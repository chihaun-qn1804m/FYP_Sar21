using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SmokeGrenade : MonoBehaviour
{
    [SerializeField] private AudioSource Explode_clip;
    [SerializeField] private AudioSource Pin_clip;

    public float delay = 3f;

    public Transform Pin;
    public GameObject explosionEffect;

    float countdown;
    bool hasExploded = false;
    bool pinIsPulled = false;

    // Start is called before the first frame update
    void Start()
    {
        countdown = delay;
    }

    // Update is called once per frame
    void Update()
    {
        var joint = Pin.GetComponent<FixedJoint>();
        if (!joint)
        {
            Pin.parent = null;
            pinIsPulled = true;

            if (countdown >= 5f && pinIsPulled)
            {
                Pin_clip.Play();
                pinIsPulled = false;
            }

            countdown -= Time.deltaTime;
            if (countdown <= 0f && !hasExploded)
            {
                StartCoroutine(WaitAndDestroy());
                Explode();
                hasExploded = true;
            }
        }
    }

    private void Explode ()
    {
        Instantiate(explosionEffect, transform.position, transform.rotation);

    }

    IEnumerator WaitAndDestroy()
    {
        Explode_clip.Play();
        yield return new WaitForSeconds(30.0f); //float time in seconds
        Destroy(gameObject);
    }

}
