
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2019-01-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for performing operations on logger entity Azure API Management deployment.The Logger entity in API Management represents an event sink that you can use to log API Management events. Currently the Logger entity supports logging API Management events to Azure EventHub.
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

  OpenApiRestCall_563556 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563556](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563556): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "apimanagement-apimloggers"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_LoggerListByService_563778 = ref object of OpenApiRestCall_563556
proc url_LoggerListByService_563780(protocol: Scheme; host: string; base: string;
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

proc validate_LoggerListByService_563779(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Lists a collection of loggers in the specified service instance.
  ## 
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-log-event-hubs
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_563943 = path.getOrDefault("serviceName")
  valid_563943 = validateParameter(valid_563943, JString, required = true,
                                 default = nil)
  if valid_563943 != nil:
    section.add "serviceName", valid_563943
  var valid_563944 = path.getOrDefault("subscriptionId")
  valid_563944 = validateParameter(valid_563944, JString, required = true,
                                 default = nil)
  if valid_563944 != nil:
    section.add "subscriptionId", valid_563944
  var valid_563945 = path.getOrDefault("resourceGroupName")
  valid_563945 = validateParameter(valid_563945, JString, required = true,
                                 default = nil)
  if valid_563945 != nil:
    section.add "resourceGroupName", valid_563945
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : Number of records to return.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : |   Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith | </br>| description | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith | </br>| loggerType | filter | eq |     | </br>| resourceId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith | </br>
  section = newJObject()
  var valid_563946 = query.getOrDefault("$top")
  valid_563946 = validateParameter(valid_563946, JInt, required = false, default = nil)
  if valid_563946 != nil:
    section.add "$top", valid_563946
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563947 = query.getOrDefault("api-version")
  valid_563947 = validateParameter(valid_563947, JString, required = true,
                                 default = nil)
  if valid_563947 != nil:
    section.add "api-version", valid_563947
  var valid_563948 = query.getOrDefault("$skip")
  valid_563948 = validateParameter(valid_563948, JInt, required = false, default = nil)
  if valid_563948 != nil:
    section.add "$skip", valid_563948
  var valid_563949 = query.getOrDefault("$filter")
  valid_563949 = validateParameter(valid_563949, JString, required = false,
                                 default = nil)
  if valid_563949 != nil:
    section.add "$filter", valid_563949
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563976: Call_LoggerListByService_563778; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of loggers in the specified service instance.
  ## 
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-log-event-hubs
  let valid = call_563976.validator(path, query, header, formData, body)
  let scheme = call_563976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563976.url(scheme.get, call_563976.host, call_563976.base,
                         call_563976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563976, url, valid)

proc call*(call_564047: Call_LoggerListByService_563778; serviceName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## loggerListByService
  ## Lists a collection of loggers in the specified service instance.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-log-event-hubs
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Top: int
  ##      : Number of records to return.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : |   Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith | </br>| description | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith | </br>| loggerType | filter | eq |     | </br>| resourceId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith | </br>
  var path_564048 = newJObject()
  var query_564050 = newJObject()
  add(path_564048, "serviceName", newJString(serviceName))
  add(query_564050, "$top", newJInt(Top))
  add(query_564050, "api-version", newJString(apiVersion))
  add(path_564048, "subscriptionId", newJString(subscriptionId))
  add(query_564050, "$skip", newJInt(Skip))
  add(path_564048, "resourceGroupName", newJString(resourceGroupName))
  add(query_564050, "$filter", newJString(Filter))
  result = call_564047.call(path_564048, query_564050, nil, nil, nil)

var loggerListByService* = Call_LoggerListByService_563778(
    name: "loggerListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/loggers",
    validator: validate_LoggerListByService_563779, base: "",
    url: url_LoggerListByService_563780, schemes: {Scheme.Https})
type
  Call_LoggerCreateOrUpdate_564101 = ref object of OpenApiRestCall_563556
proc url_LoggerCreateOrUpdate_564103(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "loggerId" in path, "`loggerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/loggers/"),
               (kind: VariableSegment, value: "loggerId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggerCreateOrUpdate_564102(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or Updates a logger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loggerId: JString (required)
  ##           : Logger identifier. Must be unique in the API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564131 = path.getOrDefault("serviceName")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "serviceName", valid_564131
  var valid_564132 = path.getOrDefault("subscriptionId")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "subscriptionId", valid_564132
  var valid_564133 = path.getOrDefault("loggerId")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "loggerId", valid_564133
  var valid_564134 = path.getOrDefault("resourceGroupName")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "resourceGroupName", valid_564134
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564135 = query.getOrDefault("api-version")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "api-version", valid_564135
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_564136 = header.getOrDefault("If-Match")
  valid_564136 = validateParameter(valid_564136, JString, required = false,
                                 default = nil)
  if valid_564136 != nil:
    section.add "If-Match", valid_564136
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

proc call*(call_564138: Call_LoggerCreateOrUpdate_564101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or Updates a logger.
  ## 
  let valid = call_564138.validator(path, query, header, formData, body)
  let scheme = call_564138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564138.url(scheme.get, call_564138.host, call_564138.base,
                         call_564138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564138, url, valid)

proc call*(call_564139: Call_LoggerCreateOrUpdate_564101; serviceName: string;
          apiVersion: string; subscriptionId: string; loggerId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## loggerCreateOrUpdate
  ## Creates or Updates a logger.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loggerId: string (required)
  ##           : Logger identifier. Must be unique in the API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  var path_564140 = newJObject()
  var query_564141 = newJObject()
  var body_564142 = newJObject()
  add(path_564140, "serviceName", newJString(serviceName))
  add(query_564141, "api-version", newJString(apiVersion))
  add(path_564140, "subscriptionId", newJString(subscriptionId))
  add(path_564140, "loggerId", newJString(loggerId))
  add(path_564140, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564142 = parameters
  result = call_564139.call(path_564140, query_564141, nil, nil, body_564142)

var loggerCreateOrUpdate* = Call_LoggerCreateOrUpdate_564101(
    name: "loggerCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/loggers/{loggerId}",
    validator: validate_LoggerCreateOrUpdate_564102, base: "",
    url: url_LoggerCreateOrUpdate_564103, schemes: {Scheme.Https})
type
  Call_LoggerGetEntityTag_564157 = ref object of OpenApiRestCall_563556
proc url_LoggerGetEntityTag_564159(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "loggerId" in path, "`loggerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/loggers/"),
               (kind: VariableSegment, value: "loggerId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggerGetEntityTag_564158(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the logger specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loggerId: JString (required)
  ##           : Logger identifier. Must be unique in the API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564160 = path.getOrDefault("serviceName")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "serviceName", valid_564160
  var valid_564161 = path.getOrDefault("subscriptionId")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "subscriptionId", valid_564161
  var valid_564162 = path.getOrDefault("loggerId")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "loggerId", valid_564162
  var valid_564163 = path.getOrDefault("resourceGroupName")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "resourceGroupName", valid_564163
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564164 = query.getOrDefault("api-version")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "api-version", valid_564164
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564165: Call_LoggerGetEntityTag_564157; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the logger specified by its identifier.
  ## 
  let valid = call_564165.validator(path, query, header, formData, body)
  let scheme = call_564165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564165.url(scheme.get, call_564165.host, call_564165.base,
                         call_564165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564165, url, valid)

proc call*(call_564166: Call_LoggerGetEntityTag_564157; serviceName: string;
          apiVersion: string; subscriptionId: string; loggerId: string;
          resourceGroupName: string): Recallable =
  ## loggerGetEntityTag
  ## Gets the entity state (Etag) version of the logger specified by its identifier.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loggerId: string (required)
  ##           : Logger identifier. Must be unique in the API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564167 = newJObject()
  var query_564168 = newJObject()
  add(path_564167, "serviceName", newJString(serviceName))
  add(query_564168, "api-version", newJString(apiVersion))
  add(path_564167, "subscriptionId", newJString(subscriptionId))
  add(path_564167, "loggerId", newJString(loggerId))
  add(path_564167, "resourceGroupName", newJString(resourceGroupName))
  result = call_564166.call(path_564167, query_564168, nil, nil, nil)

var loggerGetEntityTag* = Call_LoggerGetEntityTag_564157(
    name: "loggerGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/loggers/{loggerId}",
    validator: validate_LoggerGetEntityTag_564158, base: "",
    url: url_LoggerGetEntityTag_564159, schemes: {Scheme.Https})
type
  Call_LoggerGet_564089 = ref object of OpenApiRestCall_563556
proc url_LoggerGet_564091(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "loggerId" in path, "`loggerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/loggers/"),
               (kind: VariableSegment, value: "loggerId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggerGet_564090(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the logger specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loggerId: JString (required)
  ##           : Logger identifier. Must be unique in the API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564092 = path.getOrDefault("serviceName")
  valid_564092 = validateParameter(valid_564092, JString, required = true,
                                 default = nil)
  if valid_564092 != nil:
    section.add "serviceName", valid_564092
  var valid_564093 = path.getOrDefault("subscriptionId")
  valid_564093 = validateParameter(valid_564093, JString, required = true,
                                 default = nil)
  if valid_564093 != nil:
    section.add "subscriptionId", valid_564093
  var valid_564094 = path.getOrDefault("loggerId")
  valid_564094 = validateParameter(valid_564094, JString, required = true,
                                 default = nil)
  if valid_564094 != nil:
    section.add "loggerId", valid_564094
  var valid_564095 = path.getOrDefault("resourceGroupName")
  valid_564095 = validateParameter(valid_564095, JString, required = true,
                                 default = nil)
  if valid_564095 != nil:
    section.add "resourceGroupName", valid_564095
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564096 = query.getOrDefault("api-version")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "api-version", valid_564096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564097: Call_LoggerGet_564089; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the logger specified by its identifier.
  ## 
  let valid = call_564097.validator(path, query, header, formData, body)
  let scheme = call_564097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564097.url(scheme.get, call_564097.host, call_564097.base,
                         call_564097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564097, url, valid)

proc call*(call_564098: Call_LoggerGet_564089; serviceName: string;
          apiVersion: string; subscriptionId: string; loggerId: string;
          resourceGroupName: string): Recallable =
  ## loggerGet
  ## Gets the details of the logger specified by its identifier.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loggerId: string (required)
  ##           : Logger identifier. Must be unique in the API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564099 = newJObject()
  var query_564100 = newJObject()
  add(path_564099, "serviceName", newJString(serviceName))
  add(query_564100, "api-version", newJString(apiVersion))
  add(path_564099, "subscriptionId", newJString(subscriptionId))
  add(path_564099, "loggerId", newJString(loggerId))
  add(path_564099, "resourceGroupName", newJString(resourceGroupName))
  result = call_564098.call(path_564099, query_564100, nil, nil, nil)

var loggerGet* = Call_LoggerGet_564089(name: "loggerGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/loggers/{loggerId}",
                                    validator: validate_LoggerGet_564090,
                                    base: "", url: url_LoggerGet_564091,
                                    schemes: {Scheme.Https})
type
  Call_LoggerUpdate_564169 = ref object of OpenApiRestCall_563556
proc url_LoggerUpdate_564171(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "loggerId" in path, "`loggerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/loggers/"),
               (kind: VariableSegment, value: "loggerId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggerUpdate_564170(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing logger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loggerId: JString (required)
  ##           : Logger identifier. Must be unique in the API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564172 = path.getOrDefault("serviceName")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "serviceName", valid_564172
  var valid_564173 = path.getOrDefault("subscriptionId")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "subscriptionId", valid_564173
  var valid_564174 = path.getOrDefault("loggerId")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "loggerId", valid_564174
  var valid_564175 = path.getOrDefault("resourceGroupName")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = nil)
  if valid_564175 != nil:
    section.add "resourceGroupName", valid_564175
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564176 = query.getOrDefault("api-version")
  valid_564176 = validateParameter(valid_564176, JString, required = true,
                                 default = nil)
  if valid_564176 != nil:
    section.add "api-version", valid_564176
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564177 = header.getOrDefault("If-Match")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "If-Match", valid_564177
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

proc call*(call_564179: Call_LoggerUpdate_564169; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing logger.
  ## 
  let valid = call_564179.validator(path, query, header, formData, body)
  let scheme = call_564179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564179.url(scheme.get, call_564179.host, call_564179.base,
                         call_564179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564179, url, valid)

proc call*(call_564180: Call_LoggerUpdate_564169; serviceName: string;
          apiVersion: string; subscriptionId: string; loggerId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## loggerUpdate
  ## Updates an existing logger.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loggerId: string (required)
  ##           : Logger identifier. Must be unique in the API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Update parameters.
  var path_564181 = newJObject()
  var query_564182 = newJObject()
  var body_564183 = newJObject()
  add(path_564181, "serviceName", newJString(serviceName))
  add(query_564182, "api-version", newJString(apiVersion))
  add(path_564181, "subscriptionId", newJString(subscriptionId))
  add(path_564181, "loggerId", newJString(loggerId))
  add(path_564181, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564183 = parameters
  result = call_564180.call(path_564181, query_564182, nil, nil, body_564183)

var loggerUpdate* = Call_LoggerUpdate_564169(name: "loggerUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/loggers/{loggerId}",
    validator: validate_LoggerUpdate_564170, base: "", url: url_LoggerUpdate_564171,
    schemes: {Scheme.Https})
type
  Call_LoggerDelete_564143 = ref object of OpenApiRestCall_563556
proc url_LoggerDelete_564145(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "loggerId" in path, "`loggerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/loggers/"),
               (kind: VariableSegment, value: "loggerId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggerDelete_564144(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified logger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loggerId: JString (required)
  ##           : Logger identifier. Must be unique in the API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564146 = path.getOrDefault("serviceName")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = nil)
  if valid_564146 != nil:
    section.add "serviceName", valid_564146
  var valid_564147 = path.getOrDefault("subscriptionId")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "subscriptionId", valid_564147
  var valid_564148 = path.getOrDefault("loggerId")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "loggerId", valid_564148
  var valid_564149 = path.getOrDefault("resourceGroupName")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "resourceGroupName", valid_564149
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   force: JBool
  ##        : Force deletion even if diagnostic is attached.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564150 = query.getOrDefault("api-version")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "api-version", valid_564150
  var valid_564151 = query.getOrDefault("force")
  valid_564151 = validateParameter(valid_564151, JBool, required = false, default = nil)
  if valid_564151 != nil:
    section.add "force", valid_564151
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564152 = header.getOrDefault("If-Match")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "If-Match", valid_564152
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564153: Call_LoggerDelete_564143; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified logger.
  ## 
  let valid = call_564153.validator(path, query, header, formData, body)
  let scheme = call_564153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564153.url(scheme.get, call_564153.host, call_564153.base,
                         call_564153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564153, url, valid)

proc call*(call_564154: Call_LoggerDelete_564143; serviceName: string;
          apiVersion: string; subscriptionId: string; loggerId: string;
          resourceGroupName: string; force: bool = false): Recallable =
  ## loggerDelete
  ## Deletes the specified logger.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loggerId: string (required)
  ##           : Logger identifier. Must be unique in the API Management service instance.
  ##   force: bool
  ##        : Force deletion even if diagnostic is attached.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564155 = newJObject()
  var query_564156 = newJObject()
  add(path_564155, "serviceName", newJString(serviceName))
  add(query_564156, "api-version", newJString(apiVersion))
  add(path_564155, "subscriptionId", newJString(subscriptionId))
  add(path_564155, "loggerId", newJString(loggerId))
  add(query_564156, "force", newJBool(force))
  add(path_564155, "resourceGroupName", newJString(resourceGroupName))
  result = call_564154.call(path_564155, query_564156, nil, nil, nil)

var loggerDelete* = Call_LoggerDelete_564143(name: "loggerDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/loggers/{loggerId}",
    validator: validate_LoggerDelete_564144, base: "", url: url_LoggerDelete_564145,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
