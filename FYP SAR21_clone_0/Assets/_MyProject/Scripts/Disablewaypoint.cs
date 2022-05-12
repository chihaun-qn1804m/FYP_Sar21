using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Disablewaypoint : MonoBehaviour
{
    public GameObject B_waypoint;
    public GameObject R_waypoint;
    // Start is called before the first frame update
    void Start()
    {
        B_waypoint.SetActive(false);
        R_waypoint.SetActive(false);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
