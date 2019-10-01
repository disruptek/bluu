
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2016-07-07
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for performing operations on entities like API, Product, and Subscription associated with your Azure API Management deployment.
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_596467 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_596467](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_596467): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "apimanagement"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ApisListByService_596689 = ref object of OpenApiRestCall_596467
proc url_ApisListByService_596691(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApisListByService_596690(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Lists all APIs of the API Management service instance.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/dn781423.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_596865 = path.getOrDefault("resourceGroupName")
  valid_596865 = validateParameter(valid_596865, JString, required = true,
                                 default = nil)
  if valid_596865 != nil:
    section.add "resourceGroupName", valid_596865
  var valid_596866 = path.getOrDefault("subscriptionId")
  valid_596866 = validateParameter(valid_596866, JString, required = true,
                                 default = nil)
  if valid_596866 != nil:
    section.add "subscriptionId", valid_596866
  var valid_596867 = path.getOrDefault("serviceName")
  valid_596867 = validateParameter(valid_596867, JString, required = true,
                                 default = nil)
  if valid_596867 != nil:
    section.add "serviceName", valid_596867
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | serviceUrl  | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | path        | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596868 = query.getOrDefault("api-version")
  valid_596868 = validateParameter(valid_596868, JString, required = true,
                                 default = nil)
  if valid_596868 != nil:
    section.add "api-version", valid_596868
  var valid_596869 = query.getOrDefault("$top")
  valid_596869 = validateParameter(valid_596869, JInt, required = false, default = nil)
  if valid_596869 != nil:
    section.add "$top", valid_596869
  var valid_596870 = query.getOrDefault("$skip")
  valid_596870 = validateParameter(valid_596870, JInt, required = false, default = nil)
  if valid_596870 != nil:
    section.add "$skip", valid_596870
  var valid_596871 = query.getOrDefault("$filter")
  valid_596871 = validateParameter(valid_596871, JString, required = false,
                                 default = nil)
  if valid_596871 != nil:
    section.add "$filter", valid_596871
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596894: Call_ApisListByService_596689; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all APIs of the API Management service instance.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/dn781423.aspx
  let valid = call_596894.validator(path, query, header, formData, body)
  let scheme = call_596894.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596894.url(scheme.get, call_596894.host, call_596894.base,
                         call_596894.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596894, url, valid)

proc call*(call_596965: Call_ApisListByService_596689; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## apisListByService
  ## Lists all APIs of the API Management service instance.
  ## https://msdn.microsoft.com/en-us/library/azure/dn781423.aspx
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | serviceUrl  | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | path        | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  var path_596966 = newJObject()
  var query_596968 = newJObject()
  add(path_596966, "resourceGroupName", newJString(resourceGroupName))
  add(query_596968, "api-version", newJString(apiVersion))
  add(path_596966, "subscriptionId", newJString(subscriptionId))
  add(query_596968, "$top", newJInt(Top))
  add(query_596968, "$skip", newJInt(Skip))
  add(path_596966, "serviceName", newJString(serviceName))
  add(query_596968, "$filter", newJString(Filter))
  result = call_596965.call(path_596966, query_596968, nil, nil, nil)

var apisListByService* = Call_ApisListByService_596689(name: "apisListByService",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis",
    validator: validate_ApisListByService_596690, base: "",
    url: url_ApisListByService_596691, schemes: {Scheme.Https})
type
  Call_ApisCreateOrUpdate_597019 = ref object of OpenApiRestCall_596467
proc url_ApisCreateOrUpdate_597021(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApisCreateOrUpdate_597020(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Creates new or updates existing specified API of the API Management service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597049 = path.getOrDefault("resourceGroupName")
  valid_597049 = validateParameter(valid_597049, JString, required = true,
                                 default = nil)
  if valid_597049 != nil:
    section.add "resourceGroupName", valid_597049
  var valid_597050 = path.getOrDefault("apiId")
  valid_597050 = validateParameter(valid_597050, JString, required = true,
                                 default = nil)
  if valid_597050 != nil:
    section.add "apiId", valid_597050
  var valid_597051 = path.getOrDefault("subscriptionId")
  valid_597051 = validateParameter(valid_597051, JString, required = true,
                                 default = nil)
  if valid_597051 != nil:
    section.add "subscriptionId", valid_597051
  var valid_597052 = path.getOrDefault("serviceName")
  valid_597052 = validateParameter(valid_597052, JString, required = true,
                                 default = nil)
  if valid_597052 != nil:
    section.add "serviceName", valid_597052
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597053 = query.getOrDefault("api-version")
  valid_597053 = validateParameter(valid_597053, JString, required = true,
                                 default = nil)
  if valid_597053 != nil:
    section.add "api-version", valid_597053
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Api Entity. For Create Api Etag should not be specified. For Update Etag should match the existing Entity or it can be * for unconditional update.
  section = newJObject()
  var valid_597054 = header.getOrDefault("If-Match")
  valid_597054 = validateParameter(valid_597054, JString, required = false,
                                 default = nil)
  if valid_597054 != nil:
    section.add "If-Match", valid_597054
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Create or update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597056: Call_ApisCreateOrUpdate_597019; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates new or updates existing specified API of the API Management service instance.
  ## 
  let valid = call_597056.validator(path, query, header, formData, body)
  let scheme = call_597056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597056.url(scheme.get, call_597056.host, call_597056.base,
                         call_597056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597056, url, valid)

proc call*(call_597057: Call_ApisCreateOrUpdate_597019; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## apisCreateOrUpdate
  ## Creates new or updates existing specified API of the API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Create or update parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597058 = newJObject()
  var query_597059 = newJObject()
  var body_597060 = newJObject()
  add(path_597058, "resourceGroupName", newJString(resourceGroupName))
  add(query_597059, "api-version", newJString(apiVersion))
  add(path_597058, "apiId", newJString(apiId))
  add(path_597058, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597060 = parameters
  add(path_597058, "serviceName", newJString(serviceName))
  result = call_597057.call(path_597058, query_597059, nil, nil, body_597060)

var apisCreateOrUpdate* = Call_ApisCreateOrUpdate_597019(
    name: "apisCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}",
    validator: validate_ApisCreateOrUpdate_597020, base: "",
    url: url_ApisCreateOrUpdate_597021, schemes: {Scheme.Https})
type
  Call_ApisGet_597007 = ref object of OpenApiRestCall_596467
proc url_ApisGet_597009(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApisGet_597008(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597010 = path.getOrDefault("resourceGroupName")
  valid_597010 = validateParameter(valid_597010, JString, required = true,
                                 default = nil)
  if valid_597010 != nil:
    section.add "resourceGroupName", valid_597010
  var valid_597011 = path.getOrDefault("apiId")
  valid_597011 = validateParameter(valid_597011, JString, required = true,
                                 default = nil)
  if valid_597011 != nil:
    section.add "apiId", valid_597011
  var valid_597012 = path.getOrDefault("subscriptionId")
  valid_597012 = validateParameter(valid_597012, JString, required = true,
                                 default = nil)
  if valid_597012 != nil:
    section.add "subscriptionId", valid_597012
  var valid_597013 = path.getOrDefault("serviceName")
  valid_597013 = validateParameter(valid_597013, JString, required = true,
                                 default = nil)
  if valid_597013 != nil:
    section.add "serviceName", valid_597013
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597014 = query.getOrDefault("api-version")
  valid_597014 = validateParameter(valid_597014, JString, required = true,
                                 default = nil)
  if valid_597014 != nil:
    section.add "api-version", valid_597014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597015: Call_ApisGet_597007; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the API specified by its identifier.
  ## 
  let valid = call_597015.validator(path, query, header, formData, body)
  let scheme = call_597015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597015.url(scheme.get, call_597015.host, call_597015.base,
                         call_597015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597015, url, valid)

proc call*(call_597016: Call_ApisGet_597007; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## apisGet
  ## Gets the details of the API specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597017 = newJObject()
  var query_597018 = newJObject()
  add(path_597017, "resourceGroupName", newJString(resourceGroupName))
  add(query_597018, "api-version", newJString(apiVersion))
  add(path_597017, "apiId", newJString(apiId))
  add(path_597017, "subscriptionId", newJString(subscriptionId))
  add(path_597017, "serviceName", newJString(serviceName))
  result = call_597016.call(path_597017, query_597018, nil, nil, nil)

var apisGet* = Call_ApisGet_597007(name: "apisGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}",
                                validator: validate_ApisGet_597008, base: "",
                                url: url_ApisGet_597009, schemes: {Scheme.Https})
type
  Call_ApisUpdate_597074 = ref object of OpenApiRestCall_596467
proc url_ApisUpdate_597076(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApisUpdate_597075(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified API of the API Management service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597077 = path.getOrDefault("resourceGroupName")
  valid_597077 = validateParameter(valid_597077, JString, required = true,
                                 default = nil)
  if valid_597077 != nil:
    section.add "resourceGroupName", valid_597077
  var valid_597078 = path.getOrDefault("apiId")
  valid_597078 = validateParameter(valid_597078, JString, required = true,
                                 default = nil)
  if valid_597078 != nil:
    section.add "apiId", valid_597078
  var valid_597079 = path.getOrDefault("subscriptionId")
  valid_597079 = validateParameter(valid_597079, JString, required = true,
                                 default = nil)
  if valid_597079 != nil:
    section.add "subscriptionId", valid_597079
  var valid_597080 = path.getOrDefault("serviceName")
  valid_597080 = validateParameter(valid_597080, JString, required = true,
                                 default = nil)
  if valid_597080 != nil:
    section.add "serviceName", valid_597080
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597081 = query.getOrDefault("api-version")
  valid_597081 = validateParameter(valid_597081, JString, required = true,
                                 default = nil)
  if valid_597081 != nil:
    section.add "api-version", valid_597081
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the API entity. ETag should match the current entity state in the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597082 = header.getOrDefault("If-Match")
  valid_597082 = validateParameter(valid_597082, JString, required = true,
                                 default = nil)
  if valid_597082 != nil:
    section.add "If-Match", valid_597082
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Patch parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597084: Call_ApisUpdate_597074; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified API of the API Management service instance.
  ## 
  let valid = call_597084.validator(path, query, header, formData, body)
  let scheme = call_597084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597084.url(scheme.get, call_597084.host, call_597084.base,
                         call_597084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597084, url, valid)

proc call*(call_597085: Call_ApisUpdate_597074; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## apisUpdate
  ## Updates the specified API of the API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Patch parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597086 = newJObject()
  var query_597087 = newJObject()
  var body_597088 = newJObject()
  add(path_597086, "resourceGroupName", newJString(resourceGroupName))
  add(query_597087, "api-version", newJString(apiVersion))
  add(path_597086, "apiId", newJString(apiId))
  add(path_597086, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597088 = parameters
  add(path_597086, "serviceName", newJString(serviceName))
  result = call_597085.call(path_597086, query_597087, nil, nil, body_597088)

var apisUpdate* = Call_ApisUpdate_597074(name: "apisUpdate",
                                      meth: HttpMethod.HttpPatch,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}",
                                      validator: validate_ApisUpdate_597075,
                                      base: "", url: url_ApisUpdate_597076,
                                      schemes: {Scheme.Https})
type
  Call_ApisDelete_597061 = ref object of OpenApiRestCall_596467
proc url_ApisDelete_597063(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApisDelete_597062(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified API of the API Management service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597064 = path.getOrDefault("resourceGroupName")
  valid_597064 = validateParameter(valid_597064, JString, required = true,
                                 default = nil)
  if valid_597064 != nil:
    section.add "resourceGroupName", valid_597064
  var valid_597065 = path.getOrDefault("apiId")
  valid_597065 = validateParameter(valid_597065, JString, required = true,
                                 default = nil)
  if valid_597065 != nil:
    section.add "apiId", valid_597065
  var valid_597066 = path.getOrDefault("subscriptionId")
  valid_597066 = validateParameter(valid_597066, JString, required = true,
                                 default = nil)
  if valid_597066 != nil:
    section.add "subscriptionId", valid_597066
  var valid_597067 = path.getOrDefault("serviceName")
  valid_597067 = validateParameter(valid_597067, JString, required = true,
                                 default = nil)
  if valid_597067 != nil:
    section.add "serviceName", valid_597067
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597068 = query.getOrDefault("api-version")
  valid_597068 = validateParameter(valid_597068, JString, required = true,
                                 default = nil)
  if valid_597068 != nil:
    section.add "api-version", valid_597068
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the API Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597069 = header.getOrDefault("If-Match")
  valid_597069 = validateParameter(valid_597069, JString, required = true,
                                 default = nil)
  if valid_597069 != nil:
    section.add "If-Match", valid_597069
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597070: Call_ApisDelete_597061; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified API of the API Management service instance.
  ## 
  let valid = call_597070.validator(path, query, header, formData, body)
  let scheme = call_597070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597070.url(scheme.get, call_597070.host, call_597070.base,
                         call_597070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597070, url, valid)

proc call*(call_597071: Call_ApisDelete_597061; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## apisDelete
  ## Deletes the specified API of the API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597072 = newJObject()
  var query_597073 = newJObject()
  add(path_597072, "resourceGroupName", newJString(resourceGroupName))
  add(query_597073, "api-version", newJString(apiVersion))
  add(path_597072, "apiId", newJString(apiId))
  add(path_597072, "subscriptionId", newJString(subscriptionId))
  add(path_597072, "serviceName", newJString(serviceName))
  result = call_597071.call(path_597072, query_597073, nil, nil, nil)

var apisDelete* = Call_ApisDelete_597061(name: "apisDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}",
                                      validator: validate_ApisDelete_597062,
                                      base: "", url: url_ApisDelete_597063,
                                      schemes: {Scheme.Https})
type
  Call_ApiOperationsListByApi_597089 = ref object of OpenApiRestCall_596467
proc url_ApiOperationsListByApi_597091(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiOperationsListByApi_597090(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of the operations for the specified API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597092 = path.getOrDefault("resourceGroupName")
  valid_597092 = validateParameter(valid_597092, JString, required = true,
                                 default = nil)
  if valid_597092 != nil:
    section.add "resourceGroupName", valid_597092
  var valid_597093 = path.getOrDefault("apiId")
  valid_597093 = validateParameter(valid_597093, JString, required = true,
                                 default = nil)
  if valid_597093 != nil:
    section.add "apiId", valid_597093
  var valid_597094 = path.getOrDefault("subscriptionId")
  valid_597094 = validateParameter(valid_597094, JString, required = true,
                                 default = nil)
  if valid_597094 != nil:
    section.add "subscriptionId", valid_597094
  var valid_597095 = path.getOrDefault("serviceName")
  valid_597095 = validateParameter(valid_597095, JString, required = true,
                                 default = nil)
  if valid_597095 != nil:
    section.add "serviceName", valid_597095
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## | name        | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | method      | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | urlTemplate | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597096 = query.getOrDefault("api-version")
  valid_597096 = validateParameter(valid_597096, JString, required = true,
                                 default = nil)
  if valid_597096 != nil:
    section.add "api-version", valid_597096
  var valid_597097 = query.getOrDefault("$top")
  valid_597097 = validateParameter(valid_597097, JInt, required = false, default = nil)
  if valid_597097 != nil:
    section.add "$top", valid_597097
  var valid_597098 = query.getOrDefault("$skip")
  valid_597098 = validateParameter(valid_597098, JInt, required = false, default = nil)
  if valid_597098 != nil:
    section.add "$skip", valid_597098
  var valid_597099 = query.getOrDefault("$filter")
  valid_597099 = validateParameter(valid_597099, JString, required = false,
                                 default = nil)
  if valid_597099 != nil:
    section.add "$filter", valid_597099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597100: Call_ApiOperationsListByApi_597089; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of the operations for the specified API.
  ## 
  let valid = call_597100.validator(path, query, header, formData, body)
  let scheme = call_597100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597100.url(scheme.get, call_597100.host, call_597100.base,
                         call_597100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597100, url, valid)

proc call*(call_597101: Call_ApiOperationsListByApi_597089;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; Top: int = 0; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## apiOperationsListByApi
  ## Lists a collection of the operations for the specified API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## | name        | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | method      | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | urlTemplate | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  var path_597102 = newJObject()
  var query_597103 = newJObject()
  add(path_597102, "resourceGroupName", newJString(resourceGroupName))
  add(query_597103, "api-version", newJString(apiVersion))
  add(path_597102, "apiId", newJString(apiId))
  add(path_597102, "subscriptionId", newJString(subscriptionId))
  add(query_597103, "$top", newJInt(Top))
  add(query_597103, "$skip", newJInt(Skip))
  add(path_597102, "serviceName", newJString(serviceName))
  add(query_597103, "$filter", newJString(Filter))
  result = call_597101.call(path_597102, query_597103, nil, nil, nil)

var apiOperationsListByApi* = Call_ApiOperationsListByApi_597089(
    name: "apiOperationsListByApi", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations",
    validator: validate_ApiOperationsListByApi_597090, base: "",
    url: url_ApiOperationsListByApi_597091, schemes: {Scheme.Https})
type
  Call_ApiOperationsCreateOrUpdate_597117 = ref object of OpenApiRestCall_596467
proc url_ApiOperationsCreateOrUpdate_597119(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiOperationsCreateOrUpdate_597118(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new API operation or updates an existing one.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597120 = path.getOrDefault("resourceGroupName")
  valid_597120 = validateParameter(valid_597120, JString, required = true,
                                 default = nil)
  if valid_597120 != nil:
    section.add "resourceGroupName", valid_597120
  var valid_597121 = path.getOrDefault("apiId")
  valid_597121 = validateParameter(valid_597121, JString, required = true,
                                 default = nil)
  if valid_597121 != nil:
    section.add "apiId", valid_597121
  var valid_597122 = path.getOrDefault("subscriptionId")
  valid_597122 = validateParameter(valid_597122, JString, required = true,
                                 default = nil)
  if valid_597122 != nil:
    section.add "subscriptionId", valid_597122
  var valid_597123 = path.getOrDefault("serviceName")
  valid_597123 = validateParameter(valid_597123, JString, required = true,
                                 default = nil)
  if valid_597123 != nil:
    section.add "serviceName", valid_597123
  var valid_597124 = path.getOrDefault("operationId")
  valid_597124 = validateParameter(valid_597124, JString, required = true,
                                 default = nil)
  if valid_597124 != nil:
    section.add "operationId", valid_597124
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597125 = query.getOrDefault("api-version")
  valid_597125 = validateParameter(valid_597125, JString, required = true,
                                 default = nil)
  if valid_597125 != nil:
    section.add "api-version", valid_597125
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Create parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597127: Call_ApiOperationsCreateOrUpdate_597117; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new API operation or updates an existing one.
  ## 
  let valid = call_597127.validator(path, query, header, formData, body)
  let scheme = call_597127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597127.url(scheme.get, call_597127.host, call_597127.base,
                         call_597127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597127, url, valid)

proc call*(call_597128: Call_ApiOperationsCreateOrUpdate_597117;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; parameters: JsonNode; serviceName: string;
          operationId: string): Recallable =
  ## apiOperationsCreateOrUpdate
  ## Creates a new API operation or updates an existing one.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_597129 = newJObject()
  var query_597130 = newJObject()
  var body_597131 = newJObject()
  add(path_597129, "resourceGroupName", newJString(resourceGroupName))
  add(query_597130, "api-version", newJString(apiVersion))
  add(path_597129, "apiId", newJString(apiId))
  add(path_597129, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597131 = parameters
  add(path_597129, "serviceName", newJString(serviceName))
  add(path_597129, "operationId", newJString(operationId))
  result = call_597128.call(path_597129, query_597130, nil, nil, body_597131)

var apiOperationsCreateOrUpdate* = Call_ApiOperationsCreateOrUpdate_597117(
    name: "apiOperationsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}",
    validator: validate_ApiOperationsCreateOrUpdate_597118, base: "",
    url: url_ApiOperationsCreateOrUpdate_597119, schemes: {Scheme.Https})
type
  Call_ApiOperationsGet_597104 = ref object of OpenApiRestCall_596467
proc url_ApiOperationsGet_597106(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiOperationsGet_597105(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets the details of the API Operation specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597107 = path.getOrDefault("resourceGroupName")
  valid_597107 = validateParameter(valid_597107, JString, required = true,
                                 default = nil)
  if valid_597107 != nil:
    section.add "resourceGroupName", valid_597107
  var valid_597108 = path.getOrDefault("apiId")
  valid_597108 = validateParameter(valid_597108, JString, required = true,
                                 default = nil)
  if valid_597108 != nil:
    section.add "apiId", valid_597108
  var valid_597109 = path.getOrDefault("subscriptionId")
  valid_597109 = validateParameter(valid_597109, JString, required = true,
                                 default = nil)
  if valid_597109 != nil:
    section.add "subscriptionId", valid_597109
  var valid_597110 = path.getOrDefault("serviceName")
  valid_597110 = validateParameter(valid_597110, JString, required = true,
                                 default = nil)
  if valid_597110 != nil:
    section.add "serviceName", valid_597110
  var valid_597111 = path.getOrDefault("operationId")
  valid_597111 = validateParameter(valid_597111, JString, required = true,
                                 default = nil)
  if valid_597111 != nil:
    section.add "operationId", valid_597111
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597112 = query.getOrDefault("api-version")
  valid_597112 = validateParameter(valid_597112, JString, required = true,
                                 default = nil)
  if valid_597112 != nil:
    section.add "api-version", valid_597112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597113: Call_ApiOperationsGet_597104; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the API Operation specified by its identifier.
  ## 
  let valid = call_597113.validator(path, query, header, formData, body)
  let scheme = call_597113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597113.url(scheme.get, call_597113.host, call_597113.base,
                         call_597113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597113, url, valid)

proc call*(call_597114: Call_ApiOperationsGet_597104; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          serviceName: string; operationId: string): Recallable =
  ## apiOperationsGet
  ## Gets the details of the API Operation specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_597115 = newJObject()
  var query_597116 = newJObject()
  add(path_597115, "resourceGroupName", newJString(resourceGroupName))
  add(query_597116, "api-version", newJString(apiVersion))
  add(path_597115, "apiId", newJString(apiId))
  add(path_597115, "subscriptionId", newJString(subscriptionId))
  add(path_597115, "serviceName", newJString(serviceName))
  add(path_597115, "operationId", newJString(operationId))
  result = call_597114.call(path_597115, query_597116, nil, nil, nil)

var apiOperationsGet* = Call_ApiOperationsGet_597104(name: "apiOperationsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}",
    validator: validate_ApiOperationsGet_597105, base: "",
    url: url_ApiOperationsGet_597106, schemes: {Scheme.Https})
type
  Call_ApiOperationsUpdate_597146 = ref object of OpenApiRestCall_596467
proc url_ApiOperationsUpdate_597148(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiOperationsUpdate_597147(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates the details of the operation specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597149 = path.getOrDefault("resourceGroupName")
  valid_597149 = validateParameter(valid_597149, JString, required = true,
                                 default = nil)
  if valid_597149 != nil:
    section.add "resourceGroupName", valid_597149
  var valid_597150 = path.getOrDefault("apiId")
  valid_597150 = validateParameter(valid_597150, JString, required = true,
                                 default = nil)
  if valid_597150 != nil:
    section.add "apiId", valid_597150
  var valid_597151 = path.getOrDefault("subscriptionId")
  valid_597151 = validateParameter(valid_597151, JString, required = true,
                                 default = nil)
  if valid_597151 != nil:
    section.add "subscriptionId", valid_597151
  var valid_597152 = path.getOrDefault("serviceName")
  valid_597152 = validateParameter(valid_597152, JString, required = true,
                                 default = nil)
  if valid_597152 != nil:
    section.add "serviceName", valid_597152
  var valid_597153 = path.getOrDefault("operationId")
  valid_597153 = validateParameter(valid_597153, JString, required = true,
                                 default = nil)
  if valid_597153 != nil:
    section.add "operationId", valid_597153
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597154 = query.getOrDefault("api-version")
  valid_597154 = validateParameter(valid_597154, JString, required = true,
                                 default = nil)
  if valid_597154 != nil:
    section.add "api-version", valid_597154
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the API Operation Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597155 = header.getOrDefault("If-Match")
  valid_597155 = validateParameter(valid_597155, JString, required = true,
                                 default = nil)
  if valid_597155 != nil:
    section.add "If-Match", valid_597155
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597157: Call_ApiOperationsUpdate_597146; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of the operation specified by its identifier.
  ## 
  let valid = call_597157.validator(path, query, header, formData, body)
  let scheme = call_597157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597157.url(scheme.get, call_597157.host, call_597157.base,
                         call_597157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597157, url, valid)

proc call*(call_597158: Call_ApiOperationsUpdate_597146; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string; operationId: string): Recallable =
  ## apiOperationsUpdate
  ## Updates the details of the operation specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Update parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_597159 = newJObject()
  var query_597160 = newJObject()
  var body_597161 = newJObject()
  add(path_597159, "resourceGroupName", newJString(resourceGroupName))
  add(query_597160, "api-version", newJString(apiVersion))
  add(path_597159, "apiId", newJString(apiId))
  add(path_597159, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597161 = parameters
  add(path_597159, "serviceName", newJString(serviceName))
  add(path_597159, "operationId", newJString(operationId))
  result = call_597158.call(path_597159, query_597160, nil, nil, body_597161)

var apiOperationsUpdate* = Call_ApiOperationsUpdate_597146(
    name: "apiOperationsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}",
    validator: validate_ApiOperationsUpdate_597147, base: "",
    url: url_ApiOperationsUpdate_597148, schemes: {Scheme.Https})
type
  Call_ApiOperationsDelete_597132 = ref object of OpenApiRestCall_596467
proc url_ApiOperationsDelete_597134(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiOperationsDelete_597133(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes the specified operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597135 = path.getOrDefault("resourceGroupName")
  valid_597135 = validateParameter(valid_597135, JString, required = true,
                                 default = nil)
  if valid_597135 != nil:
    section.add "resourceGroupName", valid_597135
  var valid_597136 = path.getOrDefault("apiId")
  valid_597136 = validateParameter(valid_597136, JString, required = true,
                                 default = nil)
  if valid_597136 != nil:
    section.add "apiId", valid_597136
  var valid_597137 = path.getOrDefault("subscriptionId")
  valid_597137 = validateParameter(valid_597137, JString, required = true,
                                 default = nil)
  if valid_597137 != nil:
    section.add "subscriptionId", valid_597137
  var valid_597138 = path.getOrDefault("serviceName")
  valid_597138 = validateParameter(valid_597138, JString, required = true,
                                 default = nil)
  if valid_597138 != nil:
    section.add "serviceName", valid_597138
  var valid_597139 = path.getOrDefault("operationId")
  valid_597139 = validateParameter(valid_597139, JString, required = true,
                                 default = nil)
  if valid_597139 != nil:
    section.add "operationId", valid_597139
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597140 = query.getOrDefault("api-version")
  valid_597140 = validateParameter(valid_597140, JString, required = true,
                                 default = nil)
  if valid_597140 != nil:
    section.add "api-version", valid_597140
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the API Operation Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597141 = header.getOrDefault("If-Match")
  valid_597141 = validateParameter(valid_597141, JString, required = true,
                                 default = nil)
  if valid_597141 != nil:
    section.add "If-Match", valid_597141
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597142: Call_ApiOperationsDelete_597132; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified operation.
  ## 
  let valid = call_597142.validator(path, query, header, formData, body)
  let scheme = call_597142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597142.url(scheme.get, call_597142.host, call_597142.base,
                         call_597142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597142, url, valid)

proc call*(call_597143: Call_ApiOperationsDelete_597132; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          serviceName: string; operationId: string): Recallable =
  ## apiOperationsDelete
  ## Deletes the specified operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_597144 = newJObject()
  var query_597145 = newJObject()
  add(path_597144, "resourceGroupName", newJString(resourceGroupName))
  add(query_597145, "api-version", newJString(apiVersion))
  add(path_597144, "apiId", newJString(apiId))
  add(path_597144, "subscriptionId", newJString(subscriptionId))
  add(path_597144, "serviceName", newJString(serviceName))
  add(path_597144, "operationId", newJString(operationId))
  result = call_597143.call(path_597144, query_597145, nil, nil, nil)

var apiOperationsDelete* = Call_ApiOperationsDelete_597132(
    name: "apiOperationsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}",
    validator: validate_ApiOperationsDelete_597133, base: "",
    url: url_ApiOperationsDelete_597134, schemes: {Scheme.Https})
type
  Call_ApiProductsListByApi_597162 = ref object of OpenApiRestCall_596467
proc url_ApiProductsListByApi_597164(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/products")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiProductsListByApi_597163(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all API associated products.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597165 = path.getOrDefault("resourceGroupName")
  valid_597165 = validateParameter(valid_597165, JString, required = true,
                                 default = nil)
  if valid_597165 != nil:
    section.add "resourceGroupName", valid_597165
  var valid_597166 = path.getOrDefault("apiId")
  valid_597166 = validateParameter(valid_597166, JString, required = true,
                                 default = nil)
  if valid_597166 != nil:
    section.add "apiId", valid_597166
  var valid_597167 = path.getOrDefault("subscriptionId")
  valid_597167 = validateParameter(valid_597167, JString, required = true,
                                 default = nil)
  if valid_597167 != nil:
    section.add "subscriptionId", valid_597167
  var valid_597168 = path.getOrDefault("serviceName")
  valid_597168 = validateParameter(valid_597168, JString, required = true,
                                 default = nil)
  if valid_597168 != nil:
    section.add "serviceName", valid_597168
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field | Supported operators    | Supported functions                         |
  ## 
  ## |-------|------------------------|---------------------------------------------|
  ## | name  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597169 = query.getOrDefault("api-version")
  valid_597169 = validateParameter(valid_597169, JString, required = true,
                                 default = nil)
  if valid_597169 != nil:
    section.add "api-version", valid_597169
  var valid_597170 = query.getOrDefault("$top")
  valid_597170 = validateParameter(valid_597170, JInt, required = false, default = nil)
  if valid_597170 != nil:
    section.add "$top", valid_597170
  var valid_597171 = query.getOrDefault("$skip")
  valid_597171 = validateParameter(valid_597171, JInt, required = false, default = nil)
  if valid_597171 != nil:
    section.add "$skip", valid_597171
  var valid_597172 = query.getOrDefault("$filter")
  valid_597172 = validateParameter(valid_597172, JString, required = false,
                                 default = nil)
  if valid_597172 != nil:
    section.add "$filter", valid_597172
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597173: Call_ApiProductsListByApi_597162; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all API associated products.
  ## 
  let valid = call_597173.validator(path, query, header, formData, body)
  let scheme = call_597173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597173.url(scheme.get, call_597173.host, call_597173.base,
                         call_597173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597173, url, valid)

proc call*(call_597174: Call_ApiProductsListByApi_597162;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; Top: int = 0; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## apiProductsListByApi
  ## Lists all API associated products.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field | Supported operators    | Supported functions                         |
  ## 
  ## |-------|------------------------|---------------------------------------------|
  ## | name  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  var path_597175 = newJObject()
  var query_597176 = newJObject()
  add(path_597175, "resourceGroupName", newJString(resourceGroupName))
  add(query_597176, "api-version", newJString(apiVersion))
  add(path_597175, "apiId", newJString(apiId))
  add(path_597175, "subscriptionId", newJString(subscriptionId))
  add(query_597176, "$top", newJInt(Top))
  add(query_597176, "$skip", newJInt(Skip))
  add(path_597175, "serviceName", newJString(serviceName))
  add(query_597176, "$filter", newJString(Filter))
  result = call_597174.call(path_597175, query_597176, nil, nil, nil)

var apiProductsListByApi* = Call_ApiProductsListByApi_597162(
    name: "apiProductsListByApi", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/products",
    validator: validate_ApiProductsListByApi_597163, base: "",
    url: url_ApiProductsListByApi_597164, schemes: {Scheme.Https})
type
  Call_AuthorizationServersListByService_597177 = ref object of OpenApiRestCall_596467
proc url_AuthorizationServersListByService_597179(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/authorizationServers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AuthorizationServersListByService_597178(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of authorization servers defined within a service instance.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/dn879064.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597180 = path.getOrDefault("resourceGroupName")
  valid_597180 = validateParameter(valid_597180, JString, required = true,
                                 default = nil)
  if valid_597180 != nil:
    section.add "resourceGroupName", valid_597180
  var valid_597181 = path.getOrDefault("subscriptionId")
  valid_597181 = validateParameter(valid_597181, JString, required = true,
                                 default = nil)
  if valid_597181 != nil:
    section.add "subscriptionId", valid_597181
  var valid_597182 = path.getOrDefault("serviceName")
  valid_597182 = validateParameter(valid_597182, JString, required = true,
                                 default = nil)
  if valid_597182 != nil:
    section.add "serviceName", valid_597182
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field | Supported operators    | Supported functions                         |
  ## 
  ## |-------|------------------------|---------------------------------------------|
  ## | id    | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597183 = query.getOrDefault("api-version")
  valid_597183 = validateParameter(valid_597183, JString, required = true,
                                 default = nil)
  if valid_597183 != nil:
    section.add "api-version", valid_597183
  var valid_597184 = query.getOrDefault("$top")
  valid_597184 = validateParameter(valid_597184, JInt, required = false, default = nil)
  if valid_597184 != nil:
    section.add "$top", valid_597184
  var valid_597185 = query.getOrDefault("$skip")
  valid_597185 = validateParameter(valid_597185, JInt, required = false, default = nil)
  if valid_597185 != nil:
    section.add "$skip", valid_597185
  var valid_597186 = query.getOrDefault("$filter")
  valid_597186 = validateParameter(valid_597186, JString, required = false,
                                 default = nil)
  if valid_597186 != nil:
    section.add "$filter", valid_597186
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597187: Call_AuthorizationServersListByService_597177;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists a collection of authorization servers defined within a service instance.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/dn879064.aspx
  let valid = call_597187.validator(path, query, header, formData, body)
  let scheme = call_597187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597187.url(scheme.get, call_597187.host, call_597187.base,
                         call_597187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597187, url, valid)

proc call*(call_597188: Call_AuthorizationServersListByService_597177;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## authorizationServersListByService
  ## Lists a collection of authorization servers defined within a service instance.
  ## https://msdn.microsoft.com/en-us/library/azure/dn879064.aspx
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field | Supported operators    | Supported functions                         |
  ## 
  ## |-------|------------------------|---------------------------------------------|
  ## | id    | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  var path_597189 = newJObject()
  var query_597190 = newJObject()
  add(path_597189, "resourceGroupName", newJString(resourceGroupName))
  add(query_597190, "api-version", newJString(apiVersion))
  add(path_597189, "subscriptionId", newJString(subscriptionId))
  add(query_597190, "$top", newJInt(Top))
  add(query_597190, "$skip", newJInt(Skip))
  add(path_597189, "serviceName", newJString(serviceName))
  add(query_597190, "$filter", newJString(Filter))
  result = call_597188.call(path_597189, query_597190, nil, nil, nil)

var authorizationServersListByService* = Call_AuthorizationServersListByService_597177(
    name: "authorizationServersListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/authorizationServers",
    validator: validate_AuthorizationServersListByService_597178, base: "",
    url: url_AuthorizationServersListByService_597179, schemes: {Scheme.Https})
type
  Call_AuthorizationServersCreateOrUpdate_597203 = ref object of OpenApiRestCall_596467
proc url_AuthorizationServersCreateOrUpdate_597205(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "authsid" in path, "`authsid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/authorizationServers/"),
               (kind: VariableSegment, value: "authsid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AuthorizationServersCreateOrUpdate_597204(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates new authorization server or updates an existing authorization server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   authsid: JString (required)
  ##          : Identifier of the authorization server.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597206 = path.getOrDefault("resourceGroupName")
  valid_597206 = validateParameter(valid_597206, JString, required = true,
                                 default = nil)
  if valid_597206 != nil:
    section.add "resourceGroupName", valid_597206
  var valid_597207 = path.getOrDefault("authsid")
  valid_597207 = validateParameter(valid_597207, JString, required = true,
                                 default = nil)
  if valid_597207 != nil:
    section.add "authsid", valid_597207
  var valid_597208 = path.getOrDefault("subscriptionId")
  valid_597208 = validateParameter(valid_597208, JString, required = true,
                                 default = nil)
  if valid_597208 != nil:
    section.add "subscriptionId", valid_597208
  var valid_597209 = path.getOrDefault("serviceName")
  valid_597209 = validateParameter(valid_597209, JString, required = true,
                                 default = nil)
  if valid_597209 != nil:
    section.add "serviceName", valid_597209
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597210 = query.getOrDefault("api-version")
  valid_597210 = validateParameter(valid_597210, JString, required = true,
                                 default = nil)
  if valid_597210 != nil:
    section.add "api-version", valid_597210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Create or update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597212: Call_AuthorizationServersCreateOrUpdate_597203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates new authorization server or updates an existing authorization server.
  ## 
  let valid = call_597212.validator(path, query, header, formData, body)
  let scheme = call_597212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597212.url(scheme.get, call_597212.host, call_597212.base,
                         call_597212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597212, url, valid)

proc call*(call_597213: Call_AuthorizationServersCreateOrUpdate_597203;
          resourceGroupName: string; apiVersion: string; authsid: string;
          subscriptionId: string; parameters: JsonNode; serviceName: string): Recallable =
  ## authorizationServersCreateOrUpdate
  ## Creates new authorization server or updates an existing authorization server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   authsid: string (required)
  ##          : Identifier of the authorization server.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Create or update parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597214 = newJObject()
  var query_597215 = newJObject()
  var body_597216 = newJObject()
  add(path_597214, "resourceGroupName", newJString(resourceGroupName))
  add(query_597215, "api-version", newJString(apiVersion))
  add(path_597214, "authsid", newJString(authsid))
  add(path_597214, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597216 = parameters
  add(path_597214, "serviceName", newJString(serviceName))
  result = call_597213.call(path_597214, query_597215, nil, nil, body_597216)

var authorizationServersCreateOrUpdate* = Call_AuthorizationServersCreateOrUpdate_597203(
    name: "authorizationServersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/authorizationServers/{authsid}",
    validator: validate_AuthorizationServersCreateOrUpdate_597204, base: "",
    url: url_AuthorizationServersCreateOrUpdate_597205, schemes: {Scheme.Https})
type
  Call_AuthorizationServersGet_597191 = ref object of OpenApiRestCall_596467
proc url_AuthorizationServersGet_597193(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "authsid" in path, "`authsid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/authorizationServers/"),
               (kind: VariableSegment, value: "authsid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AuthorizationServersGet_597192(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the authorization server specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   authsid: JString (required)
  ##          : Identifier of the authorization server.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597194 = path.getOrDefault("resourceGroupName")
  valid_597194 = validateParameter(valid_597194, JString, required = true,
                                 default = nil)
  if valid_597194 != nil:
    section.add "resourceGroupName", valid_597194
  var valid_597195 = path.getOrDefault("authsid")
  valid_597195 = validateParameter(valid_597195, JString, required = true,
                                 default = nil)
  if valid_597195 != nil:
    section.add "authsid", valid_597195
  var valid_597196 = path.getOrDefault("subscriptionId")
  valid_597196 = validateParameter(valid_597196, JString, required = true,
                                 default = nil)
  if valid_597196 != nil:
    section.add "subscriptionId", valid_597196
  var valid_597197 = path.getOrDefault("serviceName")
  valid_597197 = validateParameter(valid_597197, JString, required = true,
                                 default = nil)
  if valid_597197 != nil:
    section.add "serviceName", valid_597197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597198 = query.getOrDefault("api-version")
  valid_597198 = validateParameter(valid_597198, JString, required = true,
                                 default = nil)
  if valid_597198 != nil:
    section.add "api-version", valid_597198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597199: Call_AuthorizationServersGet_597191; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the authorization server specified by its identifier.
  ## 
  let valid = call_597199.validator(path, query, header, formData, body)
  let scheme = call_597199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597199.url(scheme.get, call_597199.host, call_597199.base,
                         call_597199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597199, url, valid)

proc call*(call_597200: Call_AuthorizationServersGet_597191;
          resourceGroupName: string; apiVersion: string; authsid: string;
          subscriptionId: string; serviceName: string): Recallable =
  ## authorizationServersGet
  ## Gets the details of the authorization server specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   authsid: string (required)
  ##          : Identifier of the authorization server.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597201 = newJObject()
  var query_597202 = newJObject()
  add(path_597201, "resourceGroupName", newJString(resourceGroupName))
  add(query_597202, "api-version", newJString(apiVersion))
  add(path_597201, "authsid", newJString(authsid))
  add(path_597201, "subscriptionId", newJString(subscriptionId))
  add(path_597201, "serviceName", newJString(serviceName))
  result = call_597200.call(path_597201, query_597202, nil, nil, nil)

var authorizationServersGet* = Call_AuthorizationServersGet_597191(
    name: "authorizationServersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/authorizationServers/{authsid}",
    validator: validate_AuthorizationServersGet_597192, base: "",
    url: url_AuthorizationServersGet_597193, schemes: {Scheme.Https})
type
  Call_AuthorizationServersUpdate_597230 = ref object of OpenApiRestCall_596467
proc url_AuthorizationServersUpdate_597232(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "authsid" in path, "`authsid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/authorizationServers/"),
               (kind: VariableSegment, value: "authsid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AuthorizationServersUpdate_597231(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the details of the authorization server specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   authsid: JString (required)
  ##          : Identifier of the authorization server.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597233 = path.getOrDefault("resourceGroupName")
  valid_597233 = validateParameter(valid_597233, JString, required = true,
                                 default = nil)
  if valid_597233 != nil:
    section.add "resourceGroupName", valid_597233
  var valid_597234 = path.getOrDefault("authsid")
  valid_597234 = validateParameter(valid_597234, JString, required = true,
                                 default = nil)
  if valid_597234 != nil:
    section.add "authsid", valid_597234
  var valid_597235 = path.getOrDefault("subscriptionId")
  valid_597235 = validateParameter(valid_597235, JString, required = true,
                                 default = nil)
  if valid_597235 != nil:
    section.add "subscriptionId", valid_597235
  var valid_597236 = path.getOrDefault("serviceName")
  valid_597236 = validateParameter(valid_597236, JString, required = true,
                                 default = nil)
  if valid_597236 != nil:
    section.add "serviceName", valid_597236
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597237 = query.getOrDefault("api-version")
  valid_597237 = validateParameter(valid_597237, JString, required = true,
                                 default = nil)
  if valid_597237 != nil:
    section.add "api-version", valid_597237
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the authorization server to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597238 = header.getOrDefault("If-Match")
  valid_597238 = validateParameter(valid_597238, JString, required = true,
                                 default = nil)
  if valid_597238 != nil:
    section.add "If-Match", valid_597238
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : OAuth2 Server settings Update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597240: Call_AuthorizationServersUpdate_597230; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of the authorization server specified by its identifier.
  ## 
  let valid = call_597240.validator(path, query, header, formData, body)
  let scheme = call_597240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597240.url(scheme.get, call_597240.host, call_597240.base,
                         call_597240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597240, url, valid)

proc call*(call_597241: Call_AuthorizationServersUpdate_597230;
          resourceGroupName: string; apiVersion: string; authsid: string;
          subscriptionId: string; parameters: JsonNode; serviceName: string): Recallable =
  ## authorizationServersUpdate
  ## Updates the details of the authorization server specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   authsid: string (required)
  ##          : Identifier of the authorization server.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : OAuth2 Server settings Update parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597242 = newJObject()
  var query_597243 = newJObject()
  var body_597244 = newJObject()
  add(path_597242, "resourceGroupName", newJString(resourceGroupName))
  add(query_597243, "api-version", newJString(apiVersion))
  add(path_597242, "authsid", newJString(authsid))
  add(path_597242, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597244 = parameters
  add(path_597242, "serviceName", newJString(serviceName))
  result = call_597241.call(path_597242, query_597243, nil, nil, body_597244)

var authorizationServersUpdate* = Call_AuthorizationServersUpdate_597230(
    name: "authorizationServersUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/authorizationServers/{authsid}",
    validator: validate_AuthorizationServersUpdate_597231, base: "",
    url: url_AuthorizationServersUpdate_597232, schemes: {Scheme.Https})
type
  Call_AuthorizationServersDelete_597217 = ref object of OpenApiRestCall_596467
proc url_AuthorizationServersDelete_597219(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "authsid" in path, "`authsid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/authorizationServers/"),
               (kind: VariableSegment, value: "authsid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AuthorizationServersDelete_597218(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes specific authorization server instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   authsid: JString (required)
  ##          : Identifier of the authorization server.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597220 = path.getOrDefault("resourceGroupName")
  valid_597220 = validateParameter(valid_597220, JString, required = true,
                                 default = nil)
  if valid_597220 != nil:
    section.add "resourceGroupName", valid_597220
  var valid_597221 = path.getOrDefault("authsid")
  valid_597221 = validateParameter(valid_597221, JString, required = true,
                                 default = nil)
  if valid_597221 != nil:
    section.add "authsid", valid_597221
  var valid_597222 = path.getOrDefault("subscriptionId")
  valid_597222 = validateParameter(valid_597222, JString, required = true,
                                 default = nil)
  if valid_597222 != nil:
    section.add "subscriptionId", valid_597222
  var valid_597223 = path.getOrDefault("serviceName")
  valid_597223 = validateParameter(valid_597223, JString, required = true,
                                 default = nil)
  if valid_597223 != nil:
    section.add "serviceName", valid_597223
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597224 = query.getOrDefault("api-version")
  valid_597224 = validateParameter(valid_597224, JString, required = true,
                                 default = nil)
  if valid_597224 != nil:
    section.add "api-version", valid_597224
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the authentication server to delete. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597225 = header.getOrDefault("If-Match")
  valid_597225 = validateParameter(valid_597225, JString, required = true,
                                 default = nil)
  if valid_597225 != nil:
    section.add "If-Match", valid_597225
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597226: Call_AuthorizationServersDelete_597217; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specific authorization server instance.
  ## 
  let valid = call_597226.validator(path, query, header, formData, body)
  let scheme = call_597226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597226.url(scheme.get, call_597226.host, call_597226.base,
                         call_597226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597226, url, valid)

proc call*(call_597227: Call_AuthorizationServersDelete_597217;
          resourceGroupName: string; apiVersion: string; authsid: string;
          subscriptionId: string; serviceName: string): Recallable =
  ## authorizationServersDelete
  ## Deletes specific authorization server instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   authsid: string (required)
  ##          : Identifier of the authorization server.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597228 = newJObject()
  var query_597229 = newJObject()
  add(path_597228, "resourceGroupName", newJString(resourceGroupName))
  add(query_597229, "api-version", newJString(apiVersion))
  add(path_597228, "authsid", newJString(authsid))
  add(path_597228, "subscriptionId", newJString(subscriptionId))
  add(path_597228, "serviceName", newJString(serviceName))
  result = call_597227.call(path_597228, query_597229, nil, nil, nil)

var authorizationServersDelete* = Call_AuthorizationServersDelete_597217(
    name: "authorizationServersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/authorizationServers/{authsid}",
    validator: validate_AuthorizationServersDelete_597218, base: "",
    url: url_AuthorizationServersDelete_597219, schemes: {Scheme.Https})
type
  Call_BackendsListByService_597245 = ref object of OpenApiRestCall_596467
proc url_BackendsListByService_597247(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/backends")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackendsListByService_597246(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of backends in the specified service instance.
  ## 
  ## https://msdn.microsoft.com/en-us/library/dn935030.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597248 = path.getOrDefault("resourceGroupName")
  valid_597248 = validateParameter(valid_597248, JString, required = true,
                                 default = nil)
  if valid_597248 != nil:
    section.add "resourceGroupName", valid_597248
  var valid_597249 = path.getOrDefault("subscriptionId")
  valid_597249 = validateParameter(valid_597249, JString, required = true,
                                 default = nil)
  if valid_597249 != nil:
    section.add "subscriptionId", valid_597249
  var valid_597250 = path.getOrDefault("serviceName")
  valid_597250 = validateParameter(valid_597250, JString, required = true,
                                 default = nil)
  if valid_597250 != nil:
    section.add "serviceName", valid_597250
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field | Supported operators    | Supported functions                         |
  ## 
  ## |-------|------------------------|---------------------------------------------|
  ## | id    | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | host  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597251 = query.getOrDefault("api-version")
  valid_597251 = validateParameter(valid_597251, JString, required = true,
                                 default = nil)
  if valid_597251 != nil:
    section.add "api-version", valid_597251
  var valid_597252 = query.getOrDefault("$top")
  valid_597252 = validateParameter(valid_597252, JInt, required = false, default = nil)
  if valid_597252 != nil:
    section.add "$top", valid_597252
  var valid_597253 = query.getOrDefault("$skip")
  valid_597253 = validateParameter(valid_597253, JInt, required = false, default = nil)
  if valid_597253 != nil:
    section.add "$skip", valid_597253
  var valid_597254 = query.getOrDefault("$filter")
  valid_597254 = validateParameter(valid_597254, JString, required = false,
                                 default = nil)
  if valid_597254 != nil:
    section.add "$filter", valid_597254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597255: Call_BackendsListByService_597245; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of backends in the specified service instance.
  ## 
  ## https://msdn.microsoft.com/en-us/library/dn935030.aspx
  let valid = call_597255.validator(path, query, header, formData, body)
  let scheme = call_597255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597255.url(scheme.get, call_597255.host, call_597255.base,
                         call_597255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597255, url, valid)

proc call*(call_597256: Call_BackendsListByService_597245;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## backendsListByService
  ## Lists a collection of backends in the specified service instance.
  ## https://msdn.microsoft.com/en-us/library/dn935030.aspx
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field | Supported operators    | Supported functions                         |
  ## 
  ## |-------|------------------------|---------------------------------------------|
  ## | id    | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | host  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  var path_597257 = newJObject()
  var query_597258 = newJObject()
  add(path_597257, "resourceGroupName", newJString(resourceGroupName))
  add(query_597258, "api-version", newJString(apiVersion))
  add(path_597257, "subscriptionId", newJString(subscriptionId))
  add(query_597258, "$top", newJInt(Top))
  add(query_597258, "$skip", newJInt(Skip))
  add(path_597257, "serviceName", newJString(serviceName))
  add(query_597258, "$filter", newJString(Filter))
  result = call_597256.call(path_597257, query_597258, nil, nil, nil)

var backendsListByService* = Call_BackendsListByService_597245(
    name: "backendsListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/backends",
    validator: validate_BackendsListByService_597246, base: "",
    url: url_BackendsListByService_597247, schemes: {Scheme.Https})
type
  Call_BackendsCreateOrUpdate_597271 = ref object of OpenApiRestCall_596467
proc url_BackendsCreateOrUpdate_597273(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "backendid" in path, "`backendid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/backends/"),
               (kind: VariableSegment, value: "backendid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackendsCreateOrUpdate_597272(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or Updates a backend.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   backendid: JString (required)
  ##            : User identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597274 = path.getOrDefault("resourceGroupName")
  valid_597274 = validateParameter(valid_597274, JString, required = true,
                                 default = nil)
  if valid_597274 != nil:
    section.add "resourceGroupName", valid_597274
  var valid_597275 = path.getOrDefault("backendid")
  valid_597275 = validateParameter(valid_597275, JString, required = true,
                                 default = nil)
  if valid_597275 != nil:
    section.add "backendid", valid_597275
  var valid_597276 = path.getOrDefault("subscriptionId")
  valid_597276 = validateParameter(valid_597276, JString, required = true,
                                 default = nil)
  if valid_597276 != nil:
    section.add "subscriptionId", valid_597276
  var valid_597277 = path.getOrDefault("serviceName")
  valid_597277 = validateParameter(valid_597277, JString, required = true,
                                 default = nil)
  if valid_597277 != nil:
    section.add "serviceName", valid_597277
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597278 = query.getOrDefault("api-version")
  valid_597278 = validateParameter(valid_597278, JString, required = true,
                                 default = nil)
  if valid_597278 != nil:
    section.add "api-version", valid_597278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Create parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597280: Call_BackendsCreateOrUpdate_597271; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or Updates a backend.
  ## 
  let valid = call_597280.validator(path, query, header, formData, body)
  let scheme = call_597280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597280.url(scheme.get, call_597280.host, call_597280.base,
                         call_597280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597280, url, valid)

proc call*(call_597281: Call_BackendsCreateOrUpdate_597271;
          resourceGroupName: string; backendid: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode; serviceName: string): Recallable =
  ## backendsCreateOrUpdate
  ## Creates or Updates a backend.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   backendid: string (required)
  ##            : User identifier. Must be unique in the current API Management service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597282 = newJObject()
  var query_597283 = newJObject()
  var body_597284 = newJObject()
  add(path_597282, "resourceGroupName", newJString(resourceGroupName))
  add(path_597282, "backendid", newJString(backendid))
  add(query_597283, "api-version", newJString(apiVersion))
  add(path_597282, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597284 = parameters
  add(path_597282, "serviceName", newJString(serviceName))
  result = call_597281.call(path_597282, query_597283, nil, nil, body_597284)

var backendsCreateOrUpdate* = Call_BackendsCreateOrUpdate_597271(
    name: "backendsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/backends/{backendid}",
    validator: validate_BackendsCreateOrUpdate_597272, base: "",
    url: url_BackendsCreateOrUpdate_597273, schemes: {Scheme.Https})
type
  Call_BackendsGet_597259 = ref object of OpenApiRestCall_596467
proc url_BackendsGet_597261(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "backendid" in path, "`backendid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/backends/"),
               (kind: VariableSegment, value: "backendid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackendsGet_597260(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the backend specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   backendid: JString (required)
  ##            : User identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597262 = path.getOrDefault("resourceGroupName")
  valid_597262 = validateParameter(valid_597262, JString, required = true,
                                 default = nil)
  if valid_597262 != nil:
    section.add "resourceGroupName", valid_597262
  var valid_597263 = path.getOrDefault("backendid")
  valid_597263 = validateParameter(valid_597263, JString, required = true,
                                 default = nil)
  if valid_597263 != nil:
    section.add "backendid", valid_597263
  var valid_597264 = path.getOrDefault("subscriptionId")
  valid_597264 = validateParameter(valid_597264, JString, required = true,
                                 default = nil)
  if valid_597264 != nil:
    section.add "subscriptionId", valid_597264
  var valid_597265 = path.getOrDefault("serviceName")
  valid_597265 = validateParameter(valid_597265, JString, required = true,
                                 default = nil)
  if valid_597265 != nil:
    section.add "serviceName", valid_597265
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597266 = query.getOrDefault("api-version")
  valid_597266 = validateParameter(valid_597266, JString, required = true,
                                 default = nil)
  if valid_597266 != nil:
    section.add "api-version", valid_597266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597267: Call_BackendsGet_597259; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the backend specified by its identifier.
  ## 
  let valid = call_597267.validator(path, query, header, formData, body)
  let scheme = call_597267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597267.url(scheme.get, call_597267.host, call_597267.base,
                         call_597267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597267, url, valid)

proc call*(call_597268: Call_BackendsGet_597259; resourceGroupName: string;
          backendid: string; apiVersion: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## backendsGet
  ## Gets the details of the backend specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   backendid: string (required)
  ##            : User identifier. Must be unique in the current API Management service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597269 = newJObject()
  var query_597270 = newJObject()
  add(path_597269, "resourceGroupName", newJString(resourceGroupName))
  add(path_597269, "backendid", newJString(backendid))
  add(query_597270, "api-version", newJString(apiVersion))
  add(path_597269, "subscriptionId", newJString(subscriptionId))
  add(path_597269, "serviceName", newJString(serviceName))
  result = call_597268.call(path_597269, query_597270, nil, nil, nil)

var backendsGet* = Call_BackendsGet_597259(name: "backendsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/backends/{backendid}",
                                        validator: validate_BackendsGet_597260,
                                        base: "", url: url_BackendsGet_597261,
                                        schemes: {Scheme.Https})
type
  Call_BackendsUpdate_597298 = ref object of OpenApiRestCall_596467
proc url_BackendsUpdate_597300(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "backendid" in path, "`backendid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/backends/"),
               (kind: VariableSegment, value: "backendid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackendsUpdate_597299(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates an existing backend.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   backendid: JString (required)
  ##            : User identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597301 = path.getOrDefault("resourceGroupName")
  valid_597301 = validateParameter(valid_597301, JString, required = true,
                                 default = nil)
  if valid_597301 != nil:
    section.add "resourceGroupName", valid_597301
  var valid_597302 = path.getOrDefault("backendid")
  valid_597302 = validateParameter(valid_597302, JString, required = true,
                                 default = nil)
  if valid_597302 != nil:
    section.add "backendid", valid_597302
  var valid_597303 = path.getOrDefault("subscriptionId")
  valid_597303 = validateParameter(valid_597303, JString, required = true,
                                 default = nil)
  if valid_597303 != nil:
    section.add "subscriptionId", valid_597303
  var valid_597304 = path.getOrDefault("serviceName")
  valid_597304 = validateParameter(valid_597304, JString, required = true,
                                 default = nil)
  if valid_597304 != nil:
    section.add "serviceName", valid_597304
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597305 = query.getOrDefault("api-version")
  valid_597305 = validateParameter(valid_597305, JString, required = true,
                                 default = nil)
  if valid_597305 != nil:
    section.add "api-version", valid_597305
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the backend to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597306 = header.getOrDefault("If-Match")
  valid_597306 = validateParameter(valid_597306, JString, required = true,
                                 default = nil)
  if valid_597306 != nil:
    section.add "If-Match", valid_597306
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597308: Call_BackendsUpdate_597298; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing backend.
  ## 
  let valid = call_597308.validator(path, query, header, formData, body)
  let scheme = call_597308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597308.url(scheme.get, call_597308.host, call_597308.base,
                         call_597308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597308, url, valid)

proc call*(call_597309: Call_BackendsUpdate_597298; resourceGroupName: string;
          backendid: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## backendsUpdate
  ## Updates an existing backend.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   backendid: string (required)
  ##            : User identifier. Must be unique in the current API Management service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Update parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597310 = newJObject()
  var query_597311 = newJObject()
  var body_597312 = newJObject()
  add(path_597310, "resourceGroupName", newJString(resourceGroupName))
  add(path_597310, "backendid", newJString(backendid))
  add(query_597311, "api-version", newJString(apiVersion))
  add(path_597310, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597312 = parameters
  add(path_597310, "serviceName", newJString(serviceName))
  result = call_597309.call(path_597310, query_597311, nil, nil, body_597312)

var backendsUpdate* = Call_BackendsUpdate_597298(name: "backendsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/backends/{backendid}",
    validator: validate_BackendsUpdate_597299, base: "", url: url_BackendsUpdate_597300,
    schemes: {Scheme.Https})
type
  Call_BackendsDelete_597285 = ref object of OpenApiRestCall_596467
proc url_BackendsDelete_597287(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "backendid" in path, "`backendid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/backends/"),
               (kind: VariableSegment, value: "backendid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackendsDelete_597286(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes the specified backend.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   backendid: JString (required)
  ##            : User identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597288 = path.getOrDefault("resourceGroupName")
  valid_597288 = validateParameter(valid_597288, JString, required = true,
                                 default = nil)
  if valid_597288 != nil:
    section.add "resourceGroupName", valid_597288
  var valid_597289 = path.getOrDefault("backendid")
  valid_597289 = validateParameter(valid_597289, JString, required = true,
                                 default = nil)
  if valid_597289 != nil:
    section.add "backendid", valid_597289
  var valid_597290 = path.getOrDefault("subscriptionId")
  valid_597290 = validateParameter(valid_597290, JString, required = true,
                                 default = nil)
  if valid_597290 != nil:
    section.add "subscriptionId", valid_597290
  var valid_597291 = path.getOrDefault("serviceName")
  valid_597291 = validateParameter(valid_597291, JString, required = true,
                                 default = nil)
  if valid_597291 != nil:
    section.add "serviceName", valid_597291
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597292 = query.getOrDefault("api-version")
  valid_597292 = validateParameter(valid_597292, JString, required = true,
                                 default = nil)
  if valid_597292 != nil:
    section.add "api-version", valid_597292
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the backend to delete. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597293 = header.getOrDefault("If-Match")
  valid_597293 = validateParameter(valid_597293, JString, required = true,
                                 default = nil)
  if valid_597293 != nil:
    section.add "If-Match", valid_597293
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597294: Call_BackendsDelete_597285; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified backend.
  ## 
  let valid = call_597294.validator(path, query, header, formData, body)
  let scheme = call_597294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597294.url(scheme.get, call_597294.host, call_597294.base,
                         call_597294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597294, url, valid)

proc call*(call_597295: Call_BackendsDelete_597285; resourceGroupName: string;
          backendid: string; apiVersion: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## backendsDelete
  ## Deletes the specified backend.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   backendid: string (required)
  ##            : User identifier. Must be unique in the current API Management service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597296 = newJObject()
  var query_597297 = newJObject()
  add(path_597296, "resourceGroupName", newJString(resourceGroupName))
  add(path_597296, "backendid", newJString(backendid))
  add(query_597297, "api-version", newJString(apiVersion))
  add(path_597296, "subscriptionId", newJString(subscriptionId))
  add(path_597296, "serviceName", newJString(serviceName))
  result = call_597295.call(path_597296, query_597297, nil, nil, nil)

var backendsDelete* = Call_BackendsDelete_597285(name: "backendsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/backends/{backendid}",
    validator: validate_BackendsDelete_597286, base: "", url: url_BackendsDelete_597287,
    schemes: {Scheme.Https})
type
  Call_CertificatesListByService_597313 = ref object of OpenApiRestCall_596467
proc url_CertificatesListByService_597315(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/certificates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CertificatesListByService_597314(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of all certificates in the specified service instance.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/dn783483.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597316 = path.getOrDefault("resourceGroupName")
  valid_597316 = validateParameter(valid_597316, JString, required = true,
                                 default = nil)
  if valid_597316 != nil:
    section.add "resourceGroupName", valid_597316
  var valid_597317 = path.getOrDefault("subscriptionId")
  valid_597317 = validateParameter(valid_597317, JString, required = true,
                                 default = nil)
  if valid_597317 != nil:
    section.add "subscriptionId", valid_597317
  var valid_597318 = path.getOrDefault("serviceName")
  valid_597318 = validateParameter(valid_597318, JString, required = true,
                                 default = nil)
  if valid_597318 != nil:
    section.add "serviceName", valid_597318
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field          | Supported operators    | Supported functions                         |
  ## 
  ## |----------------|------------------------|---------------------------------------------|
  ## | id             | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | subject        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | thumbprint     | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | expirationDate | ge, le, eq, ne, gt, lt | N/A                                         |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597319 = query.getOrDefault("api-version")
  valid_597319 = validateParameter(valid_597319, JString, required = true,
                                 default = nil)
  if valid_597319 != nil:
    section.add "api-version", valid_597319
  var valid_597320 = query.getOrDefault("$top")
  valid_597320 = validateParameter(valid_597320, JInt, required = false, default = nil)
  if valid_597320 != nil:
    section.add "$top", valid_597320
  var valid_597321 = query.getOrDefault("$skip")
  valid_597321 = validateParameter(valid_597321, JInt, required = false, default = nil)
  if valid_597321 != nil:
    section.add "$skip", valid_597321
  var valid_597322 = query.getOrDefault("$filter")
  valid_597322 = validateParameter(valid_597322, JString, required = false,
                                 default = nil)
  if valid_597322 != nil:
    section.add "$filter", valid_597322
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597323: Call_CertificatesListByService_597313; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of all certificates in the specified service instance.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/dn783483.aspx
  let valid = call_597323.validator(path, query, header, formData, body)
  let scheme = call_597323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597323.url(scheme.get, call_597323.host, call_597323.base,
                         call_597323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597323, url, valid)

proc call*(call_597324: Call_CertificatesListByService_597313;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## certificatesListByService
  ## Lists a collection of all certificates in the specified service instance.
  ## https://msdn.microsoft.com/en-us/library/azure/dn783483.aspx
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field          | Supported operators    | Supported functions                         |
  ## 
  ## |----------------|------------------------|---------------------------------------------|
  ## | id             | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | subject        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | thumbprint     | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | expirationDate | ge, le, eq, ne, gt, lt | N/A                                         |
  var path_597325 = newJObject()
  var query_597326 = newJObject()
  add(path_597325, "resourceGroupName", newJString(resourceGroupName))
  add(query_597326, "api-version", newJString(apiVersion))
  add(path_597325, "subscriptionId", newJString(subscriptionId))
  add(query_597326, "$top", newJInt(Top))
  add(query_597326, "$skip", newJInt(Skip))
  add(path_597325, "serviceName", newJString(serviceName))
  add(query_597326, "$filter", newJString(Filter))
  result = call_597324.call(path_597325, query_597326, nil, nil, nil)

var certificatesListByService* = Call_CertificatesListByService_597313(
    name: "certificatesListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/certificates",
    validator: validate_CertificatesListByService_597314, base: "",
    url: url_CertificatesListByService_597315, schemes: {Scheme.Https})
type
  Call_CertificatesCreateOrUpdate_597339 = ref object of OpenApiRestCall_596467
proc url_CertificatesCreateOrUpdate_597341(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "certificateId" in path, "`certificateId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificateId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CertificatesCreateOrUpdate_597340(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the certificate being used for authentication with the backend.
  ## 
  ## How to secure back-end services using client certificate authentication in Azure API Management
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-howto-mutual-certificates/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   certificateId: JString (required)
  ##                : Identifier of the certificate entity. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597342 = path.getOrDefault("resourceGroupName")
  valid_597342 = validateParameter(valid_597342, JString, required = true,
                                 default = nil)
  if valid_597342 != nil:
    section.add "resourceGroupName", valid_597342
  var valid_597343 = path.getOrDefault("certificateId")
  valid_597343 = validateParameter(valid_597343, JString, required = true,
                                 default = nil)
  if valid_597343 != nil:
    section.add "certificateId", valid_597343
  var valid_597344 = path.getOrDefault("subscriptionId")
  valid_597344 = validateParameter(valid_597344, JString, required = true,
                                 default = nil)
  if valid_597344 != nil:
    section.add "subscriptionId", valid_597344
  var valid_597345 = path.getOrDefault("serviceName")
  valid_597345 = validateParameter(valid_597345, JString, required = true,
                                 default = nil)
  if valid_597345 != nil:
    section.add "serviceName", valid_597345
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597346 = query.getOrDefault("api-version")
  valid_597346 = validateParameter(valid_597346, JString, required = true,
                                 default = nil)
  if valid_597346 != nil:
    section.add "api-version", valid_597346
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The entity state (Etag) version of the certificate to update. A value of "*" can be used for If-Match to unconditionally apply the operation..
  section = newJObject()
  var valid_597347 = header.getOrDefault("If-Match")
  valid_597347 = validateParameter(valid_597347, JString, required = false,
                                 default = nil)
  if valid_597347 != nil:
    section.add "If-Match", valid_597347
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Create parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597349: Call_CertificatesCreateOrUpdate_597339; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the certificate being used for authentication with the backend.
  ## 
  ## How to secure back-end services using client certificate authentication in Azure API Management
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-howto-mutual-certificates/
  let valid = call_597349.validator(path, query, header, formData, body)
  let scheme = call_597349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597349.url(scheme.get, call_597349.host, call_597349.base,
                         call_597349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597349, url, valid)

proc call*(call_597350: Call_CertificatesCreateOrUpdate_597339;
          resourceGroupName: string; apiVersion: string; certificateId: string;
          subscriptionId: string; parameters: JsonNode; serviceName: string): Recallable =
  ## certificatesCreateOrUpdate
  ## Creates or updates the certificate being used for authentication with the backend.
  ## How to secure back-end services using client certificate authentication in Azure API Management
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-howto-mutual-certificates/
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   certificateId: string (required)
  ##                : Identifier of the certificate entity. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597351 = newJObject()
  var query_597352 = newJObject()
  var body_597353 = newJObject()
  add(path_597351, "resourceGroupName", newJString(resourceGroupName))
  add(query_597352, "api-version", newJString(apiVersion))
  add(path_597351, "certificateId", newJString(certificateId))
  add(path_597351, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597353 = parameters
  add(path_597351, "serviceName", newJString(serviceName))
  result = call_597350.call(path_597351, query_597352, nil, nil, body_597353)

var certificatesCreateOrUpdate* = Call_CertificatesCreateOrUpdate_597339(
    name: "certificatesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/certificates/{certificateId}",
    validator: validate_CertificatesCreateOrUpdate_597340, base: "",
    url: url_CertificatesCreateOrUpdate_597341, schemes: {Scheme.Https})
type
  Call_CertificatesGet_597327 = ref object of OpenApiRestCall_596467
proc url_CertificatesGet_597329(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "certificateId" in path, "`certificateId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificateId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CertificatesGet_597328(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the details of the certificate specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   certificateId: JString (required)
  ##                : Identifier of the certificate.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597330 = path.getOrDefault("resourceGroupName")
  valid_597330 = validateParameter(valid_597330, JString, required = true,
                                 default = nil)
  if valid_597330 != nil:
    section.add "resourceGroupName", valid_597330
  var valid_597331 = path.getOrDefault("certificateId")
  valid_597331 = validateParameter(valid_597331, JString, required = true,
                                 default = nil)
  if valid_597331 != nil:
    section.add "certificateId", valid_597331
  var valid_597332 = path.getOrDefault("subscriptionId")
  valid_597332 = validateParameter(valid_597332, JString, required = true,
                                 default = nil)
  if valid_597332 != nil:
    section.add "subscriptionId", valid_597332
  var valid_597333 = path.getOrDefault("serviceName")
  valid_597333 = validateParameter(valid_597333, JString, required = true,
                                 default = nil)
  if valid_597333 != nil:
    section.add "serviceName", valid_597333
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597334 = query.getOrDefault("api-version")
  valid_597334 = validateParameter(valid_597334, JString, required = true,
                                 default = nil)
  if valid_597334 != nil:
    section.add "api-version", valid_597334
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597335: Call_CertificatesGet_597327; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the certificate specified by its identifier.
  ## 
  let valid = call_597335.validator(path, query, header, formData, body)
  let scheme = call_597335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597335.url(scheme.get, call_597335.host, call_597335.base,
                         call_597335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597335, url, valid)

proc call*(call_597336: Call_CertificatesGet_597327; resourceGroupName: string;
          apiVersion: string; certificateId: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## certificatesGet
  ## Gets the details of the certificate specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   certificateId: string (required)
  ##                : Identifier of the certificate.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597337 = newJObject()
  var query_597338 = newJObject()
  add(path_597337, "resourceGroupName", newJString(resourceGroupName))
  add(query_597338, "api-version", newJString(apiVersion))
  add(path_597337, "certificateId", newJString(certificateId))
  add(path_597337, "subscriptionId", newJString(subscriptionId))
  add(path_597337, "serviceName", newJString(serviceName))
  result = call_597336.call(path_597337, query_597338, nil, nil, nil)

var certificatesGet* = Call_CertificatesGet_597327(name: "certificatesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/certificates/{certificateId}",
    validator: validate_CertificatesGet_597328, base: "", url: url_CertificatesGet_597329,
    schemes: {Scheme.Https})
type
  Call_CertificatesDelete_597354 = ref object of OpenApiRestCall_596467
proc url_CertificatesDelete_597356(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "certificateId" in path, "`certificateId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "certificateId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CertificatesDelete_597355(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes specific certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   certificateId: JString (required)
  ##                : Identifier of the certificate.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597357 = path.getOrDefault("resourceGroupName")
  valid_597357 = validateParameter(valid_597357, JString, required = true,
                                 default = nil)
  if valid_597357 != nil:
    section.add "resourceGroupName", valid_597357
  var valid_597358 = path.getOrDefault("certificateId")
  valid_597358 = validateParameter(valid_597358, JString, required = true,
                                 default = nil)
  if valid_597358 != nil:
    section.add "certificateId", valid_597358
  var valid_597359 = path.getOrDefault("subscriptionId")
  valid_597359 = validateParameter(valid_597359, JString, required = true,
                                 default = nil)
  if valid_597359 != nil:
    section.add "subscriptionId", valid_597359
  var valid_597360 = path.getOrDefault("serviceName")
  valid_597360 = validateParameter(valid_597360, JString, required = true,
                                 default = nil)
  if valid_597360 != nil:
    section.add "serviceName", valid_597360
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597361 = query.getOrDefault("api-version")
  valid_597361 = validateParameter(valid_597361, JString, required = true,
                                 default = nil)
  if valid_597361 != nil:
    section.add "api-version", valid_597361
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the certificate to delete. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597362 = header.getOrDefault("If-Match")
  valid_597362 = validateParameter(valid_597362, JString, required = true,
                                 default = nil)
  if valid_597362 != nil:
    section.add "If-Match", valid_597362
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597363: Call_CertificatesDelete_597354; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specific certificate.
  ## 
  let valid = call_597363.validator(path, query, header, formData, body)
  let scheme = call_597363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597363.url(scheme.get, call_597363.host, call_597363.base,
                         call_597363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597363, url, valid)

proc call*(call_597364: Call_CertificatesDelete_597354; resourceGroupName: string;
          apiVersion: string; certificateId: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## certificatesDelete
  ## Deletes specific certificate.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   certificateId: string (required)
  ##                : Identifier of the certificate.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597365 = newJObject()
  var query_597366 = newJObject()
  add(path_597365, "resourceGroupName", newJString(resourceGroupName))
  add(query_597366, "api-version", newJString(apiVersion))
  add(path_597365, "certificateId", newJString(certificateId))
  add(path_597365, "subscriptionId", newJString(subscriptionId))
  add(path_597365, "serviceName", newJString(serviceName))
  result = call_597364.call(path_597365, query_597366, nil, nil, nil)

var certificatesDelete* = Call_CertificatesDelete_597354(
    name: "certificatesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/certificates/{certificateId}",
    validator: validate_CertificatesDelete_597355, base: "",
    url: url_CertificatesDelete_597356, schemes: {Scheme.Https})
type
  Call_GroupsListByService_597367 = ref object of OpenApiRestCall_596467
proc url_GroupsListByService_597369(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/groups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupsListByService_597368(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Lists a collection of groups defined within a service instance.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/dn776329.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597370 = path.getOrDefault("resourceGroupName")
  valid_597370 = validateParameter(valid_597370, JString, required = true,
                                 default = nil)
  if valid_597370 != nil:
    section.add "resourceGroupName", valid_597370
  var valid_597371 = path.getOrDefault("subscriptionId")
  valid_597371 = validateParameter(valid_597371, JString, required = true,
                                 default = nil)
  if valid_597371 != nil:
    section.add "subscriptionId", valid_597371
  var valid_597372 = path.getOrDefault("serviceName")
  valid_597372 = validateParameter(valid_597372, JString, required = true,
                                 default = nil)
  if valid_597372 != nil:
    section.add "serviceName", valid_597372
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | type        | eq, ne                 | N/A                                         |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597373 = query.getOrDefault("api-version")
  valid_597373 = validateParameter(valid_597373, JString, required = true,
                                 default = nil)
  if valid_597373 != nil:
    section.add "api-version", valid_597373
  var valid_597374 = query.getOrDefault("$top")
  valid_597374 = validateParameter(valid_597374, JInt, required = false, default = nil)
  if valid_597374 != nil:
    section.add "$top", valid_597374
  var valid_597375 = query.getOrDefault("$skip")
  valid_597375 = validateParameter(valid_597375, JInt, required = false, default = nil)
  if valid_597375 != nil:
    section.add "$skip", valid_597375
  var valid_597376 = query.getOrDefault("$filter")
  valid_597376 = validateParameter(valid_597376, JString, required = false,
                                 default = nil)
  if valid_597376 != nil:
    section.add "$filter", valid_597376
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597377: Call_GroupsListByService_597367; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of groups defined within a service instance.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/dn776329.aspx
  let valid = call_597377.validator(path, query, header, formData, body)
  let scheme = call_597377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597377.url(scheme.get, call_597377.host, call_597377.base,
                         call_597377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597377, url, valid)

proc call*(call_597378: Call_GroupsListByService_597367; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## groupsListByService
  ## Lists a collection of groups defined within a service instance.
  ## https://msdn.microsoft.com/en-us/library/azure/dn776329.aspx
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | type        | eq, ne                 | N/A                                         |
  var path_597379 = newJObject()
  var query_597380 = newJObject()
  add(path_597379, "resourceGroupName", newJString(resourceGroupName))
  add(query_597380, "api-version", newJString(apiVersion))
  add(path_597379, "subscriptionId", newJString(subscriptionId))
  add(query_597380, "$top", newJInt(Top))
  add(query_597380, "$skip", newJInt(Skip))
  add(path_597379, "serviceName", newJString(serviceName))
  add(query_597380, "$filter", newJString(Filter))
  result = call_597378.call(path_597379, query_597380, nil, nil, nil)

var groupsListByService* = Call_GroupsListByService_597367(
    name: "groupsListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/groups",
    validator: validate_GroupsListByService_597368, base: "",
    url: url_GroupsListByService_597369, schemes: {Scheme.Https})
type
  Call_GroupsCreateOrUpdate_597393 = ref object of OpenApiRestCall_596467
proc url_GroupsCreateOrUpdate_597395(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "groupId" in path, "`groupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupsCreateOrUpdate_597394(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or Updates a group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_597396 = path.getOrDefault("groupId")
  valid_597396 = validateParameter(valid_597396, JString, required = true,
                                 default = nil)
  if valid_597396 != nil:
    section.add "groupId", valid_597396
  var valid_597397 = path.getOrDefault("resourceGroupName")
  valid_597397 = validateParameter(valid_597397, JString, required = true,
                                 default = nil)
  if valid_597397 != nil:
    section.add "resourceGroupName", valid_597397
  var valid_597398 = path.getOrDefault("subscriptionId")
  valid_597398 = validateParameter(valid_597398, JString, required = true,
                                 default = nil)
  if valid_597398 != nil:
    section.add "subscriptionId", valid_597398
  var valid_597399 = path.getOrDefault("serviceName")
  valid_597399 = validateParameter(valid_597399, JString, required = true,
                                 default = nil)
  if valid_597399 != nil:
    section.add "serviceName", valid_597399
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597400 = query.getOrDefault("api-version")
  valid_597400 = validateParameter(valid_597400, JString, required = true,
                                 default = nil)
  if valid_597400 != nil:
    section.add "api-version", valid_597400
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Create parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597402: Call_GroupsCreateOrUpdate_597393; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or Updates a group.
  ## 
  let valid = call_597402.validator(path, query, header, formData, body)
  let scheme = call_597402.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597402.url(scheme.get, call_597402.host, call_597402.base,
                         call_597402.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597402, url, valid)

proc call*(call_597403: Call_GroupsCreateOrUpdate_597393; groupId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## groupsCreateOrUpdate
  ## Creates or Updates a group.
  ##   groupId: string (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597404 = newJObject()
  var query_597405 = newJObject()
  var body_597406 = newJObject()
  add(path_597404, "groupId", newJString(groupId))
  add(path_597404, "resourceGroupName", newJString(resourceGroupName))
  add(query_597405, "api-version", newJString(apiVersion))
  add(path_597404, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597406 = parameters
  add(path_597404, "serviceName", newJString(serviceName))
  result = call_597403.call(path_597404, query_597405, nil, nil, body_597406)

var groupsCreateOrUpdate* = Call_GroupsCreateOrUpdate_597393(
    name: "groupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/groups/{groupId}",
    validator: validate_GroupsCreateOrUpdate_597394, base: "",
    url: url_GroupsCreateOrUpdate_597395, schemes: {Scheme.Https})
type
  Call_GroupsGet_597381 = ref object of OpenApiRestCall_596467
proc url_GroupsGet_597383(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "groupId" in path, "`groupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupsGet_597382(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the group specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_597384 = path.getOrDefault("groupId")
  valid_597384 = validateParameter(valid_597384, JString, required = true,
                                 default = nil)
  if valid_597384 != nil:
    section.add "groupId", valid_597384
  var valid_597385 = path.getOrDefault("resourceGroupName")
  valid_597385 = validateParameter(valid_597385, JString, required = true,
                                 default = nil)
  if valid_597385 != nil:
    section.add "resourceGroupName", valid_597385
  var valid_597386 = path.getOrDefault("subscriptionId")
  valid_597386 = validateParameter(valid_597386, JString, required = true,
                                 default = nil)
  if valid_597386 != nil:
    section.add "subscriptionId", valid_597386
  var valid_597387 = path.getOrDefault("serviceName")
  valid_597387 = validateParameter(valid_597387, JString, required = true,
                                 default = nil)
  if valid_597387 != nil:
    section.add "serviceName", valid_597387
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597388 = query.getOrDefault("api-version")
  valid_597388 = validateParameter(valid_597388, JString, required = true,
                                 default = nil)
  if valid_597388 != nil:
    section.add "api-version", valid_597388
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597389: Call_GroupsGet_597381; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the group specified by its identifier.
  ## 
  let valid = call_597389.validator(path, query, header, formData, body)
  let scheme = call_597389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597389.url(scheme.get, call_597389.host, call_597389.base,
                         call_597389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597389, url, valid)

proc call*(call_597390: Call_GroupsGet_597381; groupId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## groupsGet
  ## Gets the details of the group specified by its identifier.
  ##   groupId: string (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597391 = newJObject()
  var query_597392 = newJObject()
  add(path_597391, "groupId", newJString(groupId))
  add(path_597391, "resourceGroupName", newJString(resourceGroupName))
  add(query_597392, "api-version", newJString(apiVersion))
  add(path_597391, "subscriptionId", newJString(subscriptionId))
  add(path_597391, "serviceName", newJString(serviceName))
  result = call_597390.call(path_597391, query_597392, nil, nil, nil)

var groupsGet* = Call_GroupsGet_597381(name: "groupsGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/groups/{groupId}",
                                    validator: validate_GroupsGet_597382,
                                    base: "", url: url_GroupsGet_597383,
                                    schemes: {Scheme.Https})
type
  Call_GroupsUpdate_597420 = ref object of OpenApiRestCall_596467
proc url_GroupsUpdate_597422(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "groupId" in path, "`groupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupsUpdate_597421(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the details of the group specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_597423 = path.getOrDefault("groupId")
  valid_597423 = validateParameter(valid_597423, JString, required = true,
                                 default = nil)
  if valid_597423 != nil:
    section.add "groupId", valid_597423
  var valid_597424 = path.getOrDefault("resourceGroupName")
  valid_597424 = validateParameter(valid_597424, JString, required = true,
                                 default = nil)
  if valid_597424 != nil:
    section.add "resourceGroupName", valid_597424
  var valid_597425 = path.getOrDefault("subscriptionId")
  valid_597425 = validateParameter(valid_597425, JString, required = true,
                                 default = nil)
  if valid_597425 != nil:
    section.add "subscriptionId", valid_597425
  var valid_597426 = path.getOrDefault("serviceName")
  valid_597426 = validateParameter(valid_597426, JString, required = true,
                                 default = nil)
  if valid_597426 != nil:
    section.add "serviceName", valid_597426
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597427 = query.getOrDefault("api-version")
  valid_597427 = validateParameter(valid_597427, JString, required = true,
                                 default = nil)
  if valid_597427 != nil:
    section.add "api-version", valid_597427
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Group Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597428 = header.getOrDefault("If-Match")
  valid_597428 = validateParameter(valid_597428, JString, required = true,
                                 default = nil)
  if valid_597428 != nil:
    section.add "If-Match", valid_597428
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597430: Call_GroupsUpdate_597420; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of the group specified by its identifier.
  ## 
  let valid = call_597430.validator(path, query, header, formData, body)
  let scheme = call_597430.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597430.url(scheme.get, call_597430.host, call_597430.base,
                         call_597430.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597430, url, valid)

proc call*(call_597431: Call_GroupsUpdate_597420; groupId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## groupsUpdate
  ## Updates the details of the group specified by its identifier.
  ##   groupId: string (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Update parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597432 = newJObject()
  var query_597433 = newJObject()
  var body_597434 = newJObject()
  add(path_597432, "groupId", newJString(groupId))
  add(path_597432, "resourceGroupName", newJString(resourceGroupName))
  add(query_597433, "api-version", newJString(apiVersion))
  add(path_597432, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597434 = parameters
  add(path_597432, "serviceName", newJString(serviceName))
  result = call_597431.call(path_597432, query_597433, nil, nil, body_597434)

var groupsUpdate* = Call_GroupsUpdate_597420(name: "groupsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/groups/{groupId}",
    validator: validate_GroupsUpdate_597421, base: "", url: url_GroupsUpdate_597422,
    schemes: {Scheme.Https})
type
  Call_GroupsDelete_597407 = ref object of OpenApiRestCall_596467
proc url_GroupsDelete_597409(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "groupId" in path, "`groupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupsDelete_597408(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes specific group of the API Management service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_597410 = path.getOrDefault("groupId")
  valid_597410 = validateParameter(valid_597410, JString, required = true,
                                 default = nil)
  if valid_597410 != nil:
    section.add "groupId", valid_597410
  var valid_597411 = path.getOrDefault("resourceGroupName")
  valid_597411 = validateParameter(valid_597411, JString, required = true,
                                 default = nil)
  if valid_597411 != nil:
    section.add "resourceGroupName", valid_597411
  var valid_597412 = path.getOrDefault("subscriptionId")
  valid_597412 = validateParameter(valid_597412, JString, required = true,
                                 default = nil)
  if valid_597412 != nil:
    section.add "subscriptionId", valid_597412
  var valid_597413 = path.getOrDefault("serviceName")
  valid_597413 = validateParameter(valid_597413, JString, required = true,
                                 default = nil)
  if valid_597413 != nil:
    section.add "serviceName", valid_597413
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597414 = query.getOrDefault("api-version")
  valid_597414 = validateParameter(valid_597414, JString, required = true,
                                 default = nil)
  if valid_597414 != nil:
    section.add "api-version", valid_597414
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Group Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597415 = header.getOrDefault("If-Match")
  valid_597415 = validateParameter(valid_597415, JString, required = true,
                                 default = nil)
  if valid_597415 != nil:
    section.add "If-Match", valid_597415
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597416: Call_GroupsDelete_597407; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specific group of the API Management service instance.
  ## 
  let valid = call_597416.validator(path, query, header, formData, body)
  let scheme = call_597416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597416.url(scheme.get, call_597416.host, call_597416.base,
                         call_597416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597416, url, valid)

proc call*(call_597417: Call_GroupsDelete_597407; groupId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## groupsDelete
  ## Deletes specific group of the API Management service instance.
  ##   groupId: string (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597418 = newJObject()
  var query_597419 = newJObject()
  add(path_597418, "groupId", newJString(groupId))
  add(path_597418, "resourceGroupName", newJString(resourceGroupName))
  add(query_597419, "api-version", newJString(apiVersion))
  add(path_597418, "subscriptionId", newJString(subscriptionId))
  add(path_597418, "serviceName", newJString(serviceName))
  result = call_597417.call(path_597418, query_597419, nil, nil, nil)

var groupsDelete* = Call_GroupsDelete_597407(name: "groupsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/groups/{groupId}",
    validator: validate_GroupsDelete_597408, base: "", url: url_GroupsDelete_597409,
    schemes: {Scheme.Https})
type
  Call_GroupUsersListByGroup_597435 = ref object of OpenApiRestCall_596467
proc url_GroupUsersListByGroup_597437(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "groupId" in path, "`groupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupId"),
               (kind: ConstantSegment, value: "/users")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupUsersListByGroup_597436(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of the members of the group, specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_597438 = path.getOrDefault("groupId")
  valid_597438 = validateParameter(valid_597438, JString, required = true,
                                 default = nil)
  if valid_597438 != nil:
    section.add "groupId", valid_597438
  var valid_597439 = path.getOrDefault("resourceGroupName")
  valid_597439 = validateParameter(valid_597439, JString, required = true,
                                 default = nil)
  if valid_597439 != nil:
    section.add "resourceGroupName", valid_597439
  var valid_597440 = path.getOrDefault("subscriptionId")
  valid_597440 = validateParameter(valid_597440, JString, required = true,
                                 default = nil)
  if valid_597440 != nil:
    section.add "subscriptionId", valid_597440
  var valid_597441 = path.getOrDefault("serviceName")
  valid_597441 = validateParameter(valid_597441, JString, required = true,
                                 default = nil)
  if valid_597441 != nil:
    section.add "serviceName", valid_597441
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field            | Supported operators    | Supported functions               |
  ## 
  ## |------------------|------------------------|-----------------------------------|
  ## | id               | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | firstName        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | lastName         | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | email            | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | state            | eq                     | N/A                               |
  ## | registrationDate | ge, le, eq, ne, gt, lt | N/A                               |
  ## | note             | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597442 = query.getOrDefault("api-version")
  valid_597442 = validateParameter(valid_597442, JString, required = true,
                                 default = nil)
  if valid_597442 != nil:
    section.add "api-version", valid_597442
  var valid_597443 = query.getOrDefault("$top")
  valid_597443 = validateParameter(valid_597443, JInt, required = false, default = nil)
  if valid_597443 != nil:
    section.add "$top", valid_597443
  var valid_597444 = query.getOrDefault("$skip")
  valid_597444 = validateParameter(valid_597444, JInt, required = false, default = nil)
  if valid_597444 != nil:
    section.add "$skip", valid_597444
  var valid_597445 = query.getOrDefault("$filter")
  valid_597445 = validateParameter(valid_597445, JString, required = false,
                                 default = nil)
  if valid_597445 != nil:
    section.add "$filter", valid_597445
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597446: Call_GroupUsersListByGroup_597435; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of the members of the group, specified by its identifier.
  ## 
  let valid = call_597446.validator(path, query, header, formData, body)
  let scheme = call_597446.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597446.url(scheme.get, call_597446.host, call_597446.base,
                         call_597446.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597446, url, valid)

proc call*(call_597447: Call_GroupUsersListByGroup_597435; groupId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## groupUsersListByGroup
  ## Lists a collection of the members of the group, specified by its identifier.
  ##   groupId: string (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field            | Supported operators    | Supported functions               |
  ## 
  ## |------------------|------------------------|-----------------------------------|
  ## | id               | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | firstName        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | lastName         | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | email            | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | state            | eq                     | N/A                               |
  ## | registrationDate | ge, le, eq, ne, gt, lt | N/A                               |
  ## | note             | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  var path_597448 = newJObject()
  var query_597449 = newJObject()
  add(path_597448, "groupId", newJString(groupId))
  add(path_597448, "resourceGroupName", newJString(resourceGroupName))
  add(query_597449, "api-version", newJString(apiVersion))
  add(path_597448, "subscriptionId", newJString(subscriptionId))
  add(query_597449, "$top", newJInt(Top))
  add(query_597449, "$skip", newJInt(Skip))
  add(path_597448, "serviceName", newJString(serviceName))
  add(query_597449, "$filter", newJString(Filter))
  result = call_597447.call(path_597448, query_597449, nil, nil, nil)

var groupUsersListByGroup* = Call_GroupUsersListByGroup_597435(
    name: "groupUsersListByGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/groups/{groupId}/users",
    validator: validate_GroupUsersListByGroup_597436, base: "",
    url: url_GroupUsersListByGroup_597437, schemes: {Scheme.Https})
type
  Call_GroupUsersAdd_597450 = ref object of OpenApiRestCall_596467
proc url_GroupUsersAdd_597452(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "groupId" in path, "`groupId` is a required path parameter"
  assert "uid" in path, "`uid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "uid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupUsersAdd_597451(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a user to the specified group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_597453 = path.getOrDefault("groupId")
  valid_597453 = validateParameter(valid_597453, JString, required = true,
                                 default = nil)
  if valid_597453 != nil:
    section.add "groupId", valid_597453
  var valid_597454 = path.getOrDefault("resourceGroupName")
  valid_597454 = validateParameter(valid_597454, JString, required = true,
                                 default = nil)
  if valid_597454 != nil:
    section.add "resourceGroupName", valid_597454
  var valid_597455 = path.getOrDefault("subscriptionId")
  valid_597455 = validateParameter(valid_597455, JString, required = true,
                                 default = nil)
  if valid_597455 != nil:
    section.add "subscriptionId", valid_597455
  var valid_597456 = path.getOrDefault("uid")
  valid_597456 = validateParameter(valid_597456, JString, required = true,
                                 default = nil)
  if valid_597456 != nil:
    section.add "uid", valid_597456
  var valid_597457 = path.getOrDefault("serviceName")
  valid_597457 = validateParameter(valid_597457, JString, required = true,
                                 default = nil)
  if valid_597457 != nil:
    section.add "serviceName", valid_597457
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597458 = query.getOrDefault("api-version")
  valid_597458 = validateParameter(valid_597458, JString, required = true,
                                 default = nil)
  if valid_597458 != nil:
    section.add "api-version", valid_597458
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597459: Call_GroupUsersAdd_597450; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a user to the specified group.
  ## 
  let valid = call_597459.validator(path, query, header, formData, body)
  let scheme = call_597459.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597459.url(scheme.get, call_597459.host, call_597459.base,
                         call_597459.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597459, url, valid)

proc call*(call_597460: Call_GroupUsersAdd_597450; groupId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          uid: string; serviceName: string): Recallable =
  ## groupUsersAdd
  ## Adds a user to the specified group.
  ##   groupId: string (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   uid: string (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597461 = newJObject()
  var query_597462 = newJObject()
  add(path_597461, "groupId", newJString(groupId))
  add(path_597461, "resourceGroupName", newJString(resourceGroupName))
  add(query_597462, "api-version", newJString(apiVersion))
  add(path_597461, "subscriptionId", newJString(subscriptionId))
  add(path_597461, "uid", newJString(uid))
  add(path_597461, "serviceName", newJString(serviceName))
  result = call_597460.call(path_597461, query_597462, nil, nil, nil)

var groupUsersAdd* = Call_GroupUsersAdd_597450(name: "groupUsersAdd",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/groups/{groupId}/users/{uid}",
    validator: validate_GroupUsersAdd_597451, base: "", url: url_GroupUsersAdd_597452,
    schemes: {Scheme.Https})
type
  Call_GroupUsersRemove_597463 = ref object of OpenApiRestCall_596467
proc url_GroupUsersRemove_597465(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "groupId" in path, "`groupId` is a required path parameter"
  assert "uid" in path, "`uid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "uid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupUsersRemove_597464(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Remove existing user from existing group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_597466 = path.getOrDefault("groupId")
  valid_597466 = validateParameter(valid_597466, JString, required = true,
                                 default = nil)
  if valid_597466 != nil:
    section.add "groupId", valid_597466
  var valid_597467 = path.getOrDefault("resourceGroupName")
  valid_597467 = validateParameter(valid_597467, JString, required = true,
                                 default = nil)
  if valid_597467 != nil:
    section.add "resourceGroupName", valid_597467
  var valid_597468 = path.getOrDefault("subscriptionId")
  valid_597468 = validateParameter(valid_597468, JString, required = true,
                                 default = nil)
  if valid_597468 != nil:
    section.add "subscriptionId", valid_597468
  var valid_597469 = path.getOrDefault("uid")
  valid_597469 = validateParameter(valid_597469, JString, required = true,
                                 default = nil)
  if valid_597469 != nil:
    section.add "uid", valid_597469
  var valid_597470 = path.getOrDefault("serviceName")
  valid_597470 = validateParameter(valid_597470, JString, required = true,
                                 default = nil)
  if valid_597470 != nil:
    section.add "serviceName", valid_597470
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597471 = query.getOrDefault("api-version")
  valid_597471 = validateParameter(valid_597471, JString, required = true,
                                 default = nil)
  if valid_597471 != nil:
    section.add "api-version", valid_597471
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597472: Call_GroupUsersRemove_597463; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove existing user from existing group.
  ## 
  let valid = call_597472.validator(path, query, header, formData, body)
  let scheme = call_597472.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597472.url(scheme.get, call_597472.host, call_597472.base,
                         call_597472.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597472, url, valid)

proc call*(call_597473: Call_GroupUsersRemove_597463; groupId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          uid: string; serviceName: string): Recallable =
  ## groupUsersRemove
  ## Remove existing user from existing group.
  ##   groupId: string (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   uid: string (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597474 = newJObject()
  var query_597475 = newJObject()
  add(path_597474, "groupId", newJString(groupId))
  add(path_597474, "resourceGroupName", newJString(resourceGroupName))
  add(query_597475, "api-version", newJString(apiVersion))
  add(path_597474, "subscriptionId", newJString(subscriptionId))
  add(path_597474, "uid", newJString(uid))
  add(path_597474, "serviceName", newJString(serviceName))
  result = call_597473.call(path_597474, query_597475, nil, nil, nil)

var groupUsersRemove* = Call_GroupUsersRemove_597463(name: "groupUsersRemove",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/groups/{groupId}/users/{uid}",
    validator: validate_GroupUsersRemove_597464, base: "",
    url: url_GroupUsersRemove_597465, schemes: {Scheme.Https})
type
  Call_IdentityProvidersListByService_597476 = ref object of OpenApiRestCall_596467
proc url_IdentityProvidersListByService_597478(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/identityProviders")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IdentityProvidersListByService_597477(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of Identity Provider configured in the specified service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597479 = path.getOrDefault("resourceGroupName")
  valid_597479 = validateParameter(valid_597479, JString, required = true,
                                 default = nil)
  if valid_597479 != nil:
    section.add "resourceGroupName", valid_597479
  var valid_597480 = path.getOrDefault("subscriptionId")
  valid_597480 = validateParameter(valid_597480, JString, required = true,
                                 default = nil)
  if valid_597480 != nil:
    section.add "subscriptionId", valid_597480
  var valid_597481 = path.getOrDefault("serviceName")
  valid_597481 = validateParameter(valid_597481, JString, required = true,
                                 default = nil)
  if valid_597481 != nil:
    section.add "serviceName", valid_597481
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597482 = query.getOrDefault("api-version")
  valid_597482 = validateParameter(valid_597482, JString, required = true,
                                 default = nil)
  if valid_597482 != nil:
    section.add "api-version", valid_597482
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597483: Call_IdentityProvidersListByService_597476; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of Identity Provider configured in the specified service instance.
  ## 
  let valid = call_597483.validator(path, query, header, formData, body)
  let scheme = call_597483.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597483.url(scheme.get, call_597483.host, call_597483.base,
                         call_597483.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597483, url, valid)

proc call*(call_597484: Call_IdentityProvidersListByService_597476;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## identityProvidersListByService
  ## Lists a collection of Identity Provider configured in the specified service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597485 = newJObject()
  var query_597486 = newJObject()
  add(path_597485, "resourceGroupName", newJString(resourceGroupName))
  add(query_597486, "api-version", newJString(apiVersion))
  add(path_597485, "subscriptionId", newJString(subscriptionId))
  add(path_597485, "serviceName", newJString(serviceName))
  result = call_597484.call(path_597485, query_597486, nil, nil, nil)

var identityProvidersListByService* = Call_IdentityProvidersListByService_597476(
    name: "identityProvidersListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/identityProviders",
    validator: validate_IdentityProvidersListByService_597477, base: "",
    url: url_IdentityProvidersListByService_597478, schemes: {Scheme.Https})
type
  Call_IdentityProvidersCreateOrUpdate_597512 = ref object of OpenApiRestCall_596467
proc url_IdentityProvidersCreateOrUpdate_597514(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "identityProviderName" in path,
        "`identityProviderName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/identityProviders/"),
               (kind: VariableSegment, value: "identityProviderName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IdentityProvidersCreateOrUpdate_597513(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or Updates the IdentityProvider configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   identityProviderName: JString (required)
  ##                       : Identity Provider Type identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597515 = path.getOrDefault("resourceGroupName")
  valid_597515 = validateParameter(valid_597515, JString, required = true,
                                 default = nil)
  if valid_597515 != nil:
    section.add "resourceGroupName", valid_597515
  var valid_597516 = path.getOrDefault("subscriptionId")
  valid_597516 = validateParameter(valid_597516, JString, required = true,
                                 default = nil)
  if valid_597516 != nil:
    section.add "subscriptionId", valid_597516
  var valid_597517 = path.getOrDefault("serviceName")
  valid_597517 = validateParameter(valid_597517, JString, required = true,
                                 default = nil)
  if valid_597517 != nil:
    section.add "serviceName", valid_597517
  var valid_597518 = path.getOrDefault("identityProviderName")
  valid_597518 = validateParameter(valid_597518, JString, required = true,
                                 default = newJString("facebook"))
  if valid_597518 != nil:
    section.add "identityProviderName", valid_597518
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597519 = query.getOrDefault("api-version")
  valid_597519 = validateParameter(valid_597519, JString, required = true,
                                 default = nil)
  if valid_597519 != nil:
    section.add "api-version", valid_597519
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Create parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597521: Call_IdentityProvidersCreateOrUpdate_597512;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or Updates the IdentityProvider configuration.
  ## 
  let valid = call_597521.validator(path, query, header, formData, body)
  let scheme = call_597521.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597521.url(scheme.get, call_597521.host, call_597521.base,
                         call_597521.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597521, url, valid)

proc call*(call_597522: Call_IdentityProvidersCreateOrUpdate_597512;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string;
          identityProviderName: string = "facebook"): Recallable =
  ## identityProvidersCreateOrUpdate
  ## Creates or Updates the IdentityProvider configuration.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   identityProviderName: string (required)
  ##                       : Identity Provider Type identifier.
  var path_597523 = newJObject()
  var query_597524 = newJObject()
  var body_597525 = newJObject()
  add(path_597523, "resourceGroupName", newJString(resourceGroupName))
  add(query_597524, "api-version", newJString(apiVersion))
  add(path_597523, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597525 = parameters
  add(path_597523, "serviceName", newJString(serviceName))
  add(path_597523, "identityProviderName", newJString(identityProviderName))
  result = call_597522.call(path_597523, query_597524, nil, nil, body_597525)

var identityProvidersCreateOrUpdate* = Call_IdentityProvidersCreateOrUpdate_597512(
    name: "identityProvidersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/identityProviders/{identityProviderName}",
    validator: validate_IdentityProvidersCreateOrUpdate_597513, base: "",
    url: url_IdentityProvidersCreateOrUpdate_597514, schemes: {Scheme.Https})
type
  Call_IdentityProvidersGet_597487 = ref object of OpenApiRestCall_596467
proc url_IdentityProvidersGet_597489(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "identityProviderName" in path,
        "`identityProviderName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/identityProviders/"),
               (kind: VariableSegment, value: "identityProviderName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IdentityProvidersGet_597488(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the configuration details of the identity Provider configured in specified service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   identityProviderName: JString (required)
  ##                       : Identity Provider Type identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597490 = path.getOrDefault("resourceGroupName")
  valid_597490 = validateParameter(valid_597490, JString, required = true,
                                 default = nil)
  if valid_597490 != nil:
    section.add "resourceGroupName", valid_597490
  var valid_597491 = path.getOrDefault("subscriptionId")
  valid_597491 = validateParameter(valid_597491, JString, required = true,
                                 default = nil)
  if valid_597491 != nil:
    section.add "subscriptionId", valid_597491
  var valid_597492 = path.getOrDefault("serviceName")
  valid_597492 = validateParameter(valid_597492, JString, required = true,
                                 default = nil)
  if valid_597492 != nil:
    section.add "serviceName", valid_597492
  var valid_597506 = path.getOrDefault("identityProviderName")
  valid_597506 = validateParameter(valid_597506, JString, required = true,
                                 default = newJString("facebook"))
  if valid_597506 != nil:
    section.add "identityProviderName", valid_597506
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597507 = query.getOrDefault("api-version")
  valid_597507 = validateParameter(valid_597507, JString, required = true,
                                 default = nil)
  if valid_597507 != nil:
    section.add "api-version", valid_597507
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597508: Call_IdentityProvidersGet_597487; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the configuration details of the identity Provider configured in specified service instance.
  ## 
  let valid = call_597508.validator(path, query, header, formData, body)
  let scheme = call_597508.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597508.url(scheme.get, call_597508.host, call_597508.base,
                         call_597508.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597508, url, valid)

proc call*(call_597509: Call_IdentityProvidersGet_597487;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; identityProviderName: string = "facebook"): Recallable =
  ## identityProvidersGet
  ## Gets the configuration details of the identity Provider configured in specified service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   identityProviderName: string (required)
  ##                       : Identity Provider Type identifier.
  var path_597510 = newJObject()
  var query_597511 = newJObject()
  add(path_597510, "resourceGroupName", newJString(resourceGroupName))
  add(query_597511, "api-version", newJString(apiVersion))
  add(path_597510, "subscriptionId", newJString(subscriptionId))
  add(path_597510, "serviceName", newJString(serviceName))
  add(path_597510, "identityProviderName", newJString(identityProviderName))
  result = call_597509.call(path_597510, query_597511, nil, nil, nil)

var identityProvidersGet* = Call_IdentityProvidersGet_597487(
    name: "identityProvidersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/identityProviders/{identityProviderName}",
    validator: validate_IdentityProvidersGet_597488, base: "",
    url: url_IdentityProvidersGet_597489, schemes: {Scheme.Https})
type
  Call_IdentityProvidersUpdate_597539 = ref object of OpenApiRestCall_596467
proc url_IdentityProvidersUpdate_597541(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "identityProviderName" in path,
        "`identityProviderName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/identityProviders/"),
               (kind: VariableSegment, value: "identityProviderName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IdentityProvidersUpdate_597540(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing IdentityProvider configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   identityProviderName: JString (required)
  ##                       : Identity Provider Type identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597542 = path.getOrDefault("resourceGroupName")
  valid_597542 = validateParameter(valid_597542, JString, required = true,
                                 default = nil)
  if valid_597542 != nil:
    section.add "resourceGroupName", valid_597542
  var valid_597543 = path.getOrDefault("subscriptionId")
  valid_597543 = validateParameter(valid_597543, JString, required = true,
                                 default = nil)
  if valid_597543 != nil:
    section.add "subscriptionId", valid_597543
  var valid_597544 = path.getOrDefault("serviceName")
  valid_597544 = validateParameter(valid_597544, JString, required = true,
                                 default = nil)
  if valid_597544 != nil:
    section.add "serviceName", valid_597544
  var valid_597545 = path.getOrDefault("identityProviderName")
  valid_597545 = validateParameter(valid_597545, JString, required = true,
                                 default = newJString("facebook"))
  if valid_597545 != nil:
    section.add "identityProviderName", valid_597545
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597546 = query.getOrDefault("api-version")
  valid_597546 = validateParameter(valid_597546, JString, required = true,
                                 default = nil)
  if valid_597546 != nil:
    section.add "api-version", valid_597546
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the identity provider configuration to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597547 = header.getOrDefault("If-Match")
  valid_597547 = validateParameter(valid_597547, JString, required = true,
                                 default = nil)
  if valid_597547 != nil:
    section.add "If-Match", valid_597547
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597549: Call_IdentityProvidersUpdate_597539; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing IdentityProvider configuration.
  ## 
  let valid = call_597549.validator(path, query, header, formData, body)
  let scheme = call_597549.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597549.url(scheme.get, call_597549.host, call_597549.base,
                         call_597549.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597549, url, valid)

proc call*(call_597550: Call_IdentityProvidersUpdate_597539;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string;
          identityProviderName: string = "facebook"): Recallable =
  ## identityProvidersUpdate
  ## Updates an existing IdentityProvider configuration.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Update parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   identityProviderName: string (required)
  ##                       : Identity Provider Type identifier.
  var path_597551 = newJObject()
  var query_597552 = newJObject()
  var body_597553 = newJObject()
  add(path_597551, "resourceGroupName", newJString(resourceGroupName))
  add(query_597552, "api-version", newJString(apiVersion))
  add(path_597551, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597553 = parameters
  add(path_597551, "serviceName", newJString(serviceName))
  add(path_597551, "identityProviderName", newJString(identityProviderName))
  result = call_597550.call(path_597551, query_597552, nil, nil, body_597553)

var identityProvidersUpdate* = Call_IdentityProvidersUpdate_597539(
    name: "identityProvidersUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/identityProviders/{identityProviderName}",
    validator: validate_IdentityProvidersUpdate_597540, base: "",
    url: url_IdentityProvidersUpdate_597541, schemes: {Scheme.Https})
type
  Call_IdentityProvidersDelete_597526 = ref object of OpenApiRestCall_596467
proc url_IdentityProvidersDelete_597528(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "identityProviderName" in path,
        "`identityProviderName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/identityProviders/"),
               (kind: VariableSegment, value: "identityProviderName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IdentityProvidersDelete_597527(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified identity provider configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   identityProviderName: JString (required)
  ##                       : Identity Provider Type identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597529 = path.getOrDefault("resourceGroupName")
  valid_597529 = validateParameter(valid_597529, JString, required = true,
                                 default = nil)
  if valid_597529 != nil:
    section.add "resourceGroupName", valid_597529
  var valid_597530 = path.getOrDefault("subscriptionId")
  valid_597530 = validateParameter(valid_597530, JString, required = true,
                                 default = nil)
  if valid_597530 != nil:
    section.add "subscriptionId", valid_597530
  var valid_597531 = path.getOrDefault("serviceName")
  valid_597531 = validateParameter(valid_597531, JString, required = true,
                                 default = nil)
  if valid_597531 != nil:
    section.add "serviceName", valid_597531
  var valid_597532 = path.getOrDefault("identityProviderName")
  valid_597532 = validateParameter(valid_597532, JString, required = true,
                                 default = newJString("facebook"))
  if valid_597532 != nil:
    section.add "identityProviderName", valid_597532
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597533 = query.getOrDefault("api-version")
  valid_597533 = validateParameter(valid_597533, JString, required = true,
                                 default = nil)
  if valid_597533 != nil:
    section.add "api-version", valid_597533
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the backend to delete. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597534 = header.getOrDefault("If-Match")
  valid_597534 = validateParameter(valid_597534, JString, required = true,
                                 default = nil)
  if valid_597534 != nil:
    section.add "If-Match", valid_597534
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597535: Call_IdentityProvidersDelete_597526; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified identity provider configuration.
  ## 
  let valid = call_597535.validator(path, query, header, formData, body)
  let scheme = call_597535.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597535.url(scheme.get, call_597535.host, call_597535.base,
                         call_597535.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597535, url, valid)

proc call*(call_597536: Call_IdentityProvidersDelete_597526;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; identityProviderName: string = "facebook"): Recallable =
  ## identityProvidersDelete
  ## Deletes the specified identity provider configuration.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   identityProviderName: string (required)
  ##                       : Identity Provider Type identifier.
  var path_597537 = newJObject()
  var query_597538 = newJObject()
  add(path_597537, "resourceGroupName", newJString(resourceGroupName))
  add(query_597538, "api-version", newJString(apiVersion))
  add(path_597537, "subscriptionId", newJString(subscriptionId))
  add(path_597537, "serviceName", newJString(serviceName))
  add(path_597537, "identityProviderName", newJString(identityProviderName))
  result = call_597536.call(path_597537, query_597538, nil, nil, nil)

var identityProvidersDelete* = Call_IdentityProvidersDelete_597526(
    name: "identityProvidersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/identityProviders/{identityProviderName}",
    validator: validate_IdentityProvidersDelete_597527, base: "",
    url: url_IdentityProvidersDelete_597528, schemes: {Scheme.Https})
type
  Call_LoggersListByService_597554 = ref object of OpenApiRestCall_596467
proc url_LoggersListByService_597556(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/loggers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggersListByService_597555(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of loggers in the specified service instance.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt592020.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597557 = path.getOrDefault("resourceGroupName")
  valid_597557 = validateParameter(valid_597557, JString, required = true,
                                 default = nil)
  if valid_597557 != nil:
    section.add "resourceGroupName", valid_597557
  var valid_597558 = path.getOrDefault("subscriptionId")
  valid_597558 = validateParameter(valid_597558, JString, required = true,
                                 default = nil)
  if valid_597558 != nil:
    section.add "subscriptionId", valid_597558
  var valid_597559 = path.getOrDefault("serviceName")
  valid_597559 = validateParameter(valid_597559, JString, required = true,
                                 default = nil)
  if valid_597559 != nil:
    section.add "serviceName", valid_597559
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field | Supported operators    | Supported functions                         |
  ## 
  ## |-------|------------------------|---------------------------------------------|
  ## | id    | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | type  | eq                     |                                             |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597560 = query.getOrDefault("api-version")
  valid_597560 = validateParameter(valid_597560, JString, required = true,
                                 default = nil)
  if valid_597560 != nil:
    section.add "api-version", valid_597560
  var valid_597561 = query.getOrDefault("$top")
  valid_597561 = validateParameter(valid_597561, JInt, required = false, default = nil)
  if valid_597561 != nil:
    section.add "$top", valid_597561
  var valid_597562 = query.getOrDefault("$skip")
  valid_597562 = validateParameter(valid_597562, JInt, required = false, default = nil)
  if valid_597562 != nil:
    section.add "$skip", valid_597562
  var valid_597563 = query.getOrDefault("$filter")
  valid_597563 = validateParameter(valid_597563, JString, required = false,
                                 default = nil)
  if valid_597563 != nil:
    section.add "$filter", valid_597563
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597564: Call_LoggersListByService_597554; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of loggers in the specified service instance.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt592020.aspx
  let valid = call_597564.validator(path, query, header, formData, body)
  let scheme = call_597564.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597564.url(scheme.get, call_597564.host, call_597564.base,
                         call_597564.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597564, url, valid)

proc call*(call_597565: Call_LoggersListByService_597554;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## loggersListByService
  ## Lists a collection of loggers in the specified service instance.
  ## https://msdn.microsoft.com/en-us/library/azure/mt592020.aspx
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field | Supported operators    | Supported functions                         |
  ## 
  ## |-------|------------------------|---------------------------------------------|
  ## | id    | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | type  | eq                     |                                             |
  var path_597566 = newJObject()
  var query_597567 = newJObject()
  add(path_597566, "resourceGroupName", newJString(resourceGroupName))
  add(query_597567, "api-version", newJString(apiVersion))
  add(path_597566, "subscriptionId", newJString(subscriptionId))
  add(query_597567, "$top", newJInt(Top))
  add(query_597567, "$skip", newJInt(Skip))
  add(path_597566, "serviceName", newJString(serviceName))
  add(query_597567, "$filter", newJString(Filter))
  result = call_597565.call(path_597566, query_597567, nil, nil, nil)

var loggersListByService* = Call_LoggersListByService_597554(
    name: "loggersListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/loggers",
    validator: validate_LoggersListByService_597555, base: "",
    url: url_LoggersListByService_597556, schemes: {Scheme.Https})
type
  Call_LoggersCreateOrUpdate_597580 = ref object of OpenApiRestCall_596467
proc url_LoggersCreateOrUpdate_597582(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "loggerid" in path, "`loggerid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/loggers/"),
               (kind: VariableSegment, value: "loggerid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggersCreateOrUpdate_597581(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or Updates a logger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loggerid: JString (required)
  ##           : Identifier of the logger.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597583 = path.getOrDefault("resourceGroupName")
  valid_597583 = validateParameter(valid_597583, JString, required = true,
                                 default = nil)
  if valid_597583 != nil:
    section.add "resourceGroupName", valid_597583
  var valid_597584 = path.getOrDefault("subscriptionId")
  valid_597584 = validateParameter(valid_597584, JString, required = true,
                                 default = nil)
  if valid_597584 != nil:
    section.add "subscriptionId", valid_597584
  var valid_597585 = path.getOrDefault("loggerid")
  valid_597585 = validateParameter(valid_597585, JString, required = true,
                                 default = nil)
  if valid_597585 != nil:
    section.add "loggerid", valid_597585
  var valid_597586 = path.getOrDefault("serviceName")
  valid_597586 = validateParameter(valid_597586, JString, required = true,
                                 default = nil)
  if valid_597586 != nil:
    section.add "serviceName", valid_597586
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597587 = query.getOrDefault("api-version")
  valid_597587 = validateParameter(valid_597587, JString, required = true,
                                 default = nil)
  if valid_597587 != nil:
    section.add "api-version", valid_597587
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Create parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597589: Call_LoggersCreateOrUpdate_597580; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or Updates a logger.
  ## 
  let valid = call_597589.validator(path, query, header, formData, body)
  let scheme = call_597589.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597589.url(scheme.get, call_597589.host, call_597589.base,
                         call_597589.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597589, url, valid)

proc call*(call_597590: Call_LoggersCreateOrUpdate_597580;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          loggerid: string; parameters: JsonNode; serviceName: string): Recallable =
  ## loggersCreateOrUpdate
  ## Creates or Updates a logger.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loggerid: string (required)
  ##           : Identifier of the logger.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597591 = newJObject()
  var query_597592 = newJObject()
  var body_597593 = newJObject()
  add(path_597591, "resourceGroupName", newJString(resourceGroupName))
  add(query_597592, "api-version", newJString(apiVersion))
  add(path_597591, "subscriptionId", newJString(subscriptionId))
  add(path_597591, "loggerid", newJString(loggerid))
  if parameters != nil:
    body_597593 = parameters
  add(path_597591, "serviceName", newJString(serviceName))
  result = call_597590.call(path_597591, query_597592, nil, nil, body_597593)

var loggersCreateOrUpdate* = Call_LoggersCreateOrUpdate_597580(
    name: "loggersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/loggers/{loggerid}",
    validator: validate_LoggersCreateOrUpdate_597581, base: "",
    url: url_LoggersCreateOrUpdate_597582, schemes: {Scheme.Https})
type
  Call_LoggersGet_597568 = ref object of OpenApiRestCall_596467
proc url_LoggersGet_597570(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "loggerid" in path, "`loggerid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/loggers/"),
               (kind: VariableSegment, value: "loggerid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggersGet_597569(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the logger specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loggerid: JString (required)
  ##           : Identifier of the logger.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597571 = path.getOrDefault("resourceGroupName")
  valid_597571 = validateParameter(valid_597571, JString, required = true,
                                 default = nil)
  if valid_597571 != nil:
    section.add "resourceGroupName", valid_597571
  var valid_597572 = path.getOrDefault("subscriptionId")
  valid_597572 = validateParameter(valid_597572, JString, required = true,
                                 default = nil)
  if valid_597572 != nil:
    section.add "subscriptionId", valid_597572
  var valid_597573 = path.getOrDefault("loggerid")
  valid_597573 = validateParameter(valid_597573, JString, required = true,
                                 default = nil)
  if valid_597573 != nil:
    section.add "loggerid", valid_597573
  var valid_597574 = path.getOrDefault("serviceName")
  valid_597574 = validateParameter(valid_597574, JString, required = true,
                                 default = nil)
  if valid_597574 != nil:
    section.add "serviceName", valid_597574
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597575 = query.getOrDefault("api-version")
  valid_597575 = validateParameter(valid_597575, JString, required = true,
                                 default = nil)
  if valid_597575 != nil:
    section.add "api-version", valid_597575
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597576: Call_LoggersGet_597568; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the logger specified by its identifier.
  ## 
  let valid = call_597576.validator(path, query, header, formData, body)
  let scheme = call_597576.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597576.url(scheme.get, call_597576.host, call_597576.base,
                         call_597576.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597576, url, valid)

proc call*(call_597577: Call_LoggersGet_597568; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; loggerid: string;
          serviceName: string): Recallable =
  ## loggersGet
  ## Gets the details of the logger specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loggerid: string (required)
  ##           : Identifier of the logger.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597578 = newJObject()
  var query_597579 = newJObject()
  add(path_597578, "resourceGroupName", newJString(resourceGroupName))
  add(query_597579, "api-version", newJString(apiVersion))
  add(path_597578, "subscriptionId", newJString(subscriptionId))
  add(path_597578, "loggerid", newJString(loggerid))
  add(path_597578, "serviceName", newJString(serviceName))
  result = call_597577.call(path_597578, query_597579, nil, nil, nil)

var loggersGet* = Call_LoggersGet_597568(name: "loggersGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/loggers/{loggerid}",
                                      validator: validate_LoggersGet_597569,
                                      base: "", url: url_LoggersGet_597570,
                                      schemes: {Scheme.Https})
type
  Call_LoggersUpdate_597607 = ref object of OpenApiRestCall_596467
proc url_LoggersUpdate_597609(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "loggerid" in path, "`loggerid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/loggers/"),
               (kind: VariableSegment, value: "loggerid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggersUpdate_597608(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing logger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loggerid: JString (required)
  ##           : Identifier of the logger.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597610 = path.getOrDefault("resourceGroupName")
  valid_597610 = validateParameter(valid_597610, JString, required = true,
                                 default = nil)
  if valid_597610 != nil:
    section.add "resourceGroupName", valid_597610
  var valid_597611 = path.getOrDefault("subscriptionId")
  valid_597611 = validateParameter(valid_597611, JString, required = true,
                                 default = nil)
  if valid_597611 != nil:
    section.add "subscriptionId", valid_597611
  var valid_597612 = path.getOrDefault("loggerid")
  valid_597612 = validateParameter(valid_597612, JString, required = true,
                                 default = nil)
  if valid_597612 != nil:
    section.add "loggerid", valid_597612
  var valid_597613 = path.getOrDefault("serviceName")
  valid_597613 = validateParameter(valid_597613, JString, required = true,
                                 default = nil)
  if valid_597613 != nil:
    section.add "serviceName", valid_597613
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597614 = query.getOrDefault("api-version")
  valid_597614 = validateParameter(valid_597614, JString, required = true,
                                 default = nil)
  if valid_597614 != nil:
    section.add "api-version", valid_597614
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the logger to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597615 = header.getOrDefault("If-Match")
  valid_597615 = validateParameter(valid_597615, JString, required = true,
                                 default = nil)
  if valid_597615 != nil:
    section.add "If-Match", valid_597615
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597617: Call_LoggersUpdate_597607; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing logger.
  ## 
  let valid = call_597617.validator(path, query, header, formData, body)
  let scheme = call_597617.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597617.url(scheme.get, call_597617.host, call_597617.base,
                         call_597617.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597617, url, valid)

proc call*(call_597618: Call_LoggersUpdate_597607; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; loggerid: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## loggersUpdate
  ## Updates an existing logger.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loggerid: string (required)
  ##           : Identifier of the logger.
  ##   parameters: JObject (required)
  ##             : Update parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597619 = newJObject()
  var query_597620 = newJObject()
  var body_597621 = newJObject()
  add(path_597619, "resourceGroupName", newJString(resourceGroupName))
  add(query_597620, "api-version", newJString(apiVersion))
  add(path_597619, "subscriptionId", newJString(subscriptionId))
  add(path_597619, "loggerid", newJString(loggerid))
  if parameters != nil:
    body_597621 = parameters
  add(path_597619, "serviceName", newJString(serviceName))
  result = call_597618.call(path_597619, query_597620, nil, nil, body_597621)

var loggersUpdate* = Call_LoggersUpdate_597607(name: "loggersUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/loggers/{loggerid}",
    validator: validate_LoggersUpdate_597608, base: "", url: url_LoggersUpdate_597609,
    schemes: {Scheme.Https})
type
  Call_LoggersDelete_597594 = ref object of OpenApiRestCall_596467
proc url_LoggersDelete_597596(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "loggerid" in path, "`loggerid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/loggers/"),
               (kind: VariableSegment, value: "loggerid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggersDelete_597595(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified logger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loggerid: JString (required)
  ##           : Identifier of the logger.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597597 = path.getOrDefault("resourceGroupName")
  valid_597597 = validateParameter(valid_597597, JString, required = true,
                                 default = nil)
  if valid_597597 != nil:
    section.add "resourceGroupName", valid_597597
  var valid_597598 = path.getOrDefault("subscriptionId")
  valid_597598 = validateParameter(valid_597598, JString, required = true,
                                 default = nil)
  if valid_597598 != nil:
    section.add "subscriptionId", valid_597598
  var valid_597599 = path.getOrDefault("loggerid")
  valid_597599 = validateParameter(valid_597599, JString, required = true,
                                 default = nil)
  if valid_597599 != nil:
    section.add "loggerid", valid_597599
  var valid_597600 = path.getOrDefault("serviceName")
  valid_597600 = validateParameter(valid_597600, JString, required = true,
                                 default = nil)
  if valid_597600 != nil:
    section.add "serviceName", valid_597600
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597601 = query.getOrDefault("api-version")
  valid_597601 = validateParameter(valid_597601, JString, required = true,
                                 default = nil)
  if valid_597601 != nil:
    section.add "api-version", valid_597601
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the logger to delete. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597602 = header.getOrDefault("If-Match")
  valid_597602 = validateParameter(valid_597602, JString, required = true,
                                 default = nil)
  if valid_597602 != nil:
    section.add "If-Match", valid_597602
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597603: Call_LoggersDelete_597594; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified logger.
  ## 
  let valid = call_597603.validator(path, query, header, formData, body)
  let scheme = call_597603.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597603.url(scheme.get, call_597603.host, call_597603.base,
                         call_597603.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597603, url, valid)

proc call*(call_597604: Call_LoggersDelete_597594; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; loggerid: string;
          serviceName: string): Recallable =
  ## loggersDelete
  ## Deletes the specified logger.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loggerid: string (required)
  ##           : Identifier of the logger.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597605 = newJObject()
  var query_597606 = newJObject()
  add(path_597605, "resourceGroupName", newJString(resourceGroupName))
  add(query_597606, "api-version", newJString(apiVersion))
  add(path_597605, "subscriptionId", newJString(subscriptionId))
  add(path_597605, "loggerid", newJString(loggerid))
  add(path_597605, "serviceName", newJString(serviceName))
  result = call_597604.call(path_597605, query_597606, nil, nil, nil)

var loggersDelete* = Call_LoggersDelete_597594(name: "loggersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/loggers/{loggerid}",
    validator: validate_LoggersDelete_597595, base: "", url: url_LoggersDelete_597596,
    schemes: {Scheme.Https})
type
  Call_OpenIdConnectProvidersListByService_597622 = ref object of OpenApiRestCall_596467
proc url_OpenIdConnectProvidersListByService_597624(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/openidConnectProviders")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OpenIdConnectProvidersListByService_597623(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all OpenID Connect Providers.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597625 = path.getOrDefault("resourceGroupName")
  valid_597625 = validateParameter(valid_597625, JString, required = true,
                                 default = nil)
  if valid_597625 != nil:
    section.add "resourceGroupName", valid_597625
  var valid_597626 = path.getOrDefault("subscriptionId")
  valid_597626 = validateParameter(valid_597626, JString, required = true,
                                 default = nil)
  if valid_597626 != nil:
    section.add "subscriptionId", valid_597626
  var valid_597627 = path.getOrDefault("serviceName")
  valid_597627 = validateParameter(valid_597627, JString, required = true,
                                 default = nil)
  if valid_597627 != nil:
    section.add "serviceName", valid_597627
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field | Supported operators    | Supported functions                         |
  ## 
  ## |-------|------------------------|---------------------------------------------|
  ## | id    | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597628 = query.getOrDefault("api-version")
  valid_597628 = validateParameter(valid_597628, JString, required = true,
                                 default = nil)
  if valid_597628 != nil:
    section.add "api-version", valid_597628
  var valid_597629 = query.getOrDefault("$top")
  valid_597629 = validateParameter(valid_597629, JInt, required = false, default = nil)
  if valid_597629 != nil:
    section.add "$top", valid_597629
  var valid_597630 = query.getOrDefault("$skip")
  valid_597630 = validateParameter(valid_597630, JInt, required = false, default = nil)
  if valid_597630 != nil:
    section.add "$skip", valid_597630
  var valid_597631 = query.getOrDefault("$filter")
  valid_597631 = validateParameter(valid_597631, JString, required = false,
                                 default = nil)
  if valid_597631 != nil:
    section.add "$filter", valid_597631
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597632: Call_OpenIdConnectProvidersListByService_597622;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all OpenID Connect Providers.
  ## 
  let valid = call_597632.validator(path, query, header, formData, body)
  let scheme = call_597632.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597632.url(scheme.get, call_597632.host, call_597632.base,
                         call_597632.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597632, url, valid)

proc call*(call_597633: Call_OpenIdConnectProvidersListByService_597622;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## openIdConnectProvidersListByService
  ## Lists all OpenID Connect Providers.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field | Supported operators    | Supported functions                         |
  ## 
  ## |-------|------------------------|---------------------------------------------|
  ## | id    | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  var path_597634 = newJObject()
  var query_597635 = newJObject()
  add(path_597634, "resourceGroupName", newJString(resourceGroupName))
  add(query_597635, "api-version", newJString(apiVersion))
  add(path_597634, "subscriptionId", newJString(subscriptionId))
  add(query_597635, "$top", newJInt(Top))
  add(query_597635, "$skip", newJInt(Skip))
  add(path_597634, "serviceName", newJString(serviceName))
  add(query_597635, "$filter", newJString(Filter))
  result = call_597633.call(path_597634, query_597635, nil, nil, nil)

var openIdConnectProvidersListByService* = Call_OpenIdConnectProvidersListByService_597622(
    name: "openIdConnectProvidersListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/openidConnectProviders",
    validator: validate_OpenIdConnectProvidersListByService_597623, base: "",
    url: url_OpenIdConnectProvidersListByService_597624, schemes: {Scheme.Https})
type
  Call_OpenIdConnectProvidersCreateOrUpdate_597648 = ref object of OpenApiRestCall_596467
proc url_OpenIdConnectProvidersCreateOrUpdate_597650(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "opid" in path, "`opid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/openidConnectProviders/"),
               (kind: VariableSegment, value: "opid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OpenIdConnectProvidersCreateOrUpdate_597649(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the OpenID Connect Provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   opid: JString (required)
  ##       : Identifier of the OpenID Connect Provider.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597651 = path.getOrDefault("resourceGroupName")
  valid_597651 = validateParameter(valid_597651, JString, required = true,
                                 default = nil)
  if valid_597651 != nil:
    section.add "resourceGroupName", valid_597651
  var valid_597652 = path.getOrDefault("subscriptionId")
  valid_597652 = validateParameter(valid_597652, JString, required = true,
                                 default = nil)
  if valid_597652 != nil:
    section.add "subscriptionId", valid_597652
  var valid_597653 = path.getOrDefault("opid")
  valid_597653 = validateParameter(valid_597653, JString, required = true,
                                 default = nil)
  if valid_597653 != nil:
    section.add "opid", valid_597653
  var valid_597654 = path.getOrDefault("serviceName")
  valid_597654 = validateParameter(valid_597654, JString, required = true,
                                 default = nil)
  if valid_597654 != nil:
    section.add "serviceName", valid_597654
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597655 = query.getOrDefault("api-version")
  valid_597655 = validateParameter(valid_597655, JString, required = true,
                                 default = nil)
  if valid_597655 != nil:
    section.add "api-version", valid_597655
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Create parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597657: Call_OpenIdConnectProvidersCreateOrUpdate_597648;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the OpenID Connect Provider.
  ## 
  let valid = call_597657.validator(path, query, header, formData, body)
  let scheme = call_597657.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597657.url(scheme.get, call_597657.host, call_597657.base,
                         call_597657.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597657, url, valid)

proc call*(call_597658: Call_OpenIdConnectProvidersCreateOrUpdate_597648;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          opid: string; parameters: JsonNode; serviceName: string): Recallable =
  ## openIdConnectProvidersCreateOrUpdate
  ## Creates or updates the OpenID Connect Provider.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   opid: string (required)
  ##       : Identifier of the OpenID Connect Provider.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597659 = newJObject()
  var query_597660 = newJObject()
  var body_597661 = newJObject()
  add(path_597659, "resourceGroupName", newJString(resourceGroupName))
  add(query_597660, "api-version", newJString(apiVersion))
  add(path_597659, "subscriptionId", newJString(subscriptionId))
  add(path_597659, "opid", newJString(opid))
  if parameters != nil:
    body_597661 = parameters
  add(path_597659, "serviceName", newJString(serviceName))
  result = call_597658.call(path_597659, query_597660, nil, nil, body_597661)

var openIdConnectProvidersCreateOrUpdate* = Call_OpenIdConnectProvidersCreateOrUpdate_597648(
    name: "openIdConnectProvidersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/openidConnectProviders/{opid}",
    validator: validate_OpenIdConnectProvidersCreateOrUpdate_597649, base: "",
    url: url_OpenIdConnectProvidersCreateOrUpdate_597650, schemes: {Scheme.Https})
type
  Call_OpenIdConnectProvidersGet_597636 = ref object of OpenApiRestCall_596467
proc url_OpenIdConnectProvidersGet_597638(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "opid" in path, "`opid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/openidConnectProviders/"),
               (kind: VariableSegment, value: "opid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OpenIdConnectProvidersGet_597637(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets specific OpenID Connect Provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   opid: JString (required)
  ##       : Identifier of the OpenID Connect Provider.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597639 = path.getOrDefault("resourceGroupName")
  valid_597639 = validateParameter(valid_597639, JString, required = true,
                                 default = nil)
  if valid_597639 != nil:
    section.add "resourceGroupName", valid_597639
  var valid_597640 = path.getOrDefault("subscriptionId")
  valid_597640 = validateParameter(valid_597640, JString, required = true,
                                 default = nil)
  if valid_597640 != nil:
    section.add "subscriptionId", valid_597640
  var valid_597641 = path.getOrDefault("opid")
  valid_597641 = validateParameter(valid_597641, JString, required = true,
                                 default = nil)
  if valid_597641 != nil:
    section.add "opid", valid_597641
  var valid_597642 = path.getOrDefault("serviceName")
  valid_597642 = validateParameter(valid_597642, JString, required = true,
                                 default = nil)
  if valid_597642 != nil:
    section.add "serviceName", valid_597642
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597643 = query.getOrDefault("api-version")
  valid_597643 = validateParameter(valid_597643, JString, required = true,
                                 default = nil)
  if valid_597643 != nil:
    section.add "api-version", valid_597643
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597644: Call_OpenIdConnectProvidersGet_597636; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets specific OpenID Connect Provider.
  ## 
  let valid = call_597644.validator(path, query, header, formData, body)
  let scheme = call_597644.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597644.url(scheme.get, call_597644.host, call_597644.base,
                         call_597644.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597644, url, valid)

proc call*(call_597645: Call_OpenIdConnectProvidersGet_597636;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          opid: string; serviceName: string): Recallable =
  ## openIdConnectProvidersGet
  ## Gets specific OpenID Connect Provider.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   opid: string (required)
  ##       : Identifier of the OpenID Connect Provider.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597646 = newJObject()
  var query_597647 = newJObject()
  add(path_597646, "resourceGroupName", newJString(resourceGroupName))
  add(query_597647, "api-version", newJString(apiVersion))
  add(path_597646, "subscriptionId", newJString(subscriptionId))
  add(path_597646, "opid", newJString(opid))
  add(path_597646, "serviceName", newJString(serviceName))
  result = call_597645.call(path_597646, query_597647, nil, nil, nil)

var openIdConnectProvidersGet* = Call_OpenIdConnectProvidersGet_597636(
    name: "openIdConnectProvidersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/openidConnectProviders/{opid}",
    validator: validate_OpenIdConnectProvidersGet_597637, base: "",
    url: url_OpenIdConnectProvidersGet_597638, schemes: {Scheme.Https})
type
  Call_OpenIdConnectProvidersUpdate_597675 = ref object of OpenApiRestCall_596467
proc url_OpenIdConnectProvidersUpdate_597677(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "opid" in path, "`opid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/openidConnectProviders/"),
               (kind: VariableSegment, value: "opid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OpenIdConnectProvidersUpdate_597676(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specific OpenID Connect Provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   opid: JString (required)
  ##       : Identifier of the OpenID Connect Provider.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597678 = path.getOrDefault("resourceGroupName")
  valid_597678 = validateParameter(valid_597678, JString, required = true,
                                 default = nil)
  if valid_597678 != nil:
    section.add "resourceGroupName", valid_597678
  var valid_597679 = path.getOrDefault("subscriptionId")
  valid_597679 = validateParameter(valid_597679, JString, required = true,
                                 default = nil)
  if valid_597679 != nil:
    section.add "subscriptionId", valid_597679
  var valid_597680 = path.getOrDefault("opid")
  valid_597680 = validateParameter(valid_597680, JString, required = true,
                                 default = nil)
  if valid_597680 != nil:
    section.add "opid", valid_597680
  var valid_597681 = path.getOrDefault("serviceName")
  valid_597681 = validateParameter(valid_597681, JString, required = true,
                                 default = nil)
  if valid_597681 != nil:
    section.add "serviceName", valid_597681
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597682 = query.getOrDefault("api-version")
  valid_597682 = validateParameter(valid_597682, JString, required = true,
                                 default = nil)
  if valid_597682 != nil:
    section.add "api-version", valid_597682
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the OpenID Connect Provider to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597683 = header.getOrDefault("If-Match")
  valid_597683 = validateParameter(valid_597683, JString, required = true,
                                 default = nil)
  if valid_597683 != nil:
    section.add "If-Match", valid_597683
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597685: Call_OpenIdConnectProvidersUpdate_597675; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specific OpenID Connect Provider.
  ## 
  let valid = call_597685.validator(path, query, header, formData, body)
  let scheme = call_597685.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597685.url(scheme.get, call_597685.host, call_597685.base,
                         call_597685.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597685, url, valid)

proc call*(call_597686: Call_OpenIdConnectProvidersUpdate_597675;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          opid: string; parameters: JsonNode; serviceName: string): Recallable =
  ## openIdConnectProvidersUpdate
  ## Updates the specific OpenID Connect Provider.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   opid: string (required)
  ##       : Identifier of the OpenID Connect Provider.
  ##   parameters: JObject (required)
  ##             : Update parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597687 = newJObject()
  var query_597688 = newJObject()
  var body_597689 = newJObject()
  add(path_597687, "resourceGroupName", newJString(resourceGroupName))
  add(query_597688, "api-version", newJString(apiVersion))
  add(path_597687, "subscriptionId", newJString(subscriptionId))
  add(path_597687, "opid", newJString(opid))
  if parameters != nil:
    body_597689 = parameters
  add(path_597687, "serviceName", newJString(serviceName))
  result = call_597686.call(path_597687, query_597688, nil, nil, body_597689)

var openIdConnectProvidersUpdate* = Call_OpenIdConnectProvidersUpdate_597675(
    name: "openIdConnectProvidersUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/openidConnectProviders/{opid}",
    validator: validate_OpenIdConnectProvidersUpdate_597676, base: "",
    url: url_OpenIdConnectProvidersUpdate_597677, schemes: {Scheme.Https})
type
  Call_OpenIdConnectProvidersDelete_597662 = ref object of OpenApiRestCall_596467
proc url_OpenIdConnectProvidersDelete_597664(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "opid" in path, "`opid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/openidConnectProviders/"),
               (kind: VariableSegment, value: "opid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OpenIdConnectProvidersDelete_597663(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes specific OpenID Connect Provider of the API Management service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   opid: JString (required)
  ##       : Identifier of the OpenID Connect Provider.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597665 = path.getOrDefault("resourceGroupName")
  valid_597665 = validateParameter(valid_597665, JString, required = true,
                                 default = nil)
  if valid_597665 != nil:
    section.add "resourceGroupName", valid_597665
  var valid_597666 = path.getOrDefault("subscriptionId")
  valid_597666 = validateParameter(valid_597666, JString, required = true,
                                 default = nil)
  if valid_597666 != nil:
    section.add "subscriptionId", valid_597666
  var valid_597667 = path.getOrDefault("opid")
  valid_597667 = validateParameter(valid_597667, JString, required = true,
                                 default = nil)
  if valid_597667 != nil:
    section.add "opid", valid_597667
  var valid_597668 = path.getOrDefault("serviceName")
  valid_597668 = validateParameter(valid_597668, JString, required = true,
                                 default = nil)
  if valid_597668 != nil:
    section.add "serviceName", valid_597668
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597669 = query.getOrDefault("api-version")
  valid_597669 = validateParameter(valid_597669, JString, required = true,
                                 default = nil)
  if valid_597669 != nil:
    section.add "api-version", valid_597669
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the OpenID Connect Provider to delete. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597670 = header.getOrDefault("If-Match")
  valid_597670 = validateParameter(valid_597670, JString, required = true,
                                 default = nil)
  if valid_597670 != nil:
    section.add "If-Match", valid_597670
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597671: Call_OpenIdConnectProvidersDelete_597662; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specific OpenID Connect Provider of the API Management service instance.
  ## 
  let valid = call_597671.validator(path, query, header, formData, body)
  let scheme = call_597671.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597671.url(scheme.get, call_597671.host, call_597671.base,
                         call_597671.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597671, url, valid)

proc call*(call_597672: Call_OpenIdConnectProvidersDelete_597662;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          opid: string; serviceName: string): Recallable =
  ## openIdConnectProvidersDelete
  ## Deletes specific OpenID Connect Provider of the API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   opid: string (required)
  ##       : Identifier of the OpenID Connect Provider.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597673 = newJObject()
  var query_597674 = newJObject()
  add(path_597673, "resourceGroupName", newJString(resourceGroupName))
  add(query_597674, "api-version", newJString(apiVersion))
  add(path_597673, "subscriptionId", newJString(subscriptionId))
  add(path_597673, "opid", newJString(opid))
  add(path_597673, "serviceName", newJString(serviceName))
  result = call_597672.call(path_597673, query_597674, nil, nil, nil)

var openIdConnectProvidersDelete* = Call_OpenIdConnectProvidersDelete_597662(
    name: "openIdConnectProvidersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/openidConnectProviders/{opid}",
    validator: validate_OpenIdConnectProvidersDelete_597663, base: "",
    url: url_OpenIdConnectProvidersDelete_597664, schemes: {Scheme.Https})
type
  Call_PolicySnippetsListByService_597690 = ref object of OpenApiRestCall_596467
proc url_PolicySnippetsListByService_597692(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/policySnippets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicySnippetsListByService_597691(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all policy snippets.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597693 = path.getOrDefault("resourceGroupName")
  valid_597693 = validateParameter(valid_597693, JString, required = true,
                                 default = nil)
  if valid_597693 != nil:
    section.add "resourceGroupName", valid_597693
  var valid_597694 = path.getOrDefault("subscriptionId")
  valid_597694 = validateParameter(valid_597694, JString, required = true,
                                 default = nil)
  if valid_597694 != nil:
    section.add "subscriptionId", valid_597694
  var valid_597695 = path.getOrDefault("serviceName")
  valid_597695 = validateParameter(valid_597695, JString, required = true,
                                 default = nil)
  if valid_597695 != nil:
    section.add "serviceName", valid_597695
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   scope: JString
  ##        : Policy scope.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597696 = query.getOrDefault("api-version")
  valid_597696 = validateParameter(valid_597696, JString, required = true,
                                 default = nil)
  if valid_597696 != nil:
    section.add "api-version", valid_597696
  var valid_597697 = query.getOrDefault("scope")
  valid_597697 = validateParameter(valid_597697, JString, required = false,
                                 default = newJString("Tenant"))
  if valid_597697 != nil:
    section.add "scope", valid_597697
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597698: Call_PolicySnippetsListByService_597690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all policy snippets.
  ## 
  let valid = call_597698.validator(path, query, header, formData, body)
  let scheme = call_597698.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597698.url(scheme.get, call_597698.host, call_597698.base,
                         call_597698.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597698, url, valid)

proc call*(call_597699: Call_PolicySnippetsListByService_597690;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; scope: string = "Tenant"): Recallable =
  ## policySnippetsListByService
  ## Lists all policy snippets.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   scope: string
  ##        : Policy scope.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597700 = newJObject()
  var query_597701 = newJObject()
  add(path_597700, "resourceGroupName", newJString(resourceGroupName))
  add(query_597701, "api-version", newJString(apiVersion))
  add(query_597701, "scope", newJString(scope))
  add(path_597700, "subscriptionId", newJString(subscriptionId))
  add(path_597700, "serviceName", newJString(serviceName))
  result = call_597699.call(path_597700, query_597701, nil, nil, nil)

var policySnippetsListByService* = Call_PolicySnippetsListByService_597690(
    name: "policySnippetsListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/policySnippets",
    validator: validate_PolicySnippetsListByService_597691, base: "",
    url: url_PolicySnippetsListByService_597692, schemes: {Scheme.Https})
type
  Call_ProductsListByService_597702 = ref object of OpenApiRestCall_596467
proc url_ProductsListByService_597704(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/products")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductsListByService_597703(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of products in the specified service instance.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/dn776336.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597705 = path.getOrDefault("resourceGroupName")
  valid_597705 = validateParameter(valid_597705, JString, required = true,
                                 default = nil)
  if valid_597705 != nil:
    section.add "resourceGroupName", valid_597705
  var valid_597706 = path.getOrDefault("subscriptionId")
  valid_597706 = validateParameter(valid_597706, JString, required = true,
                                 default = nil)
  if valid_597706 != nil:
    section.add "subscriptionId", valid_597706
  var valid_597707 = path.getOrDefault("serviceName")
  valid_597707 = validateParameter(valid_597707, JString, required = true,
                                 default = nil)
  if valid_597707 != nil:
    section.add "serviceName", valid_597707
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   expandGroups: JBool
  ##               : When set to true, the response contains an array of groups that have visibility to the product. The default is false.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | terms       | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | state       | eq                     |                                             |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597708 = query.getOrDefault("api-version")
  valid_597708 = validateParameter(valid_597708, JString, required = true,
                                 default = nil)
  if valid_597708 != nil:
    section.add "api-version", valid_597708
  var valid_597709 = query.getOrDefault("$top")
  valid_597709 = validateParameter(valid_597709, JInt, required = false, default = nil)
  if valid_597709 != nil:
    section.add "$top", valid_597709
  var valid_597710 = query.getOrDefault("$skip")
  valid_597710 = validateParameter(valid_597710, JInt, required = false, default = nil)
  if valid_597710 != nil:
    section.add "$skip", valid_597710
  var valid_597711 = query.getOrDefault("expandGroups")
  valid_597711 = validateParameter(valid_597711, JBool, required = false, default = nil)
  if valid_597711 != nil:
    section.add "expandGroups", valid_597711
  var valid_597712 = query.getOrDefault("$filter")
  valid_597712 = validateParameter(valid_597712, JString, required = false,
                                 default = nil)
  if valid_597712 != nil:
    section.add "$filter", valid_597712
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597713: Call_ProductsListByService_597702; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of products in the specified service instance.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/dn776336.aspx
  let valid = call_597713.validator(path, query, header, formData, body)
  let scheme = call_597713.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597713.url(scheme.get, call_597713.host, call_597713.base,
                         call_597713.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597713, url, valid)

proc call*(call_597714: Call_ProductsListByService_597702;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; Top: int = 0; Skip: int = 0; expandGroups: bool = false;
          Filter: string = ""): Recallable =
  ## productsListByService
  ## Lists a collection of products in the specified service instance.
  ## https://msdn.microsoft.com/en-us/library/azure/dn776336.aspx
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   expandGroups: bool
  ##               : When set to true, the response contains an array of groups that have visibility to the product. The default is false.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | terms       | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | state       | eq                     |                                             |
  var path_597715 = newJObject()
  var query_597716 = newJObject()
  add(path_597715, "resourceGroupName", newJString(resourceGroupName))
  add(query_597716, "api-version", newJString(apiVersion))
  add(path_597715, "subscriptionId", newJString(subscriptionId))
  add(query_597716, "$top", newJInt(Top))
  add(query_597716, "$skip", newJInt(Skip))
  add(query_597716, "expandGroups", newJBool(expandGroups))
  add(path_597715, "serviceName", newJString(serviceName))
  add(query_597716, "$filter", newJString(Filter))
  result = call_597714.call(path_597715, query_597716, nil, nil, nil)

var productsListByService* = Call_ProductsListByService_597702(
    name: "productsListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products",
    validator: validate_ProductsListByService_597703, base: "",
    url: url_ProductsListByService_597704, schemes: {Scheme.Https})
type
  Call_ProductsCreateOrUpdate_597729 = ref object of OpenApiRestCall_596467
proc url_ProductsCreateOrUpdate_597731(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductsCreateOrUpdate_597730(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or Updates a product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597732 = path.getOrDefault("resourceGroupName")
  valid_597732 = validateParameter(valid_597732, JString, required = true,
                                 default = nil)
  if valid_597732 != nil:
    section.add "resourceGroupName", valid_597732
  var valid_597733 = path.getOrDefault("subscriptionId")
  valid_597733 = validateParameter(valid_597733, JString, required = true,
                                 default = nil)
  if valid_597733 != nil:
    section.add "subscriptionId", valid_597733
  var valid_597734 = path.getOrDefault("productId")
  valid_597734 = validateParameter(valid_597734, JString, required = true,
                                 default = nil)
  if valid_597734 != nil:
    section.add "productId", valid_597734
  var valid_597735 = path.getOrDefault("serviceName")
  valid_597735 = validateParameter(valid_597735, JString, required = true,
                                 default = nil)
  if valid_597735 != nil:
    section.add "serviceName", valid_597735
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597736 = query.getOrDefault("api-version")
  valid_597736 = validateParameter(valid_597736, JString, required = true,
                                 default = nil)
  if valid_597736 != nil:
    section.add "api-version", valid_597736
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Create or update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597738: Call_ProductsCreateOrUpdate_597729; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or Updates a product.
  ## 
  let valid = call_597738.validator(path, query, header, formData, body)
  let scheme = call_597738.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597738.url(scheme.get, call_597738.host, call_597738.base,
                         call_597738.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597738, url, valid)

proc call*(call_597739: Call_ProductsCreateOrUpdate_597729;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; productId: string; serviceName: string): Recallable =
  ## productsCreateOrUpdate
  ## Creates or Updates a product.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Create or update parameters.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597740 = newJObject()
  var query_597741 = newJObject()
  var body_597742 = newJObject()
  add(path_597740, "resourceGroupName", newJString(resourceGroupName))
  add(query_597741, "api-version", newJString(apiVersion))
  add(path_597740, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597742 = parameters
  add(path_597740, "productId", newJString(productId))
  add(path_597740, "serviceName", newJString(serviceName))
  result = call_597739.call(path_597740, query_597741, nil, nil, body_597742)

var productsCreateOrUpdate* = Call_ProductsCreateOrUpdate_597729(
    name: "productsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}",
    validator: validate_ProductsCreateOrUpdate_597730, base: "",
    url: url_ProductsCreateOrUpdate_597731, schemes: {Scheme.Https})
type
  Call_ProductsGet_597717 = ref object of OpenApiRestCall_596467
proc url_ProductsGet_597719(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductsGet_597718(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the product specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597720 = path.getOrDefault("resourceGroupName")
  valid_597720 = validateParameter(valid_597720, JString, required = true,
                                 default = nil)
  if valid_597720 != nil:
    section.add "resourceGroupName", valid_597720
  var valid_597721 = path.getOrDefault("subscriptionId")
  valid_597721 = validateParameter(valid_597721, JString, required = true,
                                 default = nil)
  if valid_597721 != nil:
    section.add "subscriptionId", valid_597721
  var valid_597722 = path.getOrDefault("productId")
  valid_597722 = validateParameter(valid_597722, JString, required = true,
                                 default = nil)
  if valid_597722 != nil:
    section.add "productId", valid_597722
  var valid_597723 = path.getOrDefault("serviceName")
  valid_597723 = validateParameter(valid_597723, JString, required = true,
                                 default = nil)
  if valid_597723 != nil:
    section.add "serviceName", valid_597723
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597724 = query.getOrDefault("api-version")
  valid_597724 = validateParameter(valid_597724, JString, required = true,
                                 default = nil)
  if valid_597724 != nil:
    section.add "api-version", valid_597724
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597725: Call_ProductsGet_597717; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the product specified by its identifier.
  ## 
  let valid = call_597725.validator(path, query, header, formData, body)
  let scheme = call_597725.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597725.url(scheme.get, call_597725.host, call_597725.base,
                         call_597725.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597725, url, valid)

proc call*(call_597726: Call_ProductsGet_597717; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; productId: string;
          serviceName: string): Recallable =
  ## productsGet
  ## Gets the details of the product specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597727 = newJObject()
  var query_597728 = newJObject()
  add(path_597727, "resourceGroupName", newJString(resourceGroupName))
  add(query_597728, "api-version", newJString(apiVersion))
  add(path_597727, "subscriptionId", newJString(subscriptionId))
  add(path_597727, "productId", newJString(productId))
  add(path_597727, "serviceName", newJString(serviceName))
  result = call_597726.call(path_597727, query_597728, nil, nil, nil)

var productsGet* = Call_ProductsGet_597717(name: "productsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}",
                                        validator: validate_ProductsGet_597718,
                                        base: "", url: url_ProductsGet_597719,
                                        schemes: {Scheme.Https})
type
  Call_ProductsUpdate_597757 = ref object of OpenApiRestCall_596467
proc url_ProductsUpdate_597759(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductsUpdate_597758(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Update product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597760 = path.getOrDefault("resourceGroupName")
  valid_597760 = validateParameter(valid_597760, JString, required = true,
                                 default = nil)
  if valid_597760 != nil:
    section.add "resourceGroupName", valid_597760
  var valid_597761 = path.getOrDefault("subscriptionId")
  valid_597761 = validateParameter(valid_597761, JString, required = true,
                                 default = nil)
  if valid_597761 != nil:
    section.add "subscriptionId", valid_597761
  var valid_597762 = path.getOrDefault("productId")
  valid_597762 = validateParameter(valid_597762, JString, required = true,
                                 default = nil)
  if valid_597762 != nil:
    section.add "productId", valid_597762
  var valid_597763 = path.getOrDefault("serviceName")
  valid_597763 = validateParameter(valid_597763, JString, required = true,
                                 default = nil)
  if valid_597763 != nil:
    section.add "serviceName", valid_597763
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597764 = query.getOrDefault("api-version")
  valid_597764 = validateParameter(valid_597764, JString, required = true,
                                 default = nil)
  if valid_597764 != nil:
    section.add "api-version", valid_597764
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Product Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597765 = header.getOrDefault("If-Match")
  valid_597765 = validateParameter(valid_597765, JString, required = true,
                                 default = nil)
  if valid_597765 != nil:
    section.add "If-Match", valid_597765
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597767: Call_ProductsUpdate_597757; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update product.
  ## 
  let valid = call_597767.validator(path, query, header, formData, body)
  let scheme = call_597767.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597767.url(scheme.get, call_597767.host, call_597767.base,
                         call_597767.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597767, url, valid)

proc call*(call_597768: Call_ProductsUpdate_597757; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          productId: string; serviceName: string): Recallable =
  ## productsUpdate
  ## Update product.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Update parameters.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597769 = newJObject()
  var query_597770 = newJObject()
  var body_597771 = newJObject()
  add(path_597769, "resourceGroupName", newJString(resourceGroupName))
  add(query_597770, "api-version", newJString(apiVersion))
  add(path_597769, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597771 = parameters
  add(path_597769, "productId", newJString(productId))
  add(path_597769, "serviceName", newJString(serviceName))
  result = call_597768.call(path_597769, query_597770, nil, nil, body_597771)

var productsUpdate* = Call_ProductsUpdate_597757(name: "productsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}",
    validator: validate_ProductsUpdate_597758, base: "", url: url_ProductsUpdate_597759,
    schemes: {Scheme.Https})
type
  Call_ProductsDelete_597743 = ref object of OpenApiRestCall_596467
proc url_ProductsDelete_597745(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductsDelete_597744(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Delete product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597746 = path.getOrDefault("resourceGroupName")
  valid_597746 = validateParameter(valid_597746, JString, required = true,
                                 default = nil)
  if valid_597746 != nil:
    section.add "resourceGroupName", valid_597746
  var valid_597747 = path.getOrDefault("subscriptionId")
  valid_597747 = validateParameter(valid_597747, JString, required = true,
                                 default = nil)
  if valid_597747 != nil:
    section.add "subscriptionId", valid_597747
  var valid_597748 = path.getOrDefault("productId")
  valid_597748 = validateParameter(valid_597748, JString, required = true,
                                 default = nil)
  if valid_597748 != nil:
    section.add "productId", valid_597748
  var valid_597749 = path.getOrDefault("serviceName")
  valid_597749 = validateParameter(valid_597749, JString, required = true,
                                 default = nil)
  if valid_597749 != nil:
    section.add "serviceName", valid_597749
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   deleteSubscriptions: JBool
  ##                      : Delete existing subscriptions to the product or not.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597750 = query.getOrDefault("api-version")
  valid_597750 = validateParameter(valid_597750, JString, required = true,
                                 default = nil)
  if valid_597750 != nil:
    section.add "api-version", valid_597750
  var valid_597751 = query.getOrDefault("deleteSubscriptions")
  valid_597751 = validateParameter(valid_597751, JBool, required = false, default = nil)
  if valid_597751 != nil:
    section.add "deleteSubscriptions", valid_597751
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Product Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597752 = header.getOrDefault("If-Match")
  valid_597752 = validateParameter(valid_597752, JString, required = true,
                                 default = nil)
  if valid_597752 != nil:
    section.add "If-Match", valid_597752
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597753: Call_ProductsDelete_597743; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete product.
  ## 
  let valid = call_597753.validator(path, query, header, formData, body)
  let scheme = call_597753.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597753.url(scheme.get, call_597753.host, call_597753.base,
                         call_597753.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597753, url, valid)

proc call*(call_597754: Call_ProductsDelete_597743; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; productId: string;
          serviceName: string; deleteSubscriptions: bool = false): Recallable =
  ## productsDelete
  ## Delete product.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   deleteSubscriptions: bool
  ##                      : Delete existing subscriptions to the product or not.
  var path_597755 = newJObject()
  var query_597756 = newJObject()
  add(path_597755, "resourceGroupName", newJString(resourceGroupName))
  add(query_597756, "api-version", newJString(apiVersion))
  add(path_597755, "subscriptionId", newJString(subscriptionId))
  add(path_597755, "productId", newJString(productId))
  add(path_597755, "serviceName", newJString(serviceName))
  add(query_597756, "deleteSubscriptions", newJBool(deleteSubscriptions))
  result = call_597754.call(path_597755, query_597756, nil, nil, nil)

var productsDelete* = Call_ProductsDelete_597743(name: "productsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}",
    validator: validate_ProductsDelete_597744, base: "", url: url_ProductsDelete_597745,
    schemes: {Scheme.Https})
type
  Call_ProductApisListByProduct_597772 = ref object of OpenApiRestCall_596467
proc url_ProductApisListByProduct_597774(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/apis")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductApisListByProduct_597773(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of the APIs associated with a product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597775 = path.getOrDefault("resourceGroupName")
  valid_597775 = validateParameter(valid_597775, JString, required = true,
                                 default = nil)
  if valid_597775 != nil:
    section.add "resourceGroupName", valid_597775
  var valid_597776 = path.getOrDefault("subscriptionId")
  valid_597776 = validateParameter(valid_597776, JString, required = true,
                                 default = nil)
  if valid_597776 != nil:
    section.add "subscriptionId", valid_597776
  var valid_597777 = path.getOrDefault("productId")
  valid_597777 = validateParameter(valid_597777, JString, required = true,
                                 default = nil)
  if valid_597777 != nil:
    section.add "productId", valid_597777
  var valid_597778 = path.getOrDefault("serviceName")
  valid_597778 = validateParameter(valid_597778, JString, required = true,
                                 default = nil)
  if valid_597778 != nil:
    section.add "serviceName", valid_597778
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | serviceUrl  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | path        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597779 = query.getOrDefault("api-version")
  valid_597779 = validateParameter(valid_597779, JString, required = true,
                                 default = nil)
  if valid_597779 != nil:
    section.add "api-version", valid_597779
  var valid_597780 = query.getOrDefault("$top")
  valid_597780 = validateParameter(valid_597780, JInt, required = false, default = nil)
  if valid_597780 != nil:
    section.add "$top", valid_597780
  var valid_597781 = query.getOrDefault("$skip")
  valid_597781 = validateParameter(valid_597781, JInt, required = false, default = nil)
  if valid_597781 != nil:
    section.add "$skip", valid_597781
  var valid_597782 = query.getOrDefault("$filter")
  valid_597782 = validateParameter(valid_597782, JString, required = false,
                                 default = nil)
  if valid_597782 != nil:
    section.add "$filter", valid_597782
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597783: Call_ProductApisListByProduct_597772; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of the APIs associated with a product.
  ## 
  let valid = call_597783.validator(path, query, header, formData, body)
  let scheme = call_597783.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597783.url(scheme.get, call_597783.host, call_597783.base,
                         call_597783.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597783, url, valid)

proc call*(call_597784: Call_ProductApisListByProduct_597772;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          productId: string; serviceName: string; Top: int = 0; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## productApisListByProduct
  ## Lists a collection of the APIs associated with a product.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | serviceUrl  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | path        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## 
  var path_597785 = newJObject()
  var query_597786 = newJObject()
  add(path_597785, "resourceGroupName", newJString(resourceGroupName))
  add(query_597786, "api-version", newJString(apiVersion))
  add(path_597785, "subscriptionId", newJString(subscriptionId))
  add(query_597786, "$top", newJInt(Top))
  add(query_597786, "$skip", newJInt(Skip))
  add(path_597785, "productId", newJString(productId))
  add(path_597785, "serviceName", newJString(serviceName))
  add(query_597786, "$filter", newJString(Filter))
  result = call_597784.call(path_597785, query_597786, nil, nil, nil)

var productApisListByProduct* = Call_ProductApisListByProduct_597772(
    name: "productApisListByProduct", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/apis",
    validator: validate_ProductApisListByProduct_597773, base: "",
    url: url_ProductApisListByProduct_597774, schemes: {Scheme.Https})
type
  Call_ProductApisAdd_597787 = ref object of OpenApiRestCall_596467
proc url_ProductApisAdd_597789(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductApisAdd_597788(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Adds an API to the specified product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597790 = path.getOrDefault("resourceGroupName")
  valid_597790 = validateParameter(valid_597790, JString, required = true,
                                 default = nil)
  if valid_597790 != nil:
    section.add "resourceGroupName", valid_597790
  var valid_597791 = path.getOrDefault("apiId")
  valid_597791 = validateParameter(valid_597791, JString, required = true,
                                 default = nil)
  if valid_597791 != nil:
    section.add "apiId", valid_597791
  var valid_597792 = path.getOrDefault("subscriptionId")
  valid_597792 = validateParameter(valid_597792, JString, required = true,
                                 default = nil)
  if valid_597792 != nil:
    section.add "subscriptionId", valid_597792
  var valid_597793 = path.getOrDefault("productId")
  valid_597793 = validateParameter(valid_597793, JString, required = true,
                                 default = nil)
  if valid_597793 != nil:
    section.add "productId", valid_597793
  var valid_597794 = path.getOrDefault("serviceName")
  valid_597794 = validateParameter(valid_597794, JString, required = true,
                                 default = nil)
  if valid_597794 != nil:
    section.add "serviceName", valid_597794
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597795 = query.getOrDefault("api-version")
  valid_597795 = validateParameter(valid_597795, JString, required = true,
                                 default = nil)
  if valid_597795 != nil:
    section.add "api-version", valid_597795
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597796: Call_ProductApisAdd_597787; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds an API to the specified product.
  ## 
  let valid = call_597796.validator(path, query, header, formData, body)
  let scheme = call_597796.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597796.url(scheme.get, call_597796.host, call_597796.base,
                         call_597796.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597796, url, valid)

proc call*(call_597797: Call_ProductApisAdd_597787; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          productId: string; serviceName: string): Recallable =
  ## productApisAdd
  ## Adds an API to the specified product.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597798 = newJObject()
  var query_597799 = newJObject()
  add(path_597798, "resourceGroupName", newJString(resourceGroupName))
  add(query_597799, "api-version", newJString(apiVersion))
  add(path_597798, "apiId", newJString(apiId))
  add(path_597798, "subscriptionId", newJString(subscriptionId))
  add(path_597798, "productId", newJString(productId))
  add(path_597798, "serviceName", newJString(serviceName))
  result = call_597797.call(path_597798, query_597799, nil, nil, nil)

var productApisAdd* = Call_ProductApisAdd_597787(name: "productApisAdd",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/apis/{apiId}",
    validator: validate_ProductApisAdd_597788, base: "", url: url_ProductApisAdd_597789,
    schemes: {Scheme.Https})
type
  Call_ProductApisRemove_597800 = ref object of OpenApiRestCall_596467
proc url_ProductApisRemove_597802(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductApisRemove_597801(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes the specified API from the specified product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597803 = path.getOrDefault("resourceGroupName")
  valid_597803 = validateParameter(valid_597803, JString, required = true,
                                 default = nil)
  if valid_597803 != nil:
    section.add "resourceGroupName", valid_597803
  var valid_597804 = path.getOrDefault("apiId")
  valid_597804 = validateParameter(valid_597804, JString, required = true,
                                 default = nil)
  if valid_597804 != nil:
    section.add "apiId", valid_597804
  var valid_597805 = path.getOrDefault("subscriptionId")
  valid_597805 = validateParameter(valid_597805, JString, required = true,
                                 default = nil)
  if valid_597805 != nil:
    section.add "subscriptionId", valid_597805
  var valid_597806 = path.getOrDefault("productId")
  valid_597806 = validateParameter(valid_597806, JString, required = true,
                                 default = nil)
  if valid_597806 != nil:
    section.add "productId", valid_597806
  var valid_597807 = path.getOrDefault("serviceName")
  valid_597807 = validateParameter(valid_597807, JString, required = true,
                                 default = nil)
  if valid_597807 != nil:
    section.add "serviceName", valid_597807
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597808 = query.getOrDefault("api-version")
  valid_597808 = validateParameter(valid_597808, JString, required = true,
                                 default = nil)
  if valid_597808 != nil:
    section.add "api-version", valid_597808
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597809: Call_ProductApisRemove_597800; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified API from the specified product.
  ## 
  let valid = call_597809.validator(path, query, header, formData, body)
  let scheme = call_597809.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597809.url(scheme.get, call_597809.host, call_597809.base,
                         call_597809.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597809, url, valid)

proc call*(call_597810: Call_ProductApisRemove_597800; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          productId: string; serviceName: string): Recallable =
  ## productApisRemove
  ## Deletes the specified API from the specified product.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597811 = newJObject()
  var query_597812 = newJObject()
  add(path_597811, "resourceGroupName", newJString(resourceGroupName))
  add(query_597812, "api-version", newJString(apiVersion))
  add(path_597811, "apiId", newJString(apiId))
  add(path_597811, "subscriptionId", newJString(subscriptionId))
  add(path_597811, "productId", newJString(productId))
  add(path_597811, "serviceName", newJString(serviceName))
  result = call_597810.call(path_597811, query_597812, nil, nil, nil)

var productApisRemove* = Call_ProductApisRemove_597800(name: "productApisRemove",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/apis/{apiId}",
    validator: validate_ProductApisRemove_597801, base: "",
    url: url_ProductApisRemove_597802, schemes: {Scheme.Https})
type
  Call_ProductGroupsListByProduct_597813 = ref object of OpenApiRestCall_596467
proc url_ProductGroupsListByProduct_597815(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/groups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductGroupsListByProduct_597814(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the collection of developer groups associated with the specified product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597816 = path.getOrDefault("resourceGroupName")
  valid_597816 = validateParameter(valid_597816, JString, required = true,
                                 default = nil)
  if valid_597816 != nil:
    section.add "resourceGroupName", valid_597816
  var valid_597817 = path.getOrDefault("subscriptionId")
  valid_597817 = validateParameter(valid_597817, JString, required = true,
                                 default = nil)
  if valid_597817 != nil:
    section.add "subscriptionId", valid_597817
  var valid_597818 = path.getOrDefault("productId")
  valid_597818 = validateParameter(valid_597818, JString, required = true,
                                 default = nil)
  if valid_597818 != nil:
    section.add "productId", valid_597818
  var valid_597819 = path.getOrDefault("serviceName")
  valid_597819 = validateParameter(valid_597819, JString, required = true,
                                 default = nil)
  if valid_597819 != nil:
    section.add "serviceName", valid_597819
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | type        | eq, ne                 | N/A                                         |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597820 = query.getOrDefault("api-version")
  valid_597820 = validateParameter(valid_597820, JString, required = true,
                                 default = nil)
  if valid_597820 != nil:
    section.add "api-version", valid_597820
  var valid_597821 = query.getOrDefault("$top")
  valid_597821 = validateParameter(valid_597821, JInt, required = false, default = nil)
  if valid_597821 != nil:
    section.add "$top", valid_597821
  var valid_597822 = query.getOrDefault("$skip")
  valid_597822 = validateParameter(valid_597822, JInt, required = false, default = nil)
  if valid_597822 != nil:
    section.add "$skip", valid_597822
  var valid_597823 = query.getOrDefault("$filter")
  valid_597823 = validateParameter(valid_597823, JString, required = false,
                                 default = nil)
  if valid_597823 != nil:
    section.add "$filter", valid_597823
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597824: Call_ProductGroupsListByProduct_597813; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the collection of developer groups associated with the specified product.
  ## 
  let valid = call_597824.validator(path, query, header, formData, body)
  let scheme = call_597824.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597824.url(scheme.get, call_597824.host, call_597824.base,
                         call_597824.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597824, url, valid)

proc call*(call_597825: Call_ProductGroupsListByProduct_597813;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          productId: string; serviceName: string; Top: int = 0; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## productGroupsListByProduct
  ## Lists the collection of developer groups associated with the specified product.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | type        | eq, ne                 | N/A                                         |
  var path_597826 = newJObject()
  var query_597827 = newJObject()
  add(path_597826, "resourceGroupName", newJString(resourceGroupName))
  add(query_597827, "api-version", newJString(apiVersion))
  add(path_597826, "subscriptionId", newJString(subscriptionId))
  add(query_597827, "$top", newJInt(Top))
  add(query_597827, "$skip", newJInt(Skip))
  add(path_597826, "productId", newJString(productId))
  add(path_597826, "serviceName", newJString(serviceName))
  add(query_597827, "$filter", newJString(Filter))
  result = call_597825.call(path_597826, query_597827, nil, nil, nil)

var productGroupsListByProduct* = Call_ProductGroupsListByProduct_597813(
    name: "productGroupsListByProduct", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/groups",
    validator: validate_ProductGroupsListByProduct_597814, base: "",
    url: url_ProductGroupsListByProduct_597815, schemes: {Scheme.Https})
type
  Call_ProductGroupsAdd_597828 = ref object of OpenApiRestCall_596467
proc url_ProductGroupsAdd_597830(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  assert "groupId" in path, "`groupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductGroupsAdd_597829(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Adds the association between the specified developer group with the specified product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_597831 = path.getOrDefault("groupId")
  valid_597831 = validateParameter(valid_597831, JString, required = true,
                                 default = nil)
  if valid_597831 != nil:
    section.add "groupId", valid_597831
  var valid_597832 = path.getOrDefault("resourceGroupName")
  valid_597832 = validateParameter(valid_597832, JString, required = true,
                                 default = nil)
  if valid_597832 != nil:
    section.add "resourceGroupName", valid_597832
  var valid_597833 = path.getOrDefault("subscriptionId")
  valid_597833 = validateParameter(valid_597833, JString, required = true,
                                 default = nil)
  if valid_597833 != nil:
    section.add "subscriptionId", valid_597833
  var valid_597834 = path.getOrDefault("productId")
  valid_597834 = validateParameter(valid_597834, JString, required = true,
                                 default = nil)
  if valid_597834 != nil:
    section.add "productId", valid_597834
  var valid_597835 = path.getOrDefault("serviceName")
  valid_597835 = validateParameter(valid_597835, JString, required = true,
                                 default = nil)
  if valid_597835 != nil:
    section.add "serviceName", valid_597835
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597836 = query.getOrDefault("api-version")
  valid_597836 = validateParameter(valid_597836, JString, required = true,
                                 default = nil)
  if valid_597836 != nil:
    section.add "api-version", valid_597836
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597837: Call_ProductGroupsAdd_597828; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds the association between the specified developer group with the specified product.
  ## 
  let valid = call_597837.validator(path, query, header, formData, body)
  let scheme = call_597837.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597837.url(scheme.get, call_597837.host, call_597837.base,
                         call_597837.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597837, url, valid)

proc call*(call_597838: Call_ProductGroupsAdd_597828; groupId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          productId: string; serviceName: string): Recallable =
  ## productGroupsAdd
  ## Adds the association between the specified developer group with the specified product.
  ##   groupId: string (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597839 = newJObject()
  var query_597840 = newJObject()
  add(path_597839, "groupId", newJString(groupId))
  add(path_597839, "resourceGroupName", newJString(resourceGroupName))
  add(query_597840, "api-version", newJString(apiVersion))
  add(path_597839, "subscriptionId", newJString(subscriptionId))
  add(path_597839, "productId", newJString(productId))
  add(path_597839, "serviceName", newJString(serviceName))
  result = call_597838.call(path_597839, query_597840, nil, nil, nil)

var productGroupsAdd* = Call_ProductGroupsAdd_597828(name: "productGroupsAdd",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/groups/{groupId}",
    validator: validate_ProductGroupsAdd_597829, base: "",
    url: url_ProductGroupsAdd_597830, schemes: {Scheme.Https})
type
  Call_ProductGroupsRemove_597841 = ref object of OpenApiRestCall_596467
proc url_ProductGroupsRemove_597843(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  assert "groupId" in path, "`groupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductGroupsRemove_597842(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes the association between the specified group and product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_597844 = path.getOrDefault("groupId")
  valid_597844 = validateParameter(valid_597844, JString, required = true,
                                 default = nil)
  if valid_597844 != nil:
    section.add "groupId", valid_597844
  var valid_597845 = path.getOrDefault("resourceGroupName")
  valid_597845 = validateParameter(valid_597845, JString, required = true,
                                 default = nil)
  if valid_597845 != nil:
    section.add "resourceGroupName", valid_597845
  var valid_597846 = path.getOrDefault("subscriptionId")
  valid_597846 = validateParameter(valid_597846, JString, required = true,
                                 default = nil)
  if valid_597846 != nil:
    section.add "subscriptionId", valid_597846
  var valid_597847 = path.getOrDefault("productId")
  valid_597847 = validateParameter(valid_597847, JString, required = true,
                                 default = nil)
  if valid_597847 != nil:
    section.add "productId", valid_597847
  var valid_597848 = path.getOrDefault("serviceName")
  valid_597848 = validateParameter(valid_597848, JString, required = true,
                                 default = nil)
  if valid_597848 != nil:
    section.add "serviceName", valid_597848
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597849 = query.getOrDefault("api-version")
  valid_597849 = validateParameter(valid_597849, JString, required = true,
                                 default = nil)
  if valid_597849 != nil:
    section.add "api-version", valid_597849
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597850: Call_ProductGroupsRemove_597841; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the association between the specified group and product.
  ## 
  let valid = call_597850.validator(path, query, header, formData, body)
  let scheme = call_597850.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597850.url(scheme.get, call_597850.host, call_597850.base,
                         call_597850.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597850, url, valid)

proc call*(call_597851: Call_ProductGroupsRemove_597841; groupId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          productId: string; serviceName: string): Recallable =
  ## productGroupsRemove
  ## Deletes the association between the specified group and product.
  ##   groupId: string (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597852 = newJObject()
  var query_597853 = newJObject()
  add(path_597852, "groupId", newJString(groupId))
  add(path_597852, "resourceGroupName", newJString(resourceGroupName))
  add(query_597853, "api-version", newJString(apiVersion))
  add(path_597852, "subscriptionId", newJString(subscriptionId))
  add(path_597852, "productId", newJString(productId))
  add(path_597852, "serviceName", newJString(serviceName))
  result = call_597851.call(path_597852, query_597853, nil, nil, nil)

var productGroupsRemove* = Call_ProductGroupsRemove_597841(
    name: "productGroupsRemove", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/groups/{groupId}",
    validator: validate_ProductGroupsRemove_597842, base: "",
    url: url_ProductGroupsRemove_597843, schemes: {Scheme.Https})
type
  Call_ProductSubscriptionsListByProduct_597854 = ref object of OpenApiRestCall_596467
proc url_ProductSubscriptionsListByProduct_597856(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/subscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductSubscriptionsListByProduct_597855(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the collection of subscriptions to the specified product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597857 = path.getOrDefault("resourceGroupName")
  valid_597857 = validateParameter(valid_597857, JString, required = true,
                                 default = nil)
  if valid_597857 != nil:
    section.add "resourceGroupName", valid_597857
  var valid_597858 = path.getOrDefault("subscriptionId")
  valid_597858 = validateParameter(valid_597858, JString, required = true,
                                 default = nil)
  if valid_597858 != nil:
    section.add "subscriptionId", valid_597858
  var valid_597859 = path.getOrDefault("productId")
  valid_597859 = validateParameter(valid_597859, JString, required = true,
                                 default = nil)
  if valid_597859 != nil:
    section.add "productId", valid_597859
  var valid_597860 = path.getOrDefault("serviceName")
  valid_597860 = validateParameter(valid_597860, JString, required = true,
                                 default = nil)
  if valid_597860 != nil:
    section.add "serviceName", valid_597860
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field        | Supported operators    | Supported functions                         |
  ## 
  ## |--------------|------------------------|---------------------------------------------|
  ## | id           | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name         | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | stateComment | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | userId       | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | productId    | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | state        | eq                     |                                             |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597861 = query.getOrDefault("api-version")
  valid_597861 = validateParameter(valid_597861, JString, required = true,
                                 default = nil)
  if valid_597861 != nil:
    section.add "api-version", valid_597861
  var valid_597862 = query.getOrDefault("$top")
  valid_597862 = validateParameter(valid_597862, JInt, required = false, default = nil)
  if valid_597862 != nil:
    section.add "$top", valid_597862
  var valid_597863 = query.getOrDefault("$skip")
  valid_597863 = validateParameter(valid_597863, JInt, required = false, default = nil)
  if valid_597863 != nil:
    section.add "$skip", valid_597863
  var valid_597864 = query.getOrDefault("$filter")
  valid_597864 = validateParameter(valid_597864, JString, required = false,
                                 default = nil)
  if valid_597864 != nil:
    section.add "$filter", valid_597864
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597865: Call_ProductSubscriptionsListByProduct_597854;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the collection of subscriptions to the specified product.
  ## 
  let valid = call_597865.validator(path, query, header, formData, body)
  let scheme = call_597865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597865.url(scheme.get, call_597865.host, call_597865.base,
                         call_597865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597865, url, valid)

proc call*(call_597866: Call_ProductSubscriptionsListByProduct_597854;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          productId: string; serviceName: string; Top: int = 0; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## productSubscriptionsListByProduct
  ## Lists the collection of subscriptions to the specified product.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field        | Supported operators    | Supported functions                         |
  ## 
  ## |--------------|------------------------|---------------------------------------------|
  ## | id           | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name         | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | stateComment | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | userId       | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | productId    | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | state        | eq                     |                                             |
  var path_597867 = newJObject()
  var query_597868 = newJObject()
  add(path_597867, "resourceGroupName", newJString(resourceGroupName))
  add(query_597868, "api-version", newJString(apiVersion))
  add(path_597867, "subscriptionId", newJString(subscriptionId))
  add(query_597868, "$top", newJInt(Top))
  add(query_597868, "$skip", newJInt(Skip))
  add(path_597867, "productId", newJString(productId))
  add(path_597867, "serviceName", newJString(serviceName))
  add(query_597868, "$filter", newJString(Filter))
  result = call_597866.call(path_597867, query_597868, nil, nil, nil)

var productSubscriptionsListByProduct* = Call_ProductSubscriptionsListByProduct_597854(
    name: "productSubscriptionsListByProduct", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/subscriptions",
    validator: validate_ProductSubscriptionsListByProduct_597855, base: "",
    url: url_ProductSubscriptionsListByProduct_597856, schemes: {Scheme.Https})
type
  Call_PropertyListByService_597869 = ref object of OpenApiRestCall_596467
proc url_PropertyListByService_597871(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/properties")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PropertyListByService_597870(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of properties defined within a service instance.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt651775.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597872 = path.getOrDefault("resourceGroupName")
  valid_597872 = validateParameter(valid_597872, JString, required = true,
                                 default = nil)
  if valid_597872 != nil:
    section.add "resourceGroupName", valid_597872
  var valid_597873 = path.getOrDefault("subscriptionId")
  valid_597873 = validateParameter(valid_597873, JString, required = true,
                                 default = nil)
  if valid_597873 != nil:
    section.add "subscriptionId", valid_597873
  var valid_597874 = path.getOrDefault("serviceName")
  valid_597874 = validateParameter(valid_597874, JString, required = true,
                                 default = nil)
  if valid_597874 != nil:
    section.add "serviceName", valid_597874
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field | Supported operators    | Supported functions                                   |
  ## 
  ## |-------|------------------------|-------------------------------------------------------|
  ## | tags  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith, any, all |
  ## | name  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith           |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597875 = query.getOrDefault("api-version")
  valid_597875 = validateParameter(valid_597875, JString, required = true,
                                 default = nil)
  if valid_597875 != nil:
    section.add "api-version", valid_597875
  var valid_597876 = query.getOrDefault("$top")
  valid_597876 = validateParameter(valid_597876, JInt, required = false, default = nil)
  if valid_597876 != nil:
    section.add "$top", valid_597876
  var valid_597877 = query.getOrDefault("$skip")
  valid_597877 = validateParameter(valid_597877, JInt, required = false, default = nil)
  if valid_597877 != nil:
    section.add "$skip", valid_597877
  var valid_597878 = query.getOrDefault("$filter")
  valid_597878 = validateParameter(valid_597878, JString, required = false,
                                 default = nil)
  if valid_597878 != nil:
    section.add "$filter", valid_597878
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597879: Call_PropertyListByService_597869; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of properties defined within a service instance.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt651775.aspx
  let valid = call_597879.validator(path, query, header, formData, body)
  let scheme = call_597879.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597879.url(scheme.get, call_597879.host, call_597879.base,
                         call_597879.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597879, url, valid)

proc call*(call_597880: Call_PropertyListByService_597869;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## propertyListByService
  ## Lists a collection of properties defined within a service instance.
  ## https://msdn.microsoft.com/en-us/library/azure/mt651775.aspx
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field | Supported operators    | Supported functions                                   |
  ## 
  ## |-------|------------------------|-------------------------------------------------------|
  ## | tags  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith, any, all |
  ## | name  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith           |
  var path_597881 = newJObject()
  var query_597882 = newJObject()
  add(path_597881, "resourceGroupName", newJString(resourceGroupName))
  add(query_597882, "api-version", newJString(apiVersion))
  add(path_597881, "subscriptionId", newJString(subscriptionId))
  add(query_597882, "$top", newJInt(Top))
  add(query_597882, "$skip", newJInt(Skip))
  add(path_597881, "serviceName", newJString(serviceName))
  add(query_597882, "$filter", newJString(Filter))
  result = call_597880.call(path_597881, query_597882, nil, nil, nil)

var propertyListByService* = Call_PropertyListByService_597869(
    name: "propertyListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/properties",
    validator: validate_PropertyListByService_597870, base: "",
    url: url_PropertyListByService_597871, schemes: {Scheme.Https})
type
  Call_PropertyCreateOrUpdate_597895 = ref object of OpenApiRestCall_596467
proc url_PropertyCreateOrUpdate_597897(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "propId" in path, "`propId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/properties/"),
               (kind: VariableSegment, value: "propId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PropertyCreateOrUpdate_597896(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a property.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   propId: JString (required)
  ##         : Identifier of the property.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597898 = path.getOrDefault("resourceGroupName")
  valid_597898 = validateParameter(valid_597898, JString, required = true,
                                 default = nil)
  if valid_597898 != nil:
    section.add "resourceGroupName", valid_597898
  var valid_597899 = path.getOrDefault("subscriptionId")
  valid_597899 = validateParameter(valid_597899, JString, required = true,
                                 default = nil)
  if valid_597899 != nil:
    section.add "subscriptionId", valid_597899
  var valid_597900 = path.getOrDefault("propId")
  valid_597900 = validateParameter(valid_597900, JString, required = true,
                                 default = nil)
  if valid_597900 != nil:
    section.add "propId", valid_597900
  var valid_597901 = path.getOrDefault("serviceName")
  valid_597901 = validateParameter(valid_597901, JString, required = true,
                                 default = nil)
  if valid_597901 != nil:
    section.add "serviceName", valid_597901
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597902 = query.getOrDefault("api-version")
  valid_597902 = validateParameter(valid_597902, JString, required = true,
                                 default = nil)
  if valid_597902 != nil:
    section.add "api-version", valid_597902
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Create parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597904: Call_PropertyCreateOrUpdate_597895; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a property.
  ## 
  let valid = call_597904.validator(path, query, header, formData, body)
  let scheme = call_597904.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597904.url(scheme.get, call_597904.host, call_597904.base,
                         call_597904.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597904, url, valid)

proc call*(call_597905: Call_PropertyCreateOrUpdate_597895;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          propId: string; parameters: JsonNode; serviceName: string): Recallable =
  ## propertyCreateOrUpdate
  ## Creates or updates a property.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   propId: string (required)
  ##         : Identifier of the property.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597906 = newJObject()
  var query_597907 = newJObject()
  var body_597908 = newJObject()
  add(path_597906, "resourceGroupName", newJString(resourceGroupName))
  add(query_597907, "api-version", newJString(apiVersion))
  add(path_597906, "subscriptionId", newJString(subscriptionId))
  add(path_597906, "propId", newJString(propId))
  if parameters != nil:
    body_597908 = parameters
  add(path_597906, "serviceName", newJString(serviceName))
  result = call_597905.call(path_597906, query_597907, nil, nil, body_597908)

var propertyCreateOrUpdate* = Call_PropertyCreateOrUpdate_597895(
    name: "propertyCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/properties/{propId}",
    validator: validate_PropertyCreateOrUpdate_597896, base: "",
    url: url_PropertyCreateOrUpdate_597897, schemes: {Scheme.Https})
type
  Call_PropertyGet_597883 = ref object of OpenApiRestCall_596467
proc url_PropertyGet_597885(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "propId" in path, "`propId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/properties/"),
               (kind: VariableSegment, value: "propId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PropertyGet_597884(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the property specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   propId: JString (required)
  ##         : Identifier of the property.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597886 = path.getOrDefault("resourceGroupName")
  valid_597886 = validateParameter(valid_597886, JString, required = true,
                                 default = nil)
  if valid_597886 != nil:
    section.add "resourceGroupName", valid_597886
  var valid_597887 = path.getOrDefault("subscriptionId")
  valid_597887 = validateParameter(valid_597887, JString, required = true,
                                 default = nil)
  if valid_597887 != nil:
    section.add "subscriptionId", valid_597887
  var valid_597888 = path.getOrDefault("propId")
  valid_597888 = validateParameter(valid_597888, JString, required = true,
                                 default = nil)
  if valid_597888 != nil:
    section.add "propId", valid_597888
  var valid_597889 = path.getOrDefault("serviceName")
  valid_597889 = validateParameter(valid_597889, JString, required = true,
                                 default = nil)
  if valid_597889 != nil:
    section.add "serviceName", valid_597889
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597890 = query.getOrDefault("api-version")
  valid_597890 = validateParameter(valid_597890, JString, required = true,
                                 default = nil)
  if valid_597890 != nil:
    section.add "api-version", valid_597890
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597891: Call_PropertyGet_597883; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the property specified by its identifier.
  ## 
  let valid = call_597891.validator(path, query, header, formData, body)
  let scheme = call_597891.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597891.url(scheme.get, call_597891.host, call_597891.base,
                         call_597891.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597891, url, valid)

proc call*(call_597892: Call_PropertyGet_597883; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; propId: string;
          serviceName: string): Recallable =
  ## propertyGet
  ## Gets the details of the property specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   propId: string (required)
  ##         : Identifier of the property.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597893 = newJObject()
  var query_597894 = newJObject()
  add(path_597893, "resourceGroupName", newJString(resourceGroupName))
  add(query_597894, "api-version", newJString(apiVersion))
  add(path_597893, "subscriptionId", newJString(subscriptionId))
  add(path_597893, "propId", newJString(propId))
  add(path_597893, "serviceName", newJString(serviceName))
  result = call_597892.call(path_597893, query_597894, nil, nil, nil)

var propertyGet* = Call_PropertyGet_597883(name: "propertyGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/properties/{propId}",
                                        validator: validate_PropertyGet_597884,
                                        base: "", url: url_PropertyGet_597885,
                                        schemes: {Scheme.Https})
type
  Call_PropertyUpdate_597922 = ref object of OpenApiRestCall_596467
proc url_PropertyUpdate_597924(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "propId" in path, "`propId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/properties/"),
               (kind: VariableSegment, value: "propId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PropertyUpdate_597923(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates the specific property.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   propId: JString (required)
  ##         : Identifier of the property.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597925 = path.getOrDefault("resourceGroupName")
  valid_597925 = validateParameter(valid_597925, JString, required = true,
                                 default = nil)
  if valid_597925 != nil:
    section.add "resourceGroupName", valid_597925
  var valid_597926 = path.getOrDefault("subscriptionId")
  valid_597926 = validateParameter(valid_597926, JString, required = true,
                                 default = nil)
  if valid_597926 != nil:
    section.add "subscriptionId", valid_597926
  var valid_597927 = path.getOrDefault("propId")
  valid_597927 = validateParameter(valid_597927, JString, required = true,
                                 default = nil)
  if valid_597927 != nil:
    section.add "propId", valid_597927
  var valid_597928 = path.getOrDefault("serviceName")
  valid_597928 = validateParameter(valid_597928, JString, required = true,
                                 default = nil)
  if valid_597928 != nil:
    section.add "serviceName", valid_597928
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597929 = query.getOrDefault("api-version")
  valid_597929 = validateParameter(valid_597929, JString, required = true,
                                 default = nil)
  if valid_597929 != nil:
    section.add "api-version", valid_597929
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the property to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597930 = header.getOrDefault("If-Match")
  valid_597930 = validateParameter(valid_597930, JString, required = true,
                                 default = nil)
  if valid_597930 != nil:
    section.add "If-Match", valid_597930
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597932: Call_PropertyUpdate_597922; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specific property.
  ## 
  let valid = call_597932.validator(path, query, header, formData, body)
  let scheme = call_597932.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597932.url(scheme.get, call_597932.host, call_597932.base,
                         call_597932.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597932, url, valid)

proc call*(call_597933: Call_PropertyUpdate_597922; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; propId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## propertyUpdate
  ## Updates the specific property.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   propId: string (required)
  ##         : Identifier of the property.
  ##   parameters: JObject (required)
  ##             : Update parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597934 = newJObject()
  var query_597935 = newJObject()
  var body_597936 = newJObject()
  add(path_597934, "resourceGroupName", newJString(resourceGroupName))
  add(query_597935, "api-version", newJString(apiVersion))
  add(path_597934, "subscriptionId", newJString(subscriptionId))
  add(path_597934, "propId", newJString(propId))
  if parameters != nil:
    body_597936 = parameters
  add(path_597934, "serviceName", newJString(serviceName))
  result = call_597933.call(path_597934, query_597935, nil, nil, body_597936)

var propertyUpdate* = Call_PropertyUpdate_597922(name: "propertyUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/properties/{propId}",
    validator: validate_PropertyUpdate_597923, base: "", url: url_PropertyUpdate_597924,
    schemes: {Scheme.Https})
type
  Call_PropertyDelete_597909 = ref object of OpenApiRestCall_596467
proc url_PropertyDelete_597911(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "propId" in path, "`propId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/properties/"),
               (kind: VariableSegment, value: "propId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PropertyDelete_597910(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes specific property from the API Management service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   propId: JString (required)
  ##         : Identifier of the property.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597912 = path.getOrDefault("resourceGroupName")
  valid_597912 = validateParameter(valid_597912, JString, required = true,
                                 default = nil)
  if valid_597912 != nil:
    section.add "resourceGroupName", valid_597912
  var valid_597913 = path.getOrDefault("subscriptionId")
  valid_597913 = validateParameter(valid_597913, JString, required = true,
                                 default = nil)
  if valid_597913 != nil:
    section.add "subscriptionId", valid_597913
  var valid_597914 = path.getOrDefault("propId")
  valid_597914 = validateParameter(valid_597914, JString, required = true,
                                 default = nil)
  if valid_597914 != nil:
    section.add "propId", valid_597914
  var valid_597915 = path.getOrDefault("serviceName")
  valid_597915 = validateParameter(valid_597915, JString, required = true,
                                 default = nil)
  if valid_597915 != nil:
    section.add "serviceName", valid_597915
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597916 = query.getOrDefault("api-version")
  valid_597916 = validateParameter(valid_597916, JString, required = true,
                                 default = nil)
  if valid_597916 != nil:
    section.add "api-version", valid_597916
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the property to delete. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597917 = header.getOrDefault("If-Match")
  valid_597917 = validateParameter(valid_597917, JString, required = true,
                                 default = nil)
  if valid_597917 != nil:
    section.add "If-Match", valid_597917
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597918: Call_PropertyDelete_597909; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specific property from the API Management service instance.
  ## 
  let valid = call_597918.validator(path, query, header, formData, body)
  let scheme = call_597918.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597918.url(scheme.get, call_597918.host, call_597918.base,
                         call_597918.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597918, url, valid)

proc call*(call_597919: Call_PropertyDelete_597909; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; propId: string;
          serviceName: string): Recallable =
  ## propertyDelete
  ## Deletes specific property from the API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   propId: string (required)
  ##         : Identifier of the property.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597920 = newJObject()
  var query_597921 = newJObject()
  add(path_597920, "resourceGroupName", newJString(resourceGroupName))
  add(query_597921, "api-version", newJString(apiVersion))
  add(path_597920, "subscriptionId", newJString(subscriptionId))
  add(path_597920, "propId", newJString(propId))
  add(path_597920, "serviceName", newJString(serviceName))
  result = call_597919.call(path_597920, query_597921, nil, nil, nil)

var propertyDelete* = Call_PropertyDelete_597909(name: "propertyDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/properties/{propId}",
    validator: validate_PropertyDelete_597910, base: "", url: url_PropertyDelete_597911,
    schemes: {Scheme.Https})
type
  Call_QuotaByCounterKeysListByService_597937 = ref object of OpenApiRestCall_596467
proc url_QuotaByCounterKeysListByService_597939(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "quotaCounterKey" in path, "`quotaCounterKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/quotas/"),
               (kind: VariableSegment, value: "quotaCounterKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QuotaByCounterKeysListByService_597938(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of current quota counter periods associated with the counter-key configured in the policy on the specified service instance. The api does not support paging yet.
  ## 
  ## Document describing how to configure the quota policies.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-product-with-rules#a-namepolicies-ato-configure-call-rate-limit-and-quota-policies
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   quotaCounterKey: JString (required)
  ##                  : Quota counter key identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `quotaCounterKey` field"
  var valid_597940 = path.getOrDefault("quotaCounterKey")
  valid_597940 = validateParameter(valid_597940, JString, required = true,
                                 default = nil)
  if valid_597940 != nil:
    section.add "quotaCounterKey", valid_597940
  var valid_597941 = path.getOrDefault("resourceGroupName")
  valid_597941 = validateParameter(valid_597941, JString, required = true,
                                 default = nil)
  if valid_597941 != nil:
    section.add "resourceGroupName", valid_597941
  var valid_597942 = path.getOrDefault("subscriptionId")
  valid_597942 = validateParameter(valid_597942, JString, required = true,
                                 default = nil)
  if valid_597942 != nil:
    section.add "subscriptionId", valid_597942
  var valid_597943 = path.getOrDefault("serviceName")
  valid_597943 = validateParameter(valid_597943, JString, required = true,
                                 default = nil)
  if valid_597943 != nil:
    section.add "serviceName", valid_597943
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597944 = query.getOrDefault("api-version")
  valid_597944 = validateParameter(valid_597944, JString, required = true,
                                 default = nil)
  if valid_597944 != nil:
    section.add "api-version", valid_597944
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597945: Call_QuotaByCounterKeysListByService_597937;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists a collection of current quota counter periods associated with the counter-key configured in the policy on the specified service instance. The api does not support paging yet.
  ## 
  ## Document describing how to configure the quota policies.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-product-with-rules#a-namepolicies-ato-configure-call-rate-limit-and-quota-policies
  let valid = call_597945.validator(path, query, header, formData, body)
  let scheme = call_597945.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597945.url(scheme.get, call_597945.host, call_597945.base,
                         call_597945.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597945, url, valid)

proc call*(call_597946: Call_QuotaByCounterKeysListByService_597937;
          quotaCounterKey: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; serviceName: string): Recallable =
  ## quotaByCounterKeysListByService
  ## Lists a collection of current quota counter periods associated with the counter-key configured in the policy on the specified service instance. The api does not support paging yet.
  ## Document describing how to configure the quota policies.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-product-with-rules#a-namepolicies-ato-configure-call-rate-limit-and-quota-policies
  ##   quotaCounterKey: string (required)
  ##                  : Quota counter key identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597947 = newJObject()
  var query_597948 = newJObject()
  add(path_597947, "quotaCounterKey", newJString(quotaCounterKey))
  add(path_597947, "resourceGroupName", newJString(resourceGroupName))
  add(query_597948, "api-version", newJString(apiVersion))
  add(path_597947, "subscriptionId", newJString(subscriptionId))
  add(path_597947, "serviceName", newJString(serviceName))
  result = call_597946.call(path_597947, query_597948, nil, nil, nil)

var quotaByCounterKeysListByService* = Call_QuotaByCounterKeysListByService_597937(
    name: "quotaByCounterKeysListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/quotas/{quotaCounterKey}",
    validator: validate_QuotaByCounterKeysListByService_597938, base: "",
    url: url_QuotaByCounterKeysListByService_597939, schemes: {Scheme.Https})
type
  Call_QuotaByCounterKeysUpdate_597949 = ref object of OpenApiRestCall_596467
proc url_QuotaByCounterKeysUpdate_597951(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "quotaCounterKey" in path, "`quotaCounterKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/quotas/"),
               (kind: VariableSegment, value: "quotaCounterKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QuotaByCounterKeysUpdate_597950(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates all the quota counter values specified with the existing quota counter key to a value in the specified service instance. This should be used for reset of the quota counter values.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   quotaCounterKey: JString (required)
  ##                  : Quota counter key identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `quotaCounterKey` field"
  var valid_597952 = path.getOrDefault("quotaCounterKey")
  valid_597952 = validateParameter(valid_597952, JString, required = true,
                                 default = nil)
  if valid_597952 != nil:
    section.add "quotaCounterKey", valid_597952
  var valid_597953 = path.getOrDefault("resourceGroupName")
  valid_597953 = validateParameter(valid_597953, JString, required = true,
                                 default = nil)
  if valid_597953 != nil:
    section.add "resourceGroupName", valid_597953
  var valid_597954 = path.getOrDefault("subscriptionId")
  valid_597954 = validateParameter(valid_597954, JString, required = true,
                                 default = nil)
  if valid_597954 != nil:
    section.add "subscriptionId", valid_597954
  var valid_597955 = path.getOrDefault("serviceName")
  valid_597955 = validateParameter(valid_597955, JString, required = true,
                                 default = nil)
  if valid_597955 != nil:
    section.add "serviceName", valid_597955
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597956 = query.getOrDefault("api-version")
  valid_597956 = validateParameter(valid_597956, JString, required = true,
                                 default = nil)
  if valid_597956 != nil:
    section.add "api-version", valid_597956
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The value of the quota counter to be applied to all quota counter periods.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597958: Call_QuotaByCounterKeysUpdate_597949; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates all the quota counter values specified with the existing quota counter key to a value in the specified service instance. This should be used for reset of the quota counter values.
  ## 
  let valid = call_597958.validator(path, query, header, formData, body)
  let scheme = call_597958.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597958.url(scheme.get, call_597958.host, call_597958.base,
                         call_597958.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597958, url, valid)

proc call*(call_597959: Call_QuotaByCounterKeysUpdate_597949;
          quotaCounterKey: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode; serviceName: string): Recallable =
  ## quotaByCounterKeysUpdate
  ## Updates all the quota counter values specified with the existing quota counter key to a value in the specified service instance. This should be used for reset of the quota counter values.
  ##   quotaCounterKey: string (required)
  ##                  : Quota counter key identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The value of the quota counter to be applied to all quota counter periods.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597960 = newJObject()
  var query_597961 = newJObject()
  var body_597962 = newJObject()
  add(path_597960, "quotaCounterKey", newJString(quotaCounterKey))
  add(path_597960, "resourceGroupName", newJString(resourceGroupName))
  add(query_597961, "api-version", newJString(apiVersion))
  add(path_597960, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597962 = parameters
  add(path_597960, "serviceName", newJString(serviceName))
  result = call_597959.call(path_597960, query_597961, nil, nil, body_597962)

var quotaByCounterKeysUpdate* = Call_QuotaByCounterKeysUpdate_597949(
    name: "quotaByCounterKeysUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/quotas/{quotaCounterKey}",
    validator: validate_QuotaByCounterKeysUpdate_597950, base: "",
    url: url_QuotaByCounterKeysUpdate_597951, schemes: {Scheme.Https})
type
  Call_QuotaByPeriodKeysGet_597963 = ref object of OpenApiRestCall_596467
proc url_QuotaByPeriodKeysGet_597965(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "quotaCounterKey" in path, "`quotaCounterKey` is a required path parameter"
  assert "quotaPeriodKey" in path, "`quotaPeriodKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/quotas/"),
               (kind: VariableSegment, value: "quotaCounterKey"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "quotaPeriodKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QuotaByPeriodKeysGet_597964(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the value of the quota counter associated with the counter-key in the policy for the specific period in service instance.
  ## 
  ## Document describing how to configure the quota policies.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-product-with-rules#a-namepolicies-ato-configure-call-rate-limit-and-quota-policies
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   quotaCounterKey: JString (required)
  ##                  : Quota counter key identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   quotaPeriodKey: JString (required)
  ##                 : Quota period key identifier.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `quotaCounterKey` field"
  var valid_597966 = path.getOrDefault("quotaCounterKey")
  valid_597966 = validateParameter(valid_597966, JString, required = true,
                                 default = nil)
  if valid_597966 != nil:
    section.add "quotaCounterKey", valid_597966
  var valid_597967 = path.getOrDefault("resourceGroupName")
  valid_597967 = validateParameter(valid_597967, JString, required = true,
                                 default = nil)
  if valid_597967 != nil:
    section.add "resourceGroupName", valid_597967
  var valid_597968 = path.getOrDefault("quotaPeriodKey")
  valid_597968 = validateParameter(valid_597968, JString, required = true,
                                 default = nil)
  if valid_597968 != nil:
    section.add "quotaPeriodKey", valid_597968
  var valid_597969 = path.getOrDefault("subscriptionId")
  valid_597969 = validateParameter(valid_597969, JString, required = true,
                                 default = nil)
  if valid_597969 != nil:
    section.add "subscriptionId", valid_597969
  var valid_597970 = path.getOrDefault("serviceName")
  valid_597970 = validateParameter(valid_597970, JString, required = true,
                                 default = nil)
  if valid_597970 != nil:
    section.add "serviceName", valid_597970
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597971 = query.getOrDefault("api-version")
  valid_597971 = validateParameter(valid_597971, JString, required = true,
                                 default = nil)
  if valid_597971 != nil:
    section.add "api-version", valid_597971
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597972: Call_QuotaByPeriodKeysGet_597963; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the value of the quota counter associated with the counter-key in the policy for the specific period in service instance.
  ## 
  ## Document describing how to configure the quota policies.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-product-with-rules#a-namepolicies-ato-configure-call-rate-limit-and-quota-policies
  let valid = call_597972.validator(path, query, header, formData, body)
  let scheme = call_597972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597972.url(scheme.get, call_597972.host, call_597972.base,
                         call_597972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597972, url, valid)

proc call*(call_597973: Call_QuotaByPeriodKeysGet_597963; quotaCounterKey: string;
          resourceGroupName: string; apiVersion: string; quotaPeriodKey: string;
          subscriptionId: string; serviceName: string): Recallable =
  ## quotaByPeriodKeysGet
  ## Gets the value of the quota counter associated with the counter-key in the policy for the specific period in service instance.
  ## Document describing how to configure the quota policies.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-product-with-rules#a-namepolicies-ato-configure-call-rate-limit-and-quota-policies
  ##   quotaCounterKey: string (required)
  ##                  : Quota counter key identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   quotaPeriodKey: string (required)
  ##                 : Quota period key identifier.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597974 = newJObject()
  var query_597975 = newJObject()
  add(path_597974, "quotaCounterKey", newJString(quotaCounterKey))
  add(path_597974, "resourceGroupName", newJString(resourceGroupName))
  add(query_597975, "api-version", newJString(apiVersion))
  add(path_597974, "quotaPeriodKey", newJString(quotaPeriodKey))
  add(path_597974, "subscriptionId", newJString(subscriptionId))
  add(path_597974, "serviceName", newJString(serviceName))
  result = call_597973.call(path_597974, query_597975, nil, nil, nil)

var quotaByPeriodKeysGet* = Call_QuotaByPeriodKeysGet_597963(
    name: "quotaByPeriodKeysGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/quotas/{quotaCounterKey}/{quotaPeriodKey}",
    validator: validate_QuotaByPeriodKeysGet_597964, base: "",
    url: url_QuotaByPeriodKeysGet_597965, schemes: {Scheme.Https})
type
  Call_QuotaByPeriodKeysUpdate_597976 = ref object of OpenApiRestCall_596467
proc url_QuotaByPeriodKeysUpdate_597978(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "quotaCounterKey" in path, "`quotaCounterKey` is a required path parameter"
  assert "quotaPeriodKey" in path, "`quotaPeriodKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/quotas/"),
               (kind: VariableSegment, value: "quotaCounterKey"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "quotaPeriodKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QuotaByPeriodKeysUpdate_597977(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing quota counter value in the specified service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   quotaCounterKey: JString (required)
  ##                  : Quota counter key identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   quotaPeriodKey: JString (required)
  ##                 : Quota period key identifier.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `quotaCounterKey` field"
  var valid_597979 = path.getOrDefault("quotaCounterKey")
  valid_597979 = validateParameter(valid_597979, JString, required = true,
                                 default = nil)
  if valid_597979 != nil:
    section.add "quotaCounterKey", valid_597979
  var valid_597980 = path.getOrDefault("resourceGroupName")
  valid_597980 = validateParameter(valid_597980, JString, required = true,
                                 default = nil)
  if valid_597980 != nil:
    section.add "resourceGroupName", valid_597980
  var valid_597981 = path.getOrDefault("quotaPeriodKey")
  valid_597981 = validateParameter(valid_597981, JString, required = true,
                                 default = nil)
  if valid_597981 != nil:
    section.add "quotaPeriodKey", valid_597981
  var valid_597982 = path.getOrDefault("subscriptionId")
  valid_597982 = validateParameter(valid_597982, JString, required = true,
                                 default = nil)
  if valid_597982 != nil:
    section.add "subscriptionId", valid_597982
  var valid_597983 = path.getOrDefault("serviceName")
  valid_597983 = validateParameter(valid_597983, JString, required = true,
                                 default = nil)
  if valid_597983 != nil:
    section.add "serviceName", valid_597983
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597984 = query.getOrDefault("api-version")
  valid_597984 = validateParameter(valid_597984, JString, required = true,
                                 default = nil)
  if valid_597984 != nil:
    section.add "api-version", valid_597984
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The value of the Quota counter to be applied on the specified period.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597986: Call_QuotaByPeriodKeysUpdate_597976; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing quota counter value in the specified service instance.
  ## 
  let valid = call_597986.validator(path, query, header, formData, body)
  let scheme = call_597986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597986.url(scheme.get, call_597986.host, call_597986.base,
                         call_597986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597986, url, valid)

proc call*(call_597987: Call_QuotaByPeriodKeysUpdate_597976;
          quotaCounterKey: string; resourceGroupName: string; apiVersion: string;
          quotaPeriodKey: string; subscriptionId: string; parameters: JsonNode;
          serviceName: string): Recallable =
  ## quotaByPeriodKeysUpdate
  ## Updates an existing quota counter value in the specified service instance.
  ##   quotaCounterKey: string (required)
  ##                  : Quota counter key identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   quotaPeriodKey: string (required)
  ##                 : Quota period key identifier.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The value of the Quota counter to be applied on the specified period.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597988 = newJObject()
  var query_597989 = newJObject()
  var body_597990 = newJObject()
  add(path_597988, "quotaCounterKey", newJString(quotaCounterKey))
  add(path_597988, "resourceGroupName", newJString(resourceGroupName))
  add(query_597989, "api-version", newJString(apiVersion))
  add(path_597988, "quotaPeriodKey", newJString(quotaPeriodKey))
  add(path_597988, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597990 = parameters
  add(path_597988, "serviceName", newJString(serviceName))
  result = call_597987.call(path_597988, query_597989, nil, nil, body_597990)

var quotaByPeriodKeysUpdate* = Call_QuotaByPeriodKeysUpdate_597976(
    name: "quotaByPeriodKeysUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/quotas/{quotaCounterKey}/{quotaPeriodKey}",
    validator: validate_QuotaByPeriodKeysUpdate_597977, base: "",
    url: url_QuotaByPeriodKeysUpdate_597978, schemes: {Scheme.Https})
type
  Call_RegionsListByService_597991 = ref object of OpenApiRestCall_596467
proc url_RegionsListByService_597993(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/regions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegionsListByService_597992(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all azure regions in which the service exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597994 = path.getOrDefault("resourceGroupName")
  valid_597994 = validateParameter(valid_597994, JString, required = true,
                                 default = nil)
  if valid_597994 != nil:
    section.add "resourceGroupName", valid_597994
  var valid_597995 = path.getOrDefault("subscriptionId")
  valid_597995 = validateParameter(valid_597995, JString, required = true,
                                 default = nil)
  if valid_597995 != nil:
    section.add "subscriptionId", valid_597995
  var valid_597996 = path.getOrDefault("serviceName")
  valid_597996 = validateParameter(valid_597996, JString, required = true,
                                 default = nil)
  if valid_597996 != nil:
    section.add "serviceName", valid_597996
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597997 = query.getOrDefault("api-version")
  valid_597997 = validateParameter(valid_597997, JString, required = true,
                                 default = nil)
  if valid_597997 != nil:
    section.add "api-version", valid_597997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597998: Call_RegionsListByService_597991; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all azure regions in which the service exists.
  ## 
  let valid = call_597998.validator(path, query, header, formData, body)
  let scheme = call_597998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597998.url(scheme.get, call_597998.host, call_597998.base,
                         call_597998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597998, url, valid)

proc call*(call_597999: Call_RegionsListByService_597991;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## regionsListByService
  ## Lists all azure regions in which the service exists.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_598000 = newJObject()
  var query_598001 = newJObject()
  add(path_598000, "resourceGroupName", newJString(resourceGroupName))
  add(query_598001, "api-version", newJString(apiVersion))
  add(path_598000, "subscriptionId", newJString(subscriptionId))
  add(path_598000, "serviceName", newJString(serviceName))
  result = call_597999.call(path_598000, query_598001, nil, nil, nil)

var regionsListByService* = Call_RegionsListByService_597991(
    name: "regionsListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/regions",
    validator: validate_RegionsListByService_597992, base: "",
    url: url_RegionsListByService_597993, schemes: {Scheme.Https})
type
  Call_ReportsListByService_598002 = ref object of OpenApiRestCall_596467
proc url_ReportsListByService_598004(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "aggregation" in path, "`aggregation` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/reports/"),
               (kind: VariableSegment, value: "aggregation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportsListByService_598003(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists report records.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   aggregation: JString (required)
  ##              : Report aggregation.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_598005 = path.getOrDefault("resourceGroupName")
  valid_598005 = validateParameter(valid_598005, JString, required = true,
                                 default = nil)
  if valid_598005 != nil:
    section.add "resourceGroupName", valid_598005
  var valid_598006 = path.getOrDefault("subscriptionId")
  valid_598006 = validateParameter(valid_598006, JString, required = true,
                                 default = nil)
  if valid_598006 != nil:
    section.add "subscriptionId", valid_598006
  var valid_598007 = path.getOrDefault("aggregation")
  valid_598007 = validateParameter(valid_598007, JString, required = true,
                                 default = newJString("byApi"))
  if valid_598007 != nil:
    section.add "aggregation", valid_598007
  var valid_598008 = path.getOrDefault("serviceName")
  valid_598008 = validateParameter(valid_598008, JString, required = true,
                                 default = nil)
  if valid_598008 != nil:
    section.add "serviceName", valid_598008
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   interval: JString
  ##           : By time interval. This value is only applicable to ByTime aggregation. Interval must be multiple of 15 minutes and may not be zero. The value should be in ISO  8601 format (http://en.wikipedia.org/wiki/ISO_8601#Durations).This code can be used to convert TimSpan to a valid interval string: XmlConvert.ToString(new TimeSpan(hours, minutes, seconds))
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_598009 = query.getOrDefault("api-version")
  valid_598009 = validateParameter(valid_598009, JString, required = true,
                                 default = nil)
  if valid_598009 != nil:
    section.add "api-version", valid_598009
  var valid_598010 = query.getOrDefault("$top")
  valid_598010 = validateParameter(valid_598010, JInt, required = false, default = nil)
  if valid_598010 != nil:
    section.add "$top", valid_598010
  var valid_598011 = query.getOrDefault("$skip")
  valid_598011 = validateParameter(valid_598011, JInt, required = false, default = nil)
  if valid_598011 != nil:
    section.add "$skip", valid_598011
  var valid_598012 = query.getOrDefault("interval")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = nil)
  if valid_598012 != nil:
    section.add "interval", valid_598012
  var valid_598013 = query.getOrDefault("$filter")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = nil)
  if valid_598013 != nil:
    section.add "$filter", valid_598013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598014: Call_ReportsListByService_598002; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records.
  ## 
  let valid = call_598014.validator(path, query, header, formData, body)
  let scheme = call_598014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598014.url(scheme.get, call_598014.host, call_598014.base,
                         call_598014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598014, url, valid)

proc call*(call_598015: Call_ReportsListByService_598002;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; Top: int = 0; Skip: int = 0; interval: string = "";
          aggregation: string = "byApi"; Filter: string = ""): Recallable =
  ## reportsListByService
  ## Lists report records.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   interval: string
  ##           : By time interval. This value is only applicable to ByTime aggregation. Interval must be multiple of 15 minutes and may not be zero. The value should be in ISO  8601 format (http://en.wikipedia.org/wiki/ISO_8601#Durations).This code can be used to convert TimSpan to a valid interval string: XmlConvert.ToString(new TimeSpan(hours, minutes, seconds))
  ##   aggregation: string (required)
  ##              : Report aggregation.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_598016 = newJObject()
  var query_598017 = newJObject()
  add(path_598016, "resourceGroupName", newJString(resourceGroupName))
  add(query_598017, "api-version", newJString(apiVersion))
  add(path_598016, "subscriptionId", newJString(subscriptionId))
  add(query_598017, "$top", newJInt(Top))
  add(query_598017, "$skip", newJInt(Skip))
  add(query_598017, "interval", newJString(interval))
  add(path_598016, "aggregation", newJString(aggregation))
  add(path_598016, "serviceName", newJString(serviceName))
  add(query_598017, "$filter", newJString(Filter))
  result = call_598015.call(path_598016, query_598017, nil, nil, nil)

var reportsListByService* = Call_ReportsListByService_598002(
    name: "reportsListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/reports/{aggregation}",
    validator: validate_ReportsListByService_598003, base: "",
    url: url_ReportsListByService_598004, schemes: {Scheme.Https})
type
  Call_SubscriptionsListByService_598018 = ref object of OpenApiRestCall_596467
proc url_SubscriptionsListByService_598020(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/subscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionsListByService_598019(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all subscriptions of the API Management service instance.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/dn776325.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_598021 = path.getOrDefault("resourceGroupName")
  valid_598021 = validateParameter(valid_598021, JString, required = true,
                                 default = nil)
  if valid_598021 != nil:
    section.add "resourceGroupName", valid_598021
  var valid_598022 = path.getOrDefault("subscriptionId")
  valid_598022 = validateParameter(valid_598022, JString, required = true,
                                 default = nil)
  if valid_598022 != nil:
    section.add "subscriptionId", valid_598022
  var valid_598023 = path.getOrDefault("serviceName")
  valid_598023 = validateParameter(valid_598023, JString, required = true,
                                 default = nil)
  if valid_598023 != nil:
    section.add "serviceName", valid_598023
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field        | Supported operators    | Supported functions                         |
  ## 
  ## |--------------|------------------------|---------------------------------------------|
  ## | id           | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name         | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | stateComment | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | userId       | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | productId    | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | state        | eq                     |                                             |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_598024 = query.getOrDefault("api-version")
  valid_598024 = validateParameter(valid_598024, JString, required = true,
                                 default = nil)
  if valid_598024 != nil:
    section.add "api-version", valid_598024
  var valid_598025 = query.getOrDefault("$top")
  valid_598025 = validateParameter(valid_598025, JInt, required = false, default = nil)
  if valid_598025 != nil:
    section.add "$top", valid_598025
  var valid_598026 = query.getOrDefault("$skip")
  valid_598026 = validateParameter(valid_598026, JInt, required = false, default = nil)
  if valid_598026 != nil:
    section.add "$skip", valid_598026
  var valid_598027 = query.getOrDefault("$filter")
  valid_598027 = validateParameter(valid_598027, JString, required = false,
                                 default = nil)
  if valid_598027 != nil:
    section.add "$filter", valid_598027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598028: Call_SubscriptionsListByService_598018; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all subscriptions of the API Management service instance.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/dn776325.aspx
  let valid = call_598028.validator(path, query, header, formData, body)
  let scheme = call_598028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598028.url(scheme.get, call_598028.host, call_598028.base,
                         call_598028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598028, url, valid)

proc call*(call_598029: Call_SubscriptionsListByService_598018;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## subscriptionsListByService
  ## Lists all subscriptions of the API Management service instance.
  ## https://msdn.microsoft.com/en-us/library/azure/dn776325.aspx
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field        | Supported operators    | Supported functions                         |
  ## 
  ## |--------------|------------------------|---------------------------------------------|
  ## | id           | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name         | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | stateComment | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | userId       | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | productId    | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | state        | eq                     |                                             |
  var path_598030 = newJObject()
  var query_598031 = newJObject()
  add(path_598030, "resourceGroupName", newJString(resourceGroupName))
  add(query_598031, "api-version", newJString(apiVersion))
  add(path_598030, "subscriptionId", newJString(subscriptionId))
  add(query_598031, "$top", newJInt(Top))
  add(query_598031, "$skip", newJInt(Skip))
  add(path_598030, "serviceName", newJString(serviceName))
  add(query_598031, "$filter", newJString(Filter))
  result = call_598029.call(path_598030, query_598031, nil, nil, nil)

var subscriptionsListByService* = Call_SubscriptionsListByService_598018(
    name: "subscriptionsListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/subscriptions",
    validator: validate_SubscriptionsListByService_598019, base: "",
    url: url_SubscriptionsListByService_598020, schemes: {Scheme.Https})
type
  Call_SubscriptionsCreateOrUpdate_598044 = ref object of OpenApiRestCall_596467
proc url_SubscriptionsCreateOrUpdate_598046(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "sid" in path, "`sid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "sid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionsCreateOrUpdate_598045(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the subscription of specified user to the specified product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   sid: JString (required)
  ##      : Identifier of the subscription.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_598047 = path.getOrDefault("resourceGroupName")
  valid_598047 = validateParameter(valid_598047, JString, required = true,
                                 default = nil)
  if valid_598047 != nil:
    section.add "resourceGroupName", valid_598047
  var valid_598048 = path.getOrDefault("subscriptionId")
  valid_598048 = validateParameter(valid_598048, JString, required = true,
                                 default = nil)
  if valid_598048 != nil:
    section.add "subscriptionId", valid_598048
  var valid_598049 = path.getOrDefault("sid")
  valid_598049 = validateParameter(valid_598049, JString, required = true,
                                 default = nil)
  if valid_598049 != nil:
    section.add "sid", valid_598049
  var valid_598050 = path.getOrDefault("serviceName")
  valid_598050 = validateParameter(valid_598050, JString, required = true,
                                 default = nil)
  if valid_598050 != nil:
    section.add "serviceName", valid_598050
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_598051 = query.getOrDefault("api-version")
  valid_598051 = validateParameter(valid_598051, JString, required = true,
                                 default = nil)
  if valid_598051 != nil:
    section.add "api-version", valid_598051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Create parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_598053: Call_SubscriptionsCreateOrUpdate_598044; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the subscription of specified user to the specified product.
  ## 
  let valid = call_598053.validator(path, query, header, formData, body)
  let scheme = call_598053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598053.url(scheme.get, call_598053.host, call_598053.base,
                         call_598053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598053, url, valid)

proc call*(call_598054: Call_SubscriptionsCreateOrUpdate_598044;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; sid: string; serviceName: string): Recallable =
  ## subscriptionsCreateOrUpdate
  ## Creates or updates the subscription of specified user to the specified product.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  ##   sid: string (required)
  ##      : Identifier of the subscription.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_598055 = newJObject()
  var query_598056 = newJObject()
  var body_598057 = newJObject()
  add(path_598055, "resourceGroupName", newJString(resourceGroupName))
  add(query_598056, "api-version", newJString(apiVersion))
  add(path_598055, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_598057 = parameters
  add(path_598055, "sid", newJString(sid))
  add(path_598055, "serviceName", newJString(serviceName))
  result = call_598054.call(path_598055, query_598056, nil, nil, body_598057)

var subscriptionsCreateOrUpdate* = Call_SubscriptionsCreateOrUpdate_598044(
    name: "subscriptionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/subscriptions/{sid}",
    validator: validate_SubscriptionsCreateOrUpdate_598045, base: "",
    url: url_SubscriptionsCreateOrUpdate_598046, schemes: {Scheme.Https})
type
  Call_SubscriptionsGet_598032 = ref object of OpenApiRestCall_596467
proc url_SubscriptionsGet_598034(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "sid" in path, "`sid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "sid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionsGet_598033(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets the specified Subscription entity.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   sid: JString (required)
  ##      : Identifier of the subscription.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_598035 = path.getOrDefault("resourceGroupName")
  valid_598035 = validateParameter(valid_598035, JString, required = true,
                                 default = nil)
  if valid_598035 != nil:
    section.add "resourceGroupName", valid_598035
  var valid_598036 = path.getOrDefault("subscriptionId")
  valid_598036 = validateParameter(valid_598036, JString, required = true,
                                 default = nil)
  if valid_598036 != nil:
    section.add "subscriptionId", valid_598036
  var valid_598037 = path.getOrDefault("sid")
  valid_598037 = validateParameter(valid_598037, JString, required = true,
                                 default = nil)
  if valid_598037 != nil:
    section.add "sid", valid_598037
  var valid_598038 = path.getOrDefault("serviceName")
  valid_598038 = validateParameter(valid_598038, JString, required = true,
                                 default = nil)
  if valid_598038 != nil:
    section.add "serviceName", valid_598038
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_598039 = query.getOrDefault("api-version")
  valid_598039 = validateParameter(valid_598039, JString, required = true,
                                 default = nil)
  if valid_598039 != nil:
    section.add "api-version", valid_598039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598040: Call_SubscriptionsGet_598032; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified Subscription entity.
  ## 
  let valid = call_598040.validator(path, query, header, formData, body)
  let scheme = call_598040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598040.url(scheme.get, call_598040.host, call_598040.base,
                         call_598040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598040, url, valid)

proc call*(call_598041: Call_SubscriptionsGet_598032; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; sid: string; serviceName: string): Recallable =
  ## subscriptionsGet
  ## Gets the specified Subscription entity.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   sid: string (required)
  ##      : Identifier of the subscription.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_598042 = newJObject()
  var query_598043 = newJObject()
  add(path_598042, "resourceGroupName", newJString(resourceGroupName))
  add(query_598043, "api-version", newJString(apiVersion))
  add(path_598042, "subscriptionId", newJString(subscriptionId))
  add(path_598042, "sid", newJString(sid))
  add(path_598042, "serviceName", newJString(serviceName))
  result = call_598041.call(path_598042, query_598043, nil, nil, nil)

var subscriptionsGet* = Call_SubscriptionsGet_598032(name: "subscriptionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/subscriptions/{sid}",
    validator: validate_SubscriptionsGet_598033, base: "",
    url: url_SubscriptionsGet_598034, schemes: {Scheme.Https})
type
  Call_SubscriptionsUpdate_598071 = ref object of OpenApiRestCall_596467
proc url_SubscriptionsUpdate_598073(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "sid" in path, "`sid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "sid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionsUpdate_598072(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates the details of a subscription specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   sid: JString (required)
  ##      : Identifier of the subscription.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_598074 = path.getOrDefault("resourceGroupName")
  valid_598074 = validateParameter(valid_598074, JString, required = true,
                                 default = nil)
  if valid_598074 != nil:
    section.add "resourceGroupName", valid_598074
  var valid_598075 = path.getOrDefault("subscriptionId")
  valid_598075 = validateParameter(valid_598075, JString, required = true,
                                 default = nil)
  if valid_598075 != nil:
    section.add "subscriptionId", valid_598075
  var valid_598076 = path.getOrDefault("sid")
  valid_598076 = validateParameter(valid_598076, JString, required = true,
                                 default = nil)
  if valid_598076 != nil:
    section.add "sid", valid_598076
  var valid_598077 = path.getOrDefault("serviceName")
  valid_598077 = validateParameter(valid_598077, JString, required = true,
                                 default = nil)
  if valid_598077 != nil:
    section.add "serviceName", valid_598077
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_598078 = query.getOrDefault("api-version")
  valid_598078 = validateParameter(valid_598078, JString, required = true,
                                 default = nil)
  if valid_598078 != nil:
    section.add "api-version", valid_598078
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Subscription Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_598079 = header.getOrDefault("If-Match")
  valid_598079 = validateParameter(valid_598079, JString, required = true,
                                 default = nil)
  if valid_598079 != nil:
    section.add "If-Match", valid_598079
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_598081: Call_SubscriptionsUpdate_598071; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of a subscription specified by its identifier.
  ## 
  let valid = call_598081.validator(path, query, header, formData, body)
  let scheme = call_598081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598081.url(scheme.get, call_598081.host, call_598081.base,
                         call_598081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598081, url, valid)

proc call*(call_598082: Call_SubscriptionsUpdate_598071; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          sid: string; serviceName: string): Recallable =
  ## subscriptionsUpdate
  ## Updates the details of a subscription specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Update parameters.
  ##   sid: string (required)
  ##      : Identifier of the subscription.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_598083 = newJObject()
  var query_598084 = newJObject()
  var body_598085 = newJObject()
  add(path_598083, "resourceGroupName", newJString(resourceGroupName))
  add(query_598084, "api-version", newJString(apiVersion))
  add(path_598083, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_598085 = parameters
  add(path_598083, "sid", newJString(sid))
  add(path_598083, "serviceName", newJString(serviceName))
  result = call_598082.call(path_598083, query_598084, nil, nil, body_598085)

var subscriptionsUpdate* = Call_SubscriptionsUpdate_598071(
    name: "subscriptionsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/subscriptions/{sid}",
    validator: validate_SubscriptionsUpdate_598072, base: "",
    url: url_SubscriptionsUpdate_598073, schemes: {Scheme.Https})
type
  Call_SubscriptionsDelete_598058 = ref object of OpenApiRestCall_596467
proc url_SubscriptionsDelete_598060(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "sid" in path, "`sid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "sid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionsDelete_598059(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes the specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   sid: JString (required)
  ##      : Identifier of the subscription.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_598061 = path.getOrDefault("resourceGroupName")
  valid_598061 = validateParameter(valid_598061, JString, required = true,
                                 default = nil)
  if valid_598061 != nil:
    section.add "resourceGroupName", valid_598061
  var valid_598062 = path.getOrDefault("subscriptionId")
  valid_598062 = validateParameter(valid_598062, JString, required = true,
                                 default = nil)
  if valid_598062 != nil:
    section.add "subscriptionId", valid_598062
  var valid_598063 = path.getOrDefault("sid")
  valid_598063 = validateParameter(valid_598063, JString, required = true,
                                 default = nil)
  if valid_598063 != nil:
    section.add "sid", valid_598063
  var valid_598064 = path.getOrDefault("serviceName")
  valid_598064 = validateParameter(valid_598064, JString, required = true,
                                 default = nil)
  if valid_598064 != nil:
    section.add "serviceName", valid_598064
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_598065 = query.getOrDefault("api-version")
  valid_598065 = validateParameter(valid_598065, JString, required = true,
                                 default = nil)
  if valid_598065 != nil:
    section.add "api-version", valid_598065
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Subscription Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_598066 = header.getOrDefault("If-Match")
  valid_598066 = validateParameter(valid_598066, JString, required = true,
                                 default = nil)
  if valid_598066 != nil:
    section.add "If-Match", valid_598066
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598067: Call_SubscriptionsDelete_598058; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified subscription.
  ## 
  let valid = call_598067.validator(path, query, header, formData, body)
  let scheme = call_598067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598067.url(scheme.get, call_598067.host, call_598067.base,
                         call_598067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598067, url, valid)

proc call*(call_598068: Call_SubscriptionsDelete_598058; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; sid: string; serviceName: string): Recallable =
  ## subscriptionsDelete
  ## Deletes the specified subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   sid: string (required)
  ##      : Identifier of the subscription.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_598069 = newJObject()
  var query_598070 = newJObject()
  add(path_598069, "resourceGroupName", newJString(resourceGroupName))
  add(query_598070, "api-version", newJString(apiVersion))
  add(path_598069, "subscriptionId", newJString(subscriptionId))
  add(path_598069, "sid", newJString(sid))
  add(path_598069, "serviceName", newJString(serviceName))
  result = call_598068.call(path_598069, query_598070, nil, nil, nil)

var subscriptionsDelete* = Call_SubscriptionsDelete_598058(
    name: "subscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/subscriptions/{sid}",
    validator: validate_SubscriptionsDelete_598059, base: "",
    url: url_SubscriptionsDelete_598060, schemes: {Scheme.Https})
type
  Call_SubscriptionsRegeneratePrimaryKey_598086 = ref object of OpenApiRestCall_596467
proc url_SubscriptionsRegeneratePrimaryKey_598088(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "sid" in path, "`sid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "sid"),
               (kind: ConstantSegment, value: "/regeneratePrimaryKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionsRegeneratePrimaryKey_598087(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates primary key of existing subscription of the API Management service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   sid: JString (required)
  ##      : Identifier of the subscription.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_598089 = path.getOrDefault("resourceGroupName")
  valid_598089 = validateParameter(valid_598089, JString, required = true,
                                 default = nil)
  if valid_598089 != nil:
    section.add "resourceGroupName", valid_598089
  var valid_598090 = path.getOrDefault("subscriptionId")
  valid_598090 = validateParameter(valid_598090, JString, required = true,
                                 default = nil)
  if valid_598090 != nil:
    section.add "subscriptionId", valid_598090
  var valid_598091 = path.getOrDefault("sid")
  valid_598091 = validateParameter(valid_598091, JString, required = true,
                                 default = nil)
  if valid_598091 != nil:
    section.add "sid", valid_598091
  var valid_598092 = path.getOrDefault("serviceName")
  valid_598092 = validateParameter(valid_598092, JString, required = true,
                                 default = nil)
  if valid_598092 != nil:
    section.add "serviceName", valid_598092
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_598093 = query.getOrDefault("api-version")
  valid_598093 = validateParameter(valid_598093, JString, required = true,
                                 default = nil)
  if valid_598093 != nil:
    section.add "api-version", valid_598093
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598094: Call_SubscriptionsRegeneratePrimaryKey_598086;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerates primary key of existing subscription of the API Management service instance.
  ## 
  let valid = call_598094.validator(path, query, header, formData, body)
  let scheme = call_598094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598094.url(scheme.get, call_598094.host, call_598094.base,
                         call_598094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598094, url, valid)

proc call*(call_598095: Call_SubscriptionsRegeneratePrimaryKey_598086;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          sid: string; serviceName: string): Recallable =
  ## subscriptionsRegeneratePrimaryKey
  ## Regenerates primary key of existing subscription of the API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   sid: string (required)
  ##      : Identifier of the subscription.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_598096 = newJObject()
  var query_598097 = newJObject()
  add(path_598096, "resourceGroupName", newJString(resourceGroupName))
  add(query_598097, "api-version", newJString(apiVersion))
  add(path_598096, "subscriptionId", newJString(subscriptionId))
  add(path_598096, "sid", newJString(sid))
  add(path_598096, "serviceName", newJString(serviceName))
  result = call_598095.call(path_598096, query_598097, nil, nil, nil)

var subscriptionsRegeneratePrimaryKey* = Call_SubscriptionsRegeneratePrimaryKey_598086(
    name: "subscriptionsRegeneratePrimaryKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/subscriptions/{sid}/regeneratePrimaryKey",
    validator: validate_SubscriptionsRegeneratePrimaryKey_598087, base: "",
    url: url_SubscriptionsRegeneratePrimaryKey_598088, schemes: {Scheme.Https})
type
  Call_SubscriptionsRegenerateSecondaryKey_598098 = ref object of OpenApiRestCall_596467
proc url_SubscriptionsRegenerateSecondaryKey_598100(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "sid" in path, "`sid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "sid"),
               (kind: ConstantSegment, value: "/regenerateSecondaryKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionsRegenerateSecondaryKey_598099(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates secondary key of existing subscription of the API Management service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   sid: JString (required)
  ##      : Identifier of the subscription.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_598101 = path.getOrDefault("resourceGroupName")
  valid_598101 = validateParameter(valid_598101, JString, required = true,
                                 default = nil)
  if valid_598101 != nil:
    section.add "resourceGroupName", valid_598101
  var valid_598102 = path.getOrDefault("subscriptionId")
  valid_598102 = validateParameter(valid_598102, JString, required = true,
                                 default = nil)
  if valid_598102 != nil:
    section.add "subscriptionId", valid_598102
  var valid_598103 = path.getOrDefault("sid")
  valid_598103 = validateParameter(valid_598103, JString, required = true,
                                 default = nil)
  if valid_598103 != nil:
    section.add "sid", valid_598103
  var valid_598104 = path.getOrDefault("serviceName")
  valid_598104 = validateParameter(valid_598104, JString, required = true,
                                 default = nil)
  if valid_598104 != nil:
    section.add "serviceName", valid_598104
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_598105 = query.getOrDefault("api-version")
  valid_598105 = validateParameter(valid_598105, JString, required = true,
                                 default = nil)
  if valid_598105 != nil:
    section.add "api-version", valid_598105
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598106: Call_SubscriptionsRegenerateSecondaryKey_598098;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerates secondary key of existing subscription of the API Management service instance.
  ## 
  let valid = call_598106.validator(path, query, header, formData, body)
  let scheme = call_598106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598106.url(scheme.get, call_598106.host, call_598106.base,
                         call_598106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598106, url, valid)

proc call*(call_598107: Call_SubscriptionsRegenerateSecondaryKey_598098;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          sid: string; serviceName: string): Recallable =
  ## subscriptionsRegenerateSecondaryKey
  ## Regenerates secondary key of existing subscription of the API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   sid: string (required)
  ##      : Identifier of the subscription.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_598108 = newJObject()
  var query_598109 = newJObject()
  add(path_598108, "resourceGroupName", newJString(resourceGroupName))
  add(query_598109, "api-version", newJString(apiVersion))
  add(path_598108, "subscriptionId", newJString(subscriptionId))
  add(path_598108, "sid", newJString(sid))
  add(path_598108, "serviceName", newJString(serviceName))
  result = call_598107.call(path_598108, query_598109, nil, nil, nil)

var subscriptionsRegenerateSecondaryKey* = Call_SubscriptionsRegenerateSecondaryKey_598098(
    name: "subscriptionsRegenerateSecondaryKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/subscriptions/{sid}/regenerateSecondaryKey",
    validator: validate_SubscriptionsRegenerateSecondaryKey_598099, base: "",
    url: url_SubscriptionsRegenerateSecondaryKey_598100, schemes: {Scheme.Https})
type
  Call_TenantAccessGet_598110 = ref object of OpenApiRestCall_596467
proc url_TenantAccessGet_598112(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tenant/access")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantAccessGet_598111(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get tenant access information details.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_598113 = path.getOrDefault("resourceGroupName")
  valid_598113 = validateParameter(valid_598113, JString, required = true,
                                 default = nil)
  if valid_598113 != nil:
    section.add "resourceGroupName", valid_598113
  var valid_598114 = path.getOrDefault("subscriptionId")
  valid_598114 = validateParameter(valid_598114, JString, required = true,
                                 default = nil)
  if valid_598114 != nil:
    section.add "subscriptionId", valid_598114
  var valid_598115 = path.getOrDefault("serviceName")
  valid_598115 = validateParameter(valid_598115, JString, required = true,
                                 default = nil)
  if valid_598115 != nil:
    section.add "serviceName", valid_598115
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_598116 = query.getOrDefault("api-version")
  valid_598116 = validateParameter(valid_598116, JString, required = true,
                                 default = nil)
  if valid_598116 != nil:
    section.add "api-version", valid_598116
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598117: Call_TenantAccessGet_598110; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get tenant access information details.
  ## 
  let valid = call_598117.validator(path, query, header, formData, body)
  let scheme = call_598117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598117.url(scheme.get, call_598117.host, call_598117.base,
                         call_598117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598117, url, valid)

proc call*(call_598118: Call_TenantAccessGet_598110; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string): Recallable =
  ## tenantAccessGet
  ## Get tenant access information details.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_598119 = newJObject()
  var query_598120 = newJObject()
  add(path_598119, "resourceGroupName", newJString(resourceGroupName))
  add(query_598120, "api-version", newJString(apiVersion))
  add(path_598119, "subscriptionId", newJString(subscriptionId))
  add(path_598119, "serviceName", newJString(serviceName))
  result = call_598118.call(path_598119, query_598120, nil, nil, nil)

var tenantAccessGet* = Call_TenantAccessGet_598110(name: "tenantAccessGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/access",
    validator: validate_TenantAccessGet_598111, base: "", url: url_TenantAccessGet_598112,
    schemes: {Scheme.Https})
type
  Call_TenantAccessUpdate_598121 = ref object of OpenApiRestCall_596467
proc url_TenantAccessUpdate_598123(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tenant/access")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantAccessUpdate_598122(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Update tenant access information details.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_598124 = path.getOrDefault("resourceGroupName")
  valid_598124 = validateParameter(valid_598124, JString, required = true,
                                 default = nil)
  if valid_598124 != nil:
    section.add "resourceGroupName", valid_598124
  var valid_598125 = path.getOrDefault("subscriptionId")
  valid_598125 = validateParameter(valid_598125, JString, required = true,
                                 default = nil)
  if valid_598125 != nil:
    section.add "subscriptionId", valid_598125
  var valid_598126 = path.getOrDefault("serviceName")
  valid_598126 = validateParameter(valid_598126, JString, required = true,
                                 default = nil)
  if valid_598126 != nil:
    section.add "serviceName", valid_598126
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_598127 = query.getOrDefault("api-version")
  valid_598127 = validateParameter(valid_598127, JString, required = true,
                                 default = nil)
  if valid_598127 != nil:
    section.add "api-version", valid_598127
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the tenant access settings to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_598128 = header.getOrDefault("If-Match")
  valid_598128 = validateParameter(valid_598128, JString, required = true,
                                 default = nil)
  if valid_598128 != nil:
    section.add "If-Match", valid_598128
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_598130: Call_TenantAccessUpdate_598121; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update tenant access information details.
  ## 
  let valid = call_598130.validator(path, query, header, formData, body)
  let scheme = call_598130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598130.url(scheme.get, call_598130.host, call_598130.base,
                         call_598130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598130, url, valid)

proc call*(call_598131: Call_TenantAccessUpdate_598121; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          serviceName: string): Recallable =
  ## tenantAccessUpdate
  ## Update tenant access information details.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_598132 = newJObject()
  var query_598133 = newJObject()
  var body_598134 = newJObject()
  add(path_598132, "resourceGroupName", newJString(resourceGroupName))
  add(query_598133, "api-version", newJString(apiVersion))
  add(path_598132, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_598134 = parameters
  add(path_598132, "serviceName", newJString(serviceName))
  result = call_598131.call(path_598132, query_598133, nil, nil, body_598134)

var tenantAccessUpdate* = Call_TenantAccessUpdate_598121(
    name: "tenantAccessUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/access",
    validator: validate_TenantAccessUpdate_598122, base: "",
    url: url_TenantAccessUpdate_598123, schemes: {Scheme.Https})
type
  Call_TenantAccessGitGet_598135 = ref object of OpenApiRestCall_596467
proc url_TenantAccessGitGet_598137(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tenant/access/git")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantAccessGitGet_598136(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the Git access configuration for the tenant.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_598138 = path.getOrDefault("resourceGroupName")
  valid_598138 = validateParameter(valid_598138, JString, required = true,
                                 default = nil)
  if valid_598138 != nil:
    section.add "resourceGroupName", valid_598138
  var valid_598139 = path.getOrDefault("subscriptionId")
  valid_598139 = validateParameter(valid_598139, JString, required = true,
                                 default = nil)
  if valid_598139 != nil:
    section.add "subscriptionId", valid_598139
  var valid_598140 = path.getOrDefault("serviceName")
  valid_598140 = validateParameter(valid_598140, JString, required = true,
                                 default = nil)
  if valid_598140 != nil:
    section.add "serviceName", valid_598140
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_598141 = query.getOrDefault("api-version")
  valid_598141 = validateParameter(valid_598141, JString, required = true,
                                 default = nil)
  if valid_598141 != nil:
    section.add "api-version", valid_598141
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598142: Call_TenantAccessGitGet_598135; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Git access configuration for the tenant.
  ## 
  let valid = call_598142.validator(path, query, header, formData, body)
  let scheme = call_598142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598142.url(scheme.get, call_598142.host, call_598142.base,
                         call_598142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598142, url, valid)

proc call*(call_598143: Call_TenantAccessGitGet_598135; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string): Recallable =
  ## tenantAccessGitGet
  ## Gets the Git access configuration for the tenant.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_598144 = newJObject()
  var query_598145 = newJObject()
  add(path_598144, "resourceGroupName", newJString(resourceGroupName))
  add(query_598145, "api-version", newJString(apiVersion))
  add(path_598144, "subscriptionId", newJString(subscriptionId))
  add(path_598144, "serviceName", newJString(serviceName))
  result = call_598143.call(path_598144, query_598145, nil, nil, nil)

var tenantAccessGitGet* = Call_TenantAccessGitGet_598135(
    name: "tenantAccessGitGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/access/git",
    validator: validate_TenantAccessGitGet_598136, base: "",
    url: url_TenantAccessGitGet_598137, schemes: {Scheme.Https})
type
  Call_TenantAccessGitRegeneratePrimaryKey_598146 = ref object of OpenApiRestCall_596467
proc url_TenantAccessGitRegeneratePrimaryKey_598148(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"), (
        kind: ConstantSegment, value: "/tenant/access/git/regeneratePrimaryKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantAccessGitRegeneratePrimaryKey_598147(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate primary access key for GIT.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_598149 = path.getOrDefault("resourceGroupName")
  valid_598149 = validateParameter(valid_598149, JString, required = true,
                                 default = nil)
  if valid_598149 != nil:
    section.add "resourceGroupName", valid_598149
  var valid_598150 = path.getOrDefault("subscriptionId")
  valid_598150 = validateParameter(valid_598150, JString, required = true,
                                 default = nil)
  if valid_598150 != nil:
    section.add "subscriptionId", valid_598150
  var valid_598151 = path.getOrDefault("serviceName")
  valid_598151 = validateParameter(valid_598151, JString, required = true,
                                 default = nil)
  if valid_598151 != nil:
    section.add "serviceName", valid_598151
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_598152 = query.getOrDefault("api-version")
  valid_598152 = validateParameter(valid_598152, JString, required = true,
                                 default = nil)
  if valid_598152 != nil:
    section.add "api-version", valid_598152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598153: Call_TenantAccessGitRegeneratePrimaryKey_598146;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate primary access key for GIT.
  ## 
  let valid = call_598153.validator(path, query, header, formData, body)
  let scheme = call_598153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598153.url(scheme.get, call_598153.host, call_598153.base,
                         call_598153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598153, url, valid)

proc call*(call_598154: Call_TenantAccessGitRegeneratePrimaryKey_598146;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## tenantAccessGitRegeneratePrimaryKey
  ## Regenerate primary access key for GIT.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_598155 = newJObject()
  var query_598156 = newJObject()
  add(path_598155, "resourceGroupName", newJString(resourceGroupName))
  add(query_598156, "api-version", newJString(apiVersion))
  add(path_598155, "subscriptionId", newJString(subscriptionId))
  add(path_598155, "serviceName", newJString(serviceName))
  result = call_598154.call(path_598155, query_598156, nil, nil, nil)

var tenantAccessGitRegeneratePrimaryKey* = Call_TenantAccessGitRegeneratePrimaryKey_598146(
    name: "tenantAccessGitRegeneratePrimaryKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/access/git/regeneratePrimaryKey",
    validator: validate_TenantAccessGitRegeneratePrimaryKey_598147, base: "",
    url: url_TenantAccessGitRegeneratePrimaryKey_598148, schemes: {Scheme.Https})
type
  Call_TenantAccessGitRegenerateSecondaryKey_598157 = ref object of OpenApiRestCall_596467
proc url_TenantAccessGitRegenerateSecondaryKey_598159(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"), (
        kind: ConstantSegment, value: "/tenant/access/git/regenerateSecondaryKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantAccessGitRegenerateSecondaryKey_598158(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate secondary access key for GIT.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_598160 = path.getOrDefault("resourceGroupName")
  valid_598160 = validateParameter(valid_598160, JString, required = true,
                                 default = nil)
  if valid_598160 != nil:
    section.add "resourceGroupName", valid_598160
  var valid_598161 = path.getOrDefault("subscriptionId")
  valid_598161 = validateParameter(valid_598161, JString, required = true,
                                 default = nil)
  if valid_598161 != nil:
    section.add "subscriptionId", valid_598161
  var valid_598162 = path.getOrDefault("serviceName")
  valid_598162 = validateParameter(valid_598162, JString, required = true,
                                 default = nil)
  if valid_598162 != nil:
    section.add "serviceName", valid_598162
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_598163 = query.getOrDefault("api-version")
  valid_598163 = validateParameter(valid_598163, JString, required = true,
                                 default = nil)
  if valid_598163 != nil:
    section.add "api-version", valid_598163
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598164: Call_TenantAccessGitRegenerateSecondaryKey_598157;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate secondary access key for GIT.
  ## 
  let valid = call_598164.validator(path, query, header, formData, body)
  let scheme = call_598164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598164.url(scheme.get, call_598164.host, call_598164.base,
                         call_598164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598164, url, valid)

proc call*(call_598165: Call_TenantAccessGitRegenerateSecondaryKey_598157;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## tenantAccessGitRegenerateSecondaryKey
  ## Regenerate secondary access key for GIT.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_598166 = newJObject()
  var query_598167 = newJObject()
  add(path_598166, "resourceGroupName", newJString(resourceGroupName))
  add(query_598167, "api-version", newJString(apiVersion))
  add(path_598166, "subscriptionId", newJString(subscriptionId))
  add(path_598166, "serviceName", newJString(serviceName))
  result = call_598165.call(path_598166, query_598167, nil, nil, nil)

var tenantAccessGitRegenerateSecondaryKey* = Call_TenantAccessGitRegenerateSecondaryKey_598157(
    name: "tenantAccessGitRegenerateSecondaryKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/access/git/regenerateSecondaryKey",
    validator: validate_TenantAccessGitRegenerateSecondaryKey_598158, base: "",
    url: url_TenantAccessGitRegenerateSecondaryKey_598159, schemes: {Scheme.Https})
type
  Call_TenantAccessRegeneratePrimaryKey_598168 = ref object of OpenApiRestCall_596467
proc url_TenantAccessRegeneratePrimaryKey_598170(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"), (
        kind: ConstantSegment, value: "/tenant/access/regeneratePrimaryKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantAccessRegeneratePrimaryKey_598169(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate primary access key.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_598171 = path.getOrDefault("resourceGroupName")
  valid_598171 = validateParameter(valid_598171, JString, required = true,
                                 default = nil)
  if valid_598171 != nil:
    section.add "resourceGroupName", valid_598171
  var valid_598172 = path.getOrDefault("subscriptionId")
  valid_598172 = validateParameter(valid_598172, JString, required = true,
                                 default = nil)
  if valid_598172 != nil:
    section.add "subscriptionId", valid_598172
  var valid_598173 = path.getOrDefault("serviceName")
  valid_598173 = validateParameter(valid_598173, JString, required = true,
                                 default = nil)
  if valid_598173 != nil:
    section.add "serviceName", valid_598173
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_598174 = query.getOrDefault("api-version")
  valid_598174 = validateParameter(valid_598174, JString, required = true,
                                 default = nil)
  if valid_598174 != nil:
    section.add "api-version", valid_598174
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598175: Call_TenantAccessRegeneratePrimaryKey_598168;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate primary access key.
  ## 
  let valid = call_598175.validator(path, query, header, formData, body)
  let scheme = call_598175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598175.url(scheme.get, call_598175.host, call_598175.base,
                         call_598175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598175, url, valid)

proc call*(call_598176: Call_TenantAccessRegeneratePrimaryKey_598168;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## tenantAccessRegeneratePrimaryKey
  ## Regenerate primary access key.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_598177 = newJObject()
  var query_598178 = newJObject()
  add(path_598177, "resourceGroupName", newJString(resourceGroupName))
  add(query_598178, "api-version", newJString(apiVersion))
  add(path_598177, "subscriptionId", newJString(subscriptionId))
  add(path_598177, "serviceName", newJString(serviceName))
  result = call_598176.call(path_598177, query_598178, nil, nil, nil)

var tenantAccessRegeneratePrimaryKey* = Call_TenantAccessRegeneratePrimaryKey_598168(
    name: "tenantAccessRegeneratePrimaryKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/access/regeneratePrimaryKey",
    validator: validate_TenantAccessRegeneratePrimaryKey_598169, base: "",
    url: url_TenantAccessRegeneratePrimaryKey_598170, schemes: {Scheme.Https})
type
  Call_TenantAccessRegenerateSecondaryKey_598179 = ref object of OpenApiRestCall_596467
proc url_TenantAccessRegenerateSecondaryKey_598181(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"), (
        kind: ConstantSegment, value: "/tenant/access/regenerateSecondaryKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantAccessRegenerateSecondaryKey_598180(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate secondary access key.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_598182 = path.getOrDefault("resourceGroupName")
  valid_598182 = validateParameter(valid_598182, JString, required = true,
                                 default = nil)
  if valid_598182 != nil:
    section.add "resourceGroupName", valid_598182
  var valid_598183 = path.getOrDefault("subscriptionId")
  valid_598183 = validateParameter(valid_598183, JString, required = true,
                                 default = nil)
  if valid_598183 != nil:
    section.add "subscriptionId", valid_598183
  var valid_598184 = path.getOrDefault("serviceName")
  valid_598184 = validateParameter(valid_598184, JString, required = true,
                                 default = nil)
  if valid_598184 != nil:
    section.add "serviceName", valid_598184
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_598185 = query.getOrDefault("api-version")
  valid_598185 = validateParameter(valid_598185, JString, required = true,
                                 default = nil)
  if valid_598185 != nil:
    section.add "api-version", valid_598185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598186: Call_TenantAccessRegenerateSecondaryKey_598179;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate secondary access key.
  ## 
  let valid = call_598186.validator(path, query, header, formData, body)
  let scheme = call_598186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598186.url(scheme.get, call_598186.host, call_598186.base,
                         call_598186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598186, url, valid)

proc call*(call_598187: Call_TenantAccessRegenerateSecondaryKey_598179;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## tenantAccessRegenerateSecondaryKey
  ## Regenerate secondary access key.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_598188 = newJObject()
  var query_598189 = newJObject()
  add(path_598188, "resourceGroupName", newJString(resourceGroupName))
  add(query_598189, "api-version", newJString(apiVersion))
  add(path_598188, "subscriptionId", newJString(subscriptionId))
  add(path_598188, "serviceName", newJString(serviceName))
  result = call_598187.call(path_598188, query_598189, nil, nil, nil)

var tenantAccessRegenerateSecondaryKey* = Call_TenantAccessRegenerateSecondaryKey_598179(
    name: "tenantAccessRegenerateSecondaryKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/access/regenerateSecondaryKey",
    validator: validate_TenantAccessRegenerateSecondaryKey_598180, base: "",
    url: url_TenantAccessRegenerateSecondaryKey_598181, schemes: {Scheme.Https})
type
  Call_TenantConfigurationDeploy_598190 = ref object of OpenApiRestCall_596467
proc url_TenantConfigurationDeploy_598192(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tenant/configuration/deploy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantConfigurationDeploy_598191(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation applies changes from the specified Git branch to the configuration database. This is a long running operation and could take several minutes to complete.
  ## 
  ## To deploy any service configuration changes to the API Management service instance
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-configuration-repository-git/#to-deploy-any-service-configuration-changes-to-the-api-management-service-instance
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_598193 = path.getOrDefault("resourceGroupName")
  valid_598193 = validateParameter(valid_598193, JString, required = true,
                                 default = nil)
  if valid_598193 != nil:
    section.add "resourceGroupName", valid_598193
  var valid_598194 = path.getOrDefault("subscriptionId")
  valid_598194 = validateParameter(valid_598194, JString, required = true,
                                 default = nil)
  if valid_598194 != nil:
    section.add "subscriptionId", valid_598194
  var valid_598195 = path.getOrDefault("serviceName")
  valid_598195 = validateParameter(valid_598195, JString, required = true,
                                 default = nil)
  if valid_598195 != nil:
    section.add "serviceName", valid_598195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_598196 = query.getOrDefault("api-version")
  valid_598196 = validateParameter(valid_598196, JString, required = true,
                                 default = nil)
  if valid_598196 != nil:
    section.add "api-version", valid_598196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Deploy Configuration parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_598198: Call_TenantConfigurationDeploy_598190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation applies changes from the specified Git branch to the configuration database. This is a long running operation and could take several minutes to complete.
  ## 
  ## To deploy any service configuration changes to the API Management service instance
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-configuration-repository-git/#to-deploy-any-service-configuration-changes-to-the-api-management-service-instance
  let valid = call_598198.validator(path, query, header, formData, body)
  let scheme = call_598198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598198.url(scheme.get, call_598198.host, call_598198.base,
                         call_598198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598198, url, valid)

proc call*(call_598199: Call_TenantConfigurationDeploy_598190;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## tenantConfigurationDeploy
  ## This operation applies changes from the specified Git branch to the configuration database. This is a long running operation and could take several minutes to complete.
  ## To deploy any service configuration changes to the API Management service instance
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-configuration-repository-git/#to-deploy-any-service-configuration-changes-to-the-api-management-service-instance
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Deploy Configuration parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_598200 = newJObject()
  var query_598201 = newJObject()
  var body_598202 = newJObject()
  add(path_598200, "resourceGroupName", newJString(resourceGroupName))
  add(query_598201, "api-version", newJString(apiVersion))
  add(path_598200, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_598202 = parameters
  add(path_598200, "serviceName", newJString(serviceName))
  result = call_598199.call(path_598200, query_598201, nil, nil, body_598202)

var tenantConfigurationDeploy* = Call_TenantConfigurationDeploy_598190(
    name: "tenantConfigurationDeploy", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/configuration/deploy",
    validator: validate_TenantConfigurationDeploy_598191, base: "",
    url: url_TenantConfigurationDeploy_598192, schemes: {Scheme.Https})
type
  Call_TenantConfigurationSave_598203 = ref object of OpenApiRestCall_596467
proc url_TenantConfigurationSave_598205(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tenant/configuration/save")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantConfigurationSave_598204(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation creates a commit with the current configuration snapshot to the specified branch in the repository. This is a long running operation and could take several minutes to complete.
  ## 
  ## To save the service configuration to the Git repository
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-configuration-repository-git/#to-save-the-service-configuration-to-the-git-repository
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_598206 = path.getOrDefault("resourceGroupName")
  valid_598206 = validateParameter(valid_598206, JString, required = true,
                                 default = nil)
  if valid_598206 != nil:
    section.add "resourceGroupName", valid_598206
  var valid_598207 = path.getOrDefault("subscriptionId")
  valid_598207 = validateParameter(valid_598207, JString, required = true,
                                 default = nil)
  if valid_598207 != nil:
    section.add "subscriptionId", valid_598207
  var valid_598208 = path.getOrDefault("serviceName")
  valid_598208 = validateParameter(valid_598208, JString, required = true,
                                 default = nil)
  if valid_598208 != nil:
    section.add "serviceName", valid_598208
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_598209 = query.getOrDefault("api-version")
  valid_598209 = validateParameter(valid_598209, JString, required = true,
                                 default = nil)
  if valid_598209 != nil:
    section.add "api-version", valid_598209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Save Configuration parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_598211: Call_TenantConfigurationSave_598203; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation creates a commit with the current configuration snapshot to the specified branch in the repository. This is a long running operation and could take several minutes to complete.
  ## 
  ## To save the service configuration to the Git repository
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-configuration-repository-git/#to-save-the-service-configuration-to-the-git-repository
  let valid = call_598211.validator(path, query, header, formData, body)
  let scheme = call_598211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598211.url(scheme.get, call_598211.host, call_598211.base,
                         call_598211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598211, url, valid)

proc call*(call_598212: Call_TenantConfigurationSave_598203;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## tenantConfigurationSave
  ## This operation creates a commit with the current configuration snapshot to the specified branch in the repository. This is a long running operation and could take several minutes to complete.
  ## To save the service configuration to the Git repository
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-configuration-repository-git/#to-save-the-service-configuration-to-the-git-repository
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Save Configuration parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_598213 = newJObject()
  var query_598214 = newJObject()
  var body_598215 = newJObject()
  add(path_598213, "resourceGroupName", newJString(resourceGroupName))
  add(query_598214, "api-version", newJString(apiVersion))
  add(path_598213, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_598215 = parameters
  add(path_598213, "serviceName", newJString(serviceName))
  result = call_598212.call(path_598213, query_598214, nil, nil, body_598215)

var tenantConfigurationSave* = Call_TenantConfigurationSave_598203(
    name: "tenantConfigurationSave", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/configuration/save",
    validator: validate_TenantConfigurationSave_598204, base: "",
    url: url_TenantConfigurationSave_598205, schemes: {Scheme.Https})
type
  Call_TenantConfigurationSyncStateGet_598216 = ref object of OpenApiRestCall_596467
proc url_TenantConfigurationSyncStateGet_598218(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"), (
        kind: ConstantSegment, value: "/tenant/configuration/syncState")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantConfigurationSyncStateGet_598217(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the status of the most recent synchronization between the configuration database and the Git repository.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_598219 = path.getOrDefault("resourceGroupName")
  valid_598219 = validateParameter(valid_598219, JString, required = true,
                                 default = nil)
  if valid_598219 != nil:
    section.add "resourceGroupName", valid_598219
  var valid_598220 = path.getOrDefault("subscriptionId")
  valid_598220 = validateParameter(valid_598220, JString, required = true,
                                 default = nil)
  if valid_598220 != nil:
    section.add "subscriptionId", valid_598220
  var valid_598221 = path.getOrDefault("serviceName")
  valid_598221 = validateParameter(valid_598221, JString, required = true,
                                 default = nil)
  if valid_598221 != nil:
    section.add "serviceName", valid_598221
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_598222 = query.getOrDefault("api-version")
  valid_598222 = validateParameter(valid_598222, JString, required = true,
                                 default = nil)
  if valid_598222 != nil:
    section.add "api-version", valid_598222
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598223: Call_TenantConfigurationSyncStateGet_598216;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status of the most recent synchronization between the configuration database and the Git repository.
  ## 
  let valid = call_598223.validator(path, query, header, formData, body)
  let scheme = call_598223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598223.url(scheme.get, call_598223.host, call_598223.base,
                         call_598223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598223, url, valid)

proc call*(call_598224: Call_TenantConfigurationSyncStateGet_598216;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## tenantConfigurationSyncStateGet
  ## Gets the status of the most recent synchronization between the configuration database and the Git repository.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_598225 = newJObject()
  var query_598226 = newJObject()
  add(path_598225, "resourceGroupName", newJString(resourceGroupName))
  add(query_598226, "api-version", newJString(apiVersion))
  add(path_598225, "subscriptionId", newJString(subscriptionId))
  add(path_598225, "serviceName", newJString(serviceName))
  result = call_598224.call(path_598225, query_598226, nil, nil, nil)

var tenantConfigurationSyncStateGet* = Call_TenantConfigurationSyncStateGet_598216(
    name: "tenantConfigurationSyncStateGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/configuration/syncState",
    validator: validate_TenantConfigurationSyncStateGet_598217, base: "",
    url: url_TenantConfigurationSyncStateGet_598218, schemes: {Scheme.Https})
type
  Call_TenantConfigurationValidate_598227 = ref object of OpenApiRestCall_596467
proc url_TenantConfigurationValidate_598229(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tenant/configuration/validate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantConfigurationValidate_598228(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation validates the changes in the specified Git branch. This is a long running operation and could take several minutes to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_598230 = path.getOrDefault("resourceGroupName")
  valid_598230 = validateParameter(valid_598230, JString, required = true,
                                 default = nil)
  if valid_598230 != nil:
    section.add "resourceGroupName", valid_598230
  var valid_598231 = path.getOrDefault("subscriptionId")
  valid_598231 = validateParameter(valid_598231, JString, required = true,
                                 default = nil)
  if valid_598231 != nil:
    section.add "subscriptionId", valid_598231
  var valid_598232 = path.getOrDefault("serviceName")
  valid_598232 = validateParameter(valid_598232, JString, required = true,
                                 default = nil)
  if valid_598232 != nil:
    section.add "serviceName", valid_598232
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_598233 = query.getOrDefault("api-version")
  valid_598233 = validateParameter(valid_598233, JString, required = true,
                                 default = nil)
  if valid_598233 != nil:
    section.add "api-version", valid_598233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Validate Configuration parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_598235: Call_TenantConfigurationValidate_598227; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation validates the changes in the specified Git branch. This is a long running operation and could take several minutes to complete.
  ## 
  let valid = call_598235.validator(path, query, header, formData, body)
  let scheme = call_598235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598235.url(scheme.get, call_598235.host, call_598235.base,
                         call_598235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598235, url, valid)

proc call*(call_598236: Call_TenantConfigurationValidate_598227;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## tenantConfigurationValidate
  ## This operation validates the changes in the specified Git branch. This is a long running operation and could take several minutes to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Validate Configuration parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_598237 = newJObject()
  var query_598238 = newJObject()
  var body_598239 = newJObject()
  add(path_598237, "resourceGroupName", newJString(resourceGroupName))
  add(query_598238, "api-version", newJString(apiVersion))
  add(path_598237, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_598239 = parameters
  add(path_598237, "serviceName", newJString(serviceName))
  result = call_598236.call(path_598237, query_598238, nil, nil, body_598239)

var tenantConfigurationValidate* = Call_TenantConfigurationValidate_598227(
    name: "tenantConfigurationValidate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/configuration/validate",
    validator: validate_TenantConfigurationValidate_598228, base: "",
    url: url_TenantConfigurationValidate_598229, schemes: {Scheme.Https})
type
  Call_UsersListByService_598240 = ref object of OpenApiRestCall_596467
proc url_UsersListByService_598242(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/users")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsersListByService_598241(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists a collection of registered users in the specified service instance.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/dn776330.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_598243 = path.getOrDefault("resourceGroupName")
  valid_598243 = validateParameter(valid_598243, JString, required = true,
                                 default = nil)
  if valid_598243 != nil:
    section.add "resourceGroupName", valid_598243
  var valid_598244 = path.getOrDefault("subscriptionId")
  valid_598244 = validateParameter(valid_598244, JString, required = true,
                                 default = nil)
  if valid_598244 != nil:
    section.add "subscriptionId", valid_598244
  var valid_598245 = path.getOrDefault("serviceName")
  valid_598245 = validateParameter(valid_598245, JString, required = true,
                                 default = nil)
  if valid_598245 != nil:
    section.add "serviceName", valid_598245
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field            | Supported operators    | Supported functions               |
  ## 
  ## |------------------|------------------------|-----------------------------------|
  ## | id               | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | firstName        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | lastName         | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | email            | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | state            | eq                     | N/A                               |
  ## | registrationDate | ge, le, eq, ne, gt, lt | N/A                               |
  ## | note             | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_598246 = query.getOrDefault("api-version")
  valid_598246 = validateParameter(valid_598246, JString, required = true,
                                 default = nil)
  if valid_598246 != nil:
    section.add "api-version", valid_598246
  var valid_598247 = query.getOrDefault("$top")
  valid_598247 = validateParameter(valid_598247, JInt, required = false, default = nil)
  if valid_598247 != nil:
    section.add "$top", valid_598247
  var valid_598248 = query.getOrDefault("$skip")
  valid_598248 = validateParameter(valid_598248, JInt, required = false, default = nil)
  if valid_598248 != nil:
    section.add "$skip", valid_598248
  var valid_598249 = query.getOrDefault("$filter")
  valid_598249 = validateParameter(valid_598249, JString, required = false,
                                 default = nil)
  if valid_598249 != nil:
    section.add "$filter", valid_598249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598250: Call_UsersListByService_598240; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of registered users in the specified service instance.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/dn776330.aspx
  let valid = call_598250.validator(path, query, header, formData, body)
  let scheme = call_598250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598250.url(scheme.get, call_598250.host, call_598250.base,
                         call_598250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598250, url, valid)

proc call*(call_598251: Call_UsersListByService_598240; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## usersListByService
  ## Lists a collection of registered users in the specified service instance.
  ## https://msdn.microsoft.com/en-us/library/azure/dn776330.aspx
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field            | Supported operators    | Supported functions               |
  ## 
  ## |------------------|------------------------|-----------------------------------|
  ## | id               | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | firstName        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | lastName         | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | email            | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | state            | eq                     | N/A                               |
  ## | registrationDate | ge, le, eq, ne, gt, lt | N/A                               |
  ## | note             | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  var path_598252 = newJObject()
  var query_598253 = newJObject()
  add(path_598252, "resourceGroupName", newJString(resourceGroupName))
  add(query_598253, "api-version", newJString(apiVersion))
  add(path_598252, "subscriptionId", newJString(subscriptionId))
  add(query_598253, "$top", newJInt(Top))
  add(query_598253, "$skip", newJInt(Skip))
  add(path_598252, "serviceName", newJString(serviceName))
  add(query_598253, "$filter", newJString(Filter))
  result = call_598251.call(path_598252, query_598253, nil, nil, nil)

var usersListByService* = Call_UsersListByService_598240(
    name: "usersListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users",
    validator: validate_UsersListByService_598241, base: "",
    url: url_UsersListByService_598242, schemes: {Scheme.Https})
type
  Call_UsersCreateOrUpdate_598266 = ref object of OpenApiRestCall_596467
proc url_UsersCreateOrUpdate_598268(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "uid" in path, "`uid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "uid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsersCreateOrUpdate_598267(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates or Updates a user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_598269 = path.getOrDefault("resourceGroupName")
  valid_598269 = validateParameter(valid_598269, JString, required = true,
                                 default = nil)
  if valid_598269 != nil:
    section.add "resourceGroupName", valid_598269
  var valid_598270 = path.getOrDefault("subscriptionId")
  valid_598270 = validateParameter(valid_598270, JString, required = true,
                                 default = nil)
  if valid_598270 != nil:
    section.add "subscriptionId", valid_598270
  var valid_598271 = path.getOrDefault("uid")
  valid_598271 = validateParameter(valid_598271, JString, required = true,
                                 default = nil)
  if valid_598271 != nil:
    section.add "uid", valid_598271
  var valid_598272 = path.getOrDefault("serviceName")
  valid_598272 = validateParameter(valid_598272, JString, required = true,
                                 default = nil)
  if valid_598272 != nil:
    section.add "serviceName", valid_598272
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_598273 = query.getOrDefault("api-version")
  valid_598273 = validateParameter(valid_598273, JString, required = true,
                                 default = nil)
  if valid_598273 != nil:
    section.add "api-version", valid_598273
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Create or update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_598275: Call_UsersCreateOrUpdate_598266; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or Updates a user.
  ## 
  let valid = call_598275.validator(path, query, header, formData, body)
  let scheme = call_598275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598275.url(scheme.get, call_598275.host, call_598275.base,
                         call_598275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598275, url, valid)

proc call*(call_598276: Call_UsersCreateOrUpdate_598266; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          uid: string; serviceName: string): Recallable =
  ## usersCreateOrUpdate
  ## Creates or Updates a user.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Create or update parameters.
  ##   uid: string (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_598277 = newJObject()
  var query_598278 = newJObject()
  var body_598279 = newJObject()
  add(path_598277, "resourceGroupName", newJString(resourceGroupName))
  add(query_598278, "api-version", newJString(apiVersion))
  add(path_598277, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_598279 = parameters
  add(path_598277, "uid", newJString(uid))
  add(path_598277, "serviceName", newJString(serviceName))
  result = call_598276.call(path_598277, query_598278, nil, nil, body_598279)

var usersCreateOrUpdate* = Call_UsersCreateOrUpdate_598266(
    name: "usersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{uid}",
    validator: validate_UsersCreateOrUpdate_598267, base: "",
    url: url_UsersCreateOrUpdate_598268, schemes: {Scheme.Https})
type
  Call_UsersGet_598254 = ref object of OpenApiRestCall_596467
proc url_UsersGet_598256(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "uid" in path, "`uid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "uid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsersGet_598255(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the user specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_598257 = path.getOrDefault("resourceGroupName")
  valid_598257 = validateParameter(valid_598257, JString, required = true,
                                 default = nil)
  if valid_598257 != nil:
    section.add "resourceGroupName", valid_598257
  var valid_598258 = path.getOrDefault("subscriptionId")
  valid_598258 = validateParameter(valid_598258, JString, required = true,
                                 default = nil)
  if valid_598258 != nil:
    section.add "subscriptionId", valid_598258
  var valid_598259 = path.getOrDefault("uid")
  valid_598259 = validateParameter(valid_598259, JString, required = true,
                                 default = nil)
  if valid_598259 != nil:
    section.add "uid", valid_598259
  var valid_598260 = path.getOrDefault("serviceName")
  valid_598260 = validateParameter(valid_598260, JString, required = true,
                                 default = nil)
  if valid_598260 != nil:
    section.add "serviceName", valid_598260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_598261 = query.getOrDefault("api-version")
  valid_598261 = validateParameter(valid_598261, JString, required = true,
                                 default = nil)
  if valid_598261 != nil:
    section.add "api-version", valid_598261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598262: Call_UsersGet_598254; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the user specified by its identifier.
  ## 
  let valid = call_598262.validator(path, query, header, formData, body)
  let scheme = call_598262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598262.url(scheme.get, call_598262.host, call_598262.base,
                         call_598262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598262, url, valid)

proc call*(call_598263: Call_UsersGet_598254; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; uid: string; serviceName: string): Recallable =
  ## usersGet
  ## Gets the details of the user specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   uid: string (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_598264 = newJObject()
  var query_598265 = newJObject()
  add(path_598264, "resourceGroupName", newJString(resourceGroupName))
  add(query_598265, "api-version", newJString(apiVersion))
  add(path_598264, "subscriptionId", newJString(subscriptionId))
  add(path_598264, "uid", newJString(uid))
  add(path_598264, "serviceName", newJString(serviceName))
  result = call_598263.call(path_598264, query_598265, nil, nil, nil)

var usersGet* = Call_UsersGet_598254(name: "usersGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{uid}",
                                  validator: validate_UsersGet_598255, base: "",
                                  url: url_UsersGet_598256,
                                  schemes: {Scheme.Https})
type
  Call_UsersUpdate_598294 = ref object of OpenApiRestCall_596467
proc url_UsersUpdate_598296(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "uid" in path, "`uid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "uid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsersUpdate_598295(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the details of the user specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_598297 = path.getOrDefault("resourceGroupName")
  valid_598297 = validateParameter(valid_598297, JString, required = true,
                                 default = nil)
  if valid_598297 != nil:
    section.add "resourceGroupName", valid_598297
  var valid_598298 = path.getOrDefault("subscriptionId")
  valid_598298 = validateParameter(valid_598298, JString, required = true,
                                 default = nil)
  if valid_598298 != nil:
    section.add "subscriptionId", valid_598298
  var valid_598299 = path.getOrDefault("uid")
  valid_598299 = validateParameter(valid_598299, JString, required = true,
                                 default = nil)
  if valid_598299 != nil:
    section.add "uid", valid_598299
  var valid_598300 = path.getOrDefault("serviceName")
  valid_598300 = validateParameter(valid_598300, JString, required = true,
                                 default = nil)
  if valid_598300 != nil:
    section.add "serviceName", valid_598300
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_598301 = query.getOrDefault("api-version")
  valid_598301 = validateParameter(valid_598301, JString, required = true,
                                 default = nil)
  if valid_598301 != nil:
    section.add "api-version", valid_598301
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the user to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_598302 = header.getOrDefault("If-Match")
  valid_598302 = validateParameter(valid_598302, JString, required = true,
                                 default = nil)
  if valid_598302 != nil:
    section.add "If-Match", valid_598302
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_598304: Call_UsersUpdate_598294; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of the user specified by its identifier.
  ## 
  let valid = call_598304.validator(path, query, header, formData, body)
  let scheme = call_598304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598304.url(scheme.get, call_598304.host, call_598304.base,
                         call_598304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598304, url, valid)

proc call*(call_598305: Call_UsersUpdate_598294; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          uid: string; serviceName: string): Recallable =
  ## usersUpdate
  ## Updates the details of the user specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Update parameters.
  ##   uid: string (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_598306 = newJObject()
  var query_598307 = newJObject()
  var body_598308 = newJObject()
  add(path_598306, "resourceGroupName", newJString(resourceGroupName))
  add(query_598307, "api-version", newJString(apiVersion))
  add(path_598306, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_598308 = parameters
  add(path_598306, "uid", newJString(uid))
  add(path_598306, "serviceName", newJString(serviceName))
  result = call_598305.call(path_598306, query_598307, nil, nil, body_598308)

var usersUpdate* = Call_UsersUpdate_598294(name: "usersUpdate",
                                        meth: HttpMethod.HttpPatch,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{uid}",
                                        validator: validate_UsersUpdate_598295,
                                        base: "", url: url_UsersUpdate_598296,
                                        schemes: {Scheme.Https})
type
  Call_UsersDelete_598280 = ref object of OpenApiRestCall_596467
proc url_UsersDelete_598282(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "uid" in path, "`uid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "uid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsersDelete_598281(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes specific user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_598283 = path.getOrDefault("resourceGroupName")
  valid_598283 = validateParameter(valid_598283, JString, required = true,
                                 default = nil)
  if valid_598283 != nil:
    section.add "resourceGroupName", valid_598283
  var valid_598284 = path.getOrDefault("subscriptionId")
  valid_598284 = validateParameter(valid_598284, JString, required = true,
                                 default = nil)
  if valid_598284 != nil:
    section.add "subscriptionId", valid_598284
  var valid_598285 = path.getOrDefault("uid")
  valid_598285 = validateParameter(valid_598285, JString, required = true,
                                 default = nil)
  if valid_598285 != nil:
    section.add "uid", valid_598285
  var valid_598286 = path.getOrDefault("serviceName")
  valid_598286 = validateParameter(valid_598286, JString, required = true,
                                 default = nil)
  if valid_598286 != nil:
    section.add "serviceName", valid_598286
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   deleteSubscriptions: JBool
  ##                      : Whether to delete user's subscription or not.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_598287 = query.getOrDefault("api-version")
  valid_598287 = validateParameter(valid_598287, JString, required = true,
                                 default = nil)
  if valid_598287 != nil:
    section.add "api-version", valid_598287
  var valid_598288 = query.getOrDefault("deleteSubscriptions")
  valid_598288 = validateParameter(valid_598288, JBool, required = false, default = nil)
  if valid_598288 != nil:
    section.add "deleteSubscriptions", valid_598288
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the user to delete. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_598289 = header.getOrDefault("If-Match")
  valid_598289 = validateParameter(valid_598289, JString, required = true,
                                 default = nil)
  if valid_598289 != nil:
    section.add "If-Match", valid_598289
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598290: Call_UsersDelete_598280; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specific user.
  ## 
  let valid = call_598290.validator(path, query, header, formData, body)
  let scheme = call_598290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598290.url(scheme.get, call_598290.host, call_598290.base,
                         call_598290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598290, url, valid)

proc call*(call_598291: Call_UsersDelete_598280; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; uid: string;
          serviceName: string; deleteSubscriptions: bool = false): Recallable =
  ## usersDelete
  ## Deletes specific user.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   uid: string (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   deleteSubscriptions: bool
  ##                      : Whether to delete user's subscription or not.
  var path_598292 = newJObject()
  var query_598293 = newJObject()
  add(path_598292, "resourceGroupName", newJString(resourceGroupName))
  add(query_598293, "api-version", newJString(apiVersion))
  add(path_598292, "subscriptionId", newJString(subscriptionId))
  add(path_598292, "uid", newJString(uid))
  add(path_598292, "serviceName", newJString(serviceName))
  add(query_598293, "deleteSubscriptions", newJBool(deleteSubscriptions))
  result = call_598291.call(path_598292, query_598293, nil, nil, nil)

var usersDelete* = Call_UsersDelete_598280(name: "usersDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{uid}",
                                        validator: validate_UsersDelete_598281,
                                        base: "", url: url_UsersDelete_598282,
                                        schemes: {Scheme.Https})
type
  Call_UsersGenerateSsoUrl_598309 = ref object of OpenApiRestCall_596467
proc url_UsersGenerateSsoUrl_598311(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "uid" in path, "`uid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "uid"),
               (kind: ConstantSegment, value: "/generateSsoUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsersGenerateSsoUrl_598310(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves a redirection URL containing an authentication token for signing a given user into the developer portal.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_598312 = path.getOrDefault("resourceGroupName")
  valid_598312 = validateParameter(valid_598312, JString, required = true,
                                 default = nil)
  if valid_598312 != nil:
    section.add "resourceGroupName", valid_598312
  var valid_598313 = path.getOrDefault("subscriptionId")
  valid_598313 = validateParameter(valid_598313, JString, required = true,
                                 default = nil)
  if valid_598313 != nil:
    section.add "subscriptionId", valid_598313
  var valid_598314 = path.getOrDefault("uid")
  valid_598314 = validateParameter(valid_598314, JString, required = true,
                                 default = nil)
  if valid_598314 != nil:
    section.add "uid", valid_598314
  var valid_598315 = path.getOrDefault("serviceName")
  valid_598315 = validateParameter(valid_598315, JString, required = true,
                                 default = nil)
  if valid_598315 != nil:
    section.add "serviceName", valid_598315
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_598316 = query.getOrDefault("api-version")
  valid_598316 = validateParameter(valid_598316, JString, required = true,
                                 default = nil)
  if valid_598316 != nil:
    section.add "api-version", valid_598316
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598317: Call_UsersGenerateSsoUrl_598309; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a redirection URL containing an authentication token for signing a given user into the developer portal.
  ## 
  let valid = call_598317.validator(path, query, header, formData, body)
  let scheme = call_598317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598317.url(scheme.get, call_598317.host, call_598317.base,
                         call_598317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598317, url, valid)

proc call*(call_598318: Call_UsersGenerateSsoUrl_598309; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; uid: string; serviceName: string): Recallable =
  ## usersGenerateSsoUrl
  ## Retrieves a redirection URL containing an authentication token for signing a given user into the developer portal.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   uid: string (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_598319 = newJObject()
  var query_598320 = newJObject()
  add(path_598319, "resourceGroupName", newJString(resourceGroupName))
  add(query_598320, "api-version", newJString(apiVersion))
  add(path_598319, "subscriptionId", newJString(subscriptionId))
  add(path_598319, "uid", newJString(uid))
  add(path_598319, "serviceName", newJString(serviceName))
  result = call_598318.call(path_598319, query_598320, nil, nil, nil)

var usersGenerateSsoUrl* = Call_UsersGenerateSsoUrl_598309(
    name: "usersGenerateSsoUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{uid}/generateSsoUrl",
    validator: validate_UsersGenerateSsoUrl_598310, base: "",
    url: url_UsersGenerateSsoUrl_598311, schemes: {Scheme.Https})
type
  Call_UserGroupsListByUser_598321 = ref object of OpenApiRestCall_596467
proc url_UserGroupsListByUser_598323(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "uid" in path, "`uid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "uid"),
               (kind: ConstantSegment, value: "/groups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserGroupsListByUser_598322(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all user groups.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_598324 = path.getOrDefault("resourceGroupName")
  valid_598324 = validateParameter(valid_598324, JString, required = true,
                                 default = nil)
  if valid_598324 != nil:
    section.add "resourceGroupName", valid_598324
  var valid_598325 = path.getOrDefault("subscriptionId")
  valid_598325 = validateParameter(valid_598325, JString, required = true,
                                 default = nil)
  if valid_598325 != nil:
    section.add "subscriptionId", valid_598325
  var valid_598326 = path.getOrDefault("uid")
  valid_598326 = validateParameter(valid_598326, JString, required = true,
                                 default = nil)
  if valid_598326 != nil:
    section.add "uid", valid_598326
  var valid_598327 = path.getOrDefault("serviceName")
  valid_598327 = validateParameter(valid_598327, JString, required = true,
                                 default = nil)
  if valid_598327 != nil:
    section.add "serviceName", valid_598327
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_598328 = query.getOrDefault("api-version")
  valid_598328 = validateParameter(valid_598328, JString, required = true,
                                 default = nil)
  if valid_598328 != nil:
    section.add "api-version", valid_598328
  var valid_598329 = query.getOrDefault("$top")
  valid_598329 = validateParameter(valid_598329, JInt, required = false, default = nil)
  if valid_598329 != nil:
    section.add "$top", valid_598329
  var valid_598330 = query.getOrDefault("$skip")
  valid_598330 = validateParameter(valid_598330, JInt, required = false, default = nil)
  if valid_598330 != nil:
    section.add "$skip", valid_598330
  var valid_598331 = query.getOrDefault("$filter")
  valid_598331 = validateParameter(valid_598331, JString, required = false,
                                 default = nil)
  if valid_598331 != nil:
    section.add "$filter", valid_598331
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598332: Call_UserGroupsListByUser_598321; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all user groups.
  ## 
  let valid = call_598332.validator(path, query, header, formData, body)
  let scheme = call_598332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598332.url(scheme.get, call_598332.host, call_598332.base,
                         call_598332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598332, url, valid)

proc call*(call_598333: Call_UserGroupsListByUser_598321;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          uid: string; serviceName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## userGroupsListByUser
  ## Lists all user groups.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   uid: string (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  var path_598334 = newJObject()
  var query_598335 = newJObject()
  add(path_598334, "resourceGroupName", newJString(resourceGroupName))
  add(query_598335, "api-version", newJString(apiVersion))
  add(path_598334, "subscriptionId", newJString(subscriptionId))
  add(query_598335, "$top", newJInt(Top))
  add(query_598335, "$skip", newJInt(Skip))
  add(path_598334, "uid", newJString(uid))
  add(path_598334, "serviceName", newJString(serviceName))
  add(query_598335, "$filter", newJString(Filter))
  result = call_598333.call(path_598334, query_598335, nil, nil, nil)

var userGroupsListByUser* = Call_UserGroupsListByUser_598321(
    name: "userGroupsListByUser", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{uid}/groups",
    validator: validate_UserGroupsListByUser_598322, base: "",
    url: url_UserGroupsListByUser_598323, schemes: {Scheme.Https})
type
  Call_UserIdentitiesListByUser_598336 = ref object of OpenApiRestCall_596467
proc url_UserIdentitiesListByUser_598338(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "uid" in path, "`uid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "uid"),
               (kind: ConstantSegment, value: "/identities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserIdentitiesListByUser_598337(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all user identities.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_598339 = path.getOrDefault("resourceGroupName")
  valid_598339 = validateParameter(valid_598339, JString, required = true,
                                 default = nil)
  if valid_598339 != nil:
    section.add "resourceGroupName", valid_598339
  var valid_598340 = path.getOrDefault("subscriptionId")
  valid_598340 = validateParameter(valid_598340, JString, required = true,
                                 default = nil)
  if valid_598340 != nil:
    section.add "subscriptionId", valid_598340
  var valid_598341 = path.getOrDefault("uid")
  valid_598341 = validateParameter(valid_598341, JString, required = true,
                                 default = nil)
  if valid_598341 != nil:
    section.add "uid", valid_598341
  var valid_598342 = path.getOrDefault("serviceName")
  valid_598342 = validateParameter(valid_598342, JString, required = true,
                                 default = nil)
  if valid_598342 != nil:
    section.add "serviceName", valid_598342
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_598343 = query.getOrDefault("api-version")
  valid_598343 = validateParameter(valid_598343, JString, required = true,
                                 default = nil)
  if valid_598343 != nil:
    section.add "api-version", valid_598343
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598344: Call_UserIdentitiesListByUser_598336; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all user identities.
  ## 
  let valid = call_598344.validator(path, query, header, formData, body)
  let scheme = call_598344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598344.url(scheme.get, call_598344.host, call_598344.base,
                         call_598344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598344, url, valid)

proc call*(call_598345: Call_UserIdentitiesListByUser_598336;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          uid: string; serviceName: string): Recallable =
  ## userIdentitiesListByUser
  ## Lists all user identities.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   uid: string (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_598346 = newJObject()
  var query_598347 = newJObject()
  add(path_598346, "resourceGroupName", newJString(resourceGroupName))
  add(query_598347, "api-version", newJString(apiVersion))
  add(path_598346, "subscriptionId", newJString(subscriptionId))
  add(path_598346, "uid", newJString(uid))
  add(path_598346, "serviceName", newJString(serviceName))
  result = call_598345.call(path_598346, query_598347, nil, nil, nil)

var userIdentitiesListByUser* = Call_UserIdentitiesListByUser_598336(
    name: "userIdentitiesListByUser", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{uid}/identities",
    validator: validate_UserIdentitiesListByUser_598337, base: "",
    url: url_UserIdentitiesListByUser_598338, schemes: {Scheme.Https})
type
  Call_UserSubscriptionsListByUser_598348 = ref object of OpenApiRestCall_596467
proc url_UserSubscriptionsListByUser_598350(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "uid" in path, "`uid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "uid"),
               (kind: ConstantSegment, value: "/subscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserSubscriptionsListByUser_598349(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the collection of subscriptions of the specified user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_598351 = path.getOrDefault("resourceGroupName")
  valid_598351 = validateParameter(valid_598351, JString, required = true,
                                 default = nil)
  if valid_598351 != nil:
    section.add "resourceGroupName", valid_598351
  var valid_598352 = path.getOrDefault("subscriptionId")
  valid_598352 = validateParameter(valid_598352, JString, required = true,
                                 default = nil)
  if valid_598352 != nil:
    section.add "subscriptionId", valid_598352
  var valid_598353 = path.getOrDefault("uid")
  valid_598353 = validateParameter(valid_598353, JString, required = true,
                                 default = nil)
  if valid_598353 != nil:
    section.add "uid", valid_598353
  var valid_598354 = path.getOrDefault("serviceName")
  valid_598354 = validateParameter(valid_598354, JString, required = true,
                                 default = nil)
  if valid_598354 != nil:
    section.add "serviceName", valid_598354
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field        | Supported operators    | Supported functions                         |
  ## 
  ## |--------------|------------------------|---------------------------------------------|
  ## | id           | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name         | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | stateComment | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | userId       | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | productId    | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | state        | eq                     |                                             |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_598355 = query.getOrDefault("api-version")
  valid_598355 = validateParameter(valid_598355, JString, required = true,
                                 default = nil)
  if valid_598355 != nil:
    section.add "api-version", valid_598355
  var valid_598356 = query.getOrDefault("$top")
  valid_598356 = validateParameter(valid_598356, JInt, required = false, default = nil)
  if valid_598356 != nil:
    section.add "$top", valid_598356
  var valid_598357 = query.getOrDefault("$skip")
  valid_598357 = validateParameter(valid_598357, JInt, required = false, default = nil)
  if valid_598357 != nil:
    section.add "$skip", valid_598357
  var valid_598358 = query.getOrDefault("$filter")
  valid_598358 = validateParameter(valid_598358, JString, required = false,
                                 default = nil)
  if valid_598358 != nil:
    section.add "$filter", valid_598358
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598359: Call_UserSubscriptionsListByUser_598348; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the collection of subscriptions of the specified user.
  ## 
  let valid = call_598359.validator(path, query, header, formData, body)
  let scheme = call_598359.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598359.url(scheme.get, call_598359.host, call_598359.base,
                         call_598359.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598359, url, valid)

proc call*(call_598360: Call_UserSubscriptionsListByUser_598348;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          uid: string; serviceName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## userSubscriptionsListByUser
  ## Lists the collection of subscriptions of the specified user.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   uid: string (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field        | Supported operators    | Supported functions                         |
  ## 
  ## |--------------|------------------------|---------------------------------------------|
  ## | id           | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name         | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | stateComment | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | userId       | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | productId    | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | state        | eq                     |                                             |
  var path_598361 = newJObject()
  var query_598362 = newJObject()
  add(path_598361, "resourceGroupName", newJString(resourceGroupName))
  add(query_598362, "api-version", newJString(apiVersion))
  add(path_598361, "subscriptionId", newJString(subscriptionId))
  add(query_598362, "$top", newJInt(Top))
  add(query_598362, "$skip", newJInt(Skip))
  add(path_598361, "uid", newJString(uid))
  add(path_598361, "serviceName", newJString(serviceName))
  add(query_598362, "$filter", newJString(Filter))
  result = call_598360.call(path_598361, query_598362, nil, nil, nil)

var userSubscriptionsListByUser* = Call_UserSubscriptionsListByUser_598348(
    name: "userSubscriptionsListByUser", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{uid}/subscriptions",
    validator: validate_UserSubscriptionsListByUser_598349, base: "",
    url: url_UserSubscriptionsListByUser_598350, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
