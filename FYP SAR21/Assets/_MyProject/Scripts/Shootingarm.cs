using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Shootingarm : MonoBehaviour
{
    [SerializeField]Transform hand;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    void Awake() {
        transform.SetParent(hand);
    }
}
