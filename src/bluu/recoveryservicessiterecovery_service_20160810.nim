
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: SiteRecoveryManagementClient
## version: 2016-08-10
## termsOfService: (not provided)
## license: (not provided)
## 
## 
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

  OpenApiRestCall_563564 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563564](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563564): Option[Scheme] {.used.} =
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
  macServiceName = "recoveryservicessiterecovery-service"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563786 = ref object of OpenApiRestCall_563564
proc url_OperationsList_563788(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OperationsList_563787(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Operation to return the list of available operations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563963 = path.getOrDefault("subscriptionId")
  valid_563963 = validateParameter(valid_563963, JString, required = true,
                                 default = nil)
  if valid_563963 != nil:
    section.add "subscriptionId", valid_563963
  var valid_563964 = path.getOrDefault("resourceGroupName")
  valid_563964 = validateParameter(valid_563964, JString, required = true,
                                 default = nil)
  if valid_563964 != nil:
    section.add "resourceGroupName", valid_563964
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563965 = query.getOrDefault("api-version")
  valid_563965 = validateParameter(valid_563965, JString, required = true,
                                 default = nil)
  if valid_563965 != nil:
    section.add "api-version", valid_563965
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563988: Call_OperationsList_563786; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Operation to return the list of available operations.
  ## 
  let valid = call_563988.validator(path, query, header, formData, body)
  let scheme = call_563988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563988.url(scheme.get, call_563988.host, call_563988.base,
                         call_563988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563988, url, valid)

proc call*(call_564059: Call_OperationsList_563786; apiVersion: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## operationsList
  ## Operation to return the list of available operations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  var path_564060 = newJObject()
  var query_564062 = newJObject()
  add(query_564062, "api-version", newJString(apiVersion))
  add(path_564060, "subscriptionId", newJString(subscriptionId))
  add(path_564060, "resourceGroupName", newJString(resourceGroupName))
  result = call_564059.call(path_564060, query_564062, nil, nil, nil)

var operationsList* = Call_OperationsList_563786(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/operations",
    validator: validate_OperationsList_563787, base: "", url: url_OperationsList_563788,
    schemes: {Scheme.Https})
type
  Call_ReplicationAlertSettingsList_564101 = ref object of OpenApiRestCall_563564
proc url_ReplicationAlertSettingsList_564103(protocol: Scheme; host: string;
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
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationAlertSettings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationAlertSettingsList_564102(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the list of email notification(alert) configurations for the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564104 = path.getOrDefault("subscriptionId")
  valid_564104 = validateParameter(valid_564104, JString, required = true,
                                 default = nil)
  if valid_564104 != nil:
    section.add "subscriptionId", valid_564104
  var valid_564105 = path.getOrDefault("resourceGroupName")
  valid_564105 = validateParameter(valid_564105, JString, required = true,
                                 default = nil)
  if valid_564105 != nil:
    section.add "resourceGroupName", valid_564105
  var valid_564106 = path.getOrDefault("resourceName")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "resourceName", valid_564106
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564107 = query.getOrDefault("api-version")
  valid_564107 = validateParameter(valid_564107, JString, required = true,
                                 default = nil)
  if valid_564107 != nil:
    section.add "api-version", valid_564107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564108: Call_ReplicationAlertSettingsList_564101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of email notification(alert) configurations for the vault.
  ## 
  let valid = call_564108.validator(path, query, header, formData, body)
  let scheme = call_564108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564108.url(scheme.get, call_564108.host, call_564108.base,
                         call_564108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564108, url, valid)

proc call*(call_564109: Call_ReplicationAlertSettingsList_564101;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## replicationAlertSettingsList
  ## Gets the list of email notification(alert) configurations for the vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564110 = newJObject()
  var query_564111 = newJObject()
  add(query_564111, "api-version", newJString(apiVersion))
  add(path_564110, "subscriptionId", newJString(subscriptionId))
  add(path_564110, "resourceGroupName", newJString(resourceGroupName))
  add(path_564110, "resourceName", newJString(resourceName))
  result = call_564109.call(path_564110, query_564111, nil, nil, nil)

var replicationAlertSettingsList* = Call_ReplicationAlertSettingsList_564101(
    name: "replicationAlertSettingsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationAlertSettings",
    validator: validate_ReplicationAlertSettingsList_564102, base: "",
    url: url_ReplicationAlertSettingsList_564103, schemes: {Scheme.Https})
type
  Call_ReplicationAlertSettingsCreate_564124 = ref object of OpenApiRestCall_563564
proc url_ReplicationAlertSettingsCreate_564126(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "alertSettingName" in path,
        "`alertSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationAlertSettings/"),
               (kind: VariableSegment, value: "alertSettingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationAlertSettingsCreate_564125(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an email notification(alert) configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertSettingName: JString (required)
  ##                   : The name of the email notification(alert) configuration.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `alertSettingName` field"
  var valid_564127 = path.getOrDefault("alertSettingName")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "alertSettingName", valid_564127
  var valid_564128 = path.getOrDefault("subscriptionId")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "subscriptionId", valid_564128
  var valid_564129 = path.getOrDefault("resourceGroupName")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "resourceGroupName", valid_564129
  var valid_564130 = path.getOrDefault("resourceName")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "resourceName", valid_564130
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564131 = query.getOrDefault("api-version")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "api-version", valid_564131
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   request: JObject (required)
  ##          : The input to configure the email notification(alert).
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564133: Call_ReplicationAlertSettingsCreate_564124; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an email notification(alert) configuration.
  ## 
  let valid = call_564133.validator(path, query, header, formData, body)
  let scheme = call_564133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564133.url(scheme.get, call_564133.host, call_564133.base,
                         call_564133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564133, url, valid)

proc call*(call_564134: Call_ReplicationAlertSettingsCreate_564124;
          apiVersion: string; alertSettingName: string; subscriptionId: string;
          resourceGroupName: string; resourceName: string; request: JsonNode): Recallable =
  ## replicationAlertSettingsCreate
  ## Create or update an email notification(alert) configuration.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   alertSettingName: string (required)
  ##                   : The name of the email notification(alert) configuration.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   request: JObject (required)
  ##          : The input to configure the email notification(alert).
  var path_564135 = newJObject()
  var query_564136 = newJObject()
  var body_564137 = newJObject()
  add(query_564136, "api-version", newJString(apiVersion))
  add(path_564135, "alertSettingName", newJString(alertSettingName))
  add(path_564135, "subscriptionId", newJString(subscriptionId))
  add(path_564135, "resourceGroupName", newJString(resourceGroupName))
  add(path_564135, "resourceName", newJString(resourceName))
  if request != nil:
    body_564137 = request
  result = call_564134.call(path_564135, query_564136, nil, nil, body_564137)

var replicationAlertSettingsCreate* = Call_ReplicationAlertSettingsCreate_564124(
    name: "replicationAlertSettingsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationAlertSettings/{alertSettingName}",
    validator: validate_ReplicationAlertSettingsCreate_564125, base: "",
    url: url_ReplicationAlertSettingsCreate_564126, schemes: {Scheme.Https})
type
  Call_ReplicationAlertSettingsGet_564112 = ref object of OpenApiRestCall_563564
proc url_ReplicationAlertSettingsGet_564114(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "alertSettingName" in path,
        "`alertSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationAlertSettings/"),
               (kind: VariableSegment, value: "alertSettingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationAlertSettingsGet_564113(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the specified email notification(alert) configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertSettingName: JString (required)
  ##                   : The name of the email notification configuration.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `alertSettingName` field"
  var valid_564115 = path.getOrDefault("alertSettingName")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "alertSettingName", valid_564115
  var valid_564116 = path.getOrDefault("subscriptionId")
  valid_564116 = validateParameter(valid_564116, JString, required = true,
                                 default = nil)
  if valid_564116 != nil:
    section.add "subscriptionId", valid_564116
  var valid_564117 = path.getOrDefault("resourceGroupName")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "resourceGroupName", valid_564117
  var valid_564118 = path.getOrDefault("resourceName")
  valid_564118 = validateParameter(valid_564118, JString, required = true,
                                 default = nil)
  if valid_564118 != nil:
    section.add "resourceName", valid_564118
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564119 = query.getOrDefault("api-version")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "api-version", valid_564119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564120: Call_ReplicationAlertSettingsGet_564112; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the specified email notification(alert) configuration.
  ## 
  let valid = call_564120.validator(path, query, header, formData, body)
  let scheme = call_564120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564120.url(scheme.get, call_564120.host, call_564120.base,
                         call_564120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564120, url, valid)

proc call*(call_564121: Call_ReplicationAlertSettingsGet_564112;
          apiVersion: string; alertSettingName: string; subscriptionId: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## replicationAlertSettingsGet
  ## Gets the details of the specified email notification(alert) configuration.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   alertSettingName: string (required)
  ##                   : The name of the email notification configuration.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564122 = newJObject()
  var query_564123 = newJObject()
  add(query_564123, "api-version", newJString(apiVersion))
  add(path_564122, "alertSettingName", newJString(alertSettingName))
  add(path_564122, "subscriptionId", newJString(subscriptionId))
  add(path_564122, "resourceGroupName", newJString(resourceGroupName))
  add(path_564122, "resourceName", newJString(resourceName))
  result = call_564121.call(path_564122, query_564123, nil, nil, nil)

var replicationAlertSettingsGet* = Call_ReplicationAlertSettingsGet_564112(
    name: "replicationAlertSettingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationAlertSettings/{alertSettingName}",
    validator: validate_ReplicationAlertSettingsGet_564113, base: "",
    url: url_ReplicationAlertSettingsGet_564114, schemes: {Scheme.Https})
type
  Call_ReplicationEventsList_564138 = ref object of OpenApiRestCall_563564
proc url_ReplicationEventsList_564140(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationEvents")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationEventsList_564139(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the list of Azure Site Recovery events for the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564142 = path.getOrDefault("subscriptionId")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "subscriptionId", valid_564142
  var valid_564143 = path.getOrDefault("resourceGroupName")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "resourceGroupName", valid_564143
  var valid_564144 = path.getOrDefault("resourceName")
  valid_564144 = validateParameter(valid_564144, JString, required = true,
                                 default = nil)
  if valid_564144 != nil:
    section.add "resourceName", valid_564144
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564145 = query.getOrDefault("api-version")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "api-version", valid_564145
  var valid_564146 = query.getOrDefault("$filter")
  valid_564146 = validateParameter(valid_564146, JString, required = false,
                                 default = nil)
  if valid_564146 != nil:
    section.add "$filter", valid_564146
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564147: Call_ReplicationEventsList_564138; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of Azure Site Recovery events for the vault.
  ## 
  let valid = call_564147.validator(path, query, header, formData, body)
  let scheme = call_564147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564147.url(scheme.get, call_564147.host, call_564147.base,
                         call_564147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564147, url, valid)

proc call*(call_564148: Call_ReplicationEventsList_564138; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string;
          Filter: string = ""): Recallable =
  ## replicationEventsList
  ## Gets the list of Azure Site Recovery events for the vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   Filter: string
  ##         : OData filter options.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564149 = newJObject()
  var query_564150 = newJObject()
  add(query_564150, "api-version", newJString(apiVersion))
  add(path_564149, "subscriptionId", newJString(subscriptionId))
  add(path_564149, "resourceGroupName", newJString(resourceGroupName))
  add(query_564150, "$filter", newJString(Filter))
  add(path_564149, "resourceName", newJString(resourceName))
  result = call_564148.call(path_564149, query_564150, nil, nil, nil)

var replicationEventsList* = Call_ReplicationEventsList_564138(
    name: "replicationEventsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationEvents",
    validator: validate_ReplicationEventsList_564139, base: "",
    url: url_ReplicationEventsList_564140, schemes: {Scheme.Https})
type
  Call_ReplicationEventsGet_564151 = ref object of OpenApiRestCall_563564
proc url_ReplicationEventsGet_564153(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "eventName" in path, "`eventName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationEvents/"),
               (kind: VariableSegment, value: "eventName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationEventsGet_564152(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to get the details of an Azure Site recovery event.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   eventName: JString (required)
  ##            : The name of the Azure Site Recovery event.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564154 = path.getOrDefault("subscriptionId")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "subscriptionId", valid_564154
  var valid_564155 = path.getOrDefault("resourceGroupName")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "resourceGroupName", valid_564155
  var valid_564156 = path.getOrDefault("resourceName")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = nil)
  if valid_564156 != nil:
    section.add "resourceName", valid_564156
  var valid_564157 = path.getOrDefault("eventName")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "eventName", valid_564157
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564158 = query.getOrDefault("api-version")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = nil)
  if valid_564158 != nil:
    section.add "api-version", valid_564158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564159: Call_ReplicationEventsGet_564151; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to get the details of an Azure Site recovery event.
  ## 
  let valid = call_564159.validator(path, query, header, formData, body)
  let scheme = call_564159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564159.url(scheme.get, call_564159.host, call_564159.base,
                         call_564159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564159, url, valid)

proc call*(call_564160: Call_ReplicationEventsGet_564151; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string;
          eventName: string): Recallable =
  ## replicationEventsGet
  ## The operation to get the details of an Azure Site recovery event.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   eventName: string (required)
  ##            : The name of the Azure Site Recovery event.
  var path_564161 = newJObject()
  var query_564162 = newJObject()
  add(query_564162, "api-version", newJString(apiVersion))
  add(path_564161, "subscriptionId", newJString(subscriptionId))
  add(path_564161, "resourceGroupName", newJString(resourceGroupName))
  add(path_564161, "resourceName", newJString(resourceName))
  add(path_564161, "eventName", newJString(eventName))
  result = call_564160.call(path_564161, query_564162, nil, nil, nil)

var replicationEventsGet* = Call_ReplicationEventsGet_564151(
    name: "replicationEventsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationEvents/{eventName}",
    validator: validate_ReplicationEventsGet_564152, base: "",
    url: url_ReplicationEventsGet_564153, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsList_564163 = ref object of OpenApiRestCall_563564
proc url_ReplicationFabricsList_564165(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationFabricsList_564164(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of the Azure Site Recovery fabrics in the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564166 = path.getOrDefault("subscriptionId")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "subscriptionId", valid_564166
  var valid_564167 = path.getOrDefault("resourceGroupName")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "resourceGroupName", valid_564167
  var valid_564168 = path.getOrDefault("resourceName")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "resourceName", valid_564168
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564169 = query.getOrDefault("api-version")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "api-version", valid_564169
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564170: Call_ReplicationFabricsList_564163; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of the Azure Site Recovery fabrics in the vault.
  ## 
  let valid = call_564170.validator(path, query, header, formData, body)
  let scheme = call_564170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564170.url(scheme.get, call_564170.host, call_564170.base,
                         call_564170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564170, url, valid)

proc call*(call_564171: Call_ReplicationFabricsList_564163; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## replicationFabricsList
  ## Gets a list of the Azure Site Recovery fabrics in the vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564172 = newJObject()
  var query_564173 = newJObject()
  add(query_564173, "api-version", newJString(apiVersion))
  add(path_564172, "subscriptionId", newJString(subscriptionId))
  add(path_564172, "resourceGroupName", newJString(resourceGroupName))
  add(path_564172, "resourceName", newJString(resourceName))
  result = call_564171.call(path_564172, query_564173, nil, nil, nil)

var replicationFabricsList* = Call_ReplicationFabricsList_564163(
    name: "replicationFabricsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics",
    validator: validate_ReplicationFabricsList_564164, base: "",
    url: url_ReplicationFabricsList_564165, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsCreate_564186 = ref object of OpenApiRestCall_563564
proc url_ReplicationFabricsCreate_564188(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationFabricsCreate_564187(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create an Azure Site Recovery fabric (for e.g. Hyper-V site)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Name of the ASR fabric.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_564189 = path.getOrDefault("fabricName")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "fabricName", valid_564189
  var valid_564190 = path.getOrDefault("subscriptionId")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "subscriptionId", valid_564190
  var valid_564191 = path.getOrDefault("resourceGroupName")
  valid_564191 = validateParameter(valid_564191, JString, required = true,
                                 default = nil)
  if valid_564191 != nil:
    section.add "resourceGroupName", valid_564191
  var valid_564192 = path.getOrDefault("resourceName")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "resourceName", valid_564192
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564193 = query.getOrDefault("api-version")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "api-version", valid_564193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Fabric creation input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564195: Call_ReplicationFabricsCreate_564186; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create an Azure Site Recovery fabric (for e.g. Hyper-V site)
  ## 
  let valid = call_564195.validator(path, query, header, formData, body)
  let scheme = call_564195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564195.url(scheme.get, call_564195.host, call_564195.base,
                         call_564195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564195, url, valid)

proc call*(call_564196: Call_ReplicationFabricsCreate_564186; apiVersion: string;
          input: JsonNode; fabricName: string; subscriptionId: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## replicationFabricsCreate
  ## The operation to create an Azure Site Recovery fabric (for e.g. Hyper-V site)
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   input: JObject (required)
  ##        : Fabric creation input.
  ##   fabricName: string (required)
  ##             : Name of the ASR fabric.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564197 = newJObject()
  var query_564198 = newJObject()
  var body_564199 = newJObject()
  add(query_564198, "api-version", newJString(apiVersion))
  if input != nil:
    body_564199 = input
  add(path_564197, "fabricName", newJString(fabricName))
  add(path_564197, "subscriptionId", newJString(subscriptionId))
  add(path_564197, "resourceGroupName", newJString(resourceGroupName))
  add(path_564197, "resourceName", newJString(resourceName))
  result = call_564196.call(path_564197, query_564198, nil, nil, body_564199)

var replicationFabricsCreate* = Call_ReplicationFabricsCreate_564186(
    name: "replicationFabricsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}",
    validator: validate_ReplicationFabricsCreate_564187, base: "",
    url: url_ReplicationFabricsCreate_564188, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsGet_564174 = ref object of OpenApiRestCall_563564
proc url_ReplicationFabricsGet_564176(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationFabricsGet_564175(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of an Azure Site Recovery fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_564177 = path.getOrDefault("fabricName")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "fabricName", valid_564177
  var valid_564178 = path.getOrDefault("subscriptionId")
  valid_564178 = validateParameter(valid_564178, JString, required = true,
                                 default = nil)
  if valid_564178 != nil:
    section.add "subscriptionId", valid_564178
  var valid_564179 = path.getOrDefault("resourceGroupName")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "resourceGroupName", valid_564179
  var valid_564180 = path.getOrDefault("resourceName")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "resourceName", valid_564180
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564181 = query.getOrDefault("api-version")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "api-version", valid_564181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564182: Call_ReplicationFabricsGet_564174; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of an Azure Site Recovery fabric.
  ## 
  let valid = call_564182.validator(path, query, header, formData, body)
  let scheme = call_564182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564182.url(scheme.get, call_564182.host, call_564182.base,
                         call_564182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564182, url, valid)

proc call*(call_564183: Call_ReplicationFabricsGet_564174; apiVersion: string;
          fabricName: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## replicationFabricsGet
  ## Gets the details of an Azure Site Recovery fabric.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564184 = newJObject()
  var query_564185 = newJObject()
  add(query_564185, "api-version", newJString(apiVersion))
  add(path_564184, "fabricName", newJString(fabricName))
  add(path_564184, "subscriptionId", newJString(subscriptionId))
  add(path_564184, "resourceGroupName", newJString(resourceGroupName))
  add(path_564184, "resourceName", newJString(resourceName))
  result = call_564183.call(path_564184, query_564185, nil, nil, nil)

var replicationFabricsGet* = Call_ReplicationFabricsGet_564174(
    name: "replicationFabricsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}",
    validator: validate_ReplicationFabricsGet_564175, base: "",
    url: url_ReplicationFabricsGet_564176, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsPurge_564200 = ref object of OpenApiRestCall_563564
proc url_ReplicationFabricsPurge_564202(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationFabricsPurge_564201(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to purge(force delete) an Azure Site Recovery fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : ASR fabric to purge.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_564203 = path.getOrDefault("fabricName")
  valid_564203 = validateParameter(valid_564203, JString, required = true,
                                 default = nil)
  if valid_564203 != nil:
    section.add "fabricName", valid_564203
  var valid_564204 = path.getOrDefault("subscriptionId")
  valid_564204 = validateParameter(valid_564204, JString, required = true,
                                 default = nil)
  if valid_564204 != nil:
    section.add "subscriptionId", valid_564204
  var valid_564205 = path.getOrDefault("resourceGroupName")
  valid_564205 = validateParameter(valid_564205, JString, required = true,
                                 default = nil)
  if valid_564205 != nil:
    section.add "resourceGroupName", valid_564205
  var valid_564206 = path.getOrDefault("resourceName")
  valid_564206 = validateParameter(valid_564206, JString, required = true,
                                 default = nil)
  if valid_564206 != nil:
    section.add "resourceName", valid_564206
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564207 = query.getOrDefault("api-version")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "api-version", valid_564207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564208: Call_ReplicationFabricsPurge_564200; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to purge(force delete) an Azure Site Recovery fabric.
  ## 
  let valid = call_564208.validator(path, query, header, formData, body)
  let scheme = call_564208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564208.url(scheme.get, call_564208.host, call_564208.base,
                         call_564208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564208, url, valid)

proc call*(call_564209: Call_ReplicationFabricsPurge_564200; apiVersion: string;
          fabricName: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## replicationFabricsPurge
  ## The operation to purge(force delete) an Azure Site Recovery fabric.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : ASR fabric to purge.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564210 = newJObject()
  var query_564211 = newJObject()
  add(query_564211, "api-version", newJString(apiVersion))
  add(path_564210, "fabricName", newJString(fabricName))
  add(path_564210, "subscriptionId", newJString(subscriptionId))
  add(path_564210, "resourceGroupName", newJString(resourceGroupName))
  add(path_564210, "resourceName", newJString(resourceName))
  result = call_564209.call(path_564210, query_564211, nil, nil, nil)

var replicationFabricsPurge* = Call_ReplicationFabricsPurge_564200(
    name: "replicationFabricsPurge", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}",
    validator: validate_ReplicationFabricsPurge_564201, base: "",
    url: url_ReplicationFabricsPurge_564202, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsCheckConsistency_564212 = ref object of OpenApiRestCall_563564
proc url_ReplicationFabricsCheckConsistency_564214(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/checkConsistency")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationFabricsCheckConsistency_564213(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to perform a consistency check on the fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_564215 = path.getOrDefault("fabricName")
  valid_564215 = validateParameter(valid_564215, JString, required = true,
                                 default = nil)
  if valid_564215 != nil:
    section.add "fabricName", valid_564215
  var valid_564216 = path.getOrDefault("subscriptionId")
  valid_564216 = validateParameter(valid_564216, JString, required = true,
                                 default = nil)
  if valid_564216 != nil:
    section.add "subscriptionId", valid_564216
  var valid_564217 = path.getOrDefault("resourceGroupName")
  valid_564217 = validateParameter(valid_564217, JString, required = true,
                                 default = nil)
  if valid_564217 != nil:
    section.add "resourceGroupName", valid_564217
  var valid_564218 = path.getOrDefault("resourceName")
  valid_564218 = validateParameter(valid_564218, JString, required = true,
                                 default = nil)
  if valid_564218 != nil:
    section.add "resourceName", valid_564218
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564219 = query.getOrDefault("api-version")
  valid_564219 = validateParameter(valid_564219, JString, required = true,
                                 default = nil)
  if valid_564219 != nil:
    section.add "api-version", valid_564219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564220: Call_ReplicationFabricsCheckConsistency_564212;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to perform a consistency check on the fabric.
  ## 
  let valid = call_564220.validator(path, query, header, formData, body)
  let scheme = call_564220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564220.url(scheme.get, call_564220.host, call_564220.base,
                         call_564220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564220, url, valid)

proc call*(call_564221: Call_ReplicationFabricsCheckConsistency_564212;
          apiVersion: string; fabricName: string; subscriptionId: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## replicationFabricsCheckConsistency
  ## The operation to perform a consistency check on the fabric.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564222 = newJObject()
  var query_564223 = newJObject()
  add(query_564223, "api-version", newJString(apiVersion))
  add(path_564222, "fabricName", newJString(fabricName))
  add(path_564222, "subscriptionId", newJString(subscriptionId))
  add(path_564222, "resourceGroupName", newJString(resourceGroupName))
  add(path_564222, "resourceName", newJString(resourceName))
  result = call_564221.call(path_564222, query_564223, nil, nil, nil)

var replicationFabricsCheckConsistency* = Call_ReplicationFabricsCheckConsistency_564212(
    name: "replicationFabricsCheckConsistency", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/checkConsistency",
    validator: validate_ReplicationFabricsCheckConsistency_564213, base: "",
    url: url_ReplicationFabricsCheckConsistency_564214, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsMigrateToAad_564224 = ref object of OpenApiRestCall_563564
proc url_ReplicationFabricsMigrateToAad_564226(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/migratetoaad")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationFabricsMigrateToAad_564225(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to migrate an Azure Site Recovery fabric to AAD.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : ASR fabric to migrate.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_564227 = path.getOrDefault("fabricName")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "fabricName", valid_564227
  var valid_564228 = path.getOrDefault("subscriptionId")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "subscriptionId", valid_564228
  var valid_564229 = path.getOrDefault("resourceGroupName")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "resourceGroupName", valid_564229
  var valid_564230 = path.getOrDefault("resourceName")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = nil)
  if valid_564230 != nil:
    section.add "resourceName", valid_564230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564231 = query.getOrDefault("api-version")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = nil)
  if valid_564231 != nil:
    section.add "api-version", valid_564231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564232: Call_ReplicationFabricsMigrateToAad_564224; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to migrate an Azure Site Recovery fabric to AAD.
  ## 
  let valid = call_564232.validator(path, query, header, formData, body)
  let scheme = call_564232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564232.url(scheme.get, call_564232.host, call_564232.base,
                         call_564232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564232, url, valid)

proc call*(call_564233: Call_ReplicationFabricsMigrateToAad_564224;
          apiVersion: string; fabricName: string; subscriptionId: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## replicationFabricsMigrateToAad
  ## The operation to migrate an Azure Site Recovery fabric to AAD.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : ASR fabric to migrate.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564234 = newJObject()
  var query_564235 = newJObject()
  add(query_564235, "api-version", newJString(apiVersion))
  add(path_564234, "fabricName", newJString(fabricName))
  add(path_564234, "subscriptionId", newJString(subscriptionId))
  add(path_564234, "resourceGroupName", newJString(resourceGroupName))
  add(path_564234, "resourceName", newJString(resourceName))
  result = call_564233.call(path_564234, query_564235, nil, nil, nil)

var replicationFabricsMigrateToAad* = Call_ReplicationFabricsMigrateToAad_564224(
    name: "replicationFabricsMigrateToAad", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/migratetoaad",
    validator: validate_ReplicationFabricsMigrateToAad_564225, base: "",
    url: url_ReplicationFabricsMigrateToAad_564226, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsReassociateGateway_564236 = ref object of OpenApiRestCall_563564
proc url_ReplicationFabricsReassociateGateway_564238(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/reassociateGateway")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationFabricsReassociateGateway_564237(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to move replications from a process server to another process server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The name of the fabric containing the process server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_564239 = path.getOrDefault("fabricName")
  valid_564239 = validateParameter(valid_564239, JString, required = true,
                                 default = nil)
  if valid_564239 != nil:
    section.add "fabricName", valid_564239
  var valid_564240 = path.getOrDefault("subscriptionId")
  valid_564240 = validateParameter(valid_564240, JString, required = true,
                                 default = nil)
  if valid_564240 != nil:
    section.add "subscriptionId", valid_564240
  var valid_564241 = path.getOrDefault("resourceGroupName")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = nil)
  if valid_564241 != nil:
    section.add "resourceGroupName", valid_564241
  var valid_564242 = path.getOrDefault("resourceName")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "resourceName", valid_564242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564243 = query.getOrDefault("api-version")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = nil)
  if valid_564243 != nil:
    section.add "api-version", valid_564243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   failoverProcessServerRequest: JObject (required)
  ##                               : The input to the failover process server operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564245: Call_ReplicationFabricsReassociateGateway_564236;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to move replications from a process server to another process server.
  ## 
  let valid = call_564245.validator(path, query, header, formData, body)
  let scheme = call_564245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564245.url(scheme.get, call_564245.host, call_564245.base,
                         call_564245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564245, url, valid)

proc call*(call_564246: Call_ReplicationFabricsReassociateGateway_564236;
          apiVersion: string; failoverProcessServerRequest: JsonNode;
          fabricName: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## replicationFabricsReassociateGateway
  ## The operation to move replications from a process server to another process server.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   failoverProcessServerRequest: JObject (required)
  ##                               : The input to the failover process server operation.
  ##   fabricName: string (required)
  ##             : The name of the fabric containing the process server.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564247 = newJObject()
  var query_564248 = newJObject()
  var body_564249 = newJObject()
  add(query_564248, "api-version", newJString(apiVersion))
  if failoverProcessServerRequest != nil:
    body_564249 = failoverProcessServerRequest
  add(path_564247, "fabricName", newJString(fabricName))
  add(path_564247, "subscriptionId", newJString(subscriptionId))
  add(path_564247, "resourceGroupName", newJString(resourceGroupName))
  add(path_564247, "resourceName", newJString(resourceName))
  result = call_564246.call(path_564247, query_564248, nil, nil, body_564249)

var replicationFabricsReassociateGateway* = Call_ReplicationFabricsReassociateGateway_564236(
    name: "replicationFabricsReassociateGateway", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/reassociateGateway",
    validator: validate_ReplicationFabricsReassociateGateway_564237, base: "",
    url: url_ReplicationFabricsReassociateGateway_564238, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsDelete_564250 = ref object of OpenApiRestCall_563564
proc url_ReplicationFabricsDelete_564252(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/remove")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationFabricsDelete_564251(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete or remove an Azure Site Recovery fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : ASR fabric to delete
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_564253 = path.getOrDefault("fabricName")
  valid_564253 = validateParameter(valid_564253, JString, required = true,
                                 default = nil)
  if valid_564253 != nil:
    section.add "fabricName", valid_564253
  var valid_564254 = path.getOrDefault("subscriptionId")
  valid_564254 = validateParameter(valid_564254, JString, required = true,
                                 default = nil)
  if valid_564254 != nil:
    section.add "subscriptionId", valid_564254
  var valid_564255 = path.getOrDefault("resourceGroupName")
  valid_564255 = validateParameter(valid_564255, JString, required = true,
                                 default = nil)
  if valid_564255 != nil:
    section.add "resourceGroupName", valid_564255
  var valid_564256 = path.getOrDefault("resourceName")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = nil)
  if valid_564256 != nil:
    section.add "resourceName", valid_564256
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564257 = query.getOrDefault("api-version")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = nil)
  if valid_564257 != nil:
    section.add "api-version", valid_564257
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564258: Call_ReplicationFabricsDelete_564250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete or remove an Azure Site Recovery fabric.
  ## 
  let valid = call_564258.validator(path, query, header, formData, body)
  let scheme = call_564258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564258.url(scheme.get, call_564258.host, call_564258.base,
                         call_564258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564258, url, valid)

proc call*(call_564259: Call_ReplicationFabricsDelete_564250; apiVersion: string;
          fabricName: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## replicationFabricsDelete
  ## The operation to delete or remove an Azure Site Recovery fabric.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : ASR fabric to delete
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564260 = newJObject()
  var query_564261 = newJObject()
  add(query_564261, "api-version", newJString(apiVersion))
  add(path_564260, "fabricName", newJString(fabricName))
  add(path_564260, "subscriptionId", newJString(subscriptionId))
  add(path_564260, "resourceGroupName", newJString(resourceGroupName))
  add(path_564260, "resourceName", newJString(resourceName))
  result = call_564259.call(path_564260, query_564261, nil, nil, nil)

var replicationFabricsDelete* = Call_ReplicationFabricsDelete_564250(
    name: "replicationFabricsDelete", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/remove",
    validator: validate_ReplicationFabricsDelete_564251, base: "",
    url: url_ReplicationFabricsDelete_564252, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsRenewCertificate_564262 = ref object of OpenApiRestCall_563564
proc url_ReplicationFabricsRenewCertificate_564264(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/renewCertificate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationFabricsRenewCertificate_564263(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Renews the connection certificate for the ASR replication fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : fabric name to renew certs for.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_564265 = path.getOrDefault("fabricName")
  valid_564265 = validateParameter(valid_564265, JString, required = true,
                                 default = nil)
  if valid_564265 != nil:
    section.add "fabricName", valid_564265
  var valid_564266 = path.getOrDefault("subscriptionId")
  valid_564266 = validateParameter(valid_564266, JString, required = true,
                                 default = nil)
  if valid_564266 != nil:
    section.add "subscriptionId", valid_564266
  var valid_564267 = path.getOrDefault("resourceGroupName")
  valid_564267 = validateParameter(valid_564267, JString, required = true,
                                 default = nil)
  if valid_564267 != nil:
    section.add "resourceGroupName", valid_564267
  var valid_564268 = path.getOrDefault("resourceName")
  valid_564268 = validateParameter(valid_564268, JString, required = true,
                                 default = nil)
  if valid_564268 != nil:
    section.add "resourceName", valid_564268
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564269 = query.getOrDefault("api-version")
  valid_564269 = validateParameter(valid_564269, JString, required = true,
                                 default = nil)
  if valid_564269 != nil:
    section.add "api-version", valid_564269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   renewCertificate: JObject (required)
  ##                   : Renew certificate input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564271: Call_ReplicationFabricsRenewCertificate_564262;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Renews the connection certificate for the ASR replication fabric.
  ## 
  let valid = call_564271.validator(path, query, header, formData, body)
  let scheme = call_564271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564271.url(scheme.get, call_564271.host, call_564271.base,
                         call_564271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564271, url, valid)

proc call*(call_564272: Call_ReplicationFabricsRenewCertificate_564262;
          apiVersion: string; renewCertificate: JsonNode; fabricName: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## replicationFabricsRenewCertificate
  ## Renews the connection certificate for the ASR replication fabric.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   renewCertificate: JObject (required)
  ##                   : Renew certificate input.
  ##   fabricName: string (required)
  ##             : fabric name to renew certs for.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564273 = newJObject()
  var query_564274 = newJObject()
  var body_564275 = newJObject()
  add(query_564274, "api-version", newJString(apiVersion))
  if renewCertificate != nil:
    body_564275 = renewCertificate
  add(path_564273, "fabricName", newJString(fabricName))
  add(path_564273, "subscriptionId", newJString(subscriptionId))
  add(path_564273, "resourceGroupName", newJString(resourceGroupName))
  add(path_564273, "resourceName", newJString(resourceName))
  result = call_564272.call(path_564273, query_564274, nil, nil, body_564275)

var replicationFabricsRenewCertificate* = Call_ReplicationFabricsRenewCertificate_564262(
    name: "replicationFabricsRenewCertificate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/renewCertificate",
    validator: validate_ReplicationFabricsRenewCertificate_564263, base: "",
    url: url_ReplicationFabricsRenewCertificate_564264, schemes: {Scheme.Https})
type
  Call_ReplicationLogicalNetworksListByReplicationFabrics_564276 = ref object of OpenApiRestCall_563564
proc url_ReplicationLogicalNetworksListByReplicationFabrics_564278(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/replicationLogicalNetworks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationLogicalNetworksListByReplicationFabrics_564277(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all the logical networks of the Azure Site Recovery fabric
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Server Id.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_564279 = path.getOrDefault("fabricName")
  valid_564279 = validateParameter(valid_564279, JString, required = true,
                                 default = nil)
  if valid_564279 != nil:
    section.add "fabricName", valid_564279
  var valid_564280 = path.getOrDefault("subscriptionId")
  valid_564280 = validateParameter(valid_564280, JString, required = true,
                                 default = nil)
  if valid_564280 != nil:
    section.add "subscriptionId", valid_564280
  var valid_564281 = path.getOrDefault("resourceGroupName")
  valid_564281 = validateParameter(valid_564281, JString, required = true,
                                 default = nil)
  if valid_564281 != nil:
    section.add "resourceGroupName", valid_564281
  var valid_564282 = path.getOrDefault("resourceName")
  valid_564282 = validateParameter(valid_564282, JString, required = true,
                                 default = nil)
  if valid_564282 != nil:
    section.add "resourceName", valid_564282
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564283 = query.getOrDefault("api-version")
  valid_564283 = validateParameter(valid_564283, JString, required = true,
                                 default = nil)
  if valid_564283 != nil:
    section.add "api-version", valid_564283
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564284: Call_ReplicationLogicalNetworksListByReplicationFabrics_564276;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the logical networks of the Azure Site Recovery fabric
  ## 
  let valid = call_564284.validator(path, query, header, formData, body)
  let scheme = call_564284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564284.url(scheme.get, call_564284.host, call_564284.base,
                         call_564284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564284, url, valid)

proc call*(call_564285: Call_ReplicationLogicalNetworksListByReplicationFabrics_564276;
          apiVersion: string; fabricName: string; subscriptionId: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## replicationLogicalNetworksListByReplicationFabrics
  ## Lists all the logical networks of the Azure Site Recovery fabric
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Server Id.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564286 = newJObject()
  var query_564287 = newJObject()
  add(query_564287, "api-version", newJString(apiVersion))
  add(path_564286, "fabricName", newJString(fabricName))
  add(path_564286, "subscriptionId", newJString(subscriptionId))
  add(path_564286, "resourceGroupName", newJString(resourceGroupName))
  add(path_564286, "resourceName", newJString(resourceName))
  result = call_564285.call(path_564286, query_564287, nil, nil, nil)

var replicationLogicalNetworksListByReplicationFabrics* = Call_ReplicationLogicalNetworksListByReplicationFabrics_564276(
    name: "replicationLogicalNetworksListByReplicationFabrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationLogicalNetworks",
    validator: validate_ReplicationLogicalNetworksListByReplicationFabrics_564277,
    base: "", url: url_ReplicationLogicalNetworksListByReplicationFabrics_564278,
    schemes: {Scheme.Https})
type
  Call_ReplicationLogicalNetworksGet_564288 = ref object of OpenApiRestCall_563564
proc url_ReplicationLogicalNetworksGet_564290(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "logicalNetworkName" in path,
        "`logicalNetworkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/replicationLogicalNetworks/"),
               (kind: VariableSegment, value: "logicalNetworkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationLogicalNetworksGet_564289(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of a logical network.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   logicalNetworkName: JString (required)
  ##                     : Logical network name.
  ##   fabricName: JString (required)
  ##             : Server Id.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `logicalNetworkName` field"
  var valid_564291 = path.getOrDefault("logicalNetworkName")
  valid_564291 = validateParameter(valid_564291, JString, required = true,
                                 default = nil)
  if valid_564291 != nil:
    section.add "logicalNetworkName", valid_564291
  var valid_564292 = path.getOrDefault("fabricName")
  valid_564292 = validateParameter(valid_564292, JString, required = true,
                                 default = nil)
  if valid_564292 != nil:
    section.add "fabricName", valid_564292
  var valid_564293 = path.getOrDefault("subscriptionId")
  valid_564293 = validateParameter(valid_564293, JString, required = true,
                                 default = nil)
  if valid_564293 != nil:
    section.add "subscriptionId", valid_564293
  var valid_564294 = path.getOrDefault("resourceGroupName")
  valid_564294 = validateParameter(valid_564294, JString, required = true,
                                 default = nil)
  if valid_564294 != nil:
    section.add "resourceGroupName", valid_564294
  var valid_564295 = path.getOrDefault("resourceName")
  valid_564295 = validateParameter(valid_564295, JString, required = true,
                                 default = nil)
  if valid_564295 != nil:
    section.add "resourceName", valid_564295
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564296 = query.getOrDefault("api-version")
  valid_564296 = validateParameter(valid_564296, JString, required = true,
                                 default = nil)
  if valid_564296 != nil:
    section.add "api-version", valid_564296
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564297: Call_ReplicationLogicalNetworksGet_564288; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a logical network.
  ## 
  let valid = call_564297.validator(path, query, header, formData, body)
  let scheme = call_564297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564297.url(scheme.get, call_564297.host, call_564297.base,
                         call_564297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564297, url, valid)

proc call*(call_564298: Call_ReplicationLogicalNetworksGet_564288;
          apiVersion: string; logicalNetworkName: string; fabricName: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## replicationLogicalNetworksGet
  ## Gets the details of a logical network.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   logicalNetworkName: string (required)
  ##                     : Logical network name.
  ##   fabricName: string (required)
  ##             : Server Id.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564299 = newJObject()
  var query_564300 = newJObject()
  add(query_564300, "api-version", newJString(apiVersion))
  add(path_564299, "logicalNetworkName", newJString(logicalNetworkName))
  add(path_564299, "fabricName", newJString(fabricName))
  add(path_564299, "subscriptionId", newJString(subscriptionId))
  add(path_564299, "resourceGroupName", newJString(resourceGroupName))
  add(path_564299, "resourceName", newJString(resourceName))
  result = call_564298.call(path_564299, query_564300, nil, nil, nil)

var replicationLogicalNetworksGet* = Call_ReplicationLogicalNetworksGet_564288(
    name: "replicationLogicalNetworksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationLogicalNetworks/{logicalNetworkName}",
    validator: validate_ReplicationLogicalNetworksGet_564289, base: "",
    url: url_ReplicationLogicalNetworksGet_564290, schemes: {Scheme.Https})
type
  Call_ReplicationNetworksListByReplicationFabrics_564301 = ref object of OpenApiRestCall_563564
proc url_ReplicationNetworksListByReplicationFabrics_564303(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/replicationNetworks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationNetworksListByReplicationFabrics_564302(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the networks available for a fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_564304 = path.getOrDefault("fabricName")
  valid_564304 = validateParameter(valid_564304, JString, required = true,
                                 default = nil)
  if valid_564304 != nil:
    section.add "fabricName", valid_564304
  var valid_564305 = path.getOrDefault("subscriptionId")
  valid_564305 = validateParameter(valid_564305, JString, required = true,
                                 default = nil)
  if valid_564305 != nil:
    section.add "subscriptionId", valid_564305
  var valid_564306 = path.getOrDefault("resourceGroupName")
  valid_564306 = validateParameter(valid_564306, JString, required = true,
                                 default = nil)
  if valid_564306 != nil:
    section.add "resourceGroupName", valid_564306
  var valid_564307 = path.getOrDefault("resourceName")
  valid_564307 = validateParameter(valid_564307, JString, required = true,
                                 default = nil)
  if valid_564307 != nil:
    section.add "resourceName", valid_564307
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564308 = query.getOrDefault("api-version")
  valid_564308 = validateParameter(valid_564308, JString, required = true,
                                 default = nil)
  if valid_564308 != nil:
    section.add "api-version", valid_564308
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564309: Call_ReplicationNetworksListByReplicationFabrics_564301;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the networks available for a fabric.
  ## 
  let valid = call_564309.validator(path, query, header, formData, body)
  let scheme = call_564309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564309.url(scheme.get, call_564309.host, call_564309.base,
                         call_564309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564309, url, valid)

proc call*(call_564310: Call_ReplicationNetworksListByReplicationFabrics_564301;
          apiVersion: string; fabricName: string; subscriptionId: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## replicationNetworksListByReplicationFabrics
  ## Lists the networks available for a fabric.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564311 = newJObject()
  var query_564312 = newJObject()
  add(query_564312, "api-version", newJString(apiVersion))
  add(path_564311, "fabricName", newJString(fabricName))
  add(path_564311, "subscriptionId", newJString(subscriptionId))
  add(path_564311, "resourceGroupName", newJString(resourceGroupName))
  add(path_564311, "resourceName", newJString(resourceName))
  result = call_564310.call(path_564311, query_564312, nil, nil, nil)

var replicationNetworksListByReplicationFabrics* = Call_ReplicationNetworksListByReplicationFabrics_564301(
    name: "replicationNetworksListByReplicationFabrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationNetworks",
    validator: validate_ReplicationNetworksListByReplicationFabrics_564302,
    base: "", url: url_ReplicationNetworksListByReplicationFabrics_564303,
    schemes: {Scheme.Https})
type
  Call_ReplicationNetworksGet_564313 = ref object of OpenApiRestCall_563564
proc url_ReplicationNetworksGet_564315(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "networkName" in path, "`networkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/replicationNetworks/"),
               (kind: VariableSegment, value: "networkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationNetworksGet_564314(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of a network.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkName: JString (required)
  ##              : Primary network name.
  ##   fabricName: JString (required)
  ##             : Server Id.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkName` field"
  var valid_564316 = path.getOrDefault("networkName")
  valid_564316 = validateParameter(valid_564316, JString, required = true,
                                 default = nil)
  if valid_564316 != nil:
    section.add "networkName", valid_564316
  var valid_564317 = path.getOrDefault("fabricName")
  valid_564317 = validateParameter(valid_564317, JString, required = true,
                                 default = nil)
  if valid_564317 != nil:
    section.add "fabricName", valid_564317
  var valid_564318 = path.getOrDefault("subscriptionId")
  valid_564318 = validateParameter(valid_564318, JString, required = true,
                                 default = nil)
  if valid_564318 != nil:
    section.add "subscriptionId", valid_564318
  var valid_564319 = path.getOrDefault("resourceGroupName")
  valid_564319 = validateParameter(valid_564319, JString, required = true,
                                 default = nil)
  if valid_564319 != nil:
    section.add "resourceGroupName", valid_564319
  var valid_564320 = path.getOrDefault("resourceName")
  valid_564320 = validateParameter(valid_564320, JString, required = true,
                                 default = nil)
  if valid_564320 != nil:
    section.add "resourceName", valid_564320
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564321 = query.getOrDefault("api-version")
  valid_564321 = validateParameter(valid_564321, JString, required = true,
                                 default = nil)
  if valid_564321 != nil:
    section.add "api-version", valid_564321
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564322: Call_ReplicationNetworksGet_564313; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a network.
  ## 
  let valid = call_564322.validator(path, query, header, formData, body)
  let scheme = call_564322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564322.url(scheme.get, call_564322.host, call_564322.base,
                         call_564322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564322, url, valid)

proc call*(call_564323: Call_ReplicationNetworksGet_564313; apiVersion: string;
          networkName: string; fabricName: string; subscriptionId: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## replicationNetworksGet
  ## Gets the details of a network.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   networkName: string (required)
  ##              : Primary network name.
  ##   fabricName: string (required)
  ##             : Server Id.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564324 = newJObject()
  var query_564325 = newJObject()
  add(query_564325, "api-version", newJString(apiVersion))
  add(path_564324, "networkName", newJString(networkName))
  add(path_564324, "fabricName", newJString(fabricName))
  add(path_564324, "subscriptionId", newJString(subscriptionId))
  add(path_564324, "resourceGroupName", newJString(resourceGroupName))
  add(path_564324, "resourceName", newJString(resourceName))
  result = call_564323.call(path_564324, query_564325, nil, nil, nil)

var replicationNetworksGet* = Call_ReplicationNetworksGet_564313(
    name: "replicationNetworksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationNetworks/{networkName}",
    validator: validate_ReplicationNetworksGet_564314, base: "",
    url: url_ReplicationNetworksGet_564315, schemes: {Scheme.Https})
type
  Call_ReplicationNetworkMappingsListByReplicationNetworks_564326 = ref object of OpenApiRestCall_563564
proc url_ReplicationNetworkMappingsListByReplicationNetworks_564328(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "networkName" in path, "`networkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/replicationNetworks/"),
               (kind: VariableSegment, value: "networkName"),
               (kind: ConstantSegment, value: "/replicationNetworkMappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationNetworkMappingsListByReplicationNetworks_564327(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all ASR network mappings for the specified network.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkName: JString (required)
  ##              : Primary network name.
  ##   fabricName: JString (required)
  ##             : Primary fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkName` field"
  var valid_564329 = path.getOrDefault("networkName")
  valid_564329 = validateParameter(valid_564329, JString, required = true,
                                 default = nil)
  if valid_564329 != nil:
    section.add "networkName", valid_564329
  var valid_564330 = path.getOrDefault("fabricName")
  valid_564330 = validateParameter(valid_564330, JString, required = true,
                                 default = nil)
  if valid_564330 != nil:
    section.add "fabricName", valid_564330
  var valid_564331 = path.getOrDefault("subscriptionId")
  valid_564331 = validateParameter(valid_564331, JString, required = true,
                                 default = nil)
  if valid_564331 != nil:
    section.add "subscriptionId", valid_564331
  var valid_564332 = path.getOrDefault("resourceGroupName")
  valid_564332 = validateParameter(valid_564332, JString, required = true,
                                 default = nil)
  if valid_564332 != nil:
    section.add "resourceGroupName", valid_564332
  var valid_564333 = path.getOrDefault("resourceName")
  valid_564333 = validateParameter(valid_564333, JString, required = true,
                                 default = nil)
  if valid_564333 != nil:
    section.add "resourceName", valid_564333
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564334 = query.getOrDefault("api-version")
  valid_564334 = validateParameter(valid_564334, JString, required = true,
                                 default = nil)
  if valid_564334 != nil:
    section.add "api-version", valid_564334
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564335: Call_ReplicationNetworkMappingsListByReplicationNetworks_564326;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all ASR network mappings for the specified network.
  ## 
  let valid = call_564335.validator(path, query, header, formData, body)
  let scheme = call_564335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564335.url(scheme.get, call_564335.host, call_564335.base,
                         call_564335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564335, url, valid)

proc call*(call_564336: Call_ReplicationNetworkMappingsListByReplicationNetworks_564326;
          apiVersion: string; networkName: string; fabricName: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## replicationNetworkMappingsListByReplicationNetworks
  ## Lists all ASR network mappings for the specified network.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   networkName: string (required)
  ##              : Primary network name.
  ##   fabricName: string (required)
  ##             : Primary fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564337 = newJObject()
  var query_564338 = newJObject()
  add(query_564338, "api-version", newJString(apiVersion))
  add(path_564337, "networkName", newJString(networkName))
  add(path_564337, "fabricName", newJString(fabricName))
  add(path_564337, "subscriptionId", newJString(subscriptionId))
  add(path_564337, "resourceGroupName", newJString(resourceGroupName))
  add(path_564337, "resourceName", newJString(resourceName))
  result = call_564336.call(path_564337, query_564338, nil, nil, nil)

var replicationNetworkMappingsListByReplicationNetworks* = Call_ReplicationNetworkMappingsListByReplicationNetworks_564326(
    name: "replicationNetworkMappingsListByReplicationNetworks",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationNetworks/{networkName}/replicationNetworkMappings",
    validator: validate_ReplicationNetworkMappingsListByReplicationNetworks_564327,
    base: "", url: url_ReplicationNetworkMappingsListByReplicationNetworks_564328,
    schemes: {Scheme.Https})
type
  Call_ReplicationNetworkMappingsCreate_564353 = ref object of OpenApiRestCall_563564
proc url_ReplicationNetworkMappingsCreate_564355(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "networkName" in path, "`networkName` is a required path parameter"
  assert "networkMappingName" in path,
        "`networkMappingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/replicationNetworks/"),
               (kind: VariableSegment, value: "networkName"),
               (kind: ConstantSegment, value: "/replicationNetworkMappings/"),
               (kind: VariableSegment, value: "networkMappingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationNetworkMappingsCreate_564354(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create an ASR network mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkMappingName: JString (required)
  ##                     : Network mapping name.
  ##   networkName: JString (required)
  ##              : Primary network name.
  ##   fabricName: JString (required)
  ##             : Primary fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkMappingName` field"
  var valid_564356 = path.getOrDefault("networkMappingName")
  valid_564356 = validateParameter(valid_564356, JString, required = true,
                                 default = nil)
  if valid_564356 != nil:
    section.add "networkMappingName", valid_564356
  var valid_564357 = path.getOrDefault("networkName")
  valid_564357 = validateParameter(valid_564357, JString, required = true,
                                 default = nil)
  if valid_564357 != nil:
    section.add "networkName", valid_564357
  var valid_564358 = path.getOrDefault("fabricName")
  valid_564358 = validateParameter(valid_564358, JString, required = true,
                                 default = nil)
  if valid_564358 != nil:
    section.add "fabricName", valid_564358
  var valid_564359 = path.getOrDefault("subscriptionId")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = nil)
  if valid_564359 != nil:
    section.add "subscriptionId", valid_564359
  var valid_564360 = path.getOrDefault("resourceGroupName")
  valid_564360 = validateParameter(valid_564360, JString, required = true,
                                 default = nil)
  if valid_564360 != nil:
    section.add "resourceGroupName", valid_564360
  var valid_564361 = path.getOrDefault("resourceName")
  valid_564361 = validateParameter(valid_564361, JString, required = true,
                                 default = nil)
  if valid_564361 != nil:
    section.add "resourceName", valid_564361
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564362 = query.getOrDefault("api-version")
  valid_564362 = validateParameter(valid_564362, JString, required = true,
                                 default = nil)
  if valid_564362 != nil:
    section.add "api-version", valid_564362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Create network mapping input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564364: Call_ReplicationNetworkMappingsCreate_564353;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create an ASR network mapping.
  ## 
  let valid = call_564364.validator(path, query, header, formData, body)
  let scheme = call_564364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564364.url(scheme.get, call_564364.host, call_564364.base,
                         call_564364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564364, url, valid)

proc call*(call_564365: Call_ReplicationNetworkMappingsCreate_564353;
          networkMappingName: string; apiVersion: string; input: JsonNode;
          networkName: string; fabricName: string; subscriptionId: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## replicationNetworkMappingsCreate
  ## The operation to create an ASR network mapping.
  ##   networkMappingName: string (required)
  ##                     : Network mapping name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   input: JObject (required)
  ##        : Create network mapping input.
  ##   networkName: string (required)
  ##              : Primary network name.
  ##   fabricName: string (required)
  ##             : Primary fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564366 = newJObject()
  var query_564367 = newJObject()
  var body_564368 = newJObject()
  add(path_564366, "networkMappingName", newJString(networkMappingName))
  add(query_564367, "api-version", newJString(apiVersion))
  if input != nil:
    body_564368 = input
  add(path_564366, "networkName", newJString(networkName))
  add(path_564366, "fabricName", newJString(fabricName))
  add(path_564366, "subscriptionId", newJString(subscriptionId))
  add(path_564366, "resourceGroupName", newJString(resourceGroupName))
  add(path_564366, "resourceName", newJString(resourceName))
  result = call_564365.call(path_564366, query_564367, nil, nil, body_564368)

var replicationNetworkMappingsCreate* = Call_ReplicationNetworkMappingsCreate_564353(
    name: "replicationNetworkMappingsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationNetworks/{networkName}/replicationNetworkMappings/{networkMappingName}",
    validator: validate_ReplicationNetworkMappingsCreate_564354, base: "",
    url: url_ReplicationNetworkMappingsCreate_564355, schemes: {Scheme.Https})
type
  Call_ReplicationNetworkMappingsGet_564339 = ref object of OpenApiRestCall_563564
proc url_ReplicationNetworkMappingsGet_564341(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "networkName" in path, "`networkName` is a required path parameter"
  assert "networkMappingName" in path,
        "`networkMappingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/replicationNetworks/"),
               (kind: VariableSegment, value: "networkName"),
               (kind: ConstantSegment, value: "/replicationNetworkMappings/"),
               (kind: VariableSegment, value: "networkMappingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationNetworkMappingsGet_564340(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of an ASR network mapping
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkMappingName: JString (required)
  ##                     : Network mapping name.
  ##   networkName: JString (required)
  ##              : Primary network name.
  ##   fabricName: JString (required)
  ##             : Primary fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkMappingName` field"
  var valid_564342 = path.getOrDefault("networkMappingName")
  valid_564342 = validateParameter(valid_564342, JString, required = true,
                                 default = nil)
  if valid_564342 != nil:
    section.add "networkMappingName", valid_564342
  var valid_564343 = path.getOrDefault("networkName")
  valid_564343 = validateParameter(valid_564343, JString, required = true,
                                 default = nil)
  if valid_564343 != nil:
    section.add "networkName", valid_564343
  var valid_564344 = path.getOrDefault("fabricName")
  valid_564344 = validateParameter(valid_564344, JString, required = true,
                                 default = nil)
  if valid_564344 != nil:
    section.add "fabricName", valid_564344
  var valid_564345 = path.getOrDefault("subscriptionId")
  valid_564345 = validateParameter(valid_564345, JString, required = true,
                                 default = nil)
  if valid_564345 != nil:
    section.add "subscriptionId", valid_564345
  var valid_564346 = path.getOrDefault("resourceGroupName")
  valid_564346 = validateParameter(valid_564346, JString, required = true,
                                 default = nil)
  if valid_564346 != nil:
    section.add "resourceGroupName", valid_564346
  var valid_564347 = path.getOrDefault("resourceName")
  valid_564347 = validateParameter(valid_564347, JString, required = true,
                                 default = nil)
  if valid_564347 != nil:
    section.add "resourceName", valid_564347
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564348 = query.getOrDefault("api-version")
  valid_564348 = validateParameter(valid_564348, JString, required = true,
                                 default = nil)
  if valid_564348 != nil:
    section.add "api-version", valid_564348
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564349: Call_ReplicationNetworkMappingsGet_564339; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of an ASR network mapping
  ## 
  let valid = call_564349.validator(path, query, header, formData, body)
  let scheme = call_564349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564349.url(scheme.get, call_564349.host, call_564349.base,
                         call_564349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564349, url, valid)

proc call*(call_564350: Call_ReplicationNetworkMappingsGet_564339;
          networkMappingName: string; apiVersion: string; networkName: string;
          fabricName: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## replicationNetworkMappingsGet
  ## Gets the details of an ASR network mapping
  ##   networkMappingName: string (required)
  ##                     : Network mapping name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   networkName: string (required)
  ##              : Primary network name.
  ##   fabricName: string (required)
  ##             : Primary fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564351 = newJObject()
  var query_564352 = newJObject()
  add(path_564351, "networkMappingName", newJString(networkMappingName))
  add(query_564352, "api-version", newJString(apiVersion))
  add(path_564351, "networkName", newJString(networkName))
  add(path_564351, "fabricName", newJString(fabricName))
  add(path_564351, "subscriptionId", newJString(subscriptionId))
  add(path_564351, "resourceGroupName", newJString(resourceGroupName))
  add(path_564351, "resourceName", newJString(resourceName))
  result = call_564350.call(path_564351, query_564352, nil, nil, nil)

var replicationNetworkMappingsGet* = Call_ReplicationNetworkMappingsGet_564339(
    name: "replicationNetworkMappingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationNetworks/{networkName}/replicationNetworkMappings/{networkMappingName}",
    validator: validate_ReplicationNetworkMappingsGet_564340, base: "",
    url: url_ReplicationNetworkMappingsGet_564341, schemes: {Scheme.Https})
type
  Call_ReplicationNetworkMappingsUpdate_564383 = ref object of OpenApiRestCall_563564
proc url_ReplicationNetworkMappingsUpdate_564385(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "networkName" in path, "`networkName` is a required path parameter"
  assert "networkMappingName" in path,
        "`networkMappingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/replicationNetworks/"),
               (kind: VariableSegment, value: "networkName"),
               (kind: ConstantSegment, value: "/replicationNetworkMappings/"),
               (kind: VariableSegment, value: "networkMappingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationNetworkMappingsUpdate_564384(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update an ASR network mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkMappingName: JString (required)
  ##                     : Network mapping name.
  ##   networkName: JString (required)
  ##              : Primary network name.
  ##   fabricName: JString (required)
  ##             : Primary fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkMappingName` field"
  var valid_564386 = path.getOrDefault("networkMappingName")
  valid_564386 = validateParameter(valid_564386, JString, required = true,
                                 default = nil)
  if valid_564386 != nil:
    section.add "networkMappingName", valid_564386
  var valid_564387 = path.getOrDefault("networkName")
  valid_564387 = validateParameter(valid_564387, JString, required = true,
                                 default = nil)
  if valid_564387 != nil:
    section.add "networkName", valid_564387
  var valid_564388 = path.getOrDefault("fabricName")
  valid_564388 = validateParameter(valid_564388, JString, required = true,
                                 default = nil)
  if valid_564388 != nil:
    section.add "fabricName", valid_564388
  var valid_564389 = path.getOrDefault("subscriptionId")
  valid_564389 = validateParameter(valid_564389, JString, required = true,
                                 default = nil)
  if valid_564389 != nil:
    section.add "subscriptionId", valid_564389
  var valid_564390 = path.getOrDefault("resourceGroupName")
  valid_564390 = validateParameter(valid_564390, JString, required = true,
                                 default = nil)
  if valid_564390 != nil:
    section.add "resourceGroupName", valid_564390
  var valid_564391 = path.getOrDefault("resourceName")
  valid_564391 = validateParameter(valid_564391, JString, required = true,
                                 default = nil)
  if valid_564391 != nil:
    section.add "resourceName", valid_564391
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564392 = query.getOrDefault("api-version")
  valid_564392 = validateParameter(valid_564392, JString, required = true,
                                 default = nil)
  if valid_564392 != nil:
    section.add "api-version", valid_564392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Update network mapping input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564394: Call_ReplicationNetworkMappingsUpdate_564383;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to update an ASR network mapping.
  ## 
  let valid = call_564394.validator(path, query, header, formData, body)
  let scheme = call_564394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564394.url(scheme.get, call_564394.host, call_564394.base,
                         call_564394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564394, url, valid)

proc call*(call_564395: Call_ReplicationNetworkMappingsUpdate_564383;
          networkMappingName: string; apiVersion: string; input: JsonNode;
          networkName: string; fabricName: string; subscriptionId: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## replicationNetworkMappingsUpdate
  ## The operation to update an ASR network mapping.
  ##   networkMappingName: string (required)
  ##                     : Network mapping name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   input: JObject (required)
  ##        : Update network mapping input.
  ##   networkName: string (required)
  ##              : Primary network name.
  ##   fabricName: string (required)
  ##             : Primary fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564396 = newJObject()
  var query_564397 = newJObject()
  var body_564398 = newJObject()
  add(path_564396, "networkMappingName", newJString(networkMappingName))
  add(query_564397, "api-version", newJString(apiVersion))
  if input != nil:
    body_564398 = input
  add(path_564396, "networkName", newJString(networkName))
  add(path_564396, "fabricName", newJString(fabricName))
  add(path_564396, "subscriptionId", newJString(subscriptionId))
  add(path_564396, "resourceGroupName", newJString(resourceGroupName))
  add(path_564396, "resourceName", newJString(resourceName))
  result = call_564395.call(path_564396, query_564397, nil, nil, body_564398)

var replicationNetworkMappingsUpdate* = Call_ReplicationNetworkMappingsUpdate_564383(
    name: "replicationNetworkMappingsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationNetworks/{networkName}/replicationNetworkMappings/{networkMappingName}",
    validator: validate_ReplicationNetworkMappingsUpdate_564384, base: "",
    url: url_ReplicationNetworkMappingsUpdate_564385, schemes: {Scheme.Https})
type
  Call_ReplicationNetworkMappingsDelete_564369 = ref object of OpenApiRestCall_563564
proc url_ReplicationNetworkMappingsDelete_564371(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "networkName" in path, "`networkName` is a required path parameter"
  assert "networkMappingName" in path,
        "`networkMappingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/replicationNetworks/"),
               (kind: VariableSegment, value: "networkName"),
               (kind: ConstantSegment, value: "/replicationNetworkMappings/"),
               (kind: VariableSegment, value: "networkMappingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationNetworkMappingsDelete_564370(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete a network mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkMappingName: JString (required)
  ##                     : ARM Resource Name for network mapping.
  ##   networkName: JString (required)
  ##              : Primary network name.
  ##   fabricName: JString (required)
  ##             : Primary fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkMappingName` field"
  var valid_564372 = path.getOrDefault("networkMappingName")
  valid_564372 = validateParameter(valid_564372, JString, required = true,
                                 default = nil)
  if valid_564372 != nil:
    section.add "networkMappingName", valid_564372
  var valid_564373 = path.getOrDefault("networkName")
  valid_564373 = validateParameter(valid_564373, JString, required = true,
                                 default = nil)
  if valid_564373 != nil:
    section.add "networkName", valid_564373
  var valid_564374 = path.getOrDefault("fabricName")
  valid_564374 = validateParameter(valid_564374, JString, required = true,
                                 default = nil)
  if valid_564374 != nil:
    section.add "fabricName", valid_564374
  var valid_564375 = path.getOrDefault("subscriptionId")
  valid_564375 = validateParameter(valid_564375, JString, required = true,
                                 default = nil)
  if valid_564375 != nil:
    section.add "subscriptionId", valid_564375
  var valid_564376 = path.getOrDefault("resourceGroupName")
  valid_564376 = validateParameter(valid_564376, JString, required = true,
                                 default = nil)
  if valid_564376 != nil:
    section.add "resourceGroupName", valid_564376
  var valid_564377 = path.getOrDefault("resourceName")
  valid_564377 = validateParameter(valid_564377, JString, required = true,
                                 default = nil)
  if valid_564377 != nil:
    section.add "resourceName", valid_564377
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564378 = query.getOrDefault("api-version")
  valid_564378 = validateParameter(valid_564378, JString, required = true,
                                 default = nil)
  if valid_564378 != nil:
    section.add "api-version", valid_564378
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564379: Call_ReplicationNetworkMappingsDelete_564369;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete a network mapping.
  ## 
  let valid = call_564379.validator(path, query, header, formData, body)
  let scheme = call_564379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564379.url(scheme.get, call_564379.host, call_564379.base,
                         call_564379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564379, url, valid)

proc call*(call_564380: Call_ReplicationNetworkMappingsDelete_564369;
          networkMappingName: string; apiVersion: string; networkName: string;
          fabricName: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## replicationNetworkMappingsDelete
  ## The operation to delete a network mapping.
  ##   networkMappingName: string (required)
  ##                     : ARM Resource Name for network mapping.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   networkName: string (required)
  ##              : Primary network name.
  ##   fabricName: string (required)
  ##             : Primary fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564381 = newJObject()
  var query_564382 = newJObject()
  add(path_564381, "networkMappingName", newJString(networkMappingName))
  add(query_564382, "api-version", newJString(apiVersion))
  add(path_564381, "networkName", newJString(networkName))
  add(path_564381, "fabricName", newJString(fabricName))
  add(path_564381, "subscriptionId", newJString(subscriptionId))
  add(path_564381, "resourceGroupName", newJString(resourceGroupName))
  add(path_564381, "resourceName", newJString(resourceName))
  result = call_564380.call(path_564381, query_564382, nil, nil, nil)

var replicationNetworkMappingsDelete* = Call_ReplicationNetworkMappingsDelete_564369(
    name: "replicationNetworkMappingsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationNetworks/{networkName}/replicationNetworkMappings/{networkMappingName}",
    validator: validate_ReplicationNetworkMappingsDelete_564370, base: "",
    url: url_ReplicationNetworkMappingsDelete_564371, schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersListByReplicationFabrics_564399 = ref object of OpenApiRestCall_563564
proc url_ReplicationProtectionContainersListByReplicationFabrics_564401(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectionContainersListByReplicationFabrics_564400(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the protection containers in the specified fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_564402 = path.getOrDefault("fabricName")
  valid_564402 = validateParameter(valid_564402, JString, required = true,
                                 default = nil)
  if valid_564402 != nil:
    section.add "fabricName", valid_564402
  var valid_564403 = path.getOrDefault("subscriptionId")
  valid_564403 = validateParameter(valid_564403, JString, required = true,
                                 default = nil)
  if valid_564403 != nil:
    section.add "subscriptionId", valid_564403
  var valid_564404 = path.getOrDefault("resourceGroupName")
  valid_564404 = validateParameter(valid_564404, JString, required = true,
                                 default = nil)
  if valid_564404 != nil:
    section.add "resourceGroupName", valid_564404
  var valid_564405 = path.getOrDefault("resourceName")
  valid_564405 = validateParameter(valid_564405, JString, required = true,
                                 default = nil)
  if valid_564405 != nil:
    section.add "resourceName", valid_564405
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564406 = query.getOrDefault("api-version")
  valid_564406 = validateParameter(valid_564406, JString, required = true,
                                 default = nil)
  if valid_564406 != nil:
    section.add "api-version", valid_564406
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564407: Call_ReplicationProtectionContainersListByReplicationFabrics_564399;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the protection containers in the specified fabric.
  ## 
  let valid = call_564407.validator(path, query, header, formData, body)
  let scheme = call_564407.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564407.url(scheme.get, call_564407.host, call_564407.base,
                         call_564407.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564407, url, valid)

proc call*(call_564408: Call_ReplicationProtectionContainersListByReplicationFabrics_564399;
          apiVersion: string; fabricName: string; subscriptionId: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## replicationProtectionContainersListByReplicationFabrics
  ## Lists the protection containers in the specified fabric.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564409 = newJObject()
  var query_564410 = newJObject()
  add(query_564410, "api-version", newJString(apiVersion))
  add(path_564409, "fabricName", newJString(fabricName))
  add(path_564409, "subscriptionId", newJString(subscriptionId))
  add(path_564409, "resourceGroupName", newJString(resourceGroupName))
  add(path_564409, "resourceName", newJString(resourceName))
  result = call_564408.call(path_564409, query_564410, nil, nil, nil)

var replicationProtectionContainersListByReplicationFabrics* = Call_ReplicationProtectionContainersListByReplicationFabrics_564399(
    name: "replicationProtectionContainersListByReplicationFabrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers", validator: validate_ReplicationProtectionContainersListByReplicationFabrics_564400,
    base: "", url: url_ReplicationProtectionContainersListByReplicationFabrics_564401,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersCreate_564424 = ref object of OpenApiRestCall_563564
proc url_ReplicationProtectionContainersCreate_564426(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectionContainersCreate_564425(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Operation to create a protection container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   protectionContainerName: JString (required)
  ##                          : Unique protection container ARM name.
  ##   fabricName: JString (required)
  ##             : Unique fabric ARM name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564427 = path.getOrDefault("protectionContainerName")
  valid_564427 = validateParameter(valid_564427, JString, required = true,
                                 default = nil)
  if valid_564427 != nil:
    section.add "protectionContainerName", valid_564427
  var valid_564428 = path.getOrDefault("fabricName")
  valid_564428 = validateParameter(valid_564428, JString, required = true,
                                 default = nil)
  if valid_564428 != nil:
    section.add "fabricName", valid_564428
  var valid_564429 = path.getOrDefault("subscriptionId")
  valid_564429 = validateParameter(valid_564429, JString, required = true,
                                 default = nil)
  if valid_564429 != nil:
    section.add "subscriptionId", valid_564429
  var valid_564430 = path.getOrDefault("resourceGroupName")
  valid_564430 = validateParameter(valid_564430, JString, required = true,
                                 default = nil)
  if valid_564430 != nil:
    section.add "resourceGroupName", valid_564430
  var valid_564431 = path.getOrDefault("resourceName")
  valid_564431 = validateParameter(valid_564431, JString, required = true,
                                 default = nil)
  if valid_564431 != nil:
    section.add "resourceName", valid_564431
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564432 = query.getOrDefault("api-version")
  valid_564432 = validateParameter(valid_564432, JString, required = true,
                                 default = nil)
  if valid_564432 != nil:
    section.add "api-version", valid_564432
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   creationInput: JObject (required)
  ##                : Creation input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564434: Call_ReplicationProtectionContainersCreate_564424;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to create a protection container.
  ## 
  let valid = call_564434.validator(path, query, header, formData, body)
  let scheme = call_564434.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564434.url(scheme.get, call_564434.host, call_564434.base,
                         call_564434.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564434, url, valid)

proc call*(call_564435: Call_ReplicationProtectionContainersCreate_564424;
          protectionContainerName: string; apiVersion: string;
          creationInput: JsonNode; fabricName: string; subscriptionId: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## replicationProtectionContainersCreate
  ## Operation to create a protection container.
  ##   protectionContainerName: string (required)
  ##                          : Unique protection container ARM name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   creationInput: JObject (required)
  ##                : Creation input.
  ##   fabricName: string (required)
  ##             : Unique fabric ARM name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564436 = newJObject()
  var query_564437 = newJObject()
  var body_564438 = newJObject()
  add(path_564436, "protectionContainerName", newJString(protectionContainerName))
  add(query_564437, "api-version", newJString(apiVersion))
  if creationInput != nil:
    body_564438 = creationInput
  add(path_564436, "fabricName", newJString(fabricName))
  add(path_564436, "subscriptionId", newJString(subscriptionId))
  add(path_564436, "resourceGroupName", newJString(resourceGroupName))
  add(path_564436, "resourceName", newJString(resourceName))
  result = call_564435.call(path_564436, query_564437, nil, nil, body_564438)

var replicationProtectionContainersCreate* = Call_ReplicationProtectionContainersCreate_564424(
    name: "replicationProtectionContainersCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}",
    validator: validate_ReplicationProtectionContainersCreate_564425, base: "",
    url: url_ReplicationProtectionContainersCreate_564426, schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersGet_564411 = ref object of OpenApiRestCall_563564
proc url_ReplicationProtectionContainersGet_564413(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectionContainersGet_564412(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of a protection container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564414 = path.getOrDefault("protectionContainerName")
  valid_564414 = validateParameter(valid_564414, JString, required = true,
                                 default = nil)
  if valid_564414 != nil:
    section.add "protectionContainerName", valid_564414
  var valid_564415 = path.getOrDefault("fabricName")
  valid_564415 = validateParameter(valid_564415, JString, required = true,
                                 default = nil)
  if valid_564415 != nil:
    section.add "fabricName", valid_564415
  var valid_564416 = path.getOrDefault("subscriptionId")
  valid_564416 = validateParameter(valid_564416, JString, required = true,
                                 default = nil)
  if valid_564416 != nil:
    section.add "subscriptionId", valid_564416
  var valid_564417 = path.getOrDefault("resourceGroupName")
  valid_564417 = validateParameter(valid_564417, JString, required = true,
                                 default = nil)
  if valid_564417 != nil:
    section.add "resourceGroupName", valid_564417
  var valid_564418 = path.getOrDefault("resourceName")
  valid_564418 = validateParameter(valid_564418, JString, required = true,
                                 default = nil)
  if valid_564418 != nil:
    section.add "resourceName", valid_564418
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564419 = query.getOrDefault("api-version")
  valid_564419 = validateParameter(valid_564419, JString, required = true,
                                 default = nil)
  if valid_564419 != nil:
    section.add "api-version", valid_564419
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564420: Call_ReplicationProtectionContainersGet_564411;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of a protection container.
  ## 
  let valid = call_564420.validator(path, query, header, formData, body)
  let scheme = call_564420.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564420.url(scheme.get, call_564420.host, call_564420.base,
                         call_564420.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564420, url, valid)

proc call*(call_564421: Call_ReplicationProtectionContainersGet_564411;
          protectionContainerName: string; apiVersion: string; fabricName: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## replicationProtectionContainersGet
  ## Gets the details of a protection container.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564422 = newJObject()
  var query_564423 = newJObject()
  add(path_564422, "protectionContainerName", newJString(protectionContainerName))
  add(query_564423, "api-version", newJString(apiVersion))
  add(path_564422, "fabricName", newJString(fabricName))
  add(path_564422, "subscriptionId", newJString(subscriptionId))
  add(path_564422, "resourceGroupName", newJString(resourceGroupName))
  add(path_564422, "resourceName", newJString(resourceName))
  result = call_564421.call(path_564422, query_564423, nil, nil, nil)

var replicationProtectionContainersGet* = Call_ReplicationProtectionContainersGet_564411(
    name: "replicationProtectionContainersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}",
    validator: validate_ReplicationProtectionContainersGet_564412, base: "",
    url: url_ReplicationProtectionContainersGet_564413, schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersDiscoverProtectableItem_564439 = ref object of OpenApiRestCall_563564
proc url_ReplicationProtectionContainersDiscoverProtectableItem_564441(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/discoverProtectableItem")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectionContainersDiscoverProtectableItem_564440(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The operation to a add a protectable item to a protection container(Add physical server.)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   protectionContainerName: JString (required)
  ##                          : The name of the protection container.
  ##   fabricName: JString (required)
  ##             : The name of the fabric.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564442 = path.getOrDefault("protectionContainerName")
  valid_564442 = validateParameter(valid_564442, JString, required = true,
                                 default = nil)
  if valid_564442 != nil:
    section.add "protectionContainerName", valid_564442
  var valid_564443 = path.getOrDefault("fabricName")
  valid_564443 = validateParameter(valid_564443, JString, required = true,
                                 default = nil)
  if valid_564443 != nil:
    section.add "fabricName", valid_564443
  var valid_564444 = path.getOrDefault("subscriptionId")
  valid_564444 = validateParameter(valid_564444, JString, required = true,
                                 default = nil)
  if valid_564444 != nil:
    section.add "subscriptionId", valid_564444
  var valid_564445 = path.getOrDefault("resourceGroupName")
  valid_564445 = validateParameter(valid_564445, JString, required = true,
                                 default = nil)
  if valid_564445 != nil:
    section.add "resourceGroupName", valid_564445
  var valid_564446 = path.getOrDefault("resourceName")
  valid_564446 = validateParameter(valid_564446, JString, required = true,
                                 default = nil)
  if valid_564446 != nil:
    section.add "resourceName", valid_564446
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564447 = query.getOrDefault("api-version")
  valid_564447 = validateParameter(valid_564447, JString, required = true,
                                 default = nil)
  if valid_564447 != nil:
    section.add "api-version", valid_564447
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   discoverProtectableItemRequest: JObject (required)
  ##                                 : The request object to add a protectable item.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564449: Call_ReplicationProtectionContainersDiscoverProtectableItem_564439;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to a add a protectable item to a protection container(Add physical server.)
  ## 
  let valid = call_564449.validator(path, query, header, formData, body)
  let scheme = call_564449.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564449.url(scheme.get, call_564449.host, call_564449.base,
                         call_564449.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564449, url, valid)

proc call*(call_564450: Call_ReplicationProtectionContainersDiscoverProtectableItem_564439;
          protectionContainerName: string; apiVersion: string; fabricName: string;
          subscriptionId: string; discoverProtectableItemRequest: JsonNode;
          resourceGroupName: string; resourceName: string): Recallable =
  ## replicationProtectionContainersDiscoverProtectableItem
  ## The operation to a add a protectable item to a protection container(Add physical server.)
  ##   protectionContainerName: string (required)
  ##                          : The name of the protection container.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : The name of the fabric.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   discoverProtectableItemRequest: JObject (required)
  ##                                 : The request object to add a protectable item.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564451 = newJObject()
  var query_564452 = newJObject()
  var body_564453 = newJObject()
  add(path_564451, "protectionContainerName", newJString(protectionContainerName))
  add(query_564452, "api-version", newJString(apiVersion))
  add(path_564451, "fabricName", newJString(fabricName))
  add(path_564451, "subscriptionId", newJString(subscriptionId))
  if discoverProtectableItemRequest != nil:
    body_564453 = discoverProtectableItemRequest
  add(path_564451, "resourceGroupName", newJString(resourceGroupName))
  add(path_564451, "resourceName", newJString(resourceName))
  result = call_564450.call(path_564451, query_564452, nil, nil, body_564453)

var replicationProtectionContainersDiscoverProtectableItem* = Call_ReplicationProtectionContainersDiscoverProtectableItem_564439(
    name: "replicationProtectionContainersDiscoverProtectableItem",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/discoverProtectableItem",
    validator: validate_ReplicationProtectionContainersDiscoverProtectableItem_564440,
    base: "", url: url_ReplicationProtectionContainersDiscoverProtectableItem_564441,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersDelete_564454 = ref object of OpenApiRestCall_563564
proc url_ReplicationProtectionContainersDelete_564456(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/remove")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectionContainersDelete_564455(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Operation to remove a protection container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   protectionContainerName: JString (required)
  ##                          : Unique protection container ARM name.
  ##   fabricName: JString (required)
  ##             : Unique fabric ARM name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564457 = path.getOrDefault("protectionContainerName")
  valid_564457 = validateParameter(valid_564457, JString, required = true,
                                 default = nil)
  if valid_564457 != nil:
    section.add "protectionContainerName", valid_564457
  var valid_564458 = path.getOrDefault("fabricName")
  valid_564458 = validateParameter(valid_564458, JString, required = true,
                                 default = nil)
  if valid_564458 != nil:
    section.add "fabricName", valid_564458
  var valid_564459 = path.getOrDefault("subscriptionId")
  valid_564459 = validateParameter(valid_564459, JString, required = true,
                                 default = nil)
  if valid_564459 != nil:
    section.add "subscriptionId", valid_564459
  var valid_564460 = path.getOrDefault("resourceGroupName")
  valid_564460 = validateParameter(valid_564460, JString, required = true,
                                 default = nil)
  if valid_564460 != nil:
    section.add "resourceGroupName", valid_564460
  var valid_564461 = path.getOrDefault("resourceName")
  valid_564461 = validateParameter(valid_564461, JString, required = true,
                                 default = nil)
  if valid_564461 != nil:
    section.add "resourceName", valid_564461
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564462 = query.getOrDefault("api-version")
  valid_564462 = validateParameter(valid_564462, JString, required = true,
                                 default = nil)
  if valid_564462 != nil:
    section.add "api-version", valid_564462
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564463: Call_ReplicationProtectionContainersDelete_564454;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to remove a protection container.
  ## 
  let valid = call_564463.validator(path, query, header, formData, body)
  let scheme = call_564463.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564463.url(scheme.get, call_564463.host, call_564463.base,
                         call_564463.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564463, url, valid)

proc call*(call_564464: Call_ReplicationProtectionContainersDelete_564454;
          protectionContainerName: string; apiVersion: string; fabricName: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## replicationProtectionContainersDelete
  ## Operation to remove a protection container.
  ##   protectionContainerName: string (required)
  ##                          : Unique protection container ARM name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Unique fabric ARM name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564465 = newJObject()
  var query_564466 = newJObject()
  add(path_564465, "protectionContainerName", newJString(protectionContainerName))
  add(query_564466, "api-version", newJString(apiVersion))
  add(path_564465, "fabricName", newJString(fabricName))
  add(path_564465, "subscriptionId", newJString(subscriptionId))
  add(path_564465, "resourceGroupName", newJString(resourceGroupName))
  add(path_564465, "resourceName", newJString(resourceName))
  result = call_564464.call(path_564465, query_564466, nil, nil, nil)

var replicationProtectionContainersDelete* = Call_ReplicationProtectionContainersDelete_564454(
    name: "replicationProtectionContainersDelete", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/remove",
    validator: validate_ReplicationProtectionContainersDelete_564455, base: "",
    url: url_ReplicationProtectionContainersDelete_564456, schemes: {Scheme.Https})
type
  Call_ReplicationProtectableItemsListByReplicationProtectionContainers_564467 = ref object of OpenApiRestCall_563564
proc url_ReplicationProtectableItemsListByReplicationProtectionContainers_564469(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectableItems")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectableItemsListByReplicationProtectionContainers_564468(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the protectable items in a protection container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564470 = path.getOrDefault("protectionContainerName")
  valid_564470 = validateParameter(valid_564470, JString, required = true,
                                 default = nil)
  if valid_564470 != nil:
    section.add "protectionContainerName", valid_564470
  var valid_564471 = path.getOrDefault("fabricName")
  valid_564471 = validateParameter(valid_564471, JString, required = true,
                                 default = nil)
  if valid_564471 != nil:
    section.add "fabricName", valid_564471
  var valid_564472 = path.getOrDefault("subscriptionId")
  valid_564472 = validateParameter(valid_564472, JString, required = true,
                                 default = nil)
  if valid_564472 != nil:
    section.add "subscriptionId", valid_564472
  var valid_564473 = path.getOrDefault("resourceGroupName")
  valid_564473 = validateParameter(valid_564473, JString, required = true,
                                 default = nil)
  if valid_564473 != nil:
    section.add "resourceGroupName", valid_564473
  var valid_564474 = path.getOrDefault("resourceName")
  valid_564474 = validateParameter(valid_564474, JString, required = true,
                                 default = nil)
  if valid_564474 != nil:
    section.add "resourceName", valid_564474
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564475 = query.getOrDefault("api-version")
  valid_564475 = validateParameter(valid_564475, JString, required = true,
                                 default = nil)
  if valid_564475 != nil:
    section.add "api-version", valid_564475
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564476: Call_ReplicationProtectableItemsListByReplicationProtectionContainers_564467;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the protectable items in a protection container.
  ## 
  let valid = call_564476.validator(path, query, header, formData, body)
  let scheme = call_564476.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564476.url(scheme.get, call_564476.host, call_564476.base,
                         call_564476.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564476, url, valid)

proc call*(call_564477: Call_ReplicationProtectableItemsListByReplicationProtectionContainers_564467;
          protectionContainerName: string; apiVersion: string; fabricName: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## replicationProtectableItemsListByReplicationProtectionContainers
  ## Lists the protectable items in a protection container.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564478 = newJObject()
  var query_564479 = newJObject()
  add(path_564478, "protectionContainerName", newJString(protectionContainerName))
  add(query_564479, "api-version", newJString(apiVersion))
  add(path_564478, "fabricName", newJString(fabricName))
  add(path_564478, "subscriptionId", newJString(subscriptionId))
  add(path_564478, "resourceGroupName", newJString(resourceGroupName))
  add(path_564478, "resourceName", newJString(resourceName))
  result = call_564477.call(path_564478, query_564479, nil, nil, nil)

var replicationProtectableItemsListByReplicationProtectionContainers* = Call_ReplicationProtectableItemsListByReplicationProtectionContainers_564467(
    name: "replicationProtectableItemsListByReplicationProtectionContainers",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectableItems", validator: validate_ReplicationProtectableItemsListByReplicationProtectionContainers_564468,
    base: "",
    url: url_ReplicationProtectableItemsListByReplicationProtectionContainers_564469,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectableItemsGet_564480 = ref object of OpenApiRestCall_563564
proc url_ReplicationProtectableItemsGet_564482(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "protectableItemName" in path,
        "`protectableItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectableItems/"),
               (kind: VariableSegment, value: "protectableItemName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectableItemsGet_564481(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to get the details of a protectable item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectableItemName: JString (required)
  ##                      : Protectable item name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564483 = path.getOrDefault("protectionContainerName")
  valid_564483 = validateParameter(valid_564483, JString, required = true,
                                 default = nil)
  if valid_564483 != nil:
    section.add "protectionContainerName", valid_564483
  var valid_564484 = path.getOrDefault("fabricName")
  valid_564484 = validateParameter(valid_564484, JString, required = true,
                                 default = nil)
  if valid_564484 != nil:
    section.add "fabricName", valid_564484
  var valid_564485 = path.getOrDefault("subscriptionId")
  valid_564485 = validateParameter(valid_564485, JString, required = true,
                                 default = nil)
  if valid_564485 != nil:
    section.add "subscriptionId", valid_564485
  var valid_564486 = path.getOrDefault("resourceGroupName")
  valid_564486 = validateParameter(valid_564486, JString, required = true,
                                 default = nil)
  if valid_564486 != nil:
    section.add "resourceGroupName", valid_564486
  var valid_564487 = path.getOrDefault("resourceName")
  valid_564487 = validateParameter(valid_564487, JString, required = true,
                                 default = nil)
  if valid_564487 != nil:
    section.add "resourceName", valid_564487
  var valid_564488 = path.getOrDefault("protectableItemName")
  valid_564488 = validateParameter(valid_564488, JString, required = true,
                                 default = nil)
  if valid_564488 != nil:
    section.add "protectableItemName", valid_564488
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564489 = query.getOrDefault("api-version")
  valid_564489 = validateParameter(valid_564489, JString, required = true,
                                 default = nil)
  if valid_564489 != nil:
    section.add "api-version", valid_564489
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564490: Call_ReplicationProtectableItemsGet_564480; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to get the details of a protectable item.
  ## 
  let valid = call_564490.validator(path, query, header, formData, body)
  let scheme = call_564490.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564490.url(scheme.get, call_564490.host, call_564490.base,
                         call_564490.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564490, url, valid)

proc call*(call_564491: Call_ReplicationProtectableItemsGet_564480;
          protectionContainerName: string; apiVersion: string; fabricName: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string;
          protectableItemName: string): Recallable =
  ## replicationProtectableItemsGet
  ## The operation to get the details of a protectable item.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectableItemName: string (required)
  ##                      : Protectable item name.
  var path_564492 = newJObject()
  var query_564493 = newJObject()
  add(path_564492, "protectionContainerName", newJString(protectionContainerName))
  add(query_564493, "api-version", newJString(apiVersion))
  add(path_564492, "fabricName", newJString(fabricName))
  add(path_564492, "subscriptionId", newJString(subscriptionId))
  add(path_564492, "resourceGroupName", newJString(resourceGroupName))
  add(path_564492, "resourceName", newJString(resourceName))
  add(path_564492, "protectableItemName", newJString(protectableItemName))
  result = call_564491.call(path_564492, query_564493, nil, nil, nil)

var replicationProtectableItemsGet* = Call_ReplicationProtectableItemsGet_564480(
    name: "replicationProtectableItemsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectableItems/{protectableItemName}",
    validator: validate_ReplicationProtectableItemsGet_564481, base: "",
    url: url_ReplicationProtectableItemsGet_564482, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsListByReplicationProtectionContainers_564494 = ref object of OpenApiRestCall_563564
proc url_ReplicationProtectedItemsListByReplicationProtectionContainers_564496(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsListByReplicationProtectionContainers_564495(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the list of ASR replication protected items in the protection container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564497 = path.getOrDefault("protectionContainerName")
  valid_564497 = validateParameter(valid_564497, JString, required = true,
                                 default = nil)
  if valid_564497 != nil:
    section.add "protectionContainerName", valid_564497
  var valid_564498 = path.getOrDefault("fabricName")
  valid_564498 = validateParameter(valid_564498, JString, required = true,
                                 default = nil)
  if valid_564498 != nil:
    section.add "fabricName", valid_564498
  var valid_564499 = path.getOrDefault("subscriptionId")
  valid_564499 = validateParameter(valid_564499, JString, required = true,
                                 default = nil)
  if valid_564499 != nil:
    section.add "subscriptionId", valid_564499
  var valid_564500 = path.getOrDefault("resourceGroupName")
  valid_564500 = validateParameter(valid_564500, JString, required = true,
                                 default = nil)
  if valid_564500 != nil:
    section.add "resourceGroupName", valid_564500
  var valid_564501 = path.getOrDefault("resourceName")
  valid_564501 = validateParameter(valid_564501, JString, required = true,
                                 default = nil)
  if valid_564501 != nil:
    section.add "resourceName", valid_564501
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564502 = query.getOrDefault("api-version")
  valid_564502 = validateParameter(valid_564502, JString, required = true,
                                 default = nil)
  if valid_564502 != nil:
    section.add "api-version", valid_564502
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564503: Call_ReplicationProtectedItemsListByReplicationProtectionContainers_564494;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the list of ASR replication protected items in the protection container.
  ## 
  let valid = call_564503.validator(path, query, header, formData, body)
  let scheme = call_564503.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564503.url(scheme.get, call_564503.host, call_564503.base,
                         call_564503.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564503, url, valid)

proc call*(call_564504: Call_ReplicationProtectedItemsListByReplicationProtectionContainers_564494;
          protectionContainerName: string; apiVersion: string; fabricName: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## replicationProtectedItemsListByReplicationProtectionContainers
  ## Gets the list of ASR replication protected items in the protection container.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564505 = newJObject()
  var query_564506 = newJObject()
  add(path_564505, "protectionContainerName", newJString(protectionContainerName))
  add(query_564506, "api-version", newJString(apiVersion))
  add(path_564505, "fabricName", newJString(fabricName))
  add(path_564505, "subscriptionId", newJString(subscriptionId))
  add(path_564505, "resourceGroupName", newJString(resourceGroupName))
  add(path_564505, "resourceName", newJString(resourceName))
  result = call_564504.call(path_564505, query_564506, nil, nil, nil)

var replicationProtectedItemsListByReplicationProtectionContainers* = Call_ReplicationProtectedItemsListByReplicationProtectionContainers_564494(
    name: "replicationProtectedItemsListByReplicationProtectionContainers",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems", validator: validate_ReplicationProtectedItemsListByReplicationProtectionContainers_564495,
    base: "",
    url: url_ReplicationProtectedItemsListByReplicationProtectionContainers_564496,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsCreate_564521 = ref object of OpenApiRestCall_563564
proc url_ReplicationProtectedItemsCreate_564523(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "replicatedProtectedItemName" in path,
        "`replicatedProtectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems/"),
               (kind: VariableSegment, value: "replicatedProtectedItemName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsCreate_564522(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create an ASR replication protected item (Enable replication).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : A name for the replication protected item.
  ##   fabricName: JString (required)
  ##             : Name of the fabric.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564524 = path.getOrDefault("protectionContainerName")
  valid_564524 = validateParameter(valid_564524, JString, required = true,
                                 default = nil)
  if valid_564524 != nil:
    section.add "protectionContainerName", valid_564524
  var valid_564525 = path.getOrDefault("replicatedProtectedItemName")
  valid_564525 = validateParameter(valid_564525, JString, required = true,
                                 default = nil)
  if valid_564525 != nil:
    section.add "replicatedProtectedItemName", valid_564525
  var valid_564526 = path.getOrDefault("fabricName")
  valid_564526 = validateParameter(valid_564526, JString, required = true,
                                 default = nil)
  if valid_564526 != nil:
    section.add "fabricName", valid_564526
  var valid_564527 = path.getOrDefault("subscriptionId")
  valid_564527 = validateParameter(valid_564527, JString, required = true,
                                 default = nil)
  if valid_564527 != nil:
    section.add "subscriptionId", valid_564527
  var valid_564528 = path.getOrDefault("resourceGroupName")
  valid_564528 = validateParameter(valid_564528, JString, required = true,
                                 default = nil)
  if valid_564528 != nil:
    section.add "resourceGroupName", valid_564528
  var valid_564529 = path.getOrDefault("resourceName")
  valid_564529 = validateParameter(valid_564529, JString, required = true,
                                 default = nil)
  if valid_564529 != nil:
    section.add "resourceName", valid_564529
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564530 = query.getOrDefault("api-version")
  valid_564530 = validateParameter(valid_564530, JString, required = true,
                                 default = nil)
  if valid_564530 != nil:
    section.add "api-version", valid_564530
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Enable Protection Input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564532: Call_ReplicationProtectedItemsCreate_564521;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create an ASR replication protected item (Enable replication).
  ## 
  let valid = call_564532.validator(path, query, header, formData, body)
  let scheme = call_564532.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564532.url(scheme.get, call_564532.host, call_564532.base,
                         call_564532.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564532, url, valid)

proc call*(call_564533: Call_ReplicationProtectedItemsCreate_564521;
          protectionContainerName: string; apiVersion: string; input: JsonNode;
          replicatedProtectedItemName: string; fabricName: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## replicationProtectedItemsCreate
  ## The operation to create an ASR replication protected item (Enable replication).
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   input: JObject (required)
  ##        : Enable Protection Input.
  ##   replicatedProtectedItemName: string (required)
  ##                              : A name for the replication protected item.
  ##   fabricName: string (required)
  ##             : Name of the fabric.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564534 = newJObject()
  var query_564535 = newJObject()
  var body_564536 = newJObject()
  add(path_564534, "protectionContainerName", newJString(protectionContainerName))
  add(query_564535, "api-version", newJString(apiVersion))
  if input != nil:
    body_564536 = input
  add(path_564534, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564534, "fabricName", newJString(fabricName))
  add(path_564534, "subscriptionId", newJString(subscriptionId))
  add(path_564534, "resourceGroupName", newJString(resourceGroupName))
  add(path_564534, "resourceName", newJString(resourceName))
  result = call_564533.call(path_564534, query_564535, nil, nil, body_564536)

var replicationProtectedItemsCreate* = Call_ReplicationProtectedItemsCreate_564521(
    name: "replicationProtectedItemsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}",
    validator: validate_ReplicationProtectedItemsCreate_564522, base: "",
    url: url_ReplicationProtectedItemsCreate_564523, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsGet_564507 = ref object of OpenApiRestCall_563564
proc url_ReplicationProtectedItemsGet_564509(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "replicatedProtectedItemName" in path,
        "`replicatedProtectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems/"),
               (kind: VariableSegment, value: "replicatedProtectedItemName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsGet_564508(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of an ASR replication protected item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : Replication protected item name.
  ##   fabricName: JString (required)
  ##             : Fabric unique name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564510 = path.getOrDefault("protectionContainerName")
  valid_564510 = validateParameter(valid_564510, JString, required = true,
                                 default = nil)
  if valid_564510 != nil:
    section.add "protectionContainerName", valid_564510
  var valid_564511 = path.getOrDefault("replicatedProtectedItemName")
  valid_564511 = validateParameter(valid_564511, JString, required = true,
                                 default = nil)
  if valid_564511 != nil:
    section.add "replicatedProtectedItemName", valid_564511
  var valid_564512 = path.getOrDefault("fabricName")
  valid_564512 = validateParameter(valid_564512, JString, required = true,
                                 default = nil)
  if valid_564512 != nil:
    section.add "fabricName", valid_564512
  var valid_564513 = path.getOrDefault("subscriptionId")
  valid_564513 = validateParameter(valid_564513, JString, required = true,
                                 default = nil)
  if valid_564513 != nil:
    section.add "subscriptionId", valid_564513
  var valid_564514 = path.getOrDefault("resourceGroupName")
  valid_564514 = validateParameter(valid_564514, JString, required = true,
                                 default = nil)
  if valid_564514 != nil:
    section.add "resourceGroupName", valid_564514
  var valid_564515 = path.getOrDefault("resourceName")
  valid_564515 = validateParameter(valid_564515, JString, required = true,
                                 default = nil)
  if valid_564515 != nil:
    section.add "resourceName", valid_564515
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564516 = query.getOrDefault("api-version")
  valid_564516 = validateParameter(valid_564516, JString, required = true,
                                 default = nil)
  if valid_564516 != nil:
    section.add "api-version", valid_564516
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564517: Call_ReplicationProtectedItemsGet_564507; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of an ASR replication protected item.
  ## 
  let valid = call_564517.validator(path, query, header, formData, body)
  let scheme = call_564517.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564517.url(scheme.get, call_564517.host, call_564517.base,
                         call_564517.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564517, url, valid)

proc call*(call_564518: Call_ReplicationProtectedItemsGet_564507;
          protectionContainerName: string; apiVersion: string;
          replicatedProtectedItemName: string; fabricName: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## replicationProtectedItemsGet
  ## Gets the details of an ASR replication protected item.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   replicatedProtectedItemName: string (required)
  ##                              : Replication protected item name.
  ##   fabricName: string (required)
  ##             : Fabric unique name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564519 = newJObject()
  var query_564520 = newJObject()
  add(path_564519, "protectionContainerName", newJString(protectionContainerName))
  add(query_564520, "api-version", newJString(apiVersion))
  add(path_564519, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564519, "fabricName", newJString(fabricName))
  add(path_564519, "subscriptionId", newJString(subscriptionId))
  add(path_564519, "resourceGroupName", newJString(resourceGroupName))
  add(path_564519, "resourceName", newJString(resourceName))
  result = call_564518.call(path_564519, query_564520, nil, nil, nil)

var replicationProtectedItemsGet* = Call_ReplicationProtectedItemsGet_564507(
    name: "replicationProtectedItemsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}",
    validator: validate_ReplicationProtectedItemsGet_564508, base: "",
    url: url_ReplicationProtectedItemsGet_564509, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsUpdate_564551 = ref object of OpenApiRestCall_563564
proc url_ReplicationProtectedItemsUpdate_564553(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "replicatedProtectedItemName" in path,
        "`replicatedProtectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems/"),
               (kind: VariableSegment, value: "replicatedProtectedItemName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsUpdate_564552(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update the recovery settings of an ASR replication protected item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : Replication protected item name.
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564554 = path.getOrDefault("protectionContainerName")
  valid_564554 = validateParameter(valid_564554, JString, required = true,
                                 default = nil)
  if valid_564554 != nil:
    section.add "protectionContainerName", valid_564554
  var valid_564555 = path.getOrDefault("replicatedProtectedItemName")
  valid_564555 = validateParameter(valid_564555, JString, required = true,
                                 default = nil)
  if valid_564555 != nil:
    section.add "replicatedProtectedItemName", valid_564555
  var valid_564556 = path.getOrDefault("fabricName")
  valid_564556 = validateParameter(valid_564556, JString, required = true,
                                 default = nil)
  if valid_564556 != nil:
    section.add "fabricName", valid_564556
  var valid_564557 = path.getOrDefault("subscriptionId")
  valid_564557 = validateParameter(valid_564557, JString, required = true,
                                 default = nil)
  if valid_564557 != nil:
    section.add "subscriptionId", valid_564557
  var valid_564558 = path.getOrDefault("resourceGroupName")
  valid_564558 = validateParameter(valid_564558, JString, required = true,
                                 default = nil)
  if valid_564558 != nil:
    section.add "resourceGroupName", valid_564558
  var valid_564559 = path.getOrDefault("resourceName")
  valid_564559 = validateParameter(valid_564559, JString, required = true,
                                 default = nil)
  if valid_564559 != nil:
    section.add "resourceName", valid_564559
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564560 = query.getOrDefault("api-version")
  valid_564560 = validateParameter(valid_564560, JString, required = true,
                                 default = nil)
  if valid_564560 != nil:
    section.add "api-version", valid_564560
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   updateProtectionInput: JObject (required)
  ##                        : Update protection input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564562: Call_ReplicationProtectedItemsUpdate_564551;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to update the recovery settings of an ASR replication protected item.
  ## 
  let valid = call_564562.validator(path, query, header, formData, body)
  let scheme = call_564562.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564562.url(scheme.get, call_564562.host, call_564562.base,
                         call_564562.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564562, url, valid)

proc call*(call_564563: Call_ReplicationProtectedItemsUpdate_564551;
          protectionContainerName: string; apiVersion: string;
          updateProtectionInput: JsonNode; replicatedProtectedItemName: string;
          fabricName: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## replicationProtectedItemsUpdate
  ## The operation to update the recovery settings of an ASR replication protected item.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   updateProtectionInput: JObject (required)
  ##                        : Update protection input.
  ##   replicatedProtectedItemName: string (required)
  ##                              : Replication protected item name.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564564 = newJObject()
  var query_564565 = newJObject()
  var body_564566 = newJObject()
  add(path_564564, "protectionContainerName", newJString(protectionContainerName))
  add(query_564565, "api-version", newJString(apiVersion))
  if updateProtectionInput != nil:
    body_564566 = updateProtectionInput
  add(path_564564, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564564, "fabricName", newJString(fabricName))
  add(path_564564, "subscriptionId", newJString(subscriptionId))
  add(path_564564, "resourceGroupName", newJString(resourceGroupName))
  add(path_564564, "resourceName", newJString(resourceName))
  result = call_564563.call(path_564564, query_564565, nil, nil, body_564566)

var replicationProtectedItemsUpdate* = Call_ReplicationProtectedItemsUpdate_564551(
    name: "replicationProtectedItemsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}",
    validator: validate_ReplicationProtectedItemsUpdate_564552, base: "",
    url: url_ReplicationProtectedItemsUpdate_564553, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsPurge_564537 = ref object of OpenApiRestCall_563564
proc url_ReplicationProtectedItemsPurge_564539(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "replicatedProtectedItemName" in path,
        "`replicatedProtectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems/"),
               (kind: VariableSegment, value: "replicatedProtectedItemName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsPurge_564538(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete or purge a replication protected item. This operation will force delete the replication protected item. Use the remove operation on replication protected item to perform a clean disable replication for the item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : Replication protected item name.
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564540 = path.getOrDefault("protectionContainerName")
  valid_564540 = validateParameter(valid_564540, JString, required = true,
                                 default = nil)
  if valid_564540 != nil:
    section.add "protectionContainerName", valid_564540
  var valid_564541 = path.getOrDefault("replicatedProtectedItemName")
  valid_564541 = validateParameter(valid_564541, JString, required = true,
                                 default = nil)
  if valid_564541 != nil:
    section.add "replicatedProtectedItemName", valid_564541
  var valid_564542 = path.getOrDefault("fabricName")
  valid_564542 = validateParameter(valid_564542, JString, required = true,
                                 default = nil)
  if valid_564542 != nil:
    section.add "fabricName", valid_564542
  var valid_564543 = path.getOrDefault("subscriptionId")
  valid_564543 = validateParameter(valid_564543, JString, required = true,
                                 default = nil)
  if valid_564543 != nil:
    section.add "subscriptionId", valid_564543
  var valid_564544 = path.getOrDefault("resourceGroupName")
  valid_564544 = validateParameter(valid_564544, JString, required = true,
                                 default = nil)
  if valid_564544 != nil:
    section.add "resourceGroupName", valid_564544
  var valid_564545 = path.getOrDefault("resourceName")
  valid_564545 = validateParameter(valid_564545, JString, required = true,
                                 default = nil)
  if valid_564545 != nil:
    section.add "resourceName", valid_564545
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564546 = query.getOrDefault("api-version")
  valid_564546 = validateParameter(valid_564546, JString, required = true,
                                 default = nil)
  if valid_564546 != nil:
    section.add "api-version", valid_564546
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564547: Call_ReplicationProtectedItemsPurge_564537; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete or purge a replication protected item. This operation will force delete the replication protected item. Use the remove operation on replication protected item to perform a clean disable replication for the item.
  ## 
  let valid = call_564547.validator(path, query, header, formData, body)
  let scheme = call_564547.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564547.url(scheme.get, call_564547.host, call_564547.base,
                         call_564547.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564547, url, valid)

proc call*(call_564548: Call_ReplicationProtectedItemsPurge_564537;
          protectionContainerName: string; apiVersion: string;
          replicatedProtectedItemName: string; fabricName: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## replicationProtectedItemsPurge
  ## The operation to delete or purge a replication protected item. This operation will force delete the replication protected item. Use the remove operation on replication protected item to perform a clean disable replication for the item.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   replicatedProtectedItemName: string (required)
  ##                              : Replication protected item name.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564549 = newJObject()
  var query_564550 = newJObject()
  add(path_564549, "protectionContainerName", newJString(protectionContainerName))
  add(query_564550, "api-version", newJString(apiVersion))
  add(path_564549, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564549, "fabricName", newJString(fabricName))
  add(path_564549, "subscriptionId", newJString(subscriptionId))
  add(path_564549, "resourceGroupName", newJString(resourceGroupName))
  add(path_564549, "resourceName", newJString(resourceName))
  result = call_564548.call(path_564549, query_564550, nil, nil, nil)

var replicationProtectedItemsPurge* = Call_ReplicationProtectedItemsPurge_564537(
    name: "replicationProtectedItemsPurge", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}",
    validator: validate_ReplicationProtectedItemsPurge_564538, base: "",
    url: url_ReplicationProtectedItemsPurge_564539, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsApplyRecoveryPoint_564567 = ref object of OpenApiRestCall_563564
proc url_ReplicationProtectedItemsApplyRecoveryPoint_564569(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "replicatedProtectedItemName" in path,
        "`replicatedProtectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems/"),
               (kind: VariableSegment, value: "replicatedProtectedItemName"),
               (kind: ConstantSegment, value: "/applyRecoveryPoint")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsApplyRecoveryPoint_564568(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to change the recovery point of a failed over replication protected item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   protectionContainerName: JString (required)
  ##                          : The protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : The replicated protected item's name.
  ##   fabricName: JString (required)
  ##             : The ARM fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564570 = path.getOrDefault("protectionContainerName")
  valid_564570 = validateParameter(valid_564570, JString, required = true,
                                 default = nil)
  if valid_564570 != nil:
    section.add "protectionContainerName", valid_564570
  var valid_564571 = path.getOrDefault("replicatedProtectedItemName")
  valid_564571 = validateParameter(valid_564571, JString, required = true,
                                 default = nil)
  if valid_564571 != nil:
    section.add "replicatedProtectedItemName", valid_564571
  var valid_564572 = path.getOrDefault("fabricName")
  valid_564572 = validateParameter(valid_564572, JString, required = true,
                                 default = nil)
  if valid_564572 != nil:
    section.add "fabricName", valid_564572
  var valid_564573 = path.getOrDefault("subscriptionId")
  valid_564573 = validateParameter(valid_564573, JString, required = true,
                                 default = nil)
  if valid_564573 != nil:
    section.add "subscriptionId", valid_564573
  var valid_564574 = path.getOrDefault("resourceGroupName")
  valid_564574 = validateParameter(valid_564574, JString, required = true,
                                 default = nil)
  if valid_564574 != nil:
    section.add "resourceGroupName", valid_564574
  var valid_564575 = path.getOrDefault("resourceName")
  valid_564575 = validateParameter(valid_564575, JString, required = true,
                                 default = nil)
  if valid_564575 != nil:
    section.add "resourceName", valid_564575
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564576 = query.getOrDefault("api-version")
  valid_564576 = validateParameter(valid_564576, JString, required = true,
                                 default = nil)
  if valid_564576 != nil:
    section.add "api-version", valid_564576
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   applyRecoveryPointInput: JObject (required)
  ##                          : The ApplyRecoveryPointInput.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564578: Call_ReplicationProtectedItemsApplyRecoveryPoint_564567;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to change the recovery point of a failed over replication protected item.
  ## 
  let valid = call_564578.validator(path, query, header, formData, body)
  let scheme = call_564578.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564578.url(scheme.get, call_564578.host, call_564578.base,
                         call_564578.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564578, url, valid)

proc call*(call_564579: Call_ReplicationProtectedItemsApplyRecoveryPoint_564567;
          protectionContainerName: string; apiVersion: string;
          replicatedProtectedItemName: string; fabricName: string;
          subscriptionId: string; applyRecoveryPointInput: JsonNode;
          resourceGroupName: string; resourceName: string): Recallable =
  ## replicationProtectedItemsApplyRecoveryPoint
  ## The operation to change the recovery point of a failed over replication protected item.
  ##   protectionContainerName: string (required)
  ##                          : The protection container name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   replicatedProtectedItemName: string (required)
  ##                              : The replicated protected item's name.
  ##   fabricName: string (required)
  ##             : The ARM fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   applyRecoveryPointInput: JObject (required)
  ##                          : The ApplyRecoveryPointInput.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564580 = newJObject()
  var query_564581 = newJObject()
  var body_564582 = newJObject()
  add(path_564580, "protectionContainerName", newJString(protectionContainerName))
  add(query_564581, "api-version", newJString(apiVersion))
  add(path_564580, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564580, "fabricName", newJString(fabricName))
  add(path_564580, "subscriptionId", newJString(subscriptionId))
  if applyRecoveryPointInput != nil:
    body_564582 = applyRecoveryPointInput
  add(path_564580, "resourceGroupName", newJString(resourceGroupName))
  add(path_564580, "resourceName", newJString(resourceName))
  result = call_564579.call(path_564580, query_564581, nil, nil, body_564582)

var replicationProtectedItemsApplyRecoveryPoint* = Call_ReplicationProtectedItemsApplyRecoveryPoint_564567(
    name: "replicationProtectedItemsApplyRecoveryPoint",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/applyRecoveryPoint",
    validator: validate_ReplicationProtectedItemsApplyRecoveryPoint_564568,
    base: "", url: url_ReplicationProtectedItemsApplyRecoveryPoint_564569,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsFailoverCommit_564583 = ref object of OpenApiRestCall_563564
proc url_ReplicationProtectedItemsFailoverCommit_564585(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "replicatedProtectedItemName" in path,
        "`replicatedProtectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems/"),
               (kind: VariableSegment, value: "replicatedProtectedItemName"),
               (kind: ConstantSegment, value: "/failoverCommit")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsFailoverCommit_564584(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Operation to commit the failover of the replication protected item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : Replication protected item name.
  ##   fabricName: JString (required)
  ##             : Unique fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564586 = path.getOrDefault("protectionContainerName")
  valid_564586 = validateParameter(valid_564586, JString, required = true,
                                 default = nil)
  if valid_564586 != nil:
    section.add "protectionContainerName", valid_564586
  var valid_564587 = path.getOrDefault("replicatedProtectedItemName")
  valid_564587 = validateParameter(valid_564587, JString, required = true,
                                 default = nil)
  if valid_564587 != nil:
    section.add "replicatedProtectedItemName", valid_564587
  var valid_564588 = path.getOrDefault("fabricName")
  valid_564588 = validateParameter(valid_564588, JString, required = true,
                                 default = nil)
  if valid_564588 != nil:
    section.add "fabricName", valid_564588
  var valid_564589 = path.getOrDefault("subscriptionId")
  valid_564589 = validateParameter(valid_564589, JString, required = true,
                                 default = nil)
  if valid_564589 != nil:
    section.add "subscriptionId", valid_564589
  var valid_564590 = path.getOrDefault("resourceGroupName")
  valid_564590 = validateParameter(valid_564590, JString, required = true,
                                 default = nil)
  if valid_564590 != nil:
    section.add "resourceGroupName", valid_564590
  var valid_564591 = path.getOrDefault("resourceName")
  valid_564591 = validateParameter(valid_564591, JString, required = true,
                                 default = nil)
  if valid_564591 != nil:
    section.add "resourceName", valid_564591
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564592 = query.getOrDefault("api-version")
  valid_564592 = validateParameter(valid_564592, JString, required = true,
                                 default = nil)
  if valid_564592 != nil:
    section.add "api-version", valid_564592
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564593: Call_ReplicationProtectedItemsFailoverCommit_564583;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to commit the failover of the replication protected item.
  ## 
  let valid = call_564593.validator(path, query, header, formData, body)
  let scheme = call_564593.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564593.url(scheme.get, call_564593.host, call_564593.base,
                         call_564593.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564593, url, valid)

proc call*(call_564594: Call_ReplicationProtectedItemsFailoverCommit_564583;
          protectionContainerName: string; apiVersion: string;
          replicatedProtectedItemName: string; fabricName: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## replicationProtectedItemsFailoverCommit
  ## Operation to commit the failover of the replication protected item.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   replicatedProtectedItemName: string (required)
  ##                              : Replication protected item name.
  ##   fabricName: string (required)
  ##             : Unique fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564595 = newJObject()
  var query_564596 = newJObject()
  add(path_564595, "protectionContainerName", newJString(protectionContainerName))
  add(query_564596, "api-version", newJString(apiVersion))
  add(path_564595, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564595, "fabricName", newJString(fabricName))
  add(path_564595, "subscriptionId", newJString(subscriptionId))
  add(path_564595, "resourceGroupName", newJString(resourceGroupName))
  add(path_564595, "resourceName", newJString(resourceName))
  result = call_564594.call(path_564595, query_564596, nil, nil, nil)

var replicationProtectedItemsFailoverCommit* = Call_ReplicationProtectedItemsFailoverCommit_564583(
    name: "replicationProtectedItemsFailoverCommit", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/failoverCommit",
    validator: validate_ReplicationProtectedItemsFailoverCommit_564584, base: "",
    url: url_ReplicationProtectedItemsFailoverCommit_564585,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsPlannedFailover_564597 = ref object of OpenApiRestCall_563564
proc url_ReplicationProtectedItemsPlannedFailover_564599(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "replicatedProtectedItemName" in path,
        "`replicatedProtectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems/"),
               (kind: VariableSegment, value: "replicatedProtectedItemName"),
               (kind: ConstantSegment, value: "/plannedFailover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsPlannedFailover_564598(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Operation to initiate a planned failover of the replication protected item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : Replication protected item name.
  ##   fabricName: JString (required)
  ##             : Unique fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564600 = path.getOrDefault("protectionContainerName")
  valid_564600 = validateParameter(valid_564600, JString, required = true,
                                 default = nil)
  if valid_564600 != nil:
    section.add "protectionContainerName", valid_564600
  var valid_564601 = path.getOrDefault("replicatedProtectedItemName")
  valid_564601 = validateParameter(valid_564601, JString, required = true,
                                 default = nil)
  if valid_564601 != nil:
    section.add "replicatedProtectedItemName", valid_564601
  var valid_564602 = path.getOrDefault("fabricName")
  valid_564602 = validateParameter(valid_564602, JString, required = true,
                                 default = nil)
  if valid_564602 != nil:
    section.add "fabricName", valid_564602
  var valid_564603 = path.getOrDefault("subscriptionId")
  valid_564603 = validateParameter(valid_564603, JString, required = true,
                                 default = nil)
  if valid_564603 != nil:
    section.add "subscriptionId", valid_564603
  var valid_564604 = path.getOrDefault("resourceGroupName")
  valid_564604 = validateParameter(valid_564604, JString, required = true,
                                 default = nil)
  if valid_564604 != nil:
    section.add "resourceGroupName", valid_564604
  var valid_564605 = path.getOrDefault("resourceName")
  valid_564605 = validateParameter(valid_564605, JString, required = true,
                                 default = nil)
  if valid_564605 != nil:
    section.add "resourceName", valid_564605
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564606 = query.getOrDefault("api-version")
  valid_564606 = validateParameter(valid_564606, JString, required = true,
                                 default = nil)
  if valid_564606 != nil:
    section.add "api-version", valid_564606
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   failoverInput: JObject (required)
  ##                : Disable protection input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564608: Call_ReplicationProtectedItemsPlannedFailover_564597;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to initiate a planned failover of the replication protected item.
  ## 
  let valid = call_564608.validator(path, query, header, formData, body)
  let scheme = call_564608.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564608.url(scheme.get, call_564608.host, call_564608.base,
                         call_564608.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564608, url, valid)

proc call*(call_564609: Call_ReplicationProtectedItemsPlannedFailover_564597;
          protectionContainerName: string; apiVersion: string;
          replicatedProtectedItemName: string; fabricName: string;
          subscriptionId: string; resourceGroupName: string;
          failoverInput: JsonNode; resourceName: string): Recallable =
  ## replicationProtectedItemsPlannedFailover
  ## Operation to initiate a planned failover of the replication protected item.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   replicatedProtectedItemName: string (required)
  ##                              : Replication protected item name.
  ##   fabricName: string (required)
  ##             : Unique fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   failoverInput: JObject (required)
  ##                : Disable protection input.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564610 = newJObject()
  var query_564611 = newJObject()
  var body_564612 = newJObject()
  add(path_564610, "protectionContainerName", newJString(protectionContainerName))
  add(query_564611, "api-version", newJString(apiVersion))
  add(path_564610, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564610, "fabricName", newJString(fabricName))
  add(path_564610, "subscriptionId", newJString(subscriptionId))
  add(path_564610, "resourceGroupName", newJString(resourceGroupName))
  if failoverInput != nil:
    body_564612 = failoverInput
  add(path_564610, "resourceName", newJString(resourceName))
  result = call_564609.call(path_564610, query_564611, nil, nil, body_564612)

var replicationProtectedItemsPlannedFailover* = Call_ReplicationProtectedItemsPlannedFailover_564597(
    name: "replicationProtectedItemsPlannedFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/plannedFailover",
    validator: validate_ReplicationProtectedItemsPlannedFailover_564598, base: "",
    url: url_ReplicationProtectedItemsPlannedFailover_564599,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsReprotect_564613 = ref object of OpenApiRestCall_563564
proc url_ReplicationProtectedItemsReprotect_564615(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "replicatedProtectedItemName" in path,
        "`replicatedProtectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems/"),
               (kind: VariableSegment, value: "replicatedProtectedItemName"),
               (kind: ConstantSegment, value: "/reProtect")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsReprotect_564614(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Operation to reprotect or reverse replicate a failed over replication protected item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : Replication protected item name.
  ##   fabricName: JString (required)
  ##             : Unique fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564616 = path.getOrDefault("protectionContainerName")
  valid_564616 = validateParameter(valid_564616, JString, required = true,
                                 default = nil)
  if valid_564616 != nil:
    section.add "protectionContainerName", valid_564616
  var valid_564617 = path.getOrDefault("replicatedProtectedItemName")
  valid_564617 = validateParameter(valid_564617, JString, required = true,
                                 default = nil)
  if valid_564617 != nil:
    section.add "replicatedProtectedItemName", valid_564617
  var valid_564618 = path.getOrDefault("fabricName")
  valid_564618 = validateParameter(valid_564618, JString, required = true,
                                 default = nil)
  if valid_564618 != nil:
    section.add "fabricName", valid_564618
  var valid_564619 = path.getOrDefault("subscriptionId")
  valid_564619 = validateParameter(valid_564619, JString, required = true,
                                 default = nil)
  if valid_564619 != nil:
    section.add "subscriptionId", valid_564619
  var valid_564620 = path.getOrDefault("resourceGroupName")
  valid_564620 = validateParameter(valid_564620, JString, required = true,
                                 default = nil)
  if valid_564620 != nil:
    section.add "resourceGroupName", valid_564620
  var valid_564621 = path.getOrDefault("resourceName")
  valid_564621 = validateParameter(valid_564621, JString, required = true,
                                 default = nil)
  if valid_564621 != nil:
    section.add "resourceName", valid_564621
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564622 = query.getOrDefault("api-version")
  valid_564622 = validateParameter(valid_564622, JString, required = true,
                                 default = nil)
  if valid_564622 != nil:
    section.add "api-version", valid_564622
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   rrInput: JObject (required)
  ##          : Disable protection input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564624: Call_ReplicationProtectedItemsReprotect_564613;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to reprotect or reverse replicate a failed over replication protected item.
  ## 
  let valid = call_564624.validator(path, query, header, formData, body)
  let scheme = call_564624.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564624.url(scheme.get, call_564624.host, call_564624.base,
                         call_564624.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564624, url, valid)

proc call*(call_564625: Call_ReplicationProtectedItemsReprotect_564613;
          protectionContainerName: string; apiVersion: string;
          replicatedProtectedItemName: string; rrInput: JsonNode;
          fabricName: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## replicationProtectedItemsReprotect
  ## Operation to reprotect or reverse replicate a failed over replication protected item.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   replicatedProtectedItemName: string (required)
  ##                              : Replication protected item name.
  ##   rrInput: JObject (required)
  ##          : Disable protection input.
  ##   fabricName: string (required)
  ##             : Unique fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564626 = newJObject()
  var query_564627 = newJObject()
  var body_564628 = newJObject()
  add(path_564626, "protectionContainerName", newJString(protectionContainerName))
  add(query_564627, "api-version", newJString(apiVersion))
  add(path_564626, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  if rrInput != nil:
    body_564628 = rrInput
  add(path_564626, "fabricName", newJString(fabricName))
  add(path_564626, "subscriptionId", newJString(subscriptionId))
  add(path_564626, "resourceGroupName", newJString(resourceGroupName))
  add(path_564626, "resourceName", newJString(resourceName))
  result = call_564625.call(path_564626, query_564627, nil, nil, body_564628)

var replicationProtectedItemsReprotect* = Call_ReplicationProtectedItemsReprotect_564613(
    name: "replicationProtectedItemsReprotect", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/reProtect",
    validator: validate_ReplicationProtectedItemsReprotect_564614, base: "",
    url: url_ReplicationProtectedItemsReprotect_564615, schemes: {Scheme.Https})
type
  Call_RecoveryPointsListByReplicationProtectedItems_564629 = ref object of OpenApiRestCall_563564
proc url_RecoveryPointsListByReplicationProtectedItems_564631(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "replicatedProtectedItemName" in path,
        "`replicatedProtectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems/"),
               (kind: VariableSegment, value: "replicatedProtectedItemName"),
               (kind: ConstantSegment, value: "/recoveryPoints")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecoveryPointsListByReplicationProtectedItems_564630(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the available recovery points for a replication protected item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   protectionContainerName: JString (required)
  ##                          : The protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : The replication protected item's name.
  ##   fabricName: JString (required)
  ##             : The fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564632 = path.getOrDefault("protectionContainerName")
  valid_564632 = validateParameter(valid_564632, JString, required = true,
                                 default = nil)
  if valid_564632 != nil:
    section.add "protectionContainerName", valid_564632
  var valid_564633 = path.getOrDefault("replicatedProtectedItemName")
  valid_564633 = validateParameter(valid_564633, JString, required = true,
                                 default = nil)
  if valid_564633 != nil:
    section.add "replicatedProtectedItemName", valid_564633
  var valid_564634 = path.getOrDefault("fabricName")
  valid_564634 = validateParameter(valid_564634, JString, required = true,
                                 default = nil)
  if valid_564634 != nil:
    section.add "fabricName", valid_564634
  var valid_564635 = path.getOrDefault("subscriptionId")
  valid_564635 = validateParameter(valid_564635, JString, required = true,
                                 default = nil)
  if valid_564635 != nil:
    section.add "subscriptionId", valid_564635
  var valid_564636 = path.getOrDefault("resourceGroupName")
  valid_564636 = validateParameter(valid_564636, JString, required = true,
                                 default = nil)
  if valid_564636 != nil:
    section.add "resourceGroupName", valid_564636
  var valid_564637 = path.getOrDefault("resourceName")
  valid_564637 = validateParameter(valid_564637, JString, required = true,
                                 default = nil)
  if valid_564637 != nil:
    section.add "resourceName", valid_564637
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564638 = query.getOrDefault("api-version")
  valid_564638 = validateParameter(valid_564638, JString, required = true,
                                 default = nil)
  if valid_564638 != nil:
    section.add "api-version", valid_564638
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564639: Call_RecoveryPointsListByReplicationProtectedItems_564629;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the available recovery points for a replication protected item.
  ## 
  let valid = call_564639.validator(path, query, header, formData, body)
  let scheme = call_564639.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564639.url(scheme.get, call_564639.host, call_564639.base,
                         call_564639.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564639, url, valid)

proc call*(call_564640: Call_RecoveryPointsListByReplicationProtectedItems_564629;
          protectionContainerName: string; apiVersion: string;
          replicatedProtectedItemName: string; fabricName: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## recoveryPointsListByReplicationProtectedItems
  ## Lists the available recovery points for a replication protected item.
  ##   protectionContainerName: string (required)
  ##                          : The protection container name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   replicatedProtectedItemName: string (required)
  ##                              : The replication protected item's name.
  ##   fabricName: string (required)
  ##             : The fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564641 = newJObject()
  var query_564642 = newJObject()
  add(path_564641, "protectionContainerName", newJString(protectionContainerName))
  add(query_564642, "api-version", newJString(apiVersion))
  add(path_564641, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564641, "fabricName", newJString(fabricName))
  add(path_564641, "subscriptionId", newJString(subscriptionId))
  add(path_564641, "resourceGroupName", newJString(resourceGroupName))
  add(path_564641, "resourceName", newJString(resourceName))
  result = call_564640.call(path_564641, query_564642, nil, nil, nil)

var recoveryPointsListByReplicationProtectedItems* = Call_RecoveryPointsListByReplicationProtectedItems_564629(
    name: "recoveryPointsListByReplicationProtectedItems",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/recoveryPoints",
    validator: validate_RecoveryPointsListByReplicationProtectedItems_564630,
    base: "", url: url_RecoveryPointsListByReplicationProtectedItems_564631,
    schemes: {Scheme.Https})
type
  Call_RecoveryPointsGet_564643 = ref object of OpenApiRestCall_563564
proc url_RecoveryPointsGet_564645(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "replicatedProtectedItemName" in path,
        "`replicatedProtectedItemName` is a required path parameter"
  assert "recoveryPointName" in path,
        "`recoveryPointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems/"),
               (kind: VariableSegment, value: "replicatedProtectedItemName"),
               (kind: ConstantSegment, value: "/recoveryPoints/"),
               (kind: VariableSegment, value: "recoveryPointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecoveryPointsGet_564644(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get the details of specified recovery point.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   protectionContainerName: JString (required)
  ##                          : The protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : The replication protected item's name.
  ##   recoveryPointName: JString (required)
  ##                    : The recovery point name.
  ##   fabricName: JString (required)
  ##             : The fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564646 = path.getOrDefault("protectionContainerName")
  valid_564646 = validateParameter(valid_564646, JString, required = true,
                                 default = nil)
  if valid_564646 != nil:
    section.add "protectionContainerName", valid_564646
  var valid_564647 = path.getOrDefault("replicatedProtectedItemName")
  valid_564647 = validateParameter(valid_564647, JString, required = true,
                                 default = nil)
  if valid_564647 != nil:
    section.add "replicatedProtectedItemName", valid_564647
  var valid_564648 = path.getOrDefault("recoveryPointName")
  valid_564648 = validateParameter(valid_564648, JString, required = true,
                                 default = nil)
  if valid_564648 != nil:
    section.add "recoveryPointName", valid_564648
  var valid_564649 = path.getOrDefault("fabricName")
  valid_564649 = validateParameter(valid_564649, JString, required = true,
                                 default = nil)
  if valid_564649 != nil:
    section.add "fabricName", valid_564649
  var valid_564650 = path.getOrDefault("subscriptionId")
  valid_564650 = validateParameter(valid_564650, JString, required = true,
                                 default = nil)
  if valid_564650 != nil:
    section.add "subscriptionId", valid_564650
  var valid_564651 = path.getOrDefault("resourceGroupName")
  valid_564651 = validateParameter(valid_564651, JString, required = true,
                                 default = nil)
  if valid_564651 != nil:
    section.add "resourceGroupName", valid_564651
  var valid_564652 = path.getOrDefault("resourceName")
  valid_564652 = validateParameter(valid_564652, JString, required = true,
                                 default = nil)
  if valid_564652 != nil:
    section.add "resourceName", valid_564652
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564653 = query.getOrDefault("api-version")
  valid_564653 = validateParameter(valid_564653, JString, required = true,
                                 default = nil)
  if valid_564653 != nil:
    section.add "api-version", valid_564653
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564654: Call_RecoveryPointsGet_564643; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the details of specified recovery point.
  ## 
  let valid = call_564654.validator(path, query, header, formData, body)
  let scheme = call_564654.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564654.url(scheme.get, call_564654.host, call_564654.base,
                         call_564654.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564654, url, valid)

proc call*(call_564655: Call_RecoveryPointsGet_564643;
          protectionContainerName: string; apiVersion: string;
          replicatedProtectedItemName: string; recoveryPointName: string;
          fabricName: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## recoveryPointsGet
  ## Get the details of specified recovery point.
  ##   protectionContainerName: string (required)
  ##                          : The protection container name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   replicatedProtectedItemName: string (required)
  ##                              : The replication protected item's name.
  ##   recoveryPointName: string (required)
  ##                    : The recovery point name.
  ##   fabricName: string (required)
  ##             : The fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564656 = newJObject()
  var query_564657 = newJObject()
  add(path_564656, "protectionContainerName", newJString(protectionContainerName))
  add(query_564657, "api-version", newJString(apiVersion))
  add(path_564656, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564656, "recoveryPointName", newJString(recoveryPointName))
  add(path_564656, "fabricName", newJString(fabricName))
  add(path_564656, "subscriptionId", newJString(subscriptionId))
  add(path_564656, "resourceGroupName", newJString(resourceGroupName))
  add(path_564656, "resourceName", newJString(resourceName))
  result = call_564655.call(path_564656, query_564657, nil, nil, nil)

var recoveryPointsGet* = Call_RecoveryPointsGet_564643(name: "recoveryPointsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/recoveryPoints/{recoveryPointName}",
    validator: validate_RecoveryPointsGet_564644, base: "",
    url: url_RecoveryPointsGet_564645, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsDelete_564658 = ref object of OpenApiRestCall_563564
proc url_ReplicationProtectedItemsDelete_564660(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "replicatedProtectedItemName" in path,
        "`replicatedProtectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems/"),
               (kind: VariableSegment, value: "replicatedProtectedItemName"),
               (kind: ConstantSegment, value: "/remove")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsDelete_564659(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to disable replication on a replication protected item. This will also remove the item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : Replication protected item name.
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564661 = path.getOrDefault("protectionContainerName")
  valid_564661 = validateParameter(valid_564661, JString, required = true,
                                 default = nil)
  if valid_564661 != nil:
    section.add "protectionContainerName", valid_564661
  var valid_564662 = path.getOrDefault("replicatedProtectedItemName")
  valid_564662 = validateParameter(valid_564662, JString, required = true,
                                 default = nil)
  if valid_564662 != nil:
    section.add "replicatedProtectedItemName", valid_564662
  var valid_564663 = path.getOrDefault("fabricName")
  valid_564663 = validateParameter(valid_564663, JString, required = true,
                                 default = nil)
  if valid_564663 != nil:
    section.add "fabricName", valid_564663
  var valid_564664 = path.getOrDefault("subscriptionId")
  valid_564664 = validateParameter(valid_564664, JString, required = true,
                                 default = nil)
  if valid_564664 != nil:
    section.add "subscriptionId", valid_564664
  var valid_564665 = path.getOrDefault("resourceGroupName")
  valid_564665 = validateParameter(valid_564665, JString, required = true,
                                 default = nil)
  if valid_564665 != nil:
    section.add "resourceGroupName", valid_564665
  var valid_564666 = path.getOrDefault("resourceName")
  valid_564666 = validateParameter(valid_564666, JString, required = true,
                                 default = nil)
  if valid_564666 != nil:
    section.add "resourceName", valid_564666
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564667 = query.getOrDefault("api-version")
  valid_564667 = validateParameter(valid_564667, JString, required = true,
                                 default = nil)
  if valid_564667 != nil:
    section.add "api-version", valid_564667
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   disableProtectionInput: JObject (required)
  ##                         : Disable protection input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564669: Call_ReplicationProtectedItemsDelete_564658;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to disable replication on a replication protected item. This will also remove the item.
  ## 
  let valid = call_564669.validator(path, query, header, formData, body)
  let scheme = call_564669.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564669.url(scheme.get, call_564669.host, call_564669.base,
                         call_564669.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564669, url, valid)

proc call*(call_564670: Call_ReplicationProtectedItemsDelete_564658;
          protectionContainerName: string; apiVersion: string;
          replicatedProtectedItemName: string; fabricName: string;
          disableProtectionInput: JsonNode; subscriptionId: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## replicationProtectedItemsDelete
  ## The operation to disable replication on a replication protected item. This will also remove the item.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   replicatedProtectedItemName: string (required)
  ##                              : Replication protected item name.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   disableProtectionInput: JObject (required)
  ##                         : Disable protection input.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564671 = newJObject()
  var query_564672 = newJObject()
  var body_564673 = newJObject()
  add(path_564671, "protectionContainerName", newJString(protectionContainerName))
  add(query_564672, "api-version", newJString(apiVersion))
  add(path_564671, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564671, "fabricName", newJString(fabricName))
  if disableProtectionInput != nil:
    body_564673 = disableProtectionInput
  add(path_564671, "subscriptionId", newJString(subscriptionId))
  add(path_564671, "resourceGroupName", newJString(resourceGroupName))
  add(path_564671, "resourceName", newJString(resourceName))
  result = call_564670.call(path_564671, query_564672, nil, nil, body_564673)

var replicationProtectedItemsDelete* = Call_ReplicationProtectedItemsDelete_564658(
    name: "replicationProtectedItemsDelete", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/remove",
    validator: validate_ReplicationProtectedItemsDelete_564659, base: "",
    url: url_ReplicationProtectedItemsDelete_564660, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsRepairReplication_564674 = ref object of OpenApiRestCall_563564
proc url_ReplicationProtectedItemsRepairReplication_564676(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "replicatedProtectedItemName" in path,
        "`replicatedProtectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems/"),
               (kind: VariableSegment, value: "replicatedProtectedItemName"),
               (kind: ConstantSegment, value: "/repairReplication")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsRepairReplication_564675(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to start resynchronize/repair replication for a replication protected item requiring resynchronization.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   protectionContainerName: JString (required)
  ##                          : The name of the container.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : The name of the replication protected item.
  ##   fabricName: JString (required)
  ##             : The name of the fabric.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564677 = path.getOrDefault("protectionContainerName")
  valid_564677 = validateParameter(valid_564677, JString, required = true,
                                 default = nil)
  if valid_564677 != nil:
    section.add "protectionContainerName", valid_564677
  var valid_564678 = path.getOrDefault("replicatedProtectedItemName")
  valid_564678 = validateParameter(valid_564678, JString, required = true,
                                 default = nil)
  if valid_564678 != nil:
    section.add "replicatedProtectedItemName", valid_564678
  var valid_564679 = path.getOrDefault("fabricName")
  valid_564679 = validateParameter(valid_564679, JString, required = true,
                                 default = nil)
  if valid_564679 != nil:
    section.add "fabricName", valid_564679
  var valid_564680 = path.getOrDefault("subscriptionId")
  valid_564680 = validateParameter(valid_564680, JString, required = true,
                                 default = nil)
  if valid_564680 != nil:
    section.add "subscriptionId", valid_564680
  var valid_564681 = path.getOrDefault("resourceGroupName")
  valid_564681 = validateParameter(valid_564681, JString, required = true,
                                 default = nil)
  if valid_564681 != nil:
    section.add "resourceGroupName", valid_564681
  var valid_564682 = path.getOrDefault("resourceName")
  valid_564682 = validateParameter(valid_564682, JString, required = true,
                                 default = nil)
  if valid_564682 != nil:
    section.add "resourceName", valid_564682
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564683 = query.getOrDefault("api-version")
  valid_564683 = validateParameter(valid_564683, JString, required = true,
                                 default = nil)
  if valid_564683 != nil:
    section.add "api-version", valid_564683
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564684: Call_ReplicationProtectedItemsRepairReplication_564674;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to start resynchronize/repair replication for a replication protected item requiring resynchronization.
  ## 
  let valid = call_564684.validator(path, query, header, formData, body)
  let scheme = call_564684.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564684.url(scheme.get, call_564684.host, call_564684.base,
                         call_564684.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564684, url, valid)

proc call*(call_564685: Call_ReplicationProtectedItemsRepairReplication_564674;
          protectionContainerName: string; apiVersion: string;
          replicatedProtectedItemName: string; fabricName: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## replicationProtectedItemsRepairReplication
  ## The operation to start resynchronize/repair replication for a replication protected item requiring resynchronization.
  ##   protectionContainerName: string (required)
  ##                          : The name of the container.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   replicatedProtectedItemName: string (required)
  ##                              : The name of the replication protected item.
  ##   fabricName: string (required)
  ##             : The name of the fabric.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564686 = newJObject()
  var query_564687 = newJObject()
  add(path_564686, "protectionContainerName", newJString(protectionContainerName))
  add(query_564687, "api-version", newJString(apiVersion))
  add(path_564686, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564686, "fabricName", newJString(fabricName))
  add(path_564686, "subscriptionId", newJString(subscriptionId))
  add(path_564686, "resourceGroupName", newJString(resourceGroupName))
  add(path_564686, "resourceName", newJString(resourceName))
  result = call_564685.call(path_564686, query_564687, nil, nil, nil)

var replicationProtectedItemsRepairReplication* = Call_ReplicationProtectedItemsRepairReplication_564674(
    name: "replicationProtectedItemsRepairReplication", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/repairReplication",
    validator: validate_ReplicationProtectedItemsRepairReplication_564675,
    base: "", url: url_ReplicationProtectedItemsRepairReplication_564676,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsTestFailover_564688 = ref object of OpenApiRestCall_563564
proc url_ReplicationProtectedItemsTestFailover_564690(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "replicatedProtectedItemName" in path,
        "`replicatedProtectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems/"),
               (kind: VariableSegment, value: "replicatedProtectedItemName"),
               (kind: ConstantSegment, value: "/testFailover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsTestFailover_564689(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Operation to perform a test failover of the replication protected item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : Replication protected item name.
  ##   fabricName: JString (required)
  ##             : Unique fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564691 = path.getOrDefault("protectionContainerName")
  valid_564691 = validateParameter(valid_564691, JString, required = true,
                                 default = nil)
  if valid_564691 != nil:
    section.add "protectionContainerName", valid_564691
  var valid_564692 = path.getOrDefault("replicatedProtectedItemName")
  valid_564692 = validateParameter(valid_564692, JString, required = true,
                                 default = nil)
  if valid_564692 != nil:
    section.add "replicatedProtectedItemName", valid_564692
  var valid_564693 = path.getOrDefault("fabricName")
  valid_564693 = validateParameter(valid_564693, JString, required = true,
                                 default = nil)
  if valid_564693 != nil:
    section.add "fabricName", valid_564693
  var valid_564694 = path.getOrDefault("subscriptionId")
  valid_564694 = validateParameter(valid_564694, JString, required = true,
                                 default = nil)
  if valid_564694 != nil:
    section.add "subscriptionId", valid_564694
  var valid_564695 = path.getOrDefault("resourceGroupName")
  valid_564695 = validateParameter(valid_564695, JString, required = true,
                                 default = nil)
  if valid_564695 != nil:
    section.add "resourceGroupName", valid_564695
  var valid_564696 = path.getOrDefault("resourceName")
  valid_564696 = validateParameter(valid_564696, JString, required = true,
                                 default = nil)
  if valid_564696 != nil:
    section.add "resourceName", valid_564696
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564697 = query.getOrDefault("api-version")
  valid_564697 = validateParameter(valid_564697, JString, required = true,
                                 default = nil)
  if valid_564697 != nil:
    section.add "api-version", valid_564697
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   failoverInput: JObject (required)
  ##                : Test failover input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564699: Call_ReplicationProtectedItemsTestFailover_564688;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to perform a test failover of the replication protected item.
  ## 
  let valid = call_564699.validator(path, query, header, formData, body)
  let scheme = call_564699.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564699.url(scheme.get, call_564699.host, call_564699.base,
                         call_564699.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564699, url, valid)

proc call*(call_564700: Call_ReplicationProtectedItemsTestFailover_564688;
          protectionContainerName: string; apiVersion: string;
          replicatedProtectedItemName: string; fabricName: string;
          subscriptionId: string; resourceGroupName: string;
          failoverInput: JsonNode; resourceName: string): Recallable =
  ## replicationProtectedItemsTestFailover
  ## Operation to perform a test failover of the replication protected item.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   replicatedProtectedItemName: string (required)
  ##                              : Replication protected item name.
  ##   fabricName: string (required)
  ##             : Unique fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   failoverInput: JObject (required)
  ##                : Test failover input.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564701 = newJObject()
  var query_564702 = newJObject()
  var body_564703 = newJObject()
  add(path_564701, "protectionContainerName", newJString(protectionContainerName))
  add(query_564702, "api-version", newJString(apiVersion))
  add(path_564701, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564701, "fabricName", newJString(fabricName))
  add(path_564701, "subscriptionId", newJString(subscriptionId))
  add(path_564701, "resourceGroupName", newJString(resourceGroupName))
  if failoverInput != nil:
    body_564703 = failoverInput
  add(path_564701, "resourceName", newJString(resourceName))
  result = call_564700.call(path_564701, query_564702, nil, nil, body_564703)

var replicationProtectedItemsTestFailover* = Call_ReplicationProtectedItemsTestFailover_564688(
    name: "replicationProtectedItemsTestFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/testFailover",
    validator: validate_ReplicationProtectedItemsTestFailover_564689, base: "",
    url: url_ReplicationProtectedItemsTestFailover_564690, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsTestFailoverCleanup_564704 = ref object of OpenApiRestCall_563564
proc url_ReplicationProtectedItemsTestFailoverCleanup_564706(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "replicatedProtectedItemName" in path,
        "`replicatedProtectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems/"),
               (kind: VariableSegment, value: "replicatedProtectedItemName"),
               (kind: ConstantSegment, value: "/testFailoverCleanup")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsTestFailoverCleanup_564705(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Operation to clean up the test failover of a replication protected item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : Replication protected item name.
  ##   fabricName: JString (required)
  ##             : Unique fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564707 = path.getOrDefault("protectionContainerName")
  valid_564707 = validateParameter(valid_564707, JString, required = true,
                                 default = nil)
  if valid_564707 != nil:
    section.add "protectionContainerName", valid_564707
  var valid_564708 = path.getOrDefault("replicatedProtectedItemName")
  valid_564708 = validateParameter(valid_564708, JString, required = true,
                                 default = nil)
  if valid_564708 != nil:
    section.add "replicatedProtectedItemName", valid_564708
  var valid_564709 = path.getOrDefault("fabricName")
  valid_564709 = validateParameter(valid_564709, JString, required = true,
                                 default = nil)
  if valid_564709 != nil:
    section.add "fabricName", valid_564709
  var valid_564710 = path.getOrDefault("subscriptionId")
  valid_564710 = validateParameter(valid_564710, JString, required = true,
                                 default = nil)
  if valid_564710 != nil:
    section.add "subscriptionId", valid_564710
  var valid_564711 = path.getOrDefault("resourceGroupName")
  valid_564711 = validateParameter(valid_564711, JString, required = true,
                                 default = nil)
  if valid_564711 != nil:
    section.add "resourceGroupName", valid_564711
  var valid_564712 = path.getOrDefault("resourceName")
  valid_564712 = validateParameter(valid_564712, JString, required = true,
                                 default = nil)
  if valid_564712 != nil:
    section.add "resourceName", valid_564712
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564713 = query.getOrDefault("api-version")
  valid_564713 = validateParameter(valid_564713, JString, required = true,
                                 default = nil)
  if valid_564713 != nil:
    section.add "api-version", valid_564713
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   cleanupInput: JObject (required)
  ##               : Test failover cleanup input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564715: Call_ReplicationProtectedItemsTestFailoverCleanup_564704;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to clean up the test failover of a replication protected item.
  ## 
  let valid = call_564715.validator(path, query, header, formData, body)
  let scheme = call_564715.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564715.url(scheme.get, call_564715.host, call_564715.base,
                         call_564715.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564715, url, valid)

proc call*(call_564716: Call_ReplicationProtectedItemsTestFailoverCleanup_564704;
          protectionContainerName: string; apiVersion: string;
          replicatedProtectedItemName: string; fabricName: string;
          subscriptionId: string; cleanupInput: JsonNode; resourceGroupName: string;
          resourceName: string): Recallable =
  ## replicationProtectedItemsTestFailoverCleanup
  ## Operation to clean up the test failover of a replication protected item.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   replicatedProtectedItemName: string (required)
  ##                              : Replication protected item name.
  ##   fabricName: string (required)
  ##             : Unique fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   cleanupInput: JObject (required)
  ##               : Test failover cleanup input.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564717 = newJObject()
  var query_564718 = newJObject()
  var body_564719 = newJObject()
  add(path_564717, "protectionContainerName", newJString(protectionContainerName))
  add(query_564718, "api-version", newJString(apiVersion))
  add(path_564717, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564717, "fabricName", newJString(fabricName))
  add(path_564717, "subscriptionId", newJString(subscriptionId))
  if cleanupInput != nil:
    body_564719 = cleanupInput
  add(path_564717, "resourceGroupName", newJString(resourceGroupName))
  add(path_564717, "resourceName", newJString(resourceName))
  result = call_564716.call(path_564717, query_564718, nil, nil, body_564719)

var replicationProtectedItemsTestFailoverCleanup* = Call_ReplicationProtectedItemsTestFailoverCleanup_564704(
    name: "replicationProtectedItemsTestFailoverCleanup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/testFailoverCleanup",
    validator: validate_ReplicationProtectedItemsTestFailoverCleanup_564705,
    base: "", url: url_ReplicationProtectedItemsTestFailoverCleanup_564706,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsUnplannedFailover_564720 = ref object of OpenApiRestCall_563564
proc url_ReplicationProtectedItemsUnplannedFailover_564722(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "replicatedProtectedItemName" in path,
        "`replicatedProtectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems/"),
               (kind: VariableSegment, value: "replicatedProtectedItemName"),
               (kind: ConstantSegment, value: "/unplannedFailover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsUnplannedFailover_564721(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Operation to initiate a failover of the replication protected item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : Replication protected item name.
  ##   fabricName: JString (required)
  ##             : Unique fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564723 = path.getOrDefault("protectionContainerName")
  valid_564723 = validateParameter(valid_564723, JString, required = true,
                                 default = nil)
  if valid_564723 != nil:
    section.add "protectionContainerName", valid_564723
  var valid_564724 = path.getOrDefault("replicatedProtectedItemName")
  valid_564724 = validateParameter(valid_564724, JString, required = true,
                                 default = nil)
  if valid_564724 != nil:
    section.add "replicatedProtectedItemName", valid_564724
  var valid_564725 = path.getOrDefault("fabricName")
  valid_564725 = validateParameter(valid_564725, JString, required = true,
                                 default = nil)
  if valid_564725 != nil:
    section.add "fabricName", valid_564725
  var valid_564726 = path.getOrDefault("subscriptionId")
  valid_564726 = validateParameter(valid_564726, JString, required = true,
                                 default = nil)
  if valid_564726 != nil:
    section.add "subscriptionId", valid_564726
  var valid_564727 = path.getOrDefault("resourceGroupName")
  valid_564727 = validateParameter(valid_564727, JString, required = true,
                                 default = nil)
  if valid_564727 != nil:
    section.add "resourceGroupName", valid_564727
  var valid_564728 = path.getOrDefault("resourceName")
  valid_564728 = validateParameter(valid_564728, JString, required = true,
                                 default = nil)
  if valid_564728 != nil:
    section.add "resourceName", valid_564728
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564729 = query.getOrDefault("api-version")
  valid_564729 = validateParameter(valid_564729, JString, required = true,
                                 default = nil)
  if valid_564729 != nil:
    section.add "api-version", valid_564729
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   failoverInput: JObject (required)
  ##                : Disable protection input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564731: Call_ReplicationProtectedItemsUnplannedFailover_564720;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to initiate a failover of the replication protected item.
  ## 
  let valid = call_564731.validator(path, query, header, formData, body)
  let scheme = call_564731.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564731.url(scheme.get, call_564731.host, call_564731.base,
                         call_564731.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564731, url, valid)

proc call*(call_564732: Call_ReplicationProtectedItemsUnplannedFailover_564720;
          protectionContainerName: string; apiVersion: string;
          replicatedProtectedItemName: string; fabricName: string;
          subscriptionId: string; resourceGroupName: string;
          failoverInput: JsonNode; resourceName: string): Recallable =
  ## replicationProtectedItemsUnplannedFailover
  ## Operation to initiate a failover of the replication protected item.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   replicatedProtectedItemName: string (required)
  ##                              : Replication protected item name.
  ##   fabricName: string (required)
  ##             : Unique fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   failoverInput: JObject (required)
  ##                : Disable protection input.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564733 = newJObject()
  var query_564734 = newJObject()
  var body_564735 = newJObject()
  add(path_564733, "protectionContainerName", newJString(protectionContainerName))
  add(query_564734, "api-version", newJString(apiVersion))
  add(path_564733, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564733, "fabricName", newJString(fabricName))
  add(path_564733, "subscriptionId", newJString(subscriptionId))
  add(path_564733, "resourceGroupName", newJString(resourceGroupName))
  if failoverInput != nil:
    body_564735 = failoverInput
  add(path_564733, "resourceName", newJString(resourceName))
  result = call_564732.call(path_564733, query_564734, nil, nil, body_564735)

var replicationProtectedItemsUnplannedFailover* = Call_ReplicationProtectedItemsUnplannedFailover_564720(
    name: "replicationProtectedItemsUnplannedFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/unplannedFailover",
    validator: validate_ReplicationProtectedItemsUnplannedFailover_564721,
    base: "", url: url_ReplicationProtectedItemsUnplannedFailover_564722,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsUpdateMobilityService_564736 = ref object of OpenApiRestCall_563564
proc url_ReplicationProtectedItemsUpdateMobilityService_564738(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "replicationProtectedItemName" in path,
        "`replicationProtectedItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems/"),
               (kind: VariableSegment, value: "replicationProtectedItemName"),
               (kind: ConstantSegment, value: "/updateMobilityService")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsUpdateMobilityService_564737(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The operation to update(push update) the installed mobility service software on a replication protected item to the latest available version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   protectionContainerName: JString (required)
  ##                          : The name of the container containing the protected item.
  ##   replicationProtectedItemName: JString (required)
  ##                               : The name of the protected item on which the agent is to be updated.
  ##   fabricName: JString (required)
  ##             : The name of the fabric containing the protected item.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564739 = path.getOrDefault("protectionContainerName")
  valid_564739 = validateParameter(valid_564739, JString, required = true,
                                 default = nil)
  if valid_564739 != nil:
    section.add "protectionContainerName", valid_564739
  var valid_564740 = path.getOrDefault("replicationProtectedItemName")
  valid_564740 = validateParameter(valid_564740, JString, required = true,
                                 default = nil)
  if valid_564740 != nil:
    section.add "replicationProtectedItemName", valid_564740
  var valid_564741 = path.getOrDefault("fabricName")
  valid_564741 = validateParameter(valid_564741, JString, required = true,
                                 default = nil)
  if valid_564741 != nil:
    section.add "fabricName", valid_564741
  var valid_564742 = path.getOrDefault("subscriptionId")
  valid_564742 = validateParameter(valid_564742, JString, required = true,
                                 default = nil)
  if valid_564742 != nil:
    section.add "subscriptionId", valid_564742
  var valid_564743 = path.getOrDefault("resourceGroupName")
  valid_564743 = validateParameter(valid_564743, JString, required = true,
                                 default = nil)
  if valid_564743 != nil:
    section.add "resourceGroupName", valid_564743
  var valid_564744 = path.getOrDefault("resourceName")
  valid_564744 = validateParameter(valid_564744, JString, required = true,
                                 default = nil)
  if valid_564744 != nil:
    section.add "resourceName", valid_564744
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564745 = query.getOrDefault("api-version")
  valid_564745 = validateParameter(valid_564745, JString, required = true,
                                 default = nil)
  if valid_564745 != nil:
    section.add "api-version", valid_564745
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   updateMobilityServiceRequest: JObject (required)
  ##                               : Request to update the mobility service on the protected item.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564747: Call_ReplicationProtectedItemsUpdateMobilityService_564736;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to update(push update) the installed mobility service software on a replication protected item to the latest available version.
  ## 
  let valid = call_564747.validator(path, query, header, formData, body)
  let scheme = call_564747.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564747.url(scheme.get, call_564747.host, call_564747.base,
                         call_564747.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564747, url, valid)

proc call*(call_564748: Call_ReplicationProtectedItemsUpdateMobilityService_564736;
          protectionContainerName: string; apiVersion: string;
          replicationProtectedItemName: string; fabricName: string;
          subscriptionId: string; resourceGroupName: string;
          updateMobilityServiceRequest: JsonNode; resourceName: string): Recallable =
  ## replicationProtectedItemsUpdateMobilityService
  ## The operation to update(push update) the installed mobility service software on a replication protected item to the latest available version.
  ##   protectionContainerName: string (required)
  ##                          : The name of the container containing the protected item.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   replicationProtectedItemName: string (required)
  ##                               : The name of the protected item on which the agent is to be updated.
  ##   fabricName: string (required)
  ##             : The name of the fabric containing the protected item.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   updateMobilityServiceRequest: JObject (required)
  ##                               : Request to update the mobility service on the protected item.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564749 = newJObject()
  var query_564750 = newJObject()
  var body_564751 = newJObject()
  add(path_564749, "protectionContainerName", newJString(protectionContainerName))
  add(query_564750, "api-version", newJString(apiVersion))
  add(path_564749, "replicationProtectedItemName",
      newJString(replicationProtectedItemName))
  add(path_564749, "fabricName", newJString(fabricName))
  add(path_564749, "subscriptionId", newJString(subscriptionId))
  add(path_564749, "resourceGroupName", newJString(resourceGroupName))
  if updateMobilityServiceRequest != nil:
    body_564751 = updateMobilityServiceRequest
  add(path_564749, "resourceName", newJString(resourceName))
  result = call_564748.call(path_564749, query_564750, nil, nil, body_564751)

var replicationProtectedItemsUpdateMobilityService* = Call_ReplicationProtectedItemsUpdateMobilityService_564736(
    name: "replicationProtectedItemsUpdateMobilityService",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicationProtectedItemName}/updateMobilityService",
    validator: validate_ReplicationProtectedItemsUpdateMobilityService_564737,
    base: "", url: url_ReplicationProtectedItemsUpdateMobilityService_564738,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_564752 = ref object of OpenApiRestCall_563564
proc url_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_564754(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"), (
        kind: ConstantSegment, value: "/replicationProtectionContainerMappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_564753(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the protection container mappings for a protection container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564755 = path.getOrDefault("protectionContainerName")
  valid_564755 = validateParameter(valid_564755, JString, required = true,
                                 default = nil)
  if valid_564755 != nil:
    section.add "protectionContainerName", valid_564755
  var valid_564756 = path.getOrDefault("fabricName")
  valid_564756 = validateParameter(valid_564756, JString, required = true,
                                 default = nil)
  if valid_564756 != nil:
    section.add "fabricName", valid_564756
  var valid_564757 = path.getOrDefault("subscriptionId")
  valid_564757 = validateParameter(valid_564757, JString, required = true,
                                 default = nil)
  if valid_564757 != nil:
    section.add "subscriptionId", valid_564757
  var valid_564758 = path.getOrDefault("resourceGroupName")
  valid_564758 = validateParameter(valid_564758, JString, required = true,
                                 default = nil)
  if valid_564758 != nil:
    section.add "resourceGroupName", valid_564758
  var valid_564759 = path.getOrDefault("resourceName")
  valid_564759 = validateParameter(valid_564759, JString, required = true,
                                 default = nil)
  if valid_564759 != nil:
    section.add "resourceName", valid_564759
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564760 = query.getOrDefault("api-version")
  valid_564760 = validateParameter(valid_564760, JString, required = true,
                                 default = nil)
  if valid_564760 != nil:
    section.add "api-version", valid_564760
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564761: Call_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_564752;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the protection container mappings for a protection container.
  ## 
  let valid = call_564761.validator(path, query, header, formData, body)
  let scheme = call_564761.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564761.url(scheme.get, call_564761.host, call_564761.base,
                         call_564761.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564761, url, valid)

proc call*(call_564762: Call_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_564752;
          protectionContainerName: string; apiVersion: string; fabricName: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## replicationProtectionContainerMappingsListByReplicationProtectionContainers
  ## Lists the protection container mappings for a protection container.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564763 = newJObject()
  var query_564764 = newJObject()
  add(path_564763, "protectionContainerName", newJString(protectionContainerName))
  add(query_564764, "api-version", newJString(apiVersion))
  add(path_564763, "fabricName", newJString(fabricName))
  add(path_564763, "subscriptionId", newJString(subscriptionId))
  add(path_564763, "resourceGroupName", newJString(resourceGroupName))
  add(path_564763, "resourceName", newJString(resourceName))
  result = call_564762.call(path_564763, query_564764, nil, nil, nil)

var replicationProtectionContainerMappingsListByReplicationProtectionContainers* = Call_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_564752(name: "replicationProtectionContainerMappingsListByReplicationProtectionContainers",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings", validator: validate_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_564753,
    base: "", url: url_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_564754,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsCreate_564779 = ref object of OpenApiRestCall_563564
proc url_ReplicationProtectionContainerMappingsCreate_564781(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "mappingName" in path, "`mappingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"), (
        kind: ConstantSegment, value: "/replicationProtectionContainerMappings/"),
               (kind: VariableSegment, value: "mappingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectionContainerMappingsCreate_564780(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create a protection container mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   mappingName: JString (required)
  ##              : Protection container mapping name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564782 = path.getOrDefault("protectionContainerName")
  valid_564782 = validateParameter(valid_564782, JString, required = true,
                                 default = nil)
  if valid_564782 != nil:
    section.add "protectionContainerName", valid_564782
  var valid_564783 = path.getOrDefault("fabricName")
  valid_564783 = validateParameter(valid_564783, JString, required = true,
                                 default = nil)
  if valid_564783 != nil:
    section.add "fabricName", valid_564783
  var valid_564784 = path.getOrDefault("subscriptionId")
  valid_564784 = validateParameter(valid_564784, JString, required = true,
                                 default = nil)
  if valid_564784 != nil:
    section.add "subscriptionId", valid_564784
  var valid_564785 = path.getOrDefault("mappingName")
  valid_564785 = validateParameter(valid_564785, JString, required = true,
                                 default = nil)
  if valid_564785 != nil:
    section.add "mappingName", valid_564785
  var valid_564786 = path.getOrDefault("resourceGroupName")
  valid_564786 = validateParameter(valid_564786, JString, required = true,
                                 default = nil)
  if valid_564786 != nil:
    section.add "resourceGroupName", valid_564786
  var valid_564787 = path.getOrDefault("resourceName")
  valid_564787 = validateParameter(valid_564787, JString, required = true,
                                 default = nil)
  if valid_564787 != nil:
    section.add "resourceName", valid_564787
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564788 = query.getOrDefault("api-version")
  valid_564788 = validateParameter(valid_564788, JString, required = true,
                                 default = nil)
  if valid_564788 != nil:
    section.add "api-version", valid_564788
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   creationInput: JObject (required)
  ##                : Mapping creation input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564790: Call_ReplicationProtectionContainerMappingsCreate_564779;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create a protection container mapping.
  ## 
  let valid = call_564790.validator(path, query, header, formData, body)
  let scheme = call_564790.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564790.url(scheme.get, call_564790.host, call_564790.base,
                         call_564790.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564790, url, valid)

proc call*(call_564791: Call_ReplicationProtectionContainerMappingsCreate_564779;
          protectionContainerName: string; apiVersion: string;
          creationInput: JsonNode; fabricName: string; subscriptionId: string;
          mappingName: string; resourceGroupName: string; resourceName: string): Recallable =
  ## replicationProtectionContainerMappingsCreate
  ## The operation to create a protection container mapping.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   creationInput: JObject (required)
  ##                : Mapping creation input.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   mappingName: string (required)
  ##              : Protection container mapping name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564792 = newJObject()
  var query_564793 = newJObject()
  var body_564794 = newJObject()
  add(path_564792, "protectionContainerName", newJString(protectionContainerName))
  add(query_564793, "api-version", newJString(apiVersion))
  if creationInput != nil:
    body_564794 = creationInput
  add(path_564792, "fabricName", newJString(fabricName))
  add(path_564792, "subscriptionId", newJString(subscriptionId))
  add(path_564792, "mappingName", newJString(mappingName))
  add(path_564792, "resourceGroupName", newJString(resourceGroupName))
  add(path_564792, "resourceName", newJString(resourceName))
  result = call_564791.call(path_564792, query_564793, nil, nil, body_564794)

var replicationProtectionContainerMappingsCreate* = Call_ReplicationProtectionContainerMappingsCreate_564779(
    name: "replicationProtectionContainerMappingsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}",
    validator: validate_ReplicationProtectionContainerMappingsCreate_564780,
    base: "", url: url_ReplicationProtectionContainerMappingsCreate_564781,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsGet_564765 = ref object of OpenApiRestCall_563564
proc url_ReplicationProtectionContainerMappingsGet_564767(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "mappingName" in path, "`mappingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"), (
        kind: ConstantSegment, value: "/replicationProtectionContainerMappings/"),
               (kind: VariableSegment, value: "mappingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectionContainerMappingsGet_564766(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of a protection container mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   mappingName: JString (required)
  ##              : Protection Container mapping name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564768 = path.getOrDefault("protectionContainerName")
  valid_564768 = validateParameter(valid_564768, JString, required = true,
                                 default = nil)
  if valid_564768 != nil:
    section.add "protectionContainerName", valid_564768
  var valid_564769 = path.getOrDefault("fabricName")
  valid_564769 = validateParameter(valid_564769, JString, required = true,
                                 default = nil)
  if valid_564769 != nil:
    section.add "fabricName", valid_564769
  var valid_564770 = path.getOrDefault("subscriptionId")
  valid_564770 = validateParameter(valid_564770, JString, required = true,
                                 default = nil)
  if valid_564770 != nil:
    section.add "subscriptionId", valid_564770
  var valid_564771 = path.getOrDefault("mappingName")
  valid_564771 = validateParameter(valid_564771, JString, required = true,
                                 default = nil)
  if valid_564771 != nil:
    section.add "mappingName", valid_564771
  var valid_564772 = path.getOrDefault("resourceGroupName")
  valid_564772 = validateParameter(valid_564772, JString, required = true,
                                 default = nil)
  if valid_564772 != nil:
    section.add "resourceGroupName", valid_564772
  var valid_564773 = path.getOrDefault("resourceName")
  valid_564773 = validateParameter(valid_564773, JString, required = true,
                                 default = nil)
  if valid_564773 != nil:
    section.add "resourceName", valid_564773
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564774 = query.getOrDefault("api-version")
  valid_564774 = validateParameter(valid_564774, JString, required = true,
                                 default = nil)
  if valid_564774 != nil:
    section.add "api-version", valid_564774
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564775: Call_ReplicationProtectionContainerMappingsGet_564765;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of a protection container mapping.
  ## 
  let valid = call_564775.validator(path, query, header, formData, body)
  let scheme = call_564775.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564775.url(scheme.get, call_564775.host, call_564775.base,
                         call_564775.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564775, url, valid)

proc call*(call_564776: Call_ReplicationProtectionContainerMappingsGet_564765;
          protectionContainerName: string; apiVersion: string; fabricName: string;
          subscriptionId: string; mappingName: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## replicationProtectionContainerMappingsGet
  ## Gets the details of a protection container mapping.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   mappingName: string (required)
  ##              : Protection Container mapping name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564777 = newJObject()
  var query_564778 = newJObject()
  add(path_564777, "protectionContainerName", newJString(protectionContainerName))
  add(query_564778, "api-version", newJString(apiVersion))
  add(path_564777, "fabricName", newJString(fabricName))
  add(path_564777, "subscriptionId", newJString(subscriptionId))
  add(path_564777, "mappingName", newJString(mappingName))
  add(path_564777, "resourceGroupName", newJString(resourceGroupName))
  add(path_564777, "resourceName", newJString(resourceName))
  result = call_564776.call(path_564777, query_564778, nil, nil, nil)

var replicationProtectionContainerMappingsGet* = Call_ReplicationProtectionContainerMappingsGet_564765(
    name: "replicationProtectionContainerMappingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}",
    validator: validate_ReplicationProtectionContainerMappingsGet_564766,
    base: "", url: url_ReplicationProtectionContainerMappingsGet_564767,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsPurge_564795 = ref object of OpenApiRestCall_563564
proc url_ReplicationProtectionContainerMappingsPurge_564797(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "mappingName" in path, "`mappingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"), (
        kind: ConstantSegment, value: "/replicationProtectionContainerMappings/"),
               (kind: VariableSegment, value: "mappingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectionContainerMappingsPurge_564796(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to purge(force delete) a protection container mapping
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   mappingName: JString (required)
  ##              : Protection container mapping name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564798 = path.getOrDefault("protectionContainerName")
  valid_564798 = validateParameter(valid_564798, JString, required = true,
                                 default = nil)
  if valid_564798 != nil:
    section.add "protectionContainerName", valid_564798
  var valid_564799 = path.getOrDefault("fabricName")
  valid_564799 = validateParameter(valid_564799, JString, required = true,
                                 default = nil)
  if valid_564799 != nil:
    section.add "fabricName", valid_564799
  var valid_564800 = path.getOrDefault("subscriptionId")
  valid_564800 = validateParameter(valid_564800, JString, required = true,
                                 default = nil)
  if valid_564800 != nil:
    section.add "subscriptionId", valid_564800
  var valid_564801 = path.getOrDefault("mappingName")
  valid_564801 = validateParameter(valid_564801, JString, required = true,
                                 default = nil)
  if valid_564801 != nil:
    section.add "mappingName", valid_564801
  var valid_564802 = path.getOrDefault("resourceGroupName")
  valid_564802 = validateParameter(valid_564802, JString, required = true,
                                 default = nil)
  if valid_564802 != nil:
    section.add "resourceGroupName", valid_564802
  var valid_564803 = path.getOrDefault("resourceName")
  valid_564803 = validateParameter(valid_564803, JString, required = true,
                                 default = nil)
  if valid_564803 != nil:
    section.add "resourceName", valid_564803
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564804 = query.getOrDefault("api-version")
  valid_564804 = validateParameter(valid_564804, JString, required = true,
                                 default = nil)
  if valid_564804 != nil:
    section.add "api-version", valid_564804
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564805: Call_ReplicationProtectionContainerMappingsPurge_564795;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to purge(force delete) a protection container mapping
  ## 
  let valid = call_564805.validator(path, query, header, formData, body)
  let scheme = call_564805.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564805.url(scheme.get, call_564805.host, call_564805.base,
                         call_564805.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564805, url, valid)

proc call*(call_564806: Call_ReplicationProtectionContainerMappingsPurge_564795;
          protectionContainerName: string; apiVersion: string; fabricName: string;
          subscriptionId: string; mappingName: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## replicationProtectionContainerMappingsPurge
  ## The operation to purge(force delete) a protection container mapping
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   mappingName: string (required)
  ##              : Protection container mapping name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564807 = newJObject()
  var query_564808 = newJObject()
  add(path_564807, "protectionContainerName", newJString(protectionContainerName))
  add(query_564808, "api-version", newJString(apiVersion))
  add(path_564807, "fabricName", newJString(fabricName))
  add(path_564807, "subscriptionId", newJString(subscriptionId))
  add(path_564807, "mappingName", newJString(mappingName))
  add(path_564807, "resourceGroupName", newJString(resourceGroupName))
  add(path_564807, "resourceName", newJString(resourceName))
  result = call_564806.call(path_564807, query_564808, nil, nil, nil)

var replicationProtectionContainerMappingsPurge* = Call_ReplicationProtectionContainerMappingsPurge_564795(
    name: "replicationProtectionContainerMappingsPurge",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}",
    validator: validate_ReplicationProtectionContainerMappingsPurge_564796,
    base: "", url: url_ReplicationProtectionContainerMappingsPurge_564797,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsDelete_564809 = ref object of OpenApiRestCall_563564
proc url_ReplicationProtectionContainerMappingsDelete_564811(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  assert "mappingName" in path, "`mappingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"), (
        kind: ConstantSegment, value: "/replicationProtectionContainerMappings/"),
               (kind: VariableSegment, value: "mappingName"),
               (kind: ConstantSegment, value: "/remove")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectionContainerMappingsDelete_564810(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete or remove a protection container mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   mappingName: JString (required)
  ##              : Protection container mapping name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564812 = path.getOrDefault("protectionContainerName")
  valid_564812 = validateParameter(valid_564812, JString, required = true,
                                 default = nil)
  if valid_564812 != nil:
    section.add "protectionContainerName", valid_564812
  var valid_564813 = path.getOrDefault("fabricName")
  valid_564813 = validateParameter(valid_564813, JString, required = true,
                                 default = nil)
  if valid_564813 != nil:
    section.add "fabricName", valid_564813
  var valid_564814 = path.getOrDefault("subscriptionId")
  valid_564814 = validateParameter(valid_564814, JString, required = true,
                                 default = nil)
  if valid_564814 != nil:
    section.add "subscriptionId", valid_564814
  var valid_564815 = path.getOrDefault("mappingName")
  valid_564815 = validateParameter(valid_564815, JString, required = true,
                                 default = nil)
  if valid_564815 != nil:
    section.add "mappingName", valid_564815
  var valid_564816 = path.getOrDefault("resourceGroupName")
  valid_564816 = validateParameter(valid_564816, JString, required = true,
                                 default = nil)
  if valid_564816 != nil:
    section.add "resourceGroupName", valid_564816
  var valid_564817 = path.getOrDefault("resourceName")
  valid_564817 = validateParameter(valid_564817, JString, required = true,
                                 default = nil)
  if valid_564817 != nil:
    section.add "resourceName", valid_564817
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564818 = query.getOrDefault("api-version")
  valid_564818 = validateParameter(valid_564818, JString, required = true,
                                 default = nil)
  if valid_564818 != nil:
    section.add "api-version", valid_564818
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   removalInput: JObject (required)
  ##               : Removal input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564820: Call_ReplicationProtectionContainerMappingsDelete_564809;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete or remove a protection container mapping.
  ## 
  let valid = call_564820.validator(path, query, header, formData, body)
  let scheme = call_564820.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564820.url(scheme.get, call_564820.host, call_564820.base,
                         call_564820.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564820, url, valid)

proc call*(call_564821: Call_ReplicationProtectionContainerMappingsDelete_564809;
          protectionContainerName: string; apiVersion: string; fabricName: string;
          subscriptionId: string; mappingName: string; resourceGroupName: string;
          removalInput: JsonNode; resourceName: string): Recallable =
  ## replicationProtectionContainerMappingsDelete
  ## The operation to delete or remove a protection container mapping.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   mappingName: string (required)
  ##              : Protection container mapping name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   removalInput: JObject (required)
  ##               : Removal input.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564822 = newJObject()
  var query_564823 = newJObject()
  var body_564824 = newJObject()
  add(path_564822, "protectionContainerName", newJString(protectionContainerName))
  add(query_564823, "api-version", newJString(apiVersion))
  add(path_564822, "fabricName", newJString(fabricName))
  add(path_564822, "subscriptionId", newJString(subscriptionId))
  add(path_564822, "mappingName", newJString(mappingName))
  add(path_564822, "resourceGroupName", newJString(resourceGroupName))
  if removalInput != nil:
    body_564824 = removalInput
  add(path_564822, "resourceName", newJString(resourceName))
  result = call_564821.call(path_564822, query_564823, nil, nil, body_564824)

var replicationProtectionContainerMappingsDelete* = Call_ReplicationProtectionContainerMappingsDelete_564809(
    name: "replicationProtectionContainerMappingsDelete",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}/remove",
    validator: validate_ReplicationProtectionContainerMappingsDelete_564810,
    base: "", url: url_ReplicationProtectionContainerMappingsDelete_564811,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersSwitchProtection_564825 = ref object of OpenApiRestCall_563564
proc url_ReplicationProtectionContainersSwitchProtection_564827(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "protectionContainerName" in path,
        "`protectionContainerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationProtectionContainers/"),
               (kind: VariableSegment, value: "protectionContainerName"),
               (kind: ConstantSegment, value: "/switchprotection")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectionContainersSwitchProtection_564826(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Operation to switch protection from one container to another or one replication provider to another.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   fabricName: JString (required)
  ##             : Unique fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564828 = path.getOrDefault("protectionContainerName")
  valid_564828 = validateParameter(valid_564828, JString, required = true,
                                 default = nil)
  if valid_564828 != nil:
    section.add "protectionContainerName", valid_564828
  var valid_564829 = path.getOrDefault("fabricName")
  valid_564829 = validateParameter(valid_564829, JString, required = true,
                                 default = nil)
  if valid_564829 != nil:
    section.add "fabricName", valid_564829
  var valid_564830 = path.getOrDefault("subscriptionId")
  valid_564830 = validateParameter(valid_564830, JString, required = true,
                                 default = nil)
  if valid_564830 != nil:
    section.add "subscriptionId", valid_564830
  var valid_564831 = path.getOrDefault("resourceGroupName")
  valid_564831 = validateParameter(valid_564831, JString, required = true,
                                 default = nil)
  if valid_564831 != nil:
    section.add "resourceGroupName", valid_564831
  var valid_564832 = path.getOrDefault("resourceName")
  valid_564832 = validateParameter(valid_564832, JString, required = true,
                                 default = nil)
  if valid_564832 != nil:
    section.add "resourceName", valid_564832
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564833 = query.getOrDefault("api-version")
  valid_564833 = validateParameter(valid_564833, JString, required = true,
                                 default = nil)
  if valid_564833 != nil:
    section.add "api-version", valid_564833
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   switchInput: JObject (required)
  ##              : Switch protection input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564835: Call_ReplicationProtectionContainersSwitchProtection_564825;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to switch protection from one container to another or one replication provider to another.
  ## 
  let valid = call_564835.validator(path, query, header, formData, body)
  let scheme = call_564835.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564835.url(scheme.get, call_564835.host, call_564835.base,
                         call_564835.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564835, url, valid)

proc call*(call_564836: Call_ReplicationProtectionContainersSwitchProtection_564825;
          protectionContainerName: string; apiVersion: string; fabricName: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string;
          switchInput: JsonNode): Recallable =
  ## replicationProtectionContainersSwitchProtection
  ## Operation to switch protection from one container to another or one replication provider to another.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Unique fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   switchInput: JObject (required)
  ##              : Switch protection input.
  var path_564837 = newJObject()
  var query_564838 = newJObject()
  var body_564839 = newJObject()
  add(path_564837, "protectionContainerName", newJString(protectionContainerName))
  add(query_564838, "api-version", newJString(apiVersion))
  add(path_564837, "fabricName", newJString(fabricName))
  add(path_564837, "subscriptionId", newJString(subscriptionId))
  add(path_564837, "resourceGroupName", newJString(resourceGroupName))
  add(path_564837, "resourceName", newJString(resourceName))
  if switchInput != nil:
    body_564839 = switchInput
  result = call_564836.call(path_564837, query_564838, nil, nil, body_564839)

var replicationProtectionContainersSwitchProtection* = Call_ReplicationProtectionContainersSwitchProtection_564825(
    name: "replicationProtectionContainersSwitchProtection",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/switchprotection",
    validator: validate_ReplicationProtectionContainersSwitchProtection_564826,
    base: "", url: url_ReplicationProtectionContainersSwitchProtection_564827,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersListByReplicationFabrics_564840 = ref object of OpenApiRestCall_563564
proc url_ReplicationRecoveryServicesProvidersListByReplicationFabrics_564842(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationRecoveryServicesProviders")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationRecoveryServicesProvidersListByReplicationFabrics_564841(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the registered recovery services providers for the specified fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_564843 = path.getOrDefault("fabricName")
  valid_564843 = validateParameter(valid_564843, JString, required = true,
                                 default = nil)
  if valid_564843 != nil:
    section.add "fabricName", valid_564843
  var valid_564844 = path.getOrDefault("subscriptionId")
  valid_564844 = validateParameter(valid_564844, JString, required = true,
                                 default = nil)
  if valid_564844 != nil:
    section.add "subscriptionId", valid_564844
  var valid_564845 = path.getOrDefault("resourceGroupName")
  valid_564845 = validateParameter(valid_564845, JString, required = true,
                                 default = nil)
  if valid_564845 != nil:
    section.add "resourceGroupName", valid_564845
  var valid_564846 = path.getOrDefault("resourceName")
  valid_564846 = validateParameter(valid_564846, JString, required = true,
                                 default = nil)
  if valid_564846 != nil:
    section.add "resourceName", valid_564846
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564847 = query.getOrDefault("api-version")
  valid_564847 = validateParameter(valid_564847, JString, required = true,
                                 default = nil)
  if valid_564847 != nil:
    section.add "api-version", valid_564847
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564848: Call_ReplicationRecoveryServicesProvidersListByReplicationFabrics_564840;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the registered recovery services providers for the specified fabric.
  ## 
  let valid = call_564848.validator(path, query, header, formData, body)
  let scheme = call_564848.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564848.url(scheme.get, call_564848.host, call_564848.base,
                         call_564848.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564848, url, valid)

proc call*(call_564849: Call_ReplicationRecoveryServicesProvidersListByReplicationFabrics_564840;
          apiVersion: string; fabricName: string; subscriptionId: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## replicationRecoveryServicesProvidersListByReplicationFabrics
  ## Lists the registered recovery services providers for the specified fabric.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564850 = newJObject()
  var query_564851 = newJObject()
  add(query_564851, "api-version", newJString(apiVersion))
  add(path_564850, "fabricName", newJString(fabricName))
  add(path_564850, "subscriptionId", newJString(subscriptionId))
  add(path_564850, "resourceGroupName", newJString(resourceGroupName))
  add(path_564850, "resourceName", newJString(resourceName))
  result = call_564849.call(path_564850, query_564851, nil, nil, nil)

var replicationRecoveryServicesProvidersListByReplicationFabrics* = Call_ReplicationRecoveryServicesProvidersListByReplicationFabrics_564840(
    name: "replicationRecoveryServicesProvidersListByReplicationFabrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders", validator: validate_ReplicationRecoveryServicesProvidersListByReplicationFabrics_564841,
    base: "",
    url: url_ReplicationRecoveryServicesProvidersListByReplicationFabrics_564842,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersGet_564852 = ref object of OpenApiRestCall_563564
proc url_ReplicationRecoveryServicesProvidersGet_564854(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "providerName" in path, "`providerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationRecoveryServicesProviders/"),
               (kind: VariableSegment, value: "providerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationRecoveryServicesProvidersGet_564853(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of registered recovery services provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   providerName: JString (required)
  ##               : Recovery services provider name
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `providerName` field"
  var valid_564855 = path.getOrDefault("providerName")
  valid_564855 = validateParameter(valid_564855, JString, required = true,
                                 default = nil)
  if valid_564855 != nil:
    section.add "providerName", valid_564855
  var valid_564856 = path.getOrDefault("fabricName")
  valid_564856 = validateParameter(valid_564856, JString, required = true,
                                 default = nil)
  if valid_564856 != nil:
    section.add "fabricName", valid_564856
  var valid_564857 = path.getOrDefault("subscriptionId")
  valid_564857 = validateParameter(valid_564857, JString, required = true,
                                 default = nil)
  if valid_564857 != nil:
    section.add "subscriptionId", valid_564857
  var valid_564858 = path.getOrDefault("resourceGroupName")
  valid_564858 = validateParameter(valid_564858, JString, required = true,
                                 default = nil)
  if valid_564858 != nil:
    section.add "resourceGroupName", valid_564858
  var valid_564859 = path.getOrDefault("resourceName")
  valid_564859 = validateParameter(valid_564859, JString, required = true,
                                 default = nil)
  if valid_564859 != nil:
    section.add "resourceName", valid_564859
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564860 = query.getOrDefault("api-version")
  valid_564860 = validateParameter(valid_564860, JString, required = true,
                                 default = nil)
  if valid_564860 != nil:
    section.add "api-version", valid_564860
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564861: Call_ReplicationRecoveryServicesProvidersGet_564852;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of registered recovery services provider.
  ## 
  let valid = call_564861.validator(path, query, header, formData, body)
  let scheme = call_564861.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564861.url(scheme.get, call_564861.host, call_564861.base,
                         call_564861.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564861, url, valid)

proc call*(call_564862: Call_ReplicationRecoveryServicesProvidersGet_564852;
          providerName: string; apiVersion: string; fabricName: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## replicationRecoveryServicesProvidersGet
  ## Gets the details of registered recovery services provider.
  ##   providerName: string (required)
  ##               : Recovery services provider name
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564863 = newJObject()
  var query_564864 = newJObject()
  add(path_564863, "providerName", newJString(providerName))
  add(query_564864, "api-version", newJString(apiVersion))
  add(path_564863, "fabricName", newJString(fabricName))
  add(path_564863, "subscriptionId", newJString(subscriptionId))
  add(path_564863, "resourceGroupName", newJString(resourceGroupName))
  add(path_564863, "resourceName", newJString(resourceName))
  result = call_564862.call(path_564863, query_564864, nil, nil, nil)

var replicationRecoveryServicesProvidersGet* = Call_ReplicationRecoveryServicesProvidersGet_564852(
    name: "replicationRecoveryServicesProvidersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}",
    validator: validate_ReplicationRecoveryServicesProvidersGet_564853, base: "",
    url: url_ReplicationRecoveryServicesProvidersGet_564854,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersPurge_564865 = ref object of OpenApiRestCall_563564
proc url_ReplicationRecoveryServicesProvidersPurge_564867(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "providerName" in path, "`providerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationRecoveryServicesProviders/"),
               (kind: VariableSegment, value: "providerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationRecoveryServicesProvidersPurge_564866(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to purge(force delete) a recovery services provider from the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   providerName: JString (required)
  ##               : Recovery services provider name.
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `providerName` field"
  var valid_564868 = path.getOrDefault("providerName")
  valid_564868 = validateParameter(valid_564868, JString, required = true,
                                 default = nil)
  if valid_564868 != nil:
    section.add "providerName", valid_564868
  var valid_564869 = path.getOrDefault("fabricName")
  valid_564869 = validateParameter(valid_564869, JString, required = true,
                                 default = nil)
  if valid_564869 != nil:
    section.add "fabricName", valid_564869
  var valid_564870 = path.getOrDefault("subscriptionId")
  valid_564870 = validateParameter(valid_564870, JString, required = true,
                                 default = nil)
  if valid_564870 != nil:
    section.add "subscriptionId", valid_564870
  var valid_564871 = path.getOrDefault("resourceGroupName")
  valid_564871 = validateParameter(valid_564871, JString, required = true,
                                 default = nil)
  if valid_564871 != nil:
    section.add "resourceGroupName", valid_564871
  var valid_564872 = path.getOrDefault("resourceName")
  valid_564872 = validateParameter(valid_564872, JString, required = true,
                                 default = nil)
  if valid_564872 != nil:
    section.add "resourceName", valid_564872
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564873 = query.getOrDefault("api-version")
  valid_564873 = validateParameter(valid_564873, JString, required = true,
                                 default = nil)
  if valid_564873 != nil:
    section.add "api-version", valid_564873
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564874: Call_ReplicationRecoveryServicesProvidersPurge_564865;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to purge(force delete) a recovery services provider from the vault.
  ## 
  let valid = call_564874.validator(path, query, header, formData, body)
  let scheme = call_564874.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564874.url(scheme.get, call_564874.host, call_564874.base,
                         call_564874.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564874, url, valid)

proc call*(call_564875: Call_ReplicationRecoveryServicesProvidersPurge_564865;
          providerName: string; apiVersion: string; fabricName: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## replicationRecoveryServicesProvidersPurge
  ## The operation to purge(force delete) a recovery services provider from the vault.
  ##   providerName: string (required)
  ##               : Recovery services provider name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564876 = newJObject()
  var query_564877 = newJObject()
  add(path_564876, "providerName", newJString(providerName))
  add(query_564877, "api-version", newJString(apiVersion))
  add(path_564876, "fabricName", newJString(fabricName))
  add(path_564876, "subscriptionId", newJString(subscriptionId))
  add(path_564876, "resourceGroupName", newJString(resourceGroupName))
  add(path_564876, "resourceName", newJString(resourceName))
  result = call_564875.call(path_564876, query_564877, nil, nil, nil)

var replicationRecoveryServicesProvidersPurge* = Call_ReplicationRecoveryServicesProvidersPurge_564865(
    name: "replicationRecoveryServicesProvidersPurge",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}",
    validator: validate_ReplicationRecoveryServicesProvidersPurge_564866,
    base: "", url: url_ReplicationRecoveryServicesProvidersPurge_564867,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersRefreshProvider_564878 = ref object of OpenApiRestCall_563564
proc url_ReplicationRecoveryServicesProvidersRefreshProvider_564880(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "providerName" in path, "`providerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationRecoveryServicesProviders/"),
               (kind: VariableSegment, value: "providerName"),
               (kind: ConstantSegment, value: "/refreshProvider")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationRecoveryServicesProvidersRefreshProvider_564879(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The operation to refresh the information from the recovery services provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   providerName: JString (required)
  ##               : Recovery services provider name.
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `providerName` field"
  var valid_564881 = path.getOrDefault("providerName")
  valid_564881 = validateParameter(valid_564881, JString, required = true,
                                 default = nil)
  if valid_564881 != nil:
    section.add "providerName", valid_564881
  var valid_564882 = path.getOrDefault("fabricName")
  valid_564882 = validateParameter(valid_564882, JString, required = true,
                                 default = nil)
  if valid_564882 != nil:
    section.add "fabricName", valid_564882
  var valid_564883 = path.getOrDefault("subscriptionId")
  valid_564883 = validateParameter(valid_564883, JString, required = true,
                                 default = nil)
  if valid_564883 != nil:
    section.add "subscriptionId", valid_564883
  var valid_564884 = path.getOrDefault("resourceGroupName")
  valid_564884 = validateParameter(valid_564884, JString, required = true,
                                 default = nil)
  if valid_564884 != nil:
    section.add "resourceGroupName", valid_564884
  var valid_564885 = path.getOrDefault("resourceName")
  valid_564885 = validateParameter(valid_564885, JString, required = true,
                                 default = nil)
  if valid_564885 != nil:
    section.add "resourceName", valid_564885
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564886 = query.getOrDefault("api-version")
  valid_564886 = validateParameter(valid_564886, JString, required = true,
                                 default = nil)
  if valid_564886 != nil:
    section.add "api-version", valid_564886
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564887: Call_ReplicationRecoveryServicesProvidersRefreshProvider_564878;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to refresh the information from the recovery services provider.
  ## 
  let valid = call_564887.validator(path, query, header, formData, body)
  let scheme = call_564887.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564887.url(scheme.get, call_564887.host, call_564887.base,
                         call_564887.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564887, url, valid)

proc call*(call_564888: Call_ReplicationRecoveryServicesProvidersRefreshProvider_564878;
          providerName: string; apiVersion: string; fabricName: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## replicationRecoveryServicesProvidersRefreshProvider
  ## The operation to refresh the information from the recovery services provider.
  ##   providerName: string (required)
  ##               : Recovery services provider name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564889 = newJObject()
  var query_564890 = newJObject()
  add(path_564889, "providerName", newJString(providerName))
  add(query_564890, "api-version", newJString(apiVersion))
  add(path_564889, "fabricName", newJString(fabricName))
  add(path_564889, "subscriptionId", newJString(subscriptionId))
  add(path_564889, "resourceGroupName", newJString(resourceGroupName))
  add(path_564889, "resourceName", newJString(resourceName))
  result = call_564888.call(path_564889, query_564890, nil, nil, nil)

var replicationRecoveryServicesProvidersRefreshProvider* = Call_ReplicationRecoveryServicesProvidersRefreshProvider_564878(
    name: "replicationRecoveryServicesProvidersRefreshProvider",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}/refreshProvider",
    validator: validate_ReplicationRecoveryServicesProvidersRefreshProvider_564879,
    base: "", url: url_ReplicationRecoveryServicesProvidersRefreshProvider_564880,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersDelete_564891 = ref object of OpenApiRestCall_563564
proc url_ReplicationRecoveryServicesProvidersDelete_564893(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "providerName" in path, "`providerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationRecoveryServicesProviders/"),
               (kind: VariableSegment, value: "providerName"),
               (kind: ConstantSegment, value: "/remove")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationRecoveryServicesProvidersDelete_564892(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to removes/delete(unregister) a recovery services provider from the vault
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   providerName: JString (required)
  ##               : Recovery services provider name.
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `providerName` field"
  var valid_564894 = path.getOrDefault("providerName")
  valid_564894 = validateParameter(valid_564894, JString, required = true,
                                 default = nil)
  if valid_564894 != nil:
    section.add "providerName", valid_564894
  var valid_564895 = path.getOrDefault("fabricName")
  valid_564895 = validateParameter(valid_564895, JString, required = true,
                                 default = nil)
  if valid_564895 != nil:
    section.add "fabricName", valid_564895
  var valid_564896 = path.getOrDefault("subscriptionId")
  valid_564896 = validateParameter(valid_564896, JString, required = true,
                                 default = nil)
  if valid_564896 != nil:
    section.add "subscriptionId", valid_564896
  var valid_564897 = path.getOrDefault("resourceGroupName")
  valid_564897 = validateParameter(valid_564897, JString, required = true,
                                 default = nil)
  if valid_564897 != nil:
    section.add "resourceGroupName", valid_564897
  var valid_564898 = path.getOrDefault("resourceName")
  valid_564898 = validateParameter(valid_564898, JString, required = true,
                                 default = nil)
  if valid_564898 != nil:
    section.add "resourceName", valid_564898
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564899 = query.getOrDefault("api-version")
  valid_564899 = validateParameter(valid_564899, JString, required = true,
                                 default = nil)
  if valid_564899 != nil:
    section.add "api-version", valid_564899
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564900: Call_ReplicationRecoveryServicesProvidersDelete_564891;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to removes/delete(unregister) a recovery services provider from the vault
  ## 
  let valid = call_564900.validator(path, query, header, formData, body)
  let scheme = call_564900.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564900.url(scheme.get, call_564900.host, call_564900.base,
                         call_564900.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564900, url, valid)

proc call*(call_564901: Call_ReplicationRecoveryServicesProvidersDelete_564891;
          providerName: string; apiVersion: string; fabricName: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## replicationRecoveryServicesProvidersDelete
  ## The operation to removes/delete(unregister) a recovery services provider from the vault
  ##   providerName: string (required)
  ##               : Recovery services provider name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564902 = newJObject()
  var query_564903 = newJObject()
  add(path_564902, "providerName", newJString(providerName))
  add(query_564903, "api-version", newJString(apiVersion))
  add(path_564902, "fabricName", newJString(fabricName))
  add(path_564902, "subscriptionId", newJString(subscriptionId))
  add(path_564902, "resourceGroupName", newJString(resourceGroupName))
  add(path_564902, "resourceName", newJString(resourceName))
  result = call_564901.call(path_564902, query_564903, nil, nil, nil)

var replicationRecoveryServicesProvidersDelete* = Call_ReplicationRecoveryServicesProvidersDelete_564891(
    name: "replicationRecoveryServicesProvidersDelete", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}/remove",
    validator: validate_ReplicationRecoveryServicesProvidersDelete_564892,
    base: "", url: url_ReplicationRecoveryServicesProvidersDelete_564893,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationsListByReplicationFabrics_564904 = ref object of OpenApiRestCall_563564
proc url_ReplicationStorageClassificationsListByReplicationFabrics_564906(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationStorageClassifications")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationStorageClassificationsListByReplicationFabrics_564905(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the storage classifications available in the specified fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Site name of interest.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_564907 = path.getOrDefault("fabricName")
  valid_564907 = validateParameter(valid_564907, JString, required = true,
                                 default = nil)
  if valid_564907 != nil:
    section.add "fabricName", valid_564907
  var valid_564908 = path.getOrDefault("subscriptionId")
  valid_564908 = validateParameter(valid_564908, JString, required = true,
                                 default = nil)
  if valid_564908 != nil:
    section.add "subscriptionId", valid_564908
  var valid_564909 = path.getOrDefault("resourceGroupName")
  valid_564909 = validateParameter(valid_564909, JString, required = true,
                                 default = nil)
  if valid_564909 != nil:
    section.add "resourceGroupName", valid_564909
  var valid_564910 = path.getOrDefault("resourceName")
  valid_564910 = validateParameter(valid_564910, JString, required = true,
                                 default = nil)
  if valid_564910 != nil:
    section.add "resourceName", valid_564910
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564911 = query.getOrDefault("api-version")
  valid_564911 = validateParameter(valid_564911, JString, required = true,
                                 default = nil)
  if valid_564911 != nil:
    section.add "api-version", valid_564911
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564912: Call_ReplicationStorageClassificationsListByReplicationFabrics_564904;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the storage classifications available in the specified fabric.
  ## 
  let valid = call_564912.validator(path, query, header, formData, body)
  let scheme = call_564912.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564912.url(scheme.get, call_564912.host, call_564912.base,
                         call_564912.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564912, url, valid)

proc call*(call_564913: Call_ReplicationStorageClassificationsListByReplicationFabrics_564904;
          apiVersion: string; fabricName: string; subscriptionId: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## replicationStorageClassificationsListByReplicationFabrics
  ## Lists the storage classifications available in the specified fabric.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Site name of interest.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564914 = newJObject()
  var query_564915 = newJObject()
  add(query_564915, "api-version", newJString(apiVersion))
  add(path_564914, "fabricName", newJString(fabricName))
  add(path_564914, "subscriptionId", newJString(subscriptionId))
  add(path_564914, "resourceGroupName", newJString(resourceGroupName))
  add(path_564914, "resourceName", newJString(resourceName))
  result = call_564913.call(path_564914, query_564915, nil, nil, nil)

var replicationStorageClassificationsListByReplicationFabrics* = Call_ReplicationStorageClassificationsListByReplicationFabrics_564904(
    name: "replicationStorageClassificationsListByReplicationFabrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications", validator: validate_ReplicationStorageClassificationsListByReplicationFabrics_564905,
    base: "", url: url_ReplicationStorageClassificationsListByReplicationFabrics_564906,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationsGet_564916 = ref object of OpenApiRestCall_563564
proc url_ReplicationStorageClassificationsGet_564918(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "storageClassificationName" in path,
        "`storageClassificationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationStorageClassifications/"),
               (kind: VariableSegment, value: "storageClassificationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationStorageClassificationsGet_564917(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the specified storage classification.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   storageClassificationName: JString (required)
  ##                            : Storage classification name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_564919 = path.getOrDefault("fabricName")
  valid_564919 = validateParameter(valid_564919, JString, required = true,
                                 default = nil)
  if valid_564919 != nil:
    section.add "fabricName", valid_564919
  var valid_564920 = path.getOrDefault("subscriptionId")
  valid_564920 = validateParameter(valid_564920, JString, required = true,
                                 default = nil)
  if valid_564920 != nil:
    section.add "subscriptionId", valid_564920
  var valid_564921 = path.getOrDefault("resourceGroupName")
  valid_564921 = validateParameter(valid_564921, JString, required = true,
                                 default = nil)
  if valid_564921 != nil:
    section.add "resourceGroupName", valid_564921
  var valid_564922 = path.getOrDefault("resourceName")
  valid_564922 = validateParameter(valid_564922, JString, required = true,
                                 default = nil)
  if valid_564922 != nil:
    section.add "resourceName", valid_564922
  var valid_564923 = path.getOrDefault("storageClassificationName")
  valid_564923 = validateParameter(valid_564923, JString, required = true,
                                 default = nil)
  if valid_564923 != nil:
    section.add "storageClassificationName", valid_564923
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564924 = query.getOrDefault("api-version")
  valid_564924 = validateParameter(valid_564924, JString, required = true,
                                 default = nil)
  if valid_564924 != nil:
    section.add "api-version", valid_564924
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564925: Call_ReplicationStorageClassificationsGet_564916;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of the specified storage classification.
  ## 
  let valid = call_564925.validator(path, query, header, formData, body)
  let scheme = call_564925.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564925.url(scheme.get, call_564925.host, call_564925.base,
                         call_564925.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564925, url, valid)

proc call*(call_564926: Call_ReplicationStorageClassificationsGet_564916;
          apiVersion: string; fabricName: string; subscriptionId: string;
          resourceGroupName: string; resourceName: string;
          storageClassificationName: string): Recallable =
  ## replicationStorageClassificationsGet
  ## Gets the details of the specified storage classification.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   storageClassificationName: string (required)
  ##                            : Storage classification name.
  var path_564927 = newJObject()
  var query_564928 = newJObject()
  add(query_564928, "api-version", newJString(apiVersion))
  add(path_564927, "fabricName", newJString(fabricName))
  add(path_564927, "subscriptionId", newJString(subscriptionId))
  add(path_564927, "resourceGroupName", newJString(resourceGroupName))
  add(path_564927, "resourceName", newJString(resourceName))
  add(path_564927, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_564926.call(path_564927, query_564928, nil, nil, nil)

var replicationStorageClassificationsGet* = Call_ReplicationStorageClassificationsGet_564916(
    name: "replicationStorageClassificationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}",
    validator: validate_ReplicationStorageClassificationsGet_564917, base: "",
    url: url_ReplicationStorageClassificationsGet_564918, schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_564929 = ref object of OpenApiRestCall_563564
proc url_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_564931(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "storageClassificationName" in path,
        "`storageClassificationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationStorageClassifications/"),
               (kind: VariableSegment, value: "storageClassificationName"), (
        kind: ConstantSegment, value: "/replicationStorageClassificationMappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_564930(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the storage classification mappings for the fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   storageClassificationName: JString (required)
  ##                            : Storage classification name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_564932 = path.getOrDefault("fabricName")
  valid_564932 = validateParameter(valid_564932, JString, required = true,
                                 default = nil)
  if valid_564932 != nil:
    section.add "fabricName", valid_564932
  var valid_564933 = path.getOrDefault("subscriptionId")
  valid_564933 = validateParameter(valid_564933, JString, required = true,
                                 default = nil)
  if valid_564933 != nil:
    section.add "subscriptionId", valid_564933
  var valid_564934 = path.getOrDefault("resourceGroupName")
  valid_564934 = validateParameter(valid_564934, JString, required = true,
                                 default = nil)
  if valid_564934 != nil:
    section.add "resourceGroupName", valid_564934
  var valid_564935 = path.getOrDefault("resourceName")
  valid_564935 = validateParameter(valid_564935, JString, required = true,
                                 default = nil)
  if valid_564935 != nil:
    section.add "resourceName", valid_564935
  var valid_564936 = path.getOrDefault("storageClassificationName")
  valid_564936 = validateParameter(valid_564936, JString, required = true,
                                 default = nil)
  if valid_564936 != nil:
    section.add "storageClassificationName", valid_564936
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564937 = query.getOrDefault("api-version")
  valid_564937 = validateParameter(valid_564937, JString, required = true,
                                 default = nil)
  if valid_564937 != nil:
    section.add "api-version", valid_564937
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564938: Call_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_564929;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the storage classification mappings for the fabric.
  ## 
  let valid = call_564938.validator(path, query, header, formData, body)
  let scheme = call_564938.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564938.url(scheme.get, call_564938.host, call_564938.base,
                         call_564938.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564938, url, valid)

proc call*(call_564939: Call_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_564929;
          apiVersion: string; fabricName: string; subscriptionId: string;
          resourceGroupName: string; resourceName: string;
          storageClassificationName: string): Recallable =
  ## replicationStorageClassificationMappingsListByReplicationStorageClassifications
  ## Lists the storage classification mappings for the fabric.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   storageClassificationName: string (required)
  ##                            : Storage classification name.
  var path_564940 = newJObject()
  var query_564941 = newJObject()
  add(query_564941, "api-version", newJString(apiVersion))
  add(path_564940, "fabricName", newJString(fabricName))
  add(path_564940, "subscriptionId", newJString(subscriptionId))
  add(path_564940, "resourceGroupName", newJString(resourceGroupName))
  add(path_564940, "resourceName", newJString(resourceName))
  add(path_564940, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_564939.call(path_564940, query_564941, nil, nil, nil)

var replicationStorageClassificationMappingsListByReplicationStorageClassifications* = Call_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_564929(name: "replicationStorageClassificationMappingsListByReplicationStorageClassifications",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}/replicationStorageClassificationMappings", validator: validate_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_564930,
    base: "", url: url_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_564931,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsCreate_564956 = ref object of OpenApiRestCall_563564
proc url_ReplicationStorageClassificationMappingsCreate_564958(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "storageClassificationName" in path,
        "`storageClassificationName` is a required path parameter"
  assert "storageClassificationMappingName" in path,
        "`storageClassificationMappingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationStorageClassifications/"),
               (kind: VariableSegment, value: "storageClassificationName"), (
        kind: ConstantSegment, value: "/replicationStorageClassificationMappings/"), (
        kind: VariableSegment, value: "storageClassificationMappingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationStorageClassificationMappingsCreate_564957(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The operation to create a storage classification mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   storageClassificationMappingName: JString (required)
  ##                                   : Storage classification mapping name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   storageClassificationName: JString (required)
  ##                            : Storage classification name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_564959 = path.getOrDefault("fabricName")
  valid_564959 = validateParameter(valid_564959, JString, required = true,
                                 default = nil)
  if valid_564959 != nil:
    section.add "fabricName", valid_564959
  var valid_564960 = path.getOrDefault("subscriptionId")
  valid_564960 = validateParameter(valid_564960, JString, required = true,
                                 default = nil)
  if valid_564960 != nil:
    section.add "subscriptionId", valid_564960
  var valid_564961 = path.getOrDefault("storageClassificationMappingName")
  valid_564961 = validateParameter(valid_564961, JString, required = true,
                                 default = nil)
  if valid_564961 != nil:
    section.add "storageClassificationMappingName", valid_564961
  var valid_564962 = path.getOrDefault("resourceGroupName")
  valid_564962 = validateParameter(valid_564962, JString, required = true,
                                 default = nil)
  if valid_564962 != nil:
    section.add "resourceGroupName", valid_564962
  var valid_564963 = path.getOrDefault("resourceName")
  valid_564963 = validateParameter(valid_564963, JString, required = true,
                                 default = nil)
  if valid_564963 != nil:
    section.add "resourceName", valid_564963
  var valid_564964 = path.getOrDefault("storageClassificationName")
  valid_564964 = validateParameter(valid_564964, JString, required = true,
                                 default = nil)
  if valid_564964 != nil:
    section.add "storageClassificationName", valid_564964
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564965 = query.getOrDefault("api-version")
  valid_564965 = validateParameter(valid_564965, JString, required = true,
                                 default = nil)
  if valid_564965 != nil:
    section.add "api-version", valid_564965
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   pairingInput: JObject (required)
  ##               : Pairing input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564967: Call_ReplicationStorageClassificationMappingsCreate_564956;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create a storage classification mapping.
  ## 
  let valid = call_564967.validator(path, query, header, formData, body)
  let scheme = call_564967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564967.url(scheme.get, call_564967.host, call_564967.base,
                         call_564967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564967, url, valid)

proc call*(call_564968: Call_ReplicationStorageClassificationMappingsCreate_564956;
          pairingInput: JsonNode; apiVersion: string; fabricName: string;
          subscriptionId: string; storageClassificationMappingName: string;
          resourceGroupName: string; resourceName: string;
          storageClassificationName: string): Recallable =
  ## replicationStorageClassificationMappingsCreate
  ## The operation to create a storage classification mapping.
  ##   pairingInput: JObject (required)
  ##               : Pairing input.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   storageClassificationMappingName: string (required)
  ##                                   : Storage classification mapping name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   storageClassificationName: string (required)
  ##                            : Storage classification name.
  var path_564969 = newJObject()
  var query_564970 = newJObject()
  var body_564971 = newJObject()
  if pairingInput != nil:
    body_564971 = pairingInput
  add(query_564970, "api-version", newJString(apiVersion))
  add(path_564969, "fabricName", newJString(fabricName))
  add(path_564969, "subscriptionId", newJString(subscriptionId))
  add(path_564969, "storageClassificationMappingName",
      newJString(storageClassificationMappingName))
  add(path_564969, "resourceGroupName", newJString(resourceGroupName))
  add(path_564969, "resourceName", newJString(resourceName))
  add(path_564969, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_564968.call(path_564969, query_564970, nil, nil, body_564971)

var replicationStorageClassificationMappingsCreate* = Call_ReplicationStorageClassificationMappingsCreate_564956(
    name: "replicationStorageClassificationMappingsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}/replicationStorageClassificationMappings/{storageClassificationMappingName}",
    validator: validate_ReplicationStorageClassificationMappingsCreate_564957,
    base: "", url: url_ReplicationStorageClassificationMappingsCreate_564958,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsGet_564942 = ref object of OpenApiRestCall_563564
proc url_ReplicationStorageClassificationMappingsGet_564944(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "storageClassificationName" in path,
        "`storageClassificationName` is a required path parameter"
  assert "storageClassificationMappingName" in path,
        "`storageClassificationMappingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationStorageClassifications/"),
               (kind: VariableSegment, value: "storageClassificationName"), (
        kind: ConstantSegment, value: "/replicationStorageClassificationMappings/"), (
        kind: VariableSegment, value: "storageClassificationMappingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationStorageClassificationMappingsGet_564943(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the specified storage classification mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   storageClassificationMappingName: JString (required)
  ##                                   : Storage classification mapping name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   storageClassificationName: JString (required)
  ##                            : Storage classification name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_564945 = path.getOrDefault("fabricName")
  valid_564945 = validateParameter(valid_564945, JString, required = true,
                                 default = nil)
  if valid_564945 != nil:
    section.add "fabricName", valid_564945
  var valid_564946 = path.getOrDefault("subscriptionId")
  valid_564946 = validateParameter(valid_564946, JString, required = true,
                                 default = nil)
  if valid_564946 != nil:
    section.add "subscriptionId", valid_564946
  var valid_564947 = path.getOrDefault("storageClassificationMappingName")
  valid_564947 = validateParameter(valid_564947, JString, required = true,
                                 default = nil)
  if valid_564947 != nil:
    section.add "storageClassificationMappingName", valid_564947
  var valid_564948 = path.getOrDefault("resourceGroupName")
  valid_564948 = validateParameter(valid_564948, JString, required = true,
                                 default = nil)
  if valid_564948 != nil:
    section.add "resourceGroupName", valid_564948
  var valid_564949 = path.getOrDefault("resourceName")
  valid_564949 = validateParameter(valid_564949, JString, required = true,
                                 default = nil)
  if valid_564949 != nil:
    section.add "resourceName", valid_564949
  var valid_564950 = path.getOrDefault("storageClassificationName")
  valid_564950 = validateParameter(valid_564950, JString, required = true,
                                 default = nil)
  if valid_564950 != nil:
    section.add "storageClassificationName", valid_564950
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564951 = query.getOrDefault("api-version")
  valid_564951 = validateParameter(valid_564951, JString, required = true,
                                 default = nil)
  if valid_564951 != nil:
    section.add "api-version", valid_564951
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564952: Call_ReplicationStorageClassificationMappingsGet_564942;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of the specified storage classification mapping.
  ## 
  let valid = call_564952.validator(path, query, header, formData, body)
  let scheme = call_564952.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564952.url(scheme.get, call_564952.host, call_564952.base,
                         call_564952.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564952, url, valid)

proc call*(call_564953: Call_ReplicationStorageClassificationMappingsGet_564942;
          apiVersion: string; fabricName: string; subscriptionId: string;
          storageClassificationMappingName: string; resourceGroupName: string;
          resourceName: string; storageClassificationName: string): Recallable =
  ## replicationStorageClassificationMappingsGet
  ## Gets the details of the specified storage classification mapping.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   storageClassificationMappingName: string (required)
  ##                                   : Storage classification mapping name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   storageClassificationName: string (required)
  ##                            : Storage classification name.
  var path_564954 = newJObject()
  var query_564955 = newJObject()
  add(query_564955, "api-version", newJString(apiVersion))
  add(path_564954, "fabricName", newJString(fabricName))
  add(path_564954, "subscriptionId", newJString(subscriptionId))
  add(path_564954, "storageClassificationMappingName",
      newJString(storageClassificationMappingName))
  add(path_564954, "resourceGroupName", newJString(resourceGroupName))
  add(path_564954, "resourceName", newJString(resourceName))
  add(path_564954, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_564953.call(path_564954, query_564955, nil, nil, nil)

var replicationStorageClassificationMappingsGet* = Call_ReplicationStorageClassificationMappingsGet_564942(
    name: "replicationStorageClassificationMappingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}/replicationStorageClassificationMappings/{storageClassificationMappingName}",
    validator: validate_ReplicationStorageClassificationMappingsGet_564943,
    base: "", url: url_ReplicationStorageClassificationMappingsGet_564944,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsDelete_564972 = ref object of OpenApiRestCall_563564
proc url_ReplicationStorageClassificationMappingsDelete_564974(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "storageClassificationName" in path,
        "`storageClassificationName` is a required path parameter"
  assert "storageClassificationMappingName" in path,
        "`storageClassificationMappingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"), (kind: ConstantSegment,
        value: "/replicationStorageClassifications/"),
               (kind: VariableSegment, value: "storageClassificationName"), (
        kind: ConstantSegment, value: "/replicationStorageClassificationMappings/"), (
        kind: VariableSegment, value: "storageClassificationMappingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationStorageClassificationMappingsDelete_564973(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The operation to delete a storage classification mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   storageClassificationMappingName: JString (required)
  ##                                   : Storage classification mapping name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   storageClassificationName: JString (required)
  ##                            : Storage classification name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_564975 = path.getOrDefault("fabricName")
  valid_564975 = validateParameter(valid_564975, JString, required = true,
                                 default = nil)
  if valid_564975 != nil:
    section.add "fabricName", valid_564975
  var valid_564976 = path.getOrDefault("subscriptionId")
  valid_564976 = validateParameter(valid_564976, JString, required = true,
                                 default = nil)
  if valid_564976 != nil:
    section.add "subscriptionId", valid_564976
  var valid_564977 = path.getOrDefault("storageClassificationMappingName")
  valid_564977 = validateParameter(valid_564977, JString, required = true,
                                 default = nil)
  if valid_564977 != nil:
    section.add "storageClassificationMappingName", valid_564977
  var valid_564978 = path.getOrDefault("resourceGroupName")
  valid_564978 = validateParameter(valid_564978, JString, required = true,
                                 default = nil)
  if valid_564978 != nil:
    section.add "resourceGroupName", valid_564978
  var valid_564979 = path.getOrDefault("resourceName")
  valid_564979 = validateParameter(valid_564979, JString, required = true,
                                 default = nil)
  if valid_564979 != nil:
    section.add "resourceName", valid_564979
  var valid_564980 = path.getOrDefault("storageClassificationName")
  valid_564980 = validateParameter(valid_564980, JString, required = true,
                                 default = nil)
  if valid_564980 != nil:
    section.add "storageClassificationName", valid_564980
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564981 = query.getOrDefault("api-version")
  valid_564981 = validateParameter(valid_564981, JString, required = true,
                                 default = nil)
  if valid_564981 != nil:
    section.add "api-version", valid_564981
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564982: Call_ReplicationStorageClassificationMappingsDelete_564972;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete a storage classification mapping.
  ## 
  let valid = call_564982.validator(path, query, header, formData, body)
  let scheme = call_564982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564982.url(scheme.get, call_564982.host, call_564982.base,
                         call_564982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564982, url, valid)

proc call*(call_564983: Call_ReplicationStorageClassificationMappingsDelete_564972;
          apiVersion: string; fabricName: string; subscriptionId: string;
          storageClassificationMappingName: string; resourceGroupName: string;
          resourceName: string; storageClassificationName: string): Recallable =
  ## replicationStorageClassificationMappingsDelete
  ## The operation to delete a storage classification mapping.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   storageClassificationMappingName: string (required)
  ##                                   : Storage classification mapping name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   storageClassificationName: string (required)
  ##                            : Storage classification name.
  var path_564984 = newJObject()
  var query_564985 = newJObject()
  add(query_564985, "api-version", newJString(apiVersion))
  add(path_564984, "fabricName", newJString(fabricName))
  add(path_564984, "subscriptionId", newJString(subscriptionId))
  add(path_564984, "storageClassificationMappingName",
      newJString(storageClassificationMappingName))
  add(path_564984, "resourceGroupName", newJString(resourceGroupName))
  add(path_564984, "resourceName", newJString(resourceName))
  add(path_564984, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_564983.call(path_564984, query_564985, nil, nil, nil)

var replicationStorageClassificationMappingsDelete* = Call_ReplicationStorageClassificationMappingsDelete_564972(
    name: "replicationStorageClassificationMappingsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}/replicationStorageClassificationMappings/{storageClassificationMappingName}",
    validator: validate_ReplicationStorageClassificationMappingsDelete_564973,
    base: "", url: url_ReplicationStorageClassificationMappingsDelete_564974,
    schemes: {Scheme.Https})
type
  Call_ReplicationvCentersListByReplicationFabrics_564986 = ref object of OpenApiRestCall_563564
proc url_ReplicationvCentersListByReplicationFabrics_564988(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/replicationvCenters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationvCentersListByReplicationFabrics_564987(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the vCenter servers registered in a fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_564989 = path.getOrDefault("fabricName")
  valid_564989 = validateParameter(valid_564989, JString, required = true,
                                 default = nil)
  if valid_564989 != nil:
    section.add "fabricName", valid_564989
  var valid_564990 = path.getOrDefault("subscriptionId")
  valid_564990 = validateParameter(valid_564990, JString, required = true,
                                 default = nil)
  if valid_564990 != nil:
    section.add "subscriptionId", valid_564990
  var valid_564991 = path.getOrDefault("resourceGroupName")
  valid_564991 = validateParameter(valid_564991, JString, required = true,
                                 default = nil)
  if valid_564991 != nil:
    section.add "resourceGroupName", valid_564991
  var valid_564992 = path.getOrDefault("resourceName")
  valid_564992 = validateParameter(valid_564992, JString, required = true,
                                 default = nil)
  if valid_564992 != nil:
    section.add "resourceName", valid_564992
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564993 = query.getOrDefault("api-version")
  valid_564993 = validateParameter(valid_564993, JString, required = true,
                                 default = nil)
  if valid_564993 != nil:
    section.add "api-version", valid_564993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564994: Call_ReplicationvCentersListByReplicationFabrics_564986;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the vCenter servers registered in a fabric.
  ## 
  let valid = call_564994.validator(path, query, header, formData, body)
  let scheme = call_564994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564994.url(scheme.get, call_564994.host, call_564994.base,
                         call_564994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564994, url, valid)

proc call*(call_564995: Call_ReplicationvCentersListByReplicationFabrics_564986;
          apiVersion: string; fabricName: string; subscriptionId: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## replicationvCentersListByReplicationFabrics
  ## Lists the vCenter servers registered in a fabric.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564996 = newJObject()
  var query_564997 = newJObject()
  add(query_564997, "api-version", newJString(apiVersion))
  add(path_564996, "fabricName", newJString(fabricName))
  add(path_564996, "subscriptionId", newJString(subscriptionId))
  add(path_564996, "resourceGroupName", newJString(resourceGroupName))
  add(path_564996, "resourceName", newJString(resourceName))
  result = call_564995.call(path_564996, query_564997, nil, nil, nil)

var replicationvCentersListByReplicationFabrics* = Call_ReplicationvCentersListByReplicationFabrics_564986(
    name: "replicationvCentersListByReplicationFabrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters",
    validator: validate_ReplicationvCentersListByReplicationFabrics_564987,
    base: "", url: url_ReplicationvCentersListByReplicationFabrics_564988,
    schemes: {Scheme.Https})
type
  Call_ReplicationvCentersCreate_565011 = ref object of OpenApiRestCall_563564
proc url_ReplicationvCentersCreate_565013(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "vCenterName" in path, "`vCenterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/replicationvCenters/"),
               (kind: VariableSegment, value: "vCenterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationvCentersCreate_565012(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create a vCenter object..
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vCenterName: JString (required)
  ##              : vCenter name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_565014 = path.getOrDefault("fabricName")
  valid_565014 = validateParameter(valid_565014, JString, required = true,
                                 default = nil)
  if valid_565014 != nil:
    section.add "fabricName", valid_565014
  var valid_565015 = path.getOrDefault("subscriptionId")
  valid_565015 = validateParameter(valid_565015, JString, required = true,
                                 default = nil)
  if valid_565015 != nil:
    section.add "subscriptionId", valid_565015
  var valid_565016 = path.getOrDefault("vCenterName")
  valid_565016 = validateParameter(valid_565016, JString, required = true,
                                 default = nil)
  if valid_565016 != nil:
    section.add "vCenterName", valid_565016
  var valid_565017 = path.getOrDefault("resourceGroupName")
  valid_565017 = validateParameter(valid_565017, JString, required = true,
                                 default = nil)
  if valid_565017 != nil:
    section.add "resourceGroupName", valid_565017
  var valid_565018 = path.getOrDefault("resourceName")
  valid_565018 = validateParameter(valid_565018, JString, required = true,
                                 default = nil)
  if valid_565018 != nil:
    section.add "resourceName", valid_565018
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565019 = query.getOrDefault("api-version")
  valid_565019 = validateParameter(valid_565019, JString, required = true,
                                 default = nil)
  if valid_565019 != nil:
    section.add "api-version", valid_565019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   addVCenterRequest: JObject (required)
  ##                    : The input to the add vCenter operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565021: Call_ReplicationvCentersCreate_565011; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create a vCenter object..
  ## 
  let valid = call_565021.validator(path, query, header, formData, body)
  let scheme = call_565021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565021.url(scheme.get, call_565021.host, call_565021.base,
                         call_565021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565021, url, valid)

proc call*(call_565022: Call_ReplicationvCentersCreate_565011; apiVersion: string;
          fabricName: string; subscriptionId: string; vCenterName: string;
          resourceGroupName: string; resourceName: string;
          addVCenterRequest: JsonNode): Recallable =
  ## replicationvCentersCreate
  ## The operation to create a vCenter object..
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vCenterName: string (required)
  ##              : vCenter name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   addVCenterRequest: JObject (required)
  ##                    : The input to the add vCenter operation.
  var path_565023 = newJObject()
  var query_565024 = newJObject()
  var body_565025 = newJObject()
  add(query_565024, "api-version", newJString(apiVersion))
  add(path_565023, "fabricName", newJString(fabricName))
  add(path_565023, "subscriptionId", newJString(subscriptionId))
  add(path_565023, "vCenterName", newJString(vCenterName))
  add(path_565023, "resourceGroupName", newJString(resourceGroupName))
  add(path_565023, "resourceName", newJString(resourceName))
  if addVCenterRequest != nil:
    body_565025 = addVCenterRequest
  result = call_565022.call(path_565023, query_565024, nil, nil, body_565025)

var replicationvCentersCreate* = Call_ReplicationvCentersCreate_565011(
    name: "replicationvCentersCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters/{vCenterName}",
    validator: validate_ReplicationvCentersCreate_565012, base: "",
    url: url_ReplicationvCentersCreate_565013, schemes: {Scheme.Https})
type
  Call_ReplicationvCentersGet_564998 = ref object of OpenApiRestCall_563564
proc url_ReplicationvCentersGet_565000(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "vCenterName" in path, "`vCenterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/replicationvCenters/"),
               (kind: VariableSegment, value: "vCenterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationvCentersGet_564999(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of a registered vCenter server(Add vCenter server.)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vCenterName: JString (required)
  ##              : vCenter name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_565001 = path.getOrDefault("fabricName")
  valid_565001 = validateParameter(valid_565001, JString, required = true,
                                 default = nil)
  if valid_565001 != nil:
    section.add "fabricName", valid_565001
  var valid_565002 = path.getOrDefault("subscriptionId")
  valid_565002 = validateParameter(valid_565002, JString, required = true,
                                 default = nil)
  if valid_565002 != nil:
    section.add "subscriptionId", valid_565002
  var valid_565003 = path.getOrDefault("vCenterName")
  valid_565003 = validateParameter(valid_565003, JString, required = true,
                                 default = nil)
  if valid_565003 != nil:
    section.add "vCenterName", valid_565003
  var valid_565004 = path.getOrDefault("resourceGroupName")
  valid_565004 = validateParameter(valid_565004, JString, required = true,
                                 default = nil)
  if valid_565004 != nil:
    section.add "resourceGroupName", valid_565004
  var valid_565005 = path.getOrDefault("resourceName")
  valid_565005 = validateParameter(valid_565005, JString, required = true,
                                 default = nil)
  if valid_565005 != nil:
    section.add "resourceName", valid_565005
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565006 = query.getOrDefault("api-version")
  valid_565006 = validateParameter(valid_565006, JString, required = true,
                                 default = nil)
  if valid_565006 != nil:
    section.add "api-version", valid_565006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565007: Call_ReplicationvCentersGet_564998; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a registered vCenter server(Add vCenter server.)
  ## 
  let valid = call_565007.validator(path, query, header, formData, body)
  let scheme = call_565007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565007.url(scheme.get, call_565007.host, call_565007.base,
                         call_565007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565007, url, valid)

proc call*(call_565008: Call_ReplicationvCentersGet_564998; apiVersion: string;
          fabricName: string; subscriptionId: string; vCenterName: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## replicationvCentersGet
  ## Gets the details of a registered vCenter server(Add vCenter server.)
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vCenterName: string (required)
  ##              : vCenter name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565009 = newJObject()
  var query_565010 = newJObject()
  add(query_565010, "api-version", newJString(apiVersion))
  add(path_565009, "fabricName", newJString(fabricName))
  add(path_565009, "subscriptionId", newJString(subscriptionId))
  add(path_565009, "vCenterName", newJString(vCenterName))
  add(path_565009, "resourceGroupName", newJString(resourceGroupName))
  add(path_565009, "resourceName", newJString(resourceName))
  result = call_565008.call(path_565009, query_565010, nil, nil, nil)

var replicationvCentersGet* = Call_ReplicationvCentersGet_564998(
    name: "replicationvCentersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters/{vCenterName}",
    validator: validate_ReplicationvCentersGet_564999, base: "",
    url: url_ReplicationvCentersGet_565000, schemes: {Scheme.Https})
type
  Call_ReplicationvCentersUpdate_565039 = ref object of OpenApiRestCall_563564
proc url_ReplicationvCentersUpdate_565041(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "vCenterName" in path, "`vCenterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/replicationvCenters/"),
               (kind: VariableSegment, value: "vCenterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationvCentersUpdate_565040(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update a registered vCenter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vCenterName: JString (required)
  ##              : vCenter name
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_565042 = path.getOrDefault("fabricName")
  valid_565042 = validateParameter(valid_565042, JString, required = true,
                                 default = nil)
  if valid_565042 != nil:
    section.add "fabricName", valid_565042
  var valid_565043 = path.getOrDefault("subscriptionId")
  valid_565043 = validateParameter(valid_565043, JString, required = true,
                                 default = nil)
  if valid_565043 != nil:
    section.add "subscriptionId", valid_565043
  var valid_565044 = path.getOrDefault("vCenterName")
  valid_565044 = validateParameter(valid_565044, JString, required = true,
                                 default = nil)
  if valid_565044 != nil:
    section.add "vCenterName", valid_565044
  var valid_565045 = path.getOrDefault("resourceGroupName")
  valid_565045 = validateParameter(valid_565045, JString, required = true,
                                 default = nil)
  if valid_565045 != nil:
    section.add "resourceGroupName", valid_565045
  var valid_565046 = path.getOrDefault("resourceName")
  valid_565046 = validateParameter(valid_565046, JString, required = true,
                                 default = nil)
  if valid_565046 != nil:
    section.add "resourceName", valid_565046
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565047 = query.getOrDefault("api-version")
  valid_565047 = validateParameter(valid_565047, JString, required = true,
                                 default = nil)
  if valid_565047 != nil:
    section.add "api-version", valid_565047
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   updateVCenterRequest: JObject (required)
  ##                       : The input to the update vCenter operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565049: Call_ReplicationvCentersUpdate_565039; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a registered vCenter.
  ## 
  let valid = call_565049.validator(path, query, header, formData, body)
  let scheme = call_565049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565049.url(scheme.get, call_565049.host, call_565049.base,
                         call_565049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565049, url, valid)

proc call*(call_565050: Call_ReplicationvCentersUpdate_565039; apiVersion: string;
          fabricName: string; subscriptionId: string; vCenterName: string;
          resourceGroupName: string; resourceName: string;
          updateVCenterRequest: JsonNode): Recallable =
  ## replicationvCentersUpdate
  ## The operation to update a registered vCenter.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vCenterName: string (required)
  ##              : vCenter name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   updateVCenterRequest: JObject (required)
  ##                       : The input to the update vCenter operation.
  var path_565051 = newJObject()
  var query_565052 = newJObject()
  var body_565053 = newJObject()
  add(query_565052, "api-version", newJString(apiVersion))
  add(path_565051, "fabricName", newJString(fabricName))
  add(path_565051, "subscriptionId", newJString(subscriptionId))
  add(path_565051, "vCenterName", newJString(vCenterName))
  add(path_565051, "resourceGroupName", newJString(resourceGroupName))
  add(path_565051, "resourceName", newJString(resourceName))
  if updateVCenterRequest != nil:
    body_565053 = updateVCenterRequest
  result = call_565050.call(path_565051, query_565052, nil, nil, body_565053)

var replicationvCentersUpdate* = Call_ReplicationvCentersUpdate_565039(
    name: "replicationvCentersUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters/{vCenterName}",
    validator: validate_ReplicationvCentersUpdate_565040, base: "",
    url: url_ReplicationvCentersUpdate_565041, schemes: {Scheme.Https})
type
  Call_ReplicationvCentersDelete_565026 = ref object of OpenApiRestCall_563564
proc url_ReplicationvCentersDelete_565028(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "fabricName" in path, "`fabricName` is a required path parameter"
  assert "vCenterName" in path, "`vCenterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationFabrics/"),
               (kind: VariableSegment, value: "fabricName"),
               (kind: ConstantSegment, value: "/replicationvCenters/"),
               (kind: VariableSegment, value: "vCenterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationvCentersDelete_565027(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to remove(unregister) a registered vCenter server from the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   vCenterName: JString (required)
  ##              : vCenter name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_565029 = path.getOrDefault("fabricName")
  valid_565029 = validateParameter(valid_565029, JString, required = true,
                                 default = nil)
  if valid_565029 != nil:
    section.add "fabricName", valid_565029
  var valid_565030 = path.getOrDefault("subscriptionId")
  valid_565030 = validateParameter(valid_565030, JString, required = true,
                                 default = nil)
  if valid_565030 != nil:
    section.add "subscriptionId", valid_565030
  var valid_565031 = path.getOrDefault("vCenterName")
  valid_565031 = validateParameter(valid_565031, JString, required = true,
                                 default = nil)
  if valid_565031 != nil:
    section.add "vCenterName", valid_565031
  var valid_565032 = path.getOrDefault("resourceGroupName")
  valid_565032 = validateParameter(valid_565032, JString, required = true,
                                 default = nil)
  if valid_565032 != nil:
    section.add "resourceGroupName", valid_565032
  var valid_565033 = path.getOrDefault("resourceName")
  valid_565033 = validateParameter(valid_565033, JString, required = true,
                                 default = nil)
  if valid_565033 != nil:
    section.add "resourceName", valid_565033
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565034 = query.getOrDefault("api-version")
  valid_565034 = validateParameter(valid_565034, JString, required = true,
                                 default = nil)
  if valid_565034 != nil:
    section.add "api-version", valid_565034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565035: Call_ReplicationvCentersDelete_565026; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to remove(unregister) a registered vCenter server from the vault.
  ## 
  let valid = call_565035.validator(path, query, header, formData, body)
  let scheme = call_565035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565035.url(scheme.get, call_565035.host, call_565035.base,
                         call_565035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565035, url, valid)

proc call*(call_565036: Call_ReplicationvCentersDelete_565026; apiVersion: string;
          fabricName: string; subscriptionId: string; vCenterName: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## replicationvCentersDelete
  ## The operation to remove(unregister) a registered vCenter server from the vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   vCenterName: string (required)
  ##              : vCenter name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565037 = newJObject()
  var query_565038 = newJObject()
  add(query_565038, "api-version", newJString(apiVersion))
  add(path_565037, "fabricName", newJString(fabricName))
  add(path_565037, "subscriptionId", newJString(subscriptionId))
  add(path_565037, "vCenterName", newJString(vCenterName))
  add(path_565037, "resourceGroupName", newJString(resourceGroupName))
  add(path_565037, "resourceName", newJString(resourceName))
  result = call_565036.call(path_565037, query_565038, nil, nil, nil)

var replicationvCentersDelete* = Call_ReplicationvCentersDelete_565026(
    name: "replicationvCentersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters/{vCenterName}",
    validator: validate_ReplicationvCentersDelete_565027, base: "",
    url: url_ReplicationvCentersDelete_565028, schemes: {Scheme.Https})
type
  Call_ReplicationJobsList_565054 = ref object of OpenApiRestCall_563564
proc url_ReplicationJobsList_565056(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationJobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationJobsList_565055(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets the list of Azure Site Recovery Jobs for the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565057 = path.getOrDefault("subscriptionId")
  valid_565057 = validateParameter(valid_565057, JString, required = true,
                                 default = nil)
  if valid_565057 != nil:
    section.add "subscriptionId", valid_565057
  var valid_565058 = path.getOrDefault("resourceGroupName")
  valid_565058 = validateParameter(valid_565058, JString, required = true,
                                 default = nil)
  if valid_565058 != nil:
    section.add "resourceGroupName", valid_565058
  var valid_565059 = path.getOrDefault("resourceName")
  valid_565059 = validateParameter(valid_565059, JString, required = true,
                                 default = nil)
  if valid_565059 != nil:
    section.add "resourceName", valid_565059
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565060 = query.getOrDefault("api-version")
  valid_565060 = validateParameter(valid_565060, JString, required = true,
                                 default = nil)
  if valid_565060 != nil:
    section.add "api-version", valid_565060
  var valid_565061 = query.getOrDefault("$filter")
  valid_565061 = validateParameter(valid_565061, JString, required = false,
                                 default = nil)
  if valid_565061 != nil:
    section.add "$filter", valid_565061
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565062: Call_ReplicationJobsList_565054; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of Azure Site Recovery Jobs for the vault.
  ## 
  let valid = call_565062.validator(path, query, header, formData, body)
  let scheme = call_565062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565062.url(scheme.get, call_565062.host, call_565062.base,
                         call_565062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565062, url, valid)

proc call*(call_565063: Call_ReplicationJobsList_565054; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string;
          Filter: string = ""): Recallable =
  ## replicationJobsList
  ## Gets the list of Azure Site Recovery Jobs for the vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   Filter: string
  ##         : OData filter options.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565064 = newJObject()
  var query_565065 = newJObject()
  add(query_565065, "api-version", newJString(apiVersion))
  add(path_565064, "subscriptionId", newJString(subscriptionId))
  add(path_565064, "resourceGroupName", newJString(resourceGroupName))
  add(query_565065, "$filter", newJString(Filter))
  add(path_565064, "resourceName", newJString(resourceName))
  result = call_565063.call(path_565064, query_565065, nil, nil, nil)

var replicationJobsList* = Call_ReplicationJobsList_565054(
    name: "replicationJobsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs",
    validator: validate_ReplicationJobsList_565055, base: "",
    url: url_ReplicationJobsList_565056, schemes: {Scheme.Https})
type
  Call_ReplicationJobsExport_565066 = ref object of OpenApiRestCall_563564
proc url_ReplicationJobsExport_565068(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationJobs/export")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationJobsExport_565067(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to export the details of the Azure Site Recovery jobs of the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565069 = path.getOrDefault("subscriptionId")
  valid_565069 = validateParameter(valid_565069, JString, required = true,
                                 default = nil)
  if valid_565069 != nil:
    section.add "subscriptionId", valid_565069
  var valid_565070 = path.getOrDefault("resourceGroupName")
  valid_565070 = validateParameter(valid_565070, JString, required = true,
                                 default = nil)
  if valid_565070 != nil:
    section.add "resourceGroupName", valid_565070
  var valid_565071 = path.getOrDefault("resourceName")
  valid_565071 = validateParameter(valid_565071, JString, required = true,
                                 default = nil)
  if valid_565071 != nil:
    section.add "resourceName", valid_565071
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565072 = query.getOrDefault("api-version")
  valid_565072 = validateParameter(valid_565072, JString, required = true,
                                 default = nil)
  if valid_565072 != nil:
    section.add "api-version", valid_565072
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   jobQueryParameter: JObject (required)
  ##                    : job query filter.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565074: Call_ReplicationJobsExport_565066; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to export the details of the Azure Site Recovery jobs of the vault.
  ## 
  let valid = call_565074.validator(path, query, header, formData, body)
  let scheme = call_565074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565074.url(scheme.get, call_565074.host, call_565074.base,
                         call_565074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565074, url, valid)

proc call*(call_565075: Call_ReplicationJobsExport_565066; apiVersion: string;
          subscriptionId: string; jobQueryParameter: JsonNode;
          resourceGroupName: string; resourceName: string): Recallable =
  ## replicationJobsExport
  ## The operation to export the details of the Azure Site Recovery jobs of the vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   jobQueryParameter: JObject (required)
  ##                    : job query filter.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565076 = newJObject()
  var query_565077 = newJObject()
  var body_565078 = newJObject()
  add(query_565077, "api-version", newJString(apiVersion))
  add(path_565076, "subscriptionId", newJString(subscriptionId))
  if jobQueryParameter != nil:
    body_565078 = jobQueryParameter
  add(path_565076, "resourceGroupName", newJString(resourceGroupName))
  add(path_565076, "resourceName", newJString(resourceName))
  result = call_565075.call(path_565076, query_565077, nil, nil, body_565078)

var replicationJobsExport* = Call_ReplicationJobsExport_565066(
    name: "replicationJobsExport", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/export",
    validator: validate_ReplicationJobsExport_565067, base: "",
    url: url_ReplicationJobsExport_565068, schemes: {Scheme.Https})
type
  Call_ReplicationJobsGet_565079 = ref object of OpenApiRestCall_563564
proc url_ReplicationJobsGet_565081(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationJobs/"),
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationJobsGet_565080(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get the details of an Azure Site Recovery job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   jobName: JString (required)
  ##          : Job identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565082 = path.getOrDefault("subscriptionId")
  valid_565082 = validateParameter(valid_565082, JString, required = true,
                                 default = nil)
  if valid_565082 != nil:
    section.add "subscriptionId", valid_565082
  var valid_565083 = path.getOrDefault("resourceGroupName")
  valid_565083 = validateParameter(valid_565083, JString, required = true,
                                 default = nil)
  if valid_565083 != nil:
    section.add "resourceGroupName", valid_565083
  var valid_565084 = path.getOrDefault("resourceName")
  valid_565084 = validateParameter(valid_565084, JString, required = true,
                                 default = nil)
  if valid_565084 != nil:
    section.add "resourceName", valid_565084
  var valid_565085 = path.getOrDefault("jobName")
  valid_565085 = validateParameter(valid_565085, JString, required = true,
                                 default = nil)
  if valid_565085 != nil:
    section.add "jobName", valid_565085
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565086 = query.getOrDefault("api-version")
  valid_565086 = validateParameter(valid_565086, JString, required = true,
                                 default = nil)
  if valid_565086 != nil:
    section.add "api-version", valid_565086
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565087: Call_ReplicationJobsGet_565079; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the details of an Azure Site Recovery job.
  ## 
  let valid = call_565087.validator(path, query, header, formData, body)
  let scheme = call_565087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565087.url(scheme.get, call_565087.host, call_565087.base,
                         call_565087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565087, url, valid)

proc call*(call_565088: Call_ReplicationJobsGet_565079; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string;
          jobName: string): Recallable =
  ## replicationJobsGet
  ## Get the details of an Azure Site Recovery job.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   jobName: string (required)
  ##          : Job identifier
  var path_565089 = newJObject()
  var query_565090 = newJObject()
  add(query_565090, "api-version", newJString(apiVersion))
  add(path_565089, "subscriptionId", newJString(subscriptionId))
  add(path_565089, "resourceGroupName", newJString(resourceGroupName))
  add(path_565089, "resourceName", newJString(resourceName))
  add(path_565089, "jobName", newJString(jobName))
  result = call_565088.call(path_565089, query_565090, nil, nil, nil)

var replicationJobsGet* = Call_ReplicationJobsGet_565079(
    name: "replicationJobsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/{jobName}",
    validator: validate_ReplicationJobsGet_565080, base: "",
    url: url_ReplicationJobsGet_565081, schemes: {Scheme.Https})
type
  Call_ReplicationJobsCancel_565091 = ref object of OpenApiRestCall_563564
proc url_ReplicationJobsCancel_565093(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationJobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationJobsCancel_565092(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to cancel an Azure Site Recovery job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   jobName: JString (required)
  ##          : Job identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565094 = path.getOrDefault("subscriptionId")
  valid_565094 = validateParameter(valid_565094, JString, required = true,
                                 default = nil)
  if valid_565094 != nil:
    section.add "subscriptionId", valid_565094
  var valid_565095 = path.getOrDefault("resourceGroupName")
  valid_565095 = validateParameter(valid_565095, JString, required = true,
                                 default = nil)
  if valid_565095 != nil:
    section.add "resourceGroupName", valid_565095
  var valid_565096 = path.getOrDefault("resourceName")
  valid_565096 = validateParameter(valid_565096, JString, required = true,
                                 default = nil)
  if valid_565096 != nil:
    section.add "resourceName", valid_565096
  var valid_565097 = path.getOrDefault("jobName")
  valid_565097 = validateParameter(valid_565097, JString, required = true,
                                 default = nil)
  if valid_565097 != nil:
    section.add "jobName", valid_565097
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565098 = query.getOrDefault("api-version")
  valid_565098 = validateParameter(valid_565098, JString, required = true,
                                 default = nil)
  if valid_565098 != nil:
    section.add "api-version", valid_565098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565099: Call_ReplicationJobsCancel_565091; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to cancel an Azure Site Recovery job.
  ## 
  let valid = call_565099.validator(path, query, header, formData, body)
  let scheme = call_565099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565099.url(scheme.get, call_565099.host, call_565099.base,
                         call_565099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565099, url, valid)

proc call*(call_565100: Call_ReplicationJobsCancel_565091; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string;
          jobName: string): Recallable =
  ## replicationJobsCancel
  ## The operation to cancel an Azure Site Recovery job.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   jobName: string (required)
  ##          : Job identifier.
  var path_565101 = newJObject()
  var query_565102 = newJObject()
  add(query_565102, "api-version", newJString(apiVersion))
  add(path_565101, "subscriptionId", newJString(subscriptionId))
  add(path_565101, "resourceGroupName", newJString(resourceGroupName))
  add(path_565101, "resourceName", newJString(resourceName))
  add(path_565101, "jobName", newJString(jobName))
  result = call_565100.call(path_565101, query_565102, nil, nil, nil)

var replicationJobsCancel* = Call_ReplicationJobsCancel_565091(
    name: "replicationJobsCancel", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/{jobName}/cancel",
    validator: validate_ReplicationJobsCancel_565092, base: "",
    url: url_ReplicationJobsCancel_565093, schemes: {Scheme.Https})
type
  Call_ReplicationJobsRestart_565103 = ref object of OpenApiRestCall_563564
proc url_ReplicationJobsRestart_565105(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationJobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/restart")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationJobsRestart_565104(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to restart an Azure Site Recovery job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   jobName: JString (required)
  ##          : Job identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565106 = path.getOrDefault("subscriptionId")
  valid_565106 = validateParameter(valid_565106, JString, required = true,
                                 default = nil)
  if valid_565106 != nil:
    section.add "subscriptionId", valid_565106
  var valid_565107 = path.getOrDefault("resourceGroupName")
  valid_565107 = validateParameter(valid_565107, JString, required = true,
                                 default = nil)
  if valid_565107 != nil:
    section.add "resourceGroupName", valid_565107
  var valid_565108 = path.getOrDefault("resourceName")
  valid_565108 = validateParameter(valid_565108, JString, required = true,
                                 default = nil)
  if valid_565108 != nil:
    section.add "resourceName", valid_565108
  var valid_565109 = path.getOrDefault("jobName")
  valid_565109 = validateParameter(valid_565109, JString, required = true,
                                 default = nil)
  if valid_565109 != nil:
    section.add "jobName", valid_565109
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565110 = query.getOrDefault("api-version")
  valid_565110 = validateParameter(valid_565110, JString, required = true,
                                 default = nil)
  if valid_565110 != nil:
    section.add "api-version", valid_565110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565111: Call_ReplicationJobsRestart_565103; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to restart an Azure Site Recovery job.
  ## 
  let valid = call_565111.validator(path, query, header, formData, body)
  let scheme = call_565111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565111.url(scheme.get, call_565111.host, call_565111.base,
                         call_565111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565111, url, valid)

proc call*(call_565112: Call_ReplicationJobsRestart_565103; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string;
          jobName: string): Recallable =
  ## replicationJobsRestart
  ## The operation to restart an Azure Site Recovery job.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   jobName: string (required)
  ##          : Job identifier.
  var path_565113 = newJObject()
  var query_565114 = newJObject()
  add(query_565114, "api-version", newJString(apiVersion))
  add(path_565113, "subscriptionId", newJString(subscriptionId))
  add(path_565113, "resourceGroupName", newJString(resourceGroupName))
  add(path_565113, "resourceName", newJString(resourceName))
  add(path_565113, "jobName", newJString(jobName))
  result = call_565112.call(path_565113, query_565114, nil, nil, nil)

var replicationJobsRestart* = Call_ReplicationJobsRestart_565103(
    name: "replicationJobsRestart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/{jobName}/restart",
    validator: validate_ReplicationJobsRestart_565104, base: "",
    url: url_ReplicationJobsRestart_565105, schemes: {Scheme.Https})
type
  Call_ReplicationJobsResume_565115 = ref object of OpenApiRestCall_563564
proc url_ReplicationJobsResume_565117(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationJobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/resume")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationJobsResume_565116(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to resume an Azure Site Recovery job
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   jobName: JString (required)
  ##          : Job identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565118 = path.getOrDefault("subscriptionId")
  valid_565118 = validateParameter(valid_565118, JString, required = true,
                                 default = nil)
  if valid_565118 != nil:
    section.add "subscriptionId", valid_565118
  var valid_565119 = path.getOrDefault("resourceGroupName")
  valid_565119 = validateParameter(valid_565119, JString, required = true,
                                 default = nil)
  if valid_565119 != nil:
    section.add "resourceGroupName", valid_565119
  var valid_565120 = path.getOrDefault("resourceName")
  valid_565120 = validateParameter(valid_565120, JString, required = true,
                                 default = nil)
  if valid_565120 != nil:
    section.add "resourceName", valid_565120
  var valid_565121 = path.getOrDefault("jobName")
  valid_565121 = validateParameter(valid_565121, JString, required = true,
                                 default = nil)
  if valid_565121 != nil:
    section.add "jobName", valid_565121
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565122 = query.getOrDefault("api-version")
  valid_565122 = validateParameter(valid_565122, JString, required = true,
                                 default = nil)
  if valid_565122 != nil:
    section.add "api-version", valid_565122
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   resumeJobParams: JObject (required)
  ##                  : Resume rob comments.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565124: Call_ReplicationJobsResume_565115; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to resume an Azure Site Recovery job
  ## 
  let valid = call_565124.validator(path, query, header, formData, body)
  let scheme = call_565124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565124.url(scheme.get, call_565124.host, call_565124.base,
                         call_565124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565124, url, valid)

proc call*(call_565125: Call_ReplicationJobsResume_565115;
          resumeJobParams: JsonNode; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; resourceName: string; jobName: string): Recallable =
  ## replicationJobsResume
  ## The operation to resume an Azure Site Recovery job
  ##   resumeJobParams: JObject (required)
  ##                  : Resume rob comments.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   jobName: string (required)
  ##          : Job identifier.
  var path_565126 = newJObject()
  var query_565127 = newJObject()
  var body_565128 = newJObject()
  if resumeJobParams != nil:
    body_565128 = resumeJobParams
  add(query_565127, "api-version", newJString(apiVersion))
  add(path_565126, "subscriptionId", newJString(subscriptionId))
  add(path_565126, "resourceGroupName", newJString(resourceGroupName))
  add(path_565126, "resourceName", newJString(resourceName))
  add(path_565126, "jobName", newJString(jobName))
  result = call_565125.call(path_565126, query_565127, nil, nil, body_565128)

var replicationJobsResume* = Call_ReplicationJobsResume_565115(
    name: "replicationJobsResume", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/{jobName}/resume",
    validator: validate_ReplicationJobsResume_565116, base: "",
    url: url_ReplicationJobsResume_565117, schemes: {Scheme.Https})
type
  Call_ReplicationNetworkMappingsList_565129 = ref object of OpenApiRestCall_563564
proc url_ReplicationNetworkMappingsList_565131(protocol: Scheme; host: string;
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
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationNetworkMappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationNetworkMappingsList_565130(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all ASR network mappings in the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565132 = path.getOrDefault("subscriptionId")
  valid_565132 = validateParameter(valid_565132, JString, required = true,
                                 default = nil)
  if valid_565132 != nil:
    section.add "subscriptionId", valid_565132
  var valid_565133 = path.getOrDefault("resourceGroupName")
  valid_565133 = validateParameter(valid_565133, JString, required = true,
                                 default = nil)
  if valid_565133 != nil:
    section.add "resourceGroupName", valid_565133
  var valid_565134 = path.getOrDefault("resourceName")
  valid_565134 = validateParameter(valid_565134, JString, required = true,
                                 default = nil)
  if valid_565134 != nil:
    section.add "resourceName", valid_565134
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565135 = query.getOrDefault("api-version")
  valid_565135 = validateParameter(valid_565135, JString, required = true,
                                 default = nil)
  if valid_565135 != nil:
    section.add "api-version", valid_565135
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565136: Call_ReplicationNetworkMappingsList_565129; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all ASR network mappings in the vault.
  ## 
  let valid = call_565136.validator(path, query, header, formData, body)
  let scheme = call_565136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565136.url(scheme.get, call_565136.host, call_565136.base,
                         call_565136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565136, url, valid)

proc call*(call_565137: Call_ReplicationNetworkMappingsList_565129;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## replicationNetworkMappingsList
  ## Lists all ASR network mappings in the vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565138 = newJObject()
  var query_565139 = newJObject()
  add(query_565139, "api-version", newJString(apiVersion))
  add(path_565138, "subscriptionId", newJString(subscriptionId))
  add(path_565138, "resourceGroupName", newJString(resourceGroupName))
  add(path_565138, "resourceName", newJString(resourceName))
  result = call_565137.call(path_565138, query_565139, nil, nil, nil)

var replicationNetworkMappingsList* = Call_ReplicationNetworkMappingsList_565129(
    name: "replicationNetworkMappingsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationNetworkMappings",
    validator: validate_ReplicationNetworkMappingsList_565130, base: "",
    url: url_ReplicationNetworkMappingsList_565131, schemes: {Scheme.Https})
type
  Call_ReplicationNetworksList_565140 = ref object of OpenApiRestCall_563564
proc url_ReplicationNetworksList_565142(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationNetworks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationNetworksList_565141(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the networks available in a vault
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565143 = path.getOrDefault("subscriptionId")
  valid_565143 = validateParameter(valid_565143, JString, required = true,
                                 default = nil)
  if valid_565143 != nil:
    section.add "subscriptionId", valid_565143
  var valid_565144 = path.getOrDefault("resourceGroupName")
  valid_565144 = validateParameter(valid_565144, JString, required = true,
                                 default = nil)
  if valid_565144 != nil:
    section.add "resourceGroupName", valid_565144
  var valid_565145 = path.getOrDefault("resourceName")
  valid_565145 = validateParameter(valid_565145, JString, required = true,
                                 default = nil)
  if valid_565145 != nil:
    section.add "resourceName", valid_565145
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565146 = query.getOrDefault("api-version")
  valid_565146 = validateParameter(valid_565146, JString, required = true,
                                 default = nil)
  if valid_565146 != nil:
    section.add "api-version", valid_565146
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565147: Call_ReplicationNetworksList_565140; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the networks available in a vault
  ## 
  let valid = call_565147.validator(path, query, header, formData, body)
  let scheme = call_565147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565147.url(scheme.get, call_565147.host, call_565147.base,
                         call_565147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565147, url, valid)

proc call*(call_565148: Call_ReplicationNetworksList_565140; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## replicationNetworksList
  ## Lists the networks available in a vault
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565149 = newJObject()
  var query_565150 = newJObject()
  add(query_565150, "api-version", newJString(apiVersion))
  add(path_565149, "subscriptionId", newJString(subscriptionId))
  add(path_565149, "resourceGroupName", newJString(resourceGroupName))
  add(path_565149, "resourceName", newJString(resourceName))
  result = call_565148.call(path_565149, query_565150, nil, nil, nil)

var replicationNetworksList* = Call_ReplicationNetworksList_565140(
    name: "replicationNetworksList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationNetworks",
    validator: validate_ReplicationNetworksList_565141, base: "",
    url: url_ReplicationNetworksList_565142, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesList_565151 = ref object of OpenApiRestCall_563564
proc url_ReplicationPoliciesList_565153(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationPolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationPoliciesList_565152(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the replication policies for a vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565154 = path.getOrDefault("subscriptionId")
  valid_565154 = validateParameter(valid_565154, JString, required = true,
                                 default = nil)
  if valid_565154 != nil:
    section.add "subscriptionId", valid_565154
  var valid_565155 = path.getOrDefault("resourceGroupName")
  valid_565155 = validateParameter(valid_565155, JString, required = true,
                                 default = nil)
  if valid_565155 != nil:
    section.add "resourceGroupName", valid_565155
  var valid_565156 = path.getOrDefault("resourceName")
  valid_565156 = validateParameter(valid_565156, JString, required = true,
                                 default = nil)
  if valid_565156 != nil:
    section.add "resourceName", valid_565156
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565157 = query.getOrDefault("api-version")
  valid_565157 = validateParameter(valid_565157, JString, required = true,
                                 default = nil)
  if valid_565157 != nil:
    section.add "api-version", valid_565157
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565158: Call_ReplicationPoliciesList_565151; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the replication policies for a vault.
  ## 
  let valid = call_565158.validator(path, query, header, formData, body)
  let scheme = call_565158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565158.url(scheme.get, call_565158.host, call_565158.base,
                         call_565158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565158, url, valid)

proc call*(call_565159: Call_ReplicationPoliciesList_565151; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## replicationPoliciesList
  ## Lists the replication policies for a vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565160 = newJObject()
  var query_565161 = newJObject()
  add(query_565161, "api-version", newJString(apiVersion))
  add(path_565160, "subscriptionId", newJString(subscriptionId))
  add(path_565160, "resourceGroupName", newJString(resourceGroupName))
  add(path_565160, "resourceName", newJString(resourceName))
  result = call_565159.call(path_565160, query_565161, nil, nil, nil)

var replicationPoliciesList* = Call_ReplicationPoliciesList_565151(
    name: "replicationPoliciesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies",
    validator: validate_ReplicationPoliciesList_565152, base: "",
    url: url_ReplicationPoliciesList_565153, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesCreate_565174 = ref object of OpenApiRestCall_563564
proc url_ReplicationPoliciesCreate_565176(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationPolicies/"),
               (kind: VariableSegment, value: "policyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationPoliciesCreate_565175(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create a replication policy
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : Replication policy name
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_565177 = path.getOrDefault("policyName")
  valid_565177 = validateParameter(valid_565177, JString, required = true,
                                 default = nil)
  if valid_565177 != nil:
    section.add "policyName", valid_565177
  var valid_565178 = path.getOrDefault("subscriptionId")
  valid_565178 = validateParameter(valid_565178, JString, required = true,
                                 default = nil)
  if valid_565178 != nil:
    section.add "subscriptionId", valid_565178
  var valid_565179 = path.getOrDefault("resourceGroupName")
  valid_565179 = validateParameter(valid_565179, JString, required = true,
                                 default = nil)
  if valid_565179 != nil:
    section.add "resourceGroupName", valid_565179
  var valid_565180 = path.getOrDefault("resourceName")
  valid_565180 = validateParameter(valid_565180, JString, required = true,
                                 default = nil)
  if valid_565180 != nil:
    section.add "resourceName", valid_565180
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565181 = query.getOrDefault("api-version")
  valid_565181 = validateParameter(valid_565181, JString, required = true,
                                 default = nil)
  if valid_565181 != nil:
    section.add "api-version", valid_565181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Create policy input
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565183: Call_ReplicationPoliciesCreate_565174; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create a replication policy
  ## 
  let valid = call_565183.validator(path, query, header, formData, body)
  let scheme = call_565183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565183.url(scheme.get, call_565183.host, call_565183.base,
                         call_565183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565183, url, valid)

proc call*(call_565184: Call_ReplicationPoliciesCreate_565174; policyName: string;
          apiVersion: string; input: JsonNode; subscriptionId: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## replicationPoliciesCreate
  ## The operation to create a replication policy
  ##   policyName: string (required)
  ##             : Replication policy name
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   input: JObject (required)
  ##        : Create policy input
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565185 = newJObject()
  var query_565186 = newJObject()
  var body_565187 = newJObject()
  add(path_565185, "policyName", newJString(policyName))
  add(query_565186, "api-version", newJString(apiVersion))
  if input != nil:
    body_565187 = input
  add(path_565185, "subscriptionId", newJString(subscriptionId))
  add(path_565185, "resourceGroupName", newJString(resourceGroupName))
  add(path_565185, "resourceName", newJString(resourceName))
  result = call_565184.call(path_565185, query_565186, nil, nil, body_565187)

var replicationPoliciesCreate* = Call_ReplicationPoliciesCreate_565174(
    name: "replicationPoliciesCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies/{policyName}",
    validator: validate_ReplicationPoliciesCreate_565175, base: "",
    url: url_ReplicationPoliciesCreate_565176, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesGet_565162 = ref object of OpenApiRestCall_563564
proc url_ReplicationPoliciesGet_565164(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationPolicies/"),
               (kind: VariableSegment, value: "policyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationPoliciesGet_565163(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of a replication policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : Replication policy name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_565165 = path.getOrDefault("policyName")
  valid_565165 = validateParameter(valid_565165, JString, required = true,
                                 default = nil)
  if valid_565165 != nil:
    section.add "policyName", valid_565165
  var valid_565166 = path.getOrDefault("subscriptionId")
  valid_565166 = validateParameter(valid_565166, JString, required = true,
                                 default = nil)
  if valid_565166 != nil:
    section.add "subscriptionId", valid_565166
  var valid_565167 = path.getOrDefault("resourceGroupName")
  valid_565167 = validateParameter(valid_565167, JString, required = true,
                                 default = nil)
  if valid_565167 != nil:
    section.add "resourceGroupName", valid_565167
  var valid_565168 = path.getOrDefault("resourceName")
  valid_565168 = validateParameter(valid_565168, JString, required = true,
                                 default = nil)
  if valid_565168 != nil:
    section.add "resourceName", valid_565168
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565169 = query.getOrDefault("api-version")
  valid_565169 = validateParameter(valid_565169, JString, required = true,
                                 default = nil)
  if valid_565169 != nil:
    section.add "api-version", valid_565169
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565170: Call_ReplicationPoliciesGet_565162; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a replication policy.
  ## 
  let valid = call_565170.validator(path, query, header, formData, body)
  let scheme = call_565170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565170.url(scheme.get, call_565170.host, call_565170.base,
                         call_565170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565170, url, valid)

proc call*(call_565171: Call_ReplicationPoliciesGet_565162; policyName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## replicationPoliciesGet
  ## Gets the details of a replication policy.
  ##   policyName: string (required)
  ##             : Replication policy name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565172 = newJObject()
  var query_565173 = newJObject()
  add(path_565172, "policyName", newJString(policyName))
  add(query_565173, "api-version", newJString(apiVersion))
  add(path_565172, "subscriptionId", newJString(subscriptionId))
  add(path_565172, "resourceGroupName", newJString(resourceGroupName))
  add(path_565172, "resourceName", newJString(resourceName))
  result = call_565171.call(path_565172, query_565173, nil, nil, nil)

var replicationPoliciesGet* = Call_ReplicationPoliciesGet_565162(
    name: "replicationPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies/{policyName}",
    validator: validate_ReplicationPoliciesGet_565163, base: "",
    url: url_ReplicationPoliciesGet_565164, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesUpdate_565200 = ref object of OpenApiRestCall_563564
proc url_ReplicationPoliciesUpdate_565202(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationPolicies/"),
               (kind: VariableSegment, value: "policyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationPoliciesUpdate_565201(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update a replication policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : Protection profile Id.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_565203 = path.getOrDefault("policyName")
  valid_565203 = validateParameter(valid_565203, JString, required = true,
                                 default = nil)
  if valid_565203 != nil:
    section.add "policyName", valid_565203
  var valid_565204 = path.getOrDefault("subscriptionId")
  valid_565204 = validateParameter(valid_565204, JString, required = true,
                                 default = nil)
  if valid_565204 != nil:
    section.add "subscriptionId", valid_565204
  var valid_565205 = path.getOrDefault("resourceGroupName")
  valid_565205 = validateParameter(valid_565205, JString, required = true,
                                 default = nil)
  if valid_565205 != nil:
    section.add "resourceGroupName", valid_565205
  var valid_565206 = path.getOrDefault("resourceName")
  valid_565206 = validateParameter(valid_565206, JString, required = true,
                                 default = nil)
  if valid_565206 != nil:
    section.add "resourceName", valid_565206
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565207 = query.getOrDefault("api-version")
  valid_565207 = validateParameter(valid_565207, JString, required = true,
                                 default = nil)
  if valid_565207 != nil:
    section.add "api-version", valid_565207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Update Protection Profile Input
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565209: Call_ReplicationPoliciesUpdate_565200; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a replication policy.
  ## 
  let valid = call_565209.validator(path, query, header, formData, body)
  let scheme = call_565209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565209.url(scheme.get, call_565209.host, call_565209.base,
                         call_565209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565209, url, valid)

proc call*(call_565210: Call_ReplicationPoliciesUpdate_565200; policyName: string;
          apiVersion: string; input: JsonNode; subscriptionId: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## replicationPoliciesUpdate
  ## The operation to update a replication policy.
  ##   policyName: string (required)
  ##             : Protection profile Id.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   input: JObject (required)
  ##        : Update Protection Profile Input
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565211 = newJObject()
  var query_565212 = newJObject()
  var body_565213 = newJObject()
  add(path_565211, "policyName", newJString(policyName))
  add(query_565212, "api-version", newJString(apiVersion))
  if input != nil:
    body_565213 = input
  add(path_565211, "subscriptionId", newJString(subscriptionId))
  add(path_565211, "resourceGroupName", newJString(resourceGroupName))
  add(path_565211, "resourceName", newJString(resourceName))
  result = call_565210.call(path_565211, query_565212, nil, nil, body_565213)

var replicationPoliciesUpdate* = Call_ReplicationPoliciesUpdate_565200(
    name: "replicationPoliciesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies/{policyName}",
    validator: validate_ReplicationPoliciesUpdate_565201, base: "",
    url: url_ReplicationPoliciesUpdate_565202, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesDelete_565188 = ref object of OpenApiRestCall_563564
proc url_ReplicationPoliciesDelete_565190(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationPolicies/"),
               (kind: VariableSegment, value: "policyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationPoliciesDelete_565189(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete a replication policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : Replication policy name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_565191 = path.getOrDefault("policyName")
  valid_565191 = validateParameter(valid_565191, JString, required = true,
                                 default = nil)
  if valid_565191 != nil:
    section.add "policyName", valid_565191
  var valid_565192 = path.getOrDefault("subscriptionId")
  valid_565192 = validateParameter(valid_565192, JString, required = true,
                                 default = nil)
  if valid_565192 != nil:
    section.add "subscriptionId", valid_565192
  var valid_565193 = path.getOrDefault("resourceGroupName")
  valid_565193 = validateParameter(valid_565193, JString, required = true,
                                 default = nil)
  if valid_565193 != nil:
    section.add "resourceGroupName", valid_565193
  var valid_565194 = path.getOrDefault("resourceName")
  valid_565194 = validateParameter(valid_565194, JString, required = true,
                                 default = nil)
  if valid_565194 != nil:
    section.add "resourceName", valid_565194
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565195 = query.getOrDefault("api-version")
  valid_565195 = validateParameter(valid_565195, JString, required = true,
                                 default = nil)
  if valid_565195 != nil:
    section.add "api-version", valid_565195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565196: Call_ReplicationPoliciesDelete_565188; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete a replication policy.
  ## 
  let valid = call_565196.validator(path, query, header, formData, body)
  let scheme = call_565196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565196.url(scheme.get, call_565196.host, call_565196.base,
                         call_565196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565196, url, valid)

proc call*(call_565197: Call_ReplicationPoliciesDelete_565188; policyName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## replicationPoliciesDelete
  ## The operation to delete a replication policy.
  ##   policyName: string (required)
  ##             : Replication policy name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565198 = newJObject()
  var query_565199 = newJObject()
  add(path_565198, "policyName", newJString(policyName))
  add(query_565199, "api-version", newJString(apiVersion))
  add(path_565198, "subscriptionId", newJString(subscriptionId))
  add(path_565198, "resourceGroupName", newJString(resourceGroupName))
  add(path_565198, "resourceName", newJString(resourceName))
  result = call_565197.call(path_565198, query_565199, nil, nil, nil)

var replicationPoliciesDelete* = Call_ReplicationPoliciesDelete_565188(
    name: "replicationPoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies/{policyName}",
    validator: validate_ReplicationPoliciesDelete_565189, base: "",
    url: url_ReplicationPoliciesDelete_565190, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsList_565214 = ref object of OpenApiRestCall_563564
proc url_ReplicationProtectedItemsList_565216(protocol: Scheme; host: string;
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
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationProtectedItems")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsList_565215(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the list of ASR replication protected items in the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565217 = path.getOrDefault("subscriptionId")
  valid_565217 = validateParameter(valid_565217, JString, required = true,
                                 default = nil)
  if valid_565217 != nil:
    section.add "subscriptionId", valid_565217
  var valid_565218 = path.getOrDefault("resourceGroupName")
  valid_565218 = validateParameter(valid_565218, JString, required = true,
                                 default = nil)
  if valid_565218 != nil:
    section.add "resourceGroupName", valid_565218
  var valid_565219 = path.getOrDefault("resourceName")
  valid_565219 = validateParameter(valid_565219, JString, required = true,
                                 default = nil)
  if valid_565219 != nil:
    section.add "resourceName", valid_565219
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   skipToken: JString
  ##            : The pagination token. Possible values: "FabricId" or "FabricId_CloudId" or null
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565220 = query.getOrDefault("api-version")
  valid_565220 = validateParameter(valid_565220, JString, required = true,
                                 default = nil)
  if valid_565220 != nil:
    section.add "api-version", valid_565220
  var valid_565221 = query.getOrDefault("skipToken")
  valid_565221 = validateParameter(valid_565221, JString, required = false,
                                 default = nil)
  if valid_565221 != nil:
    section.add "skipToken", valid_565221
  var valid_565222 = query.getOrDefault("$filter")
  valid_565222 = validateParameter(valid_565222, JString, required = false,
                                 default = nil)
  if valid_565222 != nil:
    section.add "$filter", valid_565222
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565223: Call_ReplicationProtectedItemsList_565214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of ASR replication protected items in the vault.
  ## 
  let valid = call_565223.validator(path, query, header, formData, body)
  let scheme = call_565223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565223.url(scheme.get, call_565223.host, call_565223.base,
                         call_565223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565223, url, valid)

proc call*(call_565224: Call_ReplicationProtectedItemsList_565214;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string; skipToken: string = ""; Filter: string = ""): Recallable =
  ## replicationProtectedItemsList
  ## Gets the list of ASR replication protected items in the vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   skipToken: string
  ##            : The pagination token. Possible values: "FabricId" or "FabricId_CloudId" or null
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   Filter: string
  ##         : OData filter options.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565225 = newJObject()
  var query_565226 = newJObject()
  add(query_565226, "api-version", newJString(apiVersion))
  add(query_565226, "skipToken", newJString(skipToken))
  add(path_565225, "subscriptionId", newJString(subscriptionId))
  add(path_565225, "resourceGroupName", newJString(resourceGroupName))
  add(query_565226, "$filter", newJString(Filter))
  add(path_565225, "resourceName", newJString(resourceName))
  result = call_565224.call(path_565225, query_565226, nil, nil, nil)

var replicationProtectedItemsList* = Call_ReplicationProtectedItemsList_565214(
    name: "replicationProtectedItemsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationProtectedItems",
    validator: validate_ReplicationProtectedItemsList_565215, base: "",
    url: url_ReplicationProtectedItemsList_565216, schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsList_565227 = ref object of OpenApiRestCall_563564
proc url_ReplicationProtectionContainerMappingsList_565229(protocol: Scheme;
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
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment, value: "/replicationProtectionContainerMappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectionContainerMappingsList_565228(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the protection container mappings in the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565230 = path.getOrDefault("subscriptionId")
  valid_565230 = validateParameter(valid_565230, JString, required = true,
                                 default = nil)
  if valid_565230 != nil:
    section.add "subscriptionId", valid_565230
  var valid_565231 = path.getOrDefault("resourceGroupName")
  valid_565231 = validateParameter(valid_565231, JString, required = true,
                                 default = nil)
  if valid_565231 != nil:
    section.add "resourceGroupName", valid_565231
  var valid_565232 = path.getOrDefault("resourceName")
  valid_565232 = validateParameter(valid_565232, JString, required = true,
                                 default = nil)
  if valid_565232 != nil:
    section.add "resourceName", valid_565232
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565233 = query.getOrDefault("api-version")
  valid_565233 = validateParameter(valid_565233, JString, required = true,
                                 default = nil)
  if valid_565233 != nil:
    section.add "api-version", valid_565233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565234: Call_ReplicationProtectionContainerMappingsList_565227;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the protection container mappings in the vault.
  ## 
  let valid = call_565234.validator(path, query, header, formData, body)
  let scheme = call_565234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565234.url(scheme.get, call_565234.host, call_565234.base,
                         call_565234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565234, url, valid)

proc call*(call_565235: Call_ReplicationProtectionContainerMappingsList_565227;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## replicationProtectionContainerMappingsList
  ## Lists the protection container mappings in the vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565236 = newJObject()
  var query_565237 = newJObject()
  add(query_565237, "api-version", newJString(apiVersion))
  add(path_565236, "subscriptionId", newJString(subscriptionId))
  add(path_565236, "resourceGroupName", newJString(resourceGroupName))
  add(path_565236, "resourceName", newJString(resourceName))
  result = call_565235.call(path_565236, query_565237, nil, nil, nil)

var replicationProtectionContainerMappingsList* = Call_ReplicationProtectionContainerMappingsList_565227(
    name: "replicationProtectionContainerMappingsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationProtectionContainerMappings",
    validator: validate_ReplicationProtectionContainerMappingsList_565228,
    base: "", url: url_ReplicationProtectionContainerMappingsList_565229,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersList_565238 = ref object of OpenApiRestCall_563564
proc url_ReplicationProtectionContainersList_565240(protocol: Scheme; host: string;
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
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment, value: "/replicationProtectionContainers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectionContainersList_565239(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the protection containers in a vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565241 = path.getOrDefault("subscriptionId")
  valid_565241 = validateParameter(valid_565241, JString, required = true,
                                 default = nil)
  if valid_565241 != nil:
    section.add "subscriptionId", valid_565241
  var valid_565242 = path.getOrDefault("resourceGroupName")
  valid_565242 = validateParameter(valid_565242, JString, required = true,
                                 default = nil)
  if valid_565242 != nil:
    section.add "resourceGroupName", valid_565242
  var valid_565243 = path.getOrDefault("resourceName")
  valid_565243 = validateParameter(valid_565243, JString, required = true,
                                 default = nil)
  if valid_565243 != nil:
    section.add "resourceName", valid_565243
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565244 = query.getOrDefault("api-version")
  valid_565244 = validateParameter(valid_565244, JString, required = true,
                                 default = nil)
  if valid_565244 != nil:
    section.add "api-version", valid_565244
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565245: Call_ReplicationProtectionContainersList_565238;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the protection containers in a vault.
  ## 
  let valid = call_565245.validator(path, query, header, formData, body)
  let scheme = call_565245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565245.url(scheme.get, call_565245.host, call_565245.base,
                         call_565245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565245, url, valid)

proc call*(call_565246: Call_ReplicationProtectionContainersList_565238;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## replicationProtectionContainersList
  ## Lists the protection containers in a vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565247 = newJObject()
  var query_565248 = newJObject()
  add(query_565248, "api-version", newJString(apiVersion))
  add(path_565247, "subscriptionId", newJString(subscriptionId))
  add(path_565247, "resourceGroupName", newJString(resourceGroupName))
  add(path_565247, "resourceName", newJString(resourceName))
  result = call_565246.call(path_565247, query_565248, nil, nil, nil)

var replicationProtectionContainersList* = Call_ReplicationProtectionContainersList_565238(
    name: "replicationProtectionContainersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationProtectionContainers",
    validator: validate_ReplicationProtectionContainersList_565239, base: "",
    url: url_ReplicationProtectionContainersList_565240, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansList_565249 = ref object of OpenApiRestCall_563564
proc url_ReplicationRecoveryPlansList_565251(protocol: Scheme; host: string;
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
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationRecoveryPlans")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationRecoveryPlansList_565250(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the recovery plans in the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565252 = path.getOrDefault("subscriptionId")
  valid_565252 = validateParameter(valid_565252, JString, required = true,
                                 default = nil)
  if valid_565252 != nil:
    section.add "subscriptionId", valid_565252
  var valid_565253 = path.getOrDefault("resourceGroupName")
  valid_565253 = validateParameter(valid_565253, JString, required = true,
                                 default = nil)
  if valid_565253 != nil:
    section.add "resourceGroupName", valid_565253
  var valid_565254 = path.getOrDefault("resourceName")
  valid_565254 = validateParameter(valid_565254, JString, required = true,
                                 default = nil)
  if valid_565254 != nil:
    section.add "resourceName", valid_565254
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565255 = query.getOrDefault("api-version")
  valid_565255 = validateParameter(valid_565255, JString, required = true,
                                 default = nil)
  if valid_565255 != nil:
    section.add "api-version", valid_565255
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565256: Call_ReplicationRecoveryPlansList_565249; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the recovery plans in the vault.
  ## 
  let valid = call_565256.validator(path, query, header, formData, body)
  let scheme = call_565256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565256.url(scheme.get, call_565256.host, call_565256.base,
                         call_565256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565256, url, valid)

proc call*(call_565257: Call_ReplicationRecoveryPlansList_565249;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## replicationRecoveryPlansList
  ## Lists the recovery plans in the vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565258 = newJObject()
  var query_565259 = newJObject()
  add(query_565259, "api-version", newJString(apiVersion))
  add(path_565258, "subscriptionId", newJString(subscriptionId))
  add(path_565258, "resourceGroupName", newJString(resourceGroupName))
  add(path_565258, "resourceName", newJString(resourceName))
  result = call_565257.call(path_565258, query_565259, nil, nil, nil)

var replicationRecoveryPlansList* = Call_ReplicationRecoveryPlansList_565249(
    name: "replicationRecoveryPlansList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans",
    validator: validate_ReplicationRecoveryPlansList_565250, base: "",
    url: url_ReplicationRecoveryPlansList_565251, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansCreate_565272 = ref object of OpenApiRestCall_563564
proc url_ReplicationRecoveryPlansCreate_565274(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "recoveryPlanName" in path,
        "`recoveryPlanName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationRecoveryPlans/"),
               (kind: VariableSegment, value: "recoveryPlanName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationRecoveryPlansCreate_565273(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create a recovery plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   recoveryPlanName: JString (required)
  ##                   : Recovery plan name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `recoveryPlanName` field"
  var valid_565275 = path.getOrDefault("recoveryPlanName")
  valid_565275 = validateParameter(valid_565275, JString, required = true,
                                 default = nil)
  if valid_565275 != nil:
    section.add "recoveryPlanName", valid_565275
  var valid_565276 = path.getOrDefault("subscriptionId")
  valid_565276 = validateParameter(valid_565276, JString, required = true,
                                 default = nil)
  if valid_565276 != nil:
    section.add "subscriptionId", valid_565276
  var valid_565277 = path.getOrDefault("resourceGroupName")
  valid_565277 = validateParameter(valid_565277, JString, required = true,
                                 default = nil)
  if valid_565277 != nil:
    section.add "resourceGroupName", valid_565277
  var valid_565278 = path.getOrDefault("resourceName")
  valid_565278 = validateParameter(valid_565278, JString, required = true,
                                 default = nil)
  if valid_565278 != nil:
    section.add "resourceName", valid_565278
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565279 = query.getOrDefault("api-version")
  valid_565279 = validateParameter(valid_565279, JString, required = true,
                                 default = nil)
  if valid_565279 != nil:
    section.add "api-version", valid_565279
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Recovery Plan creation input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565281: Call_ReplicationRecoveryPlansCreate_565272; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create a recovery plan.
  ## 
  let valid = call_565281.validator(path, query, header, formData, body)
  let scheme = call_565281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565281.url(scheme.get, call_565281.host, call_565281.base,
                         call_565281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565281, url, valid)

proc call*(call_565282: Call_ReplicationRecoveryPlansCreate_565272;
          recoveryPlanName: string; apiVersion: string; input: JsonNode;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## replicationRecoveryPlansCreate
  ## The operation to create a recovery plan.
  ##   recoveryPlanName: string (required)
  ##                   : Recovery plan name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   input: JObject (required)
  ##        : Recovery Plan creation input.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565283 = newJObject()
  var query_565284 = newJObject()
  var body_565285 = newJObject()
  add(path_565283, "recoveryPlanName", newJString(recoveryPlanName))
  add(query_565284, "api-version", newJString(apiVersion))
  if input != nil:
    body_565285 = input
  add(path_565283, "subscriptionId", newJString(subscriptionId))
  add(path_565283, "resourceGroupName", newJString(resourceGroupName))
  add(path_565283, "resourceName", newJString(resourceName))
  result = call_565282.call(path_565283, query_565284, nil, nil, body_565285)

var replicationRecoveryPlansCreate* = Call_ReplicationRecoveryPlansCreate_565272(
    name: "replicationRecoveryPlansCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}",
    validator: validate_ReplicationRecoveryPlansCreate_565273, base: "",
    url: url_ReplicationRecoveryPlansCreate_565274, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansGet_565260 = ref object of OpenApiRestCall_563564
proc url_ReplicationRecoveryPlansGet_565262(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "recoveryPlanName" in path,
        "`recoveryPlanName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationRecoveryPlans/"),
               (kind: VariableSegment, value: "recoveryPlanName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationRecoveryPlansGet_565261(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the recovery plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   recoveryPlanName: JString (required)
  ##                   : Name of the recovery plan.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `recoveryPlanName` field"
  var valid_565263 = path.getOrDefault("recoveryPlanName")
  valid_565263 = validateParameter(valid_565263, JString, required = true,
                                 default = nil)
  if valid_565263 != nil:
    section.add "recoveryPlanName", valid_565263
  var valid_565264 = path.getOrDefault("subscriptionId")
  valid_565264 = validateParameter(valid_565264, JString, required = true,
                                 default = nil)
  if valid_565264 != nil:
    section.add "subscriptionId", valid_565264
  var valid_565265 = path.getOrDefault("resourceGroupName")
  valid_565265 = validateParameter(valid_565265, JString, required = true,
                                 default = nil)
  if valid_565265 != nil:
    section.add "resourceGroupName", valid_565265
  var valid_565266 = path.getOrDefault("resourceName")
  valid_565266 = validateParameter(valid_565266, JString, required = true,
                                 default = nil)
  if valid_565266 != nil:
    section.add "resourceName", valid_565266
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565267 = query.getOrDefault("api-version")
  valid_565267 = validateParameter(valid_565267, JString, required = true,
                                 default = nil)
  if valid_565267 != nil:
    section.add "api-version", valid_565267
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565268: Call_ReplicationRecoveryPlansGet_565260; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the recovery plan.
  ## 
  let valid = call_565268.validator(path, query, header, formData, body)
  let scheme = call_565268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565268.url(scheme.get, call_565268.host, call_565268.base,
                         call_565268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565268, url, valid)

proc call*(call_565269: Call_ReplicationRecoveryPlansGet_565260;
          recoveryPlanName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## replicationRecoveryPlansGet
  ## Gets the details of the recovery plan.
  ##   recoveryPlanName: string (required)
  ##                   : Name of the recovery plan.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565270 = newJObject()
  var query_565271 = newJObject()
  add(path_565270, "recoveryPlanName", newJString(recoveryPlanName))
  add(query_565271, "api-version", newJString(apiVersion))
  add(path_565270, "subscriptionId", newJString(subscriptionId))
  add(path_565270, "resourceGroupName", newJString(resourceGroupName))
  add(path_565270, "resourceName", newJString(resourceName))
  result = call_565269.call(path_565270, query_565271, nil, nil, nil)

var replicationRecoveryPlansGet* = Call_ReplicationRecoveryPlansGet_565260(
    name: "replicationRecoveryPlansGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}",
    validator: validate_ReplicationRecoveryPlansGet_565261, base: "",
    url: url_ReplicationRecoveryPlansGet_565262, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansUpdate_565298 = ref object of OpenApiRestCall_563564
proc url_ReplicationRecoveryPlansUpdate_565300(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "recoveryPlanName" in path,
        "`recoveryPlanName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationRecoveryPlans/"),
               (kind: VariableSegment, value: "recoveryPlanName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationRecoveryPlansUpdate_565299(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update a recovery plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   recoveryPlanName: JString (required)
  ##                   : Recovery plan name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `recoveryPlanName` field"
  var valid_565301 = path.getOrDefault("recoveryPlanName")
  valid_565301 = validateParameter(valid_565301, JString, required = true,
                                 default = nil)
  if valid_565301 != nil:
    section.add "recoveryPlanName", valid_565301
  var valid_565302 = path.getOrDefault("subscriptionId")
  valid_565302 = validateParameter(valid_565302, JString, required = true,
                                 default = nil)
  if valid_565302 != nil:
    section.add "subscriptionId", valid_565302
  var valid_565303 = path.getOrDefault("resourceGroupName")
  valid_565303 = validateParameter(valid_565303, JString, required = true,
                                 default = nil)
  if valid_565303 != nil:
    section.add "resourceGroupName", valid_565303
  var valid_565304 = path.getOrDefault("resourceName")
  valid_565304 = validateParameter(valid_565304, JString, required = true,
                                 default = nil)
  if valid_565304 != nil:
    section.add "resourceName", valid_565304
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565305 = query.getOrDefault("api-version")
  valid_565305 = validateParameter(valid_565305, JString, required = true,
                                 default = nil)
  if valid_565305 != nil:
    section.add "api-version", valid_565305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Update recovery plan input
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565307: Call_ReplicationRecoveryPlansUpdate_565298; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a recovery plan.
  ## 
  let valid = call_565307.validator(path, query, header, formData, body)
  let scheme = call_565307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565307.url(scheme.get, call_565307.host, call_565307.base,
                         call_565307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565307, url, valid)

proc call*(call_565308: Call_ReplicationRecoveryPlansUpdate_565298;
          recoveryPlanName: string; apiVersion: string; input: JsonNode;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## replicationRecoveryPlansUpdate
  ## The operation to update a recovery plan.
  ##   recoveryPlanName: string (required)
  ##                   : Recovery plan name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   input: JObject (required)
  ##        : Update recovery plan input
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565309 = newJObject()
  var query_565310 = newJObject()
  var body_565311 = newJObject()
  add(path_565309, "recoveryPlanName", newJString(recoveryPlanName))
  add(query_565310, "api-version", newJString(apiVersion))
  if input != nil:
    body_565311 = input
  add(path_565309, "subscriptionId", newJString(subscriptionId))
  add(path_565309, "resourceGroupName", newJString(resourceGroupName))
  add(path_565309, "resourceName", newJString(resourceName))
  result = call_565308.call(path_565309, query_565310, nil, nil, body_565311)

var replicationRecoveryPlansUpdate* = Call_ReplicationRecoveryPlansUpdate_565298(
    name: "replicationRecoveryPlansUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}",
    validator: validate_ReplicationRecoveryPlansUpdate_565299, base: "",
    url: url_ReplicationRecoveryPlansUpdate_565300, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansDelete_565286 = ref object of OpenApiRestCall_563564
proc url_ReplicationRecoveryPlansDelete_565288(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "recoveryPlanName" in path,
        "`recoveryPlanName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationRecoveryPlans/"),
               (kind: VariableSegment, value: "recoveryPlanName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationRecoveryPlansDelete_565287(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a recovery plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   recoveryPlanName: JString (required)
  ##                   : Recovery plan name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `recoveryPlanName` field"
  var valid_565289 = path.getOrDefault("recoveryPlanName")
  valid_565289 = validateParameter(valid_565289, JString, required = true,
                                 default = nil)
  if valid_565289 != nil:
    section.add "recoveryPlanName", valid_565289
  var valid_565290 = path.getOrDefault("subscriptionId")
  valid_565290 = validateParameter(valid_565290, JString, required = true,
                                 default = nil)
  if valid_565290 != nil:
    section.add "subscriptionId", valid_565290
  var valid_565291 = path.getOrDefault("resourceGroupName")
  valid_565291 = validateParameter(valid_565291, JString, required = true,
                                 default = nil)
  if valid_565291 != nil:
    section.add "resourceGroupName", valid_565291
  var valid_565292 = path.getOrDefault("resourceName")
  valid_565292 = validateParameter(valid_565292, JString, required = true,
                                 default = nil)
  if valid_565292 != nil:
    section.add "resourceName", valid_565292
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565293 = query.getOrDefault("api-version")
  valid_565293 = validateParameter(valid_565293, JString, required = true,
                                 default = nil)
  if valid_565293 != nil:
    section.add "api-version", valid_565293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565294: Call_ReplicationRecoveryPlansDelete_565286; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a recovery plan.
  ## 
  let valid = call_565294.validator(path, query, header, formData, body)
  let scheme = call_565294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565294.url(scheme.get, call_565294.host, call_565294.base,
                         call_565294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565294, url, valid)

proc call*(call_565295: Call_ReplicationRecoveryPlansDelete_565286;
          recoveryPlanName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## replicationRecoveryPlansDelete
  ## Delete a recovery plan.
  ##   recoveryPlanName: string (required)
  ##                   : Recovery plan name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565296 = newJObject()
  var query_565297 = newJObject()
  add(path_565296, "recoveryPlanName", newJString(recoveryPlanName))
  add(query_565297, "api-version", newJString(apiVersion))
  add(path_565296, "subscriptionId", newJString(subscriptionId))
  add(path_565296, "resourceGroupName", newJString(resourceGroupName))
  add(path_565296, "resourceName", newJString(resourceName))
  result = call_565295.call(path_565296, query_565297, nil, nil, nil)

var replicationRecoveryPlansDelete* = Call_ReplicationRecoveryPlansDelete_565286(
    name: "replicationRecoveryPlansDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}",
    validator: validate_ReplicationRecoveryPlansDelete_565287, base: "",
    url: url_ReplicationRecoveryPlansDelete_565288, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansFailoverCommit_565312 = ref object of OpenApiRestCall_563564
proc url_ReplicationRecoveryPlansFailoverCommit_565314(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "recoveryPlanName" in path,
        "`recoveryPlanName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationRecoveryPlans/"),
               (kind: VariableSegment, value: "recoveryPlanName"),
               (kind: ConstantSegment, value: "/failoverCommit")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationRecoveryPlansFailoverCommit_565313(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to commit the fail over of a recovery plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   recoveryPlanName: JString (required)
  ##                   : Recovery plan name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `recoveryPlanName` field"
  var valid_565315 = path.getOrDefault("recoveryPlanName")
  valid_565315 = validateParameter(valid_565315, JString, required = true,
                                 default = nil)
  if valid_565315 != nil:
    section.add "recoveryPlanName", valid_565315
  var valid_565316 = path.getOrDefault("subscriptionId")
  valid_565316 = validateParameter(valid_565316, JString, required = true,
                                 default = nil)
  if valid_565316 != nil:
    section.add "subscriptionId", valid_565316
  var valid_565317 = path.getOrDefault("resourceGroupName")
  valid_565317 = validateParameter(valid_565317, JString, required = true,
                                 default = nil)
  if valid_565317 != nil:
    section.add "resourceGroupName", valid_565317
  var valid_565318 = path.getOrDefault("resourceName")
  valid_565318 = validateParameter(valid_565318, JString, required = true,
                                 default = nil)
  if valid_565318 != nil:
    section.add "resourceName", valid_565318
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565319 = query.getOrDefault("api-version")
  valid_565319 = validateParameter(valid_565319, JString, required = true,
                                 default = nil)
  if valid_565319 != nil:
    section.add "api-version", valid_565319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565320: Call_ReplicationRecoveryPlansFailoverCommit_565312;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to commit the fail over of a recovery plan.
  ## 
  let valid = call_565320.validator(path, query, header, formData, body)
  let scheme = call_565320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565320.url(scheme.get, call_565320.host, call_565320.base,
                         call_565320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565320, url, valid)

proc call*(call_565321: Call_ReplicationRecoveryPlansFailoverCommit_565312;
          recoveryPlanName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## replicationRecoveryPlansFailoverCommit
  ## The operation to commit the fail over of a recovery plan.
  ##   recoveryPlanName: string (required)
  ##                   : Recovery plan name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565322 = newJObject()
  var query_565323 = newJObject()
  add(path_565322, "recoveryPlanName", newJString(recoveryPlanName))
  add(query_565323, "api-version", newJString(apiVersion))
  add(path_565322, "subscriptionId", newJString(subscriptionId))
  add(path_565322, "resourceGroupName", newJString(resourceGroupName))
  add(path_565322, "resourceName", newJString(resourceName))
  result = call_565321.call(path_565322, query_565323, nil, nil, nil)

var replicationRecoveryPlansFailoverCommit* = Call_ReplicationRecoveryPlansFailoverCommit_565312(
    name: "replicationRecoveryPlansFailoverCommit", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/failoverCommit",
    validator: validate_ReplicationRecoveryPlansFailoverCommit_565313, base: "",
    url: url_ReplicationRecoveryPlansFailoverCommit_565314,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansPlannedFailover_565324 = ref object of OpenApiRestCall_563564
proc url_ReplicationRecoveryPlansPlannedFailover_565326(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "recoveryPlanName" in path,
        "`recoveryPlanName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationRecoveryPlans/"),
               (kind: VariableSegment, value: "recoveryPlanName"),
               (kind: ConstantSegment, value: "/plannedFailover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationRecoveryPlansPlannedFailover_565325(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to start the planned failover of a recovery plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   recoveryPlanName: JString (required)
  ##                   : Recovery plan name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `recoveryPlanName` field"
  var valid_565327 = path.getOrDefault("recoveryPlanName")
  valid_565327 = validateParameter(valid_565327, JString, required = true,
                                 default = nil)
  if valid_565327 != nil:
    section.add "recoveryPlanName", valid_565327
  var valid_565328 = path.getOrDefault("subscriptionId")
  valid_565328 = validateParameter(valid_565328, JString, required = true,
                                 default = nil)
  if valid_565328 != nil:
    section.add "subscriptionId", valid_565328
  var valid_565329 = path.getOrDefault("resourceGroupName")
  valid_565329 = validateParameter(valid_565329, JString, required = true,
                                 default = nil)
  if valid_565329 != nil:
    section.add "resourceGroupName", valid_565329
  var valid_565330 = path.getOrDefault("resourceName")
  valid_565330 = validateParameter(valid_565330, JString, required = true,
                                 default = nil)
  if valid_565330 != nil:
    section.add "resourceName", valid_565330
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565331 = query.getOrDefault("api-version")
  valid_565331 = validateParameter(valid_565331, JString, required = true,
                                 default = nil)
  if valid_565331 != nil:
    section.add "api-version", valid_565331
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Failover input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565333: Call_ReplicationRecoveryPlansPlannedFailover_565324;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to start the planned failover of a recovery plan.
  ## 
  let valid = call_565333.validator(path, query, header, formData, body)
  let scheme = call_565333.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565333.url(scheme.get, call_565333.host, call_565333.base,
                         call_565333.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565333, url, valid)

proc call*(call_565334: Call_ReplicationRecoveryPlansPlannedFailover_565324;
          recoveryPlanName: string; apiVersion: string; input: JsonNode;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## replicationRecoveryPlansPlannedFailover
  ## The operation to start the planned failover of a recovery plan.
  ##   recoveryPlanName: string (required)
  ##                   : Recovery plan name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   input: JObject (required)
  ##        : Failover input.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565335 = newJObject()
  var query_565336 = newJObject()
  var body_565337 = newJObject()
  add(path_565335, "recoveryPlanName", newJString(recoveryPlanName))
  add(query_565336, "api-version", newJString(apiVersion))
  if input != nil:
    body_565337 = input
  add(path_565335, "subscriptionId", newJString(subscriptionId))
  add(path_565335, "resourceGroupName", newJString(resourceGroupName))
  add(path_565335, "resourceName", newJString(resourceName))
  result = call_565334.call(path_565335, query_565336, nil, nil, body_565337)

var replicationRecoveryPlansPlannedFailover* = Call_ReplicationRecoveryPlansPlannedFailover_565324(
    name: "replicationRecoveryPlansPlannedFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/plannedFailover",
    validator: validate_ReplicationRecoveryPlansPlannedFailover_565325, base: "",
    url: url_ReplicationRecoveryPlansPlannedFailover_565326,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansReprotect_565338 = ref object of OpenApiRestCall_563564
proc url_ReplicationRecoveryPlansReprotect_565340(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "recoveryPlanName" in path,
        "`recoveryPlanName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationRecoveryPlans/"),
               (kind: VariableSegment, value: "recoveryPlanName"),
               (kind: ConstantSegment, value: "/reProtect")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationRecoveryPlansReprotect_565339(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to reprotect(reverse replicate) a recovery plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   recoveryPlanName: JString (required)
  ##                   : Recovery plan name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `recoveryPlanName` field"
  var valid_565341 = path.getOrDefault("recoveryPlanName")
  valid_565341 = validateParameter(valid_565341, JString, required = true,
                                 default = nil)
  if valid_565341 != nil:
    section.add "recoveryPlanName", valid_565341
  var valid_565342 = path.getOrDefault("subscriptionId")
  valid_565342 = validateParameter(valid_565342, JString, required = true,
                                 default = nil)
  if valid_565342 != nil:
    section.add "subscriptionId", valid_565342
  var valid_565343 = path.getOrDefault("resourceGroupName")
  valid_565343 = validateParameter(valid_565343, JString, required = true,
                                 default = nil)
  if valid_565343 != nil:
    section.add "resourceGroupName", valid_565343
  var valid_565344 = path.getOrDefault("resourceName")
  valid_565344 = validateParameter(valid_565344, JString, required = true,
                                 default = nil)
  if valid_565344 != nil:
    section.add "resourceName", valid_565344
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565345 = query.getOrDefault("api-version")
  valid_565345 = validateParameter(valid_565345, JString, required = true,
                                 default = nil)
  if valid_565345 != nil:
    section.add "api-version", valid_565345
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565346: Call_ReplicationRecoveryPlansReprotect_565338;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to reprotect(reverse replicate) a recovery plan.
  ## 
  let valid = call_565346.validator(path, query, header, formData, body)
  let scheme = call_565346.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565346.url(scheme.get, call_565346.host, call_565346.base,
                         call_565346.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565346, url, valid)

proc call*(call_565347: Call_ReplicationRecoveryPlansReprotect_565338;
          recoveryPlanName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## replicationRecoveryPlansReprotect
  ## The operation to reprotect(reverse replicate) a recovery plan.
  ##   recoveryPlanName: string (required)
  ##                   : Recovery plan name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565348 = newJObject()
  var query_565349 = newJObject()
  add(path_565348, "recoveryPlanName", newJString(recoveryPlanName))
  add(query_565349, "api-version", newJString(apiVersion))
  add(path_565348, "subscriptionId", newJString(subscriptionId))
  add(path_565348, "resourceGroupName", newJString(resourceGroupName))
  add(path_565348, "resourceName", newJString(resourceName))
  result = call_565347.call(path_565348, query_565349, nil, nil, nil)

var replicationRecoveryPlansReprotect* = Call_ReplicationRecoveryPlansReprotect_565338(
    name: "replicationRecoveryPlansReprotect", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/reProtect",
    validator: validate_ReplicationRecoveryPlansReprotect_565339, base: "",
    url: url_ReplicationRecoveryPlansReprotect_565340, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansTestFailover_565350 = ref object of OpenApiRestCall_563564
proc url_ReplicationRecoveryPlansTestFailover_565352(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "recoveryPlanName" in path,
        "`recoveryPlanName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationRecoveryPlans/"),
               (kind: VariableSegment, value: "recoveryPlanName"),
               (kind: ConstantSegment, value: "/testFailover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationRecoveryPlansTestFailover_565351(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to start the test failover of a recovery plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   recoveryPlanName: JString (required)
  ##                   : Recovery plan name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `recoveryPlanName` field"
  var valid_565353 = path.getOrDefault("recoveryPlanName")
  valid_565353 = validateParameter(valid_565353, JString, required = true,
                                 default = nil)
  if valid_565353 != nil:
    section.add "recoveryPlanName", valid_565353
  var valid_565354 = path.getOrDefault("subscriptionId")
  valid_565354 = validateParameter(valid_565354, JString, required = true,
                                 default = nil)
  if valid_565354 != nil:
    section.add "subscriptionId", valid_565354
  var valid_565355 = path.getOrDefault("resourceGroupName")
  valid_565355 = validateParameter(valid_565355, JString, required = true,
                                 default = nil)
  if valid_565355 != nil:
    section.add "resourceGroupName", valid_565355
  var valid_565356 = path.getOrDefault("resourceName")
  valid_565356 = validateParameter(valid_565356, JString, required = true,
                                 default = nil)
  if valid_565356 != nil:
    section.add "resourceName", valid_565356
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565357 = query.getOrDefault("api-version")
  valid_565357 = validateParameter(valid_565357, JString, required = true,
                                 default = nil)
  if valid_565357 != nil:
    section.add "api-version", valid_565357
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Failover input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565359: Call_ReplicationRecoveryPlansTestFailover_565350;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to start the test failover of a recovery plan.
  ## 
  let valid = call_565359.validator(path, query, header, formData, body)
  let scheme = call_565359.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565359.url(scheme.get, call_565359.host, call_565359.base,
                         call_565359.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565359, url, valid)

proc call*(call_565360: Call_ReplicationRecoveryPlansTestFailover_565350;
          recoveryPlanName: string; apiVersion: string; input: JsonNode;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## replicationRecoveryPlansTestFailover
  ## The operation to start the test failover of a recovery plan.
  ##   recoveryPlanName: string (required)
  ##                   : Recovery plan name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   input: JObject (required)
  ##        : Failover input.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565361 = newJObject()
  var query_565362 = newJObject()
  var body_565363 = newJObject()
  add(path_565361, "recoveryPlanName", newJString(recoveryPlanName))
  add(query_565362, "api-version", newJString(apiVersion))
  if input != nil:
    body_565363 = input
  add(path_565361, "subscriptionId", newJString(subscriptionId))
  add(path_565361, "resourceGroupName", newJString(resourceGroupName))
  add(path_565361, "resourceName", newJString(resourceName))
  result = call_565360.call(path_565361, query_565362, nil, nil, body_565363)

var replicationRecoveryPlansTestFailover* = Call_ReplicationRecoveryPlansTestFailover_565350(
    name: "replicationRecoveryPlansTestFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/testFailover",
    validator: validate_ReplicationRecoveryPlansTestFailover_565351, base: "",
    url: url_ReplicationRecoveryPlansTestFailover_565352, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansTestFailoverCleanup_565364 = ref object of OpenApiRestCall_563564
proc url_ReplicationRecoveryPlansTestFailoverCleanup_565366(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "recoveryPlanName" in path,
        "`recoveryPlanName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationRecoveryPlans/"),
               (kind: VariableSegment, value: "recoveryPlanName"),
               (kind: ConstantSegment, value: "/testFailoverCleanup")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationRecoveryPlansTestFailoverCleanup_565365(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to cleanup test failover of a recovery plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   recoveryPlanName: JString (required)
  ##                   : Recovery plan name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `recoveryPlanName` field"
  var valid_565367 = path.getOrDefault("recoveryPlanName")
  valid_565367 = validateParameter(valid_565367, JString, required = true,
                                 default = nil)
  if valid_565367 != nil:
    section.add "recoveryPlanName", valid_565367
  var valid_565368 = path.getOrDefault("subscriptionId")
  valid_565368 = validateParameter(valid_565368, JString, required = true,
                                 default = nil)
  if valid_565368 != nil:
    section.add "subscriptionId", valid_565368
  var valid_565369 = path.getOrDefault("resourceGroupName")
  valid_565369 = validateParameter(valid_565369, JString, required = true,
                                 default = nil)
  if valid_565369 != nil:
    section.add "resourceGroupName", valid_565369
  var valid_565370 = path.getOrDefault("resourceName")
  valid_565370 = validateParameter(valid_565370, JString, required = true,
                                 default = nil)
  if valid_565370 != nil:
    section.add "resourceName", valid_565370
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565371 = query.getOrDefault("api-version")
  valid_565371 = validateParameter(valid_565371, JString, required = true,
                                 default = nil)
  if valid_565371 != nil:
    section.add "api-version", valid_565371
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Test failover cleanup input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565373: Call_ReplicationRecoveryPlansTestFailoverCleanup_565364;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to cleanup test failover of a recovery plan.
  ## 
  let valid = call_565373.validator(path, query, header, formData, body)
  let scheme = call_565373.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565373.url(scheme.get, call_565373.host, call_565373.base,
                         call_565373.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565373, url, valid)

proc call*(call_565374: Call_ReplicationRecoveryPlansTestFailoverCleanup_565364;
          recoveryPlanName: string; apiVersion: string; input: JsonNode;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## replicationRecoveryPlansTestFailoverCleanup
  ## The operation to cleanup test failover of a recovery plan.
  ##   recoveryPlanName: string (required)
  ##                   : Recovery plan name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   input: JObject (required)
  ##        : Test failover cleanup input.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565375 = newJObject()
  var query_565376 = newJObject()
  var body_565377 = newJObject()
  add(path_565375, "recoveryPlanName", newJString(recoveryPlanName))
  add(query_565376, "api-version", newJString(apiVersion))
  if input != nil:
    body_565377 = input
  add(path_565375, "subscriptionId", newJString(subscriptionId))
  add(path_565375, "resourceGroupName", newJString(resourceGroupName))
  add(path_565375, "resourceName", newJString(resourceName))
  result = call_565374.call(path_565375, query_565376, nil, nil, body_565377)

var replicationRecoveryPlansTestFailoverCleanup* = Call_ReplicationRecoveryPlansTestFailoverCleanup_565364(
    name: "replicationRecoveryPlansTestFailoverCleanup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/testFailoverCleanup",
    validator: validate_ReplicationRecoveryPlansTestFailoverCleanup_565365,
    base: "", url: url_ReplicationRecoveryPlansTestFailoverCleanup_565366,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansUnplannedFailover_565378 = ref object of OpenApiRestCall_563564
proc url_ReplicationRecoveryPlansUnplannedFailover_565380(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "recoveryPlanName" in path,
        "`recoveryPlanName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationRecoveryPlans/"),
               (kind: VariableSegment, value: "recoveryPlanName"),
               (kind: ConstantSegment, value: "/unplannedFailover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationRecoveryPlansUnplannedFailover_565379(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to start the failover of a recovery plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   recoveryPlanName: JString (required)
  ##                   : Recovery plan name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `recoveryPlanName` field"
  var valid_565381 = path.getOrDefault("recoveryPlanName")
  valid_565381 = validateParameter(valid_565381, JString, required = true,
                                 default = nil)
  if valid_565381 != nil:
    section.add "recoveryPlanName", valid_565381
  var valid_565382 = path.getOrDefault("subscriptionId")
  valid_565382 = validateParameter(valid_565382, JString, required = true,
                                 default = nil)
  if valid_565382 != nil:
    section.add "subscriptionId", valid_565382
  var valid_565383 = path.getOrDefault("resourceGroupName")
  valid_565383 = validateParameter(valid_565383, JString, required = true,
                                 default = nil)
  if valid_565383 != nil:
    section.add "resourceGroupName", valid_565383
  var valid_565384 = path.getOrDefault("resourceName")
  valid_565384 = validateParameter(valid_565384, JString, required = true,
                                 default = nil)
  if valid_565384 != nil:
    section.add "resourceName", valid_565384
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565385 = query.getOrDefault("api-version")
  valid_565385 = validateParameter(valid_565385, JString, required = true,
                                 default = nil)
  if valid_565385 != nil:
    section.add "api-version", valid_565385
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Failover input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565387: Call_ReplicationRecoveryPlansUnplannedFailover_565378;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to start the failover of a recovery plan.
  ## 
  let valid = call_565387.validator(path, query, header, formData, body)
  let scheme = call_565387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565387.url(scheme.get, call_565387.host, call_565387.base,
                         call_565387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565387, url, valid)

proc call*(call_565388: Call_ReplicationRecoveryPlansUnplannedFailover_565378;
          recoveryPlanName: string; apiVersion: string; input: JsonNode;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## replicationRecoveryPlansUnplannedFailover
  ## The operation to start the failover of a recovery plan.
  ##   recoveryPlanName: string (required)
  ##                   : Recovery plan name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   input: JObject (required)
  ##        : Failover input.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565389 = newJObject()
  var query_565390 = newJObject()
  var body_565391 = newJObject()
  add(path_565389, "recoveryPlanName", newJString(recoveryPlanName))
  add(query_565390, "api-version", newJString(apiVersion))
  if input != nil:
    body_565391 = input
  add(path_565389, "subscriptionId", newJString(subscriptionId))
  add(path_565389, "resourceGroupName", newJString(resourceGroupName))
  add(path_565389, "resourceName", newJString(resourceName))
  result = call_565388.call(path_565389, query_565390, nil, nil, body_565391)

var replicationRecoveryPlansUnplannedFailover* = Call_ReplicationRecoveryPlansUnplannedFailover_565378(
    name: "replicationRecoveryPlansUnplannedFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/unplannedFailover",
    validator: validate_ReplicationRecoveryPlansUnplannedFailover_565379,
    base: "", url: url_ReplicationRecoveryPlansUnplannedFailover_565380,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersList_565392 = ref object of OpenApiRestCall_563564
proc url_ReplicationRecoveryServicesProvidersList_565394(protocol: Scheme;
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
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment, value: "/replicationRecoveryServicesProviders")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationRecoveryServicesProvidersList_565393(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the registered recovery services providers in the vault
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565395 = path.getOrDefault("subscriptionId")
  valid_565395 = validateParameter(valid_565395, JString, required = true,
                                 default = nil)
  if valid_565395 != nil:
    section.add "subscriptionId", valid_565395
  var valid_565396 = path.getOrDefault("resourceGroupName")
  valid_565396 = validateParameter(valid_565396, JString, required = true,
                                 default = nil)
  if valid_565396 != nil:
    section.add "resourceGroupName", valid_565396
  var valid_565397 = path.getOrDefault("resourceName")
  valid_565397 = validateParameter(valid_565397, JString, required = true,
                                 default = nil)
  if valid_565397 != nil:
    section.add "resourceName", valid_565397
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565398 = query.getOrDefault("api-version")
  valid_565398 = validateParameter(valid_565398, JString, required = true,
                                 default = nil)
  if valid_565398 != nil:
    section.add "api-version", valid_565398
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565399: Call_ReplicationRecoveryServicesProvidersList_565392;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the registered recovery services providers in the vault
  ## 
  let valid = call_565399.validator(path, query, header, formData, body)
  let scheme = call_565399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565399.url(scheme.get, call_565399.host, call_565399.base,
                         call_565399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565399, url, valid)

proc call*(call_565400: Call_ReplicationRecoveryServicesProvidersList_565392;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## replicationRecoveryServicesProvidersList
  ## Lists the registered recovery services providers in the vault
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565401 = newJObject()
  var query_565402 = newJObject()
  add(query_565402, "api-version", newJString(apiVersion))
  add(path_565401, "subscriptionId", newJString(subscriptionId))
  add(path_565401, "resourceGroupName", newJString(resourceGroupName))
  add(path_565401, "resourceName", newJString(resourceName))
  result = call_565400.call(path_565401, query_565402, nil, nil, nil)

var replicationRecoveryServicesProvidersList* = Call_ReplicationRecoveryServicesProvidersList_565392(
    name: "replicationRecoveryServicesProvidersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryServicesProviders",
    validator: validate_ReplicationRecoveryServicesProvidersList_565393, base: "",
    url: url_ReplicationRecoveryServicesProvidersList_565394,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsList_565403 = ref object of OpenApiRestCall_563564
proc url_ReplicationStorageClassificationMappingsList_565405(protocol: Scheme;
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
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment, value: "/replicationStorageClassificationMappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationStorageClassificationMappingsList_565404(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the storage classification mappings in the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565406 = path.getOrDefault("subscriptionId")
  valid_565406 = validateParameter(valid_565406, JString, required = true,
                                 default = nil)
  if valid_565406 != nil:
    section.add "subscriptionId", valid_565406
  var valid_565407 = path.getOrDefault("resourceGroupName")
  valid_565407 = validateParameter(valid_565407, JString, required = true,
                                 default = nil)
  if valid_565407 != nil:
    section.add "resourceGroupName", valid_565407
  var valid_565408 = path.getOrDefault("resourceName")
  valid_565408 = validateParameter(valid_565408, JString, required = true,
                                 default = nil)
  if valid_565408 != nil:
    section.add "resourceName", valid_565408
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565409 = query.getOrDefault("api-version")
  valid_565409 = validateParameter(valid_565409, JString, required = true,
                                 default = nil)
  if valid_565409 != nil:
    section.add "api-version", valid_565409
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565410: Call_ReplicationStorageClassificationMappingsList_565403;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the storage classification mappings in the vault.
  ## 
  let valid = call_565410.validator(path, query, header, formData, body)
  let scheme = call_565410.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565410.url(scheme.get, call_565410.host, call_565410.base,
                         call_565410.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565410, url, valid)

proc call*(call_565411: Call_ReplicationStorageClassificationMappingsList_565403;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## replicationStorageClassificationMappingsList
  ## Lists the storage classification mappings in the vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565412 = newJObject()
  var query_565413 = newJObject()
  add(query_565413, "api-version", newJString(apiVersion))
  add(path_565412, "subscriptionId", newJString(subscriptionId))
  add(path_565412, "resourceGroupName", newJString(resourceGroupName))
  add(path_565412, "resourceName", newJString(resourceName))
  result = call_565411.call(path_565412, query_565413, nil, nil, nil)

var replicationStorageClassificationMappingsList* = Call_ReplicationStorageClassificationMappingsList_565403(
    name: "replicationStorageClassificationMappingsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationStorageClassificationMappings",
    validator: validate_ReplicationStorageClassificationMappingsList_565404,
    base: "", url: url_ReplicationStorageClassificationMappingsList_565405,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationsList_565414 = ref object of OpenApiRestCall_563564
proc url_ReplicationStorageClassificationsList_565416(protocol: Scheme;
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
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment, value: "/replicationStorageClassifications")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationStorageClassificationsList_565415(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the storage classifications in the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565417 = path.getOrDefault("subscriptionId")
  valid_565417 = validateParameter(valid_565417, JString, required = true,
                                 default = nil)
  if valid_565417 != nil:
    section.add "subscriptionId", valid_565417
  var valid_565418 = path.getOrDefault("resourceGroupName")
  valid_565418 = validateParameter(valid_565418, JString, required = true,
                                 default = nil)
  if valid_565418 != nil:
    section.add "resourceGroupName", valid_565418
  var valid_565419 = path.getOrDefault("resourceName")
  valid_565419 = validateParameter(valid_565419, JString, required = true,
                                 default = nil)
  if valid_565419 != nil:
    section.add "resourceName", valid_565419
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565420 = query.getOrDefault("api-version")
  valid_565420 = validateParameter(valid_565420, JString, required = true,
                                 default = nil)
  if valid_565420 != nil:
    section.add "api-version", valid_565420
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565421: Call_ReplicationStorageClassificationsList_565414;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the storage classifications in the vault.
  ## 
  let valid = call_565421.validator(path, query, header, formData, body)
  let scheme = call_565421.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565421.url(scheme.get, call_565421.host, call_565421.base,
                         call_565421.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565421, url, valid)

proc call*(call_565422: Call_ReplicationStorageClassificationsList_565414;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## replicationStorageClassificationsList
  ## Lists the storage classifications in the vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565423 = newJObject()
  var query_565424 = newJObject()
  add(query_565424, "api-version", newJString(apiVersion))
  add(path_565423, "subscriptionId", newJString(subscriptionId))
  add(path_565423, "resourceGroupName", newJString(resourceGroupName))
  add(path_565423, "resourceName", newJString(resourceName))
  result = call_565422.call(path_565423, query_565424, nil, nil, nil)

var replicationStorageClassificationsList* = Call_ReplicationStorageClassificationsList_565414(
    name: "replicationStorageClassificationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationStorageClassifications",
    validator: validate_ReplicationStorageClassificationsList_565415, base: "",
    url: url_ReplicationStorageClassificationsList_565416, schemes: {Scheme.Https})
type
  Call_ReplicationVaultHealthGet_565425 = ref object of OpenApiRestCall_563564
proc url_ReplicationVaultHealthGet_565427(protocol: Scheme; host: string;
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
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationVaultHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationVaultHealthGet_565426(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the health details of the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565428 = path.getOrDefault("subscriptionId")
  valid_565428 = validateParameter(valid_565428, JString, required = true,
                                 default = nil)
  if valid_565428 != nil:
    section.add "subscriptionId", valid_565428
  var valid_565429 = path.getOrDefault("resourceGroupName")
  valid_565429 = validateParameter(valid_565429, JString, required = true,
                                 default = nil)
  if valid_565429 != nil:
    section.add "resourceGroupName", valid_565429
  var valid_565430 = path.getOrDefault("resourceName")
  valid_565430 = validateParameter(valid_565430, JString, required = true,
                                 default = nil)
  if valid_565430 != nil:
    section.add "resourceName", valid_565430
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565431 = query.getOrDefault("api-version")
  valid_565431 = validateParameter(valid_565431, JString, required = true,
                                 default = nil)
  if valid_565431 != nil:
    section.add "api-version", valid_565431
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565432: Call_ReplicationVaultHealthGet_565425; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health details of the vault.
  ## 
  let valid = call_565432.validator(path, query, header, formData, body)
  let scheme = call_565432.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565432.url(scheme.get, call_565432.host, call_565432.base,
                         call_565432.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565432, url, valid)

proc call*(call_565433: Call_ReplicationVaultHealthGet_565425; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## replicationVaultHealthGet
  ## Gets the health details of the vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565434 = newJObject()
  var query_565435 = newJObject()
  add(query_565435, "api-version", newJString(apiVersion))
  add(path_565434, "subscriptionId", newJString(subscriptionId))
  add(path_565434, "resourceGroupName", newJString(resourceGroupName))
  add(path_565434, "resourceName", newJString(resourceName))
  result = call_565433.call(path_565434, query_565435, nil, nil, nil)

var replicationVaultHealthGet* = Call_ReplicationVaultHealthGet_565425(
    name: "replicationVaultHealthGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationVaultHealth",
    validator: validate_ReplicationVaultHealthGet_565426, base: "",
    url: url_ReplicationVaultHealthGet_565427, schemes: {Scheme.Https})
type
  Call_ReplicationvCentersList_565436 = ref object of OpenApiRestCall_563564
proc url_ReplicationvCentersList_565438(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationvCenters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationvCentersList_565437(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the vCenter servers registered in the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565439 = path.getOrDefault("subscriptionId")
  valid_565439 = validateParameter(valid_565439, JString, required = true,
                                 default = nil)
  if valid_565439 != nil:
    section.add "subscriptionId", valid_565439
  var valid_565440 = path.getOrDefault("resourceGroupName")
  valid_565440 = validateParameter(valid_565440, JString, required = true,
                                 default = nil)
  if valid_565440 != nil:
    section.add "resourceGroupName", valid_565440
  var valid_565441 = path.getOrDefault("resourceName")
  valid_565441 = validateParameter(valid_565441, JString, required = true,
                                 default = nil)
  if valid_565441 != nil:
    section.add "resourceName", valid_565441
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565442 = query.getOrDefault("api-version")
  valid_565442 = validateParameter(valid_565442, JString, required = true,
                                 default = nil)
  if valid_565442 != nil:
    section.add "api-version", valid_565442
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565443: Call_ReplicationvCentersList_565436; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the vCenter servers registered in the vault.
  ## 
  let valid = call_565443.validator(path, query, header, formData, body)
  let scheme = call_565443.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565443.url(scheme.get, call_565443.host, call_565443.base,
                         call_565443.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565443, url, valid)

proc call*(call_565444: Call_ReplicationvCentersList_565436; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## replicationvCentersList
  ## Lists the vCenter servers registered in the vault.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565445 = newJObject()
  var query_565446 = newJObject()
  add(query_565446, "api-version", newJString(apiVersion))
  add(path_565445, "subscriptionId", newJString(subscriptionId))
  add(path_565445, "resourceGroupName", newJString(resourceGroupName))
  add(path_565445, "resourceName", newJString(resourceName))
  result = call_565444.call(path_565445, query_565446, nil, nil, nil)

var replicationvCentersList* = Call_ReplicationvCentersList_565436(
    name: "replicationvCentersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationvCenters",
    validator: validate_ReplicationvCentersList_565437, base: "",
    url: url_ReplicationvCentersList_565438, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
