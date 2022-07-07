 using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;


public class enemy : MonoBehaviour
{
    //Fire healthbar
    public Slider healthbar;
    public float health;

    [SerializeField] public GameObject fractured;
    [SerializeField] public AudioSource audioSource;
    

    private float tempTime;

    //opponent tag
    public GameObject powder;
    //wrong opponent tag (Water Fire Extinguisher)
    public string SAR21Bullet;
    // Powder fire extingusher damage to fire
    public const float damageTaken = 20f;
    public const float increasedamageTaken = 0.1f;
    //water Fire extinguisher damage
    public const float WrongdamageTaken = 1000f;
    //Smoke after fire extinguish
    public GameObject bloodsplash;
    //Explode after touching water
    public GameObject explode;
    //Fire
    public GameObject flame;
    //Teleport player
    public GameObject Teleport;
    public GameObject TeleportFrame;
    public GameObject LoseTeleport;
    public GameObject LoseTeleportFrame;

    public GameObject WoodFire;
    public GameObject WoodFire1;

    public GameObject pansmoke;
    private const float x = 0;
    private const float y = 0.1f;

    void lalala() {
        //Time delay after using wrong fire extinguisher
        Debug.Log("countdown to change scene");
        SceneManager.LoadScene("Lose");
    }


    void print() {
        if (healthbar.value >= 999) {
            healthbar.value = 1000;
            return;
        }
        
        healthbar.value += increasedamageTaken;
        Debug.Log("add health " + increasedamageTaken +" "+healthbar.value);
        
    }
    void OnTriggerEnter(GameObject other)
    {
        Debug.Log("Detected");

        //If fire still burning 
  
        //Extinguish fire with powder 
        if (healthbar.value > 100) {
            if (healthbar.value >= 998) {
                healthbar.value = 1000;
                Debug.Log("FULL HEALTH " + healthbar.value+" Cancel Invoke");
                CancelInvoke();
            }
            else{ 
                InvokeRepeating("print", x, y);
            }
        }

        if (other.gameObject == powder) {
            healthbar.value -= damageTaken;
            Debug.Log("deduct health " + damageTaken+" "+healthbar.value);
        }
        //Extinguish fire with water
        if (other.gameObject.tag == SAR21Bullet) {
            healthbar.value -= damageTaken;
            Debug.Log("Sar 21 Bullet Detected");
        };
        if (healthbar.value == 0 )
        {
            flame.SetActive(false);
            bloodsplash.SetActive(true);
        }
    }
    
    void Start()
    {
        Debug.Log(healthbar.value);
        Debug.Log("Set Animator <==");
        bloodsplash.SetActive(false);
        explode.SetActive(false);
        Teleport.SetActive(false);
        TeleportFrame.SetActive(false);
        LoseTeleport.SetActive(true);
        LoseTeleportFrame.SetActive(true);
    }

    void Update(){
        
        if (pansmoke.activeInHierarchy == true) {
            healthbar.value = 0;
        }
        //If fire extinguish, user able to teleport to win scene
        if (pansmoke.activeInHierarchy == true && WoodFire.activeInHierarchy == false && WoodFire1.activeInHierarchy == false)
        {
            LoseTeleport.SetActive(false);
            LoseTeleportFrame.SetActive(false);
            Teleport.SetActive(true);
            TeleportFrame.SetActive(true);
        }
        else{
            LoseTeleport.SetActive(true);
            LoseTeleportFrame.SetActive(true);
            Teleport.SetActive(false);
            TeleportFrame.SetActive(false); 
        }
    }

    public void onSave()
    {
        health = healthbar.value;
        Debug.Log("Save");
        Debug.Log(health);
        //myText.text = score.ToString();
        PlayerPrefs.SetString("json testing", JsonUtility.ToJson(this, true));
        PlayerPrefs.Save();

    }

    public void onLoad()
    {
        Debug.Log("load");
        JsonUtility.FromJsonOverwrite(PlayerPrefs.GetString("json testing"), this);
        Debug.Log(health);
        getValue();
    }

    // Update is called once per frame
    void getValue()
    {
        if (health > 10)    
        {
            bloodsplash.SetActive(false);
            flame.SetActive(true);
             
        }
        else
        {
            bloodsplash.SetActive(true);
            flame.SetActive(false);
        }
    }
}