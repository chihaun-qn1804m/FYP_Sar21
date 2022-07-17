using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DentedPixel;
using UnityEngine.UI;

public class SplashMenuLT : MonoBehaviour
{
    #region Variables
//get splash screen panel
    [SerializeField] private GameObject _splashScr;
    [SerializeField] private GameObject playerModel;
    [SerializeField] private GameObject gameTitle;
    //set splash screeen settings
    [Header("SplashScreen Settings")]
    [SerializeField] [Range(0.1f, 9.0f)] private float _fadeInTime = 1.0f;
    [SerializeField] [Range(0.1f, 9.0f)] private float _fadeOutTime = 1.0f;
    
    //get main menu panel
    [SerializeField] private CanvasGroup _mainMenuPanel;
    //get splash screen
    private RectTransform _splashScrRectTransform;

    #endregion

    #region Unity Methods
 
    protected void Awake()
    {
        // transform splash screen 
        _splashScr.transform.localScale = new Vector3(0f, 0f, 0f);
        //get splash screen transform values
        _splashScrRectTransform = _splashScr.GetComponent<RectTransform>();
    }

    protected void Start()
    {//set timer to fade in logo
        var seq = LeanTween.sequence();
        seq.append(_fadeInTime+2f);
        seq.append(() => {
           FadeInLogo();
        });//set timer to fade out logo
        seq.append(_fadeInTime+3f);
        seq.append(() => {
           FadeOutLogo();
        });//set timer to fade in decal and menu
        seq.append(_fadeInTime+1f);
        seq.append(() =>
        {
            ShowDecalAndMenu();
        });
    }
    #endregion

    #region Own Methods

    private void FadeInLogo()
    {//fade in logo time and scale
        LeanTween.scaleX(_splashScr, 0.7f, _fadeInTime);
        LeanTween.scaleY(_splashScr, 1f, _fadeInTime);
        LeanTween.alpha(_splashScrRectTransform, 1f, _fadeInTime);
    }

    private void FadeOutLogo()
    {//fade out logo time and scale
        LeanTween.scaleX(_splashScr, 0f, _fadeOutTime);
        LeanTween.scaleY(_splashScr, 0f, _fadeOutTime);
        LeanTween.alpha(_splashScrRectTransform, 0f, _fadeOutTime);
    }

    private void ShowDecalAndMenu()
    {//show decal and menu and timer
        gameTitle.SetActive(true);
        playerModel.SetActive(true);
        LeanTween.alphaCanvas(_mainMenuPanel, 30f, 2f);
    }
    #endregion
}