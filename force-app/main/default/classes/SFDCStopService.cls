public class SFDCStopService {
    public static HTTPResponse getSFDCStopBlogs(){
        
		HttpCalloutService service = new HTTPCalloutService('SFDCStopBlogs');
		//System.debug(service.getRequest());
		//System.debug(service.sendRequest().getBody());
		HTTPResponse blogsAPIResponse = service.sendRequest();
        return blogsAPIResponse;
        
    }

}