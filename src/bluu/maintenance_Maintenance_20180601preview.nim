
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: MaintenanceManagementClient
## version: 2018-06-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure Maintenance Management Client
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
  macServiceName = "maintenance-Maintenance"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563778 = ref object of OpenApiRestCall_563556
proc url_OperationsList_563780(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563779(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## List the available operations supported by the Microsoft.Maintenance resource provider
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563941 = query.getOrDefault("api-version")
  valid_563941 = validateParameter(valid_563941, JString, required = true,
                                 default = nil)
  if valid_563941 != nil:
    section.add "api-version", valid_563941
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563964: Call_OperationsList_563778; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the available operations supported by the Microsoft.Maintenance resource provider
  ## 
  let valid = call_563964.validator(path, query, header, formData, body)
  let scheme = call_563964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563964.url(scheme.get, call_563964.host, call_563964.base,
                         call_563964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563964, url, valid)

proc call*(call_564035: Call_OperationsList_563778; apiVersion: string): Recallable =
  ## operationsList
  ## List the available operations supported by the Microsoft.Maintenance resource provider
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  var query_564036 = newJObject()
  add(query_564036, "api-version", newJString(apiVersion))
  result = call_564035.call(nil, query_564036, nil, nil, nil)

var operationsList* = Call_OperationsList_563778(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Maintenance/operations",
    validator: validate_OperationsList_563779, base: "", url: url_OperationsList_563780,
    schemes: {Scheme.Https})
type
  Call_MaintenanceConfigurationsList_564076 = ref object of OpenApiRestCall_563556
proc url_MaintenanceConfigurationsList_564078(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Maintenance/maintenanceConfigurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MaintenanceConfigurationsList_564077(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564093 = path.getOrDefault("subscriptionId")
  valid_564093 = validateParameter(valid_564093, JString, required = true,
                                 default = nil)
  if valid_564093 != nil:
    section.add "subscriptionId", valid_564093
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564094 = query.getOrDefault("api-version")
  valid_564094 = validateParameter(valid_564094, JString, required = true,
                                 default = nil)
  if valid_564094 != nil:
    section.add "api-version", valid_564094
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564095: Call_MaintenanceConfigurationsList_564076; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564095.validator(path, query, header, formData, body)
  let scheme = call_564095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564095.url(scheme.get, call_564095.host, call_564095.base,
                         call_564095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564095, url, valid)

proc call*(call_564096: Call_MaintenanceConfigurationsList_564076;
          apiVersion: string; subscriptionId: string): Recallable =
  ## maintenanceConfigurationsList
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564097 = newJObject()
  var query_564098 = newJObject()
  add(query_564098, "api-version", newJString(apiVersion))
  add(path_564097, "subscriptionId", newJString(subscriptionId))
  result = call_564096.call(path_564097, query_564098, nil, nil, nil)

var maintenanceConfigurationsList* = Call_MaintenanceConfigurationsList_564076(
    name: "maintenanceConfigurationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Maintenance/maintenanceConfigurations",
    validator: validate_MaintenanceConfigurationsList_564077, base: "",
    url: url_MaintenanceConfigurationsList_564078, schemes: {Scheme.Https})
type
  Call_MaintenanceConfigurationsCreateOrUpdate_564110 = ref object of OpenApiRestCall_563556
proc url_MaintenanceConfigurationsCreateOrUpdate_564112(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Maintenance/maintenanceConfigurations/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MaintenanceConfigurationsCreateOrUpdate_564111(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Resource Group Name
  ##   resourceName: JString (required)
  ##               : Resource Identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564113 = path.getOrDefault("subscriptionId")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "subscriptionId", valid_564113
  var valid_564114 = path.getOrDefault("resourceGroupName")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "resourceGroupName", valid_564114
  var valid_564115 = path.getOrDefault("resourceName")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "resourceName", valid_564115
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564116 = query.getOrDefault("api-version")
  valid_564116 = validateParameter(valid_564116, JString, required = true,
                                 default = nil)
  if valid_564116 != nil:
    section.add "api-version", valid_564116
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   configuration: JObject (required)
  ##                : The configuration
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564118: Call_MaintenanceConfigurationsCreateOrUpdate_564110;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_564118.validator(path, query, header, formData, body)
  let scheme = call_564118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564118.url(scheme.get, call_564118.host, call_564118.base,
                         call_564118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564118, url, valid)

proc call*(call_564119: Call_MaintenanceConfigurationsCreateOrUpdate_564110;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string; configuration: JsonNode): Recallable =
  ## maintenanceConfigurationsCreateOrUpdate
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Resource Group Name
  ##   resourceName: string (required)
  ##               : Resource Identifier
  ##   configuration: JObject (required)
  ##                : The configuration
  var path_564120 = newJObject()
  var query_564121 = newJObject()
  var body_564122 = newJObject()
  add(query_564121, "api-version", newJString(apiVersion))
  add(path_564120, "subscriptionId", newJString(subscriptionId))
  add(path_564120, "resourceGroupName", newJString(resourceGroupName))
  add(path_564120, "resourceName", newJString(resourceName))
  if configuration != nil:
    body_564122 = configuration
  result = call_564119.call(path_564120, query_564121, nil, nil, body_564122)

var maintenanceConfigurationsCreateOrUpdate* = Call_MaintenanceConfigurationsCreateOrUpdate_564110(
    name: "maintenanceConfigurationsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Maintenance/maintenanceConfigurations/{resourceName}",
    validator: validate_MaintenanceConfigurationsCreateOrUpdate_564111, base: "",
    url: url_MaintenanceConfigurationsCreateOrUpdate_564112,
    schemes: {Scheme.Https})
type
  Call_MaintenanceConfigurationsGet_564099 = ref object of OpenApiRestCall_563556
proc url_MaintenanceConfigurationsGet_564101(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Maintenance/maintenanceConfigurations/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MaintenanceConfigurationsGet_564100(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Resource Group Name
  ##   resourceName: JString (required)
  ##               : Resource Identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564102 = path.getOrDefault("subscriptionId")
  valid_564102 = validateParameter(valid_564102, JString, required = true,
                                 default = nil)
  if valid_564102 != nil:
    section.add "subscriptionId", valid_564102
  var valid_564103 = path.getOrDefault("resourceGroupName")
  valid_564103 = validateParameter(valid_564103, JString, required = true,
                                 default = nil)
  if valid_564103 != nil:
    section.add "resourceGroupName", valid_564103
  var valid_564104 = path.getOrDefault("resourceName")
  valid_564104 = validateParameter(valid_564104, JString, required = true,
                                 default = nil)
  if valid_564104 != nil:
    section.add "resourceName", valid_564104
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564105 = query.getOrDefault("api-version")
  valid_564105 = validateParameter(valid_564105, JString, required = true,
                                 default = nil)
  if valid_564105 != nil:
    section.add "api-version", valid_564105
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564106: Call_MaintenanceConfigurationsGet_564099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564106.validator(path, query, header, formData, body)
  let scheme = call_564106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564106.url(scheme.get, call_564106.host, call_564106.base,
                         call_564106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564106, url, valid)

proc call*(call_564107: Call_MaintenanceConfigurationsGet_564099;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## maintenanceConfigurationsGet
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Resource Group Name
  ##   resourceName: string (required)
  ##               : Resource Identifier
  var path_564108 = newJObject()
  var query_564109 = newJObject()
  add(query_564109, "api-version", newJString(apiVersion))
  add(path_564108, "subscriptionId", newJString(subscriptionId))
  add(path_564108, "resourceGroupName", newJString(resourceGroupName))
  add(path_564108, "resourceName", newJString(resourceName))
  result = call_564107.call(path_564108, query_564109, nil, nil, nil)

var maintenanceConfigurationsGet* = Call_MaintenanceConfigurationsGet_564099(
    name: "maintenanceConfigurationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Maintenance/maintenanceConfigurations/{resourceName}",
    validator: validate_MaintenanceConfigurationsGet_564100, base: "",
    url: url_MaintenanceConfigurationsGet_564101, schemes: {Scheme.Https})
type
  Call_MaintenanceConfigurationsUpdate_564134 = ref object of OpenApiRestCall_563556
proc url_MaintenanceConfigurationsUpdate_564136(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Maintenance/maintenanceConfigurations/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MaintenanceConfigurationsUpdate_564135(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Resource Group Name
  ##   resourceName: JString (required)
  ##               : Resource Identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564137 = path.getOrDefault("subscriptionId")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = nil)
  if valid_564137 != nil:
    section.add "subscriptionId", valid_564137
  var valid_564138 = path.getOrDefault("resourceGroupName")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "resourceGroupName", valid_564138
  var valid_564139 = path.getOrDefault("resourceName")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "resourceName", valid_564139
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564140 = query.getOrDefault("api-version")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "api-version", valid_564140
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   configuration: JObject (required)
  ##                : The configuration
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564142: Call_MaintenanceConfigurationsUpdate_564134;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_564142.validator(path, query, header, formData, body)
  let scheme = call_564142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564142.url(scheme.get, call_564142.host, call_564142.base,
                         call_564142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564142, url, valid)

proc call*(call_564143: Call_MaintenanceConfigurationsUpdate_564134;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string; configuration: JsonNode): Recallable =
  ## maintenanceConfigurationsUpdate
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Resource Group Name
  ##   resourceName: string (required)
  ##               : Resource Identifier
  ##   configuration: JObject (required)
  ##                : The configuration
  var path_564144 = newJObject()
  var query_564145 = newJObject()
  var body_564146 = newJObject()
  add(query_564145, "api-version", newJString(apiVersion))
  add(path_564144, "subscriptionId", newJString(subscriptionId))
  add(path_564144, "resourceGroupName", newJString(resourceGroupName))
  add(path_564144, "resourceName", newJString(resourceName))
  if configuration != nil:
    body_564146 = configuration
  result = call_564143.call(path_564144, query_564145, nil, nil, body_564146)

var maintenanceConfigurationsUpdate* = Call_MaintenanceConfigurationsUpdate_564134(
    name: "maintenanceConfigurationsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Maintenance/maintenanceConfigurations/{resourceName}",
    validator: validate_MaintenanceConfigurationsUpdate_564135, base: "",
    url: url_MaintenanceConfigurationsUpdate_564136, schemes: {Scheme.Https})
type
  Call_MaintenanceConfigurationsDelete_564123 = ref object of OpenApiRestCall_563556
proc url_MaintenanceConfigurationsDelete_564125(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Maintenance/maintenanceConfigurations/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MaintenanceConfigurationsDelete_564124(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Resource Group Name
  ##   resourceName: JString (required)
  ##               : Resource Identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564126 = path.getOrDefault("subscriptionId")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "subscriptionId", valid_564126
  var valid_564127 = path.getOrDefault("resourceGroupName")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "resourceGroupName", valid_564127
  var valid_564128 = path.getOrDefault("resourceName")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "resourceName", valid_564128
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564129 = query.getOrDefault("api-version")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "api-version", valid_564129
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564130: Call_MaintenanceConfigurationsDelete_564123;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_564130.validator(path, query, header, formData, body)
  let scheme = call_564130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564130.url(scheme.get, call_564130.host, call_564130.base,
                         call_564130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564130, url, valid)

proc call*(call_564131: Call_MaintenanceConfigurationsDelete_564123;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## maintenanceConfigurationsDelete
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Resource Group Name
  ##   resourceName: string (required)
  ##               : Resource Identifier
  var path_564132 = newJObject()
  var query_564133 = newJObject()
  add(query_564133, "api-version", newJString(apiVersion))
  add(path_564132, "subscriptionId", newJString(subscriptionId))
  add(path_564132, "resourceGroupName", newJString(resourceGroupName))
  add(path_564132, "resourceName", newJString(resourceName))
  result = call_564131.call(path_564132, query_564133, nil, nil, nil)

var maintenanceConfigurationsDelete* = Call_MaintenanceConfigurationsDelete_564123(
    name: "maintenanceConfigurationsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Maintenance/maintenanceConfigurations/{resourceName}",
    validator: validate_MaintenanceConfigurationsDelete_564124, base: "",
    url: url_MaintenanceConfigurationsDelete_564125, schemes: {Scheme.Https})
type
  Call_ApplyUpdatesCreateOrUpdateParent_564147 = ref object of OpenApiRestCall_563556
proc url_ApplyUpdatesCreateOrUpdateParent_564149(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "providerName" in path, "`providerName` is a required path parameter"
  assert "resourceParentType" in path,
        "`resourceParentType` is a required path parameter"
  assert "resourceParentName" in path,
        "`resourceParentName` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "providerName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceParentType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceParentName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Maintenance/applyUpdates/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplyUpdatesCreateOrUpdateParent_564148(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Apply maintenance updates to resource with parent
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   providerName: JString (required)
  ##               : Resource provider name
  ##   resourceType: JString (required)
  ##               : Resource type
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceParentName: JString (required)
  ##                     : Resource parent identifier
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name
  ##   resourceParentType: JString (required)
  ##                     : Resource parent type
  ##   resourceName: JString (required)
  ##               : Resource identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `providerName` field"
  var valid_564150 = path.getOrDefault("providerName")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "providerName", valid_564150
  var valid_564151 = path.getOrDefault("resourceType")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "resourceType", valid_564151
  var valid_564152 = path.getOrDefault("subscriptionId")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "subscriptionId", valid_564152
  var valid_564153 = path.getOrDefault("resourceParentName")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "resourceParentName", valid_564153
  var valid_564154 = path.getOrDefault("resourceGroupName")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "resourceGroupName", valid_564154
  var valid_564155 = path.getOrDefault("resourceParentType")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "resourceParentType", valid_564155
  var valid_564156 = path.getOrDefault("resourceName")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = nil)
  if valid_564156 != nil:
    section.add "resourceName", valid_564156
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564157 = query.getOrDefault("api-version")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "api-version", valid_564157
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564158: Call_ApplyUpdatesCreateOrUpdateParent_564147;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Apply maintenance updates to resource with parent
  ## 
  let valid = call_564158.validator(path, query, header, formData, body)
  let scheme = call_564158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564158.url(scheme.get, call_564158.host, call_564158.base,
                         call_564158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564158, url, valid)

proc call*(call_564159: Call_ApplyUpdatesCreateOrUpdateParent_564147;
          providerName: string; apiVersion: string; resourceType: string;
          subscriptionId: string; resourceParentName: string;
          resourceGroupName: string; resourceParentType: string;
          resourceName: string): Recallable =
  ## applyUpdatesCreateOrUpdateParent
  ## Apply maintenance updates to resource with parent
  ##   providerName: string (required)
  ##               : Resource provider name
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   resourceType: string (required)
  ##               : Resource type
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceParentName: string (required)
  ##                     : Resource parent identifier
  ##   resourceGroupName: string (required)
  ##                    : Resource group name
  ##   resourceParentType: string (required)
  ##                     : Resource parent type
  ##   resourceName: string (required)
  ##               : Resource identifier
  var path_564160 = newJObject()
  var query_564161 = newJObject()
  add(path_564160, "providerName", newJString(providerName))
  add(query_564161, "api-version", newJString(apiVersion))
  add(path_564160, "resourceType", newJString(resourceType))
  add(path_564160, "subscriptionId", newJString(subscriptionId))
  add(path_564160, "resourceParentName", newJString(resourceParentName))
  add(path_564160, "resourceGroupName", newJString(resourceGroupName))
  add(path_564160, "resourceParentType", newJString(resourceParentType))
  add(path_564160, "resourceName", newJString(resourceName))
  result = call_564159.call(path_564160, query_564161, nil, nil, nil)

var applyUpdatesCreateOrUpdateParent* = Call_ApplyUpdatesCreateOrUpdateParent_564147(
    name: "applyUpdatesCreateOrUpdateParent", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{providerName}/{resourceParentType}/{resourceParentName}/{resourceType}/{resourceName}/providers/Microsoft.Maintenance/applyUpdates/default",
    validator: validate_ApplyUpdatesCreateOrUpdateParent_564148, base: "",
    url: url_ApplyUpdatesCreateOrUpdateParent_564149, schemes: {Scheme.Https})
type
  Call_ApplyUpdatesGetParent_564162 = ref object of OpenApiRestCall_563556
proc url_ApplyUpdatesGetParent_564164(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "providerName" in path, "`providerName` is a required path parameter"
  assert "resourceParentType" in path,
        "`resourceParentType` is a required path parameter"
  assert "resourceParentName" in path,
        "`resourceParentName` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "applyUpdateName" in path, "`applyUpdateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "providerName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceParentType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceParentName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Maintenance/applyUpdates/"),
               (kind: VariableSegment, value: "applyUpdateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplyUpdatesGetParent_564163(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Track maintenance updates to resource with parent
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   providerName: JString (required)
  ##               : Resource provider name
  ##   resourceType: JString (required)
  ##               : Resource type
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceParentName: JString (required)
  ##                     : Resource parent identifier
  ##   applyUpdateName: JString (required)
  ##                  : applyUpdate Id
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name
  ##   resourceParentType: JString (required)
  ##                     : Resource parent type
  ##   resourceName: JString (required)
  ##               : Resource identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `providerName` field"
  var valid_564165 = path.getOrDefault("providerName")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "providerName", valid_564165
  var valid_564166 = path.getOrDefault("resourceType")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "resourceType", valid_564166
  var valid_564167 = path.getOrDefault("subscriptionId")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "subscriptionId", valid_564167
  var valid_564168 = path.getOrDefault("resourceParentName")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "resourceParentName", valid_564168
  var valid_564169 = path.getOrDefault("applyUpdateName")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "applyUpdateName", valid_564169
  var valid_564170 = path.getOrDefault("resourceGroupName")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "resourceGroupName", valid_564170
  var valid_564171 = path.getOrDefault("resourceParentType")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = nil)
  if valid_564171 != nil:
    section.add "resourceParentType", valid_564171
  var valid_564172 = path.getOrDefault("resourceName")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "resourceName", valid_564172
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564173 = query.getOrDefault("api-version")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "api-version", valid_564173
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564174: Call_ApplyUpdatesGetParent_564162; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Track maintenance updates to resource with parent
  ## 
  let valid = call_564174.validator(path, query, header, formData, body)
  let scheme = call_564174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564174.url(scheme.get, call_564174.host, call_564174.base,
                         call_564174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564174, url, valid)

proc call*(call_564175: Call_ApplyUpdatesGetParent_564162; providerName: string;
          apiVersion: string; resourceType: string; subscriptionId: string;
          resourceParentName: string; applyUpdateName: string;
          resourceGroupName: string; resourceParentType: string;
          resourceName: string): Recallable =
  ## applyUpdatesGetParent
  ## Track maintenance updates to resource with parent
  ##   providerName: string (required)
  ##               : Resource provider name
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   resourceType: string (required)
  ##               : Resource type
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceParentName: string (required)
  ##                     : Resource parent identifier
  ##   applyUpdateName: string (required)
  ##                  : applyUpdate Id
  ##   resourceGroupName: string (required)
  ##                    : Resource group name
  ##   resourceParentType: string (required)
  ##                     : Resource parent type
  ##   resourceName: string (required)
  ##               : Resource identifier
  var path_564176 = newJObject()
  var query_564177 = newJObject()
  add(path_564176, "providerName", newJString(providerName))
  add(query_564177, "api-version", newJString(apiVersion))
  add(path_564176, "resourceType", newJString(resourceType))
  add(path_564176, "subscriptionId", newJString(subscriptionId))
  add(path_564176, "resourceParentName", newJString(resourceParentName))
  add(path_564176, "applyUpdateName", newJString(applyUpdateName))
  add(path_564176, "resourceGroupName", newJString(resourceGroupName))
  add(path_564176, "resourceParentType", newJString(resourceParentType))
  add(path_564176, "resourceName", newJString(resourceName))
  result = call_564175.call(path_564176, query_564177, nil, nil, nil)

var applyUpdatesGetParent* = Call_ApplyUpdatesGetParent_564162(
    name: "applyUpdatesGetParent", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{providerName}/{resourceParentType}/{resourceParentName}/{resourceType}/{resourceName}/providers/Microsoft.Maintenance/applyUpdates/{applyUpdateName}",
    validator: validate_ApplyUpdatesGetParent_564163, base: "",
    url: url_ApplyUpdatesGetParent_564164, schemes: {Scheme.Https})
type
  Call_ConfigurationAssignmentsListParent_564178 = ref object of OpenApiRestCall_563556
proc url_ConfigurationAssignmentsListParent_564180(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "providerName" in path, "`providerName` is a required path parameter"
  assert "resourceParentType" in path,
        "`resourceParentType` is a required path parameter"
  assert "resourceParentName" in path,
        "`resourceParentName` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "providerName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceParentType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceParentName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Maintenance/configurationAssignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationAssignmentsListParent_564179(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List configurationAssignments for resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   providerName: JString (required)
  ##               : Resource provider name
  ##   resourceType: JString (required)
  ##               : Resource type
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceParentName: JString (required)
  ##                     : Resource parent identifier
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name
  ##   resourceParentType: JString (required)
  ##                     : Resource parent type
  ##   resourceName: JString (required)
  ##               : Resource identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `providerName` field"
  var valid_564181 = path.getOrDefault("providerName")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "providerName", valid_564181
  var valid_564182 = path.getOrDefault("resourceType")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "resourceType", valid_564182
  var valid_564183 = path.getOrDefault("subscriptionId")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "subscriptionId", valid_564183
  var valid_564184 = path.getOrDefault("resourceParentName")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "resourceParentName", valid_564184
  var valid_564185 = path.getOrDefault("resourceGroupName")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "resourceGroupName", valid_564185
  var valid_564186 = path.getOrDefault("resourceParentType")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = nil)
  if valid_564186 != nil:
    section.add "resourceParentType", valid_564186
  var valid_564187 = path.getOrDefault("resourceName")
  valid_564187 = validateParameter(valid_564187, JString, required = true,
                                 default = nil)
  if valid_564187 != nil:
    section.add "resourceName", valid_564187
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564188 = query.getOrDefault("api-version")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = nil)
  if valid_564188 != nil:
    section.add "api-version", valid_564188
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564189: Call_ConfigurationAssignmentsListParent_564178;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List configurationAssignments for resource.
  ## 
  let valid = call_564189.validator(path, query, header, formData, body)
  let scheme = call_564189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564189.url(scheme.get, call_564189.host, call_564189.base,
                         call_564189.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564189, url, valid)

proc call*(call_564190: Call_ConfigurationAssignmentsListParent_564178;
          providerName: string; apiVersion: string; resourceType: string;
          subscriptionId: string; resourceParentName: string;
          resourceGroupName: string; resourceParentType: string;
          resourceName: string): Recallable =
  ## configurationAssignmentsListParent
  ## List configurationAssignments for resource.
  ##   providerName: string (required)
  ##               : Resource provider name
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   resourceType: string (required)
  ##               : Resource type
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceParentName: string (required)
  ##                     : Resource parent identifier
  ##   resourceGroupName: string (required)
  ##                    : Resource group name
  ##   resourceParentType: string (required)
  ##                     : Resource parent type
  ##   resourceName: string (required)
  ##               : Resource identifier
  var path_564191 = newJObject()
  var query_564192 = newJObject()
  add(path_564191, "providerName", newJString(providerName))
  add(query_564192, "api-version", newJString(apiVersion))
  add(path_564191, "resourceType", newJString(resourceType))
  add(path_564191, "subscriptionId", newJString(subscriptionId))
  add(path_564191, "resourceParentName", newJString(resourceParentName))
  add(path_564191, "resourceGroupName", newJString(resourceGroupName))
  add(path_564191, "resourceParentType", newJString(resourceParentType))
  add(path_564191, "resourceName", newJString(resourceName))
  result = call_564190.call(path_564191, query_564192, nil, nil, nil)

var configurationAssignmentsListParent* = Call_ConfigurationAssignmentsListParent_564178(
    name: "configurationAssignmentsListParent", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{providerName}/{resourceParentType}/{resourceParentName}/{resourceType}/{resourceName}/providers/Microsoft.Maintenance/configurationAssignments",
    validator: validate_ConfigurationAssignmentsListParent_564179, base: "",
    url: url_ConfigurationAssignmentsListParent_564180, schemes: {Scheme.Https})
type
  Call_ConfigurationAssignmentsCreateOrUpdateParent_564193 = ref object of OpenApiRestCall_563556
proc url_ConfigurationAssignmentsCreateOrUpdateParent_564195(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "providerName" in path, "`providerName` is a required path parameter"
  assert "resourceParentType" in path,
        "`resourceParentType` is a required path parameter"
  assert "resourceParentName" in path,
        "`resourceParentName` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "configurationAssignmentName" in path,
        "`configurationAssignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "providerName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceParentType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceParentName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Maintenance/configurationAssignments/"),
               (kind: VariableSegment, value: "configurationAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationAssignmentsCreateOrUpdateParent_564194(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Register configuration for resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   providerName: JString (required)
  ##               : Resource provider name
  ##   resourceType: JString (required)
  ##               : Resource type
  ##   configurationAssignmentName: JString (required)
  ##                              : Configuration assignment name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceParentName: JString (required)
  ##                     : Resource parent identifier
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name
  ##   resourceParentType: JString (required)
  ##                     : Resource parent type
  ##   resourceName: JString (required)
  ##               : Resource identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `providerName` field"
  var valid_564196 = path.getOrDefault("providerName")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "providerName", valid_564196
  var valid_564197 = path.getOrDefault("resourceType")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "resourceType", valid_564197
  var valid_564198 = path.getOrDefault("configurationAssignmentName")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "configurationAssignmentName", valid_564198
  var valid_564199 = path.getOrDefault("subscriptionId")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "subscriptionId", valid_564199
  var valid_564200 = path.getOrDefault("resourceParentName")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "resourceParentName", valid_564200
  var valid_564201 = path.getOrDefault("resourceGroupName")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "resourceGroupName", valid_564201
  var valid_564202 = path.getOrDefault("resourceParentType")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "resourceParentType", valid_564202
  var valid_564203 = path.getOrDefault("resourceName")
  valid_564203 = validateParameter(valid_564203, JString, required = true,
                                 default = nil)
  if valid_564203 != nil:
    section.add "resourceName", valid_564203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564204 = query.getOrDefault("api-version")
  valid_564204 = validateParameter(valid_564204, JString, required = true,
                                 default = nil)
  if valid_564204 != nil:
    section.add "api-version", valid_564204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   configurationAssignment: JObject (required)
  ##                          : The configurationAssignment
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564206: Call_ConfigurationAssignmentsCreateOrUpdateParent_564193;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Register configuration for resource.
  ## 
  let valid = call_564206.validator(path, query, header, formData, body)
  let scheme = call_564206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564206.url(scheme.get, call_564206.host, call_564206.base,
                         call_564206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564206, url, valid)

proc call*(call_564207: Call_ConfigurationAssignmentsCreateOrUpdateParent_564193;
          providerName: string; apiVersion: string; resourceType: string;
          configurationAssignmentName: string; subscriptionId: string;
          configurationAssignment: JsonNode; resourceParentName: string;
          resourceGroupName: string; resourceParentType: string;
          resourceName: string): Recallable =
  ## configurationAssignmentsCreateOrUpdateParent
  ## Register configuration for resource.
  ##   providerName: string (required)
  ##               : Resource provider name
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   resourceType: string (required)
  ##               : Resource type
  ##   configurationAssignmentName: string (required)
  ##                              : Configuration assignment name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   configurationAssignment: JObject (required)
  ##                          : The configurationAssignment
  ##   resourceParentName: string (required)
  ##                     : Resource parent identifier
  ##   resourceGroupName: string (required)
  ##                    : Resource group name
  ##   resourceParentType: string (required)
  ##                     : Resource parent type
  ##   resourceName: string (required)
  ##               : Resource identifier
  var path_564208 = newJObject()
  var query_564209 = newJObject()
  var body_564210 = newJObject()
  add(path_564208, "providerName", newJString(providerName))
  add(query_564209, "api-version", newJString(apiVersion))
  add(path_564208, "resourceType", newJString(resourceType))
  add(path_564208, "configurationAssignmentName",
      newJString(configurationAssignmentName))
  add(path_564208, "subscriptionId", newJString(subscriptionId))
  if configurationAssignment != nil:
    body_564210 = configurationAssignment
  add(path_564208, "resourceParentName", newJString(resourceParentName))
  add(path_564208, "resourceGroupName", newJString(resourceGroupName))
  add(path_564208, "resourceParentType", newJString(resourceParentType))
  add(path_564208, "resourceName", newJString(resourceName))
  result = call_564207.call(path_564208, query_564209, nil, nil, body_564210)

var configurationAssignmentsCreateOrUpdateParent* = Call_ConfigurationAssignmentsCreateOrUpdateParent_564193(
    name: "configurationAssignmentsCreateOrUpdateParent",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{providerName}/{resourceParentType}/{resourceParentName}/{resourceType}/{resourceName}/providers/Microsoft.Maintenance/configurationAssignments/{configurationAssignmentName}",
    validator: validate_ConfigurationAssignmentsCreateOrUpdateParent_564194,
    base: "", url: url_ConfigurationAssignmentsCreateOrUpdateParent_564195,
    schemes: {Scheme.Https})
type
  Call_ConfigurationAssignmentsDeleteParent_564211 = ref object of OpenApiRestCall_563556
proc url_ConfigurationAssignmentsDeleteParent_564213(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "providerName" in path, "`providerName` is a required path parameter"
  assert "resourceParentType" in path,
        "`resourceParentType` is a required path parameter"
  assert "resourceParentName" in path,
        "`resourceParentName` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "configurationAssignmentName" in path,
        "`configurationAssignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "providerName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceParentType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceParentName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Maintenance/configurationAssignments/"),
               (kind: VariableSegment, value: "configurationAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationAssignmentsDeleteParent_564212(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Unregister configuration for resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   providerName: JString (required)
  ##               : Resource provider name
  ##   resourceType: JString (required)
  ##               : Resource type
  ##   configurationAssignmentName: JString (required)
  ##                              : Unique configuration assignment name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceParentName: JString (required)
  ##                     : Resource parent identifier
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name
  ##   resourceParentType: JString (required)
  ##                     : Resource parent type
  ##   resourceName: JString (required)
  ##               : Resource identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `providerName` field"
  var valid_564214 = path.getOrDefault("providerName")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "providerName", valid_564214
  var valid_564215 = path.getOrDefault("resourceType")
  valid_564215 = validateParameter(valid_564215, JString, required = true,
                                 default = nil)
  if valid_564215 != nil:
    section.add "resourceType", valid_564215
  var valid_564216 = path.getOrDefault("configurationAssignmentName")
  valid_564216 = validateParameter(valid_564216, JString, required = true,
                                 default = nil)
  if valid_564216 != nil:
    section.add "configurationAssignmentName", valid_564216
  var valid_564217 = path.getOrDefault("subscriptionId")
  valid_564217 = validateParameter(valid_564217, JString, required = true,
                                 default = nil)
  if valid_564217 != nil:
    section.add "subscriptionId", valid_564217
  var valid_564218 = path.getOrDefault("resourceParentName")
  valid_564218 = validateParameter(valid_564218, JString, required = true,
                                 default = nil)
  if valid_564218 != nil:
    section.add "resourceParentName", valid_564218
  var valid_564219 = path.getOrDefault("resourceGroupName")
  valid_564219 = validateParameter(valid_564219, JString, required = true,
                                 default = nil)
  if valid_564219 != nil:
    section.add "resourceGroupName", valid_564219
  var valid_564220 = path.getOrDefault("resourceParentType")
  valid_564220 = validateParameter(valid_564220, JString, required = true,
                                 default = nil)
  if valid_564220 != nil:
    section.add "resourceParentType", valid_564220
  var valid_564221 = path.getOrDefault("resourceName")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "resourceName", valid_564221
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564222 = query.getOrDefault("api-version")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "api-version", valid_564222
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564223: Call_ConfigurationAssignmentsDeleteParent_564211;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Unregister configuration for resource.
  ## 
  let valid = call_564223.validator(path, query, header, formData, body)
  let scheme = call_564223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564223.url(scheme.get, call_564223.host, call_564223.base,
                         call_564223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564223, url, valid)

proc call*(call_564224: Call_ConfigurationAssignmentsDeleteParent_564211;
          providerName: string; apiVersion: string; resourceType: string;
          configurationAssignmentName: string; subscriptionId: string;
          resourceParentName: string; resourceGroupName: string;
          resourceParentType: string; resourceName: string): Recallable =
  ## configurationAssignmentsDeleteParent
  ## Unregister configuration for resource.
  ##   providerName: string (required)
  ##               : Resource provider name
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   resourceType: string (required)
  ##               : Resource type
  ##   configurationAssignmentName: string (required)
  ##                              : Unique configuration assignment name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceParentName: string (required)
  ##                     : Resource parent identifier
  ##   resourceGroupName: string (required)
  ##                    : Resource group name
  ##   resourceParentType: string (required)
  ##                     : Resource parent type
  ##   resourceName: string (required)
  ##               : Resource identifier
  var path_564225 = newJObject()
  var query_564226 = newJObject()
  add(path_564225, "providerName", newJString(providerName))
  add(query_564226, "api-version", newJString(apiVersion))
  add(path_564225, "resourceType", newJString(resourceType))
  add(path_564225, "configurationAssignmentName",
      newJString(configurationAssignmentName))
  add(path_564225, "subscriptionId", newJString(subscriptionId))
  add(path_564225, "resourceParentName", newJString(resourceParentName))
  add(path_564225, "resourceGroupName", newJString(resourceGroupName))
  add(path_564225, "resourceParentType", newJString(resourceParentType))
  add(path_564225, "resourceName", newJString(resourceName))
  result = call_564224.call(path_564225, query_564226, nil, nil, nil)

var configurationAssignmentsDeleteParent* = Call_ConfigurationAssignmentsDeleteParent_564211(
    name: "configurationAssignmentsDeleteParent", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{providerName}/{resourceParentType}/{resourceParentName}/{resourceType}/{resourceName}/providers/Microsoft.Maintenance/configurationAssignments/{configurationAssignmentName}",
    validator: validate_ConfigurationAssignmentsDeleteParent_564212, base: "",
    url: url_ConfigurationAssignmentsDeleteParent_564213, schemes: {Scheme.Https})
type
  Call_UpdatesListParent_564227 = ref object of OpenApiRestCall_563556
proc url_UpdatesListParent_564229(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "providerName" in path, "`providerName` is a required path parameter"
  assert "resourceParentType" in path,
        "`resourceParentType` is a required path parameter"
  assert "resourceParentName" in path,
        "`resourceParentName` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "providerName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceParentType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceParentName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Maintenance/updates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UpdatesListParent_564228(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get updates to resources.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   providerName: JString (required)
  ##               : Resource provider name
  ##   resourceType: JString (required)
  ##               : Resource type
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceParentName: JString (required)
  ##                     : Resource parent identifier
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name
  ##   resourceParentType: JString (required)
  ##                     : Resource parent type
  ##   resourceName: JString (required)
  ##               : Resource identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `providerName` field"
  var valid_564230 = path.getOrDefault("providerName")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = nil)
  if valid_564230 != nil:
    section.add "providerName", valid_564230
  var valid_564231 = path.getOrDefault("resourceType")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = nil)
  if valid_564231 != nil:
    section.add "resourceType", valid_564231
  var valid_564232 = path.getOrDefault("subscriptionId")
  valid_564232 = validateParameter(valid_564232, JString, required = true,
                                 default = nil)
  if valid_564232 != nil:
    section.add "subscriptionId", valid_564232
  var valid_564233 = path.getOrDefault("resourceParentName")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "resourceParentName", valid_564233
  var valid_564234 = path.getOrDefault("resourceGroupName")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "resourceGroupName", valid_564234
  var valid_564235 = path.getOrDefault("resourceParentType")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "resourceParentType", valid_564235
  var valid_564236 = path.getOrDefault("resourceName")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "resourceName", valid_564236
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564237 = query.getOrDefault("api-version")
  valid_564237 = validateParameter(valid_564237, JString, required = true,
                                 default = nil)
  if valid_564237 != nil:
    section.add "api-version", valid_564237
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564238: Call_UpdatesListParent_564227; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get updates to resources.
  ## 
  let valid = call_564238.validator(path, query, header, formData, body)
  let scheme = call_564238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564238.url(scheme.get, call_564238.host, call_564238.base,
                         call_564238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564238, url, valid)

proc call*(call_564239: Call_UpdatesListParent_564227; providerName: string;
          apiVersion: string; resourceType: string; subscriptionId: string;
          resourceParentName: string; resourceGroupName: string;
          resourceParentType: string; resourceName: string): Recallable =
  ## updatesListParent
  ## Get updates to resources.
  ##   providerName: string (required)
  ##               : Resource provider name
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   resourceType: string (required)
  ##               : Resource type
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceParentName: string (required)
  ##                     : Resource parent identifier
  ##   resourceGroupName: string (required)
  ##                    : Resource group name
  ##   resourceParentType: string (required)
  ##                     : Resource parent type
  ##   resourceName: string (required)
  ##               : Resource identifier
  var path_564240 = newJObject()
  var query_564241 = newJObject()
  add(path_564240, "providerName", newJString(providerName))
  add(query_564241, "api-version", newJString(apiVersion))
  add(path_564240, "resourceType", newJString(resourceType))
  add(path_564240, "subscriptionId", newJString(subscriptionId))
  add(path_564240, "resourceParentName", newJString(resourceParentName))
  add(path_564240, "resourceGroupName", newJString(resourceGroupName))
  add(path_564240, "resourceParentType", newJString(resourceParentType))
  add(path_564240, "resourceName", newJString(resourceName))
  result = call_564239.call(path_564240, query_564241, nil, nil, nil)

var updatesListParent* = Call_UpdatesListParent_564227(name: "updatesListParent",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{providerName}/{resourceParentType}/{resourceParentName}/{resourceType}/{resourceName}/providers/Microsoft.Maintenance/updates",
    validator: validate_UpdatesListParent_564228, base: "",
    url: url_UpdatesListParent_564229, schemes: {Scheme.Https})
type
  Call_ApplyUpdatesCreateOrUpdate_564242 = ref object of OpenApiRestCall_563556
proc url_ApplyUpdatesCreateOrUpdate_564244(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "providerName" in path, "`providerName` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "providerName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Maintenance/applyUpdates/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplyUpdatesCreateOrUpdate_564243(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Apply maintenance updates to resource
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   providerName: JString (required)
  ##               : Resource provider name
  ##   resourceType: JString (required)
  ##               : Resource type
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name
  ##   resourceName: JString (required)
  ##               : Resource identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `providerName` field"
  var valid_564245 = path.getOrDefault("providerName")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "providerName", valid_564245
  var valid_564246 = path.getOrDefault("resourceType")
  valid_564246 = validateParameter(valid_564246, JString, required = true,
                                 default = nil)
  if valid_564246 != nil:
    section.add "resourceType", valid_564246
  var valid_564247 = path.getOrDefault("subscriptionId")
  valid_564247 = validateParameter(valid_564247, JString, required = true,
                                 default = nil)
  if valid_564247 != nil:
    section.add "subscriptionId", valid_564247
  var valid_564248 = path.getOrDefault("resourceGroupName")
  valid_564248 = validateParameter(valid_564248, JString, required = true,
                                 default = nil)
  if valid_564248 != nil:
    section.add "resourceGroupName", valid_564248
  var valid_564249 = path.getOrDefault("resourceName")
  valid_564249 = validateParameter(valid_564249, JString, required = true,
                                 default = nil)
  if valid_564249 != nil:
    section.add "resourceName", valid_564249
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564250 = query.getOrDefault("api-version")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "api-version", valid_564250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564251: Call_ApplyUpdatesCreateOrUpdate_564242; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Apply maintenance updates to resource
  ## 
  let valid = call_564251.validator(path, query, header, formData, body)
  let scheme = call_564251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564251.url(scheme.get, call_564251.host, call_564251.base,
                         call_564251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564251, url, valid)

proc call*(call_564252: Call_ApplyUpdatesCreateOrUpdate_564242;
          providerName: string; apiVersion: string; resourceType: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## applyUpdatesCreateOrUpdate
  ## Apply maintenance updates to resource
  ##   providerName: string (required)
  ##               : Resource provider name
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   resourceType: string (required)
  ##               : Resource type
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name
  ##   resourceName: string (required)
  ##               : Resource identifier
  var path_564253 = newJObject()
  var query_564254 = newJObject()
  add(path_564253, "providerName", newJString(providerName))
  add(query_564254, "api-version", newJString(apiVersion))
  add(path_564253, "resourceType", newJString(resourceType))
  add(path_564253, "subscriptionId", newJString(subscriptionId))
  add(path_564253, "resourceGroupName", newJString(resourceGroupName))
  add(path_564253, "resourceName", newJString(resourceName))
  result = call_564252.call(path_564253, query_564254, nil, nil, nil)

var applyUpdatesCreateOrUpdate* = Call_ApplyUpdatesCreateOrUpdate_564242(
    name: "applyUpdatesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{providerName}/{resourceType}/{resourceName}/providers/Microsoft.Maintenance/applyUpdates/default",
    validator: validate_ApplyUpdatesCreateOrUpdate_564243, base: "",
    url: url_ApplyUpdatesCreateOrUpdate_564244, schemes: {Scheme.Https})
type
  Call_ApplyUpdatesGet_564255 = ref object of OpenApiRestCall_563556
proc url_ApplyUpdatesGet_564257(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "providerName" in path, "`providerName` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "applyUpdateName" in path, "`applyUpdateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "providerName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Maintenance/applyUpdates/"),
               (kind: VariableSegment, value: "applyUpdateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplyUpdatesGet_564256(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Track maintenance updates to resource
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   providerName: JString (required)
  ##               : Resource provider name
  ##   resourceType: JString (required)
  ##               : Resource type
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applyUpdateName: JString (required)
  ##                  : applyUpdate Id
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name
  ##   resourceName: JString (required)
  ##               : Resource identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `providerName` field"
  var valid_564258 = path.getOrDefault("providerName")
  valid_564258 = validateParameter(valid_564258, JString, required = true,
                                 default = nil)
  if valid_564258 != nil:
    section.add "providerName", valid_564258
  var valid_564259 = path.getOrDefault("resourceType")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = nil)
  if valid_564259 != nil:
    section.add "resourceType", valid_564259
  var valid_564260 = path.getOrDefault("subscriptionId")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = nil)
  if valid_564260 != nil:
    section.add "subscriptionId", valid_564260
  var valid_564261 = path.getOrDefault("applyUpdateName")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "applyUpdateName", valid_564261
  var valid_564262 = path.getOrDefault("resourceGroupName")
  valid_564262 = validateParameter(valid_564262, JString, required = true,
                                 default = nil)
  if valid_564262 != nil:
    section.add "resourceGroupName", valid_564262
  var valid_564263 = path.getOrDefault("resourceName")
  valid_564263 = validateParameter(valid_564263, JString, required = true,
                                 default = nil)
  if valid_564263 != nil:
    section.add "resourceName", valid_564263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564264 = query.getOrDefault("api-version")
  valid_564264 = validateParameter(valid_564264, JString, required = true,
                                 default = nil)
  if valid_564264 != nil:
    section.add "api-version", valid_564264
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564265: Call_ApplyUpdatesGet_564255; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Track maintenance updates to resource
  ## 
  let valid = call_564265.validator(path, query, header, formData, body)
  let scheme = call_564265.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564265.url(scheme.get, call_564265.host, call_564265.base,
                         call_564265.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564265, url, valid)

proc call*(call_564266: Call_ApplyUpdatesGet_564255; providerName: string;
          apiVersion: string; resourceType: string; subscriptionId: string;
          applyUpdateName: string; resourceGroupName: string; resourceName: string): Recallable =
  ## applyUpdatesGet
  ## Track maintenance updates to resource
  ##   providerName: string (required)
  ##               : Resource provider name
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   resourceType: string (required)
  ##               : Resource type
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   applyUpdateName: string (required)
  ##                  : applyUpdate Id
  ##   resourceGroupName: string (required)
  ##                    : Resource group name
  ##   resourceName: string (required)
  ##               : Resource identifier
  var path_564267 = newJObject()
  var query_564268 = newJObject()
  add(path_564267, "providerName", newJString(providerName))
  add(query_564268, "api-version", newJString(apiVersion))
  add(path_564267, "resourceType", newJString(resourceType))
  add(path_564267, "subscriptionId", newJString(subscriptionId))
  add(path_564267, "applyUpdateName", newJString(applyUpdateName))
  add(path_564267, "resourceGroupName", newJString(resourceGroupName))
  add(path_564267, "resourceName", newJString(resourceName))
  result = call_564266.call(path_564267, query_564268, nil, nil, nil)

var applyUpdatesGet* = Call_ApplyUpdatesGet_564255(name: "applyUpdatesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{providerName}/{resourceType}/{resourceName}/providers/Microsoft.Maintenance/applyUpdates/{applyUpdateName}",
    validator: validate_ApplyUpdatesGet_564256, base: "", url: url_ApplyUpdatesGet_564257,
    schemes: {Scheme.Https})
type
  Call_ConfigurationAssignmentsList_564269 = ref object of OpenApiRestCall_563556
proc url_ConfigurationAssignmentsList_564271(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "providerName" in path, "`providerName` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "providerName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Maintenance/configurationAssignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationAssignmentsList_564270(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List configurationAssignments for resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   providerName: JString (required)
  ##               : Resource provider name
  ##   resourceType: JString (required)
  ##               : Resource type
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name
  ##   resourceName: JString (required)
  ##               : Resource identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `providerName` field"
  var valid_564272 = path.getOrDefault("providerName")
  valid_564272 = validateParameter(valid_564272, JString, required = true,
                                 default = nil)
  if valid_564272 != nil:
    section.add "providerName", valid_564272
  var valid_564273 = path.getOrDefault("resourceType")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "resourceType", valid_564273
  var valid_564274 = path.getOrDefault("subscriptionId")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "subscriptionId", valid_564274
  var valid_564275 = path.getOrDefault("resourceGroupName")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "resourceGroupName", valid_564275
  var valid_564276 = path.getOrDefault("resourceName")
  valid_564276 = validateParameter(valid_564276, JString, required = true,
                                 default = nil)
  if valid_564276 != nil:
    section.add "resourceName", valid_564276
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564277 = query.getOrDefault("api-version")
  valid_564277 = validateParameter(valid_564277, JString, required = true,
                                 default = nil)
  if valid_564277 != nil:
    section.add "api-version", valid_564277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564278: Call_ConfigurationAssignmentsList_564269; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List configurationAssignments for resource.
  ## 
  let valid = call_564278.validator(path, query, header, formData, body)
  let scheme = call_564278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564278.url(scheme.get, call_564278.host, call_564278.base,
                         call_564278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564278, url, valid)

proc call*(call_564279: Call_ConfigurationAssignmentsList_564269;
          providerName: string; apiVersion: string; resourceType: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## configurationAssignmentsList
  ## List configurationAssignments for resource.
  ##   providerName: string (required)
  ##               : Resource provider name
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   resourceType: string (required)
  ##               : Resource type
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name
  ##   resourceName: string (required)
  ##               : Resource identifier
  var path_564280 = newJObject()
  var query_564281 = newJObject()
  add(path_564280, "providerName", newJString(providerName))
  add(query_564281, "api-version", newJString(apiVersion))
  add(path_564280, "resourceType", newJString(resourceType))
  add(path_564280, "subscriptionId", newJString(subscriptionId))
  add(path_564280, "resourceGroupName", newJString(resourceGroupName))
  add(path_564280, "resourceName", newJString(resourceName))
  result = call_564279.call(path_564280, query_564281, nil, nil, nil)

var configurationAssignmentsList* = Call_ConfigurationAssignmentsList_564269(
    name: "configurationAssignmentsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{providerName}/{resourceType}/{resourceName}/providers/Microsoft.Maintenance/configurationAssignments",
    validator: validate_ConfigurationAssignmentsList_564270, base: "",
    url: url_ConfigurationAssignmentsList_564271, schemes: {Scheme.Https})
type
  Call_ConfigurationAssignmentsCreateOrUpdate_564282 = ref object of OpenApiRestCall_563556
proc url_ConfigurationAssignmentsCreateOrUpdate_564284(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "providerName" in path, "`providerName` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "configurationAssignmentName" in path,
        "`configurationAssignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "providerName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Maintenance/configurationAssignments/"),
               (kind: VariableSegment, value: "configurationAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationAssignmentsCreateOrUpdate_564283(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Register configuration for resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   providerName: JString (required)
  ##               : Resource provider name
  ##   resourceType: JString (required)
  ##               : Resource type
  ##   configurationAssignmentName: JString (required)
  ##                              : Configuration assignment name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name
  ##   resourceName: JString (required)
  ##               : Resource identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `providerName` field"
  var valid_564285 = path.getOrDefault("providerName")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "providerName", valid_564285
  var valid_564286 = path.getOrDefault("resourceType")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "resourceType", valid_564286
  var valid_564287 = path.getOrDefault("configurationAssignmentName")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "configurationAssignmentName", valid_564287
  var valid_564288 = path.getOrDefault("subscriptionId")
  valid_564288 = validateParameter(valid_564288, JString, required = true,
                                 default = nil)
  if valid_564288 != nil:
    section.add "subscriptionId", valid_564288
  var valid_564289 = path.getOrDefault("resourceGroupName")
  valid_564289 = validateParameter(valid_564289, JString, required = true,
                                 default = nil)
  if valid_564289 != nil:
    section.add "resourceGroupName", valid_564289
  var valid_564290 = path.getOrDefault("resourceName")
  valid_564290 = validateParameter(valid_564290, JString, required = true,
                                 default = nil)
  if valid_564290 != nil:
    section.add "resourceName", valid_564290
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564291 = query.getOrDefault("api-version")
  valid_564291 = validateParameter(valid_564291, JString, required = true,
                                 default = nil)
  if valid_564291 != nil:
    section.add "api-version", valid_564291
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   configurationAssignment: JObject (required)
  ##                          : The configurationAssignment
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564293: Call_ConfigurationAssignmentsCreateOrUpdate_564282;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Register configuration for resource.
  ## 
  let valid = call_564293.validator(path, query, header, formData, body)
  let scheme = call_564293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564293.url(scheme.get, call_564293.host, call_564293.base,
                         call_564293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564293, url, valid)

proc call*(call_564294: Call_ConfigurationAssignmentsCreateOrUpdate_564282;
          providerName: string; apiVersion: string; resourceType: string;
          configurationAssignmentName: string; subscriptionId: string;
          configurationAssignment: JsonNode; resourceGroupName: string;
          resourceName: string): Recallable =
  ## configurationAssignmentsCreateOrUpdate
  ## Register configuration for resource.
  ##   providerName: string (required)
  ##               : Resource provider name
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   resourceType: string (required)
  ##               : Resource type
  ##   configurationAssignmentName: string (required)
  ##                              : Configuration assignment name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   configurationAssignment: JObject (required)
  ##                          : The configurationAssignment
  ##   resourceGroupName: string (required)
  ##                    : Resource group name
  ##   resourceName: string (required)
  ##               : Resource identifier
  var path_564295 = newJObject()
  var query_564296 = newJObject()
  var body_564297 = newJObject()
  add(path_564295, "providerName", newJString(providerName))
  add(query_564296, "api-version", newJString(apiVersion))
  add(path_564295, "resourceType", newJString(resourceType))
  add(path_564295, "configurationAssignmentName",
      newJString(configurationAssignmentName))
  add(path_564295, "subscriptionId", newJString(subscriptionId))
  if configurationAssignment != nil:
    body_564297 = configurationAssignment
  add(path_564295, "resourceGroupName", newJString(resourceGroupName))
  add(path_564295, "resourceName", newJString(resourceName))
  result = call_564294.call(path_564295, query_564296, nil, nil, body_564297)

var configurationAssignmentsCreateOrUpdate* = Call_ConfigurationAssignmentsCreateOrUpdate_564282(
    name: "configurationAssignmentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{providerName}/{resourceType}/{resourceName}/providers/Microsoft.Maintenance/configurationAssignments/{configurationAssignmentName}",
    validator: validate_ConfigurationAssignmentsCreateOrUpdate_564283, base: "",
    url: url_ConfigurationAssignmentsCreateOrUpdate_564284,
    schemes: {Scheme.Https})
type
  Call_ConfigurationAssignmentsDelete_564298 = ref object of OpenApiRestCall_563556
proc url_ConfigurationAssignmentsDelete_564300(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "providerName" in path, "`providerName` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "configurationAssignmentName" in path,
        "`configurationAssignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "providerName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Maintenance/configurationAssignments/"),
               (kind: VariableSegment, value: "configurationAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationAssignmentsDelete_564299(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Unregister configuration for resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   providerName: JString (required)
  ##               : Resource provider name
  ##   resourceType: JString (required)
  ##               : Resource type
  ##   configurationAssignmentName: JString (required)
  ##                              : Unique configuration assignment name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name
  ##   resourceName: JString (required)
  ##               : Resource identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `providerName` field"
  var valid_564301 = path.getOrDefault("providerName")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = nil)
  if valid_564301 != nil:
    section.add "providerName", valid_564301
  var valid_564302 = path.getOrDefault("resourceType")
  valid_564302 = validateParameter(valid_564302, JString, required = true,
                                 default = nil)
  if valid_564302 != nil:
    section.add "resourceType", valid_564302
  var valid_564303 = path.getOrDefault("configurationAssignmentName")
  valid_564303 = validateParameter(valid_564303, JString, required = true,
                                 default = nil)
  if valid_564303 != nil:
    section.add "configurationAssignmentName", valid_564303
  var valid_564304 = path.getOrDefault("subscriptionId")
  valid_564304 = validateParameter(valid_564304, JString, required = true,
                                 default = nil)
  if valid_564304 != nil:
    section.add "subscriptionId", valid_564304
  var valid_564305 = path.getOrDefault("resourceGroupName")
  valid_564305 = validateParameter(valid_564305, JString, required = true,
                                 default = nil)
  if valid_564305 != nil:
    section.add "resourceGroupName", valid_564305
  var valid_564306 = path.getOrDefault("resourceName")
  valid_564306 = validateParameter(valid_564306, JString, required = true,
                                 default = nil)
  if valid_564306 != nil:
    section.add "resourceName", valid_564306
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564307 = query.getOrDefault("api-version")
  valid_564307 = validateParameter(valid_564307, JString, required = true,
                                 default = nil)
  if valid_564307 != nil:
    section.add "api-version", valid_564307
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564308: Call_ConfigurationAssignmentsDelete_564298; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unregister configuration for resource.
  ## 
  let valid = call_564308.validator(path, query, header, formData, body)
  let scheme = call_564308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564308.url(scheme.get, call_564308.host, call_564308.base,
                         call_564308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564308, url, valid)

proc call*(call_564309: Call_ConfigurationAssignmentsDelete_564298;
          providerName: string; apiVersion: string; resourceType: string;
          configurationAssignmentName: string; subscriptionId: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## configurationAssignmentsDelete
  ## Unregister configuration for resource.
  ##   providerName: string (required)
  ##               : Resource provider name
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   resourceType: string (required)
  ##               : Resource type
  ##   configurationAssignmentName: string (required)
  ##                              : Unique configuration assignment name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name
  ##   resourceName: string (required)
  ##               : Resource identifier
  var path_564310 = newJObject()
  var query_564311 = newJObject()
  add(path_564310, "providerName", newJString(providerName))
  add(query_564311, "api-version", newJString(apiVersion))
  add(path_564310, "resourceType", newJString(resourceType))
  add(path_564310, "configurationAssignmentName",
      newJString(configurationAssignmentName))
  add(path_564310, "subscriptionId", newJString(subscriptionId))
  add(path_564310, "resourceGroupName", newJString(resourceGroupName))
  add(path_564310, "resourceName", newJString(resourceName))
  result = call_564309.call(path_564310, query_564311, nil, nil, nil)

var configurationAssignmentsDelete* = Call_ConfigurationAssignmentsDelete_564298(
    name: "configurationAssignmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{providerName}/{resourceType}/{resourceName}/providers/Microsoft.Maintenance/configurationAssignments/{configurationAssignmentName}",
    validator: validate_ConfigurationAssignmentsDelete_564299, base: "",
    url: url_ConfigurationAssignmentsDelete_564300, schemes: {Scheme.Https})
type
  Call_UpdatesList_564312 = ref object of OpenApiRestCall_563556
proc url_UpdatesList_564314(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "providerName" in path, "`providerName` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "providerName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Maintenance/updates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UpdatesList_564313(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get updates to resources.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   providerName: JString (required)
  ##               : Resource provider name
  ##   resourceType: JString (required)
  ##               : Resource type
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name
  ##   resourceName: JString (required)
  ##               : Resource identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `providerName` field"
  var valid_564315 = path.getOrDefault("providerName")
  valid_564315 = validateParameter(valid_564315, JString, required = true,
                                 default = nil)
  if valid_564315 != nil:
    section.add "providerName", valid_564315
  var valid_564316 = path.getOrDefault("resourceType")
  valid_564316 = validateParameter(valid_564316, JString, required = true,
                                 default = nil)
  if valid_564316 != nil:
    section.add "resourceType", valid_564316
  var valid_564317 = path.getOrDefault("subscriptionId")
  valid_564317 = validateParameter(valid_564317, JString, required = true,
                                 default = nil)
  if valid_564317 != nil:
    section.add "subscriptionId", valid_564317
  var valid_564318 = path.getOrDefault("resourceGroupName")
  valid_564318 = validateParameter(valid_564318, JString, required = true,
                                 default = nil)
  if valid_564318 != nil:
    section.add "resourceGroupName", valid_564318
  var valid_564319 = path.getOrDefault("resourceName")
  valid_564319 = validateParameter(valid_564319, JString, required = true,
                                 default = nil)
  if valid_564319 != nil:
    section.add "resourceName", valid_564319
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564320 = query.getOrDefault("api-version")
  valid_564320 = validateParameter(valid_564320, JString, required = true,
                                 default = nil)
  if valid_564320 != nil:
    section.add "api-version", valid_564320
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564321: Call_UpdatesList_564312; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get updates to resources.
  ## 
  let valid = call_564321.validator(path, query, header, formData, body)
  let scheme = call_564321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564321.url(scheme.get, call_564321.host, call_564321.base,
                         call_564321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564321, url, valid)

proc call*(call_564322: Call_UpdatesList_564312; providerName: string;
          apiVersion: string; resourceType: string; subscriptionId: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## updatesList
  ## Get updates to resources.
  ##   providerName: string (required)
  ##               : Resource provider name
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   resourceType: string (required)
  ##               : Resource type
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name
  ##   resourceName: string (required)
  ##               : Resource identifier
  var path_564323 = newJObject()
  var query_564324 = newJObject()
  add(path_564323, "providerName", newJString(providerName))
  add(query_564324, "api-version", newJString(apiVersion))
  add(path_564323, "resourceType", newJString(resourceType))
  add(path_564323, "subscriptionId", newJString(subscriptionId))
  add(path_564323, "resourceGroupName", newJString(resourceGroupName))
  add(path_564323, "resourceName", newJString(resourceName))
  result = call_564322.call(path_564323, query_564324, nil, nil, nil)

var updatesList* = Call_UpdatesList_564312(name: "updatesList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{providerName}/{resourceType}/{resourceName}/providers/Microsoft.Maintenance/updates",
                                        validator: validate_UpdatesList_564313,
                                        base: "", url: url_UpdatesList_564314,
                                        schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
