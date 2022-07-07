using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SmokeGrenade : MonoBehaviour
{
    [SerializeField] private AudioSource audio_clip;

    public float delay = 3f;

    public Transform Pin;
    public GameObject explosionEffect;

    float countdown;
    bool hasExploded = false;

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
        audio_clip.Play();
        yield return new WaitForSeconds(30.0f); //float time in seconds
        Destroy(gameObject);
    }

}
