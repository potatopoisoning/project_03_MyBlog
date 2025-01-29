package ezen;

public class Friend 
{
	int bno;
	int fno;
	String nickname;
	String state;
	String fdate;
	
	public Friend(){}
	
	public Friend(int bno, int fno, String nickname, String state, String fdate)
	{
		this.bno = bno;
		this.fno = fno;
		this.nickname = nickname;
		this.state = state;
		this.fdate = fdate;
	}

	public int getBno()         { return bno;      }
	public int getFno()         { return fno;      }
	public String getNickname() { return nickname; }
	public String getState()    { return state;    }
	public String getFdate()    { return fdate;    }

	public void setBno(int bno)              { this.bno = bno;           }
	public void setFno(int fno)              { this.fno = fno;           }
	public void setNickname(String nickname) { this.nickname = nickname; }
	public void setState(String state)       { this.state = state;       }
	public void setFdate(String fdate)       { this.fdate = fdate;       }
}
