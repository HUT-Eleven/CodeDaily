package ���ַ�ʽ��ʾ;

public class Methoddemo {

	public static void main(String[] args) {

		int[] arr = {1,1,2,0,9,3,12,7,8,3,4,65,22};

		BubbleSort_1(arr);//�������ð������
		BubbleSort_2(arr);//�Ż���
		BubbleSort_3(arr);//���Ż���
		
		//����Ϊ������
		for (int i :arr) {
			System.out.print(i+",");
		}
		
	}
	
	/**
	 * ���Ż���:
	 *������һ������1000���������飬��ǰ��100�����򣬺���900�������ź����Ҷ�����
	 *ǰ��100�����֣���ô�ڵ�һ�˱����������������λ�ñض�С��100�������λ��
	 *֮������ݱض��Ѿ������ˣ�Ҳ�������λ���Ժ�����ݲ���Ҫ�������ˣ����Ǽ�¼��
	 *��λ�ã��ڶ���ֻҪ������ͷ�����������λ�þͿ����ˡ�����Ƕ���
	 *�����ð�������㷨2��˵����ȻҲֻ����100�Σ�����
	 *ǰ���100������ÿ�ζ�Ҫ�Ժ����900�����ݽ��бȽϣ�
	 *���������ڵ������㷨3��ֻ��Ҫ��һ�αȽϺ����900�����ݣ�
	 *֮��ͻ�����β�߽磬��֤�����900�����ݲ��ٱ�����
	 * @param arr
	 */
	public static void BubbleSort_3(int[] arr) {
		
		int end = arr.length;//end��������¼�Ǳ�ģ�����һ����Ϊ��ǵ�С���á�
		
		while(end>0){
			int k=end;
			end=0;//�������������˷������е��ŵ㣬��Ϊδִ�л�λ�Ļ�����˵���Ѿ��ź����ˡ�
			for (int i = 0; i < k-1; i++) {
				if(arr[i]>arr[i+1]){
					int temp = arr[i];
					arr[i]=arr[i+1];
					arr[i+1]=temp;
					end=i;//��¼���µı߽�Ǳꡣ
				}
			}
		}
		
		
		
	}


	/**
	 * �Ż��档
	 * ���һ��ѭ����������û�з�����λ����˵���Ѿ��ź��ˣ��Ϳ���ֱ������ѭ���ˡ�
	 * @param arr
	 */

	public static void BubbleSort_2(int[] arr) {
		
		boolean flag = true;//Ҫ��1,�����
		int length = arr.length;//Ҫ��2��ԭ����ѭ����j-i-1��������û��i�ˣ�������len�Լ���
		while(flag){
			flag=false;//�ȸ�Ϊfalse
			for (int i = 0; i < length-1; i++) {
				if(arr[i]>arr[i+1]){
					int temp = arr[i];
					arr[i]=arr[i+1];
					arr[i+1]=temp;//���ִ����if��Ҳ����ִ�еĵ���λ�ã�������Ҫ��Ϊtrue
					flag=true;
				}
			}
			length--;
		}//while over
	}//method over

	public static void BubbleSort_1(int[] arr) {
		
		for (int i = 0; i < arr.length-1; i++) {
			for (int j = 0; j < arr.length-1-i; j++) {
				
				if(arr[j]>arr[j+1]){
					int temp = arr[j];
					arr[j]=arr[j+1];
					arr[j+1]=temp;
				}
			}
		}
	}

}
