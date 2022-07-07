using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class WeaponStats : MonoBehaviour
{
    public Text UIText;

    public GameObject Stats;
    public Text WeaponName;
    public Slider[] Slider;
    // Start is called before the first frame update
    void Start()
    {
        Stats.SetActive(false);
    }

    // Update is called once per frame
    void Update()
    {
        if (UIText.text == "SAR21")
        {
            Stats.SetActive(true);
            WeaponName.text = "SAR21";
            Slider[0].value = 5;
            Slider[1].value = 6;
            Slider[2].value = 4;
            Slider[3].value = 8;

        }
        else if (UIText.text == "GlockP80")
        {
            Stats.SetActive(true);
            WeaponName.text = "GlockP80";
            Slider[0].value = 4;
            Slider[1].value = 3;
            Slider[2].value = 6;
            Slider[3].value = 4;
        }
        else
        {
            Stats.SetActive(false);
        }

    }
}
