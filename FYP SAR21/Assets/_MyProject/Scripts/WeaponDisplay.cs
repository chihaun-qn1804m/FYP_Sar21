using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

//continuous damage due to player

public class WeaponDisplay : MonoBehaviour
{
    Animator anim;
    public GameObject Player;

    // Start is called before the first frame update
    void Start()
    {
        anim = GetComponent<Animator>();
    }

    void OnTriggerStay(Collider other) //when player stay inside the collider
    {
        anim.SetBool("isDead", true);
    }

    IEnumerator WaitForSeconds()
    {
        yield return new WaitForSecondsRealtime(1); // delay 1 seconds
    }
}
