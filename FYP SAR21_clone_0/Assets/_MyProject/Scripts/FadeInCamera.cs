using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DentedPixel;
using UnityEngine.UI;

public class FadeInCamera : MonoBehaviour
{
    #region Variables 
    //get canvas
    [SerializeField] private RectTransform _fadeScreenRectTransform;
// header and fade settings
    [Header("Fade Settings")]
    [SerializeField] [Range(0.1f, 9.0f)] private float _fadeInTime = 1.0f;
    [SerializeField] [Range(0.1f, 9.0f)] private float _fadeOutTime = 1.0f;
    #endregion

    // Start is called before the first frame update
    protected void Start()
    {//set timer and fade out scene
        var seq = LeanTween.sequence();
        seq.append(3f);
        seq.append( () =>{
            FadeOutCam();
        });

    }



    public void FadeOutCam()
    {//create fade out function and fade out scene
        LeanTween.alpha(_fadeScreenRectTransform, to: 0f, _fadeOutTime);
    }

}