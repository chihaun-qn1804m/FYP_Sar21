using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DentedPixel;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class FadeCamera : MonoBehaviour
{
    #region Variables 
    //get fade screen 
    [SerializeField] private RectTransform _fadeScreenRectTransform;
    //create header for fade 
    [Header("Fade Settings")]
    //fade in settings
    [SerializeField] [Range(0.1f, 9.0f)] private float _fadeInTime = 1.0f;
    //fade out settings
    [SerializeField] [Range(0.1f, 9.0f)] private float _fadeOutTime = 1.0f;
    #endregion//get gameobject canvas
    public GameObject Canvas;

    // Start is called before the first frame update
    //create an onclick function to attach
    public void onClick()
    {//set active canvas 
        Canvas.SetActive(true);
        var seq = LeanTween.sequence();
        seq.append(2f);
        seq.append(() => {
            FadeInCam();//fade in camera after 2 seconds
        });
        seq.append(3f);
        seq.append(() => {
            FadeOutCam();//fade out camera after 3 seconds
        });

    }
    public void onClickOffline()
    {//set active canvas 
        Canvas.SetActive(true);
        var seq = LeanTween.sequence();
        seq.append(2f);
        seq.append(() => {
            FadeInCam();//fade in camera after 2 seconds
        });
        seq.append(3f);
        seq.append(() => {
            FadeOutCam();//fade out camera after 3 seconds
        });

    }

    public void FadeInCam()
    {//set fade in timer
        LeanTween.alpha(_fadeScreenRectTransform, to: 1f, _fadeInTime);

    }


    public void FadeOutCam()
    {
        // show canvas and fade set fade out timer and load to next scene
        Canvas.SetActive(true);
        LeanTween.alpha(_fadeScreenRectTransform, to: 1f, _fadeOutTime);
        SceneManager.LoadScene("Lobby 2");

    }

    public void FadeOutCamOffline()
    {
        // show canvas and fade set fade out timer and load to next scene
        Canvas.SetActive(true);
        LeanTween.alpha(_fadeScreenRectTransform, to: 1f, _fadeOutTime);
        SceneManager.LoadScene("ProBuilder Lobby");

    }

    public void Fadetosetting()
    {   //set fade timer and load setting scene
        Canvas.SetActive(true);
        LeanTween.alpha(_fadeScreenRectTransform, to: 0f, _fadeOutTime);
        SceneManager.LoadScene("Setting");

    }

        public void FadetoMenu()
    {   //set fade timer and load back to memu scene
        Canvas.SetActive(true);
        LeanTween.alpha(_fadeScreenRectTransform, to: 0f, _fadeOutTime);
        SceneManager.LoadScene("Splash Menu");

    }
    public void FadetoNewMenu()
    {   //set fade timer and load back to memu scene
        Canvas.SetActive(true);
        LeanTween.alpha(_fadeScreenRectTransform, to: 0f, _fadeOutTime);
        SceneManager.LoadScene("Menu 1");

    }

}