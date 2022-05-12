using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShootBullets : MonoBehaviour
{
    public GameObject bullet;

    [SerializeField] private GameObject muzzlePt;
    [SerializeField] private float bulletSpeed = 100f;
    [SerializeField] private AudioSource audioSource;
    [SerializeField] private float fireRate = 1f;
    [SerializeField] private float nextFire = 0f;

    public void OnShoot()
        {
            if(Time.time > nextFire)
            {
                nextFire = Time.time + fireRate;
                GameObject tmpBullet;
                tmpBullet = Instantiate(bullet, muzzlePt.transform.position, muzzlePt.transform.rotation);
                tmpBullet.GetComponent<Rigidbody>().AddForce(muzzlePt.transform.forward * bulletSpeed);

                //audioSource.Play(); //play handgun sound
            }

    }

}
