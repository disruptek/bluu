
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: MariaDBManagementClient
## version: 2018-06-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The Microsoft Azure management API provides create, read, update, and delete functionality for Azure MariaDB resources including servers, databases, firewall rules, VNET rules, log files and configurations with new business model.
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

  OpenApiRestCall_573658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573658): Option[Scheme] {.used.} =
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
  macServiceName = "mariadb"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_573880 = ref object of OpenApiRestCall_573658
proc url_OperationsList_573882(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_573881(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574041 = query.getOrDefault("api-version")
  valid_574041 = validateParameter(valid_574041, JString, required = true,
                                 default = nil)
  if valid_574041 != nil:
    section.add "api-version", valid_574041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574064: Call_OperationsList_573880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available REST API operations.
  ## 
  let valid = call_574064.validator(path, query, header, formData, body)
  let scheme = call_574064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574064.url(scheme.get, call_574064.host, call_574064.base,
                         call_574064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574064, url, valid)

proc call*(call_574135: Call_OperationsList_573880; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available REST API operations.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  var query_574136 = newJObject()
  add(query_574136, "api-version", newJString(apiVersion))
  result = call_574135.call(nil, query_574136, nil, nil, nil)

var operationsList* = Call_OperationsList_573880(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.DBforMariaDB/operations",
    validator: validate_OperationsList_573881, base: "", url: url_OperationsList_573882,
    schemes: {Scheme.Https})
type
  Call_CheckNameAvailabilityExecute_574176 = ref object of OpenApiRestCall_573658
proc url_CheckNameAvailabilityExecute_574178(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DBforMariaDB/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CheckNameAvailabilityExecute_574177(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check the availability of name for resource
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574210 = path.getOrDefault("subscriptionId")
  valid_574210 = validateParameter(valid_574210, JString, required = true,
                                 default = nil)
  if valid_574210 != nil:
    section.add "subscriptionId", valid_574210
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574211 = query.getOrDefault("api-version")
  valid_574211 = validateParameter(valid_574211, JString, required = true,
                                 default = nil)
  if valid_574211 != nil:
    section.add "api-version", valid_574211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   nameAvailabilityRequest: JObject (required)
  ##                          : The required parameters for checking if resource name is available.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574213: Call_CheckNameAvailabilityExecute_574176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check the availability of name for resource
  ## 
  let valid = call_574213.validator(path, query, header, formData, body)
  let scheme = call_574213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574213.url(scheme.get, call_574213.host, call_574213.base,
                         call_574213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574213, url, valid)

proc call*(call_574214: Call_CheckNameAvailabilityExecute_574176;
          apiVersion: string; subscriptionId: string;
          nameAvailabilityRequest: JsonNode): Recallable =
  ## checkNameAvailabilityExecute
  ## Check the availability of name for resource
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   nameAvailabilityRequest: JObject (required)
  ##                          : The required parameters for checking if resource name is available.
  var path_574215 = newJObject()
  var query_574216 = newJObject()
  var body_574217 = newJObject()
  add(query_574216, "api-version", newJString(apiVersion))
  add(path_574215, "subscriptionId", newJString(subscriptionId))
  if nameAvailabilityRequest != nil:
    body_574217 = nameAvailabilityRequest
  result = call_574214.call(path_574215, query_574216, nil, nil, body_574217)

var checkNameAvailabilityExecute* = Call_CheckNameAvailabilityExecute_574176(
    name: "checkNameAvailabilityExecute", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DBforMariaDB/checkNameAvailability",
    validator: validate_CheckNameAvailabilityExecute_574177, base: "",
    url: url_CheckNameAvailabilityExecute_574178, schemes: {Scheme.Https})
type
  Call_LocationBasedPerformanceTierList_574218 = ref object of OpenApiRestCall_573658
proc url_LocationBasedPerformanceTierList_574220(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DBforMariaDB/locations/"),
               (kind: VariableSegment, value: "locationName"),
               (kind: ConstantSegment, value: "/performanceTiers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LocationBasedPerformanceTierList_574219(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the performance tiers at specified location in a given subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   locationName: JString (required)
  ##               : The name of the location.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574221 = path.getOrDefault("subscriptionId")
  valid_574221 = validateParameter(valid_574221, JString, required = true,
                                 default = nil)
  if valid_574221 != nil:
    section.add "subscriptionId", valid_574221
  var valid_574222 = path.getOrDefault("locationName")
  valid_574222 = validateParameter(valid_574222, JString, required = true,
                                 default = nil)
  if valid_574222 != nil:
    section.add "locationName", valid_574222
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574223 = query.getOrDefault("api-version")
  valid_574223 = validateParameter(valid_574223, JString, required = true,
                                 default = nil)
  if valid_574223 != nil:
    section.add "api-version", valid_574223
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574224: Call_LocationBasedPerformanceTierList_574218;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all the performance tiers at specified location in a given subscription.
  ## 
  let valid = call_574224.validator(path, query, header, formData, body)
  let scheme = call_574224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574224.url(scheme.get, call_574224.host, call_574224.base,
                         call_574224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574224, url, valid)

proc call*(call_574225: Call_LocationBasedPerformanceTierList_574218;
          apiVersion: string; subscriptionId: string; locationName: string): Recallable =
  ## locationBasedPerformanceTierList
  ## List all the performance tiers at specified location in a given subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   locationName: string (required)
  ##               : The name of the location.
  var path_574226 = newJObject()
  var query_574227 = newJObject()
  add(query_574227, "api-version", newJString(apiVersion))
  add(path_574226, "subscriptionId", newJString(subscriptionId))
  add(path_574226, "locationName", newJString(locationName))
  result = call_574225.call(path_574226, query_574227, nil, nil, nil)

var locationBasedPerformanceTierList* = Call_LocationBasedPerformanceTierList_574218(
    name: "locationBasedPerformanceTierList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DBforMariaDB/locations/{locationName}/performanceTiers",
    validator: validate_LocationBasedPerformanceTierList_574219, base: "",
    url: url_LocationBasedPerformanceTierList_574220, schemes: {Scheme.Https})
type
  Call_ServersList_574228 = ref object of OpenApiRestCall_573658
proc url_ServersList_574230(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMariaDB/servers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersList_574229(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the servers in a given subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574231 = path.getOrDefault("subscriptionId")
  valid_574231 = validateParameter(valid_574231, JString, required = true,
                                 default = nil)
  if valid_574231 != nil:
    section.add "subscriptionId", valid_574231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574232 = query.getOrDefault("api-version")
  valid_574232 = validateParameter(valid_574232, JString, required = true,
                                 default = nil)
  if valid_574232 != nil:
    section.add "api-version", valid_574232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574233: Call_ServersList_574228; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the servers in a given subscription.
  ## 
  let valid = call_574233.validator(path, query, header, formData, body)
  let scheme = call_574233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574233.url(scheme.get, call_574233.host, call_574233.base,
                         call_574233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574233, url, valid)

proc call*(call_574234: Call_ServersList_574228; apiVersion: string;
          subscriptionId: string): Recallable =
  ## serversList
  ## List all the servers in a given subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_574235 = newJObject()
  var query_574236 = newJObject()
  add(query_574236, "api-version", newJString(apiVersion))
  add(path_574235, "subscriptionId", newJString(subscriptionId))
  result = call_574234.call(path_574235, query_574236, nil, nil, nil)

var serversList* = Call_ServersList_574228(name: "serversList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DBforMariaDB/servers",
                                        validator: validate_ServersList_574229,
                                        base: "", url: url_ServersList_574230,
                                        schemes: {Scheme.Https})
type
  Call_ServersListByResourceGroup_574237 = ref object of OpenApiRestCall_573658
proc url_ServersListByResourceGroup_574239(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMariaDB/servers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersListByResourceGroup_574238(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the servers in a given resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574240 = path.getOrDefault("resourceGroupName")
  valid_574240 = validateParameter(valid_574240, JString, required = true,
                                 default = nil)
  if valid_574240 != nil:
    section.add "resourceGroupName", valid_574240
  var valid_574241 = path.getOrDefault("subscriptionId")
  valid_574241 = validateParameter(valid_574241, JString, required = true,
                                 default = nil)
  if valid_574241 != nil:
    section.add "subscriptionId", valid_574241
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574242 = query.getOrDefault("api-version")
  valid_574242 = validateParameter(valid_574242, JString, required = true,
                                 default = nil)
  if valid_574242 != nil:
    section.add "api-version", valid_574242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574243: Call_ServersListByResourceGroup_574237; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the servers in a given resource group.
  ## 
  let valid = call_574243.validator(path, query, header, formData, body)
  let scheme = call_574243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574243.url(scheme.get, call_574243.host, call_574243.base,
                         call_574243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574243, url, valid)

proc call*(call_574244: Call_ServersListByResourceGroup_574237;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## serversListByResourceGroup
  ## List all the servers in a given resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_574245 = newJObject()
  var query_574246 = newJObject()
  add(path_574245, "resourceGroupName", newJString(resourceGroupName))
  add(query_574246, "api-version", newJString(apiVersion))
  add(path_574245, "subscriptionId", newJString(subscriptionId))
  result = call_574244.call(path_574245, query_574246, nil, nil, nil)

var serversListByResourceGroup* = Call_ServersListByResourceGroup_574237(
    name: "serversListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMariaDB/servers",
    validator: validate_ServersListByResourceGroup_574238, base: "",
    url: url_ServersListByResourceGroup_574239, schemes: {Scheme.Https})
type
  Call_ServersCreate_574258 = ref object of OpenApiRestCall_573658
proc url_ServersCreate_574260(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMariaDB/servers/"),
               (kind: VariableSegment, value: "serverName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersCreate_574259(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new server or updates an existing server. The update action will overwrite the existing server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574261 = path.getOrDefault("resourceGroupName")
  valid_574261 = validateParameter(valid_574261, JString, required = true,
                                 default = nil)
  if valid_574261 != nil:
    section.add "resourceGroupName", valid_574261
  var valid_574262 = path.getOrDefault("serverName")
  valid_574262 = validateParameter(valid_574262, JString, required = true,
                                 default = nil)
  if valid_574262 != nil:
    section.add "serverName", valid_574262
  var valid_574263 = path.getOrDefault("subscriptionId")
  valid_574263 = validateParameter(valid_574263, JString, required = true,
                                 default = nil)
  if valid_574263 != nil:
    section.add "subscriptionId", valid_574263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574264 = query.getOrDefault("api-version")
  valid_574264 = validateParameter(valid_574264, JString, required = true,
                                 default = nil)
  if valid_574264 != nil:
    section.add "api-version", valid_574264
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The required parameters for creating or updating a server.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574266: Call_ServersCreate_574258; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new server or updates an existing server. The update action will overwrite the existing server.
  ## 
  let valid = call_574266.validator(path, query, header, formData, body)
  let scheme = call_574266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574266.url(scheme.get, call_574266.host, call_574266.base,
                         call_574266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574266, url, valid)

proc call*(call_574267: Call_ServersCreate_574258; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## serversCreate
  ## Creates a new server or updates an existing server. The update action will overwrite the existing server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   parameters: JObject (required)
  ##             : The required parameters for creating or updating a server.
  var path_574268 = newJObject()
  var query_574269 = newJObject()
  var body_574270 = newJObject()
  add(path_574268, "resourceGroupName", newJString(resourceGroupName))
  add(query_574269, "api-version", newJString(apiVersion))
  add(path_574268, "serverName", newJString(serverName))
  add(path_574268, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574270 = parameters
  result = call_574267.call(path_574268, query_574269, nil, nil, body_574270)

var serversCreate* = Call_ServersCreate_574258(name: "serversCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMariaDB/servers/{serverName}",
    validator: validate_ServersCreate_574259, base: "", url: url_ServersCreate_574260,
    schemes: {Scheme.Https})
type
  Call_ServersGet_574247 = ref object of OpenApiRestCall_573658
proc url_ServersGet_574249(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMariaDB/servers/"),
               (kind: VariableSegment, value: "serverName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersGet_574248(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about a server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574250 = path.getOrDefault("resourceGroupName")
  valid_574250 = validateParameter(valid_574250, JString, required = true,
                                 default = nil)
  if valid_574250 != nil:
    section.add "resourceGroupName", valid_574250
  var valid_574251 = path.getOrDefault("serverName")
  valid_574251 = validateParameter(valid_574251, JString, required = true,
                                 default = nil)
  if valid_574251 != nil:
    section.add "serverName", valid_574251
  var valid_574252 = path.getOrDefault("subscriptionId")
  valid_574252 = validateParameter(valid_574252, JString, required = true,
                                 default = nil)
  if valid_574252 != nil:
    section.add "subscriptionId", valid_574252
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574253 = query.getOrDefault("api-version")
  valid_574253 = validateParameter(valid_574253, JString, required = true,
                                 default = nil)
  if valid_574253 != nil:
    section.add "api-version", valid_574253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574254: Call_ServersGet_574247; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a server.
  ## 
  let valid = call_574254.validator(path, query, header, formData, body)
  let scheme = call_574254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574254.url(scheme.get, call_574254.host, call_574254.base,
                         call_574254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574254, url, valid)

proc call*(call_574255: Call_ServersGet_574247; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string): Recallable =
  ## serversGet
  ## Gets information about a server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_574256 = newJObject()
  var query_574257 = newJObject()
  add(path_574256, "resourceGroupName", newJString(resourceGroupName))
  add(query_574257, "api-version", newJString(apiVersion))
  add(path_574256, "serverName", newJString(serverName))
  add(path_574256, "subscriptionId", newJString(subscriptionId))
  result = call_574255.call(path_574256, query_574257, nil, nil, nil)

var serversGet* = Call_ServersGet_574247(name: "serversGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMariaDB/servers/{serverName}",
                                      validator: validate_ServersGet_574248,
                                      base: "", url: url_ServersGet_574249,
                                      schemes: {Scheme.Https})
type
  Call_ServersUpdate_574282 = ref object of OpenApiRestCall_573658
proc url_ServersUpdate_574284(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMariaDB/servers/"),
               (kind: VariableSegment, value: "serverName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersUpdate_574283(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing server. The request body can contain one to many of the properties present in the normal server definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574285 = path.getOrDefault("resourceGroupName")
  valid_574285 = validateParameter(valid_574285, JString, required = true,
                                 default = nil)
  if valid_574285 != nil:
    section.add "resourceGroupName", valid_574285
  var valid_574286 = path.getOrDefault("serverName")
  valid_574286 = validateParameter(valid_574286, JString, required = true,
                                 default = nil)
  if valid_574286 != nil:
    section.add "serverName", valid_574286
  var valid_574287 = path.getOrDefault("subscriptionId")
  valid_574287 = validateParameter(valid_574287, JString, required = true,
                                 default = nil)
  if valid_574287 != nil:
    section.add "subscriptionId", valid_574287
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574288 = query.getOrDefault("api-version")
  valid_574288 = validateParameter(valid_574288, JString, required = true,
                                 default = nil)
  if valid_574288 != nil:
    section.add "api-version", valid_574288
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The required parameters for updating a server.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574290: Call_ServersUpdate_574282; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing server. The request body can contain one to many of the properties present in the normal server definition.
  ## 
  let valid = call_574290.validator(path, query, header, formData, body)
  let scheme = call_574290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574290.url(scheme.get, call_574290.host, call_574290.base,
                         call_574290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574290, url, valid)

proc call*(call_574291: Call_ServersUpdate_574282; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## serversUpdate
  ## Updates an existing server. The request body can contain one to many of the properties present in the normal server definition.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   parameters: JObject (required)
  ##             : The required parameters for updating a server.
  var path_574292 = newJObject()
  var query_574293 = newJObject()
  var body_574294 = newJObject()
  add(path_574292, "resourceGroupName", newJString(resourceGroupName))
  add(query_574293, "api-version", newJString(apiVersion))
  add(path_574292, "serverName", newJString(serverName))
  add(path_574292, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574294 = parameters
  result = call_574291.call(path_574292, query_574293, nil, nil, body_574294)

var serversUpdate* = Call_ServersUpdate_574282(name: "serversUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMariaDB/servers/{serverName}",
    validator: validate_ServersUpdate_574283, base: "", url: url_ServersUpdate_574284,
    schemes: {Scheme.Https})
type
  Call_ServersDelete_574271 = ref object of OpenApiRestCall_573658
proc url_ServersDelete_574273(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMariaDB/servers/"),
               (kind: VariableSegment, value: "serverName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersDelete_574272(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574274 = path.getOrDefault("resourceGroupName")
  valid_574274 = validateParameter(valid_574274, JString, required = true,
                                 default = nil)
  if valid_574274 != nil:
    section.add "resourceGroupName", valid_574274
  var valid_574275 = path.getOrDefault("serverName")
  valid_574275 = validateParameter(valid_574275, JString, required = true,
                                 default = nil)
  if valid_574275 != nil:
    section.add "serverName", valid_574275
  var valid_574276 = path.getOrDefault("subscriptionId")
  valid_574276 = validateParameter(valid_574276, JString, required = true,
                                 default = nil)
  if valid_574276 != nil:
    section.add "subscriptionId", valid_574276
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574277 = query.getOrDefault("api-version")
  valid_574277 = validateParameter(valid_574277, JString, required = true,
                                 default = nil)
  if valid_574277 != nil:
    section.add "api-version", valid_574277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574278: Call_ServersDelete_574271; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a server.
  ## 
  let valid = call_574278.validator(path, query, header, formData, body)
  let scheme = call_574278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574278.url(scheme.get, call_574278.host, call_574278.base,
                         call_574278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574278, url, valid)

proc call*(call_574279: Call_ServersDelete_574271; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string): Recallable =
  ## serversDelete
  ## Deletes a server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_574280 = newJObject()
  var query_574281 = newJObject()
  add(path_574280, "resourceGroupName", newJString(resourceGroupName))
  add(query_574281, "api-version", newJString(apiVersion))
  add(path_574280, "serverName", newJString(serverName))
  add(path_574280, "subscriptionId", newJString(subscriptionId))
  result = call_574279.call(path_574280, query_574281, nil, nil, nil)

var serversDelete* = Call_ServersDelete_574271(name: "serversDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMariaDB/servers/{serverName}",
    validator: validate_ServersDelete_574272, base: "", url: url_ServersDelete_574273,
    schemes: {Scheme.Https})
type
  Call_ConfigurationsListByServer_574295 = ref object of OpenApiRestCall_573658
proc url_ConfigurationsListByServer_574297(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMariaDB/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/configurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationsListByServer_574296(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the configurations in a given server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574298 = path.getOrDefault("resourceGroupName")
  valid_574298 = validateParameter(valid_574298, JString, required = true,
                                 default = nil)
  if valid_574298 != nil:
    section.add "resourceGroupName", valid_574298
  var valid_574299 = path.getOrDefault("serverName")
  valid_574299 = validateParameter(valid_574299, JString, required = true,
                                 default = nil)
  if valid_574299 != nil:
    section.add "serverName", valid_574299
  var valid_574300 = path.getOrDefault("subscriptionId")
  valid_574300 = validateParameter(valid_574300, JString, required = true,
                                 default = nil)
  if valid_574300 != nil:
    section.add "subscriptionId", valid_574300
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574301 = query.getOrDefault("api-version")
  valid_574301 = validateParameter(valid_574301, JString, required = true,
                                 default = nil)
  if valid_574301 != nil:
    section.add "api-version", valid_574301
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574302: Call_ConfigurationsListByServer_574295; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the configurations in a given server.
  ## 
  let valid = call_574302.validator(path, query, header, formData, body)
  let scheme = call_574302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574302.url(scheme.get, call_574302.host, call_574302.base,
                         call_574302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574302, url, valid)

proc call*(call_574303: Call_ConfigurationsListByServer_574295;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string): Recallable =
  ## configurationsListByServer
  ## List all the configurations in a given server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_574304 = newJObject()
  var query_574305 = newJObject()
  add(path_574304, "resourceGroupName", newJString(resourceGroupName))
  add(query_574305, "api-version", newJString(apiVersion))
  add(path_574304, "serverName", newJString(serverName))
  add(path_574304, "subscriptionId", newJString(subscriptionId))
  result = call_574303.call(path_574304, query_574305, nil, nil, nil)

var configurationsListByServer* = Call_ConfigurationsListByServer_574295(
    name: "configurationsListByServer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMariaDB/servers/{serverName}/configurations",
    validator: validate_ConfigurationsListByServer_574296, base: "",
    url: url_ConfigurationsListByServer_574297, schemes: {Scheme.Https})
type
  Call_ConfigurationsCreateOrUpdate_574318 = ref object of OpenApiRestCall_573658
proc url_ConfigurationsCreateOrUpdate_574320(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "configurationName" in path,
        "`configurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMariaDB/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/configurations/"),
               (kind: VariableSegment, value: "configurationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationsCreateOrUpdate_574319(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a configuration of a server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   configurationName: JString (required)
  ##                    : The name of the server configuration.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574321 = path.getOrDefault("resourceGroupName")
  valid_574321 = validateParameter(valid_574321, JString, required = true,
                                 default = nil)
  if valid_574321 != nil:
    section.add "resourceGroupName", valid_574321
  var valid_574322 = path.getOrDefault("serverName")
  valid_574322 = validateParameter(valid_574322, JString, required = true,
                                 default = nil)
  if valid_574322 != nil:
    section.add "serverName", valid_574322
  var valid_574323 = path.getOrDefault("subscriptionId")
  valid_574323 = validateParameter(valid_574323, JString, required = true,
                                 default = nil)
  if valid_574323 != nil:
    section.add "subscriptionId", valid_574323
  var valid_574324 = path.getOrDefault("configurationName")
  valid_574324 = validateParameter(valid_574324, JString, required = true,
                                 default = nil)
  if valid_574324 != nil:
    section.add "configurationName", valid_574324
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574325 = query.getOrDefault("api-version")
  valid_574325 = validateParameter(valid_574325, JString, required = true,
                                 default = nil)
  if valid_574325 != nil:
    section.add "api-version", valid_574325
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The required parameters for updating a server configuration.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574327: Call_ConfigurationsCreateOrUpdate_574318; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a configuration of a server.
  ## 
  let valid = call_574327.validator(path, query, header, formData, body)
  let scheme = call_574327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574327.url(scheme.get, call_574327.host, call_574327.base,
                         call_574327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574327, url, valid)

proc call*(call_574328: Call_ConfigurationsCreateOrUpdate_574318;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; configurationName: string; parameters: JsonNode): Recallable =
  ## configurationsCreateOrUpdate
  ## Updates a configuration of a server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   configurationName: string (required)
  ##                    : The name of the server configuration.
  ##   parameters: JObject (required)
  ##             : The required parameters for updating a server configuration.
  var path_574329 = newJObject()
  var query_574330 = newJObject()
  var body_574331 = newJObject()
  add(path_574329, "resourceGroupName", newJString(resourceGroupName))
  add(query_574330, "api-version", newJString(apiVersion))
  add(path_574329, "serverName", newJString(serverName))
  add(path_574329, "subscriptionId", newJString(subscriptionId))
  add(path_574329, "configurationName", newJString(configurationName))
  if parameters != nil:
    body_574331 = parameters
  result = call_574328.call(path_574329, query_574330, nil, nil, body_574331)

var configurationsCreateOrUpdate* = Call_ConfigurationsCreateOrUpdate_574318(
    name: "configurationsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMariaDB/servers/{serverName}/configurations/{configurationName}",
    validator: validate_ConfigurationsCreateOrUpdate_574319, base: "",
    url: url_ConfigurationsCreateOrUpdate_574320, schemes: {Scheme.Https})
type
  Call_ConfigurationsGet_574306 = ref object of OpenApiRestCall_573658
proc url_ConfigurationsGet_574308(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "configurationName" in path,
        "`configurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMariaDB/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/configurations/"),
               (kind: VariableSegment, value: "configurationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationsGet_574307(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets information about a configuration of server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   configurationName: JString (required)
  ##                    : The name of the server configuration.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574309 = path.getOrDefault("resourceGroupName")
  valid_574309 = validateParameter(valid_574309, JString, required = true,
                                 default = nil)
  if valid_574309 != nil:
    section.add "resourceGroupName", valid_574309
  var valid_574310 = path.getOrDefault("serverName")
  valid_574310 = validateParameter(valid_574310, JString, required = true,
                                 default = nil)
  if valid_574310 != nil:
    section.add "serverName", valid_574310
  var valid_574311 = path.getOrDefault("subscriptionId")
  valid_574311 = validateParameter(valid_574311, JString, required = true,
                                 default = nil)
  if valid_574311 != nil:
    section.add "subscriptionId", valid_574311
  var valid_574312 = path.getOrDefault("configurationName")
  valid_574312 = validateParameter(valid_574312, JString, required = true,
                                 default = nil)
  if valid_574312 != nil:
    section.add "configurationName", valid_574312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574313 = query.getOrDefault("api-version")
  valid_574313 = validateParameter(valid_574313, JString, required = true,
                                 default = nil)
  if valid_574313 != nil:
    section.add "api-version", valid_574313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574314: Call_ConfigurationsGet_574306; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a configuration of server.
  ## 
  let valid = call_574314.validator(path, query, header, formData, body)
  let scheme = call_574314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574314.url(scheme.get, call_574314.host, call_574314.base,
                         call_574314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574314, url, valid)

proc call*(call_574315: Call_ConfigurationsGet_574306; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string;
          configurationName: string): Recallable =
  ## configurationsGet
  ## Gets information about a configuration of server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   configurationName: string (required)
  ##                    : The name of the server configuration.
  var path_574316 = newJObject()
  var query_574317 = newJObject()
  add(path_574316, "resourceGroupName", newJString(resourceGroupName))
  add(query_574317, "api-version", newJString(apiVersion))
  add(path_574316, "serverName", newJString(serverName))
  add(path_574316, "subscriptionId", newJString(subscriptionId))
  add(path_574316, "configurationName", newJString(configurationName))
  result = call_574315.call(path_574316, query_574317, nil, nil, nil)

var configurationsGet* = Call_ConfigurationsGet_574306(name: "configurationsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMariaDB/servers/{serverName}/configurations/{configurationName}",
    validator: validate_ConfigurationsGet_574307, base: "",
    url: url_ConfigurationsGet_574308, schemes: {Scheme.Https})
type
  Call_DatabasesListByServer_574332 = ref object of OpenApiRestCall_573658
proc url_DatabasesListByServer_574334(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMariaDB/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabasesListByServer_574333(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the databases in a given server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574335 = path.getOrDefault("resourceGroupName")
  valid_574335 = validateParameter(valid_574335, JString, required = true,
                                 default = nil)
  if valid_574335 != nil:
    section.add "resourceGroupName", valid_574335
  var valid_574336 = path.getOrDefault("serverName")
  valid_574336 = validateParameter(valid_574336, JString, required = true,
                                 default = nil)
  if valid_574336 != nil:
    section.add "serverName", valid_574336
  var valid_574337 = path.getOrDefault("subscriptionId")
  valid_574337 = validateParameter(valid_574337, JString, required = true,
                                 default = nil)
  if valid_574337 != nil:
    section.add "subscriptionId", valid_574337
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574338 = query.getOrDefault("api-version")
  valid_574338 = validateParameter(valid_574338, JString, required = true,
                                 default = nil)
  if valid_574338 != nil:
    section.add "api-version", valid_574338
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574339: Call_DatabasesListByServer_574332; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the databases in a given server.
  ## 
  let valid = call_574339.validator(path, query, header, formData, body)
  let scheme = call_574339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574339.url(scheme.get, call_574339.host, call_574339.base,
                         call_574339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574339, url, valid)

proc call*(call_574340: Call_DatabasesListByServer_574332;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string): Recallable =
  ## databasesListByServer
  ## List all the databases in a given server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_574341 = newJObject()
  var query_574342 = newJObject()
  add(path_574341, "resourceGroupName", newJString(resourceGroupName))
  add(query_574342, "api-version", newJString(apiVersion))
  add(path_574341, "serverName", newJString(serverName))
  add(path_574341, "subscriptionId", newJString(subscriptionId))
  result = call_574340.call(path_574341, query_574342, nil, nil, nil)

var databasesListByServer* = Call_DatabasesListByServer_574332(
    name: "databasesListByServer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMariaDB/servers/{serverName}/databases",
    validator: validate_DatabasesListByServer_574333, base: "",
    url: url_DatabasesListByServer_574334, schemes: {Scheme.Https})
type
  Call_DatabasesCreateOrUpdate_574355 = ref object of OpenApiRestCall_573658
proc url_DatabasesCreateOrUpdate_574357(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMariaDB/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabasesCreateOrUpdate_574356(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new database or updates an existing database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574358 = path.getOrDefault("resourceGroupName")
  valid_574358 = validateParameter(valid_574358, JString, required = true,
                                 default = nil)
  if valid_574358 != nil:
    section.add "resourceGroupName", valid_574358
  var valid_574359 = path.getOrDefault("serverName")
  valid_574359 = validateParameter(valid_574359, JString, required = true,
                                 default = nil)
  if valid_574359 != nil:
    section.add "serverName", valid_574359
  var valid_574360 = path.getOrDefault("subscriptionId")
  valid_574360 = validateParameter(valid_574360, JString, required = true,
                                 default = nil)
  if valid_574360 != nil:
    section.add "subscriptionId", valid_574360
  var valid_574361 = path.getOrDefault("databaseName")
  valid_574361 = validateParameter(valid_574361, JString, required = true,
                                 default = nil)
  if valid_574361 != nil:
    section.add "databaseName", valid_574361
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574362 = query.getOrDefault("api-version")
  valid_574362 = validateParameter(valid_574362, JString, required = true,
                                 default = nil)
  if valid_574362 != nil:
    section.add "api-version", valid_574362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The required parameters for creating or updating a database.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574364: Call_DatabasesCreateOrUpdate_574355; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new database or updates an existing database.
  ## 
  let valid = call_574364.validator(path, query, header, formData, body)
  let scheme = call_574364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574364.url(scheme.get, call_574364.host, call_574364.base,
                         call_574364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574364, url, valid)

proc call*(call_574365: Call_DatabasesCreateOrUpdate_574355;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; databaseName: string; parameters: JsonNode): Recallable =
  ## databasesCreateOrUpdate
  ## Creates a new database or updates an existing database.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  ##   parameters: JObject (required)
  ##             : The required parameters for creating or updating a database.
  var path_574366 = newJObject()
  var query_574367 = newJObject()
  var body_574368 = newJObject()
  add(path_574366, "resourceGroupName", newJString(resourceGroupName))
  add(query_574367, "api-version", newJString(apiVersion))
  add(path_574366, "serverName", newJString(serverName))
  add(path_574366, "subscriptionId", newJString(subscriptionId))
  add(path_574366, "databaseName", newJString(databaseName))
  if parameters != nil:
    body_574368 = parameters
  result = call_574365.call(path_574366, query_574367, nil, nil, body_574368)

var databasesCreateOrUpdate* = Call_DatabasesCreateOrUpdate_574355(
    name: "databasesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMariaDB/servers/{serverName}/databases/{databaseName}",
    validator: validate_DatabasesCreateOrUpdate_574356, base: "",
    url: url_DatabasesCreateOrUpdate_574357, schemes: {Scheme.Https})
type
  Call_DatabasesGet_574343 = ref object of OpenApiRestCall_573658
proc url_DatabasesGet_574345(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMariaDB/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabasesGet_574344(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about a database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574346 = path.getOrDefault("resourceGroupName")
  valid_574346 = validateParameter(valid_574346, JString, required = true,
                                 default = nil)
  if valid_574346 != nil:
    section.add "resourceGroupName", valid_574346
  var valid_574347 = path.getOrDefault("serverName")
  valid_574347 = validateParameter(valid_574347, JString, required = true,
                                 default = nil)
  if valid_574347 != nil:
    section.add "serverName", valid_574347
  var valid_574348 = path.getOrDefault("subscriptionId")
  valid_574348 = validateParameter(valid_574348, JString, required = true,
                                 default = nil)
  if valid_574348 != nil:
    section.add "subscriptionId", valid_574348
  var valid_574349 = path.getOrDefault("databaseName")
  valid_574349 = validateParameter(valid_574349, JString, required = true,
                                 default = nil)
  if valid_574349 != nil:
    section.add "databaseName", valid_574349
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574350 = query.getOrDefault("api-version")
  valid_574350 = validateParameter(valid_574350, JString, required = true,
                                 default = nil)
  if valid_574350 != nil:
    section.add "api-version", valid_574350
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574351: Call_DatabasesGet_574343; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a database.
  ## 
  let valid = call_574351.validator(path, query, header, formData, body)
  let scheme = call_574351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574351.url(scheme.get, call_574351.host, call_574351.base,
                         call_574351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574351, url, valid)

proc call*(call_574352: Call_DatabasesGet_574343; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string;
          databaseName: string): Recallable =
  ## databasesGet
  ## Gets information about a database.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  var path_574353 = newJObject()
  var query_574354 = newJObject()
  add(path_574353, "resourceGroupName", newJString(resourceGroupName))
  add(query_574354, "api-version", newJString(apiVersion))
  add(path_574353, "serverName", newJString(serverName))
  add(path_574353, "subscriptionId", newJString(subscriptionId))
  add(path_574353, "databaseName", newJString(databaseName))
  result = call_574352.call(path_574353, query_574354, nil, nil, nil)

var databasesGet* = Call_DatabasesGet_574343(name: "databasesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMariaDB/servers/{serverName}/databases/{databaseName}",
    validator: validate_DatabasesGet_574344, base: "", url: url_DatabasesGet_574345,
    schemes: {Scheme.Https})
type
  Call_DatabasesDelete_574369 = ref object of OpenApiRestCall_573658
proc url_DatabasesDelete_574371(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMariaDB/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabasesDelete_574370(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes a database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574372 = path.getOrDefault("resourceGroupName")
  valid_574372 = validateParameter(valid_574372, JString, required = true,
                                 default = nil)
  if valid_574372 != nil:
    section.add "resourceGroupName", valid_574372
  var valid_574373 = path.getOrDefault("serverName")
  valid_574373 = validateParameter(valid_574373, JString, required = true,
                                 default = nil)
  if valid_574373 != nil:
    section.add "serverName", valid_574373
  var valid_574374 = path.getOrDefault("subscriptionId")
  valid_574374 = validateParameter(valid_574374, JString, required = true,
                                 default = nil)
  if valid_574374 != nil:
    section.add "subscriptionId", valid_574374
  var valid_574375 = path.getOrDefault("databaseName")
  valid_574375 = validateParameter(valid_574375, JString, required = true,
                                 default = nil)
  if valid_574375 != nil:
    section.add "databaseName", valid_574375
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574376 = query.getOrDefault("api-version")
  valid_574376 = validateParameter(valid_574376, JString, required = true,
                                 default = nil)
  if valid_574376 != nil:
    section.add "api-version", valid_574376
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574377: Call_DatabasesDelete_574369; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a database.
  ## 
  let valid = call_574377.validator(path, query, header, formData, body)
  let scheme = call_574377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574377.url(scheme.get, call_574377.host, call_574377.base,
                         call_574377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574377, url, valid)

proc call*(call_574378: Call_DatabasesDelete_574369; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string;
          databaseName: string): Recallable =
  ## databasesDelete
  ## Deletes a database.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  var path_574379 = newJObject()
  var query_574380 = newJObject()
  add(path_574379, "resourceGroupName", newJString(resourceGroupName))
  add(query_574380, "api-version", newJString(apiVersion))
  add(path_574379, "serverName", newJString(serverName))
  add(path_574379, "subscriptionId", newJString(subscriptionId))
  add(path_574379, "databaseName", newJString(databaseName))
  result = call_574378.call(path_574379, query_574380, nil, nil, nil)

var databasesDelete* = Call_DatabasesDelete_574369(name: "databasesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMariaDB/servers/{serverName}/databases/{databaseName}",
    validator: validate_DatabasesDelete_574370, base: "", url: url_DatabasesDelete_574371,
    schemes: {Scheme.Https})
type
  Call_FirewallRulesListByServer_574381 = ref object of OpenApiRestCall_573658
proc url_FirewallRulesListByServer_574383(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMariaDB/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/firewallRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirewallRulesListByServer_574382(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the firewall rules in a given server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574384 = path.getOrDefault("resourceGroupName")
  valid_574384 = validateParameter(valid_574384, JString, required = true,
                                 default = nil)
  if valid_574384 != nil:
    section.add "resourceGroupName", valid_574384
  var valid_574385 = path.getOrDefault("serverName")
  valid_574385 = validateParameter(valid_574385, JString, required = true,
                                 default = nil)
  if valid_574385 != nil:
    section.add "serverName", valid_574385
  var valid_574386 = path.getOrDefault("subscriptionId")
  valid_574386 = validateParameter(valid_574386, JString, required = true,
                                 default = nil)
  if valid_574386 != nil:
    section.add "subscriptionId", valid_574386
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574387 = query.getOrDefault("api-version")
  valid_574387 = validateParameter(valid_574387, JString, required = true,
                                 default = nil)
  if valid_574387 != nil:
    section.add "api-version", valid_574387
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574388: Call_FirewallRulesListByServer_574381; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the firewall rules in a given server.
  ## 
  let valid = call_574388.validator(path, query, header, formData, body)
  let scheme = call_574388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574388.url(scheme.get, call_574388.host, call_574388.base,
                         call_574388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574388, url, valid)

proc call*(call_574389: Call_FirewallRulesListByServer_574381;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string): Recallable =
  ## firewallRulesListByServer
  ## List all the firewall rules in a given server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_574390 = newJObject()
  var query_574391 = newJObject()
  add(path_574390, "resourceGroupName", newJString(resourceGroupName))
  add(query_574391, "api-version", newJString(apiVersion))
  add(path_574390, "serverName", newJString(serverName))
  add(path_574390, "subscriptionId", newJString(subscriptionId))
  result = call_574389.call(path_574390, query_574391, nil, nil, nil)

var firewallRulesListByServer* = Call_FirewallRulesListByServer_574381(
    name: "firewallRulesListByServer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMariaDB/servers/{serverName}/firewallRules",
    validator: validate_FirewallRulesListByServer_574382, base: "",
    url: url_FirewallRulesListByServer_574383, schemes: {Scheme.Https})
type
  Call_FirewallRulesCreateOrUpdate_574404 = ref object of OpenApiRestCall_573658
proc url_FirewallRulesCreateOrUpdate_574406(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "firewallRuleName" in path,
        "`firewallRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMariaDB/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/firewallRules/"),
               (kind: VariableSegment, value: "firewallRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirewallRulesCreateOrUpdate_574405(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new firewall rule or updates an existing firewall rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   firewallRuleName: JString (required)
  ##                   : The name of the server firewall rule.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574407 = path.getOrDefault("resourceGroupName")
  valid_574407 = validateParameter(valid_574407, JString, required = true,
                                 default = nil)
  if valid_574407 != nil:
    section.add "resourceGroupName", valid_574407
  var valid_574408 = path.getOrDefault("serverName")
  valid_574408 = validateParameter(valid_574408, JString, required = true,
                                 default = nil)
  if valid_574408 != nil:
    section.add "serverName", valid_574408
  var valid_574409 = path.getOrDefault("subscriptionId")
  valid_574409 = validateParameter(valid_574409, JString, required = true,
                                 default = nil)
  if valid_574409 != nil:
    section.add "subscriptionId", valid_574409
  var valid_574410 = path.getOrDefault("firewallRuleName")
  valid_574410 = validateParameter(valid_574410, JString, required = true,
                                 default = nil)
  if valid_574410 != nil:
    section.add "firewallRuleName", valid_574410
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574411 = query.getOrDefault("api-version")
  valid_574411 = validateParameter(valid_574411, JString, required = true,
                                 default = nil)
  if valid_574411 != nil:
    section.add "api-version", valid_574411
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The required parameters for creating or updating a firewall rule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574413: Call_FirewallRulesCreateOrUpdate_574404; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new firewall rule or updates an existing firewall rule.
  ## 
  let valid = call_574413.validator(path, query, header, formData, body)
  let scheme = call_574413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574413.url(scheme.get, call_574413.host, call_574413.base,
                         call_574413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574413, url, valid)

proc call*(call_574414: Call_FirewallRulesCreateOrUpdate_574404;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; parameters: JsonNode; firewallRuleName: string): Recallable =
  ## firewallRulesCreateOrUpdate
  ## Creates a new firewall rule or updates an existing firewall rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   parameters: JObject (required)
  ##             : The required parameters for creating or updating a firewall rule.
  ##   firewallRuleName: string (required)
  ##                   : The name of the server firewall rule.
  var path_574415 = newJObject()
  var query_574416 = newJObject()
  var body_574417 = newJObject()
  add(path_574415, "resourceGroupName", newJString(resourceGroupName))
  add(query_574416, "api-version", newJString(apiVersion))
  add(path_574415, "serverName", newJString(serverName))
  add(path_574415, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574417 = parameters
  add(path_574415, "firewallRuleName", newJString(firewallRuleName))
  result = call_574414.call(path_574415, query_574416, nil, nil, body_574417)

var firewallRulesCreateOrUpdate* = Call_FirewallRulesCreateOrUpdate_574404(
    name: "firewallRulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMariaDB/servers/{serverName}/firewallRules/{firewallRuleName}",
    validator: validate_FirewallRulesCreateOrUpdate_574405, base: "",
    url: url_FirewallRulesCreateOrUpdate_574406, schemes: {Scheme.Https})
type
  Call_FirewallRulesGet_574392 = ref object of OpenApiRestCall_573658
proc url_FirewallRulesGet_574394(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "firewallRuleName" in path,
        "`firewallRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMariaDB/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/firewallRules/"),
               (kind: VariableSegment, value: "firewallRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirewallRulesGet_574393(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets information about a server firewall rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   firewallRuleName: JString (required)
  ##                   : The name of the server firewall rule.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574395 = path.getOrDefault("resourceGroupName")
  valid_574395 = validateParameter(valid_574395, JString, required = true,
                                 default = nil)
  if valid_574395 != nil:
    section.add "resourceGroupName", valid_574395
  var valid_574396 = path.getOrDefault("serverName")
  valid_574396 = validateParameter(valid_574396, JString, required = true,
                                 default = nil)
  if valid_574396 != nil:
    section.add "serverName", valid_574396
  var valid_574397 = path.getOrDefault("subscriptionId")
  valid_574397 = validateParameter(valid_574397, JString, required = true,
                                 default = nil)
  if valid_574397 != nil:
    section.add "subscriptionId", valid_574397
  var valid_574398 = path.getOrDefault("firewallRuleName")
  valid_574398 = validateParameter(valid_574398, JString, required = true,
                                 default = nil)
  if valid_574398 != nil:
    section.add "firewallRuleName", valid_574398
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574399 = query.getOrDefault("api-version")
  valid_574399 = validateParameter(valid_574399, JString, required = true,
                                 default = nil)
  if valid_574399 != nil:
    section.add "api-version", valid_574399
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574400: Call_FirewallRulesGet_574392; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a server firewall rule.
  ## 
  let valid = call_574400.validator(path, query, header, formData, body)
  let scheme = call_574400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574400.url(scheme.get, call_574400.host, call_574400.base,
                         call_574400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574400, url, valid)

proc call*(call_574401: Call_FirewallRulesGet_574392; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string;
          firewallRuleName: string): Recallable =
  ## firewallRulesGet
  ## Gets information about a server firewall rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   firewallRuleName: string (required)
  ##                   : The name of the server firewall rule.
  var path_574402 = newJObject()
  var query_574403 = newJObject()
  add(path_574402, "resourceGroupName", newJString(resourceGroupName))
  add(query_574403, "api-version", newJString(apiVersion))
  add(path_574402, "serverName", newJString(serverName))
  add(path_574402, "subscriptionId", newJString(subscriptionId))
  add(path_574402, "firewallRuleName", newJString(firewallRuleName))
  result = call_574401.call(path_574402, query_574403, nil, nil, nil)

var firewallRulesGet* = Call_FirewallRulesGet_574392(name: "firewallRulesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMariaDB/servers/{serverName}/firewallRules/{firewallRuleName}",
    validator: validate_FirewallRulesGet_574393, base: "",
    url: url_FirewallRulesGet_574394, schemes: {Scheme.Https})
type
  Call_FirewallRulesDelete_574418 = ref object of OpenApiRestCall_573658
proc url_FirewallRulesDelete_574420(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "firewallRuleName" in path,
        "`firewallRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMariaDB/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/firewallRules/"),
               (kind: VariableSegment, value: "firewallRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirewallRulesDelete_574419(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes a server firewall rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   firewallRuleName: JString (required)
  ##                   : The name of the server firewall rule.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574421 = path.getOrDefault("resourceGroupName")
  valid_574421 = validateParameter(valid_574421, JString, required = true,
                                 default = nil)
  if valid_574421 != nil:
    section.add "resourceGroupName", valid_574421
  var valid_574422 = path.getOrDefault("serverName")
  valid_574422 = validateParameter(valid_574422, JString, required = true,
                                 default = nil)
  if valid_574422 != nil:
    section.add "serverName", valid_574422
  var valid_574423 = path.getOrDefault("subscriptionId")
  valid_574423 = validateParameter(valid_574423, JString, required = true,
                                 default = nil)
  if valid_574423 != nil:
    section.add "subscriptionId", valid_574423
  var valid_574424 = path.getOrDefault("firewallRuleName")
  valid_574424 = validateParameter(valid_574424, JString, required = true,
                                 default = nil)
  if valid_574424 != nil:
    section.add "firewallRuleName", valid_574424
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574425 = query.getOrDefault("api-version")
  valid_574425 = validateParameter(valid_574425, JString, required = true,
                                 default = nil)
  if valid_574425 != nil:
    section.add "api-version", valid_574425
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574426: Call_FirewallRulesDelete_574418; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a server firewall rule.
  ## 
  let valid = call_574426.validator(path, query, header, formData, body)
  let scheme = call_574426.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574426.url(scheme.get, call_574426.host, call_574426.base,
                         call_574426.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574426, url, valid)

proc call*(call_574427: Call_FirewallRulesDelete_574418; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string;
          firewallRuleName: string): Recallable =
  ## firewallRulesDelete
  ## Deletes a server firewall rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   firewallRuleName: string (required)
  ##                   : The name of the server firewall rule.
  var path_574428 = newJObject()
  var query_574429 = newJObject()
  add(path_574428, "resourceGroupName", newJString(resourceGroupName))
  add(query_574429, "api-version", newJString(apiVersion))
  add(path_574428, "serverName", newJString(serverName))
  add(path_574428, "subscriptionId", newJString(subscriptionId))
  add(path_574428, "firewallRuleName", newJString(firewallRuleName))
  result = call_574427.call(path_574428, query_574429, nil, nil, nil)

var firewallRulesDelete* = Call_FirewallRulesDelete_574418(
    name: "firewallRulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMariaDB/servers/{serverName}/firewallRules/{firewallRuleName}",
    validator: validate_FirewallRulesDelete_574419, base: "",
    url: url_FirewallRulesDelete_574420, schemes: {Scheme.Https})
type
  Call_LogFilesListByServer_574430 = ref object of OpenApiRestCall_573658
proc url_LogFilesListByServer_574432(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMariaDB/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/logFiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LogFilesListByServer_574431(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the log files in a given server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574433 = path.getOrDefault("resourceGroupName")
  valid_574433 = validateParameter(valid_574433, JString, required = true,
                                 default = nil)
  if valid_574433 != nil:
    section.add "resourceGroupName", valid_574433
  var valid_574434 = path.getOrDefault("serverName")
  valid_574434 = validateParameter(valid_574434, JString, required = true,
                                 default = nil)
  if valid_574434 != nil:
    section.add "serverName", valid_574434
  var valid_574435 = path.getOrDefault("subscriptionId")
  valid_574435 = validateParameter(valid_574435, JString, required = true,
                                 default = nil)
  if valid_574435 != nil:
    section.add "subscriptionId", valid_574435
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574436 = query.getOrDefault("api-version")
  valid_574436 = validateParameter(valid_574436, JString, required = true,
                                 default = nil)
  if valid_574436 != nil:
    section.add "api-version", valid_574436
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574437: Call_LogFilesListByServer_574430; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the log files in a given server.
  ## 
  let valid = call_574437.validator(path, query, header, formData, body)
  let scheme = call_574437.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574437.url(scheme.get, call_574437.host, call_574437.base,
                         call_574437.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574437, url, valid)

proc call*(call_574438: Call_LogFilesListByServer_574430;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string): Recallable =
  ## logFilesListByServer
  ## List all the log files in a given server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_574439 = newJObject()
  var query_574440 = newJObject()
  add(path_574439, "resourceGroupName", newJString(resourceGroupName))
  add(query_574440, "api-version", newJString(apiVersion))
  add(path_574439, "serverName", newJString(serverName))
  add(path_574439, "subscriptionId", newJString(subscriptionId))
  result = call_574438.call(path_574439, query_574440, nil, nil, nil)

var logFilesListByServer* = Call_LogFilesListByServer_574430(
    name: "logFilesListByServer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMariaDB/servers/{serverName}/logFiles",
    validator: validate_LogFilesListByServer_574431, base: "",
    url: url_LogFilesListByServer_574432, schemes: {Scheme.Https})
type
  Call_ReplicasListByServer_574441 = ref object of OpenApiRestCall_573658
proc url_ReplicasListByServer_574443(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMariaDB/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/replicas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicasListByServer_574442(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the replicas for a given server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574444 = path.getOrDefault("resourceGroupName")
  valid_574444 = validateParameter(valid_574444, JString, required = true,
                                 default = nil)
  if valid_574444 != nil:
    section.add "resourceGroupName", valid_574444
  var valid_574445 = path.getOrDefault("serverName")
  valid_574445 = validateParameter(valid_574445, JString, required = true,
                                 default = nil)
  if valid_574445 != nil:
    section.add "serverName", valid_574445
  var valid_574446 = path.getOrDefault("subscriptionId")
  valid_574446 = validateParameter(valid_574446, JString, required = true,
                                 default = nil)
  if valid_574446 != nil:
    section.add "subscriptionId", valid_574446
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574447 = query.getOrDefault("api-version")
  valid_574447 = validateParameter(valid_574447, JString, required = true,
                                 default = nil)
  if valid_574447 != nil:
    section.add "api-version", valid_574447
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574448: Call_ReplicasListByServer_574441; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the replicas for a given server.
  ## 
  let valid = call_574448.validator(path, query, header, formData, body)
  let scheme = call_574448.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574448.url(scheme.get, call_574448.host, call_574448.base,
                         call_574448.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574448, url, valid)

proc call*(call_574449: Call_ReplicasListByServer_574441;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string): Recallable =
  ## replicasListByServer
  ## List all the replicas for a given server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_574450 = newJObject()
  var query_574451 = newJObject()
  add(path_574450, "resourceGroupName", newJString(resourceGroupName))
  add(query_574451, "api-version", newJString(apiVersion))
  add(path_574450, "serverName", newJString(serverName))
  add(path_574450, "subscriptionId", newJString(subscriptionId))
  result = call_574449.call(path_574450, query_574451, nil, nil, nil)

var replicasListByServer* = Call_ReplicasListByServer_574441(
    name: "replicasListByServer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMariaDB/servers/{serverName}/replicas",
    validator: validate_ReplicasListByServer_574442, base: "",
    url: url_ReplicasListByServer_574443, schemes: {Scheme.Https})
type
  Call_ServersRestart_574452 = ref object of OpenApiRestCall_573658
proc url_ServersRestart_574454(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMariaDB/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/restart")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServersRestart_574453(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Restarts a server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574455 = path.getOrDefault("resourceGroupName")
  valid_574455 = validateParameter(valid_574455, JString, required = true,
                                 default = nil)
  if valid_574455 != nil:
    section.add "resourceGroupName", valid_574455
  var valid_574456 = path.getOrDefault("serverName")
  valid_574456 = validateParameter(valid_574456, JString, required = true,
                                 default = nil)
  if valid_574456 != nil:
    section.add "serverName", valid_574456
  var valid_574457 = path.getOrDefault("subscriptionId")
  valid_574457 = validateParameter(valid_574457, JString, required = true,
                                 default = nil)
  if valid_574457 != nil:
    section.add "subscriptionId", valid_574457
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574458 = query.getOrDefault("api-version")
  valid_574458 = validateParameter(valid_574458, JString, required = true,
                                 default = nil)
  if valid_574458 != nil:
    section.add "api-version", valid_574458
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574459: Call_ServersRestart_574452; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restarts a server.
  ## 
  let valid = call_574459.validator(path, query, header, formData, body)
  let scheme = call_574459.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574459.url(scheme.get, call_574459.host, call_574459.base,
                         call_574459.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574459, url, valid)

proc call*(call_574460: Call_ServersRestart_574452; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string): Recallable =
  ## serversRestart
  ## Restarts a server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_574461 = newJObject()
  var query_574462 = newJObject()
  add(path_574461, "resourceGroupName", newJString(resourceGroupName))
  add(query_574462, "api-version", newJString(apiVersion))
  add(path_574461, "serverName", newJString(serverName))
  add(path_574461, "subscriptionId", newJString(subscriptionId))
  result = call_574460.call(path_574461, query_574462, nil, nil, nil)

var serversRestart* = Call_ServersRestart_574452(name: "serversRestart",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMariaDB/servers/{serverName}/restart",
    validator: validate_ServersRestart_574453, base: "", url: url_ServersRestart_574454,
    schemes: {Scheme.Https})
type
  Call_ServerSecurityAlertPoliciesCreateOrUpdate_574488 = ref object of OpenApiRestCall_573658
proc url_ServerSecurityAlertPoliciesCreateOrUpdate_574490(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "securityAlertPolicyName" in path,
        "`securityAlertPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMariaDB/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/securityAlertPolicies/"),
               (kind: VariableSegment, value: "securityAlertPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServerSecurityAlertPoliciesCreateOrUpdate_574489(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a threat detection policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   securityAlertPolicyName: JString (required)
  ##                          : The name of the threat detection policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574491 = path.getOrDefault("resourceGroupName")
  valid_574491 = validateParameter(valid_574491, JString, required = true,
                                 default = nil)
  if valid_574491 != nil:
    section.add "resourceGroupName", valid_574491
  var valid_574492 = path.getOrDefault("serverName")
  valid_574492 = validateParameter(valid_574492, JString, required = true,
                                 default = nil)
  if valid_574492 != nil:
    section.add "serverName", valid_574492
  var valid_574493 = path.getOrDefault("subscriptionId")
  valid_574493 = validateParameter(valid_574493, JString, required = true,
                                 default = nil)
  if valid_574493 != nil:
    section.add "subscriptionId", valid_574493
  var valid_574494 = path.getOrDefault("securityAlertPolicyName")
  valid_574494 = validateParameter(valid_574494, JString, required = true,
                                 default = newJString("Default"))
  if valid_574494 != nil:
    section.add "securityAlertPolicyName", valid_574494
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574495 = query.getOrDefault("api-version")
  valid_574495 = validateParameter(valid_574495, JString, required = true,
                                 default = nil)
  if valid_574495 != nil:
    section.add "api-version", valid_574495
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The server security alert policy.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574497: Call_ServerSecurityAlertPoliciesCreateOrUpdate_574488;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a threat detection policy.
  ## 
  let valid = call_574497.validator(path, query, header, formData, body)
  let scheme = call_574497.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574497.url(scheme.get, call_574497.host, call_574497.base,
                         call_574497.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574497, url, valid)

proc call*(call_574498: Call_ServerSecurityAlertPoliciesCreateOrUpdate_574488;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; parameters: JsonNode;
          securityAlertPolicyName: string = "Default"): Recallable =
  ## serverSecurityAlertPoliciesCreateOrUpdate
  ## Creates or updates a threat detection policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   securityAlertPolicyName: string (required)
  ##                          : The name of the threat detection policy.
  ##   parameters: JObject (required)
  ##             : The server security alert policy.
  var path_574499 = newJObject()
  var query_574500 = newJObject()
  var body_574501 = newJObject()
  add(path_574499, "resourceGroupName", newJString(resourceGroupName))
  add(query_574500, "api-version", newJString(apiVersion))
  add(path_574499, "serverName", newJString(serverName))
  add(path_574499, "subscriptionId", newJString(subscriptionId))
  add(path_574499, "securityAlertPolicyName", newJString(securityAlertPolicyName))
  if parameters != nil:
    body_574501 = parameters
  result = call_574498.call(path_574499, query_574500, nil, nil, body_574501)

var serverSecurityAlertPoliciesCreateOrUpdate* = Call_ServerSecurityAlertPoliciesCreateOrUpdate_574488(
    name: "serverSecurityAlertPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMariaDB/servers/{serverName}/securityAlertPolicies/{securityAlertPolicyName}",
    validator: validate_ServerSecurityAlertPoliciesCreateOrUpdate_574489,
    base: "", url: url_ServerSecurityAlertPoliciesCreateOrUpdate_574490,
    schemes: {Scheme.Https})
type
  Call_ServerSecurityAlertPoliciesGet_574463 = ref object of OpenApiRestCall_573658
proc url_ServerSecurityAlertPoliciesGet_574465(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "securityAlertPolicyName" in path,
        "`securityAlertPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMariaDB/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/securityAlertPolicies/"),
               (kind: VariableSegment, value: "securityAlertPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServerSecurityAlertPoliciesGet_574464(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a server's security alert policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   securityAlertPolicyName: JString (required)
  ##                          : The name of the security alert policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574466 = path.getOrDefault("resourceGroupName")
  valid_574466 = validateParameter(valid_574466, JString, required = true,
                                 default = nil)
  if valid_574466 != nil:
    section.add "resourceGroupName", valid_574466
  var valid_574467 = path.getOrDefault("serverName")
  valid_574467 = validateParameter(valid_574467, JString, required = true,
                                 default = nil)
  if valid_574467 != nil:
    section.add "serverName", valid_574467
  var valid_574468 = path.getOrDefault("subscriptionId")
  valid_574468 = validateParameter(valid_574468, JString, required = true,
                                 default = nil)
  if valid_574468 != nil:
    section.add "subscriptionId", valid_574468
  var valid_574482 = path.getOrDefault("securityAlertPolicyName")
  valid_574482 = validateParameter(valid_574482, JString, required = true,
                                 default = newJString("Default"))
  if valid_574482 != nil:
    section.add "securityAlertPolicyName", valid_574482
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574483 = query.getOrDefault("api-version")
  valid_574483 = validateParameter(valid_574483, JString, required = true,
                                 default = nil)
  if valid_574483 != nil:
    section.add "api-version", valid_574483
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574484: Call_ServerSecurityAlertPoliciesGet_574463; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a server's security alert policy.
  ## 
  let valid = call_574484.validator(path, query, header, formData, body)
  let scheme = call_574484.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574484.url(scheme.get, call_574484.host, call_574484.base,
                         call_574484.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574484, url, valid)

proc call*(call_574485: Call_ServerSecurityAlertPoliciesGet_574463;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; securityAlertPolicyName: string = "Default"): Recallable =
  ## serverSecurityAlertPoliciesGet
  ## Get a server's security alert policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   securityAlertPolicyName: string (required)
  ##                          : The name of the security alert policy.
  var path_574486 = newJObject()
  var query_574487 = newJObject()
  add(path_574486, "resourceGroupName", newJString(resourceGroupName))
  add(query_574487, "api-version", newJString(apiVersion))
  add(path_574486, "serverName", newJString(serverName))
  add(path_574486, "subscriptionId", newJString(subscriptionId))
  add(path_574486, "securityAlertPolicyName", newJString(securityAlertPolicyName))
  result = call_574485.call(path_574486, query_574487, nil, nil, nil)

var serverSecurityAlertPoliciesGet* = Call_ServerSecurityAlertPoliciesGet_574463(
    name: "serverSecurityAlertPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMariaDB/servers/{serverName}/securityAlertPolicies/{securityAlertPolicyName}",
    validator: validate_ServerSecurityAlertPoliciesGet_574464, base: "",
    url: url_ServerSecurityAlertPoliciesGet_574465, schemes: {Scheme.Https})
type
  Call_VirtualNetworkRulesListByServer_574502 = ref object of OpenApiRestCall_573658
proc url_VirtualNetworkRulesListByServer_574504(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMariaDB/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/virtualNetworkRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkRulesListByServer_574503(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of virtual network rules in a server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574505 = path.getOrDefault("resourceGroupName")
  valid_574505 = validateParameter(valid_574505, JString, required = true,
                                 default = nil)
  if valid_574505 != nil:
    section.add "resourceGroupName", valid_574505
  var valid_574506 = path.getOrDefault("serverName")
  valid_574506 = validateParameter(valid_574506, JString, required = true,
                                 default = nil)
  if valid_574506 != nil:
    section.add "serverName", valid_574506
  var valid_574507 = path.getOrDefault("subscriptionId")
  valid_574507 = validateParameter(valid_574507, JString, required = true,
                                 default = nil)
  if valid_574507 != nil:
    section.add "subscriptionId", valid_574507
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574508 = query.getOrDefault("api-version")
  valid_574508 = validateParameter(valid_574508, JString, required = true,
                                 default = nil)
  if valid_574508 != nil:
    section.add "api-version", valid_574508
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574509: Call_VirtualNetworkRulesListByServer_574502;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of virtual network rules in a server.
  ## 
  let valid = call_574509.validator(path, query, header, formData, body)
  let scheme = call_574509.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574509.url(scheme.get, call_574509.host, call_574509.base,
                         call_574509.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574509, url, valid)

proc call*(call_574510: Call_VirtualNetworkRulesListByServer_574502;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string): Recallable =
  ## virtualNetworkRulesListByServer
  ## Gets a list of virtual network rules in a server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  var path_574511 = newJObject()
  var query_574512 = newJObject()
  add(path_574511, "resourceGroupName", newJString(resourceGroupName))
  add(query_574512, "api-version", newJString(apiVersion))
  add(path_574511, "serverName", newJString(serverName))
  add(path_574511, "subscriptionId", newJString(subscriptionId))
  result = call_574510.call(path_574511, query_574512, nil, nil, nil)

var virtualNetworkRulesListByServer* = Call_VirtualNetworkRulesListByServer_574502(
    name: "virtualNetworkRulesListByServer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMariaDB/servers/{serverName}/virtualNetworkRules",
    validator: validate_VirtualNetworkRulesListByServer_574503, base: "",
    url: url_VirtualNetworkRulesListByServer_574504, schemes: {Scheme.Https})
type
  Call_VirtualNetworkRulesCreateOrUpdate_574525 = ref object of OpenApiRestCall_573658
proc url_VirtualNetworkRulesCreateOrUpdate_574527(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "virtualNetworkRuleName" in path,
        "`virtualNetworkRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMariaDB/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/virtualNetworkRules/"),
               (kind: VariableSegment, value: "virtualNetworkRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkRulesCreateOrUpdate_574526(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an existing virtual network rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   virtualNetworkRuleName: JString (required)
  ##                         : The name of the virtual network rule.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574528 = path.getOrDefault("resourceGroupName")
  valid_574528 = validateParameter(valid_574528, JString, required = true,
                                 default = nil)
  if valid_574528 != nil:
    section.add "resourceGroupName", valid_574528
  var valid_574529 = path.getOrDefault("serverName")
  valid_574529 = validateParameter(valid_574529, JString, required = true,
                                 default = nil)
  if valid_574529 != nil:
    section.add "serverName", valid_574529
  var valid_574530 = path.getOrDefault("subscriptionId")
  valid_574530 = validateParameter(valid_574530, JString, required = true,
                                 default = nil)
  if valid_574530 != nil:
    section.add "subscriptionId", valid_574530
  var valid_574531 = path.getOrDefault("virtualNetworkRuleName")
  valid_574531 = validateParameter(valid_574531, JString, required = true,
                                 default = nil)
  if valid_574531 != nil:
    section.add "virtualNetworkRuleName", valid_574531
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574532 = query.getOrDefault("api-version")
  valid_574532 = validateParameter(valid_574532, JString, required = true,
                                 default = nil)
  if valid_574532 != nil:
    section.add "api-version", valid_574532
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The requested virtual Network Rule Resource state.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574534: Call_VirtualNetworkRulesCreateOrUpdate_574525;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an existing virtual network rule.
  ## 
  let valid = call_574534.validator(path, query, header, formData, body)
  let scheme = call_574534.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574534.url(scheme.get, call_574534.host, call_574534.base,
                         call_574534.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574534, url, valid)

proc call*(call_574535: Call_VirtualNetworkRulesCreateOrUpdate_574525;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; virtualNetworkRuleName: string;
          parameters: JsonNode): Recallable =
  ## virtualNetworkRulesCreateOrUpdate
  ## Creates or updates an existing virtual network rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   virtualNetworkRuleName: string (required)
  ##                         : The name of the virtual network rule.
  ##   parameters: JObject (required)
  ##             : The requested virtual Network Rule Resource state.
  var path_574536 = newJObject()
  var query_574537 = newJObject()
  var body_574538 = newJObject()
  add(path_574536, "resourceGroupName", newJString(resourceGroupName))
  add(query_574537, "api-version", newJString(apiVersion))
  add(path_574536, "serverName", newJString(serverName))
  add(path_574536, "subscriptionId", newJString(subscriptionId))
  add(path_574536, "virtualNetworkRuleName", newJString(virtualNetworkRuleName))
  if parameters != nil:
    body_574538 = parameters
  result = call_574535.call(path_574536, query_574537, nil, nil, body_574538)

var virtualNetworkRulesCreateOrUpdate* = Call_VirtualNetworkRulesCreateOrUpdate_574525(
    name: "virtualNetworkRulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMariaDB/servers/{serverName}/virtualNetworkRules/{virtualNetworkRuleName}",
    validator: validate_VirtualNetworkRulesCreateOrUpdate_574526, base: "",
    url: url_VirtualNetworkRulesCreateOrUpdate_574527, schemes: {Scheme.Https})
type
  Call_VirtualNetworkRulesGet_574513 = ref object of OpenApiRestCall_573658
proc url_VirtualNetworkRulesGet_574515(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "virtualNetworkRuleName" in path,
        "`virtualNetworkRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMariaDB/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/virtualNetworkRules/"),
               (kind: VariableSegment, value: "virtualNetworkRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkRulesGet_574514(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a virtual network rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   virtualNetworkRuleName: JString (required)
  ##                         : The name of the virtual network rule.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574516 = path.getOrDefault("resourceGroupName")
  valid_574516 = validateParameter(valid_574516, JString, required = true,
                                 default = nil)
  if valid_574516 != nil:
    section.add "resourceGroupName", valid_574516
  var valid_574517 = path.getOrDefault("serverName")
  valid_574517 = validateParameter(valid_574517, JString, required = true,
                                 default = nil)
  if valid_574517 != nil:
    section.add "serverName", valid_574517
  var valid_574518 = path.getOrDefault("subscriptionId")
  valid_574518 = validateParameter(valid_574518, JString, required = true,
                                 default = nil)
  if valid_574518 != nil:
    section.add "subscriptionId", valid_574518
  var valid_574519 = path.getOrDefault("virtualNetworkRuleName")
  valid_574519 = validateParameter(valid_574519, JString, required = true,
                                 default = nil)
  if valid_574519 != nil:
    section.add "virtualNetworkRuleName", valid_574519
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574520 = query.getOrDefault("api-version")
  valid_574520 = validateParameter(valid_574520, JString, required = true,
                                 default = nil)
  if valid_574520 != nil:
    section.add "api-version", valid_574520
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574521: Call_VirtualNetworkRulesGet_574513; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a virtual network rule.
  ## 
  let valid = call_574521.validator(path, query, header, formData, body)
  let scheme = call_574521.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574521.url(scheme.get, call_574521.host, call_574521.base,
                         call_574521.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574521, url, valid)

proc call*(call_574522: Call_VirtualNetworkRulesGet_574513;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; virtualNetworkRuleName: string): Recallable =
  ## virtualNetworkRulesGet
  ## Gets a virtual network rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   virtualNetworkRuleName: string (required)
  ##                         : The name of the virtual network rule.
  var path_574523 = newJObject()
  var query_574524 = newJObject()
  add(path_574523, "resourceGroupName", newJString(resourceGroupName))
  add(query_574524, "api-version", newJString(apiVersion))
  add(path_574523, "serverName", newJString(serverName))
  add(path_574523, "subscriptionId", newJString(subscriptionId))
  add(path_574523, "virtualNetworkRuleName", newJString(virtualNetworkRuleName))
  result = call_574522.call(path_574523, query_574524, nil, nil, nil)

var virtualNetworkRulesGet* = Call_VirtualNetworkRulesGet_574513(
    name: "virtualNetworkRulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMariaDB/servers/{serverName}/virtualNetworkRules/{virtualNetworkRuleName}",
    validator: validate_VirtualNetworkRulesGet_574514, base: "",
    url: url_VirtualNetworkRulesGet_574515, schemes: {Scheme.Https})
type
  Call_VirtualNetworkRulesDelete_574539 = ref object of OpenApiRestCall_573658
proc url_VirtualNetworkRulesDelete_574541(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "virtualNetworkRuleName" in path,
        "`virtualNetworkRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DBforMariaDB/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/virtualNetworkRules/"),
               (kind: VariableSegment, value: "virtualNetworkRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkRulesDelete_574540(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the virtual network rule with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   virtualNetworkRuleName: JString (required)
  ##                         : The name of the virtual network rule.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574542 = path.getOrDefault("resourceGroupName")
  valid_574542 = validateParameter(valid_574542, JString, required = true,
                                 default = nil)
  if valid_574542 != nil:
    section.add "resourceGroupName", valid_574542
  var valid_574543 = path.getOrDefault("serverName")
  valid_574543 = validateParameter(valid_574543, JString, required = true,
                                 default = nil)
  if valid_574543 != nil:
    section.add "serverName", valid_574543
  var valid_574544 = path.getOrDefault("subscriptionId")
  valid_574544 = validateParameter(valid_574544, JString, required = true,
                                 default = nil)
  if valid_574544 != nil:
    section.add "subscriptionId", valid_574544
  var valid_574545 = path.getOrDefault("virtualNetworkRuleName")
  valid_574545 = validateParameter(valid_574545, JString, required = true,
                                 default = nil)
  if valid_574545 != nil:
    section.add "virtualNetworkRuleName", valid_574545
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574546 = query.getOrDefault("api-version")
  valid_574546 = validateParameter(valid_574546, JString, required = true,
                                 default = nil)
  if valid_574546 != nil:
    section.add "api-version", valid_574546
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574547: Call_VirtualNetworkRulesDelete_574539; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the virtual network rule with the given name.
  ## 
  let valid = call_574547.validator(path, query, header, formData, body)
  let scheme = call_574547.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574547.url(scheme.get, call_574547.host, call_574547.base,
                         call_574547.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574547, url, valid)

proc call*(call_574548: Call_VirtualNetworkRulesDelete_574539;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; virtualNetworkRuleName: string): Recallable =
  ## virtualNetworkRulesDelete
  ## Deletes the virtual network rule with the given name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   virtualNetworkRuleName: string (required)
  ##                         : The name of the virtual network rule.
  var path_574549 = newJObject()
  var query_574550 = newJObject()
  add(path_574549, "resourceGroupName", newJString(resourceGroupName))
  add(query_574550, "api-version", newJString(apiVersion))
  add(path_574549, "serverName", newJString(serverName))
  add(path_574549, "subscriptionId", newJString(subscriptionId))
  add(path_574549, "virtualNetworkRuleName", newJString(virtualNetworkRuleName))
  result = call_574548.call(path_574549, query_574550, nil, nil, nil)

var virtualNetworkRulesDelete* = Call_VirtualNetworkRulesDelete_574539(
    name: "virtualNetworkRulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DBforMariaDB/servers/{serverName}/virtualNetworkRules/{virtualNetworkRuleName}",
    validator: validate_VirtualNetworkRulesDelete_574540, base: "",
    url: url_VirtualNetworkRulesDelete_574541, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
