#include "HelloImp.h"
#include "servant/Application.h"
#include "util/tc_http.h"

using namespace std;

//////////////////////////////////////////////////////
void HelloImp::initialize()
{
    //initialize servant here:
    //...

    _helloPrx = Application::getCommunicator()->stringToProxy<Demo::HelloPrx>("Demo.CppTars.HelloObj");
}

//////////////////////////////////////////////////////
void HelloImp::destroy()
{
    //destroy servant here:
    //...
}

int HelloImp::doRequest(tars::TarsCurrentPtr current, vector<char> &buffer)
{
    TC_HttpRequest request; 
    request.decode(current->getRequestBuffer());
    
    string buff;
    if(request.getRequestUrl() == "/test/ping")
    {
        buff = "pong";
    } 
    else if(request.getRequestUrl() == "/test/pingCpp")
    {
        buff = _helloPrx->ping();
    }
    else
    {
        buff = "error"; 
    }
    
    TC_HttpResponse rsp;
    rsp.setResponse(buff.c_str(), buff.size());
    rsp.encode(buffer);
    return 0;
}