using UnityEngine;

namespace DuloGames.UI
{
    public class Demo_AddChatMessage : MonoBehaviour
    {
        #pragma warning disable 0649
        [SerializeField] private Demo_Chat m_Chat;
        #pragma warning restore 0649

        public void OnSendMessage(Demo_Chat.Message msg)
        {
            if (this.m_Chat != null)
            {
                this.m_Chat.ReceiveChatMessage(msg);
            }
        }
    }
}
