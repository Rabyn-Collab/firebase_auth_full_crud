class ApiPath{
  static String post(String uid, String postId) => 'userPost/$uid/posts/$postId';

  static String posts(String uid) => 'userPost/$uid/posts';


}