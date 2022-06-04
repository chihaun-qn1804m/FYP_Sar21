using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using UnityEngine.EventSystems;// Required when using Event data.

public class Hovering : MonoBehaviour// required interface when using the OnPointerEnter method.
{
    public GameObject button1;
    public GameObject button2;
    public GameObject button3;
    public GameObject button4;


    //Do this when the cursor enters the rect area of this selectable UI object.

    void OnMouseOver()
    {
        //if (button == button1){
        ////If your mouse hovers over the GameObject with the script attached, output this message
        //    Debug.Log("Mouse is over button1");
        //}
        //if (button == button2){
        ////If your mouse hovers over the GameObject with the script attached, output this message
        //    Debug.Log("Mouse is over button2");
        //}
        //if (button == button3){
        ////If your mouse hovers over the GameObject with the script attached, output this message
        //    Debug.Log("Mouse is over button3");
        //}
        //if (button == button4){
        ////If your mouse hovers over the GameObject with the script attached, output this message
        //    Debug.Log("Mouse is over button4");
        //}
        Debug.Log("Mouse is over button1.");
    }
    void OnMouseExit()
    {
        //The mouse is no longer hovering over the GameObject so output this message each frame
        Debug.Log("Mouse is no longer on GameObject.");
    }

}