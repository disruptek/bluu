
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: SearchManagementClient
## version: 2015-02-28
## termsOfService: (not provided)
## license: (not provided)
## 
## Client that can be used to manage Azure Search services and API keys.
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

  OpenApiRestCall_563539 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563539](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563539): Option[Scheme] {.used.} =
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
  macServiceName = "search"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ServicesList_563761 = ref object of OpenApiRestCall_563539
proc url_ServicesList_563763(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.Search/searchServices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesList_563762(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of all Search services in the given resource group.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn832688.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the current subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563938 = path.getOrDefault("subscriptionId")
  valid_563938 = validateParameter(valid_563938, JString, required = true,
                                 default = nil)
  if valid_563938 != nil:
    section.add "subscriptionId", valid_563938
  var valid_563939 = path.getOrDefault("resourceGroupName")
  valid_563939 = validateParameter(valid_563939, JString, required = true,
                                 default = nil)
  if valid_563939 != nil:
    section.add "resourceGroupName", valid_563939
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563940 = query.getOrDefault("api-version")
  valid_563940 = validateParameter(valid_563940, JString, required = true,
                                 default = nil)
  if valid_563940 != nil:
    section.add "api-version", valid_563940
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563963: Call_ServicesList_563761; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of all Search services in the given resource group.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn832688.aspx
  let valid = call_563963.validator(path, query, header, formData, body)
  let scheme = call_563963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563963.url(scheme.get, call_563963.host, call_563963.base,
                         call_563963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563963, url, valid)

proc call*(call_564034: Call_ServicesList_563761; apiVersion: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## servicesList
  ## Returns a list of all Search services in the given resource group.
  ## https://msdn.microsoft.com/library/azure/dn832688.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the current subscription.
  var path_564035 = newJObject()
  var query_564037 = newJObject()
  add(query_564037, "api-version", newJString(apiVersion))
  add(path_564035, "subscriptionId", newJString(subscriptionId))
  add(path_564035, "resourceGroupName", newJString(resourceGroupName))
  result = call_564034.call(path_564035, query_564037, nil, nil, nil)

var servicesList* = Call_ServicesList_563761(name: "servicesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices",
    validator: validate_ServicesList_563762, base: "", url: url_ServicesList_563763,
    schemes: {Scheme.Https})
type
  Call_ServicesCreateOrUpdate_564076 = ref object of OpenApiRestCall_563539
proc url_ServicesCreateOrUpdate_564078(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Search/searchServices/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesCreateOrUpdate_564077(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a Search service in the given resource group. If the Search service already exists, all properties will be updated with the given values.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn832687.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the Search service to create or update.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the current subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564096 = path.getOrDefault("serviceName")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "serviceName", valid_564096
  var valid_564097 = path.getOrDefault("subscriptionId")
  valid_564097 = validateParameter(valid_564097, JString, required = true,
                                 default = nil)
  if valid_564097 != nil:
    section.add "subscriptionId", valid_564097
  var valid_564098 = path.getOrDefault("resourceGroupName")
  valid_564098 = validateParameter(valid_564098, JString, required = true,
                                 default = nil)
  if valid_564098 != nil:
    section.add "resourceGroupName", valid_564098
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564099 = query.getOrDefault("api-version")
  valid_564099 = validateParameter(valid_564099, JString, required = true,
                                 default = nil)
  if valid_564099 != nil:
    section.add "api-version", valid_564099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The properties to set or update on the Search service.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564101: Call_ServicesCreateOrUpdate_564076; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a Search service in the given resource group. If the Search service already exists, all properties will be updated with the given values.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn832687.aspx
  let valid = call_564101.validator(path, query, header, formData, body)
  let scheme = call_564101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564101.url(scheme.get, call_564101.host, call_564101.base,
                         call_564101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564101, url, valid)

proc call*(call_564102: Call_ServicesCreateOrUpdate_564076; serviceName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## servicesCreateOrUpdate
  ## Creates or updates a Search service in the given resource group. If the Search service already exists, all properties will be updated with the given values.
  ## https://msdn.microsoft.com/library/azure/dn832687.aspx
  ##   serviceName: string (required)
  ##              : The name of the Search service to create or update.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the current subscription.
  ##   parameters: JObject (required)
  ##             : The properties to set or update on the Search service.
  var path_564103 = newJObject()
  var query_564104 = newJObject()
  var body_564105 = newJObject()
  add(path_564103, "serviceName", newJString(serviceName))
  add(query_564104, "api-version", newJString(apiVersion))
  add(path_564103, "subscriptionId", newJString(subscriptionId))
  add(path_564103, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564105 = parameters
  result = call_564102.call(path_564103, query_564104, nil, nil, body_564105)

var servicesCreateOrUpdate* = Call_ServicesCreateOrUpdate_564076(
    name: "servicesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{serviceName}",
    validator: validate_ServicesCreateOrUpdate_564077, base: "",
    url: url_ServicesCreateOrUpdate_564078, schemes: {Scheme.Https})
type
  Call_ServicesDelete_564106 = ref object of OpenApiRestCall_563539
proc url_ServicesDelete_564108(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Search/searchServices/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesDelete_564107(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes a Search service in the given resource group, along with its associated resources.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn832692.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the Search service to delete.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the current subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564109 = path.getOrDefault("serviceName")
  valid_564109 = validateParameter(valid_564109, JString, required = true,
                                 default = nil)
  if valid_564109 != nil:
    section.add "serviceName", valid_564109
  var valid_564110 = path.getOrDefault("subscriptionId")
  valid_564110 = validateParameter(valid_564110, JString, required = true,
                                 default = nil)
  if valid_564110 != nil:
    section.add "subscriptionId", valid_564110
  var valid_564111 = path.getOrDefault("resourceGroupName")
  valid_564111 = validateParameter(valid_564111, JString, required = true,
                                 default = nil)
  if valid_564111 != nil:
    section.add "resourceGroupName", valid_564111
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564112 = query.getOrDefault("api-version")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = nil)
  if valid_564112 != nil:
    section.add "api-version", valid_564112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564113: Call_ServicesDelete_564106; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Search service in the given resource group, along with its associated resources.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn832692.aspx
  let valid = call_564113.validator(path, query, header, formData, body)
  let scheme = call_564113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564113.url(scheme.get, call_564113.host, call_564113.base,
                         call_564113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564113, url, valid)

proc call*(call_564114: Call_ServicesDelete_564106; serviceName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## servicesDelete
  ## Deletes a Search service in the given resource group, along with its associated resources.
  ## https://msdn.microsoft.com/library/azure/dn832692.aspx
  ##   serviceName: string (required)
  ##              : The name of the Search service to delete.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the current subscription.
  var path_564115 = newJObject()
  var query_564116 = newJObject()
  add(path_564115, "serviceName", newJString(serviceName))
  add(query_564116, "api-version", newJString(apiVersion))
  add(path_564115, "subscriptionId", newJString(subscriptionId))
  add(path_564115, "resourceGroupName", newJString(resourceGroupName))
  result = call_564114.call(path_564115, query_564116, nil, nil, nil)

var servicesDelete* = Call_ServicesDelete_564106(name: "servicesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{serviceName}",
    validator: validate_ServicesDelete_564107, base: "", url: url_ServicesDelete_564108,
    schemes: {Scheme.Https})
type
  Call_AdminKeysList_564117 = ref object of OpenApiRestCall_563539
proc url_AdminKeysList_564119(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Search/searchServices/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/listAdminKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdminKeysList_564118(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the primary and secondary API keys for the given Azure Search service.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn832685.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the Search service for which to list admin keys.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the current subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564120 = path.getOrDefault("serviceName")
  valid_564120 = validateParameter(valid_564120, JString, required = true,
                                 default = nil)
  if valid_564120 != nil:
    section.add "serviceName", valid_564120
  var valid_564121 = path.getOrDefault("subscriptionId")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "subscriptionId", valid_564121
  var valid_564122 = path.getOrDefault("resourceGroupName")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = nil)
  if valid_564122 != nil:
    section.add "resourceGroupName", valid_564122
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564123 = query.getOrDefault("api-version")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "api-version", valid_564123
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564124: Call_AdminKeysList_564117; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the primary and secondary API keys for the given Azure Search service.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn832685.aspx
  let valid = call_564124.validator(path, query, header, formData, body)
  let scheme = call_564124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564124.url(scheme.get, call_564124.host, call_564124.base,
                         call_564124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564124, url, valid)

proc call*(call_564125: Call_AdminKeysList_564117; serviceName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## adminKeysList
  ## Returns the primary and secondary API keys for the given Azure Search service.
  ## https://msdn.microsoft.com/library/azure/dn832685.aspx
  ##   serviceName: string (required)
  ##              : The name of the Search service for which to list admin keys.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the current subscription.
  var path_564126 = newJObject()
  var query_564127 = newJObject()
  add(path_564126, "serviceName", newJString(serviceName))
  add(query_564127, "api-version", newJString(apiVersion))
  add(path_564126, "subscriptionId", newJString(subscriptionId))
  add(path_564126, "resourceGroupName", newJString(resourceGroupName))
  result = call_564125.call(path_564126, query_564127, nil, nil, nil)

var adminKeysList* = Call_AdminKeysList_564117(name: "adminKeysList",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{serviceName}/listAdminKeys",
    validator: validate_AdminKeysList_564118, base: "", url: url_AdminKeysList_564119,
    schemes: {Scheme.Https})
type
  Call_QueryKeysList_564128 = ref object of OpenApiRestCall_563539
proc url_QueryKeysList_564130(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Search/searchServices/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/listQueryKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueryKeysList_564129(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the list of query API keys for the given Azure Search service.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn832701.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the Search service for which to list query keys.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the current subscription.
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
  var valid_564133 = path.getOrDefault("resourceGroupName")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "resourceGroupName", valid_564133
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564134 = query.getOrDefault("api-version")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "api-version", valid_564134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564135: Call_QueryKeysList_564128; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of query API keys for the given Azure Search service.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn832701.aspx
  let valid = call_564135.validator(path, query, header, formData, body)
  let scheme = call_564135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564135.url(scheme.get, call_564135.host, call_564135.base,
                         call_564135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564135, url, valid)

proc call*(call_564136: Call_QueryKeysList_564128; serviceName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## queryKeysList
  ## Returns the list of query API keys for the given Azure Search service.
  ## https://msdn.microsoft.com/library/azure/dn832701.aspx
  ##   serviceName: string (required)
  ##              : The name of the Search service for which to list query keys.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the current subscription.
  var path_564137 = newJObject()
  var query_564138 = newJObject()
  add(path_564137, "serviceName", newJString(serviceName))
  add(query_564138, "api-version", newJString(apiVersion))
  add(path_564137, "subscriptionId", newJString(subscriptionId))
  add(path_564137, "resourceGroupName", newJString(resourceGroupName))
  result = call_564136.call(path_564137, query_564138, nil, nil, nil)

var queryKeysList* = Call_QueryKeysList_564128(name: "queryKeysList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{serviceName}/listQueryKeys",
    validator: validate_QueryKeysList_564129, base: "", url: url_QueryKeysList_564130,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
