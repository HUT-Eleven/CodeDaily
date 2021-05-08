package com.atguigu.principle.dependencyreverse.improve;

public class DependencyPass {

	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}

}

// ��ʽ1�� ͨ���ӿڴ���ʵ������
// ���صĽӿ�
// interface IOpenAndClose {
// public void open(ITV tv); //���󷽷�,���սӿ�
// }
//
// interface ITV { //ITV�ӿ�
// public void play();
// }
//// ʵ�ֽӿ�
// class OpenAndClose implements IOpenAndClose{
// public void open(ITV tv){
// tv.play();
// }
// }

// ��ʽ2: ͨ�����췽����������
// interface IOpenAndClose {
// public void open(); //���󷽷�
// }
// interface ITV { //ITV�ӿ�
// public void play();
// }
// class OpenAndClose implements IOpenAndClose{
// public ITV tv;
// public OpenAndClose(ITV tv){
// this.tv = tv;
// }
// public void open(){
// this.tv.play();
// }
// }

// ��ʽ3 , ͨ��setter��������
interface IOpenAndClose {
	public void open(); // ���󷽷�

	public void setTv(ITV tv);
}

interface ITV { // ITV�ӿ�
	public void play();
}

class OpenAndClose implements IOpenAndClose {
	private ITV tv;

	public void setTv(ITV tv) {
		this.tv = tv;
	}

	public void open() {
		this.tv.play();
	}
}