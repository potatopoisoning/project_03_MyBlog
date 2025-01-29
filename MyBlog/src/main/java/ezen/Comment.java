package ezen;

public class Comment
{
	private int cno;
	private int fno;
	private int uno;
	private String content;
	private String rdate;
	private String state;
	private String uid;
	private String uname;
	
	public Comment(){}
	
	public Comment(int cno, int fno, int uno, String content, String rdate, String state, String uid, String uname) 
	{
		this.cno = cno;
		this.fno = fno;
		this.uno = uno;
		this.content = content;
		this.rdate = rdate;
		this.state = state;
		this.uid = uid;
		this.uname = uname;
	}

	public int getCno()        { return cno;     }
	public int getFno()        { return fno;     }
	public int getUno()        { return uno;     }
	public String getContent() { return content; }
	public String getRdate()   { return rdate;   }
	public String getState()   { return state;   }
	public String getUid()     { return uid;     }
	public String getUname()   { return uname;   }
	
	public void setCno(int cno)            { this.cno = cno;         }
	public void setFno(int fno)            { this.fno = fno;         }
	public void setUno(int uno)            { this.uno = uno;         }
	public void setContent(String content) { this.content = content; }
	public void setRdate(String rdate)     { this.rdate = rdate;     }
	public void setState(String state)     { this.state = state;     }
	public void setUid(String uid)         { this.uid = uid;         }
	public void setUname(String uname)     { this.uname = uname;     }
}
