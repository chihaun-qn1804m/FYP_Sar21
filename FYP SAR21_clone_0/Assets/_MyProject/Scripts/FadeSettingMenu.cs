using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DentedPixel;
using UnityEngine.UI;

public class FadeSettingMenu : MonoBehaviour
{
    #region Variables 

    [SerializeField] private RectTransform _fadeScreenRectTransform;

    [Header("Fade Settings")]
    [SerializeField] [Range(0.1f, 9.0f)] private float _fadeInTime = 1.0f;
    [SerializeField] [Range(0.1f, 9.0f)] private float _fadeOutTime = 1.0f;
    #endregion
    public GameObject Canvas;
    public GameObject Panel_1;
    public GameObject Panel_2;
    public GameObject playerModel;

    // Start is called before the first frame update
    public void onClick()
    {
        Canvas.SetActive(true);
        var seq = LeanTween.sequence();
        seq.append(2f);
        seq.append(() => {
            FadeInCam();
        });
        seq.append(3f);
        seq.append(() => {
            FadeOutCam();
        });

    }
    public void onClickMenu()
    {
        Canvas.SetActive(true);
        var seq = LeanTween.sequence();
        seq.append(2f);
        seq.append(() => {
            FadeInCam();
        });
        seq.append(3f);
        seq.append(() => {
            FadeOutCamMenu();
        });

    }

    public void FadeInCam()
    {
        LeanTween.alpha(_fadeScreenRectTransform, to: 1f, _fadeInTime);

    }


    public void FadeOutCam()
    {
        playerModel.SetActive(false);
        Panel_1.SetActive(false);
        Panel_2.SetActive(true);
        LeanTween.alpha(_fadeScreenRectTransform, to: 0f, _fadeOutTime);

    }
    public void FadeOutCamMenu()
    {
        playerModel.SetActive(true);
        Panel_1.SetActive(false);
        Panel_2.SetActive(true);
        LeanTween.alpha(_fadeScreenRectTransform, to: 0f, _fadeOutTime);

    }

}