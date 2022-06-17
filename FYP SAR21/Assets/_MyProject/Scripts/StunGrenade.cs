using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StunGrenade : MonoBehaviour
{
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

    void Explode()
    {
        if (checkVisibility())
            Debug.Log("go blind!");
        else
            Debug.Log("don't get affected");

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
}