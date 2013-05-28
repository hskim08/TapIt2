//
//  TIAudio.m
//  TapIt
//
//  Created by Hyung-Suk Kim on 5/26/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#include "TIAudio.h"

#include "FileWvIn.h"

void audioCallback( Float32* buffer, UInt32 numFrames, void* data )
{
    ((TIAudio*)data)->handleAudio(buffer, numFrames);
}

TIAudio::TIAudio()
:_isInitialized(false)
,_isPlaying(false)
{
    
}

TIAudio::~TIAudio()
{
    
}

void TIAudio::loadAudioFile(std::string& audioFile)
{
    NSLog(@"loading audio: %s", audioFile.c_str());
    _waveReader.openFile(audioFile);
}

void TIAudio::openRecordFile( std::string& audioFile )
{
    NSLog(@"loading audio: %s", audioFile.c_str());
    _waveWriter.openFile(audioFile, 2, stk::FileWrite::FILE_WAV, stk::Stk::STK_SINT16);
}

void TIAudio::closeFiles()
{
    _waveWriter.closeFile();
    _waveReader.closeFile();
}

void TIAudio::play()
{
    _isPlaying = true;
}

void TIAudio::pause()
{
    _isPlaying = false;
}

#pragma mark - Internal calls

void TIAudio::initialize()
{
    if (_isInitialized)
        return;
    
    // initialize MoAudio
	bool result = MoAudio::init( SAMPLE_RATE, BUFFER_SIZE, NUM_CHANNELS );
    if( !result )
    {
		NSLog( @"AudioEngine::initialize() - failed to initialize MoAudio." );
		return;
	}
	
    // start MoAudio
    result = MoAudio::start( &audioCallback, this );
    if( !result )
    {
		NSLog( @"AudioEngine::initialize() - failed to start MoAudio." );
		return;
	}
	
    // set sample rate
	stk::Stk::setSampleRate( SAMPLE_RATE );
    
    _isInitialized = true;
}

void TIAudio::handleAudio(Float32* buffer, UInt32 numFrames)
{
    for (int i = 0; i < numFrames; i++) {
        
        if (_isPlaying) {
            // write audio
            _waveWriter.tick(buffer[2*i]);
            
            // play audio file
            _waveReader.tick();
            buffer[2*i] = _waveReader.lastOut(0);
            buffer[2*i + 1] = _waveReader.lastOut(1);

        }
        else {
            
            buffer[2*i] = buffer[2*i+1] = 0;
        }
    }
}