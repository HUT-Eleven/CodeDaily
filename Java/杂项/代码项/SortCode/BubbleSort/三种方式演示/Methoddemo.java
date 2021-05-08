package 三种方式演示;

public class Methoddemo {

	public static void main(String[] args) {

		int[] arr = {1,1,2,0,9,3,12,7,8,3,4,65,22};

		BubbleSort_1(arr);//最基本的冒泡排序
		BubbleSort_2(arr);//优化版
		BubbleSort_3(arr);//再优化版
		
		//底下为测试码
		for (int i :arr) {
			System.out.print(i+",");
		}
		
	}
	
	/**
	 * 再优化版:
	 *假如有一个包含1000个数的数组，仅前面100个无序，后面900个都已排好序且都大于
	 *前面100个数字，那么在第一趟遍历后，最后发生交换的位置必定小于100，且这个位置
	 *之后的数据必定已经有序了，也就是这个位置以后的数据不需要再排序了，于是记录下
	 *这位置，第二次只要从数组头部遍历到这个位置就可以了。如果是对于
	 *上面的冒泡排序算法2来说，虽然也只排序100次，但是
	 *前面的100次排序每次都要对后面的900个数据进行比较，
	 *而对于现在的排序算法3，只需要有一次比较后面的900个数据，
	 *之后就会设置尾边界，保证后面的900个数据不再被排序。
	 * @param arr
	 */
	public static void BubbleSort_3(int[] arr) {
		
		int end = arr.length;//end是用来记录角标的，还有一个作为标记的小作用。
		
		while(end>0){
			int k=end;
			end=0;//这个标记是引用了方法二中的优点，意为未执行换位的话，则说明已经排好序了。
			for (int i = 0; i < k-1; i++) {
				if(arr[i]>arr[i+1]){
					int temp = arr[i];
					arr[i]=arr[i+1];
					arr[i+1]=temp;
					end=i;//记录最新的边界角标。
				}
			}
		}
		
		
		
	}


	/**
	 * 优化版。
	 * 如果一次循环下来，都没有发生换位，则说明已经排好了，就可以直接跳出循环了。
	 * @param arr
	 */

	public static void BubbleSort_2(int[] arr) {
		
		boolean flag = true;//要点1,：标记
		int length = arr.length;//要点2：原先内循环的j-i-1，但现在没有i了，所以用len自减。
		while(flag){
			flag=false;//先改为false
			for (int i = 0; i < length-1; i++) {
				if(arr[i]>arr[i+1]){
					int temp = arr[i];
					arr[i]=arr[i+1];
					arr[i+1]=temp;//如果执行了if，也就是执行的调换位置，所以需要改为true
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
