// Copyright 2016-2017 Cisco Systems Inc
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import Wme

class MediaSessionWrapper {
    
    enum Status {
        case initial, preview, prepare, running
    }
    
    enum MediaType {
        case video((local:MediaRenderView, remote:MediaRenderView)?)
        case screenShare(MediaRenderView?)
    }

    private var status: Status = .initial
    
    private let mediaSession = MediaSession()
    private var mediaSessionObserver: MediaSessionObserver?
    
    // MARK: - SDP
    func getLocalSdp() -> String {
        mediaSession.createLocalSdpOffer()
        return mediaSession.localSdpOffer
    }
    
    func setRemoteSdp(_ sdp: String) {
        mediaSession.receiveRemoteSdpAnswer(sdp)
    }
    
    var hasAudio: Bool {
        return mediaSession.mediaConstraint.hasAudio
    }
    
    var hasVideo: Bool {
        return mediaSession.mediaConstraint.hasVideo
    }
    
    var hasScreenShare: Bool {
        return mediaSession.mediaConstraint.hasScreenShare
    }
    
    // MARK: - Local View & Remote View
    var localVideoViewHeight: Int32 {
        return Int32(mediaSession.localVideoViewHeight)
    }
    
    var localVideoViewWidth: Int32 {
        return Int32(mediaSession.localVideoViewWidth)
    }
    
    var remoteVideoViewHeight: Int32 {
        return Int32(mediaSession.remoteVideoViewHeight)
    }
    
    var remoteVideoViewWidth: Int32 {
        return Int32(mediaSession.remoteVideoViewWidth)
    }
    
    var remoteScreenShareViewHeight: Int32 {
        return Int32(mediaSession.screenShareViewHeight)
    }
    
    var remoteScreenShareViewWidth: Int32 {
        return Int32(mediaSession.screenShareViewWidth)
    }
    
    var videoViews: (local:MediaRenderView,remote:MediaRenderView)? {
        if let localView = mediaSession.localVideoView, let remoteView = mediaSession.remoteVideoView {
            return (local:localView, remote:remoteView)
        }
        return nil
    }
    
    var screenShareView: MediaRenderView? {
        return mediaSession.screenShareView
    }
    
    // MARK: - Audio & Video
    var audioMuted: Bool {
        get {
            return mediaSession.audioMuted
        }
        set {
            newValue ? mediaSession.muteAudio() : mediaSession.unmuteAudio()
        }
    }
    
    var audioOutputMuted: Bool {
        get {
            return mediaSession.audioOutputMuted
        }
        set {
            newValue ? mediaSession.muteAudioOutput() : mediaSession.unmuteAudioOutput()
        }
    }
    
    var videoMuted: Bool {
        get {
            return mediaSession.videoMuted
        }
        set {
            newValue ? mediaSession.muteVideo() : mediaSession.unmuteVideo()
        }
    }
    
    var videoOutputMuted: Bool {
        get {
            return mediaSession.videoOutputMuted
        }
        set {
            newValue ? mediaSession.muteVideoOutput() : mediaSession.unmuteVideoOutput()
        }
    }
    
    var screenShareOutputMuted: Bool {
        get {
            return mediaSession.screenShareOutputMuted
        }
        set {
            newValue ? mediaSession.muteScreenShareOutput() : mediaSession.unmuteScreenShareOutput()
        }
    }
    
    // MARK: - Camera
    func setFacingMode(mode: Phone.FacingMode) {
        mediaSession.setCamrea(mode == .user)
    }
    
    func isFrontCameraSelected() -> Bool {
        return mediaSession.isFrontCameraSelected()
    }
    
    // MARK: - Loud Speaker
    func setLoudSpeaker(speaker: Bool) {
        mediaSession.setSpeaker(speaker)
    }
        
    func isSpeakerSelected() -> Bool {
        return mediaSession.isSpeakerSelected()
    }
    
    func startPreview(view: MediaRenderView, phone: Phone) -> Bool {
        if self.status == .initial {
            self.status = .preview
            mediaSession.mediaConstraint = MediaConstraint(constraint: MediaConstraintFlag.audio.rawValue | MediaConstraintFlag.video.rawValue)
            mediaSession.sendVideo = true
            mediaSession.localVideoView = view
            mediaSession.createMediaConnection()
            mediaSession.setDefaultCamera(phone.defaultFacingMode == Phone.FacingMode.user)
            mediaSession.setCamrea(phone.defaultFacingMode == Phone.FacingMode.user)
            mediaSession.setDefaultAudioOutput(phone.defaultLoudSpeaker)
            mediaSession.startLocalVideoRenderView()
            return true
        }
        return false;
    }
    
    func stopPreview() {
        if self.status == .preview {
            mediaSession.stopLocalVideoRenderView(true)
            mediaSession.localVideoView = nil
            mediaSession.sendVideo = false
            mediaSession.disconnectFromCloud()
            self.status = .initial
        }
    }
    
    // MARK: - lifecycle
    func prepare(option: MediaOption, phone: Phone) {
        if self.status == .preview {
            self.stopPreview()
        }
        if self.status == .initial {
            self.status = .prepare
            
            let mediaConfig :MediaCapabilityConfig = MediaCapabilityConfig()
            mediaConfig.audioMaxBandwidth = phone.audioMaxBandwidth
            
            if option.hasVideo && option.hasScreenShare {
                mediaConfig.videoMaxBandwidth = phone.videoMaxBandwidth
                mediaConfig.screenShareMaxBandwidth = phone.screenShareMaxBandwidth
                mediaSession.mediaConstraint = MediaConstraint(constraint: MediaConstraintFlag.audio.rawValue | MediaConstraintFlag.video.rawValue | MediaConstraintFlag.screenShare.rawValue, withCapability:mediaConfig)
                mediaSession.localVideoView = option.localVideoView
                mediaSession.remoteVideoView = option.remoteVideoView
                mediaSession.screenShareView = option.screenShareView
            }
            else if option.hasVideo {
                mediaConfig.videoMaxBandwidth = phone.videoMaxBandwidth
                mediaSession.mediaConstraint = MediaConstraint(constraint: MediaConstraintFlag.audio.rawValue | MediaConstraintFlag.video.rawValue, withCapability:mediaConfig)
                mediaSession.localVideoView = option.localVideoView
                mediaSession.remoteVideoView = option.remoteVideoView
            }
            else {
                mediaSession.mediaConstraint = MediaConstraint(constraint: MediaConstraintFlag.audio.rawValue, withCapability:mediaConfig)
            }
            mediaSession.createMediaConnection()
            mediaSession.setDefaultCamera(phone.defaultFacingMode == Phone.FacingMode.user)
            mediaSession.setDefaultAudioOutput(phone.defaultLoudSpeaker)
        }
    }
    
    func startMedia(call: Call) {
        if self.status == .prepare {
            self.status = .running
            mediaSessionObserver = MediaSessionObserver(call: call)
            mediaSessionObserver?.startObserving(mediaSession)
            mediaSession.connectToCloud()
        }
    }
    
    func stopMedia() {
        mediaSessionObserver?.stopObserving()
        mediaSession.disconnectFromCloud()
        self.status = .initial
    }
    
    func updateMedia(mediaType:MediaType) {
        guard self.status != .preview || self.status != .initial else {
            return
        }
        switch mediaType {
        case .video(let renderViews):
            mediaSession.updateSdpDirection(withLocalView: renderViews?.local, remoteView: renderViews?.remote)
            break
        case .screenShare(let renderView):
            mediaSession.updateSdpDirection(withScreenShare: renderView)
            break
        }
    }
    
    func restartAudio() {
        mediaSession.stopAudio()
        mediaSession.startAudio()
    }
    
    func joinScreenShare(_ shareId: String) {
        if mediaSession.mediaConstraint.hasScreenShare {
            mediaSession.joinScreenShare(shareId)
        }
    }
    
    func leaveScreenShare(_ shareId: String) {
        if mediaSession.mediaConstraint.hasScreenShare {
            mediaSession.leaveScreenShare(shareId)
        }
    }
}
