using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using UnityEngine.EventSystems;// Required when using Event data.

public class Hovering1 : EventTrigger// required interface when using the OnPointerEnter method.
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
    public override void OnBeginDrag(PointerEventData data)
    {
        Debug.Log("OnBeginDrag called.");
    }

    public override void OnCancel(BaseEventData data)
    {
        Debug.Log("OnCancel called.");
    }

    public override void OnDeselect(BaseEventData data)
    {
        Debug.Log("OnDeselect called.");
    }

    public override void OnDrag(PointerEventData data)
    {
        Debug.Log("OnDrag called.");
    }

    public override void OnDrop(PointerEventData data)
    {
        Debug.Log("OnDrop called.");
    }

    public override void OnEndDrag(PointerEventData data)
    {
        Debug.Log("OnEndDrag called.");
    }

    public override void OnInitializePotentialDrag(PointerEventData data)
    {
        Debug.Log("OnInitializePotentialDrag called.");
    }

    public override void OnMove(AxisEventData data)
    {
        Debug.Log("OnMove called.");
    }

    public override void OnPointerClick(PointerEventData data)
    {
        Debug.Log("OnPointerClick called.");
    }

    public override void OnPointerDown(PointerEventData data)
    {
        Debug.Log("OnPointerDown called.");
    }

    public override void OnPointerEnter(PointerEventData data)
    {
        Debug.Log("OnPointerEnter called."+data);
    }

    public override void OnPointerExit(PointerEventData data)
    {
        Debug.Log("OnPointerExit called.");
    }

    public override void OnPointerUp(PointerEventData data)
    {
        Debug.Log("OnPointerUp called.");
    }

    public override void OnScroll(PointerEventData data)
    {
        Debug.Log("OnScroll called.");
    }

    public override void OnSelect(BaseEventData data)
    {
        Debug.Log("OnSelect called.");
    }

    public override void OnSubmit(BaseEventData data)
    {
        Debug.Log("OnSubmit called.");
    }

    public override void OnUpdateSelected(BaseEventData data)
    {
        Debug.Log("OnUpdateSelected called.");
    }

}