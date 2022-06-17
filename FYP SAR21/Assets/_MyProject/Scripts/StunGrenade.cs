using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StunGrenade : MonoBehaviour
{
    #region Variables 

    [SerializeField] private RectTransform _fadeScreenRectTransform;

    [Header("Fade Settings")]
    [SerializeField] [Range(0.1f, 9.0f)] private float _fadeInTime = 1.0f;
    [SerializeField] [Range(0.1f, 9.0f)] private float _fadeOutTime = 1.0f;
    #endregion
    public GameObject Canvas;

    public float delay = 3f;

    public Transform Pin;
    public GameObject explosionEffect;

    float countdown;
    bool hasExploded = false;

    private Camera cam;

    // Start is called before the first frame update
    void Start()
    {
        countdown = delay;
        cam = Camera.main;
    }

    // Update is called once per frame
    void Update()
    {
        var joint = Pin.GetComponent<FixedJoint>();
        if (!joint)
        {
            Pin.parent = null;

            countdown -= Time.deltaTime;
            if (countdown <= 0f && !hasExploded)
            {
                Explode();
                hasExploded = true;
            }
        }
    }

    private void Explode()
    {
        if (checkVisibility())
        {
            Canvas.SetActive(true);
            var seq = LeanTween.sequence();
            seq.append(3f);
            seq.append(() => {
                LeanTween.alpha(_fadeScreenRectTransform, to: 0f, _fadeOutTime);
            });
        }
        else
        {
            Debug.Log("don't get affected");
        }

        explosionEffect.transform.position = transform.position + new Vector3(0.0f, 1.0f, 0.0f);
        Instantiate(explosionEffect, explosionEffect.transform.position, transform.rotation);

        //Destroy(gameObject);
    }

    private bool checkVisibility()
    {
        var planes = GeometryUtility.CalculateFrustumPlanes(cam);
        var point = transform.position;

        foreach (var p in planes)
        {
            if (p.GetDistanceToPoint(point) > 0)
            {
                Ray ray = new Ray(cam.transform.position, transform.position - cam.transform.position);
                RaycastHit hit;
                if (Physics.Raycast(ray, out hit))
                    return hit.transform.gameObject == this.gameObject;
                else return false;
            }
            else return false;
        }

        return false;
    }

    public void FadeInCam()
    {
        LeanTween.alpha(_fadeScreenRectTransform, to: 1f, _fadeInTime);

    }

    public void FadeOutCam()
    {
        LeanTween.alpha(_fadeScreenRectTransform, to: 0f, _fadeOutTime);

    }
}