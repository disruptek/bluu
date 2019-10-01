
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: SqlManagementClient
## version: 2017-10-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## The Azure SQL Database management API provides a RESTful set of web APIs that interact with Azure SQL Database services to manage your databases. The API enables users to create, retrieve, update, and delete databases, servers, and other entities.
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

  OpenApiRestCall_567657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567657): Option[Scheme] {.used.} =
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
  macServiceName = "sql-instanceFailoverGroups"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_InstanceFailoverGroupsListByLocation_567879 = ref object of OpenApiRestCall_567657
proc url_InstanceFailoverGroupsListByLocation_567881(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/locations/"),
               (kind: VariableSegment, value: "locationName"),
               (kind: ConstantSegment, value: "/instanceFailoverGroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InstanceFailoverGroupsListByLocation_567880(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the failover groups in a location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   locationName: JString (required)
  ##               : The name of the region where the resource is located.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568054 = path.getOrDefault("resourceGroupName")
  valid_568054 = validateParameter(valid_568054, JString, required = true,
                                 default = nil)
  if valid_568054 != nil:
    section.add "resourceGroupName", valid_568054
  var valid_568055 = path.getOrDefault("subscriptionId")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "subscriptionId", valid_568055
  var valid_568056 = path.getOrDefault("locationName")
  valid_568056 = validateParameter(valid_568056, JString, required = true,
                                 default = nil)
  if valid_568056 != nil:
    section.add "locationName", valid_568056
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568057 = query.getOrDefault("api-version")
  valid_568057 = validateParameter(valid_568057, JString, required = true,
                                 default = nil)
  if valid_568057 != nil:
    section.add "api-version", valid_568057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568080: Call_InstanceFailoverGroupsListByLocation_567879;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the failover groups in a location.
  ## 
  let valid = call_568080.validator(path, query, header, formData, body)
  let scheme = call_568080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568080.url(scheme.get, call_568080.host, call_568080.base,
                         call_568080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568080, url, valid)

proc call*(call_568151: Call_InstanceFailoverGroupsListByLocation_567879;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          locationName: string): Recallable =
  ## instanceFailoverGroupsListByLocation
  ## Lists the failover groups in a location.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   locationName: string (required)
  ##               : The name of the region where the resource is located.
  var path_568152 = newJObject()
  var query_568154 = newJObject()
  add(path_568152, "resourceGroupName", newJString(resourceGroupName))
  add(query_568154, "api-version", newJString(apiVersion))
  add(path_568152, "subscriptionId", newJString(subscriptionId))
  add(path_568152, "locationName", newJString(locationName))
  result = call_568151.call(path_568152, query_568154, nil, nil, nil)

var instanceFailoverGroupsListByLocation* = Call_InstanceFailoverGroupsListByLocation_567879(
    name: "instanceFailoverGroupsListByLocation", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/locations/{locationName}/instanceFailoverGroups",
    validator: validate_InstanceFailoverGroupsListByLocation_567880, base: "",
    url: url_InstanceFailoverGroupsListByLocation_567881, schemes: {Scheme.Https})
type
  Call_InstanceFailoverGroupsCreateOrUpdate_568205 = ref object of OpenApiRestCall_567657
proc url_InstanceFailoverGroupsCreateOrUpdate_568207(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  assert "failoverGroupName" in path,
        "`failoverGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/locations/"),
               (kind: VariableSegment, value: "locationName"),
               (kind: ConstantSegment, value: "/instanceFailoverGroups/"),
               (kind: VariableSegment, value: "failoverGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InstanceFailoverGroupsCreateOrUpdate_568206(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a failover group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   failoverGroupName: JString (required)
  ##                    : The name of the failover group.
  ##   locationName: JString (required)
  ##               : The name of the region where the resource is located.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568208 = path.getOrDefault("resourceGroupName")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "resourceGroupName", valid_568208
  var valid_568209 = path.getOrDefault("subscriptionId")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "subscriptionId", valid_568209
  var valid_568210 = path.getOrDefault("failoverGroupName")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "failoverGroupName", valid_568210
  var valid_568211 = path.getOrDefault("locationName")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "locationName", valid_568211
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568212 = query.getOrDefault("api-version")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "api-version", valid_568212
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The failover group parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568214: Call_InstanceFailoverGroupsCreateOrUpdate_568205;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a failover group.
  ## 
  let valid = call_568214.validator(path, query, header, formData, body)
  let scheme = call_568214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568214.url(scheme.get, call_568214.host, call_568214.base,
                         call_568214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568214, url, valid)

proc call*(call_568215: Call_InstanceFailoverGroupsCreateOrUpdate_568205;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; failoverGroupName: string; locationName: string): Recallable =
  ## instanceFailoverGroupsCreateOrUpdate
  ## Creates or updates a failover group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   parameters: JObject (required)
  ##             : The failover group parameters.
  ##   failoverGroupName: string (required)
  ##                    : The name of the failover group.
  ##   locationName: string (required)
  ##               : The name of the region where the resource is located.
  var path_568216 = newJObject()
  var query_568217 = newJObject()
  var body_568218 = newJObject()
  add(path_568216, "resourceGroupName", newJString(resourceGroupName))
  add(query_568217, "api-version", newJString(apiVersion))
  add(path_568216, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568218 = parameters
  add(path_568216, "failoverGroupName", newJString(failoverGroupName))
  add(path_568216, "locationName", newJString(locationName))
  result = call_568215.call(path_568216, query_568217, nil, nil, body_568218)

var instanceFailoverGroupsCreateOrUpdate* = Call_InstanceFailoverGroupsCreateOrUpdate_568205(
    name: "instanceFailoverGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/locations/{locationName}/instanceFailoverGroups/{failoverGroupName}",
    validator: validate_InstanceFailoverGroupsCreateOrUpdate_568206, base: "",
    url: url_InstanceFailoverGroupsCreateOrUpdate_568207, schemes: {Scheme.Https})
type
  Call_InstanceFailoverGroupsGet_568193 = ref object of OpenApiRestCall_567657
proc url_InstanceFailoverGroupsGet_568195(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  assert "failoverGroupName" in path,
        "`failoverGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/locations/"),
               (kind: VariableSegment, value: "locationName"),
               (kind: ConstantSegment, value: "/instanceFailoverGroups/"),
               (kind: VariableSegment, value: "failoverGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InstanceFailoverGroupsGet_568194(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a failover group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   failoverGroupName: JString (required)
  ##                    : The name of the failover group.
  ##   locationName: JString (required)
  ##               : The name of the region where the resource is located.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568196 = path.getOrDefault("resourceGroupName")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "resourceGroupName", valid_568196
  var valid_568197 = path.getOrDefault("subscriptionId")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "subscriptionId", valid_568197
  var valid_568198 = path.getOrDefault("failoverGroupName")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "failoverGroupName", valid_568198
  var valid_568199 = path.getOrDefault("locationName")
  valid_568199 = validateParameter(valid_568199, JString, required = true,
                                 default = nil)
  if valid_568199 != nil:
    section.add "locationName", valid_568199
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568200 = query.getOrDefault("api-version")
  valid_568200 = validateParameter(valid_568200, JString, required = true,
                                 default = nil)
  if valid_568200 != nil:
    section.add "api-version", valid_568200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568201: Call_InstanceFailoverGroupsGet_568193; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a failover group.
  ## 
  let valid = call_568201.validator(path, query, header, formData, body)
  let scheme = call_568201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568201.url(scheme.get, call_568201.host, call_568201.base,
                         call_568201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568201, url, valid)

proc call*(call_568202: Call_InstanceFailoverGroupsGet_568193;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          failoverGroupName: string; locationName: string): Recallable =
  ## instanceFailoverGroupsGet
  ## Gets a failover group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   failoverGroupName: string (required)
  ##                    : The name of the failover group.
  ##   locationName: string (required)
  ##               : The name of the region where the resource is located.
  var path_568203 = newJObject()
  var query_568204 = newJObject()
  add(path_568203, "resourceGroupName", newJString(resourceGroupName))
  add(query_568204, "api-version", newJString(apiVersion))
  add(path_568203, "subscriptionId", newJString(subscriptionId))
  add(path_568203, "failoverGroupName", newJString(failoverGroupName))
  add(path_568203, "locationName", newJString(locationName))
  result = call_568202.call(path_568203, query_568204, nil, nil, nil)

var instanceFailoverGroupsGet* = Call_InstanceFailoverGroupsGet_568193(
    name: "instanceFailoverGroupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/locations/{locationName}/instanceFailoverGroups/{failoverGroupName}",
    validator: validate_InstanceFailoverGroupsGet_568194, base: "",
    url: url_InstanceFailoverGroupsGet_568195, schemes: {Scheme.Https})
type
  Call_InstanceFailoverGroupsDelete_568219 = ref object of OpenApiRestCall_567657
proc url_InstanceFailoverGroupsDelete_568221(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  assert "failoverGroupName" in path,
        "`failoverGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/locations/"),
               (kind: VariableSegment, value: "locationName"),
               (kind: ConstantSegment, value: "/instanceFailoverGroups/"),
               (kind: VariableSegment, value: "failoverGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InstanceFailoverGroupsDelete_568220(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a failover group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   failoverGroupName: JString (required)
  ##                    : The name of the failover group.
  ##   locationName: JString (required)
  ##               : The name of the region where the resource is located.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568222 = path.getOrDefault("resourceGroupName")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "resourceGroupName", valid_568222
  var valid_568223 = path.getOrDefault("subscriptionId")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "subscriptionId", valid_568223
  var valid_568224 = path.getOrDefault("failoverGroupName")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "failoverGroupName", valid_568224
  var valid_568225 = path.getOrDefault("locationName")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "locationName", valid_568225
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568226 = query.getOrDefault("api-version")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "api-version", valid_568226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568227: Call_InstanceFailoverGroupsDelete_568219; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a failover group.
  ## 
  let valid = call_568227.validator(path, query, header, formData, body)
  let scheme = call_568227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568227.url(scheme.get, call_568227.host, call_568227.base,
                         call_568227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568227, url, valid)

proc call*(call_568228: Call_InstanceFailoverGroupsDelete_568219;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          failoverGroupName: string; locationName: string): Recallable =
  ## instanceFailoverGroupsDelete
  ## Deletes a failover group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   failoverGroupName: string (required)
  ##                    : The name of the failover group.
  ##   locationName: string (required)
  ##               : The name of the region where the resource is located.
  var path_568229 = newJObject()
  var query_568230 = newJObject()
  add(path_568229, "resourceGroupName", newJString(resourceGroupName))
  add(query_568230, "api-version", newJString(apiVersion))
  add(path_568229, "subscriptionId", newJString(subscriptionId))
  add(path_568229, "failoverGroupName", newJString(failoverGroupName))
  add(path_568229, "locationName", newJString(locationName))
  result = call_568228.call(path_568229, query_568230, nil, nil, nil)

var instanceFailoverGroupsDelete* = Call_InstanceFailoverGroupsDelete_568219(
    name: "instanceFailoverGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/locations/{locationName}/instanceFailoverGroups/{failoverGroupName}",
    validator: validate_InstanceFailoverGroupsDelete_568220, base: "",
    url: url_InstanceFailoverGroupsDelete_568221, schemes: {Scheme.Https})
type
  Call_InstanceFailoverGroupsFailover_568231 = ref object of OpenApiRestCall_567657
proc url_InstanceFailoverGroupsFailover_568233(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  assert "failoverGroupName" in path,
        "`failoverGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/locations/"),
               (kind: VariableSegment, value: "locationName"),
               (kind: ConstantSegment, value: "/instanceFailoverGroups/"),
               (kind: VariableSegment, value: "failoverGroupName"),
               (kind: ConstantSegment, value: "/failover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InstanceFailoverGroupsFailover_568232(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fails over from the current primary managed instance to this managed instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   failoverGroupName: JString (required)
  ##                    : The name of the failover group.
  ##   locationName: JString (required)
  ##               : The name of the region where the resource is located.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568234 = path.getOrDefault("resourceGroupName")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "resourceGroupName", valid_568234
  var valid_568235 = path.getOrDefault("subscriptionId")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "subscriptionId", valid_568235
  var valid_568236 = path.getOrDefault("failoverGroupName")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "failoverGroupName", valid_568236
  var valid_568237 = path.getOrDefault("locationName")
  valid_568237 = validateParameter(valid_568237, JString, required = true,
                                 default = nil)
  if valid_568237 != nil:
    section.add "locationName", valid_568237
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568238 = query.getOrDefault("api-version")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "api-version", valid_568238
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568239: Call_InstanceFailoverGroupsFailover_568231; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fails over from the current primary managed instance to this managed instance.
  ## 
  let valid = call_568239.validator(path, query, header, formData, body)
  let scheme = call_568239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568239.url(scheme.get, call_568239.host, call_568239.base,
                         call_568239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568239, url, valid)

proc call*(call_568240: Call_InstanceFailoverGroupsFailover_568231;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          failoverGroupName: string; locationName: string): Recallable =
  ## instanceFailoverGroupsFailover
  ## Fails over from the current primary managed instance to this managed instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   failoverGroupName: string (required)
  ##                    : The name of the failover group.
  ##   locationName: string (required)
  ##               : The name of the region where the resource is located.
  var path_568241 = newJObject()
  var query_568242 = newJObject()
  add(path_568241, "resourceGroupName", newJString(resourceGroupName))
  add(query_568242, "api-version", newJString(apiVersion))
  add(path_568241, "subscriptionId", newJString(subscriptionId))
  add(path_568241, "failoverGroupName", newJString(failoverGroupName))
  add(path_568241, "locationName", newJString(locationName))
  result = call_568240.call(path_568241, query_568242, nil, nil, nil)

var instanceFailoverGroupsFailover* = Call_InstanceFailoverGroupsFailover_568231(
    name: "instanceFailoverGroupsFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/locations/{locationName}/instanceFailoverGroups/{failoverGroupName}/failover",
    validator: validate_InstanceFailoverGroupsFailover_568232, base: "",
    url: url_InstanceFailoverGroupsFailover_568233, schemes: {Scheme.Https})
type
  Call_InstanceFailoverGroupsForceFailoverAllowDataLoss_568243 = ref object of OpenApiRestCall_567657
proc url_InstanceFailoverGroupsForceFailoverAllowDataLoss_568245(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  assert "failoverGroupName" in path,
        "`failoverGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/locations/"),
               (kind: VariableSegment, value: "locationName"),
               (kind: ConstantSegment, value: "/instanceFailoverGroups/"),
               (kind: VariableSegment, value: "failoverGroupName"),
               (kind: ConstantSegment, value: "/forceFailoverAllowDataLoss")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InstanceFailoverGroupsForceFailoverAllowDataLoss_568244(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Fails over from the current primary managed instance to this managed instance. This operation might result in data loss.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   failoverGroupName: JString (required)
  ##                    : The name of the failover group.
  ##   locationName: JString (required)
  ##               : The name of the region where the resource is located.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568246 = path.getOrDefault("resourceGroupName")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "resourceGroupName", valid_568246
  var valid_568247 = path.getOrDefault("subscriptionId")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "subscriptionId", valid_568247
  var valid_568248 = path.getOrDefault("failoverGroupName")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "failoverGroupName", valid_568248
  var valid_568249 = path.getOrDefault("locationName")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "locationName", valid_568249
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568250 = query.getOrDefault("api-version")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "api-version", valid_568250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568251: Call_InstanceFailoverGroupsForceFailoverAllowDataLoss_568243;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fails over from the current primary managed instance to this managed instance. This operation might result in data loss.
  ## 
  let valid = call_568251.validator(path, query, header, formData, body)
  let scheme = call_568251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568251.url(scheme.get, call_568251.host, call_568251.base,
                         call_568251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568251, url, valid)

proc call*(call_568252: Call_InstanceFailoverGroupsForceFailoverAllowDataLoss_568243;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          failoverGroupName: string; locationName: string): Recallable =
  ## instanceFailoverGroupsForceFailoverAllowDataLoss
  ## Fails over from the current primary managed instance to this managed instance. This operation might result in data loss.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   failoverGroupName: string (required)
  ##                    : The name of the failover group.
  ##   locationName: string (required)
  ##               : The name of the region where the resource is located.
  var path_568253 = newJObject()
  var query_568254 = newJObject()
  add(path_568253, "resourceGroupName", newJString(resourceGroupName))
  add(query_568254, "api-version", newJString(apiVersion))
  add(path_568253, "subscriptionId", newJString(subscriptionId))
  add(path_568253, "failoverGroupName", newJString(failoverGroupName))
  add(path_568253, "locationName", newJString(locationName))
  result = call_568252.call(path_568253, query_568254, nil, nil, nil)

var instanceFailoverGroupsForceFailoverAllowDataLoss* = Call_InstanceFailoverGroupsForceFailoverAllowDataLoss_568243(
    name: "instanceFailoverGroupsForceFailoverAllowDataLoss",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/locations/{locationName}/instanceFailoverGroups/{failoverGroupName}/forceFailoverAllowDataLoss",
    validator: validate_InstanceFailoverGroupsForceFailoverAllowDataLoss_568244,
    base: "", url: url_InstanceFailoverGroupsForceFailoverAllowDataLoss_568245,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
