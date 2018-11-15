public class LetterTest {

    public static void main(String args[]) {
        //㈻(\u323b),㆙('\u3199) are not letters.
        //林(\uf9f4) is a letter.
       System.out.println(Character.isLetter('\u323b'));
       System.out.println(Character.isLetter('\uf9f4'));
       System.out.println(Character.isLetter('\u3199'));
    }
 }