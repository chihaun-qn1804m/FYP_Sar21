using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class WeaponDisplay : MonoBehaviour
{
    Animator anim;
    public GameObject Player;

    public GameObject Rifle;
    public GameObject Pistol;

    public Text UIText;

    // Start is called before the first frame update
    void Start()
    {
        anim = GetComponent<Animator>();
    }
    
    public void OnChange()
    {
        if (UIText.text == "SAR21")
        {
            transform.localRotation = Quaternion.Euler(0, 90, 0);
            Rifle.SetActive(true);
            Pistol.SetActive(false);
            anim.SetBool("isIdle", false);
            anim.SetBool("isRifle", true);
            anim.SetBool("isPistol", false);
        }
        else if(UIText.text == "GlockP80")
        {
            transform.localRotation = Quaternion.Euler(0, 209, 0);
            Rifle.SetActive(false);
            Pistol.SetActive(true);
            anim.SetBool("isIdle", false);
            anim.SetBool("isRifle", false);
            anim.SetBool("isPistol", true);
        }
        else
        {
            transform.localRotation = Quaternion.Euler(0, 209, 0);
            Rifle.SetActive(false);
            Pistol.SetActive(false);
            anim.SetBool("isIdle", true);
            anim.SetBool("isPistol", false);
            anim.SetBool("isRifle", false);
        }
    }


}
