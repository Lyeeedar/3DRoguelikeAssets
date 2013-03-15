package com.lyeeedar.Roguelike3D;

import android.os.Bundle;

import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.backends.android.AndroidApplication;
import com.badlogic.gdx.backends.android.AndroidApplicationConfiguration;
import com.lyeeedar.Roguelike3D.Game.GameData;
import com.lyeeedar.Roguelike3D.Graphics.Lights.LightManager.LightQuality;

public class MainActivity extends AndroidApplication {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        AndroidApplicationConfiguration cfg = new AndroidApplicationConfiguration();
        cfg.useGL20 = true;
        cfg.numSamples = 16;
        
        GameData.resolution[0] = 600;
		GameData.resolution[1] = 400;
		
		GameData.lightQuality = LightQuality.FORWARD_VERTEX;
		
		GameData.game = new Roguelike3DGame();
		GameData.isAndroid = true;
		
        initialize(GameData.game, cfg);
    }
}