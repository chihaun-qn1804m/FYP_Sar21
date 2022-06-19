using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class FragGrenade : MonoBehaviour
{
    [SerializeField] private AudioSource audio_clip;


    public float delay = 3f;
    public float radius = 5f;
    public float force = 700f;

    public float Damage = 25f;

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

    void Explode ()
    {
        Instantiate(explosionEffect, transform.position, Quaternion.identity);

        Collider[] colliders = Physics.OverlapSphere(transform.position, radius);

        foreach (Collider nearbyObject in colliders)
        {
            //Damage
            Rigidbody rb = nearbyObject.GetComponent<Rigidbody>();
            if (rb != null)
            {
                //rb.AddExplosionForce(force, transform.position, radius);
            }
        }

    }

    IEnumerator WaitAndDestroy()
    {
        audio_clip.Play();
        yield return new WaitForSeconds(1.0f); //float time in seconds
        Destroy(gameObject);
    }

}
