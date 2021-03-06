//
//  TIAudio.h
//  TapIt
//
//  Created by Hyung-Suk Kim on 5/26/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#ifndef __TIAUDIO_H__
#define __TIAUDIO_H__

#include <string>

#include "mo_audio.h"
#include "FileWvIn.h"
#include "FileWvOut.h"

#define SAMPLE_RATE 44100.0
#define BUFFER_SIZE 512
#define NUM_CHANNELS 2

@protocol TIAudioDelegate <NSObject>

@optional
- (void) didReachAudioEnd;
- (void) didReachCueAudioEnd;

@end

class TIAudio {
    
public:
    static TIAudio& getInstance()
    {
        static TIAudio instance;
        instance.initialize();
        return instance;
    }
    
    void loadCueFile( std::string& audioFile );
    void useCue(bool useCue) { _useCue = useCue; }
    bool isUsingCue(){ return _useCue; }
    
    void loadAudioFile( std::string& audioFile );
    void openRecordFile( std::string& audioFile );
    void closeFiles();
    
    void play();
    void pause();
    bool isPlaying() { return _isPlaying; }
    
    id<TIAudioDelegate> delegate;
    
private:
    TIAudio();
    ~TIAudio();
    
    void initialize();
    
    bool _isInitialized;
    
    stk::FileWvIn _cueReader;
    bool _useCue;
    
    stk::FileWvIn _waveReader;
    stk::FileWvOut _waveWriter;
    bool _isPlaying;
    
public: // internal callback
    void handleAudio(Float32* buffer, UInt32 numFrames);
};

#endif