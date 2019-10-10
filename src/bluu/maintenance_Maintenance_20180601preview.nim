
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
  macServiceName = "maintenance-Maintenance"
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
  ## List the available operations supported by the Microsoft.Maintenance resource provider
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
  ## List the available operations supported by the Microsoft.Maintenance resource provider
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  var query_574136 = newJObject()
  add(query_574136, "api-version", newJString(apiVersion))
  result = call_574135.call(nil, query_574136, nil, nil, nil)

var operationsList* = Call_OperationsList_573880(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Maintenance/operations",
    validator: validate_OperationsList_573881, base: "", url: url_OperationsList_573882,
    schemes: {Scheme.Https})
type
  Call_MaintenanceConfigurationsList_574176 = ref object of OpenApiRestCall_573658
proc url_MaintenanceConfigurationsList_574178(protocol: Scheme; host: string;
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

proc validate_MaintenanceConfigurationsList_574177(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574193 = path.getOrDefault("subscriptionId")
  valid_574193 = validateParameter(valid_574193, JString, required = true,
                                 default = nil)
  if valid_574193 != nil:
    section.add "subscriptionId", valid_574193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574194 = query.getOrDefault("api-version")
  valid_574194 = validateParameter(valid_574194, JString, required = true,
                                 default = nil)
  if valid_574194 != nil:
    section.add "api-version", valid_574194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574195: Call_MaintenanceConfigurationsList_574176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574195.validator(path, query, header, formData, body)
  let scheme = call_574195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574195.url(scheme.get, call_574195.host, call_574195.base,
                         call_574195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574195, url, valid)

proc call*(call_574196: Call_MaintenanceConfigurationsList_574176;
          apiVersion: string; subscriptionId: string): Recallable =
  ## maintenanceConfigurationsList
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574197 = newJObject()
  var query_574198 = newJObject()
  add(query_574198, "api-version", newJString(apiVersion))
  add(path_574197, "subscriptionId", newJString(subscriptionId))
  result = call_574196.call(path_574197, query_574198, nil, nil, nil)

var maintenanceConfigurationsList* = Call_MaintenanceConfigurationsList_574176(
    name: "maintenanceConfigurationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Maintenance/maintenanceConfigurations",
    validator: validate_MaintenanceConfigurationsList_574177, base: "",
    url: url_MaintenanceConfigurationsList_574178, schemes: {Scheme.Https})
type
  Call_MaintenanceConfigurationsCreateOrUpdate_574210 = ref object of OpenApiRestCall_573658
proc url_MaintenanceConfigurationsCreateOrUpdate_574212(protocol: Scheme;
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

proc validate_MaintenanceConfigurationsCreateOrUpdate_574211(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : Resource Identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574213 = path.getOrDefault("resourceGroupName")
  valid_574213 = validateParameter(valid_574213, JString, required = true,
                                 default = nil)
  if valid_574213 != nil:
    section.add "resourceGroupName", valid_574213
  var valid_574214 = path.getOrDefault("subscriptionId")
  valid_574214 = validateParameter(valid_574214, JString, required = true,
                                 default = nil)
  if valid_574214 != nil:
    section.add "subscriptionId", valid_574214
  var valid_574215 = path.getOrDefault("resourceName")
  valid_574215 = validateParameter(valid_574215, JString, required = true,
                                 default = nil)
  if valid_574215 != nil:
    section.add "resourceName", valid_574215
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574216 = query.getOrDefault("api-version")
  valid_574216 = validateParameter(valid_574216, JString, required = true,
                                 default = nil)
  if valid_574216 != nil:
    section.add "api-version", valid_574216
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

proc call*(call_574218: Call_MaintenanceConfigurationsCreateOrUpdate_574210;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_574218.validator(path, query, header, formData, body)
  let scheme = call_574218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574218.url(scheme.get, call_574218.host, call_574218.base,
                         call_574218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574218, url, valid)

proc call*(call_574219: Call_MaintenanceConfigurationsCreateOrUpdate_574210;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; configuration: JsonNode): Recallable =
  ## maintenanceConfigurationsCreateOrUpdate
  ##   resourceGroupName: string (required)
  ##                    : Resource Group Name
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : Resource Identifier
  ##   configuration: JObject (required)
  ##                : The configuration
  var path_574220 = newJObject()
  var query_574221 = newJObject()
  var body_574222 = newJObject()
  add(path_574220, "resourceGroupName", newJString(resourceGroupName))
  add(query_574221, "api-version", newJString(apiVersion))
  add(path_574220, "subscriptionId", newJString(subscriptionId))
  add(path_574220, "resourceName", newJString(resourceName))
  if configuration != nil:
    body_574222 = configuration
  result = call_574219.call(path_574220, query_574221, nil, nil, body_574222)

var maintenanceConfigurationsCreateOrUpdate* = Call_MaintenanceConfigurationsCreateOrUpdate_574210(
    name: "maintenanceConfigurationsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Maintenance/maintenanceConfigurations/{resourceName}",
    validator: validate_MaintenanceConfigurationsCreateOrUpdate_574211, base: "",
    url: url_MaintenanceConfigurationsCreateOrUpdate_574212,
    schemes: {Scheme.Https})
type
  Call_MaintenanceConfigurationsGet_574199 = ref object of OpenApiRestCall_573658
proc url_MaintenanceConfigurationsGet_574201(protocol: Scheme; host: string;
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

proc validate_MaintenanceConfigurationsGet_574200(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : Resource Identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574202 = path.getOrDefault("resourceGroupName")
  valid_574202 = validateParameter(valid_574202, JString, required = true,
                                 default = nil)
  if valid_574202 != nil:
    section.add "resourceGroupName", valid_574202
  var valid_574203 = path.getOrDefault("subscriptionId")
  valid_574203 = validateParameter(valid_574203, JString, required = true,
                                 default = nil)
  if valid_574203 != nil:
    section.add "subscriptionId", valid_574203
  var valid_574204 = path.getOrDefault("resourceName")
  valid_574204 = validateParameter(valid_574204, JString, required = true,
                                 default = nil)
  if valid_574204 != nil:
    section.add "resourceName", valid_574204
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574205 = query.getOrDefault("api-version")
  valid_574205 = validateParameter(valid_574205, JString, required = true,
                                 default = nil)
  if valid_574205 != nil:
    section.add "api-version", valid_574205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574206: Call_MaintenanceConfigurationsGet_574199; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574206.validator(path, query, header, formData, body)
  let scheme = call_574206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574206.url(scheme.get, call_574206.host, call_574206.base,
                         call_574206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574206, url, valid)

proc call*(call_574207: Call_MaintenanceConfigurationsGet_574199;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## maintenanceConfigurationsGet
  ##   resourceGroupName: string (required)
  ##                    : Resource Group Name
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : Resource Identifier
  var path_574208 = newJObject()
  var query_574209 = newJObject()
  add(path_574208, "resourceGroupName", newJString(resourceGroupName))
  add(query_574209, "api-version", newJString(apiVersion))
  add(path_574208, "subscriptionId", newJString(subscriptionId))
  add(path_574208, "resourceName", newJString(resourceName))
  result = call_574207.call(path_574208, query_574209, nil, nil, nil)

var maintenanceConfigurationsGet* = Call_MaintenanceConfigurationsGet_574199(
    name: "maintenanceConfigurationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Maintenance/maintenanceConfigurations/{resourceName}",
    validator: validate_MaintenanceConfigurationsGet_574200, base: "",
    url: url_MaintenanceConfigurationsGet_574201, schemes: {Scheme.Https})
type
  Call_MaintenanceConfigurationsUpdate_574234 = ref object of OpenApiRestCall_573658
proc url_MaintenanceConfigurationsUpdate_574236(protocol: Scheme; host: string;
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

proc validate_MaintenanceConfigurationsUpdate_574235(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : Resource Identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574237 = path.getOrDefault("resourceGroupName")
  valid_574237 = validateParameter(valid_574237, JString, required = true,
                                 default = nil)
  if valid_574237 != nil:
    section.add "resourceGroupName", valid_574237
  var valid_574238 = path.getOrDefault("subscriptionId")
  valid_574238 = validateParameter(valid_574238, JString, required = true,
                                 default = nil)
  if valid_574238 != nil:
    section.add "subscriptionId", valid_574238
  var valid_574239 = path.getOrDefault("resourceName")
  valid_574239 = validateParameter(valid_574239, JString, required = true,
                                 default = nil)
  if valid_574239 != nil:
    section.add "resourceName", valid_574239
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574240 = query.getOrDefault("api-version")
  valid_574240 = validateParameter(valid_574240, JString, required = true,
                                 default = nil)
  if valid_574240 != nil:
    section.add "api-version", valid_574240
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

proc call*(call_574242: Call_MaintenanceConfigurationsUpdate_574234;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_574242.validator(path, query, header, formData, body)
  let scheme = call_574242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574242.url(scheme.get, call_574242.host, call_574242.base,
                         call_574242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574242, url, valid)

proc call*(call_574243: Call_MaintenanceConfigurationsUpdate_574234;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; configuration: JsonNode): Recallable =
  ## maintenanceConfigurationsUpdate
  ##   resourceGroupName: string (required)
  ##                    : Resource Group Name
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : Resource Identifier
  ##   configuration: JObject (required)
  ##                : The configuration
  var path_574244 = newJObject()
  var query_574245 = newJObject()
  var body_574246 = newJObject()
  add(path_574244, "resourceGroupName", newJString(resourceGroupName))
  add(query_574245, "api-version", newJString(apiVersion))
  add(path_574244, "subscriptionId", newJString(subscriptionId))
  add(path_574244, "resourceName", newJString(resourceName))
  if configuration != nil:
    body_574246 = configuration
  result = call_574243.call(path_574244, query_574245, nil, nil, body_574246)

var maintenanceConfigurationsUpdate* = Call_MaintenanceConfigurationsUpdate_574234(
    name: "maintenanceConfigurationsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Maintenance/maintenanceConfigurations/{resourceName}",
    validator: validate_MaintenanceConfigurationsUpdate_574235, base: "",
    url: url_MaintenanceConfigurationsUpdate_574236, schemes: {Scheme.Https})
type
  Call_MaintenanceConfigurationsDelete_574223 = ref object of OpenApiRestCall_573658
proc url_MaintenanceConfigurationsDelete_574225(protocol: Scheme; host: string;
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

proc validate_MaintenanceConfigurationsDelete_574224(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource Group Name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : Resource Identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574226 = path.getOrDefault("resourceGroupName")
  valid_574226 = validateParameter(valid_574226, JString, required = true,
                                 default = nil)
  if valid_574226 != nil:
    section.add "resourceGroupName", valid_574226
  var valid_574227 = path.getOrDefault("subscriptionId")
  valid_574227 = validateParameter(valid_574227, JString, required = true,
                                 default = nil)
  if valid_574227 != nil:
    section.add "subscriptionId", valid_574227
  var valid_574228 = path.getOrDefault("resourceName")
  valid_574228 = validateParameter(valid_574228, JString, required = true,
                                 default = nil)
  if valid_574228 != nil:
    section.add "resourceName", valid_574228
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574229 = query.getOrDefault("api-version")
  valid_574229 = validateParameter(valid_574229, JString, required = true,
                                 default = nil)
  if valid_574229 != nil:
    section.add "api-version", valid_574229
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574230: Call_MaintenanceConfigurationsDelete_574223;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_574230.validator(path, query, header, formData, body)
  let scheme = call_574230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574230.url(scheme.get, call_574230.host, call_574230.base,
                         call_574230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574230, url, valid)

proc call*(call_574231: Call_MaintenanceConfigurationsDelete_574223;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## maintenanceConfigurationsDelete
  ##   resourceGroupName: string (required)
  ##                    : Resource Group Name
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : Resource Identifier
  var path_574232 = newJObject()
  var query_574233 = newJObject()
  add(path_574232, "resourceGroupName", newJString(resourceGroupName))
  add(query_574233, "api-version", newJString(apiVersion))
  add(path_574232, "subscriptionId", newJString(subscriptionId))
  add(path_574232, "resourceName", newJString(resourceName))
  result = call_574231.call(path_574232, query_574233, nil, nil, nil)

var maintenanceConfigurationsDelete* = Call_MaintenanceConfigurationsDelete_574223(
    name: "maintenanceConfigurationsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Maintenance/maintenanceConfigurations/{resourceName}",
    validator: validate_MaintenanceConfigurationsDelete_574224, base: "",
    url: url_MaintenanceConfigurationsDelete_574225, schemes: {Scheme.Https})
type
  Call_ApplyUpdatesCreateOrUpdateParent_574247 = ref object of OpenApiRestCall_573658
proc url_ApplyUpdatesCreateOrUpdateParent_574249(protocol: Scheme; host: string;
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

proc validate_ApplyUpdatesCreateOrUpdateParent_574248(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Apply maintenance updates to resource with parent
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : Resource type
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : Resource identifier
  ##   resourceParentName: JString (required)
  ##                     : Resource parent identifier
  ##   providerName: JString (required)
  ##               : Resource provider name
  ##   resourceParentType: JString (required)
  ##                     : Resource parent type
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_574250 = path.getOrDefault("resourceType")
  valid_574250 = validateParameter(valid_574250, JString, required = true,
                                 default = nil)
  if valid_574250 != nil:
    section.add "resourceType", valid_574250
  var valid_574251 = path.getOrDefault("resourceGroupName")
  valid_574251 = validateParameter(valid_574251, JString, required = true,
                                 default = nil)
  if valid_574251 != nil:
    section.add "resourceGroupName", valid_574251
  var valid_574252 = path.getOrDefault("subscriptionId")
  valid_574252 = validateParameter(valid_574252, JString, required = true,
                                 default = nil)
  if valid_574252 != nil:
    section.add "subscriptionId", valid_574252
  var valid_574253 = path.getOrDefault("resourceName")
  valid_574253 = validateParameter(valid_574253, JString, required = true,
                                 default = nil)
  if valid_574253 != nil:
    section.add "resourceName", valid_574253
  var valid_574254 = path.getOrDefault("resourceParentName")
  valid_574254 = validateParameter(valid_574254, JString, required = true,
                                 default = nil)
  if valid_574254 != nil:
    section.add "resourceParentName", valid_574254
  var valid_574255 = path.getOrDefault("providerName")
  valid_574255 = validateParameter(valid_574255, JString, required = true,
                                 default = nil)
  if valid_574255 != nil:
    section.add "providerName", valid_574255
  var valid_574256 = path.getOrDefault("resourceParentType")
  valid_574256 = validateParameter(valid_574256, JString, required = true,
                                 default = nil)
  if valid_574256 != nil:
    section.add "resourceParentType", valid_574256
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574257 = query.getOrDefault("api-version")
  valid_574257 = validateParameter(valid_574257, JString, required = true,
                                 default = nil)
  if valid_574257 != nil:
    section.add "api-version", valid_574257
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574258: Call_ApplyUpdatesCreateOrUpdateParent_574247;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Apply maintenance updates to resource with parent
  ## 
  let valid = call_574258.validator(path, query, header, formData, body)
  let scheme = call_574258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574258.url(scheme.get, call_574258.host, call_574258.base,
                         call_574258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574258, url, valid)

proc call*(call_574259: Call_ApplyUpdatesCreateOrUpdateParent_574247;
          resourceType: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string; resourceParentName: string;
          providerName: string; resourceParentType: string): Recallable =
  ## applyUpdatesCreateOrUpdateParent
  ## Apply maintenance updates to resource with parent
  ##   resourceType: string (required)
  ##               : Resource type
  ##   resourceGroupName: string (required)
  ##                    : Resource group name
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : Resource identifier
  ##   resourceParentName: string (required)
  ##                     : Resource parent identifier
  ##   providerName: string (required)
  ##               : Resource provider name
  ##   resourceParentType: string (required)
  ##                     : Resource parent type
  var path_574260 = newJObject()
  var query_574261 = newJObject()
  add(path_574260, "resourceType", newJString(resourceType))
  add(path_574260, "resourceGroupName", newJString(resourceGroupName))
  add(query_574261, "api-version", newJString(apiVersion))
  add(path_574260, "subscriptionId", newJString(subscriptionId))
  add(path_574260, "resourceName", newJString(resourceName))
  add(path_574260, "resourceParentName", newJString(resourceParentName))
  add(path_574260, "providerName", newJString(providerName))
  add(path_574260, "resourceParentType", newJString(resourceParentType))
  result = call_574259.call(path_574260, query_574261, nil, nil, nil)

var applyUpdatesCreateOrUpdateParent* = Call_ApplyUpdatesCreateOrUpdateParent_574247(
    name: "applyUpdatesCreateOrUpdateParent", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{providerName}/{resourceParentType}/{resourceParentName}/{resourceType}/{resourceName}/providers/Microsoft.Maintenance/applyUpdates/default",
    validator: validate_ApplyUpdatesCreateOrUpdateParent_574248, base: "",
    url: url_ApplyUpdatesCreateOrUpdateParent_574249, schemes: {Scheme.Https})
type
  Call_ApplyUpdatesGetParent_574262 = ref object of OpenApiRestCall_573658
proc url_ApplyUpdatesGetParent_574264(protocol: Scheme; host: string; base: string;
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

proc validate_ApplyUpdatesGetParent_574263(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Track maintenance updates to resource with parent
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : Resource type
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : Resource identifier
  ##   resourceParentName: JString (required)
  ##                     : Resource parent identifier
  ##   providerName: JString (required)
  ##               : Resource provider name
  ##   resourceParentType: JString (required)
  ##                     : Resource parent type
  ##   applyUpdateName: JString (required)
  ##                  : applyUpdate Id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_574265 = path.getOrDefault("resourceType")
  valid_574265 = validateParameter(valid_574265, JString, required = true,
                                 default = nil)
  if valid_574265 != nil:
    section.add "resourceType", valid_574265
  var valid_574266 = path.getOrDefault("resourceGroupName")
  valid_574266 = validateParameter(valid_574266, JString, required = true,
                                 default = nil)
  if valid_574266 != nil:
    section.add "resourceGroupName", valid_574266
  var valid_574267 = path.getOrDefault("subscriptionId")
  valid_574267 = validateParameter(valid_574267, JString, required = true,
                                 default = nil)
  if valid_574267 != nil:
    section.add "subscriptionId", valid_574267
  var valid_574268 = path.getOrDefault("resourceName")
  valid_574268 = validateParameter(valid_574268, JString, required = true,
                                 default = nil)
  if valid_574268 != nil:
    section.add "resourceName", valid_574268
  var valid_574269 = path.getOrDefault("resourceParentName")
  valid_574269 = validateParameter(valid_574269, JString, required = true,
                                 default = nil)
  if valid_574269 != nil:
    section.add "resourceParentName", valid_574269
  var valid_574270 = path.getOrDefault("providerName")
  valid_574270 = validateParameter(valid_574270, JString, required = true,
                                 default = nil)
  if valid_574270 != nil:
    section.add "providerName", valid_574270
  var valid_574271 = path.getOrDefault("resourceParentType")
  valid_574271 = validateParameter(valid_574271, JString, required = true,
                                 default = nil)
  if valid_574271 != nil:
    section.add "resourceParentType", valid_574271
  var valid_574272 = path.getOrDefault("applyUpdateName")
  valid_574272 = validateParameter(valid_574272, JString, required = true,
                                 default = nil)
  if valid_574272 != nil:
    section.add "applyUpdateName", valid_574272
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574273 = query.getOrDefault("api-version")
  valid_574273 = validateParameter(valid_574273, JString, required = true,
                                 default = nil)
  if valid_574273 != nil:
    section.add "api-version", valid_574273
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574274: Call_ApplyUpdatesGetParent_574262; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Track maintenance updates to resource with parent
  ## 
  let valid = call_574274.validator(path, query, header, formData, body)
  let scheme = call_574274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574274.url(scheme.get, call_574274.host, call_574274.base,
                         call_574274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574274, url, valid)

proc call*(call_574275: Call_ApplyUpdatesGetParent_574262; resourceType: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; resourceParentName: string; providerName: string;
          resourceParentType: string; applyUpdateName: string): Recallable =
  ## applyUpdatesGetParent
  ## Track maintenance updates to resource with parent
  ##   resourceType: string (required)
  ##               : Resource type
  ##   resourceGroupName: string (required)
  ##                    : Resource group name
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : Resource identifier
  ##   resourceParentName: string (required)
  ##                     : Resource parent identifier
  ##   providerName: string (required)
  ##               : Resource provider name
  ##   resourceParentType: string (required)
  ##                     : Resource parent type
  ##   applyUpdateName: string (required)
  ##                  : applyUpdate Id
  var path_574276 = newJObject()
  var query_574277 = newJObject()
  add(path_574276, "resourceType", newJString(resourceType))
  add(path_574276, "resourceGroupName", newJString(resourceGroupName))
  add(query_574277, "api-version", newJString(apiVersion))
  add(path_574276, "subscriptionId", newJString(subscriptionId))
  add(path_574276, "resourceName", newJString(resourceName))
  add(path_574276, "resourceParentName", newJString(resourceParentName))
  add(path_574276, "providerName", newJString(providerName))
  add(path_574276, "resourceParentType", newJString(resourceParentType))
  add(path_574276, "applyUpdateName", newJString(applyUpdateName))
  result = call_574275.call(path_574276, query_574277, nil, nil, nil)

var applyUpdatesGetParent* = Call_ApplyUpdatesGetParent_574262(
    name: "applyUpdatesGetParent", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{providerName}/{resourceParentType}/{resourceParentName}/{resourceType}/{resourceName}/providers/Microsoft.Maintenance/applyUpdates/{applyUpdateName}",
    validator: validate_ApplyUpdatesGetParent_574263, base: "",
    url: url_ApplyUpdatesGetParent_574264, schemes: {Scheme.Https})
type
  Call_ConfigurationAssignmentsListParent_574278 = ref object of OpenApiRestCall_573658
proc url_ConfigurationAssignmentsListParent_574280(protocol: Scheme; host: string;
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

proc validate_ConfigurationAssignmentsListParent_574279(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List configurationAssignments for resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : Resource type
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : Resource identifier
  ##   resourceParentName: JString (required)
  ##                     : Resource parent identifier
  ##   providerName: JString (required)
  ##               : Resource provider name
  ##   resourceParentType: JString (required)
  ##                     : Resource parent type
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_574281 = path.getOrDefault("resourceType")
  valid_574281 = validateParameter(valid_574281, JString, required = true,
                                 default = nil)
  if valid_574281 != nil:
    section.add "resourceType", valid_574281
  var valid_574282 = path.getOrDefault("resourceGroupName")
  valid_574282 = validateParameter(valid_574282, JString, required = true,
                                 default = nil)
  if valid_574282 != nil:
    section.add "resourceGroupName", valid_574282
  var valid_574283 = path.getOrDefault("subscriptionId")
  valid_574283 = validateParameter(valid_574283, JString, required = true,
                                 default = nil)
  if valid_574283 != nil:
    section.add "subscriptionId", valid_574283
  var valid_574284 = path.getOrDefault("resourceName")
  valid_574284 = validateParameter(valid_574284, JString, required = true,
                                 default = nil)
  if valid_574284 != nil:
    section.add "resourceName", valid_574284
  var valid_574285 = path.getOrDefault("resourceParentName")
  valid_574285 = validateParameter(valid_574285, JString, required = true,
                                 default = nil)
  if valid_574285 != nil:
    section.add "resourceParentName", valid_574285
  var valid_574286 = path.getOrDefault("providerName")
  valid_574286 = validateParameter(valid_574286, JString, required = true,
                                 default = nil)
  if valid_574286 != nil:
    section.add "providerName", valid_574286
  var valid_574287 = path.getOrDefault("resourceParentType")
  valid_574287 = validateParameter(valid_574287, JString, required = true,
                                 default = nil)
  if valid_574287 != nil:
    section.add "resourceParentType", valid_574287
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
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
  if body != nil:
    result.add "body", body

proc call*(call_574289: Call_ConfigurationAssignmentsListParent_574278;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List configurationAssignments for resource.
  ## 
  let valid = call_574289.validator(path, query, header, formData, body)
  let scheme = call_574289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574289.url(scheme.get, call_574289.host, call_574289.base,
                         call_574289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574289, url, valid)

proc call*(call_574290: Call_ConfigurationAssignmentsListParent_574278;
          resourceType: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string; resourceParentName: string;
          providerName: string; resourceParentType: string): Recallable =
  ## configurationAssignmentsListParent
  ## List configurationAssignments for resource.
  ##   resourceType: string (required)
  ##               : Resource type
  ##   resourceGroupName: string (required)
  ##                    : Resource group name
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : Resource identifier
  ##   resourceParentName: string (required)
  ##                     : Resource parent identifier
  ##   providerName: string (required)
  ##               : Resource provider name
  ##   resourceParentType: string (required)
  ##                     : Resource parent type
  var path_574291 = newJObject()
  var query_574292 = newJObject()
  add(path_574291, "resourceType", newJString(resourceType))
  add(path_574291, "resourceGroupName", newJString(resourceGroupName))
  add(query_574292, "api-version", newJString(apiVersion))
  add(path_574291, "subscriptionId", newJString(subscriptionId))
  add(path_574291, "resourceName", newJString(resourceName))
  add(path_574291, "resourceParentName", newJString(resourceParentName))
  add(path_574291, "providerName", newJString(providerName))
  add(path_574291, "resourceParentType", newJString(resourceParentType))
  result = call_574290.call(path_574291, query_574292, nil, nil, nil)

var configurationAssignmentsListParent* = Call_ConfigurationAssignmentsListParent_574278(
    name: "configurationAssignmentsListParent", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{providerName}/{resourceParentType}/{resourceParentName}/{resourceType}/{resourceName}/providers/Microsoft.Maintenance/configurationAssignments",
    validator: validate_ConfigurationAssignmentsListParent_574279, base: "",
    url: url_ConfigurationAssignmentsListParent_574280, schemes: {Scheme.Https})
type
  Call_ConfigurationAssignmentsCreateOrUpdateParent_574293 = ref object of OpenApiRestCall_573658
proc url_ConfigurationAssignmentsCreateOrUpdateParent_574295(protocol: Scheme;
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

proc validate_ConfigurationAssignmentsCreateOrUpdateParent_574294(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Register configuration for resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : Resource type
  ##   configurationAssignmentName: JString (required)
  ##                              : Configuration assignment name
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : Resource identifier
  ##   resourceParentName: JString (required)
  ##                     : Resource parent identifier
  ##   providerName: JString (required)
  ##               : Resource provider name
  ##   resourceParentType: JString (required)
  ##                     : Resource parent type
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_574296 = path.getOrDefault("resourceType")
  valid_574296 = validateParameter(valid_574296, JString, required = true,
                                 default = nil)
  if valid_574296 != nil:
    section.add "resourceType", valid_574296
  var valid_574297 = path.getOrDefault("configurationAssignmentName")
  valid_574297 = validateParameter(valid_574297, JString, required = true,
                                 default = nil)
  if valid_574297 != nil:
    section.add "configurationAssignmentName", valid_574297
  var valid_574298 = path.getOrDefault("resourceGroupName")
  valid_574298 = validateParameter(valid_574298, JString, required = true,
                                 default = nil)
  if valid_574298 != nil:
    section.add "resourceGroupName", valid_574298
  var valid_574299 = path.getOrDefault("subscriptionId")
  valid_574299 = validateParameter(valid_574299, JString, required = true,
                                 default = nil)
  if valid_574299 != nil:
    section.add "subscriptionId", valid_574299
  var valid_574300 = path.getOrDefault("resourceName")
  valid_574300 = validateParameter(valid_574300, JString, required = true,
                                 default = nil)
  if valid_574300 != nil:
    section.add "resourceName", valid_574300
  var valid_574301 = path.getOrDefault("resourceParentName")
  valid_574301 = validateParameter(valid_574301, JString, required = true,
                                 default = nil)
  if valid_574301 != nil:
    section.add "resourceParentName", valid_574301
  var valid_574302 = path.getOrDefault("providerName")
  valid_574302 = validateParameter(valid_574302, JString, required = true,
                                 default = nil)
  if valid_574302 != nil:
    section.add "providerName", valid_574302
  var valid_574303 = path.getOrDefault("resourceParentType")
  valid_574303 = validateParameter(valid_574303, JString, required = true,
                                 default = nil)
  if valid_574303 != nil:
    section.add "resourceParentType", valid_574303
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574304 = query.getOrDefault("api-version")
  valid_574304 = validateParameter(valid_574304, JString, required = true,
                                 default = nil)
  if valid_574304 != nil:
    section.add "api-version", valid_574304
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

proc call*(call_574306: Call_ConfigurationAssignmentsCreateOrUpdateParent_574293;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Register configuration for resource.
  ## 
  let valid = call_574306.validator(path, query, header, formData, body)
  let scheme = call_574306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574306.url(scheme.get, call_574306.host, call_574306.base,
                         call_574306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574306, url, valid)

proc call*(call_574307: Call_ConfigurationAssignmentsCreateOrUpdateParent_574293;
          resourceType: string; configurationAssignmentName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; resourceParentName: string; providerName: string;
          resourceParentType: string; configurationAssignment: JsonNode): Recallable =
  ## configurationAssignmentsCreateOrUpdateParent
  ## Register configuration for resource.
  ##   resourceType: string (required)
  ##               : Resource type
  ##   configurationAssignmentName: string (required)
  ##                              : Configuration assignment name
  ##   resourceGroupName: string (required)
  ##                    : Resource group name
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : Resource identifier
  ##   resourceParentName: string (required)
  ##                     : Resource parent identifier
  ##   providerName: string (required)
  ##               : Resource provider name
  ##   resourceParentType: string (required)
  ##                     : Resource parent type
  ##   configurationAssignment: JObject (required)
  ##                          : The configurationAssignment
  var path_574308 = newJObject()
  var query_574309 = newJObject()
  var body_574310 = newJObject()
  add(path_574308, "resourceType", newJString(resourceType))
  add(path_574308, "configurationAssignmentName",
      newJString(configurationAssignmentName))
  add(path_574308, "resourceGroupName", newJString(resourceGroupName))
  add(query_574309, "api-version", newJString(apiVersion))
  add(path_574308, "subscriptionId", newJString(subscriptionId))
  add(path_574308, "resourceName", newJString(resourceName))
  add(path_574308, "resourceParentName", newJString(resourceParentName))
  add(path_574308, "providerName", newJString(providerName))
  add(path_574308, "resourceParentType", newJString(resourceParentType))
  if configurationAssignment != nil:
    body_574310 = configurationAssignment
  result = call_574307.call(path_574308, query_574309, nil, nil, body_574310)

var configurationAssignmentsCreateOrUpdateParent* = Call_ConfigurationAssignmentsCreateOrUpdateParent_574293(
    name: "configurationAssignmentsCreateOrUpdateParent",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{providerName}/{resourceParentType}/{resourceParentName}/{resourceType}/{resourceName}/providers/Microsoft.Maintenance/configurationAssignments/{configurationAssignmentName}",
    validator: validate_ConfigurationAssignmentsCreateOrUpdateParent_574294,
    base: "", url: url_ConfigurationAssignmentsCreateOrUpdateParent_574295,
    schemes: {Scheme.Https})
type
  Call_ConfigurationAssignmentsDeleteParent_574311 = ref object of OpenApiRestCall_573658
proc url_ConfigurationAssignmentsDeleteParent_574313(protocol: Scheme;
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

proc validate_ConfigurationAssignmentsDeleteParent_574312(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Unregister configuration for resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : Resource type
  ##   configurationAssignmentName: JString (required)
  ##                              : Unique configuration assignment name
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : Resource identifier
  ##   resourceParentName: JString (required)
  ##                     : Resource parent identifier
  ##   providerName: JString (required)
  ##               : Resource provider name
  ##   resourceParentType: JString (required)
  ##                     : Resource parent type
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_574314 = path.getOrDefault("resourceType")
  valid_574314 = validateParameter(valid_574314, JString, required = true,
                                 default = nil)
  if valid_574314 != nil:
    section.add "resourceType", valid_574314
  var valid_574315 = path.getOrDefault("configurationAssignmentName")
  valid_574315 = validateParameter(valid_574315, JString, required = true,
                                 default = nil)
  if valid_574315 != nil:
    section.add "configurationAssignmentName", valid_574315
  var valid_574316 = path.getOrDefault("resourceGroupName")
  valid_574316 = validateParameter(valid_574316, JString, required = true,
                                 default = nil)
  if valid_574316 != nil:
    section.add "resourceGroupName", valid_574316
  var valid_574317 = path.getOrDefault("subscriptionId")
  valid_574317 = validateParameter(valid_574317, JString, required = true,
                                 default = nil)
  if valid_574317 != nil:
    section.add "subscriptionId", valid_574317
  var valid_574318 = path.getOrDefault("resourceName")
  valid_574318 = validateParameter(valid_574318, JString, required = true,
                                 default = nil)
  if valid_574318 != nil:
    section.add "resourceName", valid_574318
  var valid_574319 = path.getOrDefault("resourceParentName")
  valid_574319 = validateParameter(valid_574319, JString, required = true,
                                 default = nil)
  if valid_574319 != nil:
    section.add "resourceParentName", valid_574319
  var valid_574320 = path.getOrDefault("providerName")
  valid_574320 = validateParameter(valid_574320, JString, required = true,
                                 default = nil)
  if valid_574320 != nil:
    section.add "providerName", valid_574320
  var valid_574321 = path.getOrDefault("resourceParentType")
  valid_574321 = validateParameter(valid_574321, JString, required = true,
                                 default = nil)
  if valid_574321 != nil:
    section.add "resourceParentType", valid_574321
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574322 = query.getOrDefault("api-version")
  valid_574322 = validateParameter(valid_574322, JString, required = true,
                                 default = nil)
  if valid_574322 != nil:
    section.add "api-version", valid_574322
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574323: Call_ConfigurationAssignmentsDeleteParent_574311;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Unregister configuration for resource.
  ## 
  let valid = call_574323.validator(path, query, header, formData, body)
  let scheme = call_574323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574323.url(scheme.get, call_574323.host, call_574323.base,
                         call_574323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574323, url, valid)

proc call*(call_574324: Call_ConfigurationAssignmentsDeleteParent_574311;
          resourceType: string; configurationAssignmentName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; resourceParentName: string; providerName: string;
          resourceParentType: string): Recallable =
  ## configurationAssignmentsDeleteParent
  ## Unregister configuration for resource.
  ##   resourceType: string (required)
  ##               : Resource type
  ##   configurationAssignmentName: string (required)
  ##                              : Unique configuration assignment name
  ##   resourceGroupName: string (required)
  ##                    : Resource group name
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : Resource identifier
  ##   resourceParentName: string (required)
  ##                     : Resource parent identifier
  ##   providerName: string (required)
  ##               : Resource provider name
  ##   resourceParentType: string (required)
  ##                     : Resource parent type
  var path_574325 = newJObject()
  var query_574326 = newJObject()
  add(path_574325, "resourceType", newJString(resourceType))
  add(path_574325, "configurationAssignmentName",
      newJString(configurationAssignmentName))
  add(path_574325, "resourceGroupName", newJString(resourceGroupName))
  add(query_574326, "api-version", newJString(apiVersion))
  add(path_574325, "subscriptionId", newJString(subscriptionId))
  add(path_574325, "resourceName", newJString(resourceName))
  add(path_574325, "resourceParentName", newJString(resourceParentName))
  add(path_574325, "providerName", newJString(providerName))
  add(path_574325, "resourceParentType", newJString(resourceParentType))
  result = call_574324.call(path_574325, query_574326, nil, nil, nil)

var configurationAssignmentsDeleteParent* = Call_ConfigurationAssignmentsDeleteParent_574311(
    name: "configurationAssignmentsDeleteParent", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{providerName}/{resourceParentType}/{resourceParentName}/{resourceType}/{resourceName}/providers/Microsoft.Maintenance/configurationAssignments/{configurationAssignmentName}",
    validator: validate_ConfigurationAssignmentsDeleteParent_574312, base: "",
    url: url_ConfigurationAssignmentsDeleteParent_574313, schemes: {Scheme.Https})
type
  Call_UpdatesListParent_574327 = ref object of OpenApiRestCall_573658
proc url_UpdatesListParent_574329(protocol: Scheme; host: string; base: string;
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

proc validate_UpdatesListParent_574328(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get updates to resources.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : Resource type
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : Resource identifier
  ##   resourceParentName: JString (required)
  ##                     : Resource parent identifier
  ##   providerName: JString (required)
  ##               : Resource provider name
  ##   resourceParentType: JString (required)
  ##                     : Resource parent type
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_574330 = path.getOrDefault("resourceType")
  valid_574330 = validateParameter(valid_574330, JString, required = true,
                                 default = nil)
  if valid_574330 != nil:
    section.add "resourceType", valid_574330
  var valid_574331 = path.getOrDefault("resourceGroupName")
  valid_574331 = validateParameter(valid_574331, JString, required = true,
                                 default = nil)
  if valid_574331 != nil:
    section.add "resourceGroupName", valid_574331
  var valid_574332 = path.getOrDefault("subscriptionId")
  valid_574332 = validateParameter(valid_574332, JString, required = true,
                                 default = nil)
  if valid_574332 != nil:
    section.add "subscriptionId", valid_574332
  var valid_574333 = path.getOrDefault("resourceName")
  valid_574333 = validateParameter(valid_574333, JString, required = true,
                                 default = nil)
  if valid_574333 != nil:
    section.add "resourceName", valid_574333
  var valid_574334 = path.getOrDefault("resourceParentName")
  valid_574334 = validateParameter(valid_574334, JString, required = true,
                                 default = nil)
  if valid_574334 != nil:
    section.add "resourceParentName", valid_574334
  var valid_574335 = path.getOrDefault("providerName")
  valid_574335 = validateParameter(valid_574335, JString, required = true,
                                 default = nil)
  if valid_574335 != nil:
    section.add "providerName", valid_574335
  var valid_574336 = path.getOrDefault("resourceParentType")
  valid_574336 = validateParameter(valid_574336, JString, required = true,
                                 default = nil)
  if valid_574336 != nil:
    section.add "resourceParentType", valid_574336
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574337 = query.getOrDefault("api-version")
  valid_574337 = validateParameter(valid_574337, JString, required = true,
                                 default = nil)
  if valid_574337 != nil:
    section.add "api-version", valid_574337
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574338: Call_UpdatesListParent_574327; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get updates to resources.
  ## 
  let valid = call_574338.validator(path, query, header, formData, body)
  let scheme = call_574338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574338.url(scheme.get, call_574338.host, call_574338.base,
                         call_574338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574338, url, valid)

proc call*(call_574339: Call_UpdatesListParent_574327; resourceType: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; resourceParentName: string; providerName: string;
          resourceParentType: string): Recallable =
  ## updatesListParent
  ## Get updates to resources.
  ##   resourceType: string (required)
  ##               : Resource type
  ##   resourceGroupName: string (required)
  ##                    : Resource group name
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : Resource identifier
  ##   resourceParentName: string (required)
  ##                     : Resource parent identifier
  ##   providerName: string (required)
  ##               : Resource provider name
  ##   resourceParentType: string (required)
  ##                     : Resource parent type
  var path_574340 = newJObject()
  var query_574341 = newJObject()
  add(path_574340, "resourceType", newJString(resourceType))
  add(path_574340, "resourceGroupName", newJString(resourceGroupName))
  add(query_574341, "api-version", newJString(apiVersion))
  add(path_574340, "subscriptionId", newJString(subscriptionId))
  add(path_574340, "resourceName", newJString(resourceName))
  add(path_574340, "resourceParentName", newJString(resourceParentName))
  add(path_574340, "providerName", newJString(providerName))
  add(path_574340, "resourceParentType", newJString(resourceParentType))
  result = call_574339.call(path_574340, query_574341, nil, nil, nil)

var updatesListParent* = Call_UpdatesListParent_574327(name: "updatesListParent",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{providerName}/{resourceParentType}/{resourceParentName}/{resourceType}/{resourceName}/providers/Microsoft.Maintenance/updates",
    validator: validate_UpdatesListParent_574328, base: "",
    url: url_UpdatesListParent_574329, schemes: {Scheme.Https})
type
  Call_ApplyUpdatesCreateOrUpdate_574342 = ref object of OpenApiRestCall_573658
proc url_ApplyUpdatesCreateOrUpdate_574344(protocol: Scheme; host: string;
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

proc validate_ApplyUpdatesCreateOrUpdate_574343(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Apply maintenance updates to resource
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : Resource type
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : Resource identifier
  ##   providerName: JString (required)
  ##               : Resource provider name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_574345 = path.getOrDefault("resourceType")
  valid_574345 = validateParameter(valid_574345, JString, required = true,
                                 default = nil)
  if valid_574345 != nil:
    section.add "resourceType", valid_574345
  var valid_574346 = path.getOrDefault("resourceGroupName")
  valid_574346 = validateParameter(valid_574346, JString, required = true,
                                 default = nil)
  if valid_574346 != nil:
    section.add "resourceGroupName", valid_574346
  var valid_574347 = path.getOrDefault("subscriptionId")
  valid_574347 = validateParameter(valid_574347, JString, required = true,
                                 default = nil)
  if valid_574347 != nil:
    section.add "subscriptionId", valid_574347
  var valid_574348 = path.getOrDefault("resourceName")
  valid_574348 = validateParameter(valid_574348, JString, required = true,
                                 default = nil)
  if valid_574348 != nil:
    section.add "resourceName", valid_574348
  var valid_574349 = path.getOrDefault("providerName")
  valid_574349 = validateParameter(valid_574349, JString, required = true,
                                 default = nil)
  if valid_574349 != nil:
    section.add "providerName", valid_574349
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
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

proc call*(call_574351: Call_ApplyUpdatesCreateOrUpdate_574342; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Apply maintenance updates to resource
  ## 
  let valid = call_574351.validator(path, query, header, formData, body)
  let scheme = call_574351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574351.url(scheme.get, call_574351.host, call_574351.base,
                         call_574351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574351, url, valid)

proc call*(call_574352: Call_ApplyUpdatesCreateOrUpdate_574342;
          resourceType: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string; providerName: string): Recallable =
  ## applyUpdatesCreateOrUpdate
  ## Apply maintenance updates to resource
  ##   resourceType: string (required)
  ##               : Resource type
  ##   resourceGroupName: string (required)
  ##                    : Resource group name
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : Resource identifier
  ##   providerName: string (required)
  ##               : Resource provider name
  var path_574353 = newJObject()
  var query_574354 = newJObject()
  add(path_574353, "resourceType", newJString(resourceType))
  add(path_574353, "resourceGroupName", newJString(resourceGroupName))
  add(query_574354, "api-version", newJString(apiVersion))
  add(path_574353, "subscriptionId", newJString(subscriptionId))
  add(path_574353, "resourceName", newJString(resourceName))
  add(path_574353, "providerName", newJString(providerName))
  result = call_574352.call(path_574353, query_574354, nil, nil, nil)

var applyUpdatesCreateOrUpdate* = Call_ApplyUpdatesCreateOrUpdate_574342(
    name: "applyUpdatesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{providerName}/{resourceType}/{resourceName}/providers/Microsoft.Maintenance/applyUpdates/default",
    validator: validate_ApplyUpdatesCreateOrUpdate_574343, base: "",
    url: url_ApplyUpdatesCreateOrUpdate_574344, schemes: {Scheme.Https})
type
  Call_ApplyUpdatesGet_574355 = ref object of OpenApiRestCall_573658
proc url_ApplyUpdatesGet_574357(protocol: Scheme; host: string; base: string;
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

proc validate_ApplyUpdatesGet_574356(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Track maintenance updates to resource
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : Resource type
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : Resource identifier
  ##   providerName: JString (required)
  ##               : Resource provider name
  ##   applyUpdateName: JString (required)
  ##                  : applyUpdate Id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_574358 = path.getOrDefault("resourceType")
  valid_574358 = validateParameter(valid_574358, JString, required = true,
                                 default = nil)
  if valid_574358 != nil:
    section.add "resourceType", valid_574358
  var valid_574359 = path.getOrDefault("resourceGroupName")
  valid_574359 = validateParameter(valid_574359, JString, required = true,
                                 default = nil)
  if valid_574359 != nil:
    section.add "resourceGroupName", valid_574359
  var valid_574360 = path.getOrDefault("subscriptionId")
  valid_574360 = validateParameter(valid_574360, JString, required = true,
                                 default = nil)
  if valid_574360 != nil:
    section.add "subscriptionId", valid_574360
  var valid_574361 = path.getOrDefault("resourceName")
  valid_574361 = validateParameter(valid_574361, JString, required = true,
                                 default = nil)
  if valid_574361 != nil:
    section.add "resourceName", valid_574361
  var valid_574362 = path.getOrDefault("providerName")
  valid_574362 = validateParameter(valid_574362, JString, required = true,
                                 default = nil)
  if valid_574362 != nil:
    section.add "providerName", valid_574362
  var valid_574363 = path.getOrDefault("applyUpdateName")
  valid_574363 = validateParameter(valid_574363, JString, required = true,
                                 default = nil)
  if valid_574363 != nil:
    section.add "applyUpdateName", valid_574363
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574364 = query.getOrDefault("api-version")
  valid_574364 = validateParameter(valid_574364, JString, required = true,
                                 default = nil)
  if valid_574364 != nil:
    section.add "api-version", valid_574364
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574365: Call_ApplyUpdatesGet_574355; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Track maintenance updates to resource
  ## 
  let valid = call_574365.validator(path, query, header, formData, body)
  let scheme = call_574365.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574365.url(scheme.get, call_574365.host, call_574365.base,
                         call_574365.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574365, url, valid)

proc call*(call_574366: Call_ApplyUpdatesGet_574355; resourceType: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; providerName: string; applyUpdateName: string): Recallable =
  ## applyUpdatesGet
  ## Track maintenance updates to resource
  ##   resourceType: string (required)
  ##               : Resource type
  ##   resourceGroupName: string (required)
  ##                    : Resource group name
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : Resource identifier
  ##   providerName: string (required)
  ##               : Resource provider name
  ##   applyUpdateName: string (required)
  ##                  : applyUpdate Id
  var path_574367 = newJObject()
  var query_574368 = newJObject()
  add(path_574367, "resourceType", newJString(resourceType))
  add(path_574367, "resourceGroupName", newJString(resourceGroupName))
  add(query_574368, "api-version", newJString(apiVersion))
  add(path_574367, "subscriptionId", newJString(subscriptionId))
  add(path_574367, "resourceName", newJString(resourceName))
  add(path_574367, "providerName", newJString(providerName))
  add(path_574367, "applyUpdateName", newJString(applyUpdateName))
  result = call_574366.call(path_574367, query_574368, nil, nil, nil)

var applyUpdatesGet* = Call_ApplyUpdatesGet_574355(name: "applyUpdatesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{providerName}/{resourceType}/{resourceName}/providers/Microsoft.Maintenance/applyUpdates/{applyUpdateName}",
    validator: validate_ApplyUpdatesGet_574356, base: "", url: url_ApplyUpdatesGet_574357,
    schemes: {Scheme.Https})
type
  Call_ConfigurationAssignmentsList_574369 = ref object of OpenApiRestCall_573658
proc url_ConfigurationAssignmentsList_574371(protocol: Scheme; host: string;
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

proc validate_ConfigurationAssignmentsList_574370(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List configurationAssignments for resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : Resource type
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : Resource identifier
  ##   providerName: JString (required)
  ##               : Resource provider name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_574372 = path.getOrDefault("resourceType")
  valid_574372 = validateParameter(valid_574372, JString, required = true,
                                 default = nil)
  if valid_574372 != nil:
    section.add "resourceType", valid_574372
  var valid_574373 = path.getOrDefault("resourceGroupName")
  valid_574373 = validateParameter(valid_574373, JString, required = true,
                                 default = nil)
  if valid_574373 != nil:
    section.add "resourceGroupName", valid_574373
  var valid_574374 = path.getOrDefault("subscriptionId")
  valid_574374 = validateParameter(valid_574374, JString, required = true,
                                 default = nil)
  if valid_574374 != nil:
    section.add "subscriptionId", valid_574374
  var valid_574375 = path.getOrDefault("resourceName")
  valid_574375 = validateParameter(valid_574375, JString, required = true,
                                 default = nil)
  if valid_574375 != nil:
    section.add "resourceName", valid_574375
  var valid_574376 = path.getOrDefault("providerName")
  valid_574376 = validateParameter(valid_574376, JString, required = true,
                                 default = nil)
  if valid_574376 != nil:
    section.add "providerName", valid_574376
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574377 = query.getOrDefault("api-version")
  valid_574377 = validateParameter(valid_574377, JString, required = true,
                                 default = nil)
  if valid_574377 != nil:
    section.add "api-version", valid_574377
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574378: Call_ConfigurationAssignmentsList_574369; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List configurationAssignments for resource.
  ## 
  let valid = call_574378.validator(path, query, header, formData, body)
  let scheme = call_574378.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574378.url(scheme.get, call_574378.host, call_574378.base,
                         call_574378.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574378, url, valid)

proc call*(call_574379: Call_ConfigurationAssignmentsList_574369;
          resourceType: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string; providerName: string): Recallable =
  ## configurationAssignmentsList
  ## List configurationAssignments for resource.
  ##   resourceType: string (required)
  ##               : Resource type
  ##   resourceGroupName: string (required)
  ##                    : Resource group name
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : Resource identifier
  ##   providerName: string (required)
  ##               : Resource provider name
  var path_574380 = newJObject()
  var query_574381 = newJObject()
  add(path_574380, "resourceType", newJString(resourceType))
  add(path_574380, "resourceGroupName", newJString(resourceGroupName))
  add(query_574381, "api-version", newJString(apiVersion))
  add(path_574380, "subscriptionId", newJString(subscriptionId))
  add(path_574380, "resourceName", newJString(resourceName))
  add(path_574380, "providerName", newJString(providerName))
  result = call_574379.call(path_574380, query_574381, nil, nil, nil)

var configurationAssignmentsList* = Call_ConfigurationAssignmentsList_574369(
    name: "configurationAssignmentsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{providerName}/{resourceType}/{resourceName}/providers/Microsoft.Maintenance/configurationAssignments",
    validator: validate_ConfigurationAssignmentsList_574370, base: "",
    url: url_ConfigurationAssignmentsList_574371, schemes: {Scheme.Https})
type
  Call_ConfigurationAssignmentsCreateOrUpdate_574382 = ref object of OpenApiRestCall_573658
proc url_ConfigurationAssignmentsCreateOrUpdate_574384(protocol: Scheme;
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

proc validate_ConfigurationAssignmentsCreateOrUpdate_574383(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Register configuration for resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : Resource type
  ##   configurationAssignmentName: JString (required)
  ##                              : Configuration assignment name
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : Resource identifier
  ##   providerName: JString (required)
  ##               : Resource provider name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_574385 = path.getOrDefault("resourceType")
  valid_574385 = validateParameter(valid_574385, JString, required = true,
                                 default = nil)
  if valid_574385 != nil:
    section.add "resourceType", valid_574385
  var valid_574386 = path.getOrDefault("configurationAssignmentName")
  valid_574386 = validateParameter(valid_574386, JString, required = true,
                                 default = nil)
  if valid_574386 != nil:
    section.add "configurationAssignmentName", valid_574386
  var valid_574387 = path.getOrDefault("resourceGroupName")
  valid_574387 = validateParameter(valid_574387, JString, required = true,
                                 default = nil)
  if valid_574387 != nil:
    section.add "resourceGroupName", valid_574387
  var valid_574388 = path.getOrDefault("subscriptionId")
  valid_574388 = validateParameter(valid_574388, JString, required = true,
                                 default = nil)
  if valid_574388 != nil:
    section.add "subscriptionId", valid_574388
  var valid_574389 = path.getOrDefault("resourceName")
  valid_574389 = validateParameter(valid_574389, JString, required = true,
                                 default = nil)
  if valid_574389 != nil:
    section.add "resourceName", valid_574389
  var valid_574390 = path.getOrDefault("providerName")
  valid_574390 = validateParameter(valid_574390, JString, required = true,
                                 default = nil)
  if valid_574390 != nil:
    section.add "providerName", valid_574390
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574391 = query.getOrDefault("api-version")
  valid_574391 = validateParameter(valid_574391, JString, required = true,
                                 default = nil)
  if valid_574391 != nil:
    section.add "api-version", valid_574391
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

proc call*(call_574393: Call_ConfigurationAssignmentsCreateOrUpdate_574382;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Register configuration for resource.
  ## 
  let valid = call_574393.validator(path, query, header, formData, body)
  let scheme = call_574393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574393.url(scheme.get, call_574393.host, call_574393.base,
                         call_574393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574393, url, valid)

proc call*(call_574394: Call_ConfigurationAssignmentsCreateOrUpdate_574382;
          resourceType: string; configurationAssignmentName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; providerName: string;
          configurationAssignment: JsonNode): Recallable =
  ## configurationAssignmentsCreateOrUpdate
  ## Register configuration for resource.
  ##   resourceType: string (required)
  ##               : Resource type
  ##   configurationAssignmentName: string (required)
  ##                              : Configuration assignment name
  ##   resourceGroupName: string (required)
  ##                    : Resource group name
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : Resource identifier
  ##   providerName: string (required)
  ##               : Resource provider name
  ##   configurationAssignment: JObject (required)
  ##                          : The configurationAssignment
  var path_574395 = newJObject()
  var query_574396 = newJObject()
  var body_574397 = newJObject()
  add(path_574395, "resourceType", newJString(resourceType))
  add(path_574395, "configurationAssignmentName",
      newJString(configurationAssignmentName))
  add(path_574395, "resourceGroupName", newJString(resourceGroupName))
  add(query_574396, "api-version", newJString(apiVersion))
  add(path_574395, "subscriptionId", newJString(subscriptionId))
  add(path_574395, "resourceName", newJString(resourceName))
  add(path_574395, "providerName", newJString(providerName))
  if configurationAssignment != nil:
    body_574397 = configurationAssignment
  result = call_574394.call(path_574395, query_574396, nil, nil, body_574397)

var configurationAssignmentsCreateOrUpdate* = Call_ConfigurationAssignmentsCreateOrUpdate_574382(
    name: "configurationAssignmentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{providerName}/{resourceType}/{resourceName}/providers/Microsoft.Maintenance/configurationAssignments/{configurationAssignmentName}",
    validator: validate_ConfigurationAssignmentsCreateOrUpdate_574383, base: "",
    url: url_ConfigurationAssignmentsCreateOrUpdate_574384,
    schemes: {Scheme.Https})
type
  Call_ConfigurationAssignmentsDelete_574398 = ref object of OpenApiRestCall_573658
proc url_ConfigurationAssignmentsDelete_574400(protocol: Scheme; host: string;
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

proc validate_ConfigurationAssignmentsDelete_574399(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Unregister configuration for resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : Resource type
  ##   configurationAssignmentName: JString (required)
  ##                              : Unique configuration assignment name
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : Resource identifier
  ##   providerName: JString (required)
  ##               : Resource provider name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_574401 = path.getOrDefault("resourceType")
  valid_574401 = validateParameter(valid_574401, JString, required = true,
                                 default = nil)
  if valid_574401 != nil:
    section.add "resourceType", valid_574401
  var valid_574402 = path.getOrDefault("configurationAssignmentName")
  valid_574402 = validateParameter(valid_574402, JString, required = true,
                                 default = nil)
  if valid_574402 != nil:
    section.add "configurationAssignmentName", valid_574402
  var valid_574403 = path.getOrDefault("resourceGroupName")
  valid_574403 = validateParameter(valid_574403, JString, required = true,
                                 default = nil)
  if valid_574403 != nil:
    section.add "resourceGroupName", valid_574403
  var valid_574404 = path.getOrDefault("subscriptionId")
  valid_574404 = validateParameter(valid_574404, JString, required = true,
                                 default = nil)
  if valid_574404 != nil:
    section.add "subscriptionId", valid_574404
  var valid_574405 = path.getOrDefault("resourceName")
  valid_574405 = validateParameter(valid_574405, JString, required = true,
                                 default = nil)
  if valid_574405 != nil:
    section.add "resourceName", valid_574405
  var valid_574406 = path.getOrDefault("providerName")
  valid_574406 = validateParameter(valid_574406, JString, required = true,
                                 default = nil)
  if valid_574406 != nil:
    section.add "providerName", valid_574406
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574407 = query.getOrDefault("api-version")
  valid_574407 = validateParameter(valid_574407, JString, required = true,
                                 default = nil)
  if valid_574407 != nil:
    section.add "api-version", valid_574407
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574408: Call_ConfigurationAssignmentsDelete_574398; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unregister configuration for resource.
  ## 
  let valid = call_574408.validator(path, query, header, formData, body)
  let scheme = call_574408.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574408.url(scheme.get, call_574408.host, call_574408.base,
                         call_574408.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574408, url, valid)

proc call*(call_574409: Call_ConfigurationAssignmentsDelete_574398;
          resourceType: string; configurationAssignmentName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; providerName: string): Recallable =
  ## configurationAssignmentsDelete
  ## Unregister configuration for resource.
  ##   resourceType: string (required)
  ##               : Resource type
  ##   configurationAssignmentName: string (required)
  ##                              : Unique configuration assignment name
  ##   resourceGroupName: string (required)
  ##                    : Resource group name
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : Resource identifier
  ##   providerName: string (required)
  ##               : Resource provider name
  var path_574410 = newJObject()
  var query_574411 = newJObject()
  add(path_574410, "resourceType", newJString(resourceType))
  add(path_574410, "configurationAssignmentName",
      newJString(configurationAssignmentName))
  add(path_574410, "resourceGroupName", newJString(resourceGroupName))
  add(query_574411, "api-version", newJString(apiVersion))
  add(path_574410, "subscriptionId", newJString(subscriptionId))
  add(path_574410, "resourceName", newJString(resourceName))
  add(path_574410, "providerName", newJString(providerName))
  result = call_574409.call(path_574410, query_574411, nil, nil, nil)

var configurationAssignmentsDelete* = Call_ConfigurationAssignmentsDelete_574398(
    name: "configurationAssignmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{providerName}/{resourceType}/{resourceName}/providers/Microsoft.Maintenance/configurationAssignments/{configurationAssignmentName}",
    validator: validate_ConfigurationAssignmentsDelete_574399, base: "",
    url: url_ConfigurationAssignmentsDelete_574400, schemes: {Scheme.Https})
type
  Call_UpdatesList_574412 = ref object of OpenApiRestCall_573658
proc url_UpdatesList_574414(protocol: Scheme; host: string; base: string;
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

proc validate_UpdatesList_574413(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get updates to resources.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : Resource type
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: JString (required)
  ##               : Resource identifier
  ##   providerName: JString (required)
  ##               : Resource provider name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_574415 = path.getOrDefault("resourceType")
  valid_574415 = validateParameter(valid_574415, JString, required = true,
                                 default = nil)
  if valid_574415 != nil:
    section.add "resourceType", valid_574415
  var valid_574416 = path.getOrDefault("resourceGroupName")
  valid_574416 = validateParameter(valid_574416, JString, required = true,
                                 default = nil)
  if valid_574416 != nil:
    section.add "resourceGroupName", valid_574416
  var valid_574417 = path.getOrDefault("subscriptionId")
  valid_574417 = validateParameter(valid_574417, JString, required = true,
                                 default = nil)
  if valid_574417 != nil:
    section.add "subscriptionId", valid_574417
  var valid_574418 = path.getOrDefault("resourceName")
  valid_574418 = validateParameter(valid_574418, JString, required = true,
                                 default = nil)
  if valid_574418 != nil:
    section.add "resourceName", valid_574418
  var valid_574419 = path.getOrDefault("providerName")
  valid_574419 = validateParameter(valid_574419, JString, required = true,
                                 default = nil)
  if valid_574419 != nil:
    section.add "providerName", valid_574419
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574420 = query.getOrDefault("api-version")
  valid_574420 = validateParameter(valid_574420, JString, required = true,
                                 default = nil)
  if valid_574420 != nil:
    section.add "api-version", valid_574420
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574421: Call_UpdatesList_574412; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get updates to resources.
  ## 
  let valid = call_574421.validator(path, query, header, formData, body)
  let scheme = call_574421.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574421.url(scheme.get, call_574421.host, call_574421.base,
                         call_574421.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574421, url, valid)

proc call*(call_574422: Call_UpdatesList_574412; resourceType: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; providerName: string): Recallable =
  ## updatesList
  ## Get updates to resources.
  ##   resourceType: string (required)
  ##               : Resource type
  ##   resourceGroupName: string (required)
  ##                    : Resource group name
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceName: string (required)
  ##               : Resource identifier
  ##   providerName: string (required)
  ##               : Resource provider name
  var path_574423 = newJObject()
  var query_574424 = newJObject()
  add(path_574423, "resourceType", newJString(resourceType))
  add(path_574423, "resourceGroupName", newJString(resourceGroupName))
  add(query_574424, "api-version", newJString(apiVersion))
  add(path_574423, "subscriptionId", newJString(subscriptionId))
  add(path_574423, "resourceName", newJString(resourceName))
  add(path_574423, "providerName", newJString(providerName))
  result = call_574422.call(path_574423, query_574424, nil, nil, nil)

var updatesList* = Call_UpdatesList_574412(name: "updatesList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{providerName}/{resourceType}/{resourceName}/providers/Microsoft.Maintenance/updates",
                                        validator: validate_UpdatesList_574413,
                                        base: "", url: url_UpdatesList_574414,
                                        schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
