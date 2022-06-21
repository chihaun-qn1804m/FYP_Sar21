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

    public GameObject WeaponUI;
    public Text UIText;

    // Start is called before the first frame update
    void Start()
    {
        anim = GetComponent<Animator>();
        UIText = WeaponUI.GetComponent<Text>();
    }

    // Update is called once per frame
    void Update()
    {

    }


}
