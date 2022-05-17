using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;
using UnityEngine.SceneManagement;
using UnityEngine.UI;



public class muteunmute : MonoBehaviour
{
    public AudioMixer masterMixer;
    
    public GameObject volumeslider;
    public GameObject volumeslider1;
    public GameObject volumeslider2;

    public Slider volumeslidervol;
    public Slider volumeslider1vol;
    public Slider volumeslider2vol;
    public void muteToggleMasterLvl(bool muted)
    {
        if (muted) {
            volumeslidervol.value = -60f;
            volumeslider.SetActive(false);
            volumeslider1.SetActive(false);
            volumeslider2.SetActive(false);
        }
        else {
            volumeslidervol.value = 20f;
            volumeslider.SetActive(true);
            volumeslider1.SetActive(true);
            volumeslider2.SetActive(true);
        }        
    }

    public void muteToggleBGMLvl(bool muted)
    {
        if (muted) {
            volumeslider1vol.value = -60f;
            volumeslider1.SetActive(false);
        }
        else {
            volumeslider1vol.value = 20f;
            volumeslider1.SetActive(true);
        }        
    }
        public void muteToggleSFXLvl(bool muted)
    {
        if (muted) {
            volumeslider2vol.value = -60f;
            volumeslider2.SetActive(false);
        }
        else {
            volumeslider2vol.value = 20f;
            volumeslider2.SetActive(true);
        }        
    }
}