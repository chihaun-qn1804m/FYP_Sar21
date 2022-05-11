using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

using UnityEngine.Audio;

public class MixLevels : MonoBehaviour
{
    public AudioMixer masterMixer;

    //For master volume
    public void SetMasterLvl(float masterLvl)
    {
        masterMixer.SetFloat("Mastervol", masterLvl);
        
    }

    //For BGM volume
    public void SetBGMLvl(float bgmLvl)
    {
        masterMixer.SetFloat("BGMvol", bgmLvl);
    }

    //For SFX volume
    public void SetSFXLvl(float sfxLvl)
    {
        masterMixer.SetFloat("SFXvol", sfxLvl);
    }


}

