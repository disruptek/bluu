
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: SiteRecoveryManagementClient
## version: 2018-01-10
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

  OpenApiRestCall_563566 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563566](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563566): Option[Scheme] {.used.} =
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
  Call_OperationsList_563788 = ref object of OpenApiRestCall_563566
proc url_OperationsList_563790(protocol: Scheme; host: string; base: string;
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

proc validate_OperationsList_563789(path: JsonNode; query: JsonNode;
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
  var valid_563965 = path.getOrDefault("subscriptionId")
  valid_563965 = validateParameter(valid_563965, JString, required = true,
                                 default = nil)
  if valid_563965 != nil:
    section.add "subscriptionId", valid_563965
  var valid_563966 = path.getOrDefault("resourceGroupName")
  valid_563966 = validateParameter(valid_563966, JString, required = true,
                                 default = nil)
  if valid_563966 != nil:
    section.add "resourceGroupName", valid_563966
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563967 = query.getOrDefault("api-version")
  valid_563967 = validateParameter(valid_563967, JString, required = true,
                                 default = nil)
  if valid_563967 != nil:
    section.add "api-version", valid_563967
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563990: Call_OperationsList_563788; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Operation to return the list of available operations.
  ## 
  let valid = call_563990.validator(path, query, header, formData, body)
  let scheme = call_563990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563990.url(scheme.get, call_563990.host, call_563990.base,
                         call_563990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563990, url, valid)

proc call*(call_564061: Call_OperationsList_563788; apiVersion: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## operationsList
  ## Operation to return the list of available operations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  var path_564062 = newJObject()
  var query_564064 = newJObject()
  add(query_564064, "api-version", newJString(apiVersion))
  add(path_564062, "subscriptionId", newJString(subscriptionId))
  add(path_564062, "resourceGroupName", newJString(resourceGroupName))
  result = call_564061.call(path_564062, query_564064, nil, nil, nil)

var operationsList* = Call_OperationsList_563788(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/operations",
    validator: validate_OperationsList_563789, base: "", url: url_OperationsList_563790,
    schemes: {Scheme.Https})
type
  Call_ReplicationAlertSettingsList_564103 = ref object of OpenApiRestCall_563566
proc url_ReplicationAlertSettingsList_564105(protocol: Scheme; host: string;
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

proc validate_ReplicationAlertSettingsList_564104(path: JsonNode; query: JsonNode;
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
  var valid_564106 = path.getOrDefault("subscriptionId")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "subscriptionId", valid_564106
  var valid_564107 = path.getOrDefault("resourceGroupName")
  valid_564107 = validateParameter(valid_564107, JString, required = true,
                                 default = nil)
  if valid_564107 != nil:
    section.add "resourceGroupName", valid_564107
  var valid_564108 = path.getOrDefault("resourceName")
  valid_564108 = validateParameter(valid_564108, JString, required = true,
                                 default = nil)
  if valid_564108 != nil:
    section.add "resourceName", valid_564108
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564109 = query.getOrDefault("api-version")
  valid_564109 = validateParameter(valid_564109, JString, required = true,
                                 default = nil)
  if valid_564109 != nil:
    section.add "api-version", valid_564109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564110: Call_ReplicationAlertSettingsList_564103; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of email notification(alert) configurations for the vault.
  ## 
  let valid = call_564110.validator(path, query, header, formData, body)
  let scheme = call_564110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564110.url(scheme.get, call_564110.host, call_564110.base,
                         call_564110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564110, url, valid)

proc call*(call_564111: Call_ReplicationAlertSettingsList_564103;
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
  var path_564112 = newJObject()
  var query_564113 = newJObject()
  add(query_564113, "api-version", newJString(apiVersion))
  add(path_564112, "subscriptionId", newJString(subscriptionId))
  add(path_564112, "resourceGroupName", newJString(resourceGroupName))
  add(path_564112, "resourceName", newJString(resourceName))
  result = call_564111.call(path_564112, query_564113, nil, nil, nil)

var replicationAlertSettingsList* = Call_ReplicationAlertSettingsList_564103(
    name: "replicationAlertSettingsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationAlertSettings",
    validator: validate_ReplicationAlertSettingsList_564104, base: "",
    url: url_ReplicationAlertSettingsList_564105, schemes: {Scheme.Https})
type
  Call_ReplicationAlertSettingsCreate_564126 = ref object of OpenApiRestCall_563566
proc url_ReplicationAlertSettingsCreate_564128(protocol: Scheme; host: string;
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

proc validate_ReplicationAlertSettingsCreate_564127(path: JsonNode;
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
  var valid_564129 = path.getOrDefault("alertSettingName")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "alertSettingName", valid_564129
  var valid_564130 = path.getOrDefault("subscriptionId")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "subscriptionId", valid_564130
  var valid_564131 = path.getOrDefault("resourceGroupName")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "resourceGroupName", valid_564131
  var valid_564132 = path.getOrDefault("resourceName")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "resourceName", valid_564132
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564133 = query.getOrDefault("api-version")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "api-version", valid_564133
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

proc call*(call_564135: Call_ReplicationAlertSettingsCreate_564126; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an email notification(alert) configuration.
  ## 
  let valid = call_564135.validator(path, query, header, formData, body)
  let scheme = call_564135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564135.url(scheme.get, call_564135.host, call_564135.base,
                         call_564135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564135, url, valid)

proc call*(call_564136: Call_ReplicationAlertSettingsCreate_564126;
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
  var path_564137 = newJObject()
  var query_564138 = newJObject()
  var body_564139 = newJObject()
  add(query_564138, "api-version", newJString(apiVersion))
  add(path_564137, "alertSettingName", newJString(alertSettingName))
  add(path_564137, "subscriptionId", newJString(subscriptionId))
  add(path_564137, "resourceGroupName", newJString(resourceGroupName))
  add(path_564137, "resourceName", newJString(resourceName))
  if request != nil:
    body_564139 = request
  result = call_564136.call(path_564137, query_564138, nil, nil, body_564139)

var replicationAlertSettingsCreate* = Call_ReplicationAlertSettingsCreate_564126(
    name: "replicationAlertSettingsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationAlertSettings/{alertSettingName}",
    validator: validate_ReplicationAlertSettingsCreate_564127, base: "",
    url: url_ReplicationAlertSettingsCreate_564128, schemes: {Scheme.Https})
type
  Call_ReplicationAlertSettingsGet_564114 = ref object of OpenApiRestCall_563566
proc url_ReplicationAlertSettingsGet_564116(protocol: Scheme; host: string;
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

proc validate_ReplicationAlertSettingsGet_564115(path: JsonNode; query: JsonNode;
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
  var valid_564117 = path.getOrDefault("alertSettingName")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "alertSettingName", valid_564117
  var valid_564118 = path.getOrDefault("subscriptionId")
  valid_564118 = validateParameter(valid_564118, JString, required = true,
                                 default = nil)
  if valid_564118 != nil:
    section.add "subscriptionId", valid_564118
  var valid_564119 = path.getOrDefault("resourceGroupName")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "resourceGroupName", valid_564119
  var valid_564120 = path.getOrDefault("resourceName")
  valid_564120 = validateParameter(valid_564120, JString, required = true,
                                 default = nil)
  if valid_564120 != nil:
    section.add "resourceName", valid_564120
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564121 = query.getOrDefault("api-version")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "api-version", valid_564121
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564122: Call_ReplicationAlertSettingsGet_564114; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the specified email notification(alert) configuration.
  ## 
  let valid = call_564122.validator(path, query, header, formData, body)
  let scheme = call_564122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564122.url(scheme.get, call_564122.host, call_564122.base,
                         call_564122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564122, url, valid)

proc call*(call_564123: Call_ReplicationAlertSettingsGet_564114;
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
  var path_564124 = newJObject()
  var query_564125 = newJObject()
  add(query_564125, "api-version", newJString(apiVersion))
  add(path_564124, "alertSettingName", newJString(alertSettingName))
  add(path_564124, "subscriptionId", newJString(subscriptionId))
  add(path_564124, "resourceGroupName", newJString(resourceGroupName))
  add(path_564124, "resourceName", newJString(resourceName))
  result = call_564123.call(path_564124, query_564125, nil, nil, nil)

var replicationAlertSettingsGet* = Call_ReplicationAlertSettingsGet_564114(
    name: "replicationAlertSettingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationAlertSettings/{alertSettingName}",
    validator: validate_ReplicationAlertSettingsGet_564115, base: "",
    url: url_ReplicationAlertSettingsGet_564116, schemes: {Scheme.Https})
type
  Call_ReplicationEventsList_564140 = ref object of OpenApiRestCall_563566
proc url_ReplicationEventsList_564142(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationEventsList_564141(path: JsonNode; query: JsonNode;
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
  var valid_564144 = path.getOrDefault("subscriptionId")
  valid_564144 = validateParameter(valid_564144, JString, required = true,
                                 default = nil)
  if valid_564144 != nil:
    section.add "subscriptionId", valid_564144
  var valid_564145 = path.getOrDefault("resourceGroupName")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "resourceGroupName", valid_564145
  var valid_564146 = path.getOrDefault("resourceName")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = nil)
  if valid_564146 != nil:
    section.add "resourceName", valid_564146
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564147 = query.getOrDefault("api-version")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "api-version", valid_564147
  var valid_564148 = query.getOrDefault("$filter")
  valid_564148 = validateParameter(valid_564148, JString, required = false,
                                 default = nil)
  if valid_564148 != nil:
    section.add "$filter", valid_564148
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564149: Call_ReplicationEventsList_564140; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of Azure Site Recovery events for the vault.
  ## 
  let valid = call_564149.validator(path, query, header, formData, body)
  let scheme = call_564149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564149.url(scheme.get, call_564149.host, call_564149.base,
                         call_564149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564149, url, valid)

proc call*(call_564150: Call_ReplicationEventsList_564140; apiVersion: string;
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
  var path_564151 = newJObject()
  var query_564152 = newJObject()
  add(query_564152, "api-version", newJString(apiVersion))
  add(path_564151, "subscriptionId", newJString(subscriptionId))
  add(path_564151, "resourceGroupName", newJString(resourceGroupName))
  add(query_564152, "$filter", newJString(Filter))
  add(path_564151, "resourceName", newJString(resourceName))
  result = call_564150.call(path_564151, query_564152, nil, nil, nil)

var replicationEventsList* = Call_ReplicationEventsList_564140(
    name: "replicationEventsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationEvents",
    validator: validate_ReplicationEventsList_564141, base: "",
    url: url_ReplicationEventsList_564142, schemes: {Scheme.Https})
type
  Call_ReplicationEventsGet_564153 = ref object of OpenApiRestCall_563566
proc url_ReplicationEventsGet_564155(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationEventsGet_564154(path: JsonNode; query: JsonNode;
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
  var valid_564156 = path.getOrDefault("subscriptionId")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = nil)
  if valid_564156 != nil:
    section.add "subscriptionId", valid_564156
  var valid_564157 = path.getOrDefault("resourceGroupName")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "resourceGroupName", valid_564157
  var valid_564158 = path.getOrDefault("resourceName")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = nil)
  if valid_564158 != nil:
    section.add "resourceName", valid_564158
  var valid_564159 = path.getOrDefault("eventName")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "eventName", valid_564159
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564160 = query.getOrDefault("api-version")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "api-version", valid_564160
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564161: Call_ReplicationEventsGet_564153; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to get the details of an Azure Site recovery event.
  ## 
  let valid = call_564161.validator(path, query, header, formData, body)
  let scheme = call_564161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564161.url(scheme.get, call_564161.host, call_564161.base,
                         call_564161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564161, url, valid)

proc call*(call_564162: Call_ReplicationEventsGet_564153; apiVersion: string;
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
  var path_564163 = newJObject()
  var query_564164 = newJObject()
  add(query_564164, "api-version", newJString(apiVersion))
  add(path_564163, "subscriptionId", newJString(subscriptionId))
  add(path_564163, "resourceGroupName", newJString(resourceGroupName))
  add(path_564163, "resourceName", newJString(resourceName))
  add(path_564163, "eventName", newJString(eventName))
  result = call_564162.call(path_564163, query_564164, nil, nil, nil)

var replicationEventsGet* = Call_ReplicationEventsGet_564153(
    name: "replicationEventsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationEvents/{eventName}",
    validator: validate_ReplicationEventsGet_564154, base: "",
    url: url_ReplicationEventsGet_564155, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsList_564165 = ref object of OpenApiRestCall_563566
proc url_ReplicationFabricsList_564167(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationFabricsList_564166(path: JsonNode; query: JsonNode;
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
  var valid_564168 = path.getOrDefault("subscriptionId")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "subscriptionId", valid_564168
  var valid_564169 = path.getOrDefault("resourceGroupName")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "resourceGroupName", valid_564169
  var valid_564170 = path.getOrDefault("resourceName")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "resourceName", valid_564170
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564171 = query.getOrDefault("api-version")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = nil)
  if valid_564171 != nil:
    section.add "api-version", valid_564171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564172: Call_ReplicationFabricsList_564165; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of the Azure Site Recovery fabrics in the vault.
  ## 
  let valid = call_564172.validator(path, query, header, formData, body)
  let scheme = call_564172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564172.url(scheme.get, call_564172.host, call_564172.base,
                         call_564172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564172, url, valid)

proc call*(call_564173: Call_ReplicationFabricsList_564165; apiVersion: string;
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
  var path_564174 = newJObject()
  var query_564175 = newJObject()
  add(query_564175, "api-version", newJString(apiVersion))
  add(path_564174, "subscriptionId", newJString(subscriptionId))
  add(path_564174, "resourceGroupName", newJString(resourceGroupName))
  add(path_564174, "resourceName", newJString(resourceName))
  result = call_564173.call(path_564174, query_564175, nil, nil, nil)

var replicationFabricsList* = Call_ReplicationFabricsList_564165(
    name: "replicationFabricsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics",
    validator: validate_ReplicationFabricsList_564166, base: "",
    url: url_ReplicationFabricsList_564167, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsCreate_564188 = ref object of OpenApiRestCall_563566
proc url_ReplicationFabricsCreate_564190(protocol: Scheme; host: string;
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

proc validate_ReplicationFabricsCreate_564189(path: JsonNode; query: JsonNode;
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
  var valid_564191 = path.getOrDefault("fabricName")
  valid_564191 = validateParameter(valid_564191, JString, required = true,
                                 default = nil)
  if valid_564191 != nil:
    section.add "fabricName", valid_564191
  var valid_564192 = path.getOrDefault("subscriptionId")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "subscriptionId", valid_564192
  var valid_564193 = path.getOrDefault("resourceGroupName")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "resourceGroupName", valid_564193
  var valid_564194 = path.getOrDefault("resourceName")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "resourceName", valid_564194
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564195 = query.getOrDefault("api-version")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "api-version", valid_564195
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

proc call*(call_564197: Call_ReplicationFabricsCreate_564188; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create an Azure Site Recovery fabric (for e.g. Hyper-V site)
  ## 
  let valid = call_564197.validator(path, query, header, formData, body)
  let scheme = call_564197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564197.url(scheme.get, call_564197.host, call_564197.base,
                         call_564197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564197, url, valid)

proc call*(call_564198: Call_ReplicationFabricsCreate_564188; apiVersion: string;
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
  var path_564199 = newJObject()
  var query_564200 = newJObject()
  var body_564201 = newJObject()
  add(query_564200, "api-version", newJString(apiVersion))
  if input != nil:
    body_564201 = input
  add(path_564199, "fabricName", newJString(fabricName))
  add(path_564199, "subscriptionId", newJString(subscriptionId))
  add(path_564199, "resourceGroupName", newJString(resourceGroupName))
  add(path_564199, "resourceName", newJString(resourceName))
  result = call_564198.call(path_564199, query_564200, nil, nil, body_564201)

var replicationFabricsCreate* = Call_ReplicationFabricsCreate_564188(
    name: "replicationFabricsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}",
    validator: validate_ReplicationFabricsCreate_564189, base: "",
    url: url_ReplicationFabricsCreate_564190, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsGet_564176 = ref object of OpenApiRestCall_563566
proc url_ReplicationFabricsGet_564178(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationFabricsGet_564177(path: JsonNode; query: JsonNode;
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
  var valid_564179 = path.getOrDefault("fabricName")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "fabricName", valid_564179
  var valid_564180 = path.getOrDefault("subscriptionId")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "subscriptionId", valid_564180
  var valid_564181 = path.getOrDefault("resourceGroupName")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "resourceGroupName", valid_564181
  var valid_564182 = path.getOrDefault("resourceName")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "resourceName", valid_564182
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564183 = query.getOrDefault("api-version")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "api-version", valid_564183
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564184: Call_ReplicationFabricsGet_564176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of an Azure Site Recovery fabric.
  ## 
  let valid = call_564184.validator(path, query, header, formData, body)
  let scheme = call_564184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564184.url(scheme.get, call_564184.host, call_564184.base,
                         call_564184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564184, url, valid)

proc call*(call_564185: Call_ReplicationFabricsGet_564176; apiVersion: string;
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
  var path_564186 = newJObject()
  var query_564187 = newJObject()
  add(query_564187, "api-version", newJString(apiVersion))
  add(path_564186, "fabricName", newJString(fabricName))
  add(path_564186, "subscriptionId", newJString(subscriptionId))
  add(path_564186, "resourceGroupName", newJString(resourceGroupName))
  add(path_564186, "resourceName", newJString(resourceName))
  result = call_564185.call(path_564186, query_564187, nil, nil, nil)

var replicationFabricsGet* = Call_ReplicationFabricsGet_564176(
    name: "replicationFabricsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}",
    validator: validate_ReplicationFabricsGet_564177, base: "",
    url: url_ReplicationFabricsGet_564178, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsPurge_564202 = ref object of OpenApiRestCall_563566
proc url_ReplicationFabricsPurge_564204(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationFabricsPurge_564203(path: JsonNode; query: JsonNode;
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
  var valid_564205 = path.getOrDefault("fabricName")
  valid_564205 = validateParameter(valid_564205, JString, required = true,
                                 default = nil)
  if valid_564205 != nil:
    section.add "fabricName", valid_564205
  var valid_564206 = path.getOrDefault("subscriptionId")
  valid_564206 = validateParameter(valid_564206, JString, required = true,
                                 default = nil)
  if valid_564206 != nil:
    section.add "subscriptionId", valid_564206
  var valid_564207 = path.getOrDefault("resourceGroupName")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "resourceGroupName", valid_564207
  var valid_564208 = path.getOrDefault("resourceName")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "resourceName", valid_564208
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564209 = query.getOrDefault("api-version")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "api-version", valid_564209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564210: Call_ReplicationFabricsPurge_564202; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to purge(force delete) an Azure Site Recovery fabric.
  ## 
  let valid = call_564210.validator(path, query, header, formData, body)
  let scheme = call_564210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564210.url(scheme.get, call_564210.host, call_564210.base,
                         call_564210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564210, url, valid)

proc call*(call_564211: Call_ReplicationFabricsPurge_564202; apiVersion: string;
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
  var path_564212 = newJObject()
  var query_564213 = newJObject()
  add(query_564213, "api-version", newJString(apiVersion))
  add(path_564212, "fabricName", newJString(fabricName))
  add(path_564212, "subscriptionId", newJString(subscriptionId))
  add(path_564212, "resourceGroupName", newJString(resourceGroupName))
  add(path_564212, "resourceName", newJString(resourceName))
  result = call_564211.call(path_564212, query_564213, nil, nil, nil)

var replicationFabricsPurge* = Call_ReplicationFabricsPurge_564202(
    name: "replicationFabricsPurge", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}",
    validator: validate_ReplicationFabricsPurge_564203, base: "",
    url: url_ReplicationFabricsPurge_564204, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsCheckConsistency_564214 = ref object of OpenApiRestCall_563566
proc url_ReplicationFabricsCheckConsistency_564216(protocol: Scheme; host: string;
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

proc validate_ReplicationFabricsCheckConsistency_564215(path: JsonNode;
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
  var valid_564217 = path.getOrDefault("fabricName")
  valid_564217 = validateParameter(valid_564217, JString, required = true,
                                 default = nil)
  if valid_564217 != nil:
    section.add "fabricName", valid_564217
  var valid_564218 = path.getOrDefault("subscriptionId")
  valid_564218 = validateParameter(valid_564218, JString, required = true,
                                 default = nil)
  if valid_564218 != nil:
    section.add "subscriptionId", valid_564218
  var valid_564219 = path.getOrDefault("resourceGroupName")
  valid_564219 = validateParameter(valid_564219, JString, required = true,
                                 default = nil)
  if valid_564219 != nil:
    section.add "resourceGroupName", valid_564219
  var valid_564220 = path.getOrDefault("resourceName")
  valid_564220 = validateParameter(valid_564220, JString, required = true,
                                 default = nil)
  if valid_564220 != nil:
    section.add "resourceName", valid_564220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564221 = query.getOrDefault("api-version")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "api-version", valid_564221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564222: Call_ReplicationFabricsCheckConsistency_564214;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to perform a consistency check on the fabric.
  ## 
  let valid = call_564222.validator(path, query, header, formData, body)
  let scheme = call_564222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564222.url(scheme.get, call_564222.host, call_564222.base,
                         call_564222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564222, url, valid)

proc call*(call_564223: Call_ReplicationFabricsCheckConsistency_564214;
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
  var path_564224 = newJObject()
  var query_564225 = newJObject()
  add(query_564225, "api-version", newJString(apiVersion))
  add(path_564224, "fabricName", newJString(fabricName))
  add(path_564224, "subscriptionId", newJString(subscriptionId))
  add(path_564224, "resourceGroupName", newJString(resourceGroupName))
  add(path_564224, "resourceName", newJString(resourceName))
  result = call_564223.call(path_564224, query_564225, nil, nil, nil)

var replicationFabricsCheckConsistency* = Call_ReplicationFabricsCheckConsistency_564214(
    name: "replicationFabricsCheckConsistency", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/checkConsistency",
    validator: validate_ReplicationFabricsCheckConsistency_564215, base: "",
    url: url_ReplicationFabricsCheckConsistency_564216, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsMigrateToAad_564226 = ref object of OpenApiRestCall_563566
proc url_ReplicationFabricsMigrateToAad_564228(protocol: Scheme; host: string;
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

proc validate_ReplicationFabricsMigrateToAad_564227(path: JsonNode;
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
  var valid_564229 = path.getOrDefault("fabricName")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "fabricName", valid_564229
  var valid_564230 = path.getOrDefault("subscriptionId")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = nil)
  if valid_564230 != nil:
    section.add "subscriptionId", valid_564230
  var valid_564231 = path.getOrDefault("resourceGroupName")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = nil)
  if valid_564231 != nil:
    section.add "resourceGroupName", valid_564231
  var valid_564232 = path.getOrDefault("resourceName")
  valid_564232 = validateParameter(valid_564232, JString, required = true,
                                 default = nil)
  if valid_564232 != nil:
    section.add "resourceName", valid_564232
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564233 = query.getOrDefault("api-version")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "api-version", valid_564233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564234: Call_ReplicationFabricsMigrateToAad_564226; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to migrate an Azure Site Recovery fabric to AAD.
  ## 
  let valid = call_564234.validator(path, query, header, formData, body)
  let scheme = call_564234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564234.url(scheme.get, call_564234.host, call_564234.base,
                         call_564234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564234, url, valid)

proc call*(call_564235: Call_ReplicationFabricsMigrateToAad_564226;
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
  var path_564236 = newJObject()
  var query_564237 = newJObject()
  add(query_564237, "api-version", newJString(apiVersion))
  add(path_564236, "fabricName", newJString(fabricName))
  add(path_564236, "subscriptionId", newJString(subscriptionId))
  add(path_564236, "resourceGroupName", newJString(resourceGroupName))
  add(path_564236, "resourceName", newJString(resourceName))
  result = call_564235.call(path_564236, query_564237, nil, nil, nil)

var replicationFabricsMigrateToAad* = Call_ReplicationFabricsMigrateToAad_564226(
    name: "replicationFabricsMigrateToAad", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/migratetoaad",
    validator: validate_ReplicationFabricsMigrateToAad_564227, base: "",
    url: url_ReplicationFabricsMigrateToAad_564228, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsReassociateGateway_564238 = ref object of OpenApiRestCall_563566
proc url_ReplicationFabricsReassociateGateway_564240(protocol: Scheme;
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

proc validate_ReplicationFabricsReassociateGateway_564239(path: JsonNode;
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
  var valid_564241 = path.getOrDefault("fabricName")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = nil)
  if valid_564241 != nil:
    section.add "fabricName", valid_564241
  var valid_564242 = path.getOrDefault("subscriptionId")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "subscriptionId", valid_564242
  var valid_564243 = path.getOrDefault("resourceGroupName")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = nil)
  if valid_564243 != nil:
    section.add "resourceGroupName", valid_564243
  var valid_564244 = path.getOrDefault("resourceName")
  valid_564244 = validateParameter(valid_564244, JString, required = true,
                                 default = nil)
  if valid_564244 != nil:
    section.add "resourceName", valid_564244
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564245 = query.getOrDefault("api-version")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "api-version", valid_564245
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

proc call*(call_564247: Call_ReplicationFabricsReassociateGateway_564238;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to move replications from a process server to another process server.
  ## 
  let valid = call_564247.validator(path, query, header, formData, body)
  let scheme = call_564247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564247.url(scheme.get, call_564247.host, call_564247.base,
                         call_564247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564247, url, valid)

proc call*(call_564248: Call_ReplicationFabricsReassociateGateway_564238;
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
  var path_564249 = newJObject()
  var query_564250 = newJObject()
  var body_564251 = newJObject()
  add(query_564250, "api-version", newJString(apiVersion))
  if failoverProcessServerRequest != nil:
    body_564251 = failoverProcessServerRequest
  add(path_564249, "fabricName", newJString(fabricName))
  add(path_564249, "subscriptionId", newJString(subscriptionId))
  add(path_564249, "resourceGroupName", newJString(resourceGroupName))
  add(path_564249, "resourceName", newJString(resourceName))
  result = call_564248.call(path_564249, query_564250, nil, nil, body_564251)

var replicationFabricsReassociateGateway* = Call_ReplicationFabricsReassociateGateway_564238(
    name: "replicationFabricsReassociateGateway", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/reassociateGateway",
    validator: validate_ReplicationFabricsReassociateGateway_564239, base: "",
    url: url_ReplicationFabricsReassociateGateway_564240, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsDelete_564252 = ref object of OpenApiRestCall_563566
proc url_ReplicationFabricsDelete_564254(protocol: Scheme; host: string;
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

proc validate_ReplicationFabricsDelete_564253(path: JsonNode; query: JsonNode;
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
  var valid_564255 = path.getOrDefault("fabricName")
  valid_564255 = validateParameter(valid_564255, JString, required = true,
                                 default = nil)
  if valid_564255 != nil:
    section.add "fabricName", valid_564255
  var valid_564256 = path.getOrDefault("subscriptionId")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = nil)
  if valid_564256 != nil:
    section.add "subscriptionId", valid_564256
  var valid_564257 = path.getOrDefault("resourceGroupName")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = nil)
  if valid_564257 != nil:
    section.add "resourceGroupName", valid_564257
  var valid_564258 = path.getOrDefault("resourceName")
  valid_564258 = validateParameter(valid_564258, JString, required = true,
                                 default = nil)
  if valid_564258 != nil:
    section.add "resourceName", valid_564258
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564259 = query.getOrDefault("api-version")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = nil)
  if valid_564259 != nil:
    section.add "api-version", valid_564259
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564260: Call_ReplicationFabricsDelete_564252; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete or remove an Azure Site Recovery fabric.
  ## 
  let valid = call_564260.validator(path, query, header, formData, body)
  let scheme = call_564260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564260.url(scheme.get, call_564260.host, call_564260.base,
                         call_564260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564260, url, valid)

proc call*(call_564261: Call_ReplicationFabricsDelete_564252; apiVersion: string;
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
  var path_564262 = newJObject()
  var query_564263 = newJObject()
  add(query_564263, "api-version", newJString(apiVersion))
  add(path_564262, "fabricName", newJString(fabricName))
  add(path_564262, "subscriptionId", newJString(subscriptionId))
  add(path_564262, "resourceGroupName", newJString(resourceGroupName))
  add(path_564262, "resourceName", newJString(resourceName))
  result = call_564261.call(path_564262, query_564263, nil, nil, nil)

var replicationFabricsDelete* = Call_ReplicationFabricsDelete_564252(
    name: "replicationFabricsDelete", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/remove",
    validator: validate_ReplicationFabricsDelete_564253, base: "",
    url: url_ReplicationFabricsDelete_564254, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsRenewCertificate_564264 = ref object of OpenApiRestCall_563566
proc url_ReplicationFabricsRenewCertificate_564266(protocol: Scheme; host: string;
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

proc validate_ReplicationFabricsRenewCertificate_564265(path: JsonNode;
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
  var valid_564267 = path.getOrDefault("fabricName")
  valid_564267 = validateParameter(valid_564267, JString, required = true,
                                 default = nil)
  if valid_564267 != nil:
    section.add "fabricName", valid_564267
  var valid_564268 = path.getOrDefault("subscriptionId")
  valid_564268 = validateParameter(valid_564268, JString, required = true,
                                 default = nil)
  if valid_564268 != nil:
    section.add "subscriptionId", valid_564268
  var valid_564269 = path.getOrDefault("resourceGroupName")
  valid_564269 = validateParameter(valid_564269, JString, required = true,
                                 default = nil)
  if valid_564269 != nil:
    section.add "resourceGroupName", valid_564269
  var valid_564270 = path.getOrDefault("resourceName")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "resourceName", valid_564270
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564271 = query.getOrDefault("api-version")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "api-version", valid_564271
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

proc call*(call_564273: Call_ReplicationFabricsRenewCertificate_564264;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Renews the connection certificate for the ASR replication fabric.
  ## 
  let valid = call_564273.validator(path, query, header, formData, body)
  let scheme = call_564273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564273.url(scheme.get, call_564273.host, call_564273.base,
                         call_564273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564273, url, valid)

proc call*(call_564274: Call_ReplicationFabricsRenewCertificate_564264;
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
  var path_564275 = newJObject()
  var query_564276 = newJObject()
  var body_564277 = newJObject()
  add(query_564276, "api-version", newJString(apiVersion))
  if renewCertificate != nil:
    body_564277 = renewCertificate
  add(path_564275, "fabricName", newJString(fabricName))
  add(path_564275, "subscriptionId", newJString(subscriptionId))
  add(path_564275, "resourceGroupName", newJString(resourceGroupName))
  add(path_564275, "resourceName", newJString(resourceName))
  result = call_564274.call(path_564275, query_564276, nil, nil, body_564277)

var replicationFabricsRenewCertificate* = Call_ReplicationFabricsRenewCertificate_564264(
    name: "replicationFabricsRenewCertificate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/renewCertificate",
    validator: validate_ReplicationFabricsRenewCertificate_564265, base: "",
    url: url_ReplicationFabricsRenewCertificate_564266, schemes: {Scheme.Https})
type
  Call_ReplicationLogicalNetworksListByReplicationFabrics_564278 = ref object of OpenApiRestCall_563566
proc url_ReplicationLogicalNetworksListByReplicationFabrics_564280(
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

proc validate_ReplicationLogicalNetworksListByReplicationFabrics_564279(
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
  var valid_564281 = path.getOrDefault("fabricName")
  valid_564281 = validateParameter(valid_564281, JString, required = true,
                                 default = nil)
  if valid_564281 != nil:
    section.add "fabricName", valid_564281
  var valid_564282 = path.getOrDefault("subscriptionId")
  valid_564282 = validateParameter(valid_564282, JString, required = true,
                                 default = nil)
  if valid_564282 != nil:
    section.add "subscriptionId", valid_564282
  var valid_564283 = path.getOrDefault("resourceGroupName")
  valid_564283 = validateParameter(valid_564283, JString, required = true,
                                 default = nil)
  if valid_564283 != nil:
    section.add "resourceGroupName", valid_564283
  var valid_564284 = path.getOrDefault("resourceName")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = nil)
  if valid_564284 != nil:
    section.add "resourceName", valid_564284
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564285 = query.getOrDefault("api-version")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "api-version", valid_564285
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564286: Call_ReplicationLogicalNetworksListByReplicationFabrics_564278;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the logical networks of the Azure Site Recovery fabric
  ## 
  let valid = call_564286.validator(path, query, header, formData, body)
  let scheme = call_564286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564286.url(scheme.get, call_564286.host, call_564286.base,
                         call_564286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564286, url, valid)

proc call*(call_564287: Call_ReplicationLogicalNetworksListByReplicationFabrics_564278;
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
  var path_564288 = newJObject()
  var query_564289 = newJObject()
  add(query_564289, "api-version", newJString(apiVersion))
  add(path_564288, "fabricName", newJString(fabricName))
  add(path_564288, "subscriptionId", newJString(subscriptionId))
  add(path_564288, "resourceGroupName", newJString(resourceGroupName))
  add(path_564288, "resourceName", newJString(resourceName))
  result = call_564287.call(path_564288, query_564289, nil, nil, nil)

var replicationLogicalNetworksListByReplicationFabrics* = Call_ReplicationLogicalNetworksListByReplicationFabrics_564278(
    name: "replicationLogicalNetworksListByReplicationFabrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationLogicalNetworks",
    validator: validate_ReplicationLogicalNetworksListByReplicationFabrics_564279,
    base: "", url: url_ReplicationLogicalNetworksListByReplicationFabrics_564280,
    schemes: {Scheme.Https})
type
  Call_ReplicationLogicalNetworksGet_564290 = ref object of OpenApiRestCall_563566
proc url_ReplicationLogicalNetworksGet_564292(protocol: Scheme; host: string;
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

proc validate_ReplicationLogicalNetworksGet_564291(path: JsonNode; query: JsonNode;
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
  var valid_564293 = path.getOrDefault("logicalNetworkName")
  valid_564293 = validateParameter(valid_564293, JString, required = true,
                                 default = nil)
  if valid_564293 != nil:
    section.add "logicalNetworkName", valid_564293
  var valid_564294 = path.getOrDefault("fabricName")
  valid_564294 = validateParameter(valid_564294, JString, required = true,
                                 default = nil)
  if valid_564294 != nil:
    section.add "fabricName", valid_564294
  var valid_564295 = path.getOrDefault("subscriptionId")
  valid_564295 = validateParameter(valid_564295, JString, required = true,
                                 default = nil)
  if valid_564295 != nil:
    section.add "subscriptionId", valid_564295
  var valid_564296 = path.getOrDefault("resourceGroupName")
  valid_564296 = validateParameter(valid_564296, JString, required = true,
                                 default = nil)
  if valid_564296 != nil:
    section.add "resourceGroupName", valid_564296
  var valid_564297 = path.getOrDefault("resourceName")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = nil)
  if valid_564297 != nil:
    section.add "resourceName", valid_564297
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564298 = query.getOrDefault("api-version")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = nil)
  if valid_564298 != nil:
    section.add "api-version", valid_564298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564299: Call_ReplicationLogicalNetworksGet_564290; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a logical network.
  ## 
  let valid = call_564299.validator(path, query, header, formData, body)
  let scheme = call_564299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564299.url(scheme.get, call_564299.host, call_564299.base,
                         call_564299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564299, url, valid)

proc call*(call_564300: Call_ReplicationLogicalNetworksGet_564290;
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
  var path_564301 = newJObject()
  var query_564302 = newJObject()
  add(query_564302, "api-version", newJString(apiVersion))
  add(path_564301, "logicalNetworkName", newJString(logicalNetworkName))
  add(path_564301, "fabricName", newJString(fabricName))
  add(path_564301, "subscriptionId", newJString(subscriptionId))
  add(path_564301, "resourceGroupName", newJString(resourceGroupName))
  add(path_564301, "resourceName", newJString(resourceName))
  result = call_564300.call(path_564301, query_564302, nil, nil, nil)

var replicationLogicalNetworksGet* = Call_ReplicationLogicalNetworksGet_564290(
    name: "replicationLogicalNetworksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationLogicalNetworks/{logicalNetworkName}",
    validator: validate_ReplicationLogicalNetworksGet_564291, base: "",
    url: url_ReplicationLogicalNetworksGet_564292, schemes: {Scheme.Https})
type
  Call_ReplicationNetworksListByReplicationFabrics_564303 = ref object of OpenApiRestCall_563566
proc url_ReplicationNetworksListByReplicationFabrics_564305(protocol: Scheme;
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

proc validate_ReplicationNetworksListByReplicationFabrics_564304(path: JsonNode;
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
  var valid_564306 = path.getOrDefault("fabricName")
  valid_564306 = validateParameter(valid_564306, JString, required = true,
                                 default = nil)
  if valid_564306 != nil:
    section.add "fabricName", valid_564306
  var valid_564307 = path.getOrDefault("subscriptionId")
  valid_564307 = validateParameter(valid_564307, JString, required = true,
                                 default = nil)
  if valid_564307 != nil:
    section.add "subscriptionId", valid_564307
  var valid_564308 = path.getOrDefault("resourceGroupName")
  valid_564308 = validateParameter(valid_564308, JString, required = true,
                                 default = nil)
  if valid_564308 != nil:
    section.add "resourceGroupName", valid_564308
  var valid_564309 = path.getOrDefault("resourceName")
  valid_564309 = validateParameter(valid_564309, JString, required = true,
                                 default = nil)
  if valid_564309 != nil:
    section.add "resourceName", valid_564309
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564310 = query.getOrDefault("api-version")
  valid_564310 = validateParameter(valid_564310, JString, required = true,
                                 default = nil)
  if valid_564310 != nil:
    section.add "api-version", valid_564310
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564311: Call_ReplicationNetworksListByReplicationFabrics_564303;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the networks available for a fabric.
  ## 
  let valid = call_564311.validator(path, query, header, formData, body)
  let scheme = call_564311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564311.url(scheme.get, call_564311.host, call_564311.base,
                         call_564311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564311, url, valid)

proc call*(call_564312: Call_ReplicationNetworksListByReplicationFabrics_564303;
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
  var path_564313 = newJObject()
  var query_564314 = newJObject()
  add(query_564314, "api-version", newJString(apiVersion))
  add(path_564313, "fabricName", newJString(fabricName))
  add(path_564313, "subscriptionId", newJString(subscriptionId))
  add(path_564313, "resourceGroupName", newJString(resourceGroupName))
  add(path_564313, "resourceName", newJString(resourceName))
  result = call_564312.call(path_564313, query_564314, nil, nil, nil)

var replicationNetworksListByReplicationFabrics* = Call_ReplicationNetworksListByReplicationFabrics_564303(
    name: "replicationNetworksListByReplicationFabrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationNetworks",
    validator: validate_ReplicationNetworksListByReplicationFabrics_564304,
    base: "", url: url_ReplicationNetworksListByReplicationFabrics_564305,
    schemes: {Scheme.Https})
type
  Call_ReplicationNetworksGet_564315 = ref object of OpenApiRestCall_563566
proc url_ReplicationNetworksGet_564317(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationNetworksGet_564316(path: JsonNode; query: JsonNode;
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
  var valid_564318 = path.getOrDefault("networkName")
  valid_564318 = validateParameter(valid_564318, JString, required = true,
                                 default = nil)
  if valid_564318 != nil:
    section.add "networkName", valid_564318
  var valid_564319 = path.getOrDefault("fabricName")
  valid_564319 = validateParameter(valid_564319, JString, required = true,
                                 default = nil)
  if valid_564319 != nil:
    section.add "fabricName", valid_564319
  var valid_564320 = path.getOrDefault("subscriptionId")
  valid_564320 = validateParameter(valid_564320, JString, required = true,
                                 default = nil)
  if valid_564320 != nil:
    section.add "subscriptionId", valid_564320
  var valid_564321 = path.getOrDefault("resourceGroupName")
  valid_564321 = validateParameter(valid_564321, JString, required = true,
                                 default = nil)
  if valid_564321 != nil:
    section.add "resourceGroupName", valid_564321
  var valid_564322 = path.getOrDefault("resourceName")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "resourceName", valid_564322
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564323 = query.getOrDefault("api-version")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "api-version", valid_564323
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564324: Call_ReplicationNetworksGet_564315; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a network.
  ## 
  let valid = call_564324.validator(path, query, header, formData, body)
  let scheme = call_564324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564324.url(scheme.get, call_564324.host, call_564324.base,
                         call_564324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564324, url, valid)

proc call*(call_564325: Call_ReplicationNetworksGet_564315; apiVersion: string;
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
  var path_564326 = newJObject()
  var query_564327 = newJObject()
  add(query_564327, "api-version", newJString(apiVersion))
  add(path_564326, "networkName", newJString(networkName))
  add(path_564326, "fabricName", newJString(fabricName))
  add(path_564326, "subscriptionId", newJString(subscriptionId))
  add(path_564326, "resourceGroupName", newJString(resourceGroupName))
  add(path_564326, "resourceName", newJString(resourceName))
  result = call_564325.call(path_564326, query_564327, nil, nil, nil)

var replicationNetworksGet* = Call_ReplicationNetworksGet_564315(
    name: "replicationNetworksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationNetworks/{networkName}",
    validator: validate_ReplicationNetworksGet_564316, base: "",
    url: url_ReplicationNetworksGet_564317, schemes: {Scheme.Https})
type
  Call_ReplicationNetworkMappingsListByReplicationNetworks_564328 = ref object of OpenApiRestCall_563566
proc url_ReplicationNetworkMappingsListByReplicationNetworks_564330(
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

proc validate_ReplicationNetworkMappingsListByReplicationNetworks_564329(
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
  var valid_564331 = path.getOrDefault("networkName")
  valid_564331 = validateParameter(valid_564331, JString, required = true,
                                 default = nil)
  if valid_564331 != nil:
    section.add "networkName", valid_564331
  var valid_564332 = path.getOrDefault("fabricName")
  valid_564332 = validateParameter(valid_564332, JString, required = true,
                                 default = nil)
  if valid_564332 != nil:
    section.add "fabricName", valid_564332
  var valid_564333 = path.getOrDefault("subscriptionId")
  valid_564333 = validateParameter(valid_564333, JString, required = true,
                                 default = nil)
  if valid_564333 != nil:
    section.add "subscriptionId", valid_564333
  var valid_564334 = path.getOrDefault("resourceGroupName")
  valid_564334 = validateParameter(valid_564334, JString, required = true,
                                 default = nil)
  if valid_564334 != nil:
    section.add "resourceGroupName", valid_564334
  var valid_564335 = path.getOrDefault("resourceName")
  valid_564335 = validateParameter(valid_564335, JString, required = true,
                                 default = nil)
  if valid_564335 != nil:
    section.add "resourceName", valid_564335
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564336 = query.getOrDefault("api-version")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "api-version", valid_564336
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564337: Call_ReplicationNetworkMappingsListByReplicationNetworks_564328;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all ASR network mappings for the specified network.
  ## 
  let valid = call_564337.validator(path, query, header, formData, body)
  let scheme = call_564337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564337.url(scheme.get, call_564337.host, call_564337.base,
                         call_564337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564337, url, valid)

proc call*(call_564338: Call_ReplicationNetworkMappingsListByReplicationNetworks_564328;
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
  var path_564339 = newJObject()
  var query_564340 = newJObject()
  add(query_564340, "api-version", newJString(apiVersion))
  add(path_564339, "networkName", newJString(networkName))
  add(path_564339, "fabricName", newJString(fabricName))
  add(path_564339, "subscriptionId", newJString(subscriptionId))
  add(path_564339, "resourceGroupName", newJString(resourceGroupName))
  add(path_564339, "resourceName", newJString(resourceName))
  result = call_564338.call(path_564339, query_564340, nil, nil, nil)

var replicationNetworkMappingsListByReplicationNetworks* = Call_ReplicationNetworkMappingsListByReplicationNetworks_564328(
    name: "replicationNetworkMappingsListByReplicationNetworks",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationNetworks/{networkName}/replicationNetworkMappings",
    validator: validate_ReplicationNetworkMappingsListByReplicationNetworks_564329,
    base: "", url: url_ReplicationNetworkMappingsListByReplicationNetworks_564330,
    schemes: {Scheme.Https})
type
  Call_ReplicationNetworkMappingsCreate_564355 = ref object of OpenApiRestCall_563566
proc url_ReplicationNetworkMappingsCreate_564357(protocol: Scheme; host: string;
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

proc validate_ReplicationNetworkMappingsCreate_564356(path: JsonNode;
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
  var valid_564358 = path.getOrDefault("networkMappingName")
  valid_564358 = validateParameter(valid_564358, JString, required = true,
                                 default = nil)
  if valid_564358 != nil:
    section.add "networkMappingName", valid_564358
  var valid_564359 = path.getOrDefault("networkName")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = nil)
  if valid_564359 != nil:
    section.add "networkName", valid_564359
  var valid_564360 = path.getOrDefault("fabricName")
  valid_564360 = validateParameter(valid_564360, JString, required = true,
                                 default = nil)
  if valid_564360 != nil:
    section.add "fabricName", valid_564360
  var valid_564361 = path.getOrDefault("subscriptionId")
  valid_564361 = validateParameter(valid_564361, JString, required = true,
                                 default = nil)
  if valid_564361 != nil:
    section.add "subscriptionId", valid_564361
  var valid_564362 = path.getOrDefault("resourceGroupName")
  valid_564362 = validateParameter(valid_564362, JString, required = true,
                                 default = nil)
  if valid_564362 != nil:
    section.add "resourceGroupName", valid_564362
  var valid_564363 = path.getOrDefault("resourceName")
  valid_564363 = validateParameter(valid_564363, JString, required = true,
                                 default = nil)
  if valid_564363 != nil:
    section.add "resourceName", valid_564363
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564364 = query.getOrDefault("api-version")
  valid_564364 = validateParameter(valid_564364, JString, required = true,
                                 default = nil)
  if valid_564364 != nil:
    section.add "api-version", valid_564364
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

proc call*(call_564366: Call_ReplicationNetworkMappingsCreate_564355;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create an ASR network mapping.
  ## 
  let valid = call_564366.validator(path, query, header, formData, body)
  let scheme = call_564366.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564366.url(scheme.get, call_564366.host, call_564366.base,
                         call_564366.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564366, url, valid)

proc call*(call_564367: Call_ReplicationNetworkMappingsCreate_564355;
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
  var path_564368 = newJObject()
  var query_564369 = newJObject()
  var body_564370 = newJObject()
  add(path_564368, "networkMappingName", newJString(networkMappingName))
  add(query_564369, "api-version", newJString(apiVersion))
  if input != nil:
    body_564370 = input
  add(path_564368, "networkName", newJString(networkName))
  add(path_564368, "fabricName", newJString(fabricName))
  add(path_564368, "subscriptionId", newJString(subscriptionId))
  add(path_564368, "resourceGroupName", newJString(resourceGroupName))
  add(path_564368, "resourceName", newJString(resourceName))
  result = call_564367.call(path_564368, query_564369, nil, nil, body_564370)

var replicationNetworkMappingsCreate* = Call_ReplicationNetworkMappingsCreate_564355(
    name: "replicationNetworkMappingsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationNetworks/{networkName}/replicationNetworkMappings/{networkMappingName}",
    validator: validate_ReplicationNetworkMappingsCreate_564356, base: "",
    url: url_ReplicationNetworkMappingsCreate_564357, schemes: {Scheme.Https})
type
  Call_ReplicationNetworkMappingsGet_564341 = ref object of OpenApiRestCall_563566
proc url_ReplicationNetworkMappingsGet_564343(protocol: Scheme; host: string;
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

proc validate_ReplicationNetworkMappingsGet_564342(path: JsonNode; query: JsonNode;
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
  var valid_564344 = path.getOrDefault("networkMappingName")
  valid_564344 = validateParameter(valid_564344, JString, required = true,
                                 default = nil)
  if valid_564344 != nil:
    section.add "networkMappingName", valid_564344
  var valid_564345 = path.getOrDefault("networkName")
  valid_564345 = validateParameter(valid_564345, JString, required = true,
                                 default = nil)
  if valid_564345 != nil:
    section.add "networkName", valid_564345
  var valid_564346 = path.getOrDefault("fabricName")
  valid_564346 = validateParameter(valid_564346, JString, required = true,
                                 default = nil)
  if valid_564346 != nil:
    section.add "fabricName", valid_564346
  var valid_564347 = path.getOrDefault("subscriptionId")
  valid_564347 = validateParameter(valid_564347, JString, required = true,
                                 default = nil)
  if valid_564347 != nil:
    section.add "subscriptionId", valid_564347
  var valid_564348 = path.getOrDefault("resourceGroupName")
  valid_564348 = validateParameter(valid_564348, JString, required = true,
                                 default = nil)
  if valid_564348 != nil:
    section.add "resourceGroupName", valid_564348
  var valid_564349 = path.getOrDefault("resourceName")
  valid_564349 = validateParameter(valid_564349, JString, required = true,
                                 default = nil)
  if valid_564349 != nil:
    section.add "resourceName", valid_564349
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564350 = query.getOrDefault("api-version")
  valid_564350 = validateParameter(valid_564350, JString, required = true,
                                 default = nil)
  if valid_564350 != nil:
    section.add "api-version", valid_564350
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564351: Call_ReplicationNetworkMappingsGet_564341; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of an ASR network mapping
  ## 
  let valid = call_564351.validator(path, query, header, formData, body)
  let scheme = call_564351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564351.url(scheme.get, call_564351.host, call_564351.base,
                         call_564351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564351, url, valid)

proc call*(call_564352: Call_ReplicationNetworkMappingsGet_564341;
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
  var path_564353 = newJObject()
  var query_564354 = newJObject()
  add(path_564353, "networkMappingName", newJString(networkMappingName))
  add(query_564354, "api-version", newJString(apiVersion))
  add(path_564353, "networkName", newJString(networkName))
  add(path_564353, "fabricName", newJString(fabricName))
  add(path_564353, "subscriptionId", newJString(subscriptionId))
  add(path_564353, "resourceGroupName", newJString(resourceGroupName))
  add(path_564353, "resourceName", newJString(resourceName))
  result = call_564352.call(path_564353, query_564354, nil, nil, nil)

var replicationNetworkMappingsGet* = Call_ReplicationNetworkMappingsGet_564341(
    name: "replicationNetworkMappingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationNetworks/{networkName}/replicationNetworkMappings/{networkMappingName}",
    validator: validate_ReplicationNetworkMappingsGet_564342, base: "",
    url: url_ReplicationNetworkMappingsGet_564343, schemes: {Scheme.Https})
type
  Call_ReplicationNetworkMappingsUpdate_564385 = ref object of OpenApiRestCall_563566
proc url_ReplicationNetworkMappingsUpdate_564387(protocol: Scheme; host: string;
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

proc validate_ReplicationNetworkMappingsUpdate_564386(path: JsonNode;
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
  var valid_564388 = path.getOrDefault("networkMappingName")
  valid_564388 = validateParameter(valid_564388, JString, required = true,
                                 default = nil)
  if valid_564388 != nil:
    section.add "networkMappingName", valid_564388
  var valid_564389 = path.getOrDefault("networkName")
  valid_564389 = validateParameter(valid_564389, JString, required = true,
                                 default = nil)
  if valid_564389 != nil:
    section.add "networkName", valid_564389
  var valid_564390 = path.getOrDefault("fabricName")
  valid_564390 = validateParameter(valid_564390, JString, required = true,
                                 default = nil)
  if valid_564390 != nil:
    section.add "fabricName", valid_564390
  var valid_564391 = path.getOrDefault("subscriptionId")
  valid_564391 = validateParameter(valid_564391, JString, required = true,
                                 default = nil)
  if valid_564391 != nil:
    section.add "subscriptionId", valid_564391
  var valid_564392 = path.getOrDefault("resourceGroupName")
  valid_564392 = validateParameter(valid_564392, JString, required = true,
                                 default = nil)
  if valid_564392 != nil:
    section.add "resourceGroupName", valid_564392
  var valid_564393 = path.getOrDefault("resourceName")
  valid_564393 = validateParameter(valid_564393, JString, required = true,
                                 default = nil)
  if valid_564393 != nil:
    section.add "resourceName", valid_564393
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564394 = query.getOrDefault("api-version")
  valid_564394 = validateParameter(valid_564394, JString, required = true,
                                 default = nil)
  if valid_564394 != nil:
    section.add "api-version", valid_564394
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

proc call*(call_564396: Call_ReplicationNetworkMappingsUpdate_564385;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to update an ASR network mapping.
  ## 
  let valid = call_564396.validator(path, query, header, formData, body)
  let scheme = call_564396.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564396.url(scheme.get, call_564396.host, call_564396.base,
                         call_564396.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564396, url, valid)

proc call*(call_564397: Call_ReplicationNetworkMappingsUpdate_564385;
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
  var path_564398 = newJObject()
  var query_564399 = newJObject()
  var body_564400 = newJObject()
  add(path_564398, "networkMappingName", newJString(networkMappingName))
  add(query_564399, "api-version", newJString(apiVersion))
  if input != nil:
    body_564400 = input
  add(path_564398, "networkName", newJString(networkName))
  add(path_564398, "fabricName", newJString(fabricName))
  add(path_564398, "subscriptionId", newJString(subscriptionId))
  add(path_564398, "resourceGroupName", newJString(resourceGroupName))
  add(path_564398, "resourceName", newJString(resourceName))
  result = call_564397.call(path_564398, query_564399, nil, nil, body_564400)

var replicationNetworkMappingsUpdate* = Call_ReplicationNetworkMappingsUpdate_564385(
    name: "replicationNetworkMappingsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationNetworks/{networkName}/replicationNetworkMappings/{networkMappingName}",
    validator: validate_ReplicationNetworkMappingsUpdate_564386, base: "",
    url: url_ReplicationNetworkMappingsUpdate_564387, schemes: {Scheme.Https})
type
  Call_ReplicationNetworkMappingsDelete_564371 = ref object of OpenApiRestCall_563566
proc url_ReplicationNetworkMappingsDelete_564373(protocol: Scheme; host: string;
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

proc validate_ReplicationNetworkMappingsDelete_564372(path: JsonNode;
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
  var valid_564374 = path.getOrDefault("networkMappingName")
  valid_564374 = validateParameter(valid_564374, JString, required = true,
                                 default = nil)
  if valid_564374 != nil:
    section.add "networkMappingName", valid_564374
  var valid_564375 = path.getOrDefault("networkName")
  valid_564375 = validateParameter(valid_564375, JString, required = true,
                                 default = nil)
  if valid_564375 != nil:
    section.add "networkName", valid_564375
  var valid_564376 = path.getOrDefault("fabricName")
  valid_564376 = validateParameter(valid_564376, JString, required = true,
                                 default = nil)
  if valid_564376 != nil:
    section.add "fabricName", valid_564376
  var valid_564377 = path.getOrDefault("subscriptionId")
  valid_564377 = validateParameter(valid_564377, JString, required = true,
                                 default = nil)
  if valid_564377 != nil:
    section.add "subscriptionId", valid_564377
  var valid_564378 = path.getOrDefault("resourceGroupName")
  valid_564378 = validateParameter(valid_564378, JString, required = true,
                                 default = nil)
  if valid_564378 != nil:
    section.add "resourceGroupName", valid_564378
  var valid_564379 = path.getOrDefault("resourceName")
  valid_564379 = validateParameter(valid_564379, JString, required = true,
                                 default = nil)
  if valid_564379 != nil:
    section.add "resourceName", valid_564379
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564380 = query.getOrDefault("api-version")
  valid_564380 = validateParameter(valid_564380, JString, required = true,
                                 default = nil)
  if valid_564380 != nil:
    section.add "api-version", valid_564380
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564381: Call_ReplicationNetworkMappingsDelete_564371;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete a network mapping.
  ## 
  let valid = call_564381.validator(path, query, header, formData, body)
  let scheme = call_564381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564381.url(scheme.get, call_564381.host, call_564381.base,
                         call_564381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564381, url, valid)

proc call*(call_564382: Call_ReplicationNetworkMappingsDelete_564371;
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
  var path_564383 = newJObject()
  var query_564384 = newJObject()
  add(path_564383, "networkMappingName", newJString(networkMappingName))
  add(query_564384, "api-version", newJString(apiVersion))
  add(path_564383, "networkName", newJString(networkName))
  add(path_564383, "fabricName", newJString(fabricName))
  add(path_564383, "subscriptionId", newJString(subscriptionId))
  add(path_564383, "resourceGroupName", newJString(resourceGroupName))
  add(path_564383, "resourceName", newJString(resourceName))
  result = call_564382.call(path_564383, query_564384, nil, nil, nil)

var replicationNetworkMappingsDelete* = Call_ReplicationNetworkMappingsDelete_564371(
    name: "replicationNetworkMappingsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationNetworks/{networkName}/replicationNetworkMappings/{networkMappingName}",
    validator: validate_ReplicationNetworkMappingsDelete_564372, base: "",
    url: url_ReplicationNetworkMappingsDelete_564373, schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersListByReplicationFabrics_564401 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectionContainersListByReplicationFabrics_564403(
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

proc validate_ReplicationProtectionContainersListByReplicationFabrics_564402(
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
  var valid_564404 = path.getOrDefault("fabricName")
  valid_564404 = validateParameter(valid_564404, JString, required = true,
                                 default = nil)
  if valid_564404 != nil:
    section.add "fabricName", valid_564404
  var valid_564405 = path.getOrDefault("subscriptionId")
  valid_564405 = validateParameter(valid_564405, JString, required = true,
                                 default = nil)
  if valid_564405 != nil:
    section.add "subscriptionId", valid_564405
  var valid_564406 = path.getOrDefault("resourceGroupName")
  valid_564406 = validateParameter(valid_564406, JString, required = true,
                                 default = nil)
  if valid_564406 != nil:
    section.add "resourceGroupName", valid_564406
  var valid_564407 = path.getOrDefault("resourceName")
  valid_564407 = validateParameter(valid_564407, JString, required = true,
                                 default = nil)
  if valid_564407 != nil:
    section.add "resourceName", valid_564407
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564408 = query.getOrDefault("api-version")
  valid_564408 = validateParameter(valid_564408, JString, required = true,
                                 default = nil)
  if valid_564408 != nil:
    section.add "api-version", valid_564408
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564409: Call_ReplicationProtectionContainersListByReplicationFabrics_564401;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the protection containers in the specified fabric.
  ## 
  let valid = call_564409.validator(path, query, header, formData, body)
  let scheme = call_564409.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564409.url(scheme.get, call_564409.host, call_564409.base,
                         call_564409.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564409, url, valid)

proc call*(call_564410: Call_ReplicationProtectionContainersListByReplicationFabrics_564401;
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
  var path_564411 = newJObject()
  var query_564412 = newJObject()
  add(query_564412, "api-version", newJString(apiVersion))
  add(path_564411, "fabricName", newJString(fabricName))
  add(path_564411, "subscriptionId", newJString(subscriptionId))
  add(path_564411, "resourceGroupName", newJString(resourceGroupName))
  add(path_564411, "resourceName", newJString(resourceName))
  result = call_564410.call(path_564411, query_564412, nil, nil, nil)

var replicationProtectionContainersListByReplicationFabrics* = Call_ReplicationProtectionContainersListByReplicationFabrics_564401(
    name: "replicationProtectionContainersListByReplicationFabrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers", validator: validate_ReplicationProtectionContainersListByReplicationFabrics_564402,
    base: "", url: url_ReplicationProtectionContainersListByReplicationFabrics_564403,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersCreate_564426 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectionContainersCreate_564428(protocol: Scheme;
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

proc validate_ReplicationProtectionContainersCreate_564427(path: JsonNode;
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
  var valid_564429 = path.getOrDefault("protectionContainerName")
  valid_564429 = validateParameter(valid_564429, JString, required = true,
                                 default = nil)
  if valid_564429 != nil:
    section.add "protectionContainerName", valid_564429
  var valid_564430 = path.getOrDefault("fabricName")
  valid_564430 = validateParameter(valid_564430, JString, required = true,
                                 default = nil)
  if valid_564430 != nil:
    section.add "fabricName", valid_564430
  var valid_564431 = path.getOrDefault("subscriptionId")
  valid_564431 = validateParameter(valid_564431, JString, required = true,
                                 default = nil)
  if valid_564431 != nil:
    section.add "subscriptionId", valid_564431
  var valid_564432 = path.getOrDefault("resourceGroupName")
  valid_564432 = validateParameter(valid_564432, JString, required = true,
                                 default = nil)
  if valid_564432 != nil:
    section.add "resourceGroupName", valid_564432
  var valid_564433 = path.getOrDefault("resourceName")
  valid_564433 = validateParameter(valid_564433, JString, required = true,
                                 default = nil)
  if valid_564433 != nil:
    section.add "resourceName", valid_564433
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564434 = query.getOrDefault("api-version")
  valid_564434 = validateParameter(valid_564434, JString, required = true,
                                 default = nil)
  if valid_564434 != nil:
    section.add "api-version", valid_564434
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

proc call*(call_564436: Call_ReplicationProtectionContainersCreate_564426;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to create a protection container.
  ## 
  let valid = call_564436.validator(path, query, header, formData, body)
  let scheme = call_564436.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564436.url(scheme.get, call_564436.host, call_564436.base,
                         call_564436.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564436, url, valid)

proc call*(call_564437: Call_ReplicationProtectionContainersCreate_564426;
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
  var path_564438 = newJObject()
  var query_564439 = newJObject()
  var body_564440 = newJObject()
  add(path_564438, "protectionContainerName", newJString(protectionContainerName))
  add(query_564439, "api-version", newJString(apiVersion))
  if creationInput != nil:
    body_564440 = creationInput
  add(path_564438, "fabricName", newJString(fabricName))
  add(path_564438, "subscriptionId", newJString(subscriptionId))
  add(path_564438, "resourceGroupName", newJString(resourceGroupName))
  add(path_564438, "resourceName", newJString(resourceName))
  result = call_564437.call(path_564438, query_564439, nil, nil, body_564440)

var replicationProtectionContainersCreate* = Call_ReplicationProtectionContainersCreate_564426(
    name: "replicationProtectionContainersCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}",
    validator: validate_ReplicationProtectionContainersCreate_564427, base: "",
    url: url_ReplicationProtectionContainersCreate_564428, schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersGet_564413 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectionContainersGet_564415(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectionContainersGet_564414(path: JsonNode;
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
  var valid_564416 = path.getOrDefault("protectionContainerName")
  valid_564416 = validateParameter(valid_564416, JString, required = true,
                                 default = nil)
  if valid_564416 != nil:
    section.add "protectionContainerName", valid_564416
  var valid_564417 = path.getOrDefault("fabricName")
  valid_564417 = validateParameter(valid_564417, JString, required = true,
                                 default = nil)
  if valid_564417 != nil:
    section.add "fabricName", valid_564417
  var valid_564418 = path.getOrDefault("subscriptionId")
  valid_564418 = validateParameter(valid_564418, JString, required = true,
                                 default = nil)
  if valid_564418 != nil:
    section.add "subscriptionId", valid_564418
  var valid_564419 = path.getOrDefault("resourceGroupName")
  valid_564419 = validateParameter(valid_564419, JString, required = true,
                                 default = nil)
  if valid_564419 != nil:
    section.add "resourceGroupName", valid_564419
  var valid_564420 = path.getOrDefault("resourceName")
  valid_564420 = validateParameter(valid_564420, JString, required = true,
                                 default = nil)
  if valid_564420 != nil:
    section.add "resourceName", valid_564420
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564421 = query.getOrDefault("api-version")
  valid_564421 = validateParameter(valid_564421, JString, required = true,
                                 default = nil)
  if valid_564421 != nil:
    section.add "api-version", valid_564421
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564422: Call_ReplicationProtectionContainersGet_564413;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of a protection container.
  ## 
  let valid = call_564422.validator(path, query, header, formData, body)
  let scheme = call_564422.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564422.url(scheme.get, call_564422.host, call_564422.base,
                         call_564422.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564422, url, valid)

proc call*(call_564423: Call_ReplicationProtectionContainersGet_564413;
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
  var path_564424 = newJObject()
  var query_564425 = newJObject()
  add(path_564424, "protectionContainerName", newJString(protectionContainerName))
  add(query_564425, "api-version", newJString(apiVersion))
  add(path_564424, "fabricName", newJString(fabricName))
  add(path_564424, "subscriptionId", newJString(subscriptionId))
  add(path_564424, "resourceGroupName", newJString(resourceGroupName))
  add(path_564424, "resourceName", newJString(resourceName))
  result = call_564423.call(path_564424, query_564425, nil, nil, nil)

var replicationProtectionContainersGet* = Call_ReplicationProtectionContainersGet_564413(
    name: "replicationProtectionContainersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}",
    validator: validate_ReplicationProtectionContainersGet_564414, base: "",
    url: url_ReplicationProtectionContainersGet_564415, schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersDiscoverProtectableItem_564441 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectionContainersDiscoverProtectableItem_564443(
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

proc validate_ReplicationProtectionContainersDiscoverProtectableItem_564442(
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
  var valid_564444 = path.getOrDefault("protectionContainerName")
  valid_564444 = validateParameter(valid_564444, JString, required = true,
                                 default = nil)
  if valid_564444 != nil:
    section.add "protectionContainerName", valid_564444
  var valid_564445 = path.getOrDefault("fabricName")
  valid_564445 = validateParameter(valid_564445, JString, required = true,
                                 default = nil)
  if valid_564445 != nil:
    section.add "fabricName", valid_564445
  var valid_564446 = path.getOrDefault("subscriptionId")
  valid_564446 = validateParameter(valid_564446, JString, required = true,
                                 default = nil)
  if valid_564446 != nil:
    section.add "subscriptionId", valid_564446
  var valid_564447 = path.getOrDefault("resourceGroupName")
  valid_564447 = validateParameter(valid_564447, JString, required = true,
                                 default = nil)
  if valid_564447 != nil:
    section.add "resourceGroupName", valid_564447
  var valid_564448 = path.getOrDefault("resourceName")
  valid_564448 = validateParameter(valid_564448, JString, required = true,
                                 default = nil)
  if valid_564448 != nil:
    section.add "resourceName", valid_564448
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564449 = query.getOrDefault("api-version")
  valid_564449 = validateParameter(valid_564449, JString, required = true,
                                 default = nil)
  if valid_564449 != nil:
    section.add "api-version", valid_564449
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

proc call*(call_564451: Call_ReplicationProtectionContainersDiscoverProtectableItem_564441;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to a add a protectable item to a protection container(Add physical server.)
  ## 
  let valid = call_564451.validator(path, query, header, formData, body)
  let scheme = call_564451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564451.url(scheme.get, call_564451.host, call_564451.base,
                         call_564451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564451, url, valid)

proc call*(call_564452: Call_ReplicationProtectionContainersDiscoverProtectableItem_564441;
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
  var path_564453 = newJObject()
  var query_564454 = newJObject()
  var body_564455 = newJObject()
  add(path_564453, "protectionContainerName", newJString(protectionContainerName))
  add(query_564454, "api-version", newJString(apiVersion))
  add(path_564453, "fabricName", newJString(fabricName))
  add(path_564453, "subscriptionId", newJString(subscriptionId))
  if discoverProtectableItemRequest != nil:
    body_564455 = discoverProtectableItemRequest
  add(path_564453, "resourceGroupName", newJString(resourceGroupName))
  add(path_564453, "resourceName", newJString(resourceName))
  result = call_564452.call(path_564453, query_564454, nil, nil, body_564455)

var replicationProtectionContainersDiscoverProtectableItem* = Call_ReplicationProtectionContainersDiscoverProtectableItem_564441(
    name: "replicationProtectionContainersDiscoverProtectableItem",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/discoverProtectableItem",
    validator: validate_ReplicationProtectionContainersDiscoverProtectableItem_564442,
    base: "", url: url_ReplicationProtectionContainersDiscoverProtectableItem_564443,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersDelete_564456 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectionContainersDelete_564458(protocol: Scheme;
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

proc validate_ReplicationProtectionContainersDelete_564457(path: JsonNode;
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
  var valid_564459 = path.getOrDefault("protectionContainerName")
  valid_564459 = validateParameter(valid_564459, JString, required = true,
                                 default = nil)
  if valid_564459 != nil:
    section.add "protectionContainerName", valid_564459
  var valid_564460 = path.getOrDefault("fabricName")
  valid_564460 = validateParameter(valid_564460, JString, required = true,
                                 default = nil)
  if valid_564460 != nil:
    section.add "fabricName", valid_564460
  var valid_564461 = path.getOrDefault("subscriptionId")
  valid_564461 = validateParameter(valid_564461, JString, required = true,
                                 default = nil)
  if valid_564461 != nil:
    section.add "subscriptionId", valid_564461
  var valid_564462 = path.getOrDefault("resourceGroupName")
  valid_564462 = validateParameter(valid_564462, JString, required = true,
                                 default = nil)
  if valid_564462 != nil:
    section.add "resourceGroupName", valid_564462
  var valid_564463 = path.getOrDefault("resourceName")
  valid_564463 = validateParameter(valid_564463, JString, required = true,
                                 default = nil)
  if valid_564463 != nil:
    section.add "resourceName", valid_564463
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564464 = query.getOrDefault("api-version")
  valid_564464 = validateParameter(valid_564464, JString, required = true,
                                 default = nil)
  if valid_564464 != nil:
    section.add "api-version", valid_564464
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564465: Call_ReplicationProtectionContainersDelete_564456;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to remove a protection container.
  ## 
  let valid = call_564465.validator(path, query, header, formData, body)
  let scheme = call_564465.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564465.url(scheme.get, call_564465.host, call_564465.base,
                         call_564465.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564465, url, valid)

proc call*(call_564466: Call_ReplicationProtectionContainersDelete_564456;
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
  var path_564467 = newJObject()
  var query_564468 = newJObject()
  add(path_564467, "protectionContainerName", newJString(protectionContainerName))
  add(query_564468, "api-version", newJString(apiVersion))
  add(path_564467, "fabricName", newJString(fabricName))
  add(path_564467, "subscriptionId", newJString(subscriptionId))
  add(path_564467, "resourceGroupName", newJString(resourceGroupName))
  add(path_564467, "resourceName", newJString(resourceName))
  result = call_564466.call(path_564467, query_564468, nil, nil, nil)

var replicationProtectionContainersDelete* = Call_ReplicationProtectionContainersDelete_564456(
    name: "replicationProtectionContainersDelete", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/remove",
    validator: validate_ReplicationProtectionContainersDelete_564457, base: "",
    url: url_ReplicationProtectionContainersDelete_564458, schemes: {Scheme.Https})
type
  Call_ReplicationMigrationItemsListByReplicationProtectionContainers_564469 = ref object of OpenApiRestCall_563566
proc url_ReplicationMigrationItemsListByReplicationProtectionContainers_564471(
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
               (kind: ConstantSegment, value: "/replicationMigrationItems")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationMigrationItemsListByReplicationProtectionContainers_564470(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the list of ASR migration items in the protection container.
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
  var valid_564472 = path.getOrDefault("protectionContainerName")
  valid_564472 = validateParameter(valid_564472, JString, required = true,
                                 default = nil)
  if valid_564472 != nil:
    section.add "protectionContainerName", valid_564472
  var valid_564473 = path.getOrDefault("fabricName")
  valid_564473 = validateParameter(valid_564473, JString, required = true,
                                 default = nil)
  if valid_564473 != nil:
    section.add "fabricName", valid_564473
  var valid_564474 = path.getOrDefault("subscriptionId")
  valid_564474 = validateParameter(valid_564474, JString, required = true,
                                 default = nil)
  if valid_564474 != nil:
    section.add "subscriptionId", valid_564474
  var valid_564475 = path.getOrDefault("resourceGroupName")
  valid_564475 = validateParameter(valid_564475, JString, required = true,
                                 default = nil)
  if valid_564475 != nil:
    section.add "resourceGroupName", valid_564475
  var valid_564476 = path.getOrDefault("resourceName")
  valid_564476 = validateParameter(valid_564476, JString, required = true,
                                 default = nil)
  if valid_564476 != nil:
    section.add "resourceName", valid_564476
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564477 = query.getOrDefault("api-version")
  valid_564477 = validateParameter(valid_564477, JString, required = true,
                                 default = nil)
  if valid_564477 != nil:
    section.add "api-version", valid_564477
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564478: Call_ReplicationMigrationItemsListByReplicationProtectionContainers_564469;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the list of ASR migration items in the protection container.
  ## 
  let valid = call_564478.validator(path, query, header, formData, body)
  let scheme = call_564478.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564478.url(scheme.get, call_564478.host, call_564478.base,
                         call_564478.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564478, url, valid)

proc call*(call_564479: Call_ReplicationMigrationItemsListByReplicationProtectionContainers_564469;
          protectionContainerName: string; apiVersion: string; fabricName: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## replicationMigrationItemsListByReplicationProtectionContainers
  ## Gets the list of ASR migration items in the protection container.
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
  var path_564480 = newJObject()
  var query_564481 = newJObject()
  add(path_564480, "protectionContainerName", newJString(protectionContainerName))
  add(query_564481, "api-version", newJString(apiVersion))
  add(path_564480, "fabricName", newJString(fabricName))
  add(path_564480, "subscriptionId", newJString(subscriptionId))
  add(path_564480, "resourceGroupName", newJString(resourceGroupName))
  add(path_564480, "resourceName", newJString(resourceName))
  result = call_564479.call(path_564480, query_564481, nil, nil, nil)

var replicationMigrationItemsListByReplicationProtectionContainers* = Call_ReplicationMigrationItemsListByReplicationProtectionContainers_564469(
    name: "replicationMigrationItemsListByReplicationProtectionContainers",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationMigrationItems", validator: validate_ReplicationMigrationItemsListByReplicationProtectionContainers_564470,
    base: "",
    url: url_ReplicationMigrationItemsListByReplicationProtectionContainers_564471,
    schemes: {Scheme.Https})
type
  Call_ReplicationMigrationItemsCreate_564496 = ref object of OpenApiRestCall_563566
proc url_ReplicationMigrationItemsCreate_564498(protocol: Scheme; host: string;
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
  assert "migrationItemName" in path,
        "`migrationItemName` is a required path parameter"
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
               (kind: ConstantSegment, value: "/replicationMigrationItems/"),
               (kind: VariableSegment, value: "migrationItemName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationMigrationItemsCreate_564497(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create an ASR migration item (enable migration).
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
  ##   migrationItemName: JString (required)
  ##                    : Migration item name.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564499 = path.getOrDefault("protectionContainerName")
  valid_564499 = validateParameter(valid_564499, JString, required = true,
                                 default = nil)
  if valid_564499 != nil:
    section.add "protectionContainerName", valid_564499
  var valid_564500 = path.getOrDefault("fabricName")
  valid_564500 = validateParameter(valid_564500, JString, required = true,
                                 default = nil)
  if valid_564500 != nil:
    section.add "fabricName", valid_564500
  var valid_564501 = path.getOrDefault("subscriptionId")
  valid_564501 = validateParameter(valid_564501, JString, required = true,
                                 default = nil)
  if valid_564501 != nil:
    section.add "subscriptionId", valid_564501
  var valid_564502 = path.getOrDefault("resourceGroupName")
  valid_564502 = validateParameter(valid_564502, JString, required = true,
                                 default = nil)
  if valid_564502 != nil:
    section.add "resourceGroupName", valid_564502
  var valid_564503 = path.getOrDefault("migrationItemName")
  valid_564503 = validateParameter(valid_564503, JString, required = true,
                                 default = nil)
  if valid_564503 != nil:
    section.add "migrationItemName", valid_564503
  var valid_564504 = path.getOrDefault("resourceName")
  valid_564504 = validateParameter(valid_564504, JString, required = true,
                                 default = nil)
  if valid_564504 != nil:
    section.add "resourceName", valid_564504
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564505 = query.getOrDefault("api-version")
  valid_564505 = validateParameter(valid_564505, JString, required = true,
                                 default = nil)
  if valid_564505 != nil:
    section.add "api-version", valid_564505
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Enable migration input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564507: Call_ReplicationMigrationItemsCreate_564496;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create an ASR migration item (enable migration).
  ## 
  let valid = call_564507.validator(path, query, header, formData, body)
  let scheme = call_564507.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564507.url(scheme.get, call_564507.host, call_564507.base,
                         call_564507.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564507, url, valid)

proc call*(call_564508: Call_ReplicationMigrationItemsCreate_564496;
          protectionContainerName: string; apiVersion: string; input: JsonNode;
          fabricName: string; subscriptionId: string; resourceGroupName: string;
          migrationItemName: string; resourceName: string): Recallable =
  ## replicationMigrationItemsCreate
  ## The operation to create an ASR migration item (enable migration).
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   input: JObject (required)
  ##        : Enable migration input.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   migrationItemName: string (required)
  ##                    : Migration item name.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564509 = newJObject()
  var query_564510 = newJObject()
  var body_564511 = newJObject()
  add(path_564509, "protectionContainerName", newJString(protectionContainerName))
  add(query_564510, "api-version", newJString(apiVersion))
  if input != nil:
    body_564511 = input
  add(path_564509, "fabricName", newJString(fabricName))
  add(path_564509, "subscriptionId", newJString(subscriptionId))
  add(path_564509, "resourceGroupName", newJString(resourceGroupName))
  add(path_564509, "migrationItemName", newJString(migrationItemName))
  add(path_564509, "resourceName", newJString(resourceName))
  result = call_564508.call(path_564509, query_564510, nil, nil, body_564511)

var replicationMigrationItemsCreate* = Call_ReplicationMigrationItemsCreate_564496(
    name: "replicationMigrationItemsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationMigrationItems/{migrationItemName}",
    validator: validate_ReplicationMigrationItemsCreate_564497, base: "",
    url: url_ReplicationMigrationItemsCreate_564498, schemes: {Scheme.Https})
type
  Call_ReplicationMigrationItemsGet_564482 = ref object of OpenApiRestCall_563566
proc url_ReplicationMigrationItemsGet_564484(protocol: Scheme; host: string;
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
  assert "migrationItemName" in path,
        "`migrationItemName` is a required path parameter"
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
               (kind: ConstantSegment, value: "/replicationMigrationItems/"),
               (kind: VariableSegment, value: "migrationItemName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationMigrationItemsGet_564483(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   fabricName: JString (required)
  ##             : Fabric unique name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   migrationItemName: JString (required)
  ##                    : Migration item name.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564485 = path.getOrDefault("protectionContainerName")
  valid_564485 = validateParameter(valid_564485, JString, required = true,
                                 default = nil)
  if valid_564485 != nil:
    section.add "protectionContainerName", valid_564485
  var valid_564486 = path.getOrDefault("fabricName")
  valid_564486 = validateParameter(valid_564486, JString, required = true,
                                 default = nil)
  if valid_564486 != nil:
    section.add "fabricName", valid_564486
  var valid_564487 = path.getOrDefault("subscriptionId")
  valid_564487 = validateParameter(valid_564487, JString, required = true,
                                 default = nil)
  if valid_564487 != nil:
    section.add "subscriptionId", valid_564487
  var valid_564488 = path.getOrDefault("resourceGroupName")
  valid_564488 = validateParameter(valid_564488, JString, required = true,
                                 default = nil)
  if valid_564488 != nil:
    section.add "resourceGroupName", valid_564488
  var valid_564489 = path.getOrDefault("migrationItemName")
  valid_564489 = validateParameter(valid_564489, JString, required = true,
                                 default = nil)
  if valid_564489 != nil:
    section.add "migrationItemName", valid_564489
  var valid_564490 = path.getOrDefault("resourceName")
  valid_564490 = validateParameter(valid_564490, JString, required = true,
                                 default = nil)
  if valid_564490 != nil:
    section.add "resourceName", valid_564490
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564491 = query.getOrDefault("api-version")
  valid_564491 = validateParameter(valid_564491, JString, required = true,
                                 default = nil)
  if valid_564491 != nil:
    section.add "api-version", valid_564491
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564492: Call_ReplicationMigrationItemsGet_564482; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564492.validator(path, query, header, formData, body)
  let scheme = call_564492.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564492.url(scheme.get, call_564492.host, call_564492.base,
                         call_564492.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564492, url, valid)

proc call*(call_564493: Call_ReplicationMigrationItemsGet_564482;
          protectionContainerName: string; apiVersion: string; fabricName: string;
          subscriptionId: string; resourceGroupName: string;
          migrationItemName: string; resourceName: string): Recallable =
  ## replicationMigrationItemsGet
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric unique name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   migrationItemName: string (required)
  ##                    : Migration item name.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564494 = newJObject()
  var query_564495 = newJObject()
  add(path_564494, "protectionContainerName", newJString(protectionContainerName))
  add(query_564495, "api-version", newJString(apiVersion))
  add(path_564494, "fabricName", newJString(fabricName))
  add(path_564494, "subscriptionId", newJString(subscriptionId))
  add(path_564494, "resourceGroupName", newJString(resourceGroupName))
  add(path_564494, "migrationItemName", newJString(migrationItemName))
  add(path_564494, "resourceName", newJString(resourceName))
  result = call_564493.call(path_564494, query_564495, nil, nil, nil)

var replicationMigrationItemsGet* = Call_ReplicationMigrationItemsGet_564482(
    name: "replicationMigrationItemsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationMigrationItems/{migrationItemName}",
    validator: validate_ReplicationMigrationItemsGet_564483, base: "",
    url: url_ReplicationMigrationItemsGet_564484, schemes: {Scheme.Https})
type
  Call_ReplicationMigrationItemsUpdate_564527 = ref object of OpenApiRestCall_563566
proc url_ReplicationMigrationItemsUpdate_564529(protocol: Scheme; host: string;
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
  assert "migrationItemName" in path,
        "`migrationItemName` is a required path parameter"
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
               (kind: ConstantSegment, value: "/replicationMigrationItems/"),
               (kind: VariableSegment, value: "migrationItemName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationMigrationItemsUpdate_564528(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update the recovery settings of an ASR migration item.
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
  ##   migrationItemName: JString (required)
  ##                    : Migration item name.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564530 = path.getOrDefault("protectionContainerName")
  valid_564530 = validateParameter(valid_564530, JString, required = true,
                                 default = nil)
  if valid_564530 != nil:
    section.add "protectionContainerName", valid_564530
  var valid_564531 = path.getOrDefault("fabricName")
  valid_564531 = validateParameter(valid_564531, JString, required = true,
                                 default = nil)
  if valid_564531 != nil:
    section.add "fabricName", valid_564531
  var valid_564532 = path.getOrDefault("subscriptionId")
  valid_564532 = validateParameter(valid_564532, JString, required = true,
                                 default = nil)
  if valid_564532 != nil:
    section.add "subscriptionId", valid_564532
  var valid_564533 = path.getOrDefault("resourceGroupName")
  valid_564533 = validateParameter(valid_564533, JString, required = true,
                                 default = nil)
  if valid_564533 != nil:
    section.add "resourceGroupName", valid_564533
  var valid_564534 = path.getOrDefault("migrationItemName")
  valid_564534 = validateParameter(valid_564534, JString, required = true,
                                 default = nil)
  if valid_564534 != nil:
    section.add "migrationItemName", valid_564534
  var valid_564535 = path.getOrDefault("resourceName")
  valid_564535 = validateParameter(valid_564535, JString, required = true,
                                 default = nil)
  if valid_564535 != nil:
    section.add "resourceName", valid_564535
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564536 = query.getOrDefault("api-version")
  valid_564536 = validateParameter(valid_564536, JString, required = true,
                                 default = nil)
  if valid_564536 != nil:
    section.add "api-version", valid_564536
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Update migration item input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564538: Call_ReplicationMigrationItemsUpdate_564527;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to update the recovery settings of an ASR migration item.
  ## 
  let valid = call_564538.validator(path, query, header, formData, body)
  let scheme = call_564538.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564538.url(scheme.get, call_564538.host, call_564538.base,
                         call_564538.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564538, url, valid)

proc call*(call_564539: Call_ReplicationMigrationItemsUpdate_564527;
          protectionContainerName: string; apiVersion: string; input: JsonNode;
          fabricName: string; subscriptionId: string; resourceGroupName: string;
          migrationItemName: string; resourceName: string): Recallable =
  ## replicationMigrationItemsUpdate
  ## The operation to update the recovery settings of an ASR migration item.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   input: JObject (required)
  ##        : Update migration item input.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   migrationItemName: string (required)
  ##                    : Migration item name.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564540 = newJObject()
  var query_564541 = newJObject()
  var body_564542 = newJObject()
  add(path_564540, "protectionContainerName", newJString(protectionContainerName))
  add(query_564541, "api-version", newJString(apiVersion))
  if input != nil:
    body_564542 = input
  add(path_564540, "fabricName", newJString(fabricName))
  add(path_564540, "subscriptionId", newJString(subscriptionId))
  add(path_564540, "resourceGroupName", newJString(resourceGroupName))
  add(path_564540, "migrationItemName", newJString(migrationItemName))
  add(path_564540, "resourceName", newJString(resourceName))
  result = call_564539.call(path_564540, query_564541, nil, nil, body_564542)

var replicationMigrationItemsUpdate* = Call_ReplicationMigrationItemsUpdate_564527(
    name: "replicationMigrationItemsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationMigrationItems/{migrationItemName}",
    validator: validate_ReplicationMigrationItemsUpdate_564528, base: "",
    url: url_ReplicationMigrationItemsUpdate_564529, schemes: {Scheme.Https})
type
  Call_ReplicationMigrationItemsDelete_564512 = ref object of OpenApiRestCall_563566
proc url_ReplicationMigrationItemsDelete_564514(protocol: Scheme; host: string;
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
  assert "migrationItemName" in path,
        "`migrationItemName` is a required path parameter"
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
               (kind: ConstantSegment, value: "/replicationMigrationItems/"),
               (kind: VariableSegment, value: "migrationItemName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationMigrationItemsDelete_564513(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete an ASR migration item.
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
  ##   migrationItemName: JString (required)
  ##                    : Migration item name.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564515 = path.getOrDefault("protectionContainerName")
  valid_564515 = validateParameter(valid_564515, JString, required = true,
                                 default = nil)
  if valid_564515 != nil:
    section.add "protectionContainerName", valid_564515
  var valid_564516 = path.getOrDefault("fabricName")
  valid_564516 = validateParameter(valid_564516, JString, required = true,
                                 default = nil)
  if valid_564516 != nil:
    section.add "fabricName", valid_564516
  var valid_564517 = path.getOrDefault("subscriptionId")
  valid_564517 = validateParameter(valid_564517, JString, required = true,
                                 default = nil)
  if valid_564517 != nil:
    section.add "subscriptionId", valid_564517
  var valid_564518 = path.getOrDefault("resourceGroupName")
  valid_564518 = validateParameter(valid_564518, JString, required = true,
                                 default = nil)
  if valid_564518 != nil:
    section.add "resourceGroupName", valid_564518
  var valid_564519 = path.getOrDefault("migrationItemName")
  valid_564519 = validateParameter(valid_564519, JString, required = true,
                                 default = nil)
  if valid_564519 != nil:
    section.add "migrationItemName", valid_564519
  var valid_564520 = path.getOrDefault("resourceName")
  valid_564520 = validateParameter(valid_564520, JString, required = true,
                                 default = nil)
  if valid_564520 != nil:
    section.add "resourceName", valid_564520
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   deleteOption: JString
  ##               : The delete option.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564521 = query.getOrDefault("api-version")
  valid_564521 = validateParameter(valid_564521, JString, required = true,
                                 default = nil)
  if valid_564521 != nil:
    section.add "api-version", valid_564521
  var valid_564522 = query.getOrDefault("deleteOption")
  valid_564522 = validateParameter(valid_564522, JString, required = false,
                                 default = nil)
  if valid_564522 != nil:
    section.add "deleteOption", valid_564522
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564523: Call_ReplicationMigrationItemsDelete_564512;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete an ASR migration item.
  ## 
  let valid = call_564523.validator(path, query, header, formData, body)
  let scheme = call_564523.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564523.url(scheme.get, call_564523.host, call_564523.base,
                         call_564523.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564523, url, valid)

proc call*(call_564524: Call_ReplicationMigrationItemsDelete_564512;
          protectionContainerName: string; apiVersion: string; fabricName: string;
          subscriptionId: string; resourceGroupName: string;
          migrationItemName: string; resourceName: string; deleteOption: string = ""): Recallable =
  ## replicationMigrationItemsDelete
  ## The operation to delete an ASR migration item.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   deleteOption: string
  ##               : The delete option.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   migrationItemName: string (required)
  ##                    : Migration item name.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564525 = newJObject()
  var query_564526 = newJObject()
  add(path_564525, "protectionContainerName", newJString(protectionContainerName))
  add(query_564526, "api-version", newJString(apiVersion))
  add(path_564525, "fabricName", newJString(fabricName))
  add(query_564526, "deleteOption", newJString(deleteOption))
  add(path_564525, "subscriptionId", newJString(subscriptionId))
  add(path_564525, "resourceGroupName", newJString(resourceGroupName))
  add(path_564525, "migrationItemName", newJString(migrationItemName))
  add(path_564525, "resourceName", newJString(resourceName))
  result = call_564524.call(path_564525, query_564526, nil, nil, nil)

var replicationMigrationItemsDelete* = Call_ReplicationMigrationItemsDelete_564512(
    name: "replicationMigrationItemsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationMigrationItems/{migrationItemName}",
    validator: validate_ReplicationMigrationItemsDelete_564513, base: "",
    url: url_ReplicationMigrationItemsDelete_564514, schemes: {Scheme.Https})
type
  Call_ReplicationMigrationItemsMigrate_564543 = ref object of OpenApiRestCall_563566
proc url_ReplicationMigrationItemsMigrate_564545(protocol: Scheme; host: string;
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
  assert "migrationItemName" in path,
        "`migrationItemName` is a required path parameter"
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
               (kind: ConstantSegment, value: "/replicationMigrationItems/"),
               (kind: VariableSegment, value: "migrationItemName"),
               (kind: ConstantSegment, value: "/migrate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationMigrationItemsMigrate_564544(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to initiate migration of the item.
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
  ##   migrationItemName: JString (required)
  ##                    : Migration item name.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564546 = path.getOrDefault("protectionContainerName")
  valid_564546 = validateParameter(valid_564546, JString, required = true,
                                 default = nil)
  if valid_564546 != nil:
    section.add "protectionContainerName", valid_564546
  var valid_564547 = path.getOrDefault("fabricName")
  valid_564547 = validateParameter(valid_564547, JString, required = true,
                                 default = nil)
  if valid_564547 != nil:
    section.add "fabricName", valid_564547
  var valid_564548 = path.getOrDefault("subscriptionId")
  valid_564548 = validateParameter(valid_564548, JString, required = true,
                                 default = nil)
  if valid_564548 != nil:
    section.add "subscriptionId", valid_564548
  var valid_564549 = path.getOrDefault("resourceGroupName")
  valid_564549 = validateParameter(valid_564549, JString, required = true,
                                 default = nil)
  if valid_564549 != nil:
    section.add "resourceGroupName", valid_564549
  var valid_564550 = path.getOrDefault("migrationItemName")
  valid_564550 = validateParameter(valid_564550, JString, required = true,
                                 default = nil)
  if valid_564550 != nil:
    section.add "migrationItemName", valid_564550
  var valid_564551 = path.getOrDefault("resourceName")
  valid_564551 = validateParameter(valid_564551, JString, required = true,
                                 default = nil)
  if valid_564551 != nil:
    section.add "resourceName", valid_564551
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564552 = query.getOrDefault("api-version")
  valid_564552 = validateParameter(valid_564552, JString, required = true,
                                 default = nil)
  if valid_564552 != nil:
    section.add "api-version", valid_564552
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   migrateInput: JObject (required)
  ##               : Migrate input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564554: Call_ReplicationMigrationItemsMigrate_564543;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to initiate migration of the item.
  ## 
  let valid = call_564554.validator(path, query, header, formData, body)
  let scheme = call_564554.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564554.url(scheme.get, call_564554.host, call_564554.base,
                         call_564554.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564554, url, valid)

proc call*(call_564555: Call_ReplicationMigrationItemsMigrate_564543;
          protectionContainerName: string; apiVersion: string; fabricName: string;
          subscriptionId: string; resourceGroupName: string;
          migrationItemName: string; resourceName: string; migrateInput: JsonNode): Recallable =
  ## replicationMigrationItemsMigrate
  ## The operation to initiate migration of the item.
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
  ##   migrationItemName: string (required)
  ##                    : Migration item name.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   migrateInput: JObject (required)
  ##               : Migrate input.
  var path_564556 = newJObject()
  var query_564557 = newJObject()
  var body_564558 = newJObject()
  add(path_564556, "protectionContainerName", newJString(protectionContainerName))
  add(query_564557, "api-version", newJString(apiVersion))
  add(path_564556, "fabricName", newJString(fabricName))
  add(path_564556, "subscriptionId", newJString(subscriptionId))
  add(path_564556, "resourceGroupName", newJString(resourceGroupName))
  add(path_564556, "migrationItemName", newJString(migrationItemName))
  add(path_564556, "resourceName", newJString(resourceName))
  if migrateInput != nil:
    body_564558 = migrateInput
  result = call_564555.call(path_564556, query_564557, nil, nil, body_564558)

var replicationMigrationItemsMigrate* = Call_ReplicationMigrationItemsMigrate_564543(
    name: "replicationMigrationItemsMigrate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationMigrationItems/{migrationItemName}/migrate",
    validator: validate_ReplicationMigrationItemsMigrate_564544, base: "",
    url: url_ReplicationMigrationItemsMigrate_564545, schemes: {Scheme.Https})
type
  Call_MigrationRecoveryPointsListByReplicationMigrationItems_564559 = ref object of OpenApiRestCall_563566
proc url_MigrationRecoveryPointsListByReplicationMigrationItems_564561(
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
  assert "migrationItemName" in path,
        "`migrationItemName` is a required path parameter"
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
               (kind: ConstantSegment, value: "/replicationMigrationItems/"),
               (kind: VariableSegment, value: "migrationItemName"),
               (kind: ConstantSegment, value: "/migrationRecoveryPoints")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MigrationRecoveryPointsListByReplicationMigrationItems_564560(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   fabricName: JString (required)
  ##             : Fabric unique name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   migrationItemName: JString (required)
  ##                    : Migration item name.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564562 = path.getOrDefault("protectionContainerName")
  valid_564562 = validateParameter(valid_564562, JString, required = true,
                                 default = nil)
  if valid_564562 != nil:
    section.add "protectionContainerName", valid_564562
  var valid_564563 = path.getOrDefault("fabricName")
  valid_564563 = validateParameter(valid_564563, JString, required = true,
                                 default = nil)
  if valid_564563 != nil:
    section.add "fabricName", valid_564563
  var valid_564564 = path.getOrDefault("subscriptionId")
  valid_564564 = validateParameter(valid_564564, JString, required = true,
                                 default = nil)
  if valid_564564 != nil:
    section.add "subscriptionId", valid_564564
  var valid_564565 = path.getOrDefault("resourceGroupName")
  valid_564565 = validateParameter(valid_564565, JString, required = true,
                                 default = nil)
  if valid_564565 != nil:
    section.add "resourceGroupName", valid_564565
  var valid_564566 = path.getOrDefault("migrationItemName")
  valid_564566 = validateParameter(valid_564566, JString, required = true,
                                 default = nil)
  if valid_564566 != nil:
    section.add "migrationItemName", valid_564566
  var valid_564567 = path.getOrDefault("resourceName")
  valid_564567 = validateParameter(valid_564567, JString, required = true,
                                 default = nil)
  if valid_564567 != nil:
    section.add "resourceName", valid_564567
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564568 = query.getOrDefault("api-version")
  valid_564568 = validateParameter(valid_564568, JString, required = true,
                                 default = nil)
  if valid_564568 != nil:
    section.add "api-version", valid_564568
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564569: Call_MigrationRecoveryPointsListByReplicationMigrationItems_564559;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_564569.validator(path, query, header, formData, body)
  let scheme = call_564569.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564569.url(scheme.get, call_564569.host, call_564569.base,
                         call_564569.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564569, url, valid)

proc call*(call_564570: Call_MigrationRecoveryPointsListByReplicationMigrationItems_564559;
          protectionContainerName: string; apiVersion: string; fabricName: string;
          subscriptionId: string; resourceGroupName: string;
          migrationItemName: string; resourceName: string): Recallable =
  ## migrationRecoveryPointsListByReplicationMigrationItems
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric unique name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   migrationItemName: string (required)
  ##                    : Migration item name.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564571 = newJObject()
  var query_564572 = newJObject()
  add(path_564571, "protectionContainerName", newJString(protectionContainerName))
  add(query_564572, "api-version", newJString(apiVersion))
  add(path_564571, "fabricName", newJString(fabricName))
  add(path_564571, "subscriptionId", newJString(subscriptionId))
  add(path_564571, "resourceGroupName", newJString(resourceGroupName))
  add(path_564571, "migrationItemName", newJString(migrationItemName))
  add(path_564571, "resourceName", newJString(resourceName))
  result = call_564570.call(path_564571, query_564572, nil, nil, nil)

var migrationRecoveryPointsListByReplicationMigrationItems* = Call_MigrationRecoveryPointsListByReplicationMigrationItems_564559(
    name: "migrationRecoveryPointsListByReplicationMigrationItems",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationMigrationItems/{migrationItemName}/migrationRecoveryPoints",
    validator: validate_MigrationRecoveryPointsListByReplicationMigrationItems_564560,
    base: "", url: url_MigrationRecoveryPointsListByReplicationMigrationItems_564561,
    schemes: {Scheme.Https})
type
  Call_MigrationRecoveryPointsGet_564573 = ref object of OpenApiRestCall_563566
proc url_MigrationRecoveryPointsGet_564575(protocol: Scheme; host: string;
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
  assert "migrationItemName" in path,
        "`migrationItemName` is a required path parameter"
  assert "migrationRecoveryPointName" in path,
        "`migrationRecoveryPointName` is a required path parameter"
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
               (kind: ConstantSegment, value: "/replicationMigrationItems/"),
               (kind: VariableSegment, value: "migrationItemName"),
               (kind: ConstantSegment, value: "/migrationRecoveryPoints/"),
               (kind: VariableSegment, value: "migrationRecoveryPointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MigrationRecoveryPointsGet_564574(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   fabricName: JString (required)
  ##             : Fabric unique name.
  ##   migrationRecoveryPointName: JString (required)
  ##                             : The migration recovery point name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   migrationItemName: JString (required)
  ##                    : Migration item name.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564576 = path.getOrDefault("protectionContainerName")
  valid_564576 = validateParameter(valid_564576, JString, required = true,
                                 default = nil)
  if valid_564576 != nil:
    section.add "protectionContainerName", valid_564576
  var valid_564577 = path.getOrDefault("fabricName")
  valid_564577 = validateParameter(valid_564577, JString, required = true,
                                 default = nil)
  if valid_564577 != nil:
    section.add "fabricName", valid_564577
  var valid_564578 = path.getOrDefault("migrationRecoveryPointName")
  valid_564578 = validateParameter(valid_564578, JString, required = true,
                                 default = nil)
  if valid_564578 != nil:
    section.add "migrationRecoveryPointName", valid_564578
  var valid_564579 = path.getOrDefault("subscriptionId")
  valid_564579 = validateParameter(valid_564579, JString, required = true,
                                 default = nil)
  if valid_564579 != nil:
    section.add "subscriptionId", valid_564579
  var valid_564580 = path.getOrDefault("resourceGroupName")
  valid_564580 = validateParameter(valid_564580, JString, required = true,
                                 default = nil)
  if valid_564580 != nil:
    section.add "resourceGroupName", valid_564580
  var valid_564581 = path.getOrDefault("migrationItemName")
  valid_564581 = validateParameter(valid_564581, JString, required = true,
                                 default = nil)
  if valid_564581 != nil:
    section.add "migrationItemName", valid_564581
  var valid_564582 = path.getOrDefault("resourceName")
  valid_564582 = validateParameter(valid_564582, JString, required = true,
                                 default = nil)
  if valid_564582 != nil:
    section.add "resourceName", valid_564582
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564583 = query.getOrDefault("api-version")
  valid_564583 = validateParameter(valid_564583, JString, required = true,
                                 default = nil)
  if valid_564583 != nil:
    section.add "api-version", valid_564583
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564584: Call_MigrationRecoveryPointsGet_564573; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564584.validator(path, query, header, formData, body)
  let scheme = call_564584.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564584.url(scheme.get, call_564584.host, call_564584.base,
                         call_564584.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564584, url, valid)

proc call*(call_564585: Call_MigrationRecoveryPointsGet_564573;
          protectionContainerName: string; apiVersion: string; fabricName: string;
          migrationRecoveryPointName: string; subscriptionId: string;
          resourceGroupName: string; migrationItemName: string; resourceName: string): Recallable =
  ## migrationRecoveryPointsGet
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric unique name.
  ##   migrationRecoveryPointName: string (required)
  ##                             : The migration recovery point name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   migrationItemName: string (required)
  ##                    : Migration item name.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564586 = newJObject()
  var query_564587 = newJObject()
  add(path_564586, "protectionContainerName", newJString(protectionContainerName))
  add(query_564587, "api-version", newJString(apiVersion))
  add(path_564586, "fabricName", newJString(fabricName))
  add(path_564586, "migrationRecoveryPointName",
      newJString(migrationRecoveryPointName))
  add(path_564586, "subscriptionId", newJString(subscriptionId))
  add(path_564586, "resourceGroupName", newJString(resourceGroupName))
  add(path_564586, "migrationItemName", newJString(migrationItemName))
  add(path_564586, "resourceName", newJString(resourceName))
  result = call_564585.call(path_564586, query_564587, nil, nil, nil)

var migrationRecoveryPointsGet* = Call_MigrationRecoveryPointsGet_564573(
    name: "migrationRecoveryPointsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationMigrationItems/{migrationItemName}/migrationRecoveryPoints/{migrationRecoveryPointName}",
    validator: validate_MigrationRecoveryPointsGet_564574, base: "",
    url: url_MigrationRecoveryPointsGet_564575, schemes: {Scheme.Https})
type
  Call_ReplicationMigrationItemsTestMigrate_564588 = ref object of OpenApiRestCall_563566
proc url_ReplicationMigrationItemsTestMigrate_564590(protocol: Scheme;
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
  assert "migrationItemName" in path,
        "`migrationItemName` is a required path parameter"
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
               (kind: ConstantSegment, value: "/replicationMigrationItems/"),
               (kind: VariableSegment, value: "migrationItemName"),
               (kind: ConstantSegment, value: "/testMigrate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationMigrationItemsTestMigrate_564589(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to initiate test migration of the item.
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
  ##   migrationItemName: JString (required)
  ##                    : Migration item name.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564591 = path.getOrDefault("protectionContainerName")
  valid_564591 = validateParameter(valid_564591, JString, required = true,
                                 default = nil)
  if valid_564591 != nil:
    section.add "protectionContainerName", valid_564591
  var valid_564592 = path.getOrDefault("fabricName")
  valid_564592 = validateParameter(valid_564592, JString, required = true,
                                 default = nil)
  if valid_564592 != nil:
    section.add "fabricName", valid_564592
  var valid_564593 = path.getOrDefault("subscriptionId")
  valid_564593 = validateParameter(valid_564593, JString, required = true,
                                 default = nil)
  if valid_564593 != nil:
    section.add "subscriptionId", valid_564593
  var valid_564594 = path.getOrDefault("resourceGroupName")
  valid_564594 = validateParameter(valid_564594, JString, required = true,
                                 default = nil)
  if valid_564594 != nil:
    section.add "resourceGroupName", valid_564594
  var valid_564595 = path.getOrDefault("migrationItemName")
  valid_564595 = validateParameter(valid_564595, JString, required = true,
                                 default = nil)
  if valid_564595 != nil:
    section.add "migrationItemName", valid_564595
  var valid_564596 = path.getOrDefault("resourceName")
  valid_564596 = validateParameter(valid_564596, JString, required = true,
                                 default = nil)
  if valid_564596 != nil:
    section.add "resourceName", valid_564596
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564597 = query.getOrDefault("api-version")
  valid_564597 = validateParameter(valid_564597, JString, required = true,
                                 default = nil)
  if valid_564597 != nil:
    section.add "api-version", valid_564597
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   testMigrateInput: JObject (required)
  ##                   : Test migrate input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564599: Call_ReplicationMigrationItemsTestMigrate_564588;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to initiate test migration of the item.
  ## 
  let valid = call_564599.validator(path, query, header, formData, body)
  let scheme = call_564599.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564599.url(scheme.get, call_564599.host, call_564599.base,
                         call_564599.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564599, url, valid)

proc call*(call_564600: Call_ReplicationMigrationItemsTestMigrate_564588;
          protectionContainerName: string; apiVersion: string;
          testMigrateInput: JsonNode; fabricName: string; subscriptionId: string;
          resourceGroupName: string; migrationItemName: string; resourceName: string): Recallable =
  ## replicationMigrationItemsTestMigrate
  ## The operation to initiate test migration of the item.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   testMigrateInput: JObject (required)
  ##                   : Test migrate input.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   migrationItemName: string (required)
  ##                    : Migration item name.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564601 = newJObject()
  var query_564602 = newJObject()
  var body_564603 = newJObject()
  add(path_564601, "protectionContainerName", newJString(protectionContainerName))
  add(query_564602, "api-version", newJString(apiVersion))
  if testMigrateInput != nil:
    body_564603 = testMigrateInput
  add(path_564601, "fabricName", newJString(fabricName))
  add(path_564601, "subscriptionId", newJString(subscriptionId))
  add(path_564601, "resourceGroupName", newJString(resourceGroupName))
  add(path_564601, "migrationItemName", newJString(migrationItemName))
  add(path_564601, "resourceName", newJString(resourceName))
  result = call_564600.call(path_564601, query_564602, nil, nil, body_564603)

var replicationMigrationItemsTestMigrate* = Call_ReplicationMigrationItemsTestMigrate_564588(
    name: "replicationMigrationItemsTestMigrate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationMigrationItems/{migrationItemName}/testMigrate",
    validator: validate_ReplicationMigrationItemsTestMigrate_564589, base: "",
    url: url_ReplicationMigrationItemsTestMigrate_564590, schemes: {Scheme.Https})
type
  Call_ReplicationMigrationItemsTestMigrateCleanup_564604 = ref object of OpenApiRestCall_563566
proc url_ReplicationMigrationItemsTestMigrateCleanup_564606(protocol: Scheme;
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
  assert "migrationItemName" in path,
        "`migrationItemName` is a required path parameter"
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
               (kind: ConstantSegment, value: "/replicationMigrationItems/"),
               (kind: VariableSegment, value: "migrationItemName"),
               (kind: ConstantSegment, value: "/testMigrateCleanup")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationMigrationItemsTestMigrateCleanup_564605(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to initiate test migrate cleanup.
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
  ##   migrationItemName: JString (required)
  ##                    : Migration item name.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `protectionContainerName` field"
  var valid_564607 = path.getOrDefault("protectionContainerName")
  valid_564607 = validateParameter(valid_564607, JString, required = true,
                                 default = nil)
  if valid_564607 != nil:
    section.add "protectionContainerName", valid_564607
  var valid_564608 = path.getOrDefault("fabricName")
  valid_564608 = validateParameter(valid_564608, JString, required = true,
                                 default = nil)
  if valid_564608 != nil:
    section.add "fabricName", valid_564608
  var valid_564609 = path.getOrDefault("subscriptionId")
  valid_564609 = validateParameter(valid_564609, JString, required = true,
                                 default = nil)
  if valid_564609 != nil:
    section.add "subscriptionId", valid_564609
  var valid_564610 = path.getOrDefault("resourceGroupName")
  valid_564610 = validateParameter(valid_564610, JString, required = true,
                                 default = nil)
  if valid_564610 != nil:
    section.add "resourceGroupName", valid_564610
  var valid_564611 = path.getOrDefault("migrationItemName")
  valid_564611 = validateParameter(valid_564611, JString, required = true,
                                 default = nil)
  if valid_564611 != nil:
    section.add "migrationItemName", valid_564611
  var valid_564612 = path.getOrDefault("resourceName")
  valid_564612 = validateParameter(valid_564612, JString, required = true,
                                 default = nil)
  if valid_564612 != nil:
    section.add "resourceName", valid_564612
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564613 = query.getOrDefault("api-version")
  valid_564613 = validateParameter(valid_564613, JString, required = true,
                                 default = nil)
  if valid_564613 != nil:
    section.add "api-version", valid_564613
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   testMigrateCleanupInput: JObject (required)
  ##                          : Test migrate cleanup input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564615: Call_ReplicationMigrationItemsTestMigrateCleanup_564604;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to initiate test migrate cleanup.
  ## 
  let valid = call_564615.validator(path, query, header, formData, body)
  let scheme = call_564615.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564615.url(scheme.get, call_564615.host, call_564615.base,
                         call_564615.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564615, url, valid)

proc call*(call_564616: Call_ReplicationMigrationItemsTestMigrateCleanup_564604;
          protectionContainerName: string; apiVersion: string; fabricName: string;
          subscriptionId: string; resourceGroupName: string;
          migrationItemName: string; resourceName: string;
          testMigrateCleanupInput: JsonNode): Recallable =
  ## replicationMigrationItemsTestMigrateCleanup
  ## The operation to initiate test migrate cleanup.
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
  ##   migrationItemName: string (required)
  ##                    : Migration item name.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   testMigrateCleanupInput: JObject (required)
  ##                          : Test migrate cleanup input.
  var path_564617 = newJObject()
  var query_564618 = newJObject()
  var body_564619 = newJObject()
  add(path_564617, "protectionContainerName", newJString(protectionContainerName))
  add(query_564618, "api-version", newJString(apiVersion))
  add(path_564617, "fabricName", newJString(fabricName))
  add(path_564617, "subscriptionId", newJString(subscriptionId))
  add(path_564617, "resourceGroupName", newJString(resourceGroupName))
  add(path_564617, "migrationItemName", newJString(migrationItemName))
  add(path_564617, "resourceName", newJString(resourceName))
  if testMigrateCleanupInput != nil:
    body_564619 = testMigrateCleanupInput
  result = call_564616.call(path_564617, query_564618, nil, nil, body_564619)

var replicationMigrationItemsTestMigrateCleanup* = Call_ReplicationMigrationItemsTestMigrateCleanup_564604(
    name: "replicationMigrationItemsTestMigrateCleanup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationMigrationItems/{migrationItemName}/testMigrateCleanup",
    validator: validate_ReplicationMigrationItemsTestMigrateCleanup_564605,
    base: "", url: url_ReplicationMigrationItemsTestMigrateCleanup_564606,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectableItemsListByReplicationProtectionContainers_564620 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectableItemsListByReplicationProtectionContainers_564622(
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

proc validate_ReplicationProtectableItemsListByReplicationProtectionContainers_564621(
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
  var valid_564623 = path.getOrDefault("protectionContainerName")
  valid_564623 = validateParameter(valid_564623, JString, required = true,
                                 default = nil)
  if valid_564623 != nil:
    section.add "protectionContainerName", valid_564623
  var valid_564624 = path.getOrDefault("fabricName")
  valid_564624 = validateParameter(valid_564624, JString, required = true,
                                 default = nil)
  if valid_564624 != nil:
    section.add "fabricName", valid_564624
  var valid_564625 = path.getOrDefault("subscriptionId")
  valid_564625 = validateParameter(valid_564625, JString, required = true,
                                 default = nil)
  if valid_564625 != nil:
    section.add "subscriptionId", valid_564625
  var valid_564626 = path.getOrDefault("resourceGroupName")
  valid_564626 = validateParameter(valid_564626, JString, required = true,
                                 default = nil)
  if valid_564626 != nil:
    section.add "resourceGroupName", valid_564626
  var valid_564627 = path.getOrDefault("resourceName")
  valid_564627 = validateParameter(valid_564627, JString, required = true,
                                 default = nil)
  if valid_564627 != nil:
    section.add "resourceName", valid_564627
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564628 = query.getOrDefault("api-version")
  valid_564628 = validateParameter(valid_564628, JString, required = true,
                                 default = nil)
  if valid_564628 != nil:
    section.add "api-version", valid_564628
  var valid_564629 = query.getOrDefault("$filter")
  valid_564629 = validateParameter(valid_564629, JString, required = false,
                                 default = nil)
  if valid_564629 != nil:
    section.add "$filter", valid_564629
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564630: Call_ReplicationProtectableItemsListByReplicationProtectionContainers_564620;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the protectable items in a protection container.
  ## 
  let valid = call_564630.validator(path, query, header, formData, body)
  let scheme = call_564630.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564630.url(scheme.get, call_564630.host, call_564630.base,
                         call_564630.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564630, url, valid)

proc call*(call_564631: Call_ReplicationProtectableItemsListByReplicationProtectionContainers_564620;
          protectionContainerName: string; apiVersion: string; fabricName: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string;
          Filter: string = ""): Recallable =
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
  ##   Filter: string
  ##         : OData filter options.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_564632 = newJObject()
  var query_564633 = newJObject()
  add(path_564632, "protectionContainerName", newJString(protectionContainerName))
  add(query_564633, "api-version", newJString(apiVersion))
  add(path_564632, "fabricName", newJString(fabricName))
  add(path_564632, "subscriptionId", newJString(subscriptionId))
  add(path_564632, "resourceGroupName", newJString(resourceGroupName))
  add(query_564633, "$filter", newJString(Filter))
  add(path_564632, "resourceName", newJString(resourceName))
  result = call_564631.call(path_564632, query_564633, nil, nil, nil)

var replicationProtectableItemsListByReplicationProtectionContainers* = Call_ReplicationProtectableItemsListByReplicationProtectionContainers_564620(
    name: "replicationProtectableItemsListByReplicationProtectionContainers",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectableItems", validator: validate_ReplicationProtectableItemsListByReplicationProtectionContainers_564621,
    base: "",
    url: url_ReplicationProtectableItemsListByReplicationProtectionContainers_564622,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectableItemsGet_564634 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectableItemsGet_564636(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectableItemsGet_564635(path: JsonNode;
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
  var valid_564637 = path.getOrDefault("protectionContainerName")
  valid_564637 = validateParameter(valid_564637, JString, required = true,
                                 default = nil)
  if valid_564637 != nil:
    section.add "protectionContainerName", valid_564637
  var valid_564638 = path.getOrDefault("fabricName")
  valid_564638 = validateParameter(valid_564638, JString, required = true,
                                 default = nil)
  if valid_564638 != nil:
    section.add "fabricName", valid_564638
  var valid_564639 = path.getOrDefault("subscriptionId")
  valid_564639 = validateParameter(valid_564639, JString, required = true,
                                 default = nil)
  if valid_564639 != nil:
    section.add "subscriptionId", valid_564639
  var valid_564640 = path.getOrDefault("resourceGroupName")
  valid_564640 = validateParameter(valid_564640, JString, required = true,
                                 default = nil)
  if valid_564640 != nil:
    section.add "resourceGroupName", valid_564640
  var valid_564641 = path.getOrDefault("resourceName")
  valid_564641 = validateParameter(valid_564641, JString, required = true,
                                 default = nil)
  if valid_564641 != nil:
    section.add "resourceName", valid_564641
  var valid_564642 = path.getOrDefault("protectableItemName")
  valid_564642 = validateParameter(valid_564642, JString, required = true,
                                 default = nil)
  if valid_564642 != nil:
    section.add "protectableItemName", valid_564642
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564643 = query.getOrDefault("api-version")
  valid_564643 = validateParameter(valid_564643, JString, required = true,
                                 default = nil)
  if valid_564643 != nil:
    section.add "api-version", valid_564643
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564644: Call_ReplicationProtectableItemsGet_564634; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to get the details of a protectable item.
  ## 
  let valid = call_564644.validator(path, query, header, formData, body)
  let scheme = call_564644.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564644.url(scheme.get, call_564644.host, call_564644.base,
                         call_564644.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564644, url, valid)

proc call*(call_564645: Call_ReplicationProtectableItemsGet_564634;
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
  var path_564646 = newJObject()
  var query_564647 = newJObject()
  add(path_564646, "protectionContainerName", newJString(protectionContainerName))
  add(query_564647, "api-version", newJString(apiVersion))
  add(path_564646, "fabricName", newJString(fabricName))
  add(path_564646, "subscriptionId", newJString(subscriptionId))
  add(path_564646, "resourceGroupName", newJString(resourceGroupName))
  add(path_564646, "resourceName", newJString(resourceName))
  add(path_564646, "protectableItemName", newJString(protectableItemName))
  result = call_564645.call(path_564646, query_564647, nil, nil, nil)

var replicationProtectableItemsGet* = Call_ReplicationProtectableItemsGet_564634(
    name: "replicationProtectableItemsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectableItems/{protectableItemName}",
    validator: validate_ReplicationProtectableItemsGet_564635, base: "",
    url: url_ReplicationProtectableItemsGet_564636, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsListByReplicationProtectionContainers_564648 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectedItemsListByReplicationProtectionContainers_564650(
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

proc validate_ReplicationProtectedItemsListByReplicationProtectionContainers_564649(
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
  var valid_564651 = path.getOrDefault("protectionContainerName")
  valid_564651 = validateParameter(valid_564651, JString, required = true,
                                 default = nil)
  if valid_564651 != nil:
    section.add "protectionContainerName", valid_564651
  var valid_564652 = path.getOrDefault("fabricName")
  valid_564652 = validateParameter(valid_564652, JString, required = true,
                                 default = nil)
  if valid_564652 != nil:
    section.add "fabricName", valid_564652
  var valid_564653 = path.getOrDefault("subscriptionId")
  valid_564653 = validateParameter(valid_564653, JString, required = true,
                                 default = nil)
  if valid_564653 != nil:
    section.add "subscriptionId", valid_564653
  var valid_564654 = path.getOrDefault("resourceGroupName")
  valid_564654 = validateParameter(valid_564654, JString, required = true,
                                 default = nil)
  if valid_564654 != nil:
    section.add "resourceGroupName", valid_564654
  var valid_564655 = path.getOrDefault("resourceName")
  valid_564655 = validateParameter(valid_564655, JString, required = true,
                                 default = nil)
  if valid_564655 != nil:
    section.add "resourceName", valid_564655
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564656 = query.getOrDefault("api-version")
  valid_564656 = validateParameter(valid_564656, JString, required = true,
                                 default = nil)
  if valid_564656 != nil:
    section.add "api-version", valid_564656
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564657: Call_ReplicationProtectedItemsListByReplicationProtectionContainers_564648;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the list of ASR replication protected items in the protection container.
  ## 
  let valid = call_564657.validator(path, query, header, formData, body)
  let scheme = call_564657.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564657.url(scheme.get, call_564657.host, call_564657.base,
                         call_564657.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564657, url, valid)

proc call*(call_564658: Call_ReplicationProtectedItemsListByReplicationProtectionContainers_564648;
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
  var path_564659 = newJObject()
  var query_564660 = newJObject()
  add(path_564659, "protectionContainerName", newJString(protectionContainerName))
  add(query_564660, "api-version", newJString(apiVersion))
  add(path_564659, "fabricName", newJString(fabricName))
  add(path_564659, "subscriptionId", newJString(subscriptionId))
  add(path_564659, "resourceGroupName", newJString(resourceGroupName))
  add(path_564659, "resourceName", newJString(resourceName))
  result = call_564658.call(path_564659, query_564660, nil, nil, nil)

var replicationProtectedItemsListByReplicationProtectionContainers* = Call_ReplicationProtectedItemsListByReplicationProtectionContainers_564648(
    name: "replicationProtectedItemsListByReplicationProtectionContainers",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems", validator: validate_ReplicationProtectedItemsListByReplicationProtectionContainers_564649,
    base: "",
    url: url_ReplicationProtectedItemsListByReplicationProtectionContainers_564650,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsCreate_564675 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectedItemsCreate_564677(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectedItemsCreate_564676(path: JsonNode;
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
  var valid_564678 = path.getOrDefault("protectionContainerName")
  valid_564678 = validateParameter(valid_564678, JString, required = true,
                                 default = nil)
  if valid_564678 != nil:
    section.add "protectionContainerName", valid_564678
  var valid_564679 = path.getOrDefault("replicatedProtectedItemName")
  valid_564679 = validateParameter(valid_564679, JString, required = true,
                                 default = nil)
  if valid_564679 != nil:
    section.add "replicatedProtectedItemName", valid_564679
  var valid_564680 = path.getOrDefault("fabricName")
  valid_564680 = validateParameter(valid_564680, JString, required = true,
                                 default = nil)
  if valid_564680 != nil:
    section.add "fabricName", valid_564680
  var valid_564681 = path.getOrDefault("subscriptionId")
  valid_564681 = validateParameter(valid_564681, JString, required = true,
                                 default = nil)
  if valid_564681 != nil:
    section.add "subscriptionId", valid_564681
  var valid_564682 = path.getOrDefault("resourceGroupName")
  valid_564682 = validateParameter(valid_564682, JString, required = true,
                                 default = nil)
  if valid_564682 != nil:
    section.add "resourceGroupName", valid_564682
  var valid_564683 = path.getOrDefault("resourceName")
  valid_564683 = validateParameter(valid_564683, JString, required = true,
                                 default = nil)
  if valid_564683 != nil:
    section.add "resourceName", valid_564683
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564684 = query.getOrDefault("api-version")
  valid_564684 = validateParameter(valid_564684, JString, required = true,
                                 default = nil)
  if valid_564684 != nil:
    section.add "api-version", valid_564684
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

proc call*(call_564686: Call_ReplicationProtectedItemsCreate_564675;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create an ASR replication protected item (Enable replication).
  ## 
  let valid = call_564686.validator(path, query, header, formData, body)
  let scheme = call_564686.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564686.url(scheme.get, call_564686.host, call_564686.base,
                         call_564686.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564686, url, valid)

proc call*(call_564687: Call_ReplicationProtectedItemsCreate_564675;
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
  var path_564688 = newJObject()
  var query_564689 = newJObject()
  var body_564690 = newJObject()
  add(path_564688, "protectionContainerName", newJString(protectionContainerName))
  add(query_564689, "api-version", newJString(apiVersion))
  if input != nil:
    body_564690 = input
  add(path_564688, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564688, "fabricName", newJString(fabricName))
  add(path_564688, "subscriptionId", newJString(subscriptionId))
  add(path_564688, "resourceGroupName", newJString(resourceGroupName))
  add(path_564688, "resourceName", newJString(resourceName))
  result = call_564687.call(path_564688, query_564689, nil, nil, body_564690)

var replicationProtectedItemsCreate* = Call_ReplicationProtectedItemsCreate_564675(
    name: "replicationProtectedItemsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}",
    validator: validate_ReplicationProtectedItemsCreate_564676, base: "",
    url: url_ReplicationProtectedItemsCreate_564677, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsGet_564661 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectedItemsGet_564663(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectedItemsGet_564662(path: JsonNode; query: JsonNode;
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
  var valid_564664 = path.getOrDefault("protectionContainerName")
  valid_564664 = validateParameter(valid_564664, JString, required = true,
                                 default = nil)
  if valid_564664 != nil:
    section.add "protectionContainerName", valid_564664
  var valid_564665 = path.getOrDefault("replicatedProtectedItemName")
  valid_564665 = validateParameter(valid_564665, JString, required = true,
                                 default = nil)
  if valid_564665 != nil:
    section.add "replicatedProtectedItemName", valid_564665
  var valid_564666 = path.getOrDefault("fabricName")
  valid_564666 = validateParameter(valid_564666, JString, required = true,
                                 default = nil)
  if valid_564666 != nil:
    section.add "fabricName", valid_564666
  var valid_564667 = path.getOrDefault("subscriptionId")
  valid_564667 = validateParameter(valid_564667, JString, required = true,
                                 default = nil)
  if valid_564667 != nil:
    section.add "subscriptionId", valid_564667
  var valid_564668 = path.getOrDefault("resourceGroupName")
  valid_564668 = validateParameter(valid_564668, JString, required = true,
                                 default = nil)
  if valid_564668 != nil:
    section.add "resourceGroupName", valid_564668
  var valid_564669 = path.getOrDefault("resourceName")
  valid_564669 = validateParameter(valid_564669, JString, required = true,
                                 default = nil)
  if valid_564669 != nil:
    section.add "resourceName", valid_564669
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564670 = query.getOrDefault("api-version")
  valid_564670 = validateParameter(valid_564670, JString, required = true,
                                 default = nil)
  if valid_564670 != nil:
    section.add "api-version", valid_564670
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564671: Call_ReplicationProtectedItemsGet_564661; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of an ASR replication protected item.
  ## 
  let valid = call_564671.validator(path, query, header, formData, body)
  let scheme = call_564671.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564671.url(scheme.get, call_564671.host, call_564671.base,
                         call_564671.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564671, url, valid)

proc call*(call_564672: Call_ReplicationProtectedItemsGet_564661;
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
  var path_564673 = newJObject()
  var query_564674 = newJObject()
  add(path_564673, "protectionContainerName", newJString(protectionContainerName))
  add(query_564674, "api-version", newJString(apiVersion))
  add(path_564673, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564673, "fabricName", newJString(fabricName))
  add(path_564673, "subscriptionId", newJString(subscriptionId))
  add(path_564673, "resourceGroupName", newJString(resourceGroupName))
  add(path_564673, "resourceName", newJString(resourceName))
  result = call_564672.call(path_564673, query_564674, nil, nil, nil)

var replicationProtectedItemsGet* = Call_ReplicationProtectedItemsGet_564661(
    name: "replicationProtectedItemsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}",
    validator: validate_ReplicationProtectedItemsGet_564662, base: "",
    url: url_ReplicationProtectedItemsGet_564663, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsUpdate_564705 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectedItemsUpdate_564707(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectedItemsUpdate_564706(path: JsonNode;
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
  var valid_564708 = path.getOrDefault("protectionContainerName")
  valid_564708 = validateParameter(valid_564708, JString, required = true,
                                 default = nil)
  if valid_564708 != nil:
    section.add "protectionContainerName", valid_564708
  var valid_564709 = path.getOrDefault("replicatedProtectedItemName")
  valid_564709 = validateParameter(valid_564709, JString, required = true,
                                 default = nil)
  if valid_564709 != nil:
    section.add "replicatedProtectedItemName", valid_564709
  var valid_564710 = path.getOrDefault("fabricName")
  valid_564710 = validateParameter(valid_564710, JString, required = true,
                                 default = nil)
  if valid_564710 != nil:
    section.add "fabricName", valid_564710
  var valid_564711 = path.getOrDefault("subscriptionId")
  valid_564711 = validateParameter(valid_564711, JString, required = true,
                                 default = nil)
  if valid_564711 != nil:
    section.add "subscriptionId", valid_564711
  var valid_564712 = path.getOrDefault("resourceGroupName")
  valid_564712 = validateParameter(valid_564712, JString, required = true,
                                 default = nil)
  if valid_564712 != nil:
    section.add "resourceGroupName", valid_564712
  var valid_564713 = path.getOrDefault("resourceName")
  valid_564713 = validateParameter(valid_564713, JString, required = true,
                                 default = nil)
  if valid_564713 != nil:
    section.add "resourceName", valid_564713
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564714 = query.getOrDefault("api-version")
  valid_564714 = validateParameter(valid_564714, JString, required = true,
                                 default = nil)
  if valid_564714 != nil:
    section.add "api-version", valid_564714
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

proc call*(call_564716: Call_ReplicationProtectedItemsUpdate_564705;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to update the recovery settings of an ASR replication protected item.
  ## 
  let valid = call_564716.validator(path, query, header, formData, body)
  let scheme = call_564716.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564716.url(scheme.get, call_564716.host, call_564716.base,
                         call_564716.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564716, url, valid)

proc call*(call_564717: Call_ReplicationProtectedItemsUpdate_564705;
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
  var path_564718 = newJObject()
  var query_564719 = newJObject()
  var body_564720 = newJObject()
  add(path_564718, "protectionContainerName", newJString(protectionContainerName))
  add(query_564719, "api-version", newJString(apiVersion))
  if updateProtectionInput != nil:
    body_564720 = updateProtectionInput
  add(path_564718, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564718, "fabricName", newJString(fabricName))
  add(path_564718, "subscriptionId", newJString(subscriptionId))
  add(path_564718, "resourceGroupName", newJString(resourceGroupName))
  add(path_564718, "resourceName", newJString(resourceName))
  result = call_564717.call(path_564718, query_564719, nil, nil, body_564720)

var replicationProtectedItemsUpdate* = Call_ReplicationProtectedItemsUpdate_564705(
    name: "replicationProtectedItemsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}",
    validator: validate_ReplicationProtectedItemsUpdate_564706, base: "",
    url: url_ReplicationProtectedItemsUpdate_564707, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsPurge_564691 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectedItemsPurge_564693(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectedItemsPurge_564692(path: JsonNode;
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
  var valid_564694 = path.getOrDefault("protectionContainerName")
  valid_564694 = validateParameter(valid_564694, JString, required = true,
                                 default = nil)
  if valid_564694 != nil:
    section.add "protectionContainerName", valid_564694
  var valid_564695 = path.getOrDefault("replicatedProtectedItemName")
  valid_564695 = validateParameter(valid_564695, JString, required = true,
                                 default = nil)
  if valid_564695 != nil:
    section.add "replicatedProtectedItemName", valid_564695
  var valid_564696 = path.getOrDefault("fabricName")
  valid_564696 = validateParameter(valid_564696, JString, required = true,
                                 default = nil)
  if valid_564696 != nil:
    section.add "fabricName", valid_564696
  var valid_564697 = path.getOrDefault("subscriptionId")
  valid_564697 = validateParameter(valid_564697, JString, required = true,
                                 default = nil)
  if valid_564697 != nil:
    section.add "subscriptionId", valid_564697
  var valid_564698 = path.getOrDefault("resourceGroupName")
  valid_564698 = validateParameter(valid_564698, JString, required = true,
                                 default = nil)
  if valid_564698 != nil:
    section.add "resourceGroupName", valid_564698
  var valid_564699 = path.getOrDefault("resourceName")
  valid_564699 = validateParameter(valid_564699, JString, required = true,
                                 default = nil)
  if valid_564699 != nil:
    section.add "resourceName", valid_564699
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564700 = query.getOrDefault("api-version")
  valid_564700 = validateParameter(valid_564700, JString, required = true,
                                 default = nil)
  if valid_564700 != nil:
    section.add "api-version", valid_564700
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564701: Call_ReplicationProtectedItemsPurge_564691; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete or purge a replication protected item. This operation will force delete the replication protected item. Use the remove operation on replication protected item to perform a clean disable replication for the item.
  ## 
  let valid = call_564701.validator(path, query, header, formData, body)
  let scheme = call_564701.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564701.url(scheme.get, call_564701.host, call_564701.base,
                         call_564701.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564701, url, valid)

proc call*(call_564702: Call_ReplicationProtectedItemsPurge_564691;
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
  var path_564703 = newJObject()
  var query_564704 = newJObject()
  add(path_564703, "protectionContainerName", newJString(protectionContainerName))
  add(query_564704, "api-version", newJString(apiVersion))
  add(path_564703, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564703, "fabricName", newJString(fabricName))
  add(path_564703, "subscriptionId", newJString(subscriptionId))
  add(path_564703, "resourceGroupName", newJString(resourceGroupName))
  add(path_564703, "resourceName", newJString(resourceName))
  result = call_564702.call(path_564703, query_564704, nil, nil, nil)

var replicationProtectedItemsPurge* = Call_ReplicationProtectedItemsPurge_564691(
    name: "replicationProtectedItemsPurge", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}",
    validator: validate_ReplicationProtectedItemsPurge_564692, base: "",
    url: url_ReplicationProtectedItemsPurge_564693, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsApplyRecoveryPoint_564721 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectedItemsApplyRecoveryPoint_564723(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsApplyRecoveryPoint_564722(path: JsonNode;
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
  var valid_564724 = path.getOrDefault("protectionContainerName")
  valid_564724 = validateParameter(valid_564724, JString, required = true,
                                 default = nil)
  if valid_564724 != nil:
    section.add "protectionContainerName", valid_564724
  var valid_564725 = path.getOrDefault("replicatedProtectedItemName")
  valid_564725 = validateParameter(valid_564725, JString, required = true,
                                 default = nil)
  if valid_564725 != nil:
    section.add "replicatedProtectedItemName", valid_564725
  var valid_564726 = path.getOrDefault("fabricName")
  valid_564726 = validateParameter(valid_564726, JString, required = true,
                                 default = nil)
  if valid_564726 != nil:
    section.add "fabricName", valid_564726
  var valid_564727 = path.getOrDefault("subscriptionId")
  valid_564727 = validateParameter(valid_564727, JString, required = true,
                                 default = nil)
  if valid_564727 != nil:
    section.add "subscriptionId", valid_564727
  var valid_564728 = path.getOrDefault("resourceGroupName")
  valid_564728 = validateParameter(valid_564728, JString, required = true,
                                 default = nil)
  if valid_564728 != nil:
    section.add "resourceGroupName", valid_564728
  var valid_564729 = path.getOrDefault("resourceName")
  valid_564729 = validateParameter(valid_564729, JString, required = true,
                                 default = nil)
  if valid_564729 != nil:
    section.add "resourceName", valid_564729
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564730 = query.getOrDefault("api-version")
  valid_564730 = validateParameter(valid_564730, JString, required = true,
                                 default = nil)
  if valid_564730 != nil:
    section.add "api-version", valid_564730
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

proc call*(call_564732: Call_ReplicationProtectedItemsApplyRecoveryPoint_564721;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to change the recovery point of a failed over replication protected item.
  ## 
  let valid = call_564732.validator(path, query, header, formData, body)
  let scheme = call_564732.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564732.url(scheme.get, call_564732.host, call_564732.base,
                         call_564732.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564732, url, valid)

proc call*(call_564733: Call_ReplicationProtectedItemsApplyRecoveryPoint_564721;
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
  var path_564734 = newJObject()
  var query_564735 = newJObject()
  var body_564736 = newJObject()
  add(path_564734, "protectionContainerName", newJString(protectionContainerName))
  add(query_564735, "api-version", newJString(apiVersion))
  add(path_564734, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564734, "fabricName", newJString(fabricName))
  add(path_564734, "subscriptionId", newJString(subscriptionId))
  if applyRecoveryPointInput != nil:
    body_564736 = applyRecoveryPointInput
  add(path_564734, "resourceGroupName", newJString(resourceGroupName))
  add(path_564734, "resourceName", newJString(resourceName))
  result = call_564733.call(path_564734, query_564735, nil, nil, body_564736)

var replicationProtectedItemsApplyRecoveryPoint* = Call_ReplicationProtectedItemsApplyRecoveryPoint_564721(
    name: "replicationProtectedItemsApplyRecoveryPoint",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/applyRecoveryPoint",
    validator: validate_ReplicationProtectedItemsApplyRecoveryPoint_564722,
    base: "", url: url_ReplicationProtectedItemsApplyRecoveryPoint_564723,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsFailoverCommit_564737 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectedItemsFailoverCommit_564739(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsFailoverCommit_564738(path: JsonNode;
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
  var valid_564740 = path.getOrDefault("protectionContainerName")
  valid_564740 = validateParameter(valid_564740, JString, required = true,
                                 default = nil)
  if valid_564740 != nil:
    section.add "protectionContainerName", valid_564740
  var valid_564741 = path.getOrDefault("replicatedProtectedItemName")
  valid_564741 = validateParameter(valid_564741, JString, required = true,
                                 default = nil)
  if valid_564741 != nil:
    section.add "replicatedProtectedItemName", valid_564741
  var valid_564742 = path.getOrDefault("fabricName")
  valid_564742 = validateParameter(valid_564742, JString, required = true,
                                 default = nil)
  if valid_564742 != nil:
    section.add "fabricName", valid_564742
  var valid_564743 = path.getOrDefault("subscriptionId")
  valid_564743 = validateParameter(valid_564743, JString, required = true,
                                 default = nil)
  if valid_564743 != nil:
    section.add "subscriptionId", valid_564743
  var valid_564744 = path.getOrDefault("resourceGroupName")
  valid_564744 = validateParameter(valid_564744, JString, required = true,
                                 default = nil)
  if valid_564744 != nil:
    section.add "resourceGroupName", valid_564744
  var valid_564745 = path.getOrDefault("resourceName")
  valid_564745 = validateParameter(valid_564745, JString, required = true,
                                 default = nil)
  if valid_564745 != nil:
    section.add "resourceName", valid_564745
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564746 = query.getOrDefault("api-version")
  valid_564746 = validateParameter(valid_564746, JString, required = true,
                                 default = nil)
  if valid_564746 != nil:
    section.add "api-version", valid_564746
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564747: Call_ReplicationProtectedItemsFailoverCommit_564737;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to commit the failover of the replication protected item.
  ## 
  let valid = call_564747.validator(path, query, header, formData, body)
  let scheme = call_564747.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564747.url(scheme.get, call_564747.host, call_564747.base,
                         call_564747.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564747, url, valid)

proc call*(call_564748: Call_ReplicationProtectedItemsFailoverCommit_564737;
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
  var path_564749 = newJObject()
  var query_564750 = newJObject()
  add(path_564749, "protectionContainerName", newJString(protectionContainerName))
  add(query_564750, "api-version", newJString(apiVersion))
  add(path_564749, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564749, "fabricName", newJString(fabricName))
  add(path_564749, "subscriptionId", newJString(subscriptionId))
  add(path_564749, "resourceGroupName", newJString(resourceGroupName))
  add(path_564749, "resourceName", newJString(resourceName))
  result = call_564748.call(path_564749, query_564750, nil, nil, nil)

var replicationProtectedItemsFailoverCommit* = Call_ReplicationProtectedItemsFailoverCommit_564737(
    name: "replicationProtectedItemsFailoverCommit", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/failoverCommit",
    validator: validate_ReplicationProtectedItemsFailoverCommit_564738, base: "",
    url: url_ReplicationProtectedItemsFailoverCommit_564739,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsPlannedFailover_564751 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectedItemsPlannedFailover_564753(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsPlannedFailover_564752(path: JsonNode;
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
  var valid_564754 = path.getOrDefault("protectionContainerName")
  valid_564754 = validateParameter(valid_564754, JString, required = true,
                                 default = nil)
  if valid_564754 != nil:
    section.add "protectionContainerName", valid_564754
  var valid_564755 = path.getOrDefault("replicatedProtectedItemName")
  valid_564755 = validateParameter(valid_564755, JString, required = true,
                                 default = nil)
  if valid_564755 != nil:
    section.add "replicatedProtectedItemName", valid_564755
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
  ## parameters in `body` object:
  ##   failoverInput: JObject (required)
  ##                : Disable protection input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564762: Call_ReplicationProtectedItemsPlannedFailover_564751;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to initiate a planned failover of the replication protected item.
  ## 
  let valid = call_564762.validator(path, query, header, formData, body)
  let scheme = call_564762.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564762.url(scheme.get, call_564762.host, call_564762.base,
                         call_564762.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564762, url, valid)

proc call*(call_564763: Call_ReplicationProtectedItemsPlannedFailover_564751;
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
  var path_564764 = newJObject()
  var query_564765 = newJObject()
  var body_564766 = newJObject()
  add(path_564764, "protectionContainerName", newJString(protectionContainerName))
  add(query_564765, "api-version", newJString(apiVersion))
  add(path_564764, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564764, "fabricName", newJString(fabricName))
  add(path_564764, "subscriptionId", newJString(subscriptionId))
  add(path_564764, "resourceGroupName", newJString(resourceGroupName))
  if failoverInput != nil:
    body_564766 = failoverInput
  add(path_564764, "resourceName", newJString(resourceName))
  result = call_564763.call(path_564764, query_564765, nil, nil, body_564766)

var replicationProtectedItemsPlannedFailover* = Call_ReplicationProtectedItemsPlannedFailover_564751(
    name: "replicationProtectedItemsPlannedFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/plannedFailover",
    validator: validate_ReplicationProtectedItemsPlannedFailover_564752, base: "",
    url: url_ReplicationProtectedItemsPlannedFailover_564753,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsReprotect_564767 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectedItemsReprotect_564769(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectedItemsReprotect_564768(path: JsonNode;
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
  var valid_564770 = path.getOrDefault("protectionContainerName")
  valid_564770 = validateParameter(valid_564770, JString, required = true,
                                 default = nil)
  if valid_564770 != nil:
    section.add "protectionContainerName", valid_564770
  var valid_564771 = path.getOrDefault("replicatedProtectedItemName")
  valid_564771 = validateParameter(valid_564771, JString, required = true,
                                 default = nil)
  if valid_564771 != nil:
    section.add "replicatedProtectedItemName", valid_564771
  var valid_564772 = path.getOrDefault("fabricName")
  valid_564772 = validateParameter(valid_564772, JString, required = true,
                                 default = nil)
  if valid_564772 != nil:
    section.add "fabricName", valid_564772
  var valid_564773 = path.getOrDefault("subscriptionId")
  valid_564773 = validateParameter(valid_564773, JString, required = true,
                                 default = nil)
  if valid_564773 != nil:
    section.add "subscriptionId", valid_564773
  var valid_564774 = path.getOrDefault("resourceGroupName")
  valid_564774 = validateParameter(valid_564774, JString, required = true,
                                 default = nil)
  if valid_564774 != nil:
    section.add "resourceGroupName", valid_564774
  var valid_564775 = path.getOrDefault("resourceName")
  valid_564775 = validateParameter(valid_564775, JString, required = true,
                                 default = nil)
  if valid_564775 != nil:
    section.add "resourceName", valid_564775
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564776 = query.getOrDefault("api-version")
  valid_564776 = validateParameter(valid_564776, JString, required = true,
                                 default = nil)
  if valid_564776 != nil:
    section.add "api-version", valid_564776
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

proc call*(call_564778: Call_ReplicationProtectedItemsReprotect_564767;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to reprotect or reverse replicate a failed over replication protected item.
  ## 
  let valid = call_564778.validator(path, query, header, formData, body)
  let scheme = call_564778.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564778.url(scheme.get, call_564778.host, call_564778.base,
                         call_564778.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564778, url, valid)

proc call*(call_564779: Call_ReplicationProtectedItemsReprotect_564767;
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
  var path_564780 = newJObject()
  var query_564781 = newJObject()
  var body_564782 = newJObject()
  add(path_564780, "protectionContainerName", newJString(protectionContainerName))
  add(query_564781, "api-version", newJString(apiVersion))
  add(path_564780, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  if rrInput != nil:
    body_564782 = rrInput
  add(path_564780, "fabricName", newJString(fabricName))
  add(path_564780, "subscriptionId", newJString(subscriptionId))
  add(path_564780, "resourceGroupName", newJString(resourceGroupName))
  add(path_564780, "resourceName", newJString(resourceName))
  result = call_564779.call(path_564780, query_564781, nil, nil, body_564782)

var replicationProtectedItemsReprotect* = Call_ReplicationProtectedItemsReprotect_564767(
    name: "replicationProtectedItemsReprotect", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/reProtect",
    validator: validate_ReplicationProtectedItemsReprotect_564768, base: "",
    url: url_ReplicationProtectedItemsReprotect_564769, schemes: {Scheme.Https})
type
  Call_RecoveryPointsListByReplicationProtectedItems_564783 = ref object of OpenApiRestCall_563566
proc url_RecoveryPointsListByReplicationProtectedItems_564785(protocol: Scheme;
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

proc validate_RecoveryPointsListByReplicationProtectedItems_564784(
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
  var valid_564786 = path.getOrDefault("protectionContainerName")
  valid_564786 = validateParameter(valid_564786, JString, required = true,
                                 default = nil)
  if valid_564786 != nil:
    section.add "protectionContainerName", valid_564786
  var valid_564787 = path.getOrDefault("replicatedProtectedItemName")
  valid_564787 = validateParameter(valid_564787, JString, required = true,
                                 default = nil)
  if valid_564787 != nil:
    section.add "replicatedProtectedItemName", valid_564787
  var valid_564788 = path.getOrDefault("fabricName")
  valid_564788 = validateParameter(valid_564788, JString, required = true,
                                 default = nil)
  if valid_564788 != nil:
    section.add "fabricName", valid_564788
  var valid_564789 = path.getOrDefault("subscriptionId")
  valid_564789 = validateParameter(valid_564789, JString, required = true,
                                 default = nil)
  if valid_564789 != nil:
    section.add "subscriptionId", valid_564789
  var valid_564790 = path.getOrDefault("resourceGroupName")
  valid_564790 = validateParameter(valid_564790, JString, required = true,
                                 default = nil)
  if valid_564790 != nil:
    section.add "resourceGroupName", valid_564790
  var valid_564791 = path.getOrDefault("resourceName")
  valid_564791 = validateParameter(valid_564791, JString, required = true,
                                 default = nil)
  if valid_564791 != nil:
    section.add "resourceName", valid_564791
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564792 = query.getOrDefault("api-version")
  valid_564792 = validateParameter(valid_564792, JString, required = true,
                                 default = nil)
  if valid_564792 != nil:
    section.add "api-version", valid_564792
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564793: Call_RecoveryPointsListByReplicationProtectedItems_564783;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the available recovery points for a replication protected item.
  ## 
  let valid = call_564793.validator(path, query, header, formData, body)
  let scheme = call_564793.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564793.url(scheme.get, call_564793.host, call_564793.base,
                         call_564793.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564793, url, valid)

proc call*(call_564794: Call_RecoveryPointsListByReplicationProtectedItems_564783;
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
  var path_564795 = newJObject()
  var query_564796 = newJObject()
  add(path_564795, "protectionContainerName", newJString(protectionContainerName))
  add(query_564796, "api-version", newJString(apiVersion))
  add(path_564795, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564795, "fabricName", newJString(fabricName))
  add(path_564795, "subscriptionId", newJString(subscriptionId))
  add(path_564795, "resourceGroupName", newJString(resourceGroupName))
  add(path_564795, "resourceName", newJString(resourceName))
  result = call_564794.call(path_564795, query_564796, nil, nil, nil)

var recoveryPointsListByReplicationProtectedItems* = Call_RecoveryPointsListByReplicationProtectedItems_564783(
    name: "recoveryPointsListByReplicationProtectedItems",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/recoveryPoints",
    validator: validate_RecoveryPointsListByReplicationProtectedItems_564784,
    base: "", url: url_RecoveryPointsListByReplicationProtectedItems_564785,
    schemes: {Scheme.Https})
type
  Call_RecoveryPointsGet_564797 = ref object of OpenApiRestCall_563566
proc url_RecoveryPointsGet_564799(protocol: Scheme; host: string; base: string;
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

proc validate_RecoveryPointsGet_564798(path: JsonNode; query: JsonNode;
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
  var valid_564800 = path.getOrDefault("protectionContainerName")
  valid_564800 = validateParameter(valid_564800, JString, required = true,
                                 default = nil)
  if valid_564800 != nil:
    section.add "protectionContainerName", valid_564800
  var valid_564801 = path.getOrDefault("replicatedProtectedItemName")
  valid_564801 = validateParameter(valid_564801, JString, required = true,
                                 default = nil)
  if valid_564801 != nil:
    section.add "replicatedProtectedItemName", valid_564801
  var valid_564802 = path.getOrDefault("recoveryPointName")
  valid_564802 = validateParameter(valid_564802, JString, required = true,
                                 default = nil)
  if valid_564802 != nil:
    section.add "recoveryPointName", valid_564802
  var valid_564803 = path.getOrDefault("fabricName")
  valid_564803 = validateParameter(valid_564803, JString, required = true,
                                 default = nil)
  if valid_564803 != nil:
    section.add "fabricName", valid_564803
  var valid_564804 = path.getOrDefault("subscriptionId")
  valid_564804 = validateParameter(valid_564804, JString, required = true,
                                 default = nil)
  if valid_564804 != nil:
    section.add "subscriptionId", valid_564804
  var valid_564805 = path.getOrDefault("resourceGroupName")
  valid_564805 = validateParameter(valid_564805, JString, required = true,
                                 default = nil)
  if valid_564805 != nil:
    section.add "resourceGroupName", valid_564805
  var valid_564806 = path.getOrDefault("resourceName")
  valid_564806 = validateParameter(valid_564806, JString, required = true,
                                 default = nil)
  if valid_564806 != nil:
    section.add "resourceName", valid_564806
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564807 = query.getOrDefault("api-version")
  valid_564807 = validateParameter(valid_564807, JString, required = true,
                                 default = nil)
  if valid_564807 != nil:
    section.add "api-version", valid_564807
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564808: Call_RecoveryPointsGet_564797; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the details of specified recovery point.
  ## 
  let valid = call_564808.validator(path, query, header, formData, body)
  let scheme = call_564808.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564808.url(scheme.get, call_564808.host, call_564808.base,
                         call_564808.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564808, url, valid)

proc call*(call_564809: Call_RecoveryPointsGet_564797;
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
  var path_564810 = newJObject()
  var query_564811 = newJObject()
  add(path_564810, "protectionContainerName", newJString(protectionContainerName))
  add(query_564811, "api-version", newJString(apiVersion))
  add(path_564810, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564810, "recoveryPointName", newJString(recoveryPointName))
  add(path_564810, "fabricName", newJString(fabricName))
  add(path_564810, "subscriptionId", newJString(subscriptionId))
  add(path_564810, "resourceGroupName", newJString(resourceGroupName))
  add(path_564810, "resourceName", newJString(resourceName))
  result = call_564809.call(path_564810, query_564811, nil, nil, nil)

var recoveryPointsGet* = Call_RecoveryPointsGet_564797(name: "recoveryPointsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/recoveryPoints/{recoveryPointName}",
    validator: validate_RecoveryPointsGet_564798, base: "",
    url: url_RecoveryPointsGet_564799, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsDelete_564812 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectedItemsDelete_564814(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectedItemsDelete_564813(path: JsonNode;
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
  var valid_564815 = path.getOrDefault("protectionContainerName")
  valid_564815 = validateParameter(valid_564815, JString, required = true,
                                 default = nil)
  if valid_564815 != nil:
    section.add "protectionContainerName", valid_564815
  var valid_564816 = path.getOrDefault("replicatedProtectedItemName")
  valid_564816 = validateParameter(valid_564816, JString, required = true,
                                 default = nil)
  if valid_564816 != nil:
    section.add "replicatedProtectedItemName", valid_564816
  var valid_564817 = path.getOrDefault("fabricName")
  valid_564817 = validateParameter(valid_564817, JString, required = true,
                                 default = nil)
  if valid_564817 != nil:
    section.add "fabricName", valid_564817
  var valid_564818 = path.getOrDefault("subscriptionId")
  valid_564818 = validateParameter(valid_564818, JString, required = true,
                                 default = nil)
  if valid_564818 != nil:
    section.add "subscriptionId", valid_564818
  var valid_564819 = path.getOrDefault("resourceGroupName")
  valid_564819 = validateParameter(valid_564819, JString, required = true,
                                 default = nil)
  if valid_564819 != nil:
    section.add "resourceGroupName", valid_564819
  var valid_564820 = path.getOrDefault("resourceName")
  valid_564820 = validateParameter(valid_564820, JString, required = true,
                                 default = nil)
  if valid_564820 != nil:
    section.add "resourceName", valid_564820
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564821 = query.getOrDefault("api-version")
  valid_564821 = validateParameter(valid_564821, JString, required = true,
                                 default = nil)
  if valid_564821 != nil:
    section.add "api-version", valid_564821
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

proc call*(call_564823: Call_ReplicationProtectedItemsDelete_564812;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to disable replication on a replication protected item. This will also remove the item.
  ## 
  let valid = call_564823.validator(path, query, header, formData, body)
  let scheme = call_564823.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564823.url(scheme.get, call_564823.host, call_564823.base,
                         call_564823.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564823, url, valid)

proc call*(call_564824: Call_ReplicationProtectedItemsDelete_564812;
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
  var path_564825 = newJObject()
  var query_564826 = newJObject()
  var body_564827 = newJObject()
  add(path_564825, "protectionContainerName", newJString(protectionContainerName))
  add(query_564826, "api-version", newJString(apiVersion))
  add(path_564825, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564825, "fabricName", newJString(fabricName))
  if disableProtectionInput != nil:
    body_564827 = disableProtectionInput
  add(path_564825, "subscriptionId", newJString(subscriptionId))
  add(path_564825, "resourceGroupName", newJString(resourceGroupName))
  add(path_564825, "resourceName", newJString(resourceName))
  result = call_564824.call(path_564825, query_564826, nil, nil, body_564827)

var replicationProtectedItemsDelete* = Call_ReplicationProtectedItemsDelete_564812(
    name: "replicationProtectedItemsDelete", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/remove",
    validator: validate_ReplicationProtectedItemsDelete_564813, base: "",
    url: url_ReplicationProtectedItemsDelete_564814, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsRepairReplication_564828 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectedItemsRepairReplication_564830(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsRepairReplication_564829(path: JsonNode;
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
  var valid_564831 = path.getOrDefault("protectionContainerName")
  valid_564831 = validateParameter(valid_564831, JString, required = true,
                                 default = nil)
  if valid_564831 != nil:
    section.add "protectionContainerName", valid_564831
  var valid_564832 = path.getOrDefault("replicatedProtectedItemName")
  valid_564832 = validateParameter(valid_564832, JString, required = true,
                                 default = nil)
  if valid_564832 != nil:
    section.add "replicatedProtectedItemName", valid_564832
  var valid_564833 = path.getOrDefault("fabricName")
  valid_564833 = validateParameter(valid_564833, JString, required = true,
                                 default = nil)
  if valid_564833 != nil:
    section.add "fabricName", valid_564833
  var valid_564834 = path.getOrDefault("subscriptionId")
  valid_564834 = validateParameter(valid_564834, JString, required = true,
                                 default = nil)
  if valid_564834 != nil:
    section.add "subscriptionId", valid_564834
  var valid_564835 = path.getOrDefault("resourceGroupName")
  valid_564835 = validateParameter(valid_564835, JString, required = true,
                                 default = nil)
  if valid_564835 != nil:
    section.add "resourceGroupName", valid_564835
  var valid_564836 = path.getOrDefault("resourceName")
  valid_564836 = validateParameter(valid_564836, JString, required = true,
                                 default = nil)
  if valid_564836 != nil:
    section.add "resourceName", valid_564836
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564837 = query.getOrDefault("api-version")
  valid_564837 = validateParameter(valid_564837, JString, required = true,
                                 default = nil)
  if valid_564837 != nil:
    section.add "api-version", valid_564837
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564838: Call_ReplicationProtectedItemsRepairReplication_564828;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to start resynchronize/repair replication for a replication protected item requiring resynchronization.
  ## 
  let valid = call_564838.validator(path, query, header, formData, body)
  let scheme = call_564838.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564838.url(scheme.get, call_564838.host, call_564838.base,
                         call_564838.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564838, url, valid)

proc call*(call_564839: Call_ReplicationProtectedItemsRepairReplication_564828;
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
  var path_564840 = newJObject()
  var query_564841 = newJObject()
  add(path_564840, "protectionContainerName", newJString(protectionContainerName))
  add(query_564841, "api-version", newJString(apiVersion))
  add(path_564840, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564840, "fabricName", newJString(fabricName))
  add(path_564840, "subscriptionId", newJString(subscriptionId))
  add(path_564840, "resourceGroupName", newJString(resourceGroupName))
  add(path_564840, "resourceName", newJString(resourceName))
  result = call_564839.call(path_564840, query_564841, nil, nil, nil)

var replicationProtectedItemsRepairReplication* = Call_ReplicationProtectedItemsRepairReplication_564828(
    name: "replicationProtectedItemsRepairReplication", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/repairReplication",
    validator: validate_ReplicationProtectedItemsRepairReplication_564829,
    base: "", url: url_ReplicationProtectedItemsRepairReplication_564830,
    schemes: {Scheme.Https})
type
  Call_TargetComputeSizesListByReplicationProtectedItems_564842 = ref object of OpenApiRestCall_563566
proc url_TargetComputeSizesListByReplicationProtectedItems_564844(
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
               (kind: ConstantSegment, value: "/targetComputeSizes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TargetComputeSizesListByReplicationProtectedItems_564843(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the available target compute sizes for a replication protected item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   protectionContainerName: JString (required)
  ##                          : protection container name.
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
  var valid_564845 = path.getOrDefault("protectionContainerName")
  valid_564845 = validateParameter(valid_564845, JString, required = true,
                                 default = nil)
  if valid_564845 != nil:
    section.add "protectionContainerName", valid_564845
  var valid_564846 = path.getOrDefault("replicatedProtectedItemName")
  valid_564846 = validateParameter(valid_564846, JString, required = true,
                                 default = nil)
  if valid_564846 != nil:
    section.add "replicatedProtectedItemName", valid_564846
  var valid_564847 = path.getOrDefault("fabricName")
  valid_564847 = validateParameter(valid_564847, JString, required = true,
                                 default = nil)
  if valid_564847 != nil:
    section.add "fabricName", valid_564847
  var valid_564848 = path.getOrDefault("subscriptionId")
  valid_564848 = validateParameter(valid_564848, JString, required = true,
                                 default = nil)
  if valid_564848 != nil:
    section.add "subscriptionId", valid_564848
  var valid_564849 = path.getOrDefault("resourceGroupName")
  valid_564849 = validateParameter(valid_564849, JString, required = true,
                                 default = nil)
  if valid_564849 != nil:
    section.add "resourceGroupName", valid_564849
  var valid_564850 = path.getOrDefault("resourceName")
  valid_564850 = validateParameter(valid_564850, JString, required = true,
                                 default = nil)
  if valid_564850 != nil:
    section.add "resourceName", valid_564850
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564851 = query.getOrDefault("api-version")
  valid_564851 = validateParameter(valid_564851, JString, required = true,
                                 default = nil)
  if valid_564851 != nil:
    section.add "api-version", valid_564851
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564852: Call_TargetComputeSizesListByReplicationProtectedItems_564842;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the available target compute sizes for a replication protected item.
  ## 
  let valid = call_564852.validator(path, query, header, formData, body)
  let scheme = call_564852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564852.url(scheme.get, call_564852.host, call_564852.base,
                         call_564852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564852, url, valid)

proc call*(call_564853: Call_TargetComputeSizesListByReplicationProtectedItems_564842;
          protectionContainerName: string; apiVersion: string;
          replicatedProtectedItemName: string; fabricName: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## targetComputeSizesListByReplicationProtectedItems
  ## Lists the available target compute sizes for a replication protected item.
  ##   protectionContainerName: string (required)
  ##                          : protection container name.
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
  var path_564854 = newJObject()
  var query_564855 = newJObject()
  add(path_564854, "protectionContainerName", newJString(protectionContainerName))
  add(query_564855, "api-version", newJString(apiVersion))
  add(path_564854, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564854, "fabricName", newJString(fabricName))
  add(path_564854, "subscriptionId", newJString(subscriptionId))
  add(path_564854, "resourceGroupName", newJString(resourceGroupName))
  add(path_564854, "resourceName", newJString(resourceName))
  result = call_564853.call(path_564854, query_564855, nil, nil, nil)

var targetComputeSizesListByReplicationProtectedItems* = Call_TargetComputeSizesListByReplicationProtectedItems_564842(
    name: "targetComputeSizesListByReplicationProtectedItems",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/targetComputeSizes",
    validator: validate_TargetComputeSizesListByReplicationProtectedItems_564843,
    base: "", url: url_TargetComputeSizesListByReplicationProtectedItems_564844,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsTestFailover_564856 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectedItemsTestFailover_564858(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsTestFailover_564857(path: JsonNode;
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
  var valid_564859 = path.getOrDefault("protectionContainerName")
  valid_564859 = validateParameter(valid_564859, JString, required = true,
                                 default = nil)
  if valid_564859 != nil:
    section.add "protectionContainerName", valid_564859
  var valid_564860 = path.getOrDefault("replicatedProtectedItemName")
  valid_564860 = validateParameter(valid_564860, JString, required = true,
                                 default = nil)
  if valid_564860 != nil:
    section.add "replicatedProtectedItemName", valid_564860
  var valid_564861 = path.getOrDefault("fabricName")
  valid_564861 = validateParameter(valid_564861, JString, required = true,
                                 default = nil)
  if valid_564861 != nil:
    section.add "fabricName", valid_564861
  var valid_564862 = path.getOrDefault("subscriptionId")
  valid_564862 = validateParameter(valid_564862, JString, required = true,
                                 default = nil)
  if valid_564862 != nil:
    section.add "subscriptionId", valid_564862
  var valid_564863 = path.getOrDefault("resourceGroupName")
  valid_564863 = validateParameter(valid_564863, JString, required = true,
                                 default = nil)
  if valid_564863 != nil:
    section.add "resourceGroupName", valid_564863
  var valid_564864 = path.getOrDefault("resourceName")
  valid_564864 = validateParameter(valid_564864, JString, required = true,
                                 default = nil)
  if valid_564864 != nil:
    section.add "resourceName", valid_564864
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564865 = query.getOrDefault("api-version")
  valid_564865 = validateParameter(valid_564865, JString, required = true,
                                 default = nil)
  if valid_564865 != nil:
    section.add "api-version", valid_564865
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

proc call*(call_564867: Call_ReplicationProtectedItemsTestFailover_564856;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to perform a test failover of the replication protected item.
  ## 
  let valid = call_564867.validator(path, query, header, formData, body)
  let scheme = call_564867.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564867.url(scheme.get, call_564867.host, call_564867.base,
                         call_564867.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564867, url, valid)

proc call*(call_564868: Call_ReplicationProtectedItemsTestFailover_564856;
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
  var path_564869 = newJObject()
  var query_564870 = newJObject()
  var body_564871 = newJObject()
  add(path_564869, "protectionContainerName", newJString(protectionContainerName))
  add(query_564870, "api-version", newJString(apiVersion))
  add(path_564869, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564869, "fabricName", newJString(fabricName))
  add(path_564869, "subscriptionId", newJString(subscriptionId))
  add(path_564869, "resourceGroupName", newJString(resourceGroupName))
  if failoverInput != nil:
    body_564871 = failoverInput
  add(path_564869, "resourceName", newJString(resourceName))
  result = call_564868.call(path_564869, query_564870, nil, nil, body_564871)

var replicationProtectedItemsTestFailover* = Call_ReplicationProtectedItemsTestFailover_564856(
    name: "replicationProtectedItemsTestFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/testFailover",
    validator: validate_ReplicationProtectedItemsTestFailover_564857, base: "",
    url: url_ReplicationProtectedItemsTestFailover_564858, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsTestFailoverCleanup_564872 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectedItemsTestFailoverCleanup_564874(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsTestFailoverCleanup_564873(path: JsonNode;
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
  var valid_564875 = path.getOrDefault("protectionContainerName")
  valid_564875 = validateParameter(valid_564875, JString, required = true,
                                 default = nil)
  if valid_564875 != nil:
    section.add "protectionContainerName", valid_564875
  var valid_564876 = path.getOrDefault("replicatedProtectedItemName")
  valid_564876 = validateParameter(valid_564876, JString, required = true,
                                 default = nil)
  if valid_564876 != nil:
    section.add "replicatedProtectedItemName", valid_564876
  var valid_564877 = path.getOrDefault("fabricName")
  valid_564877 = validateParameter(valid_564877, JString, required = true,
                                 default = nil)
  if valid_564877 != nil:
    section.add "fabricName", valid_564877
  var valid_564878 = path.getOrDefault("subscriptionId")
  valid_564878 = validateParameter(valid_564878, JString, required = true,
                                 default = nil)
  if valid_564878 != nil:
    section.add "subscriptionId", valid_564878
  var valid_564879 = path.getOrDefault("resourceGroupName")
  valid_564879 = validateParameter(valid_564879, JString, required = true,
                                 default = nil)
  if valid_564879 != nil:
    section.add "resourceGroupName", valid_564879
  var valid_564880 = path.getOrDefault("resourceName")
  valid_564880 = validateParameter(valid_564880, JString, required = true,
                                 default = nil)
  if valid_564880 != nil:
    section.add "resourceName", valid_564880
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564881 = query.getOrDefault("api-version")
  valid_564881 = validateParameter(valid_564881, JString, required = true,
                                 default = nil)
  if valid_564881 != nil:
    section.add "api-version", valid_564881
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

proc call*(call_564883: Call_ReplicationProtectedItemsTestFailoverCleanup_564872;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to clean up the test failover of a replication protected item.
  ## 
  let valid = call_564883.validator(path, query, header, formData, body)
  let scheme = call_564883.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564883.url(scheme.get, call_564883.host, call_564883.base,
                         call_564883.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564883, url, valid)

proc call*(call_564884: Call_ReplicationProtectedItemsTestFailoverCleanup_564872;
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
  var path_564885 = newJObject()
  var query_564886 = newJObject()
  var body_564887 = newJObject()
  add(path_564885, "protectionContainerName", newJString(protectionContainerName))
  add(query_564886, "api-version", newJString(apiVersion))
  add(path_564885, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564885, "fabricName", newJString(fabricName))
  add(path_564885, "subscriptionId", newJString(subscriptionId))
  if cleanupInput != nil:
    body_564887 = cleanupInput
  add(path_564885, "resourceGroupName", newJString(resourceGroupName))
  add(path_564885, "resourceName", newJString(resourceName))
  result = call_564884.call(path_564885, query_564886, nil, nil, body_564887)

var replicationProtectedItemsTestFailoverCleanup* = Call_ReplicationProtectedItemsTestFailoverCleanup_564872(
    name: "replicationProtectedItemsTestFailoverCleanup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/testFailoverCleanup",
    validator: validate_ReplicationProtectedItemsTestFailoverCleanup_564873,
    base: "", url: url_ReplicationProtectedItemsTestFailoverCleanup_564874,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsUnplannedFailover_564888 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectedItemsUnplannedFailover_564890(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsUnplannedFailover_564889(path: JsonNode;
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
  var valid_564891 = path.getOrDefault("protectionContainerName")
  valid_564891 = validateParameter(valid_564891, JString, required = true,
                                 default = nil)
  if valid_564891 != nil:
    section.add "protectionContainerName", valid_564891
  var valid_564892 = path.getOrDefault("replicatedProtectedItemName")
  valid_564892 = validateParameter(valid_564892, JString, required = true,
                                 default = nil)
  if valid_564892 != nil:
    section.add "replicatedProtectedItemName", valid_564892
  var valid_564893 = path.getOrDefault("fabricName")
  valid_564893 = validateParameter(valid_564893, JString, required = true,
                                 default = nil)
  if valid_564893 != nil:
    section.add "fabricName", valid_564893
  var valid_564894 = path.getOrDefault("subscriptionId")
  valid_564894 = validateParameter(valid_564894, JString, required = true,
                                 default = nil)
  if valid_564894 != nil:
    section.add "subscriptionId", valid_564894
  var valid_564895 = path.getOrDefault("resourceGroupName")
  valid_564895 = validateParameter(valid_564895, JString, required = true,
                                 default = nil)
  if valid_564895 != nil:
    section.add "resourceGroupName", valid_564895
  var valid_564896 = path.getOrDefault("resourceName")
  valid_564896 = validateParameter(valid_564896, JString, required = true,
                                 default = nil)
  if valid_564896 != nil:
    section.add "resourceName", valid_564896
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564897 = query.getOrDefault("api-version")
  valid_564897 = validateParameter(valid_564897, JString, required = true,
                                 default = nil)
  if valid_564897 != nil:
    section.add "api-version", valid_564897
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

proc call*(call_564899: Call_ReplicationProtectedItemsUnplannedFailover_564888;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to initiate a failover of the replication protected item.
  ## 
  let valid = call_564899.validator(path, query, header, formData, body)
  let scheme = call_564899.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564899.url(scheme.get, call_564899.host, call_564899.base,
                         call_564899.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564899, url, valid)

proc call*(call_564900: Call_ReplicationProtectedItemsUnplannedFailover_564888;
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
  var path_564901 = newJObject()
  var query_564902 = newJObject()
  var body_564903 = newJObject()
  add(path_564901, "protectionContainerName", newJString(protectionContainerName))
  add(query_564902, "api-version", newJString(apiVersion))
  add(path_564901, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564901, "fabricName", newJString(fabricName))
  add(path_564901, "subscriptionId", newJString(subscriptionId))
  add(path_564901, "resourceGroupName", newJString(resourceGroupName))
  if failoverInput != nil:
    body_564903 = failoverInput
  add(path_564901, "resourceName", newJString(resourceName))
  result = call_564900.call(path_564901, query_564902, nil, nil, body_564903)

var replicationProtectedItemsUnplannedFailover* = Call_ReplicationProtectedItemsUnplannedFailover_564888(
    name: "replicationProtectedItemsUnplannedFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/unplannedFailover",
    validator: validate_ReplicationProtectedItemsUnplannedFailover_564889,
    base: "", url: url_ReplicationProtectedItemsUnplannedFailover_564890,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsUpdateMobilityService_564904 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectedItemsUpdateMobilityService_564906(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsUpdateMobilityService_564905(
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
  var valid_564907 = path.getOrDefault("protectionContainerName")
  valid_564907 = validateParameter(valid_564907, JString, required = true,
                                 default = nil)
  if valid_564907 != nil:
    section.add "protectionContainerName", valid_564907
  var valid_564908 = path.getOrDefault("replicationProtectedItemName")
  valid_564908 = validateParameter(valid_564908, JString, required = true,
                                 default = nil)
  if valid_564908 != nil:
    section.add "replicationProtectedItemName", valid_564908
  var valid_564909 = path.getOrDefault("fabricName")
  valid_564909 = validateParameter(valid_564909, JString, required = true,
                                 default = nil)
  if valid_564909 != nil:
    section.add "fabricName", valid_564909
  var valid_564910 = path.getOrDefault("subscriptionId")
  valid_564910 = validateParameter(valid_564910, JString, required = true,
                                 default = nil)
  if valid_564910 != nil:
    section.add "subscriptionId", valid_564910
  var valid_564911 = path.getOrDefault("resourceGroupName")
  valid_564911 = validateParameter(valid_564911, JString, required = true,
                                 default = nil)
  if valid_564911 != nil:
    section.add "resourceGroupName", valid_564911
  var valid_564912 = path.getOrDefault("resourceName")
  valid_564912 = validateParameter(valid_564912, JString, required = true,
                                 default = nil)
  if valid_564912 != nil:
    section.add "resourceName", valid_564912
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564913 = query.getOrDefault("api-version")
  valid_564913 = validateParameter(valid_564913, JString, required = true,
                                 default = nil)
  if valid_564913 != nil:
    section.add "api-version", valid_564913
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

proc call*(call_564915: Call_ReplicationProtectedItemsUpdateMobilityService_564904;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to update(push update) the installed mobility service software on a replication protected item to the latest available version.
  ## 
  let valid = call_564915.validator(path, query, header, formData, body)
  let scheme = call_564915.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564915.url(scheme.get, call_564915.host, call_564915.base,
                         call_564915.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564915, url, valid)

proc call*(call_564916: Call_ReplicationProtectedItemsUpdateMobilityService_564904;
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
  var path_564917 = newJObject()
  var query_564918 = newJObject()
  var body_564919 = newJObject()
  add(path_564917, "protectionContainerName", newJString(protectionContainerName))
  add(query_564918, "api-version", newJString(apiVersion))
  add(path_564917, "replicationProtectedItemName",
      newJString(replicationProtectedItemName))
  add(path_564917, "fabricName", newJString(fabricName))
  add(path_564917, "subscriptionId", newJString(subscriptionId))
  add(path_564917, "resourceGroupName", newJString(resourceGroupName))
  if updateMobilityServiceRequest != nil:
    body_564919 = updateMobilityServiceRequest
  add(path_564917, "resourceName", newJString(resourceName))
  result = call_564916.call(path_564917, query_564918, nil, nil, body_564919)

var replicationProtectedItemsUpdateMobilityService* = Call_ReplicationProtectedItemsUpdateMobilityService_564904(
    name: "replicationProtectedItemsUpdateMobilityService",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicationProtectedItemName}/updateMobilityService",
    validator: validate_ReplicationProtectedItemsUpdateMobilityService_564905,
    base: "", url: url_ReplicationProtectedItemsUpdateMobilityService_564906,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_564920 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_564922(
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

proc validate_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_564921(
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
  var valid_564923 = path.getOrDefault("protectionContainerName")
  valid_564923 = validateParameter(valid_564923, JString, required = true,
                                 default = nil)
  if valid_564923 != nil:
    section.add "protectionContainerName", valid_564923
  var valid_564924 = path.getOrDefault("fabricName")
  valid_564924 = validateParameter(valid_564924, JString, required = true,
                                 default = nil)
  if valid_564924 != nil:
    section.add "fabricName", valid_564924
  var valid_564925 = path.getOrDefault("subscriptionId")
  valid_564925 = validateParameter(valid_564925, JString, required = true,
                                 default = nil)
  if valid_564925 != nil:
    section.add "subscriptionId", valid_564925
  var valid_564926 = path.getOrDefault("resourceGroupName")
  valid_564926 = validateParameter(valid_564926, JString, required = true,
                                 default = nil)
  if valid_564926 != nil:
    section.add "resourceGroupName", valid_564926
  var valid_564927 = path.getOrDefault("resourceName")
  valid_564927 = validateParameter(valid_564927, JString, required = true,
                                 default = nil)
  if valid_564927 != nil:
    section.add "resourceName", valid_564927
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564928 = query.getOrDefault("api-version")
  valid_564928 = validateParameter(valid_564928, JString, required = true,
                                 default = nil)
  if valid_564928 != nil:
    section.add "api-version", valid_564928
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564929: Call_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_564920;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the protection container mappings for a protection container.
  ## 
  let valid = call_564929.validator(path, query, header, formData, body)
  let scheme = call_564929.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564929.url(scheme.get, call_564929.host, call_564929.base,
                         call_564929.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564929, url, valid)

proc call*(call_564930: Call_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_564920;
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
  var path_564931 = newJObject()
  var query_564932 = newJObject()
  add(path_564931, "protectionContainerName", newJString(protectionContainerName))
  add(query_564932, "api-version", newJString(apiVersion))
  add(path_564931, "fabricName", newJString(fabricName))
  add(path_564931, "subscriptionId", newJString(subscriptionId))
  add(path_564931, "resourceGroupName", newJString(resourceGroupName))
  add(path_564931, "resourceName", newJString(resourceName))
  result = call_564930.call(path_564931, query_564932, nil, nil, nil)

var replicationProtectionContainerMappingsListByReplicationProtectionContainers* = Call_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_564920(name: "replicationProtectionContainerMappingsListByReplicationProtectionContainers",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings", validator: validate_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_564921,
    base: "", url: url_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_564922,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsCreate_564947 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectionContainerMappingsCreate_564949(protocol: Scheme;
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

proc validate_ReplicationProtectionContainerMappingsCreate_564948(path: JsonNode;
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
  var valid_564950 = path.getOrDefault("protectionContainerName")
  valid_564950 = validateParameter(valid_564950, JString, required = true,
                                 default = nil)
  if valid_564950 != nil:
    section.add "protectionContainerName", valid_564950
  var valid_564951 = path.getOrDefault("fabricName")
  valid_564951 = validateParameter(valid_564951, JString, required = true,
                                 default = nil)
  if valid_564951 != nil:
    section.add "fabricName", valid_564951
  var valid_564952 = path.getOrDefault("subscriptionId")
  valid_564952 = validateParameter(valid_564952, JString, required = true,
                                 default = nil)
  if valid_564952 != nil:
    section.add "subscriptionId", valid_564952
  var valid_564953 = path.getOrDefault("mappingName")
  valid_564953 = validateParameter(valid_564953, JString, required = true,
                                 default = nil)
  if valid_564953 != nil:
    section.add "mappingName", valid_564953
  var valid_564954 = path.getOrDefault("resourceGroupName")
  valid_564954 = validateParameter(valid_564954, JString, required = true,
                                 default = nil)
  if valid_564954 != nil:
    section.add "resourceGroupName", valid_564954
  var valid_564955 = path.getOrDefault("resourceName")
  valid_564955 = validateParameter(valid_564955, JString, required = true,
                                 default = nil)
  if valid_564955 != nil:
    section.add "resourceName", valid_564955
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564956 = query.getOrDefault("api-version")
  valid_564956 = validateParameter(valid_564956, JString, required = true,
                                 default = nil)
  if valid_564956 != nil:
    section.add "api-version", valid_564956
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

proc call*(call_564958: Call_ReplicationProtectionContainerMappingsCreate_564947;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create a protection container mapping.
  ## 
  let valid = call_564958.validator(path, query, header, formData, body)
  let scheme = call_564958.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564958.url(scheme.get, call_564958.host, call_564958.base,
                         call_564958.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564958, url, valid)

proc call*(call_564959: Call_ReplicationProtectionContainerMappingsCreate_564947;
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
  var path_564960 = newJObject()
  var query_564961 = newJObject()
  var body_564962 = newJObject()
  add(path_564960, "protectionContainerName", newJString(protectionContainerName))
  add(query_564961, "api-version", newJString(apiVersion))
  if creationInput != nil:
    body_564962 = creationInput
  add(path_564960, "fabricName", newJString(fabricName))
  add(path_564960, "subscriptionId", newJString(subscriptionId))
  add(path_564960, "mappingName", newJString(mappingName))
  add(path_564960, "resourceGroupName", newJString(resourceGroupName))
  add(path_564960, "resourceName", newJString(resourceName))
  result = call_564959.call(path_564960, query_564961, nil, nil, body_564962)

var replicationProtectionContainerMappingsCreate* = Call_ReplicationProtectionContainerMappingsCreate_564947(
    name: "replicationProtectionContainerMappingsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}",
    validator: validate_ReplicationProtectionContainerMappingsCreate_564948,
    base: "", url: url_ReplicationProtectionContainerMappingsCreate_564949,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsGet_564933 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectionContainerMappingsGet_564935(protocol: Scheme;
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

proc validate_ReplicationProtectionContainerMappingsGet_564934(path: JsonNode;
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
  var valid_564936 = path.getOrDefault("protectionContainerName")
  valid_564936 = validateParameter(valid_564936, JString, required = true,
                                 default = nil)
  if valid_564936 != nil:
    section.add "protectionContainerName", valid_564936
  var valid_564937 = path.getOrDefault("fabricName")
  valid_564937 = validateParameter(valid_564937, JString, required = true,
                                 default = nil)
  if valid_564937 != nil:
    section.add "fabricName", valid_564937
  var valid_564938 = path.getOrDefault("subscriptionId")
  valid_564938 = validateParameter(valid_564938, JString, required = true,
                                 default = nil)
  if valid_564938 != nil:
    section.add "subscriptionId", valid_564938
  var valid_564939 = path.getOrDefault("mappingName")
  valid_564939 = validateParameter(valid_564939, JString, required = true,
                                 default = nil)
  if valid_564939 != nil:
    section.add "mappingName", valid_564939
  var valid_564940 = path.getOrDefault("resourceGroupName")
  valid_564940 = validateParameter(valid_564940, JString, required = true,
                                 default = nil)
  if valid_564940 != nil:
    section.add "resourceGroupName", valid_564940
  var valid_564941 = path.getOrDefault("resourceName")
  valid_564941 = validateParameter(valid_564941, JString, required = true,
                                 default = nil)
  if valid_564941 != nil:
    section.add "resourceName", valid_564941
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564942 = query.getOrDefault("api-version")
  valid_564942 = validateParameter(valid_564942, JString, required = true,
                                 default = nil)
  if valid_564942 != nil:
    section.add "api-version", valid_564942
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564943: Call_ReplicationProtectionContainerMappingsGet_564933;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of a protection container mapping.
  ## 
  let valid = call_564943.validator(path, query, header, formData, body)
  let scheme = call_564943.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564943.url(scheme.get, call_564943.host, call_564943.base,
                         call_564943.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564943, url, valid)

proc call*(call_564944: Call_ReplicationProtectionContainerMappingsGet_564933;
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
  var path_564945 = newJObject()
  var query_564946 = newJObject()
  add(path_564945, "protectionContainerName", newJString(protectionContainerName))
  add(query_564946, "api-version", newJString(apiVersion))
  add(path_564945, "fabricName", newJString(fabricName))
  add(path_564945, "subscriptionId", newJString(subscriptionId))
  add(path_564945, "mappingName", newJString(mappingName))
  add(path_564945, "resourceGroupName", newJString(resourceGroupName))
  add(path_564945, "resourceName", newJString(resourceName))
  result = call_564944.call(path_564945, query_564946, nil, nil, nil)

var replicationProtectionContainerMappingsGet* = Call_ReplicationProtectionContainerMappingsGet_564933(
    name: "replicationProtectionContainerMappingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}",
    validator: validate_ReplicationProtectionContainerMappingsGet_564934,
    base: "", url: url_ReplicationProtectionContainerMappingsGet_564935,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsUpdate_564977 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectionContainerMappingsUpdate_564979(protocol: Scheme;
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

proc validate_ReplicationProtectionContainerMappingsUpdate_564978(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update protection container mapping.
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
  var valid_564980 = path.getOrDefault("protectionContainerName")
  valid_564980 = validateParameter(valid_564980, JString, required = true,
                                 default = nil)
  if valid_564980 != nil:
    section.add "protectionContainerName", valid_564980
  var valid_564981 = path.getOrDefault("fabricName")
  valid_564981 = validateParameter(valid_564981, JString, required = true,
                                 default = nil)
  if valid_564981 != nil:
    section.add "fabricName", valid_564981
  var valid_564982 = path.getOrDefault("subscriptionId")
  valid_564982 = validateParameter(valid_564982, JString, required = true,
                                 default = nil)
  if valid_564982 != nil:
    section.add "subscriptionId", valid_564982
  var valid_564983 = path.getOrDefault("mappingName")
  valid_564983 = validateParameter(valid_564983, JString, required = true,
                                 default = nil)
  if valid_564983 != nil:
    section.add "mappingName", valid_564983
  var valid_564984 = path.getOrDefault("resourceGroupName")
  valid_564984 = validateParameter(valid_564984, JString, required = true,
                                 default = nil)
  if valid_564984 != nil:
    section.add "resourceGroupName", valid_564984
  var valid_564985 = path.getOrDefault("resourceName")
  valid_564985 = validateParameter(valid_564985, JString, required = true,
                                 default = nil)
  if valid_564985 != nil:
    section.add "resourceName", valid_564985
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564986 = query.getOrDefault("api-version")
  valid_564986 = validateParameter(valid_564986, JString, required = true,
                                 default = nil)
  if valid_564986 != nil:
    section.add "api-version", valid_564986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   updateInput: JObject (required)
  ##              : Mapping update input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564988: Call_ReplicationProtectionContainerMappingsUpdate_564977;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to update protection container mapping.
  ## 
  let valid = call_564988.validator(path, query, header, formData, body)
  let scheme = call_564988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564988.url(scheme.get, call_564988.host, call_564988.base,
                         call_564988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564988, url, valid)

proc call*(call_564989: Call_ReplicationProtectionContainerMappingsUpdate_564977;
          protectionContainerName: string; apiVersion: string; fabricName: string;
          subscriptionId: string; mappingName: string; resourceGroupName: string;
          resourceName: string; updateInput: JsonNode): Recallable =
  ## replicationProtectionContainerMappingsUpdate
  ## The operation to update protection container mapping.
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
  ##   updateInput: JObject (required)
  ##              : Mapping update input.
  var path_564990 = newJObject()
  var query_564991 = newJObject()
  var body_564992 = newJObject()
  add(path_564990, "protectionContainerName", newJString(protectionContainerName))
  add(query_564991, "api-version", newJString(apiVersion))
  add(path_564990, "fabricName", newJString(fabricName))
  add(path_564990, "subscriptionId", newJString(subscriptionId))
  add(path_564990, "mappingName", newJString(mappingName))
  add(path_564990, "resourceGroupName", newJString(resourceGroupName))
  add(path_564990, "resourceName", newJString(resourceName))
  if updateInput != nil:
    body_564992 = updateInput
  result = call_564989.call(path_564990, query_564991, nil, nil, body_564992)

var replicationProtectionContainerMappingsUpdate* = Call_ReplicationProtectionContainerMappingsUpdate_564977(
    name: "replicationProtectionContainerMappingsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}",
    validator: validate_ReplicationProtectionContainerMappingsUpdate_564978,
    base: "", url: url_ReplicationProtectionContainerMappingsUpdate_564979,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsPurge_564963 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectionContainerMappingsPurge_564965(protocol: Scheme;
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

proc validate_ReplicationProtectionContainerMappingsPurge_564964(path: JsonNode;
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
  var valid_564966 = path.getOrDefault("protectionContainerName")
  valid_564966 = validateParameter(valid_564966, JString, required = true,
                                 default = nil)
  if valid_564966 != nil:
    section.add "protectionContainerName", valid_564966
  var valid_564967 = path.getOrDefault("fabricName")
  valid_564967 = validateParameter(valid_564967, JString, required = true,
                                 default = nil)
  if valid_564967 != nil:
    section.add "fabricName", valid_564967
  var valid_564968 = path.getOrDefault("subscriptionId")
  valid_564968 = validateParameter(valid_564968, JString, required = true,
                                 default = nil)
  if valid_564968 != nil:
    section.add "subscriptionId", valid_564968
  var valid_564969 = path.getOrDefault("mappingName")
  valid_564969 = validateParameter(valid_564969, JString, required = true,
                                 default = nil)
  if valid_564969 != nil:
    section.add "mappingName", valid_564969
  var valid_564970 = path.getOrDefault("resourceGroupName")
  valid_564970 = validateParameter(valid_564970, JString, required = true,
                                 default = nil)
  if valid_564970 != nil:
    section.add "resourceGroupName", valid_564970
  var valid_564971 = path.getOrDefault("resourceName")
  valid_564971 = validateParameter(valid_564971, JString, required = true,
                                 default = nil)
  if valid_564971 != nil:
    section.add "resourceName", valid_564971
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564972 = query.getOrDefault("api-version")
  valid_564972 = validateParameter(valid_564972, JString, required = true,
                                 default = nil)
  if valid_564972 != nil:
    section.add "api-version", valid_564972
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564973: Call_ReplicationProtectionContainerMappingsPurge_564963;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to purge(force delete) a protection container mapping
  ## 
  let valid = call_564973.validator(path, query, header, formData, body)
  let scheme = call_564973.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564973.url(scheme.get, call_564973.host, call_564973.base,
                         call_564973.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564973, url, valid)

proc call*(call_564974: Call_ReplicationProtectionContainerMappingsPurge_564963;
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
  var path_564975 = newJObject()
  var query_564976 = newJObject()
  add(path_564975, "protectionContainerName", newJString(protectionContainerName))
  add(query_564976, "api-version", newJString(apiVersion))
  add(path_564975, "fabricName", newJString(fabricName))
  add(path_564975, "subscriptionId", newJString(subscriptionId))
  add(path_564975, "mappingName", newJString(mappingName))
  add(path_564975, "resourceGroupName", newJString(resourceGroupName))
  add(path_564975, "resourceName", newJString(resourceName))
  result = call_564974.call(path_564975, query_564976, nil, nil, nil)

var replicationProtectionContainerMappingsPurge* = Call_ReplicationProtectionContainerMappingsPurge_564963(
    name: "replicationProtectionContainerMappingsPurge",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}",
    validator: validate_ReplicationProtectionContainerMappingsPurge_564964,
    base: "", url: url_ReplicationProtectionContainerMappingsPurge_564965,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsDelete_564993 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectionContainerMappingsDelete_564995(protocol: Scheme;
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

proc validate_ReplicationProtectionContainerMappingsDelete_564994(path: JsonNode;
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
  var valid_564996 = path.getOrDefault("protectionContainerName")
  valid_564996 = validateParameter(valid_564996, JString, required = true,
                                 default = nil)
  if valid_564996 != nil:
    section.add "protectionContainerName", valid_564996
  var valid_564997 = path.getOrDefault("fabricName")
  valid_564997 = validateParameter(valid_564997, JString, required = true,
                                 default = nil)
  if valid_564997 != nil:
    section.add "fabricName", valid_564997
  var valid_564998 = path.getOrDefault("subscriptionId")
  valid_564998 = validateParameter(valid_564998, JString, required = true,
                                 default = nil)
  if valid_564998 != nil:
    section.add "subscriptionId", valid_564998
  var valid_564999 = path.getOrDefault("mappingName")
  valid_564999 = validateParameter(valid_564999, JString, required = true,
                                 default = nil)
  if valid_564999 != nil:
    section.add "mappingName", valid_564999
  var valid_565000 = path.getOrDefault("resourceGroupName")
  valid_565000 = validateParameter(valid_565000, JString, required = true,
                                 default = nil)
  if valid_565000 != nil:
    section.add "resourceGroupName", valid_565000
  var valid_565001 = path.getOrDefault("resourceName")
  valid_565001 = validateParameter(valid_565001, JString, required = true,
                                 default = nil)
  if valid_565001 != nil:
    section.add "resourceName", valid_565001
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565002 = query.getOrDefault("api-version")
  valid_565002 = validateParameter(valid_565002, JString, required = true,
                                 default = nil)
  if valid_565002 != nil:
    section.add "api-version", valid_565002
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

proc call*(call_565004: Call_ReplicationProtectionContainerMappingsDelete_564993;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete or remove a protection container mapping.
  ## 
  let valid = call_565004.validator(path, query, header, formData, body)
  let scheme = call_565004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565004.url(scheme.get, call_565004.host, call_565004.base,
                         call_565004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565004, url, valid)

proc call*(call_565005: Call_ReplicationProtectionContainerMappingsDelete_564993;
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
  var path_565006 = newJObject()
  var query_565007 = newJObject()
  var body_565008 = newJObject()
  add(path_565006, "protectionContainerName", newJString(protectionContainerName))
  add(query_565007, "api-version", newJString(apiVersion))
  add(path_565006, "fabricName", newJString(fabricName))
  add(path_565006, "subscriptionId", newJString(subscriptionId))
  add(path_565006, "mappingName", newJString(mappingName))
  add(path_565006, "resourceGroupName", newJString(resourceGroupName))
  if removalInput != nil:
    body_565008 = removalInput
  add(path_565006, "resourceName", newJString(resourceName))
  result = call_565005.call(path_565006, query_565007, nil, nil, body_565008)

var replicationProtectionContainerMappingsDelete* = Call_ReplicationProtectionContainerMappingsDelete_564993(
    name: "replicationProtectionContainerMappingsDelete",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}/remove",
    validator: validate_ReplicationProtectionContainerMappingsDelete_564994,
    base: "", url: url_ReplicationProtectionContainerMappingsDelete_564995,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersSwitchProtection_565009 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectionContainersSwitchProtection_565011(protocol: Scheme;
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

proc validate_ReplicationProtectionContainersSwitchProtection_565010(
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
  var valid_565012 = path.getOrDefault("protectionContainerName")
  valid_565012 = validateParameter(valid_565012, JString, required = true,
                                 default = nil)
  if valid_565012 != nil:
    section.add "protectionContainerName", valid_565012
  var valid_565013 = path.getOrDefault("fabricName")
  valid_565013 = validateParameter(valid_565013, JString, required = true,
                                 default = nil)
  if valid_565013 != nil:
    section.add "fabricName", valid_565013
  var valid_565014 = path.getOrDefault("subscriptionId")
  valid_565014 = validateParameter(valid_565014, JString, required = true,
                                 default = nil)
  if valid_565014 != nil:
    section.add "subscriptionId", valid_565014
  var valid_565015 = path.getOrDefault("resourceGroupName")
  valid_565015 = validateParameter(valid_565015, JString, required = true,
                                 default = nil)
  if valid_565015 != nil:
    section.add "resourceGroupName", valid_565015
  var valid_565016 = path.getOrDefault("resourceName")
  valid_565016 = validateParameter(valid_565016, JString, required = true,
                                 default = nil)
  if valid_565016 != nil:
    section.add "resourceName", valid_565016
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565017 = query.getOrDefault("api-version")
  valid_565017 = validateParameter(valid_565017, JString, required = true,
                                 default = nil)
  if valid_565017 != nil:
    section.add "api-version", valid_565017
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

proc call*(call_565019: Call_ReplicationProtectionContainersSwitchProtection_565009;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to switch protection from one container to another or one replication provider to another.
  ## 
  let valid = call_565019.validator(path, query, header, formData, body)
  let scheme = call_565019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565019.url(scheme.get, call_565019.host, call_565019.base,
                         call_565019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565019, url, valid)

proc call*(call_565020: Call_ReplicationProtectionContainersSwitchProtection_565009;
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
  var path_565021 = newJObject()
  var query_565022 = newJObject()
  var body_565023 = newJObject()
  add(path_565021, "protectionContainerName", newJString(protectionContainerName))
  add(query_565022, "api-version", newJString(apiVersion))
  add(path_565021, "fabricName", newJString(fabricName))
  add(path_565021, "subscriptionId", newJString(subscriptionId))
  add(path_565021, "resourceGroupName", newJString(resourceGroupName))
  add(path_565021, "resourceName", newJString(resourceName))
  if switchInput != nil:
    body_565023 = switchInput
  result = call_565020.call(path_565021, query_565022, nil, nil, body_565023)

var replicationProtectionContainersSwitchProtection* = Call_ReplicationProtectionContainersSwitchProtection_565009(
    name: "replicationProtectionContainersSwitchProtection",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/switchprotection",
    validator: validate_ReplicationProtectionContainersSwitchProtection_565010,
    base: "", url: url_ReplicationProtectionContainersSwitchProtection_565011,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersListByReplicationFabrics_565024 = ref object of OpenApiRestCall_563566
proc url_ReplicationRecoveryServicesProvidersListByReplicationFabrics_565026(
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

proc validate_ReplicationRecoveryServicesProvidersListByReplicationFabrics_565025(
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
  var valid_565027 = path.getOrDefault("fabricName")
  valid_565027 = validateParameter(valid_565027, JString, required = true,
                                 default = nil)
  if valid_565027 != nil:
    section.add "fabricName", valid_565027
  var valid_565028 = path.getOrDefault("subscriptionId")
  valid_565028 = validateParameter(valid_565028, JString, required = true,
                                 default = nil)
  if valid_565028 != nil:
    section.add "subscriptionId", valid_565028
  var valid_565029 = path.getOrDefault("resourceGroupName")
  valid_565029 = validateParameter(valid_565029, JString, required = true,
                                 default = nil)
  if valid_565029 != nil:
    section.add "resourceGroupName", valid_565029
  var valid_565030 = path.getOrDefault("resourceName")
  valid_565030 = validateParameter(valid_565030, JString, required = true,
                                 default = nil)
  if valid_565030 != nil:
    section.add "resourceName", valid_565030
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565031 = query.getOrDefault("api-version")
  valid_565031 = validateParameter(valid_565031, JString, required = true,
                                 default = nil)
  if valid_565031 != nil:
    section.add "api-version", valid_565031
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565032: Call_ReplicationRecoveryServicesProvidersListByReplicationFabrics_565024;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the registered recovery services providers for the specified fabric.
  ## 
  let valid = call_565032.validator(path, query, header, formData, body)
  let scheme = call_565032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565032.url(scheme.get, call_565032.host, call_565032.base,
                         call_565032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565032, url, valid)

proc call*(call_565033: Call_ReplicationRecoveryServicesProvidersListByReplicationFabrics_565024;
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
  var path_565034 = newJObject()
  var query_565035 = newJObject()
  add(query_565035, "api-version", newJString(apiVersion))
  add(path_565034, "fabricName", newJString(fabricName))
  add(path_565034, "subscriptionId", newJString(subscriptionId))
  add(path_565034, "resourceGroupName", newJString(resourceGroupName))
  add(path_565034, "resourceName", newJString(resourceName))
  result = call_565033.call(path_565034, query_565035, nil, nil, nil)

var replicationRecoveryServicesProvidersListByReplicationFabrics* = Call_ReplicationRecoveryServicesProvidersListByReplicationFabrics_565024(
    name: "replicationRecoveryServicesProvidersListByReplicationFabrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders", validator: validate_ReplicationRecoveryServicesProvidersListByReplicationFabrics_565025,
    base: "",
    url: url_ReplicationRecoveryServicesProvidersListByReplicationFabrics_565026,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersCreate_565049 = ref object of OpenApiRestCall_563566
proc url_ReplicationRecoveryServicesProvidersCreate_565051(protocol: Scheme;
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

proc validate_ReplicationRecoveryServicesProvidersCreate_565050(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to add a recovery services provider.
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
  var valid_565052 = path.getOrDefault("providerName")
  valid_565052 = validateParameter(valid_565052, JString, required = true,
                                 default = nil)
  if valid_565052 != nil:
    section.add "providerName", valid_565052
  var valid_565053 = path.getOrDefault("fabricName")
  valid_565053 = validateParameter(valid_565053, JString, required = true,
                                 default = nil)
  if valid_565053 != nil:
    section.add "fabricName", valid_565053
  var valid_565054 = path.getOrDefault("subscriptionId")
  valid_565054 = validateParameter(valid_565054, JString, required = true,
                                 default = nil)
  if valid_565054 != nil:
    section.add "subscriptionId", valid_565054
  var valid_565055 = path.getOrDefault("resourceGroupName")
  valid_565055 = validateParameter(valid_565055, JString, required = true,
                                 default = nil)
  if valid_565055 != nil:
    section.add "resourceGroupName", valid_565055
  var valid_565056 = path.getOrDefault("resourceName")
  valid_565056 = validateParameter(valid_565056, JString, required = true,
                                 default = nil)
  if valid_565056 != nil:
    section.add "resourceName", valid_565056
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565057 = query.getOrDefault("api-version")
  valid_565057 = validateParameter(valid_565057, JString, required = true,
                                 default = nil)
  if valid_565057 != nil:
    section.add "api-version", valid_565057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   addProviderInput: JObject (required)
  ##                   : Add provider input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565059: Call_ReplicationRecoveryServicesProvidersCreate_565049;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to add a recovery services provider.
  ## 
  let valid = call_565059.validator(path, query, header, formData, body)
  let scheme = call_565059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565059.url(scheme.get, call_565059.host, call_565059.base,
                         call_565059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565059, url, valid)

proc call*(call_565060: Call_ReplicationRecoveryServicesProvidersCreate_565049;
          providerName: string; apiVersion: string; fabricName: string;
          addProviderInput: JsonNode; subscriptionId: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## replicationRecoveryServicesProvidersCreate
  ## The operation to add a recovery services provider.
  ##   providerName: string (required)
  ##               : Recovery services provider name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   addProviderInput: JObject (required)
  ##                   : Add provider input.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565061 = newJObject()
  var query_565062 = newJObject()
  var body_565063 = newJObject()
  add(path_565061, "providerName", newJString(providerName))
  add(query_565062, "api-version", newJString(apiVersion))
  add(path_565061, "fabricName", newJString(fabricName))
  if addProviderInput != nil:
    body_565063 = addProviderInput
  add(path_565061, "subscriptionId", newJString(subscriptionId))
  add(path_565061, "resourceGroupName", newJString(resourceGroupName))
  add(path_565061, "resourceName", newJString(resourceName))
  result = call_565060.call(path_565061, query_565062, nil, nil, body_565063)

var replicationRecoveryServicesProvidersCreate* = Call_ReplicationRecoveryServicesProvidersCreate_565049(
    name: "replicationRecoveryServicesProvidersCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}",
    validator: validate_ReplicationRecoveryServicesProvidersCreate_565050,
    base: "", url: url_ReplicationRecoveryServicesProvidersCreate_565051,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersGet_565036 = ref object of OpenApiRestCall_563566
proc url_ReplicationRecoveryServicesProvidersGet_565038(protocol: Scheme;
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

proc validate_ReplicationRecoveryServicesProvidersGet_565037(path: JsonNode;
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
  var valid_565039 = path.getOrDefault("providerName")
  valid_565039 = validateParameter(valid_565039, JString, required = true,
                                 default = nil)
  if valid_565039 != nil:
    section.add "providerName", valid_565039
  var valid_565040 = path.getOrDefault("fabricName")
  valid_565040 = validateParameter(valid_565040, JString, required = true,
                                 default = nil)
  if valid_565040 != nil:
    section.add "fabricName", valid_565040
  var valid_565041 = path.getOrDefault("subscriptionId")
  valid_565041 = validateParameter(valid_565041, JString, required = true,
                                 default = nil)
  if valid_565041 != nil:
    section.add "subscriptionId", valid_565041
  var valid_565042 = path.getOrDefault("resourceGroupName")
  valid_565042 = validateParameter(valid_565042, JString, required = true,
                                 default = nil)
  if valid_565042 != nil:
    section.add "resourceGroupName", valid_565042
  var valid_565043 = path.getOrDefault("resourceName")
  valid_565043 = validateParameter(valid_565043, JString, required = true,
                                 default = nil)
  if valid_565043 != nil:
    section.add "resourceName", valid_565043
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565044 = query.getOrDefault("api-version")
  valid_565044 = validateParameter(valid_565044, JString, required = true,
                                 default = nil)
  if valid_565044 != nil:
    section.add "api-version", valid_565044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565045: Call_ReplicationRecoveryServicesProvidersGet_565036;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of registered recovery services provider.
  ## 
  let valid = call_565045.validator(path, query, header, formData, body)
  let scheme = call_565045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565045.url(scheme.get, call_565045.host, call_565045.base,
                         call_565045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565045, url, valid)

proc call*(call_565046: Call_ReplicationRecoveryServicesProvidersGet_565036;
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
  var path_565047 = newJObject()
  var query_565048 = newJObject()
  add(path_565047, "providerName", newJString(providerName))
  add(query_565048, "api-version", newJString(apiVersion))
  add(path_565047, "fabricName", newJString(fabricName))
  add(path_565047, "subscriptionId", newJString(subscriptionId))
  add(path_565047, "resourceGroupName", newJString(resourceGroupName))
  add(path_565047, "resourceName", newJString(resourceName))
  result = call_565046.call(path_565047, query_565048, nil, nil, nil)

var replicationRecoveryServicesProvidersGet* = Call_ReplicationRecoveryServicesProvidersGet_565036(
    name: "replicationRecoveryServicesProvidersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}",
    validator: validate_ReplicationRecoveryServicesProvidersGet_565037, base: "",
    url: url_ReplicationRecoveryServicesProvidersGet_565038,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersPurge_565064 = ref object of OpenApiRestCall_563566
proc url_ReplicationRecoveryServicesProvidersPurge_565066(protocol: Scheme;
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

proc validate_ReplicationRecoveryServicesProvidersPurge_565065(path: JsonNode;
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
  var valid_565067 = path.getOrDefault("providerName")
  valid_565067 = validateParameter(valid_565067, JString, required = true,
                                 default = nil)
  if valid_565067 != nil:
    section.add "providerName", valid_565067
  var valid_565068 = path.getOrDefault("fabricName")
  valid_565068 = validateParameter(valid_565068, JString, required = true,
                                 default = nil)
  if valid_565068 != nil:
    section.add "fabricName", valid_565068
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
  if body != nil:
    result.add "body", body

proc call*(call_565073: Call_ReplicationRecoveryServicesProvidersPurge_565064;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to purge(force delete) a recovery services provider from the vault.
  ## 
  let valid = call_565073.validator(path, query, header, formData, body)
  let scheme = call_565073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565073.url(scheme.get, call_565073.host, call_565073.base,
                         call_565073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565073, url, valid)

proc call*(call_565074: Call_ReplicationRecoveryServicesProvidersPurge_565064;
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
  var path_565075 = newJObject()
  var query_565076 = newJObject()
  add(path_565075, "providerName", newJString(providerName))
  add(query_565076, "api-version", newJString(apiVersion))
  add(path_565075, "fabricName", newJString(fabricName))
  add(path_565075, "subscriptionId", newJString(subscriptionId))
  add(path_565075, "resourceGroupName", newJString(resourceGroupName))
  add(path_565075, "resourceName", newJString(resourceName))
  result = call_565074.call(path_565075, query_565076, nil, nil, nil)

var replicationRecoveryServicesProvidersPurge* = Call_ReplicationRecoveryServicesProvidersPurge_565064(
    name: "replicationRecoveryServicesProvidersPurge",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}",
    validator: validate_ReplicationRecoveryServicesProvidersPurge_565065,
    base: "", url: url_ReplicationRecoveryServicesProvidersPurge_565066,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersRefreshProvider_565077 = ref object of OpenApiRestCall_563566
proc url_ReplicationRecoveryServicesProvidersRefreshProvider_565079(
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

proc validate_ReplicationRecoveryServicesProvidersRefreshProvider_565078(
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
  var valid_565080 = path.getOrDefault("providerName")
  valid_565080 = validateParameter(valid_565080, JString, required = true,
                                 default = nil)
  if valid_565080 != nil:
    section.add "providerName", valid_565080
  var valid_565081 = path.getOrDefault("fabricName")
  valid_565081 = validateParameter(valid_565081, JString, required = true,
                                 default = nil)
  if valid_565081 != nil:
    section.add "fabricName", valid_565081
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565085 = query.getOrDefault("api-version")
  valid_565085 = validateParameter(valid_565085, JString, required = true,
                                 default = nil)
  if valid_565085 != nil:
    section.add "api-version", valid_565085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565086: Call_ReplicationRecoveryServicesProvidersRefreshProvider_565077;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to refresh the information from the recovery services provider.
  ## 
  let valid = call_565086.validator(path, query, header, formData, body)
  let scheme = call_565086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565086.url(scheme.get, call_565086.host, call_565086.base,
                         call_565086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565086, url, valid)

proc call*(call_565087: Call_ReplicationRecoveryServicesProvidersRefreshProvider_565077;
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
  var path_565088 = newJObject()
  var query_565089 = newJObject()
  add(path_565088, "providerName", newJString(providerName))
  add(query_565089, "api-version", newJString(apiVersion))
  add(path_565088, "fabricName", newJString(fabricName))
  add(path_565088, "subscriptionId", newJString(subscriptionId))
  add(path_565088, "resourceGroupName", newJString(resourceGroupName))
  add(path_565088, "resourceName", newJString(resourceName))
  result = call_565087.call(path_565088, query_565089, nil, nil, nil)

var replicationRecoveryServicesProvidersRefreshProvider* = Call_ReplicationRecoveryServicesProvidersRefreshProvider_565077(
    name: "replicationRecoveryServicesProvidersRefreshProvider",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}/refreshProvider",
    validator: validate_ReplicationRecoveryServicesProvidersRefreshProvider_565078,
    base: "", url: url_ReplicationRecoveryServicesProvidersRefreshProvider_565079,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersDelete_565090 = ref object of OpenApiRestCall_563566
proc url_ReplicationRecoveryServicesProvidersDelete_565092(protocol: Scheme;
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

proc validate_ReplicationRecoveryServicesProvidersDelete_565091(path: JsonNode;
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
  var valid_565093 = path.getOrDefault("providerName")
  valid_565093 = validateParameter(valid_565093, JString, required = true,
                                 default = nil)
  if valid_565093 != nil:
    section.add "providerName", valid_565093
  var valid_565094 = path.getOrDefault("fabricName")
  valid_565094 = validateParameter(valid_565094, JString, required = true,
                                 default = nil)
  if valid_565094 != nil:
    section.add "fabricName", valid_565094
  var valid_565095 = path.getOrDefault("subscriptionId")
  valid_565095 = validateParameter(valid_565095, JString, required = true,
                                 default = nil)
  if valid_565095 != nil:
    section.add "subscriptionId", valid_565095
  var valid_565096 = path.getOrDefault("resourceGroupName")
  valid_565096 = validateParameter(valid_565096, JString, required = true,
                                 default = nil)
  if valid_565096 != nil:
    section.add "resourceGroupName", valid_565096
  var valid_565097 = path.getOrDefault("resourceName")
  valid_565097 = validateParameter(valid_565097, JString, required = true,
                                 default = nil)
  if valid_565097 != nil:
    section.add "resourceName", valid_565097
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

proc call*(call_565099: Call_ReplicationRecoveryServicesProvidersDelete_565090;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to removes/delete(unregister) a recovery services provider from the vault
  ## 
  let valid = call_565099.validator(path, query, header, formData, body)
  let scheme = call_565099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565099.url(scheme.get, call_565099.host, call_565099.base,
                         call_565099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565099, url, valid)

proc call*(call_565100: Call_ReplicationRecoveryServicesProvidersDelete_565090;
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
  var path_565101 = newJObject()
  var query_565102 = newJObject()
  add(path_565101, "providerName", newJString(providerName))
  add(query_565102, "api-version", newJString(apiVersion))
  add(path_565101, "fabricName", newJString(fabricName))
  add(path_565101, "subscriptionId", newJString(subscriptionId))
  add(path_565101, "resourceGroupName", newJString(resourceGroupName))
  add(path_565101, "resourceName", newJString(resourceName))
  result = call_565100.call(path_565101, query_565102, nil, nil, nil)

var replicationRecoveryServicesProvidersDelete* = Call_ReplicationRecoveryServicesProvidersDelete_565090(
    name: "replicationRecoveryServicesProvidersDelete", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}/remove",
    validator: validate_ReplicationRecoveryServicesProvidersDelete_565091,
    base: "", url: url_ReplicationRecoveryServicesProvidersDelete_565092,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationsListByReplicationFabrics_565103 = ref object of OpenApiRestCall_563566
proc url_ReplicationStorageClassificationsListByReplicationFabrics_565105(
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

proc validate_ReplicationStorageClassificationsListByReplicationFabrics_565104(
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
  var valid_565106 = path.getOrDefault("fabricName")
  valid_565106 = validateParameter(valid_565106, JString, required = true,
                                 default = nil)
  if valid_565106 != nil:
    section.add "fabricName", valid_565106
  var valid_565107 = path.getOrDefault("subscriptionId")
  valid_565107 = validateParameter(valid_565107, JString, required = true,
                                 default = nil)
  if valid_565107 != nil:
    section.add "subscriptionId", valid_565107
  var valid_565108 = path.getOrDefault("resourceGroupName")
  valid_565108 = validateParameter(valid_565108, JString, required = true,
                                 default = nil)
  if valid_565108 != nil:
    section.add "resourceGroupName", valid_565108
  var valid_565109 = path.getOrDefault("resourceName")
  valid_565109 = validateParameter(valid_565109, JString, required = true,
                                 default = nil)
  if valid_565109 != nil:
    section.add "resourceName", valid_565109
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

proc call*(call_565111: Call_ReplicationStorageClassificationsListByReplicationFabrics_565103;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the storage classifications available in the specified fabric.
  ## 
  let valid = call_565111.validator(path, query, header, formData, body)
  let scheme = call_565111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565111.url(scheme.get, call_565111.host, call_565111.base,
                         call_565111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565111, url, valid)

proc call*(call_565112: Call_ReplicationStorageClassificationsListByReplicationFabrics_565103;
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
  var path_565113 = newJObject()
  var query_565114 = newJObject()
  add(query_565114, "api-version", newJString(apiVersion))
  add(path_565113, "fabricName", newJString(fabricName))
  add(path_565113, "subscriptionId", newJString(subscriptionId))
  add(path_565113, "resourceGroupName", newJString(resourceGroupName))
  add(path_565113, "resourceName", newJString(resourceName))
  result = call_565112.call(path_565113, query_565114, nil, nil, nil)

var replicationStorageClassificationsListByReplicationFabrics* = Call_ReplicationStorageClassificationsListByReplicationFabrics_565103(
    name: "replicationStorageClassificationsListByReplicationFabrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications", validator: validate_ReplicationStorageClassificationsListByReplicationFabrics_565104,
    base: "", url: url_ReplicationStorageClassificationsListByReplicationFabrics_565105,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationsGet_565115 = ref object of OpenApiRestCall_563566
proc url_ReplicationStorageClassificationsGet_565117(protocol: Scheme;
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

proc validate_ReplicationStorageClassificationsGet_565116(path: JsonNode;
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
  var valid_565118 = path.getOrDefault("fabricName")
  valid_565118 = validateParameter(valid_565118, JString, required = true,
                                 default = nil)
  if valid_565118 != nil:
    section.add "fabricName", valid_565118
  var valid_565119 = path.getOrDefault("subscriptionId")
  valid_565119 = validateParameter(valid_565119, JString, required = true,
                                 default = nil)
  if valid_565119 != nil:
    section.add "subscriptionId", valid_565119
  var valid_565120 = path.getOrDefault("resourceGroupName")
  valid_565120 = validateParameter(valid_565120, JString, required = true,
                                 default = nil)
  if valid_565120 != nil:
    section.add "resourceGroupName", valid_565120
  var valid_565121 = path.getOrDefault("resourceName")
  valid_565121 = validateParameter(valid_565121, JString, required = true,
                                 default = nil)
  if valid_565121 != nil:
    section.add "resourceName", valid_565121
  var valid_565122 = path.getOrDefault("storageClassificationName")
  valid_565122 = validateParameter(valid_565122, JString, required = true,
                                 default = nil)
  if valid_565122 != nil:
    section.add "storageClassificationName", valid_565122
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565123 = query.getOrDefault("api-version")
  valid_565123 = validateParameter(valid_565123, JString, required = true,
                                 default = nil)
  if valid_565123 != nil:
    section.add "api-version", valid_565123
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565124: Call_ReplicationStorageClassificationsGet_565115;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of the specified storage classification.
  ## 
  let valid = call_565124.validator(path, query, header, formData, body)
  let scheme = call_565124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565124.url(scheme.get, call_565124.host, call_565124.base,
                         call_565124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565124, url, valid)

proc call*(call_565125: Call_ReplicationStorageClassificationsGet_565115;
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
  var path_565126 = newJObject()
  var query_565127 = newJObject()
  add(query_565127, "api-version", newJString(apiVersion))
  add(path_565126, "fabricName", newJString(fabricName))
  add(path_565126, "subscriptionId", newJString(subscriptionId))
  add(path_565126, "resourceGroupName", newJString(resourceGroupName))
  add(path_565126, "resourceName", newJString(resourceName))
  add(path_565126, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_565125.call(path_565126, query_565127, nil, nil, nil)

var replicationStorageClassificationsGet* = Call_ReplicationStorageClassificationsGet_565115(
    name: "replicationStorageClassificationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}",
    validator: validate_ReplicationStorageClassificationsGet_565116, base: "",
    url: url_ReplicationStorageClassificationsGet_565117, schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_565128 = ref object of OpenApiRestCall_563566
proc url_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_565130(
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

proc validate_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_565129(
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
  var valid_565131 = path.getOrDefault("fabricName")
  valid_565131 = validateParameter(valid_565131, JString, required = true,
                                 default = nil)
  if valid_565131 != nil:
    section.add "fabricName", valid_565131
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
  var valid_565135 = path.getOrDefault("storageClassificationName")
  valid_565135 = validateParameter(valid_565135, JString, required = true,
                                 default = nil)
  if valid_565135 != nil:
    section.add "storageClassificationName", valid_565135
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565136 = query.getOrDefault("api-version")
  valid_565136 = validateParameter(valid_565136, JString, required = true,
                                 default = nil)
  if valid_565136 != nil:
    section.add "api-version", valid_565136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565137: Call_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_565128;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the storage classification mappings for the fabric.
  ## 
  let valid = call_565137.validator(path, query, header, formData, body)
  let scheme = call_565137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565137.url(scheme.get, call_565137.host, call_565137.base,
                         call_565137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565137, url, valid)

proc call*(call_565138: Call_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_565128;
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
  var path_565139 = newJObject()
  var query_565140 = newJObject()
  add(query_565140, "api-version", newJString(apiVersion))
  add(path_565139, "fabricName", newJString(fabricName))
  add(path_565139, "subscriptionId", newJString(subscriptionId))
  add(path_565139, "resourceGroupName", newJString(resourceGroupName))
  add(path_565139, "resourceName", newJString(resourceName))
  add(path_565139, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_565138.call(path_565139, query_565140, nil, nil, nil)

var replicationStorageClassificationMappingsListByReplicationStorageClassifications* = Call_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_565128(name: "replicationStorageClassificationMappingsListByReplicationStorageClassifications",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}/replicationStorageClassificationMappings", validator: validate_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_565129,
    base: "", url: url_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_565130,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsCreate_565155 = ref object of OpenApiRestCall_563566
proc url_ReplicationStorageClassificationMappingsCreate_565157(protocol: Scheme;
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

proc validate_ReplicationStorageClassificationMappingsCreate_565156(
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
  var valid_565158 = path.getOrDefault("fabricName")
  valid_565158 = validateParameter(valid_565158, JString, required = true,
                                 default = nil)
  if valid_565158 != nil:
    section.add "fabricName", valid_565158
  var valid_565159 = path.getOrDefault("subscriptionId")
  valid_565159 = validateParameter(valid_565159, JString, required = true,
                                 default = nil)
  if valid_565159 != nil:
    section.add "subscriptionId", valid_565159
  var valid_565160 = path.getOrDefault("storageClassificationMappingName")
  valid_565160 = validateParameter(valid_565160, JString, required = true,
                                 default = nil)
  if valid_565160 != nil:
    section.add "storageClassificationMappingName", valid_565160
  var valid_565161 = path.getOrDefault("resourceGroupName")
  valid_565161 = validateParameter(valid_565161, JString, required = true,
                                 default = nil)
  if valid_565161 != nil:
    section.add "resourceGroupName", valid_565161
  var valid_565162 = path.getOrDefault("resourceName")
  valid_565162 = validateParameter(valid_565162, JString, required = true,
                                 default = nil)
  if valid_565162 != nil:
    section.add "resourceName", valid_565162
  var valid_565163 = path.getOrDefault("storageClassificationName")
  valid_565163 = validateParameter(valid_565163, JString, required = true,
                                 default = nil)
  if valid_565163 != nil:
    section.add "storageClassificationName", valid_565163
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565164 = query.getOrDefault("api-version")
  valid_565164 = validateParameter(valid_565164, JString, required = true,
                                 default = nil)
  if valid_565164 != nil:
    section.add "api-version", valid_565164
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

proc call*(call_565166: Call_ReplicationStorageClassificationMappingsCreate_565155;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create a storage classification mapping.
  ## 
  let valid = call_565166.validator(path, query, header, formData, body)
  let scheme = call_565166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565166.url(scheme.get, call_565166.host, call_565166.base,
                         call_565166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565166, url, valid)

proc call*(call_565167: Call_ReplicationStorageClassificationMappingsCreate_565155;
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
  var path_565168 = newJObject()
  var query_565169 = newJObject()
  var body_565170 = newJObject()
  if pairingInput != nil:
    body_565170 = pairingInput
  add(query_565169, "api-version", newJString(apiVersion))
  add(path_565168, "fabricName", newJString(fabricName))
  add(path_565168, "subscriptionId", newJString(subscriptionId))
  add(path_565168, "storageClassificationMappingName",
      newJString(storageClassificationMappingName))
  add(path_565168, "resourceGroupName", newJString(resourceGroupName))
  add(path_565168, "resourceName", newJString(resourceName))
  add(path_565168, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_565167.call(path_565168, query_565169, nil, nil, body_565170)

var replicationStorageClassificationMappingsCreate* = Call_ReplicationStorageClassificationMappingsCreate_565155(
    name: "replicationStorageClassificationMappingsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}/replicationStorageClassificationMappings/{storageClassificationMappingName}",
    validator: validate_ReplicationStorageClassificationMappingsCreate_565156,
    base: "", url: url_ReplicationStorageClassificationMappingsCreate_565157,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsGet_565141 = ref object of OpenApiRestCall_563566
proc url_ReplicationStorageClassificationMappingsGet_565143(protocol: Scheme;
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

proc validate_ReplicationStorageClassificationMappingsGet_565142(path: JsonNode;
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
  var valid_565144 = path.getOrDefault("fabricName")
  valid_565144 = validateParameter(valid_565144, JString, required = true,
                                 default = nil)
  if valid_565144 != nil:
    section.add "fabricName", valid_565144
  var valid_565145 = path.getOrDefault("subscriptionId")
  valid_565145 = validateParameter(valid_565145, JString, required = true,
                                 default = nil)
  if valid_565145 != nil:
    section.add "subscriptionId", valid_565145
  var valid_565146 = path.getOrDefault("storageClassificationMappingName")
  valid_565146 = validateParameter(valid_565146, JString, required = true,
                                 default = nil)
  if valid_565146 != nil:
    section.add "storageClassificationMappingName", valid_565146
  var valid_565147 = path.getOrDefault("resourceGroupName")
  valid_565147 = validateParameter(valid_565147, JString, required = true,
                                 default = nil)
  if valid_565147 != nil:
    section.add "resourceGroupName", valid_565147
  var valid_565148 = path.getOrDefault("resourceName")
  valid_565148 = validateParameter(valid_565148, JString, required = true,
                                 default = nil)
  if valid_565148 != nil:
    section.add "resourceName", valid_565148
  var valid_565149 = path.getOrDefault("storageClassificationName")
  valid_565149 = validateParameter(valid_565149, JString, required = true,
                                 default = nil)
  if valid_565149 != nil:
    section.add "storageClassificationName", valid_565149
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565150 = query.getOrDefault("api-version")
  valid_565150 = validateParameter(valid_565150, JString, required = true,
                                 default = nil)
  if valid_565150 != nil:
    section.add "api-version", valid_565150
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565151: Call_ReplicationStorageClassificationMappingsGet_565141;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of the specified storage classification mapping.
  ## 
  let valid = call_565151.validator(path, query, header, formData, body)
  let scheme = call_565151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565151.url(scheme.get, call_565151.host, call_565151.base,
                         call_565151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565151, url, valid)

proc call*(call_565152: Call_ReplicationStorageClassificationMappingsGet_565141;
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
  var path_565153 = newJObject()
  var query_565154 = newJObject()
  add(query_565154, "api-version", newJString(apiVersion))
  add(path_565153, "fabricName", newJString(fabricName))
  add(path_565153, "subscriptionId", newJString(subscriptionId))
  add(path_565153, "storageClassificationMappingName",
      newJString(storageClassificationMappingName))
  add(path_565153, "resourceGroupName", newJString(resourceGroupName))
  add(path_565153, "resourceName", newJString(resourceName))
  add(path_565153, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_565152.call(path_565153, query_565154, nil, nil, nil)

var replicationStorageClassificationMappingsGet* = Call_ReplicationStorageClassificationMappingsGet_565141(
    name: "replicationStorageClassificationMappingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}/replicationStorageClassificationMappings/{storageClassificationMappingName}",
    validator: validate_ReplicationStorageClassificationMappingsGet_565142,
    base: "", url: url_ReplicationStorageClassificationMappingsGet_565143,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsDelete_565171 = ref object of OpenApiRestCall_563566
proc url_ReplicationStorageClassificationMappingsDelete_565173(protocol: Scheme;
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

proc validate_ReplicationStorageClassificationMappingsDelete_565172(
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
  var valid_565174 = path.getOrDefault("fabricName")
  valid_565174 = validateParameter(valid_565174, JString, required = true,
                                 default = nil)
  if valid_565174 != nil:
    section.add "fabricName", valid_565174
  var valid_565175 = path.getOrDefault("subscriptionId")
  valid_565175 = validateParameter(valid_565175, JString, required = true,
                                 default = nil)
  if valid_565175 != nil:
    section.add "subscriptionId", valid_565175
  var valid_565176 = path.getOrDefault("storageClassificationMappingName")
  valid_565176 = validateParameter(valid_565176, JString, required = true,
                                 default = nil)
  if valid_565176 != nil:
    section.add "storageClassificationMappingName", valid_565176
  var valid_565177 = path.getOrDefault("resourceGroupName")
  valid_565177 = validateParameter(valid_565177, JString, required = true,
                                 default = nil)
  if valid_565177 != nil:
    section.add "resourceGroupName", valid_565177
  var valid_565178 = path.getOrDefault("resourceName")
  valid_565178 = validateParameter(valid_565178, JString, required = true,
                                 default = nil)
  if valid_565178 != nil:
    section.add "resourceName", valid_565178
  var valid_565179 = path.getOrDefault("storageClassificationName")
  valid_565179 = validateParameter(valid_565179, JString, required = true,
                                 default = nil)
  if valid_565179 != nil:
    section.add "storageClassificationName", valid_565179
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565180 = query.getOrDefault("api-version")
  valid_565180 = validateParameter(valid_565180, JString, required = true,
                                 default = nil)
  if valid_565180 != nil:
    section.add "api-version", valid_565180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565181: Call_ReplicationStorageClassificationMappingsDelete_565171;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete a storage classification mapping.
  ## 
  let valid = call_565181.validator(path, query, header, formData, body)
  let scheme = call_565181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565181.url(scheme.get, call_565181.host, call_565181.base,
                         call_565181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565181, url, valid)

proc call*(call_565182: Call_ReplicationStorageClassificationMappingsDelete_565171;
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
  var path_565183 = newJObject()
  var query_565184 = newJObject()
  add(query_565184, "api-version", newJString(apiVersion))
  add(path_565183, "fabricName", newJString(fabricName))
  add(path_565183, "subscriptionId", newJString(subscriptionId))
  add(path_565183, "storageClassificationMappingName",
      newJString(storageClassificationMappingName))
  add(path_565183, "resourceGroupName", newJString(resourceGroupName))
  add(path_565183, "resourceName", newJString(resourceName))
  add(path_565183, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_565182.call(path_565183, query_565184, nil, nil, nil)

var replicationStorageClassificationMappingsDelete* = Call_ReplicationStorageClassificationMappingsDelete_565171(
    name: "replicationStorageClassificationMappingsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}/replicationStorageClassificationMappings/{storageClassificationMappingName}",
    validator: validate_ReplicationStorageClassificationMappingsDelete_565172,
    base: "", url: url_ReplicationStorageClassificationMappingsDelete_565173,
    schemes: {Scheme.Https})
type
  Call_ReplicationvCentersListByReplicationFabrics_565185 = ref object of OpenApiRestCall_563566
proc url_ReplicationvCentersListByReplicationFabrics_565187(protocol: Scheme;
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

proc validate_ReplicationvCentersListByReplicationFabrics_565186(path: JsonNode;
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
  var valid_565188 = path.getOrDefault("fabricName")
  valid_565188 = validateParameter(valid_565188, JString, required = true,
                                 default = nil)
  if valid_565188 != nil:
    section.add "fabricName", valid_565188
  var valid_565189 = path.getOrDefault("subscriptionId")
  valid_565189 = validateParameter(valid_565189, JString, required = true,
                                 default = nil)
  if valid_565189 != nil:
    section.add "subscriptionId", valid_565189
  var valid_565190 = path.getOrDefault("resourceGroupName")
  valid_565190 = validateParameter(valid_565190, JString, required = true,
                                 default = nil)
  if valid_565190 != nil:
    section.add "resourceGroupName", valid_565190
  var valid_565191 = path.getOrDefault("resourceName")
  valid_565191 = validateParameter(valid_565191, JString, required = true,
                                 default = nil)
  if valid_565191 != nil:
    section.add "resourceName", valid_565191
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565192 = query.getOrDefault("api-version")
  valid_565192 = validateParameter(valid_565192, JString, required = true,
                                 default = nil)
  if valid_565192 != nil:
    section.add "api-version", valid_565192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565193: Call_ReplicationvCentersListByReplicationFabrics_565185;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the vCenter servers registered in a fabric.
  ## 
  let valid = call_565193.validator(path, query, header, formData, body)
  let scheme = call_565193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565193.url(scheme.get, call_565193.host, call_565193.base,
                         call_565193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565193, url, valid)

proc call*(call_565194: Call_ReplicationvCentersListByReplicationFabrics_565185;
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
  var path_565195 = newJObject()
  var query_565196 = newJObject()
  add(query_565196, "api-version", newJString(apiVersion))
  add(path_565195, "fabricName", newJString(fabricName))
  add(path_565195, "subscriptionId", newJString(subscriptionId))
  add(path_565195, "resourceGroupName", newJString(resourceGroupName))
  add(path_565195, "resourceName", newJString(resourceName))
  result = call_565194.call(path_565195, query_565196, nil, nil, nil)

var replicationvCentersListByReplicationFabrics* = Call_ReplicationvCentersListByReplicationFabrics_565185(
    name: "replicationvCentersListByReplicationFabrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters",
    validator: validate_ReplicationvCentersListByReplicationFabrics_565186,
    base: "", url: url_ReplicationvCentersListByReplicationFabrics_565187,
    schemes: {Scheme.Https})
type
  Call_ReplicationvCentersCreate_565210 = ref object of OpenApiRestCall_563566
proc url_ReplicationvCentersCreate_565212(protocol: Scheme; host: string;
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

proc validate_ReplicationvCentersCreate_565211(path: JsonNode; query: JsonNode;
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
  var valid_565213 = path.getOrDefault("fabricName")
  valid_565213 = validateParameter(valid_565213, JString, required = true,
                                 default = nil)
  if valid_565213 != nil:
    section.add "fabricName", valid_565213
  var valid_565214 = path.getOrDefault("subscriptionId")
  valid_565214 = validateParameter(valid_565214, JString, required = true,
                                 default = nil)
  if valid_565214 != nil:
    section.add "subscriptionId", valid_565214
  var valid_565215 = path.getOrDefault("vCenterName")
  valid_565215 = validateParameter(valid_565215, JString, required = true,
                                 default = nil)
  if valid_565215 != nil:
    section.add "vCenterName", valid_565215
  var valid_565216 = path.getOrDefault("resourceGroupName")
  valid_565216 = validateParameter(valid_565216, JString, required = true,
                                 default = nil)
  if valid_565216 != nil:
    section.add "resourceGroupName", valid_565216
  var valid_565217 = path.getOrDefault("resourceName")
  valid_565217 = validateParameter(valid_565217, JString, required = true,
                                 default = nil)
  if valid_565217 != nil:
    section.add "resourceName", valid_565217
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565218 = query.getOrDefault("api-version")
  valid_565218 = validateParameter(valid_565218, JString, required = true,
                                 default = nil)
  if valid_565218 != nil:
    section.add "api-version", valid_565218
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

proc call*(call_565220: Call_ReplicationvCentersCreate_565210; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create a vCenter object..
  ## 
  let valid = call_565220.validator(path, query, header, formData, body)
  let scheme = call_565220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565220.url(scheme.get, call_565220.host, call_565220.base,
                         call_565220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565220, url, valid)

proc call*(call_565221: Call_ReplicationvCentersCreate_565210; apiVersion: string;
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
  var path_565222 = newJObject()
  var query_565223 = newJObject()
  var body_565224 = newJObject()
  add(query_565223, "api-version", newJString(apiVersion))
  add(path_565222, "fabricName", newJString(fabricName))
  add(path_565222, "subscriptionId", newJString(subscriptionId))
  add(path_565222, "vCenterName", newJString(vCenterName))
  add(path_565222, "resourceGroupName", newJString(resourceGroupName))
  add(path_565222, "resourceName", newJString(resourceName))
  if addVCenterRequest != nil:
    body_565224 = addVCenterRequest
  result = call_565221.call(path_565222, query_565223, nil, nil, body_565224)

var replicationvCentersCreate* = Call_ReplicationvCentersCreate_565210(
    name: "replicationvCentersCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters/{vCenterName}",
    validator: validate_ReplicationvCentersCreate_565211, base: "",
    url: url_ReplicationvCentersCreate_565212, schemes: {Scheme.Https})
type
  Call_ReplicationvCentersGet_565197 = ref object of OpenApiRestCall_563566
proc url_ReplicationvCentersGet_565199(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationvCentersGet_565198(path: JsonNode; query: JsonNode;
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
  var valid_565200 = path.getOrDefault("fabricName")
  valid_565200 = validateParameter(valid_565200, JString, required = true,
                                 default = nil)
  if valid_565200 != nil:
    section.add "fabricName", valid_565200
  var valid_565201 = path.getOrDefault("subscriptionId")
  valid_565201 = validateParameter(valid_565201, JString, required = true,
                                 default = nil)
  if valid_565201 != nil:
    section.add "subscriptionId", valid_565201
  var valid_565202 = path.getOrDefault("vCenterName")
  valid_565202 = validateParameter(valid_565202, JString, required = true,
                                 default = nil)
  if valid_565202 != nil:
    section.add "vCenterName", valid_565202
  var valid_565203 = path.getOrDefault("resourceGroupName")
  valid_565203 = validateParameter(valid_565203, JString, required = true,
                                 default = nil)
  if valid_565203 != nil:
    section.add "resourceGroupName", valid_565203
  var valid_565204 = path.getOrDefault("resourceName")
  valid_565204 = validateParameter(valid_565204, JString, required = true,
                                 default = nil)
  if valid_565204 != nil:
    section.add "resourceName", valid_565204
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565205 = query.getOrDefault("api-version")
  valid_565205 = validateParameter(valid_565205, JString, required = true,
                                 default = nil)
  if valid_565205 != nil:
    section.add "api-version", valid_565205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565206: Call_ReplicationvCentersGet_565197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a registered vCenter server(Add vCenter server.)
  ## 
  let valid = call_565206.validator(path, query, header, formData, body)
  let scheme = call_565206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565206.url(scheme.get, call_565206.host, call_565206.base,
                         call_565206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565206, url, valid)

proc call*(call_565207: Call_ReplicationvCentersGet_565197; apiVersion: string;
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
  var path_565208 = newJObject()
  var query_565209 = newJObject()
  add(query_565209, "api-version", newJString(apiVersion))
  add(path_565208, "fabricName", newJString(fabricName))
  add(path_565208, "subscriptionId", newJString(subscriptionId))
  add(path_565208, "vCenterName", newJString(vCenterName))
  add(path_565208, "resourceGroupName", newJString(resourceGroupName))
  add(path_565208, "resourceName", newJString(resourceName))
  result = call_565207.call(path_565208, query_565209, nil, nil, nil)

var replicationvCentersGet* = Call_ReplicationvCentersGet_565197(
    name: "replicationvCentersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters/{vCenterName}",
    validator: validate_ReplicationvCentersGet_565198, base: "",
    url: url_ReplicationvCentersGet_565199, schemes: {Scheme.Https})
type
  Call_ReplicationvCentersUpdate_565238 = ref object of OpenApiRestCall_563566
proc url_ReplicationvCentersUpdate_565240(protocol: Scheme; host: string;
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

proc validate_ReplicationvCentersUpdate_565239(path: JsonNode; query: JsonNode;
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
  var valid_565241 = path.getOrDefault("fabricName")
  valid_565241 = validateParameter(valid_565241, JString, required = true,
                                 default = nil)
  if valid_565241 != nil:
    section.add "fabricName", valid_565241
  var valid_565242 = path.getOrDefault("subscriptionId")
  valid_565242 = validateParameter(valid_565242, JString, required = true,
                                 default = nil)
  if valid_565242 != nil:
    section.add "subscriptionId", valid_565242
  var valid_565243 = path.getOrDefault("vCenterName")
  valid_565243 = validateParameter(valid_565243, JString, required = true,
                                 default = nil)
  if valid_565243 != nil:
    section.add "vCenterName", valid_565243
  var valid_565244 = path.getOrDefault("resourceGroupName")
  valid_565244 = validateParameter(valid_565244, JString, required = true,
                                 default = nil)
  if valid_565244 != nil:
    section.add "resourceGroupName", valid_565244
  var valid_565245 = path.getOrDefault("resourceName")
  valid_565245 = validateParameter(valid_565245, JString, required = true,
                                 default = nil)
  if valid_565245 != nil:
    section.add "resourceName", valid_565245
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565246 = query.getOrDefault("api-version")
  valid_565246 = validateParameter(valid_565246, JString, required = true,
                                 default = nil)
  if valid_565246 != nil:
    section.add "api-version", valid_565246
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

proc call*(call_565248: Call_ReplicationvCentersUpdate_565238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a registered vCenter.
  ## 
  let valid = call_565248.validator(path, query, header, formData, body)
  let scheme = call_565248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565248.url(scheme.get, call_565248.host, call_565248.base,
                         call_565248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565248, url, valid)

proc call*(call_565249: Call_ReplicationvCentersUpdate_565238; apiVersion: string;
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
  var path_565250 = newJObject()
  var query_565251 = newJObject()
  var body_565252 = newJObject()
  add(query_565251, "api-version", newJString(apiVersion))
  add(path_565250, "fabricName", newJString(fabricName))
  add(path_565250, "subscriptionId", newJString(subscriptionId))
  add(path_565250, "vCenterName", newJString(vCenterName))
  add(path_565250, "resourceGroupName", newJString(resourceGroupName))
  add(path_565250, "resourceName", newJString(resourceName))
  if updateVCenterRequest != nil:
    body_565252 = updateVCenterRequest
  result = call_565249.call(path_565250, query_565251, nil, nil, body_565252)

var replicationvCentersUpdate* = Call_ReplicationvCentersUpdate_565238(
    name: "replicationvCentersUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters/{vCenterName}",
    validator: validate_ReplicationvCentersUpdate_565239, base: "",
    url: url_ReplicationvCentersUpdate_565240, schemes: {Scheme.Https})
type
  Call_ReplicationvCentersDelete_565225 = ref object of OpenApiRestCall_563566
proc url_ReplicationvCentersDelete_565227(protocol: Scheme; host: string;
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

proc validate_ReplicationvCentersDelete_565226(path: JsonNode; query: JsonNode;
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
  var valid_565228 = path.getOrDefault("fabricName")
  valid_565228 = validateParameter(valid_565228, JString, required = true,
                                 default = nil)
  if valid_565228 != nil:
    section.add "fabricName", valid_565228
  var valid_565229 = path.getOrDefault("subscriptionId")
  valid_565229 = validateParameter(valid_565229, JString, required = true,
                                 default = nil)
  if valid_565229 != nil:
    section.add "subscriptionId", valid_565229
  var valid_565230 = path.getOrDefault("vCenterName")
  valid_565230 = validateParameter(valid_565230, JString, required = true,
                                 default = nil)
  if valid_565230 != nil:
    section.add "vCenterName", valid_565230
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

proc call*(call_565234: Call_ReplicationvCentersDelete_565225; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to remove(unregister) a registered vCenter server from the vault.
  ## 
  let valid = call_565234.validator(path, query, header, formData, body)
  let scheme = call_565234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565234.url(scheme.get, call_565234.host, call_565234.base,
                         call_565234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565234, url, valid)

proc call*(call_565235: Call_ReplicationvCentersDelete_565225; apiVersion: string;
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
  var path_565236 = newJObject()
  var query_565237 = newJObject()
  add(query_565237, "api-version", newJString(apiVersion))
  add(path_565236, "fabricName", newJString(fabricName))
  add(path_565236, "subscriptionId", newJString(subscriptionId))
  add(path_565236, "vCenterName", newJString(vCenterName))
  add(path_565236, "resourceGroupName", newJString(resourceGroupName))
  add(path_565236, "resourceName", newJString(resourceName))
  result = call_565235.call(path_565236, query_565237, nil, nil, nil)

var replicationvCentersDelete* = Call_ReplicationvCentersDelete_565225(
    name: "replicationvCentersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters/{vCenterName}",
    validator: validate_ReplicationvCentersDelete_565226, base: "",
    url: url_ReplicationvCentersDelete_565227, schemes: {Scheme.Https})
type
  Call_ReplicationJobsList_565253 = ref object of OpenApiRestCall_563566
proc url_ReplicationJobsList_565255(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationJobsList_565254(path: JsonNode; query: JsonNode;
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
  var valid_565256 = path.getOrDefault("subscriptionId")
  valid_565256 = validateParameter(valid_565256, JString, required = true,
                                 default = nil)
  if valid_565256 != nil:
    section.add "subscriptionId", valid_565256
  var valid_565257 = path.getOrDefault("resourceGroupName")
  valid_565257 = validateParameter(valid_565257, JString, required = true,
                                 default = nil)
  if valid_565257 != nil:
    section.add "resourceGroupName", valid_565257
  var valid_565258 = path.getOrDefault("resourceName")
  valid_565258 = validateParameter(valid_565258, JString, required = true,
                                 default = nil)
  if valid_565258 != nil:
    section.add "resourceName", valid_565258
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565259 = query.getOrDefault("api-version")
  valid_565259 = validateParameter(valid_565259, JString, required = true,
                                 default = nil)
  if valid_565259 != nil:
    section.add "api-version", valid_565259
  var valid_565260 = query.getOrDefault("$filter")
  valid_565260 = validateParameter(valid_565260, JString, required = false,
                                 default = nil)
  if valid_565260 != nil:
    section.add "$filter", valid_565260
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565261: Call_ReplicationJobsList_565253; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of Azure Site Recovery Jobs for the vault.
  ## 
  let valid = call_565261.validator(path, query, header, formData, body)
  let scheme = call_565261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565261.url(scheme.get, call_565261.host, call_565261.base,
                         call_565261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565261, url, valid)

proc call*(call_565262: Call_ReplicationJobsList_565253; apiVersion: string;
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
  var path_565263 = newJObject()
  var query_565264 = newJObject()
  add(query_565264, "api-version", newJString(apiVersion))
  add(path_565263, "subscriptionId", newJString(subscriptionId))
  add(path_565263, "resourceGroupName", newJString(resourceGroupName))
  add(query_565264, "$filter", newJString(Filter))
  add(path_565263, "resourceName", newJString(resourceName))
  result = call_565262.call(path_565263, query_565264, nil, nil, nil)

var replicationJobsList* = Call_ReplicationJobsList_565253(
    name: "replicationJobsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs",
    validator: validate_ReplicationJobsList_565254, base: "",
    url: url_ReplicationJobsList_565255, schemes: {Scheme.Https})
type
  Call_ReplicationJobsExport_565265 = ref object of OpenApiRestCall_563566
proc url_ReplicationJobsExport_565267(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationJobsExport_565266(path: JsonNode; query: JsonNode;
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
  var valid_565268 = path.getOrDefault("subscriptionId")
  valid_565268 = validateParameter(valid_565268, JString, required = true,
                                 default = nil)
  if valid_565268 != nil:
    section.add "subscriptionId", valid_565268
  var valid_565269 = path.getOrDefault("resourceGroupName")
  valid_565269 = validateParameter(valid_565269, JString, required = true,
                                 default = nil)
  if valid_565269 != nil:
    section.add "resourceGroupName", valid_565269
  var valid_565270 = path.getOrDefault("resourceName")
  valid_565270 = validateParameter(valid_565270, JString, required = true,
                                 default = nil)
  if valid_565270 != nil:
    section.add "resourceName", valid_565270
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565271 = query.getOrDefault("api-version")
  valid_565271 = validateParameter(valid_565271, JString, required = true,
                                 default = nil)
  if valid_565271 != nil:
    section.add "api-version", valid_565271
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

proc call*(call_565273: Call_ReplicationJobsExport_565265; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to export the details of the Azure Site Recovery jobs of the vault.
  ## 
  let valid = call_565273.validator(path, query, header, formData, body)
  let scheme = call_565273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565273.url(scheme.get, call_565273.host, call_565273.base,
                         call_565273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565273, url, valid)

proc call*(call_565274: Call_ReplicationJobsExport_565265; apiVersion: string;
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
  var path_565275 = newJObject()
  var query_565276 = newJObject()
  var body_565277 = newJObject()
  add(query_565276, "api-version", newJString(apiVersion))
  add(path_565275, "subscriptionId", newJString(subscriptionId))
  if jobQueryParameter != nil:
    body_565277 = jobQueryParameter
  add(path_565275, "resourceGroupName", newJString(resourceGroupName))
  add(path_565275, "resourceName", newJString(resourceName))
  result = call_565274.call(path_565275, query_565276, nil, nil, body_565277)

var replicationJobsExport* = Call_ReplicationJobsExport_565265(
    name: "replicationJobsExport", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/export",
    validator: validate_ReplicationJobsExport_565266, base: "",
    url: url_ReplicationJobsExport_565267, schemes: {Scheme.Https})
type
  Call_ReplicationJobsGet_565278 = ref object of OpenApiRestCall_563566
proc url_ReplicationJobsGet_565280(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationJobsGet_565279(path: JsonNode; query: JsonNode;
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
  var valid_565281 = path.getOrDefault("subscriptionId")
  valid_565281 = validateParameter(valid_565281, JString, required = true,
                                 default = nil)
  if valid_565281 != nil:
    section.add "subscriptionId", valid_565281
  var valid_565282 = path.getOrDefault("resourceGroupName")
  valid_565282 = validateParameter(valid_565282, JString, required = true,
                                 default = nil)
  if valid_565282 != nil:
    section.add "resourceGroupName", valid_565282
  var valid_565283 = path.getOrDefault("resourceName")
  valid_565283 = validateParameter(valid_565283, JString, required = true,
                                 default = nil)
  if valid_565283 != nil:
    section.add "resourceName", valid_565283
  var valid_565284 = path.getOrDefault("jobName")
  valid_565284 = validateParameter(valid_565284, JString, required = true,
                                 default = nil)
  if valid_565284 != nil:
    section.add "jobName", valid_565284
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565285 = query.getOrDefault("api-version")
  valid_565285 = validateParameter(valid_565285, JString, required = true,
                                 default = nil)
  if valid_565285 != nil:
    section.add "api-version", valid_565285
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565286: Call_ReplicationJobsGet_565278; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the details of an Azure Site Recovery job.
  ## 
  let valid = call_565286.validator(path, query, header, formData, body)
  let scheme = call_565286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565286.url(scheme.get, call_565286.host, call_565286.base,
                         call_565286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565286, url, valid)

proc call*(call_565287: Call_ReplicationJobsGet_565278; apiVersion: string;
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
  var path_565288 = newJObject()
  var query_565289 = newJObject()
  add(query_565289, "api-version", newJString(apiVersion))
  add(path_565288, "subscriptionId", newJString(subscriptionId))
  add(path_565288, "resourceGroupName", newJString(resourceGroupName))
  add(path_565288, "resourceName", newJString(resourceName))
  add(path_565288, "jobName", newJString(jobName))
  result = call_565287.call(path_565288, query_565289, nil, nil, nil)

var replicationJobsGet* = Call_ReplicationJobsGet_565278(
    name: "replicationJobsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/{jobName}",
    validator: validate_ReplicationJobsGet_565279, base: "",
    url: url_ReplicationJobsGet_565280, schemes: {Scheme.Https})
type
  Call_ReplicationJobsCancel_565290 = ref object of OpenApiRestCall_563566
proc url_ReplicationJobsCancel_565292(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationJobsCancel_565291(path: JsonNode; query: JsonNode;
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
  var valid_565293 = path.getOrDefault("subscriptionId")
  valid_565293 = validateParameter(valid_565293, JString, required = true,
                                 default = nil)
  if valid_565293 != nil:
    section.add "subscriptionId", valid_565293
  var valid_565294 = path.getOrDefault("resourceGroupName")
  valid_565294 = validateParameter(valid_565294, JString, required = true,
                                 default = nil)
  if valid_565294 != nil:
    section.add "resourceGroupName", valid_565294
  var valid_565295 = path.getOrDefault("resourceName")
  valid_565295 = validateParameter(valid_565295, JString, required = true,
                                 default = nil)
  if valid_565295 != nil:
    section.add "resourceName", valid_565295
  var valid_565296 = path.getOrDefault("jobName")
  valid_565296 = validateParameter(valid_565296, JString, required = true,
                                 default = nil)
  if valid_565296 != nil:
    section.add "jobName", valid_565296
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565297 = query.getOrDefault("api-version")
  valid_565297 = validateParameter(valid_565297, JString, required = true,
                                 default = nil)
  if valid_565297 != nil:
    section.add "api-version", valid_565297
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565298: Call_ReplicationJobsCancel_565290; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to cancel an Azure Site Recovery job.
  ## 
  let valid = call_565298.validator(path, query, header, formData, body)
  let scheme = call_565298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565298.url(scheme.get, call_565298.host, call_565298.base,
                         call_565298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565298, url, valid)

proc call*(call_565299: Call_ReplicationJobsCancel_565290; apiVersion: string;
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
  var path_565300 = newJObject()
  var query_565301 = newJObject()
  add(query_565301, "api-version", newJString(apiVersion))
  add(path_565300, "subscriptionId", newJString(subscriptionId))
  add(path_565300, "resourceGroupName", newJString(resourceGroupName))
  add(path_565300, "resourceName", newJString(resourceName))
  add(path_565300, "jobName", newJString(jobName))
  result = call_565299.call(path_565300, query_565301, nil, nil, nil)

var replicationJobsCancel* = Call_ReplicationJobsCancel_565290(
    name: "replicationJobsCancel", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/{jobName}/cancel",
    validator: validate_ReplicationJobsCancel_565291, base: "",
    url: url_ReplicationJobsCancel_565292, schemes: {Scheme.Https})
type
  Call_ReplicationJobsRestart_565302 = ref object of OpenApiRestCall_563566
proc url_ReplicationJobsRestart_565304(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationJobsRestart_565303(path: JsonNode; query: JsonNode;
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
  var valid_565305 = path.getOrDefault("subscriptionId")
  valid_565305 = validateParameter(valid_565305, JString, required = true,
                                 default = nil)
  if valid_565305 != nil:
    section.add "subscriptionId", valid_565305
  var valid_565306 = path.getOrDefault("resourceGroupName")
  valid_565306 = validateParameter(valid_565306, JString, required = true,
                                 default = nil)
  if valid_565306 != nil:
    section.add "resourceGroupName", valid_565306
  var valid_565307 = path.getOrDefault("resourceName")
  valid_565307 = validateParameter(valid_565307, JString, required = true,
                                 default = nil)
  if valid_565307 != nil:
    section.add "resourceName", valid_565307
  var valid_565308 = path.getOrDefault("jobName")
  valid_565308 = validateParameter(valid_565308, JString, required = true,
                                 default = nil)
  if valid_565308 != nil:
    section.add "jobName", valid_565308
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565309 = query.getOrDefault("api-version")
  valid_565309 = validateParameter(valid_565309, JString, required = true,
                                 default = nil)
  if valid_565309 != nil:
    section.add "api-version", valid_565309
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565310: Call_ReplicationJobsRestart_565302; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to restart an Azure Site Recovery job.
  ## 
  let valid = call_565310.validator(path, query, header, formData, body)
  let scheme = call_565310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565310.url(scheme.get, call_565310.host, call_565310.base,
                         call_565310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565310, url, valid)

proc call*(call_565311: Call_ReplicationJobsRestart_565302; apiVersion: string;
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
  var path_565312 = newJObject()
  var query_565313 = newJObject()
  add(query_565313, "api-version", newJString(apiVersion))
  add(path_565312, "subscriptionId", newJString(subscriptionId))
  add(path_565312, "resourceGroupName", newJString(resourceGroupName))
  add(path_565312, "resourceName", newJString(resourceName))
  add(path_565312, "jobName", newJString(jobName))
  result = call_565311.call(path_565312, query_565313, nil, nil, nil)

var replicationJobsRestart* = Call_ReplicationJobsRestart_565302(
    name: "replicationJobsRestart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/{jobName}/restart",
    validator: validate_ReplicationJobsRestart_565303, base: "",
    url: url_ReplicationJobsRestart_565304, schemes: {Scheme.Https})
type
  Call_ReplicationJobsResume_565314 = ref object of OpenApiRestCall_563566
proc url_ReplicationJobsResume_565316(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationJobsResume_565315(path: JsonNode; query: JsonNode;
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
  var valid_565317 = path.getOrDefault("subscriptionId")
  valid_565317 = validateParameter(valid_565317, JString, required = true,
                                 default = nil)
  if valid_565317 != nil:
    section.add "subscriptionId", valid_565317
  var valid_565318 = path.getOrDefault("resourceGroupName")
  valid_565318 = validateParameter(valid_565318, JString, required = true,
                                 default = nil)
  if valid_565318 != nil:
    section.add "resourceGroupName", valid_565318
  var valid_565319 = path.getOrDefault("resourceName")
  valid_565319 = validateParameter(valid_565319, JString, required = true,
                                 default = nil)
  if valid_565319 != nil:
    section.add "resourceName", valid_565319
  var valid_565320 = path.getOrDefault("jobName")
  valid_565320 = validateParameter(valid_565320, JString, required = true,
                                 default = nil)
  if valid_565320 != nil:
    section.add "jobName", valid_565320
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565321 = query.getOrDefault("api-version")
  valid_565321 = validateParameter(valid_565321, JString, required = true,
                                 default = nil)
  if valid_565321 != nil:
    section.add "api-version", valid_565321
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

proc call*(call_565323: Call_ReplicationJobsResume_565314; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to resume an Azure Site Recovery job
  ## 
  let valid = call_565323.validator(path, query, header, formData, body)
  let scheme = call_565323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565323.url(scheme.get, call_565323.host, call_565323.base,
                         call_565323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565323, url, valid)

proc call*(call_565324: Call_ReplicationJobsResume_565314;
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
  var path_565325 = newJObject()
  var query_565326 = newJObject()
  var body_565327 = newJObject()
  if resumeJobParams != nil:
    body_565327 = resumeJobParams
  add(query_565326, "api-version", newJString(apiVersion))
  add(path_565325, "subscriptionId", newJString(subscriptionId))
  add(path_565325, "resourceGroupName", newJString(resourceGroupName))
  add(path_565325, "resourceName", newJString(resourceName))
  add(path_565325, "jobName", newJString(jobName))
  result = call_565324.call(path_565325, query_565326, nil, nil, body_565327)

var replicationJobsResume* = Call_ReplicationJobsResume_565314(
    name: "replicationJobsResume", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/{jobName}/resume",
    validator: validate_ReplicationJobsResume_565315, base: "",
    url: url_ReplicationJobsResume_565316, schemes: {Scheme.Https})
type
  Call_ReplicationMigrationItemsList_565328 = ref object of OpenApiRestCall_563566
proc url_ReplicationMigrationItemsList_565330(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/replicationMigrationItems")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationMigrationItemsList_565329(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_565331 = path.getOrDefault("subscriptionId")
  valid_565331 = validateParameter(valid_565331, JString, required = true,
                                 default = nil)
  if valid_565331 != nil:
    section.add "subscriptionId", valid_565331
  var valid_565332 = path.getOrDefault("resourceGroupName")
  valid_565332 = validateParameter(valid_565332, JString, required = true,
                                 default = nil)
  if valid_565332 != nil:
    section.add "resourceGroupName", valid_565332
  var valid_565333 = path.getOrDefault("resourceName")
  valid_565333 = validateParameter(valid_565333, JString, required = true,
                                 default = nil)
  if valid_565333 != nil:
    section.add "resourceName", valid_565333
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   skipToken: JString
  ##            : The pagination token.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565334 = query.getOrDefault("api-version")
  valid_565334 = validateParameter(valid_565334, JString, required = true,
                                 default = nil)
  if valid_565334 != nil:
    section.add "api-version", valid_565334
  var valid_565335 = query.getOrDefault("skipToken")
  valid_565335 = validateParameter(valid_565335, JString, required = false,
                                 default = nil)
  if valid_565335 != nil:
    section.add "skipToken", valid_565335
  var valid_565336 = query.getOrDefault("$filter")
  valid_565336 = validateParameter(valid_565336, JString, required = false,
                                 default = nil)
  if valid_565336 != nil:
    section.add "$filter", valid_565336
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565337: Call_ReplicationMigrationItemsList_565328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565337.validator(path, query, header, formData, body)
  let scheme = call_565337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565337.url(scheme.get, call_565337.host, call_565337.base,
                         call_565337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565337, url, valid)

proc call*(call_565338: Call_ReplicationMigrationItemsList_565328;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string; skipToken: string = ""; Filter: string = ""): Recallable =
  ## replicationMigrationItemsList
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   skipToken: string
  ##            : The pagination token.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   Filter: string
  ##         : OData filter options.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565339 = newJObject()
  var query_565340 = newJObject()
  add(query_565340, "api-version", newJString(apiVersion))
  add(query_565340, "skipToken", newJString(skipToken))
  add(path_565339, "subscriptionId", newJString(subscriptionId))
  add(path_565339, "resourceGroupName", newJString(resourceGroupName))
  add(query_565340, "$filter", newJString(Filter))
  add(path_565339, "resourceName", newJString(resourceName))
  result = call_565338.call(path_565339, query_565340, nil, nil, nil)

var replicationMigrationItemsList* = Call_ReplicationMigrationItemsList_565328(
    name: "replicationMigrationItemsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationMigrationItems",
    validator: validate_ReplicationMigrationItemsList_565329, base: "",
    url: url_ReplicationMigrationItemsList_565330, schemes: {Scheme.Https})
type
  Call_ReplicationNetworkMappingsList_565341 = ref object of OpenApiRestCall_563566
proc url_ReplicationNetworkMappingsList_565343(protocol: Scheme; host: string;
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

proc validate_ReplicationNetworkMappingsList_565342(path: JsonNode;
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
  var valid_565344 = path.getOrDefault("subscriptionId")
  valid_565344 = validateParameter(valid_565344, JString, required = true,
                                 default = nil)
  if valid_565344 != nil:
    section.add "subscriptionId", valid_565344
  var valid_565345 = path.getOrDefault("resourceGroupName")
  valid_565345 = validateParameter(valid_565345, JString, required = true,
                                 default = nil)
  if valid_565345 != nil:
    section.add "resourceGroupName", valid_565345
  var valid_565346 = path.getOrDefault("resourceName")
  valid_565346 = validateParameter(valid_565346, JString, required = true,
                                 default = nil)
  if valid_565346 != nil:
    section.add "resourceName", valid_565346
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565347 = query.getOrDefault("api-version")
  valid_565347 = validateParameter(valid_565347, JString, required = true,
                                 default = nil)
  if valid_565347 != nil:
    section.add "api-version", valid_565347
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565348: Call_ReplicationNetworkMappingsList_565341; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all ASR network mappings in the vault.
  ## 
  let valid = call_565348.validator(path, query, header, formData, body)
  let scheme = call_565348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565348.url(scheme.get, call_565348.host, call_565348.base,
                         call_565348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565348, url, valid)

proc call*(call_565349: Call_ReplicationNetworkMappingsList_565341;
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
  var path_565350 = newJObject()
  var query_565351 = newJObject()
  add(query_565351, "api-version", newJString(apiVersion))
  add(path_565350, "subscriptionId", newJString(subscriptionId))
  add(path_565350, "resourceGroupName", newJString(resourceGroupName))
  add(path_565350, "resourceName", newJString(resourceName))
  result = call_565349.call(path_565350, query_565351, nil, nil, nil)

var replicationNetworkMappingsList* = Call_ReplicationNetworkMappingsList_565341(
    name: "replicationNetworkMappingsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationNetworkMappings",
    validator: validate_ReplicationNetworkMappingsList_565342, base: "",
    url: url_ReplicationNetworkMappingsList_565343, schemes: {Scheme.Https})
type
  Call_ReplicationNetworksList_565352 = ref object of OpenApiRestCall_563566
proc url_ReplicationNetworksList_565354(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationNetworksList_565353(path: JsonNode; query: JsonNode;
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
  var valid_565355 = path.getOrDefault("subscriptionId")
  valid_565355 = validateParameter(valid_565355, JString, required = true,
                                 default = nil)
  if valid_565355 != nil:
    section.add "subscriptionId", valid_565355
  var valid_565356 = path.getOrDefault("resourceGroupName")
  valid_565356 = validateParameter(valid_565356, JString, required = true,
                                 default = nil)
  if valid_565356 != nil:
    section.add "resourceGroupName", valid_565356
  var valid_565357 = path.getOrDefault("resourceName")
  valid_565357 = validateParameter(valid_565357, JString, required = true,
                                 default = nil)
  if valid_565357 != nil:
    section.add "resourceName", valid_565357
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565358 = query.getOrDefault("api-version")
  valid_565358 = validateParameter(valid_565358, JString, required = true,
                                 default = nil)
  if valid_565358 != nil:
    section.add "api-version", valid_565358
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565359: Call_ReplicationNetworksList_565352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the networks available in a vault
  ## 
  let valid = call_565359.validator(path, query, header, formData, body)
  let scheme = call_565359.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565359.url(scheme.get, call_565359.host, call_565359.base,
                         call_565359.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565359, url, valid)

proc call*(call_565360: Call_ReplicationNetworksList_565352; apiVersion: string;
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
  var path_565361 = newJObject()
  var query_565362 = newJObject()
  add(query_565362, "api-version", newJString(apiVersion))
  add(path_565361, "subscriptionId", newJString(subscriptionId))
  add(path_565361, "resourceGroupName", newJString(resourceGroupName))
  add(path_565361, "resourceName", newJString(resourceName))
  result = call_565360.call(path_565361, query_565362, nil, nil, nil)

var replicationNetworksList* = Call_ReplicationNetworksList_565352(
    name: "replicationNetworksList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationNetworks",
    validator: validate_ReplicationNetworksList_565353, base: "",
    url: url_ReplicationNetworksList_565354, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesList_565363 = ref object of OpenApiRestCall_563566
proc url_ReplicationPoliciesList_565365(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationPoliciesList_565364(path: JsonNode; query: JsonNode;
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
  var valid_565366 = path.getOrDefault("subscriptionId")
  valid_565366 = validateParameter(valid_565366, JString, required = true,
                                 default = nil)
  if valid_565366 != nil:
    section.add "subscriptionId", valid_565366
  var valid_565367 = path.getOrDefault("resourceGroupName")
  valid_565367 = validateParameter(valid_565367, JString, required = true,
                                 default = nil)
  if valid_565367 != nil:
    section.add "resourceGroupName", valid_565367
  var valid_565368 = path.getOrDefault("resourceName")
  valid_565368 = validateParameter(valid_565368, JString, required = true,
                                 default = nil)
  if valid_565368 != nil:
    section.add "resourceName", valid_565368
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565369 = query.getOrDefault("api-version")
  valid_565369 = validateParameter(valid_565369, JString, required = true,
                                 default = nil)
  if valid_565369 != nil:
    section.add "api-version", valid_565369
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565370: Call_ReplicationPoliciesList_565363; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the replication policies for a vault.
  ## 
  let valid = call_565370.validator(path, query, header, formData, body)
  let scheme = call_565370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565370.url(scheme.get, call_565370.host, call_565370.base,
                         call_565370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565370, url, valid)

proc call*(call_565371: Call_ReplicationPoliciesList_565363; apiVersion: string;
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
  var path_565372 = newJObject()
  var query_565373 = newJObject()
  add(query_565373, "api-version", newJString(apiVersion))
  add(path_565372, "subscriptionId", newJString(subscriptionId))
  add(path_565372, "resourceGroupName", newJString(resourceGroupName))
  add(path_565372, "resourceName", newJString(resourceName))
  result = call_565371.call(path_565372, query_565373, nil, nil, nil)

var replicationPoliciesList* = Call_ReplicationPoliciesList_565363(
    name: "replicationPoliciesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies",
    validator: validate_ReplicationPoliciesList_565364, base: "",
    url: url_ReplicationPoliciesList_565365, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesCreate_565386 = ref object of OpenApiRestCall_563566
proc url_ReplicationPoliciesCreate_565388(protocol: Scheme; host: string;
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

proc validate_ReplicationPoliciesCreate_565387(path: JsonNode; query: JsonNode;
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
  var valid_565389 = path.getOrDefault("policyName")
  valid_565389 = validateParameter(valid_565389, JString, required = true,
                                 default = nil)
  if valid_565389 != nil:
    section.add "policyName", valid_565389
  var valid_565390 = path.getOrDefault("subscriptionId")
  valid_565390 = validateParameter(valid_565390, JString, required = true,
                                 default = nil)
  if valid_565390 != nil:
    section.add "subscriptionId", valid_565390
  var valid_565391 = path.getOrDefault("resourceGroupName")
  valid_565391 = validateParameter(valid_565391, JString, required = true,
                                 default = nil)
  if valid_565391 != nil:
    section.add "resourceGroupName", valid_565391
  var valid_565392 = path.getOrDefault("resourceName")
  valid_565392 = validateParameter(valid_565392, JString, required = true,
                                 default = nil)
  if valid_565392 != nil:
    section.add "resourceName", valid_565392
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565393 = query.getOrDefault("api-version")
  valid_565393 = validateParameter(valid_565393, JString, required = true,
                                 default = nil)
  if valid_565393 != nil:
    section.add "api-version", valid_565393
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

proc call*(call_565395: Call_ReplicationPoliciesCreate_565386; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create a replication policy
  ## 
  let valid = call_565395.validator(path, query, header, formData, body)
  let scheme = call_565395.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565395.url(scheme.get, call_565395.host, call_565395.base,
                         call_565395.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565395, url, valid)

proc call*(call_565396: Call_ReplicationPoliciesCreate_565386; policyName: string;
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
  var path_565397 = newJObject()
  var query_565398 = newJObject()
  var body_565399 = newJObject()
  add(path_565397, "policyName", newJString(policyName))
  add(query_565398, "api-version", newJString(apiVersion))
  if input != nil:
    body_565399 = input
  add(path_565397, "subscriptionId", newJString(subscriptionId))
  add(path_565397, "resourceGroupName", newJString(resourceGroupName))
  add(path_565397, "resourceName", newJString(resourceName))
  result = call_565396.call(path_565397, query_565398, nil, nil, body_565399)

var replicationPoliciesCreate* = Call_ReplicationPoliciesCreate_565386(
    name: "replicationPoliciesCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies/{policyName}",
    validator: validate_ReplicationPoliciesCreate_565387, base: "",
    url: url_ReplicationPoliciesCreate_565388, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesGet_565374 = ref object of OpenApiRestCall_563566
proc url_ReplicationPoliciesGet_565376(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationPoliciesGet_565375(path: JsonNode; query: JsonNode;
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
  var valid_565377 = path.getOrDefault("policyName")
  valid_565377 = validateParameter(valid_565377, JString, required = true,
                                 default = nil)
  if valid_565377 != nil:
    section.add "policyName", valid_565377
  var valid_565378 = path.getOrDefault("subscriptionId")
  valid_565378 = validateParameter(valid_565378, JString, required = true,
                                 default = nil)
  if valid_565378 != nil:
    section.add "subscriptionId", valid_565378
  var valid_565379 = path.getOrDefault("resourceGroupName")
  valid_565379 = validateParameter(valid_565379, JString, required = true,
                                 default = nil)
  if valid_565379 != nil:
    section.add "resourceGroupName", valid_565379
  var valid_565380 = path.getOrDefault("resourceName")
  valid_565380 = validateParameter(valid_565380, JString, required = true,
                                 default = nil)
  if valid_565380 != nil:
    section.add "resourceName", valid_565380
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565381 = query.getOrDefault("api-version")
  valid_565381 = validateParameter(valid_565381, JString, required = true,
                                 default = nil)
  if valid_565381 != nil:
    section.add "api-version", valid_565381
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565382: Call_ReplicationPoliciesGet_565374; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a replication policy.
  ## 
  let valid = call_565382.validator(path, query, header, formData, body)
  let scheme = call_565382.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565382.url(scheme.get, call_565382.host, call_565382.base,
                         call_565382.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565382, url, valid)

proc call*(call_565383: Call_ReplicationPoliciesGet_565374; policyName: string;
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
  var path_565384 = newJObject()
  var query_565385 = newJObject()
  add(path_565384, "policyName", newJString(policyName))
  add(query_565385, "api-version", newJString(apiVersion))
  add(path_565384, "subscriptionId", newJString(subscriptionId))
  add(path_565384, "resourceGroupName", newJString(resourceGroupName))
  add(path_565384, "resourceName", newJString(resourceName))
  result = call_565383.call(path_565384, query_565385, nil, nil, nil)

var replicationPoliciesGet* = Call_ReplicationPoliciesGet_565374(
    name: "replicationPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies/{policyName}",
    validator: validate_ReplicationPoliciesGet_565375, base: "",
    url: url_ReplicationPoliciesGet_565376, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesUpdate_565412 = ref object of OpenApiRestCall_563566
proc url_ReplicationPoliciesUpdate_565414(protocol: Scheme; host: string;
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

proc validate_ReplicationPoliciesUpdate_565413(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update a replication policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : Policy Id.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_565415 = path.getOrDefault("policyName")
  valid_565415 = validateParameter(valid_565415, JString, required = true,
                                 default = nil)
  if valid_565415 != nil:
    section.add "policyName", valid_565415
  var valid_565416 = path.getOrDefault("subscriptionId")
  valid_565416 = validateParameter(valid_565416, JString, required = true,
                                 default = nil)
  if valid_565416 != nil:
    section.add "subscriptionId", valid_565416
  var valid_565417 = path.getOrDefault("resourceGroupName")
  valid_565417 = validateParameter(valid_565417, JString, required = true,
                                 default = nil)
  if valid_565417 != nil:
    section.add "resourceGroupName", valid_565417
  var valid_565418 = path.getOrDefault("resourceName")
  valid_565418 = validateParameter(valid_565418, JString, required = true,
                                 default = nil)
  if valid_565418 != nil:
    section.add "resourceName", valid_565418
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565419 = query.getOrDefault("api-version")
  valid_565419 = validateParameter(valid_565419, JString, required = true,
                                 default = nil)
  if valid_565419 != nil:
    section.add "api-version", valid_565419
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Update Policy Input
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565421: Call_ReplicationPoliciesUpdate_565412; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a replication policy.
  ## 
  let valid = call_565421.validator(path, query, header, formData, body)
  let scheme = call_565421.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565421.url(scheme.get, call_565421.host, call_565421.base,
                         call_565421.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565421, url, valid)

proc call*(call_565422: Call_ReplicationPoliciesUpdate_565412; policyName: string;
          apiVersion: string; input: JsonNode; subscriptionId: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## replicationPoliciesUpdate
  ## The operation to update a replication policy.
  ##   policyName: string (required)
  ##             : Policy Id.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   input: JObject (required)
  ##        : Update Policy Input
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565423 = newJObject()
  var query_565424 = newJObject()
  var body_565425 = newJObject()
  add(path_565423, "policyName", newJString(policyName))
  add(query_565424, "api-version", newJString(apiVersion))
  if input != nil:
    body_565425 = input
  add(path_565423, "subscriptionId", newJString(subscriptionId))
  add(path_565423, "resourceGroupName", newJString(resourceGroupName))
  add(path_565423, "resourceName", newJString(resourceName))
  result = call_565422.call(path_565423, query_565424, nil, nil, body_565425)

var replicationPoliciesUpdate* = Call_ReplicationPoliciesUpdate_565412(
    name: "replicationPoliciesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies/{policyName}",
    validator: validate_ReplicationPoliciesUpdate_565413, base: "",
    url: url_ReplicationPoliciesUpdate_565414, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesDelete_565400 = ref object of OpenApiRestCall_563566
proc url_ReplicationPoliciesDelete_565402(protocol: Scheme; host: string;
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

proc validate_ReplicationPoliciesDelete_565401(path: JsonNode; query: JsonNode;
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
  var valid_565403 = path.getOrDefault("policyName")
  valid_565403 = validateParameter(valid_565403, JString, required = true,
                                 default = nil)
  if valid_565403 != nil:
    section.add "policyName", valid_565403
  var valid_565404 = path.getOrDefault("subscriptionId")
  valid_565404 = validateParameter(valid_565404, JString, required = true,
                                 default = nil)
  if valid_565404 != nil:
    section.add "subscriptionId", valid_565404
  var valid_565405 = path.getOrDefault("resourceGroupName")
  valid_565405 = validateParameter(valid_565405, JString, required = true,
                                 default = nil)
  if valid_565405 != nil:
    section.add "resourceGroupName", valid_565405
  var valid_565406 = path.getOrDefault("resourceName")
  valid_565406 = validateParameter(valid_565406, JString, required = true,
                                 default = nil)
  if valid_565406 != nil:
    section.add "resourceName", valid_565406
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565407 = query.getOrDefault("api-version")
  valid_565407 = validateParameter(valid_565407, JString, required = true,
                                 default = nil)
  if valid_565407 != nil:
    section.add "api-version", valid_565407
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565408: Call_ReplicationPoliciesDelete_565400; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete a replication policy.
  ## 
  let valid = call_565408.validator(path, query, header, formData, body)
  let scheme = call_565408.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565408.url(scheme.get, call_565408.host, call_565408.base,
                         call_565408.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565408, url, valid)

proc call*(call_565409: Call_ReplicationPoliciesDelete_565400; policyName: string;
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
  var path_565410 = newJObject()
  var query_565411 = newJObject()
  add(path_565410, "policyName", newJString(policyName))
  add(query_565411, "api-version", newJString(apiVersion))
  add(path_565410, "subscriptionId", newJString(subscriptionId))
  add(path_565410, "resourceGroupName", newJString(resourceGroupName))
  add(path_565410, "resourceName", newJString(resourceName))
  result = call_565409.call(path_565410, query_565411, nil, nil, nil)

var replicationPoliciesDelete* = Call_ReplicationPoliciesDelete_565400(
    name: "replicationPoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies/{policyName}",
    validator: validate_ReplicationPoliciesDelete_565401, base: "",
    url: url_ReplicationPoliciesDelete_565402, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsList_565426 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectedItemsList_565428(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectedItemsList_565427(path: JsonNode; query: JsonNode;
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
  var valid_565429 = path.getOrDefault("subscriptionId")
  valid_565429 = validateParameter(valid_565429, JString, required = true,
                                 default = nil)
  if valid_565429 != nil:
    section.add "subscriptionId", valid_565429
  var valid_565430 = path.getOrDefault("resourceGroupName")
  valid_565430 = validateParameter(valid_565430, JString, required = true,
                                 default = nil)
  if valid_565430 != nil:
    section.add "resourceGroupName", valid_565430
  var valid_565431 = path.getOrDefault("resourceName")
  valid_565431 = validateParameter(valid_565431, JString, required = true,
                                 default = nil)
  if valid_565431 != nil:
    section.add "resourceName", valid_565431
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
  var valid_565432 = query.getOrDefault("api-version")
  valid_565432 = validateParameter(valid_565432, JString, required = true,
                                 default = nil)
  if valid_565432 != nil:
    section.add "api-version", valid_565432
  var valid_565433 = query.getOrDefault("skipToken")
  valid_565433 = validateParameter(valid_565433, JString, required = false,
                                 default = nil)
  if valid_565433 != nil:
    section.add "skipToken", valid_565433
  var valid_565434 = query.getOrDefault("$filter")
  valid_565434 = validateParameter(valid_565434, JString, required = false,
                                 default = nil)
  if valid_565434 != nil:
    section.add "$filter", valid_565434
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565435: Call_ReplicationProtectedItemsList_565426; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of ASR replication protected items in the vault.
  ## 
  let valid = call_565435.validator(path, query, header, formData, body)
  let scheme = call_565435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565435.url(scheme.get, call_565435.host, call_565435.base,
                         call_565435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565435, url, valid)

proc call*(call_565436: Call_ReplicationProtectedItemsList_565426;
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
  var path_565437 = newJObject()
  var query_565438 = newJObject()
  add(query_565438, "api-version", newJString(apiVersion))
  add(query_565438, "skipToken", newJString(skipToken))
  add(path_565437, "subscriptionId", newJString(subscriptionId))
  add(path_565437, "resourceGroupName", newJString(resourceGroupName))
  add(query_565438, "$filter", newJString(Filter))
  add(path_565437, "resourceName", newJString(resourceName))
  result = call_565436.call(path_565437, query_565438, nil, nil, nil)

var replicationProtectedItemsList* = Call_ReplicationProtectedItemsList_565426(
    name: "replicationProtectedItemsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationProtectedItems",
    validator: validate_ReplicationProtectedItemsList_565427, base: "",
    url: url_ReplicationProtectedItemsList_565428, schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsList_565439 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectionContainerMappingsList_565441(protocol: Scheme;
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

proc validate_ReplicationProtectionContainerMappingsList_565440(path: JsonNode;
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
  var valid_565442 = path.getOrDefault("subscriptionId")
  valid_565442 = validateParameter(valid_565442, JString, required = true,
                                 default = nil)
  if valid_565442 != nil:
    section.add "subscriptionId", valid_565442
  var valid_565443 = path.getOrDefault("resourceGroupName")
  valid_565443 = validateParameter(valid_565443, JString, required = true,
                                 default = nil)
  if valid_565443 != nil:
    section.add "resourceGroupName", valid_565443
  var valid_565444 = path.getOrDefault("resourceName")
  valid_565444 = validateParameter(valid_565444, JString, required = true,
                                 default = nil)
  if valid_565444 != nil:
    section.add "resourceName", valid_565444
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565445 = query.getOrDefault("api-version")
  valid_565445 = validateParameter(valid_565445, JString, required = true,
                                 default = nil)
  if valid_565445 != nil:
    section.add "api-version", valid_565445
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565446: Call_ReplicationProtectionContainerMappingsList_565439;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the protection container mappings in the vault.
  ## 
  let valid = call_565446.validator(path, query, header, formData, body)
  let scheme = call_565446.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565446.url(scheme.get, call_565446.host, call_565446.base,
                         call_565446.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565446, url, valid)

proc call*(call_565447: Call_ReplicationProtectionContainerMappingsList_565439;
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
  var path_565448 = newJObject()
  var query_565449 = newJObject()
  add(query_565449, "api-version", newJString(apiVersion))
  add(path_565448, "subscriptionId", newJString(subscriptionId))
  add(path_565448, "resourceGroupName", newJString(resourceGroupName))
  add(path_565448, "resourceName", newJString(resourceName))
  result = call_565447.call(path_565448, query_565449, nil, nil, nil)

var replicationProtectionContainerMappingsList* = Call_ReplicationProtectionContainerMappingsList_565439(
    name: "replicationProtectionContainerMappingsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationProtectionContainerMappings",
    validator: validate_ReplicationProtectionContainerMappingsList_565440,
    base: "", url: url_ReplicationProtectionContainerMappingsList_565441,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersList_565450 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectionContainersList_565452(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectionContainersList_565451(path: JsonNode;
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
  var valid_565453 = path.getOrDefault("subscriptionId")
  valid_565453 = validateParameter(valid_565453, JString, required = true,
                                 default = nil)
  if valid_565453 != nil:
    section.add "subscriptionId", valid_565453
  var valid_565454 = path.getOrDefault("resourceGroupName")
  valid_565454 = validateParameter(valid_565454, JString, required = true,
                                 default = nil)
  if valid_565454 != nil:
    section.add "resourceGroupName", valid_565454
  var valid_565455 = path.getOrDefault("resourceName")
  valid_565455 = validateParameter(valid_565455, JString, required = true,
                                 default = nil)
  if valid_565455 != nil:
    section.add "resourceName", valid_565455
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565456 = query.getOrDefault("api-version")
  valid_565456 = validateParameter(valid_565456, JString, required = true,
                                 default = nil)
  if valid_565456 != nil:
    section.add "api-version", valid_565456
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565457: Call_ReplicationProtectionContainersList_565450;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the protection containers in a vault.
  ## 
  let valid = call_565457.validator(path, query, header, formData, body)
  let scheme = call_565457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565457.url(scheme.get, call_565457.host, call_565457.base,
                         call_565457.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565457, url, valid)

proc call*(call_565458: Call_ReplicationProtectionContainersList_565450;
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
  var path_565459 = newJObject()
  var query_565460 = newJObject()
  add(query_565460, "api-version", newJString(apiVersion))
  add(path_565459, "subscriptionId", newJString(subscriptionId))
  add(path_565459, "resourceGroupName", newJString(resourceGroupName))
  add(path_565459, "resourceName", newJString(resourceName))
  result = call_565458.call(path_565459, query_565460, nil, nil, nil)

var replicationProtectionContainersList* = Call_ReplicationProtectionContainersList_565450(
    name: "replicationProtectionContainersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationProtectionContainers",
    validator: validate_ReplicationProtectionContainersList_565451, base: "",
    url: url_ReplicationProtectionContainersList_565452, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansList_565461 = ref object of OpenApiRestCall_563566
proc url_ReplicationRecoveryPlansList_565463(protocol: Scheme; host: string;
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

proc validate_ReplicationRecoveryPlansList_565462(path: JsonNode; query: JsonNode;
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
  var valid_565464 = path.getOrDefault("subscriptionId")
  valid_565464 = validateParameter(valid_565464, JString, required = true,
                                 default = nil)
  if valid_565464 != nil:
    section.add "subscriptionId", valid_565464
  var valid_565465 = path.getOrDefault("resourceGroupName")
  valid_565465 = validateParameter(valid_565465, JString, required = true,
                                 default = nil)
  if valid_565465 != nil:
    section.add "resourceGroupName", valid_565465
  var valid_565466 = path.getOrDefault("resourceName")
  valid_565466 = validateParameter(valid_565466, JString, required = true,
                                 default = nil)
  if valid_565466 != nil:
    section.add "resourceName", valid_565466
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565467 = query.getOrDefault("api-version")
  valid_565467 = validateParameter(valid_565467, JString, required = true,
                                 default = nil)
  if valid_565467 != nil:
    section.add "api-version", valid_565467
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565468: Call_ReplicationRecoveryPlansList_565461; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the recovery plans in the vault.
  ## 
  let valid = call_565468.validator(path, query, header, formData, body)
  let scheme = call_565468.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565468.url(scheme.get, call_565468.host, call_565468.base,
                         call_565468.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565468, url, valid)

proc call*(call_565469: Call_ReplicationRecoveryPlansList_565461;
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
  var path_565470 = newJObject()
  var query_565471 = newJObject()
  add(query_565471, "api-version", newJString(apiVersion))
  add(path_565470, "subscriptionId", newJString(subscriptionId))
  add(path_565470, "resourceGroupName", newJString(resourceGroupName))
  add(path_565470, "resourceName", newJString(resourceName))
  result = call_565469.call(path_565470, query_565471, nil, nil, nil)

var replicationRecoveryPlansList* = Call_ReplicationRecoveryPlansList_565461(
    name: "replicationRecoveryPlansList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans",
    validator: validate_ReplicationRecoveryPlansList_565462, base: "",
    url: url_ReplicationRecoveryPlansList_565463, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansCreate_565484 = ref object of OpenApiRestCall_563566
proc url_ReplicationRecoveryPlansCreate_565486(protocol: Scheme; host: string;
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

proc validate_ReplicationRecoveryPlansCreate_565485(path: JsonNode;
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
  var valid_565487 = path.getOrDefault("recoveryPlanName")
  valid_565487 = validateParameter(valid_565487, JString, required = true,
                                 default = nil)
  if valid_565487 != nil:
    section.add "recoveryPlanName", valid_565487
  var valid_565488 = path.getOrDefault("subscriptionId")
  valid_565488 = validateParameter(valid_565488, JString, required = true,
                                 default = nil)
  if valid_565488 != nil:
    section.add "subscriptionId", valid_565488
  var valid_565489 = path.getOrDefault("resourceGroupName")
  valid_565489 = validateParameter(valid_565489, JString, required = true,
                                 default = nil)
  if valid_565489 != nil:
    section.add "resourceGroupName", valid_565489
  var valid_565490 = path.getOrDefault("resourceName")
  valid_565490 = validateParameter(valid_565490, JString, required = true,
                                 default = nil)
  if valid_565490 != nil:
    section.add "resourceName", valid_565490
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565491 = query.getOrDefault("api-version")
  valid_565491 = validateParameter(valid_565491, JString, required = true,
                                 default = nil)
  if valid_565491 != nil:
    section.add "api-version", valid_565491
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

proc call*(call_565493: Call_ReplicationRecoveryPlansCreate_565484; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create a recovery plan.
  ## 
  let valid = call_565493.validator(path, query, header, formData, body)
  let scheme = call_565493.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565493.url(scheme.get, call_565493.host, call_565493.base,
                         call_565493.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565493, url, valid)

proc call*(call_565494: Call_ReplicationRecoveryPlansCreate_565484;
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
  var path_565495 = newJObject()
  var query_565496 = newJObject()
  var body_565497 = newJObject()
  add(path_565495, "recoveryPlanName", newJString(recoveryPlanName))
  add(query_565496, "api-version", newJString(apiVersion))
  if input != nil:
    body_565497 = input
  add(path_565495, "subscriptionId", newJString(subscriptionId))
  add(path_565495, "resourceGroupName", newJString(resourceGroupName))
  add(path_565495, "resourceName", newJString(resourceName))
  result = call_565494.call(path_565495, query_565496, nil, nil, body_565497)

var replicationRecoveryPlansCreate* = Call_ReplicationRecoveryPlansCreate_565484(
    name: "replicationRecoveryPlansCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}",
    validator: validate_ReplicationRecoveryPlansCreate_565485, base: "",
    url: url_ReplicationRecoveryPlansCreate_565486, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansGet_565472 = ref object of OpenApiRestCall_563566
proc url_ReplicationRecoveryPlansGet_565474(protocol: Scheme; host: string;
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

proc validate_ReplicationRecoveryPlansGet_565473(path: JsonNode; query: JsonNode;
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
  var valid_565475 = path.getOrDefault("recoveryPlanName")
  valid_565475 = validateParameter(valid_565475, JString, required = true,
                                 default = nil)
  if valid_565475 != nil:
    section.add "recoveryPlanName", valid_565475
  var valid_565476 = path.getOrDefault("subscriptionId")
  valid_565476 = validateParameter(valid_565476, JString, required = true,
                                 default = nil)
  if valid_565476 != nil:
    section.add "subscriptionId", valid_565476
  var valid_565477 = path.getOrDefault("resourceGroupName")
  valid_565477 = validateParameter(valid_565477, JString, required = true,
                                 default = nil)
  if valid_565477 != nil:
    section.add "resourceGroupName", valid_565477
  var valid_565478 = path.getOrDefault("resourceName")
  valid_565478 = validateParameter(valid_565478, JString, required = true,
                                 default = nil)
  if valid_565478 != nil:
    section.add "resourceName", valid_565478
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565479 = query.getOrDefault("api-version")
  valid_565479 = validateParameter(valid_565479, JString, required = true,
                                 default = nil)
  if valid_565479 != nil:
    section.add "api-version", valid_565479
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565480: Call_ReplicationRecoveryPlansGet_565472; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the recovery plan.
  ## 
  let valid = call_565480.validator(path, query, header, formData, body)
  let scheme = call_565480.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565480.url(scheme.get, call_565480.host, call_565480.base,
                         call_565480.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565480, url, valid)

proc call*(call_565481: Call_ReplicationRecoveryPlansGet_565472;
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
  var path_565482 = newJObject()
  var query_565483 = newJObject()
  add(path_565482, "recoveryPlanName", newJString(recoveryPlanName))
  add(query_565483, "api-version", newJString(apiVersion))
  add(path_565482, "subscriptionId", newJString(subscriptionId))
  add(path_565482, "resourceGroupName", newJString(resourceGroupName))
  add(path_565482, "resourceName", newJString(resourceName))
  result = call_565481.call(path_565482, query_565483, nil, nil, nil)

var replicationRecoveryPlansGet* = Call_ReplicationRecoveryPlansGet_565472(
    name: "replicationRecoveryPlansGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}",
    validator: validate_ReplicationRecoveryPlansGet_565473, base: "",
    url: url_ReplicationRecoveryPlansGet_565474, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansUpdate_565510 = ref object of OpenApiRestCall_563566
proc url_ReplicationRecoveryPlansUpdate_565512(protocol: Scheme; host: string;
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

proc validate_ReplicationRecoveryPlansUpdate_565511(path: JsonNode;
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
  var valid_565513 = path.getOrDefault("recoveryPlanName")
  valid_565513 = validateParameter(valid_565513, JString, required = true,
                                 default = nil)
  if valid_565513 != nil:
    section.add "recoveryPlanName", valid_565513
  var valid_565514 = path.getOrDefault("subscriptionId")
  valid_565514 = validateParameter(valid_565514, JString, required = true,
                                 default = nil)
  if valid_565514 != nil:
    section.add "subscriptionId", valid_565514
  var valid_565515 = path.getOrDefault("resourceGroupName")
  valid_565515 = validateParameter(valid_565515, JString, required = true,
                                 default = nil)
  if valid_565515 != nil:
    section.add "resourceGroupName", valid_565515
  var valid_565516 = path.getOrDefault("resourceName")
  valid_565516 = validateParameter(valid_565516, JString, required = true,
                                 default = nil)
  if valid_565516 != nil:
    section.add "resourceName", valid_565516
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565517 = query.getOrDefault("api-version")
  valid_565517 = validateParameter(valid_565517, JString, required = true,
                                 default = nil)
  if valid_565517 != nil:
    section.add "api-version", valid_565517
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

proc call*(call_565519: Call_ReplicationRecoveryPlansUpdate_565510; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a recovery plan.
  ## 
  let valid = call_565519.validator(path, query, header, formData, body)
  let scheme = call_565519.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565519.url(scheme.get, call_565519.host, call_565519.base,
                         call_565519.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565519, url, valid)

proc call*(call_565520: Call_ReplicationRecoveryPlansUpdate_565510;
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
  var path_565521 = newJObject()
  var query_565522 = newJObject()
  var body_565523 = newJObject()
  add(path_565521, "recoveryPlanName", newJString(recoveryPlanName))
  add(query_565522, "api-version", newJString(apiVersion))
  if input != nil:
    body_565523 = input
  add(path_565521, "subscriptionId", newJString(subscriptionId))
  add(path_565521, "resourceGroupName", newJString(resourceGroupName))
  add(path_565521, "resourceName", newJString(resourceName))
  result = call_565520.call(path_565521, query_565522, nil, nil, body_565523)

var replicationRecoveryPlansUpdate* = Call_ReplicationRecoveryPlansUpdate_565510(
    name: "replicationRecoveryPlansUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}",
    validator: validate_ReplicationRecoveryPlansUpdate_565511, base: "",
    url: url_ReplicationRecoveryPlansUpdate_565512, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansDelete_565498 = ref object of OpenApiRestCall_563566
proc url_ReplicationRecoveryPlansDelete_565500(protocol: Scheme; host: string;
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

proc validate_ReplicationRecoveryPlansDelete_565499(path: JsonNode;
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
  var valid_565501 = path.getOrDefault("recoveryPlanName")
  valid_565501 = validateParameter(valid_565501, JString, required = true,
                                 default = nil)
  if valid_565501 != nil:
    section.add "recoveryPlanName", valid_565501
  var valid_565502 = path.getOrDefault("subscriptionId")
  valid_565502 = validateParameter(valid_565502, JString, required = true,
                                 default = nil)
  if valid_565502 != nil:
    section.add "subscriptionId", valid_565502
  var valid_565503 = path.getOrDefault("resourceGroupName")
  valid_565503 = validateParameter(valid_565503, JString, required = true,
                                 default = nil)
  if valid_565503 != nil:
    section.add "resourceGroupName", valid_565503
  var valid_565504 = path.getOrDefault("resourceName")
  valid_565504 = validateParameter(valid_565504, JString, required = true,
                                 default = nil)
  if valid_565504 != nil:
    section.add "resourceName", valid_565504
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565505 = query.getOrDefault("api-version")
  valid_565505 = validateParameter(valid_565505, JString, required = true,
                                 default = nil)
  if valid_565505 != nil:
    section.add "api-version", valid_565505
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565506: Call_ReplicationRecoveryPlansDelete_565498; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a recovery plan.
  ## 
  let valid = call_565506.validator(path, query, header, formData, body)
  let scheme = call_565506.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565506.url(scheme.get, call_565506.host, call_565506.base,
                         call_565506.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565506, url, valid)

proc call*(call_565507: Call_ReplicationRecoveryPlansDelete_565498;
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
  var path_565508 = newJObject()
  var query_565509 = newJObject()
  add(path_565508, "recoveryPlanName", newJString(recoveryPlanName))
  add(query_565509, "api-version", newJString(apiVersion))
  add(path_565508, "subscriptionId", newJString(subscriptionId))
  add(path_565508, "resourceGroupName", newJString(resourceGroupName))
  add(path_565508, "resourceName", newJString(resourceName))
  result = call_565507.call(path_565508, query_565509, nil, nil, nil)

var replicationRecoveryPlansDelete* = Call_ReplicationRecoveryPlansDelete_565498(
    name: "replicationRecoveryPlansDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}",
    validator: validate_ReplicationRecoveryPlansDelete_565499, base: "",
    url: url_ReplicationRecoveryPlansDelete_565500, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansFailoverCommit_565524 = ref object of OpenApiRestCall_563566
proc url_ReplicationRecoveryPlansFailoverCommit_565526(protocol: Scheme;
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

proc validate_ReplicationRecoveryPlansFailoverCommit_565525(path: JsonNode;
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
  var valid_565527 = path.getOrDefault("recoveryPlanName")
  valid_565527 = validateParameter(valid_565527, JString, required = true,
                                 default = nil)
  if valid_565527 != nil:
    section.add "recoveryPlanName", valid_565527
  var valid_565528 = path.getOrDefault("subscriptionId")
  valid_565528 = validateParameter(valid_565528, JString, required = true,
                                 default = nil)
  if valid_565528 != nil:
    section.add "subscriptionId", valid_565528
  var valid_565529 = path.getOrDefault("resourceGroupName")
  valid_565529 = validateParameter(valid_565529, JString, required = true,
                                 default = nil)
  if valid_565529 != nil:
    section.add "resourceGroupName", valid_565529
  var valid_565530 = path.getOrDefault("resourceName")
  valid_565530 = validateParameter(valid_565530, JString, required = true,
                                 default = nil)
  if valid_565530 != nil:
    section.add "resourceName", valid_565530
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565531 = query.getOrDefault("api-version")
  valid_565531 = validateParameter(valid_565531, JString, required = true,
                                 default = nil)
  if valid_565531 != nil:
    section.add "api-version", valid_565531
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565532: Call_ReplicationRecoveryPlansFailoverCommit_565524;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to commit the fail over of a recovery plan.
  ## 
  let valid = call_565532.validator(path, query, header, formData, body)
  let scheme = call_565532.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565532.url(scheme.get, call_565532.host, call_565532.base,
                         call_565532.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565532, url, valid)

proc call*(call_565533: Call_ReplicationRecoveryPlansFailoverCommit_565524;
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
  var path_565534 = newJObject()
  var query_565535 = newJObject()
  add(path_565534, "recoveryPlanName", newJString(recoveryPlanName))
  add(query_565535, "api-version", newJString(apiVersion))
  add(path_565534, "subscriptionId", newJString(subscriptionId))
  add(path_565534, "resourceGroupName", newJString(resourceGroupName))
  add(path_565534, "resourceName", newJString(resourceName))
  result = call_565533.call(path_565534, query_565535, nil, nil, nil)

var replicationRecoveryPlansFailoverCommit* = Call_ReplicationRecoveryPlansFailoverCommit_565524(
    name: "replicationRecoveryPlansFailoverCommit", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/failoverCommit",
    validator: validate_ReplicationRecoveryPlansFailoverCommit_565525, base: "",
    url: url_ReplicationRecoveryPlansFailoverCommit_565526,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansPlannedFailover_565536 = ref object of OpenApiRestCall_563566
proc url_ReplicationRecoveryPlansPlannedFailover_565538(protocol: Scheme;
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

proc validate_ReplicationRecoveryPlansPlannedFailover_565537(path: JsonNode;
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
  var valid_565539 = path.getOrDefault("recoveryPlanName")
  valid_565539 = validateParameter(valid_565539, JString, required = true,
                                 default = nil)
  if valid_565539 != nil:
    section.add "recoveryPlanName", valid_565539
  var valid_565540 = path.getOrDefault("subscriptionId")
  valid_565540 = validateParameter(valid_565540, JString, required = true,
                                 default = nil)
  if valid_565540 != nil:
    section.add "subscriptionId", valid_565540
  var valid_565541 = path.getOrDefault("resourceGroupName")
  valid_565541 = validateParameter(valid_565541, JString, required = true,
                                 default = nil)
  if valid_565541 != nil:
    section.add "resourceGroupName", valid_565541
  var valid_565542 = path.getOrDefault("resourceName")
  valid_565542 = validateParameter(valid_565542, JString, required = true,
                                 default = nil)
  if valid_565542 != nil:
    section.add "resourceName", valid_565542
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565543 = query.getOrDefault("api-version")
  valid_565543 = validateParameter(valid_565543, JString, required = true,
                                 default = nil)
  if valid_565543 != nil:
    section.add "api-version", valid_565543
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

proc call*(call_565545: Call_ReplicationRecoveryPlansPlannedFailover_565536;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to start the planned failover of a recovery plan.
  ## 
  let valid = call_565545.validator(path, query, header, formData, body)
  let scheme = call_565545.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565545.url(scheme.get, call_565545.host, call_565545.base,
                         call_565545.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565545, url, valid)

proc call*(call_565546: Call_ReplicationRecoveryPlansPlannedFailover_565536;
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
  var path_565547 = newJObject()
  var query_565548 = newJObject()
  var body_565549 = newJObject()
  add(path_565547, "recoveryPlanName", newJString(recoveryPlanName))
  add(query_565548, "api-version", newJString(apiVersion))
  if input != nil:
    body_565549 = input
  add(path_565547, "subscriptionId", newJString(subscriptionId))
  add(path_565547, "resourceGroupName", newJString(resourceGroupName))
  add(path_565547, "resourceName", newJString(resourceName))
  result = call_565546.call(path_565547, query_565548, nil, nil, body_565549)

var replicationRecoveryPlansPlannedFailover* = Call_ReplicationRecoveryPlansPlannedFailover_565536(
    name: "replicationRecoveryPlansPlannedFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/plannedFailover",
    validator: validate_ReplicationRecoveryPlansPlannedFailover_565537, base: "",
    url: url_ReplicationRecoveryPlansPlannedFailover_565538,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansReprotect_565550 = ref object of OpenApiRestCall_563566
proc url_ReplicationRecoveryPlansReprotect_565552(protocol: Scheme; host: string;
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

proc validate_ReplicationRecoveryPlansReprotect_565551(path: JsonNode;
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
  var valid_565553 = path.getOrDefault("recoveryPlanName")
  valid_565553 = validateParameter(valid_565553, JString, required = true,
                                 default = nil)
  if valid_565553 != nil:
    section.add "recoveryPlanName", valid_565553
  var valid_565554 = path.getOrDefault("subscriptionId")
  valid_565554 = validateParameter(valid_565554, JString, required = true,
                                 default = nil)
  if valid_565554 != nil:
    section.add "subscriptionId", valid_565554
  var valid_565555 = path.getOrDefault("resourceGroupName")
  valid_565555 = validateParameter(valid_565555, JString, required = true,
                                 default = nil)
  if valid_565555 != nil:
    section.add "resourceGroupName", valid_565555
  var valid_565556 = path.getOrDefault("resourceName")
  valid_565556 = validateParameter(valid_565556, JString, required = true,
                                 default = nil)
  if valid_565556 != nil:
    section.add "resourceName", valid_565556
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565557 = query.getOrDefault("api-version")
  valid_565557 = validateParameter(valid_565557, JString, required = true,
                                 default = nil)
  if valid_565557 != nil:
    section.add "api-version", valid_565557
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565558: Call_ReplicationRecoveryPlansReprotect_565550;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to reprotect(reverse replicate) a recovery plan.
  ## 
  let valid = call_565558.validator(path, query, header, formData, body)
  let scheme = call_565558.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565558.url(scheme.get, call_565558.host, call_565558.base,
                         call_565558.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565558, url, valid)

proc call*(call_565559: Call_ReplicationRecoveryPlansReprotect_565550;
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
  var path_565560 = newJObject()
  var query_565561 = newJObject()
  add(path_565560, "recoveryPlanName", newJString(recoveryPlanName))
  add(query_565561, "api-version", newJString(apiVersion))
  add(path_565560, "subscriptionId", newJString(subscriptionId))
  add(path_565560, "resourceGroupName", newJString(resourceGroupName))
  add(path_565560, "resourceName", newJString(resourceName))
  result = call_565559.call(path_565560, query_565561, nil, nil, nil)

var replicationRecoveryPlansReprotect* = Call_ReplicationRecoveryPlansReprotect_565550(
    name: "replicationRecoveryPlansReprotect", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/reProtect",
    validator: validate_ReplicationRecoveryPlansReprotect_565551, base: "",
    url: url_ReplicationRecoveryPlansReprotect_565552, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansTestFailover_565562 = ref object of OpenApiRestCall_563566
proc url_ReplicationRecoveryPlansTestFailover_565564(protocol: Scheme;
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

proc validate_ReplicationRecoveryPlansTestFailover_565563(path: JsonNode;
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
  var valid_565565 = path.getOrDefault("recoveryPlanName")
  valid_565565 = validateParameter(valid_565565, JString, required = true,
                                 default = nil)
  if valid_565565 != nil:
    section.add "recoveryPlanName", valid_565565
  var valid_565566 = path.getOrDefault("subscriptionId")
  valid_565566 = validateParameter(valid_565566, JString, required = true,
                                 default = nil)
  if valid_565566 != nil:
    section.add "subscriptionId", valid_565566
  var valid_565567 = path.getOrDefault("resourceGroupName")
  valid_565567 = validateParameter(valid_565567, JString, required = true,
                                 default = nil)
  if valid_565567 != nil:
    section.add "resourceGroupName", valid_565567
  var valid_565568 = path.getOrDefault("resourceName")
  valid_565568 = validateParameter(valid_565568, JString, required = true,
                                 default = nil)
  if valid_565568 != nil:
    section.add "resourceName", valid_565568
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565569 = query.getOrDefault("api-version")
  valid_565569 = validateParameter(valid_565569, JString, required = true,
                                 default = nil)
  if valid_565569 != nil:
    section.add "api-version", valid_565569
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

proc call*(call_565571: Call_ReplicationRecoveryPlansTestFailover_565562;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to start the test failover of a recovery plan.
  ## 
  let valid = call_565571.validator(path, query, header, formData, body)
  let scheme = call_565571.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565571.url(scheme.get, call_565571.host, call_565571.base,
                         call_565571.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565571, url, valid)

proc call*(call_565572: Call_ReplicationRecoveryPlansTestFailover_565562;
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
  var path_565573 = newJObject()
  var query_565574 = newJObject()
  var body_565575 = newJObject()
  add(path_565573, "recoveryPlanName", newJString(recoveryPlanName))
  add(query_565574, "api-version", newJString(apiVersion))
  if input != nil:
    body_565575 = input
  add(path_565573, "subscriptionId", newJString(subscriptionId))
  add(path_565573, "resourceGroupName", newJString(resourceGroupName))
  add(path_565573, "resourceName", newJString(resourceName))
  result = call_565572.call(path_565573, query_565574, nil, nil, body_565575)

var replicationRecoveryPlansTestFailover* = Call_ReplicationRecoveryPlansTestFailover_565562(
    name: "replicationRecoveryPlansTestFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/testFailover",
    validator: validate_ReplicationRecoveryPlansTestFailover_565563, base: "",
    url: url_ReplicationRecoveryPlansTestFailover_565564, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansTestFailoverCleanup_565576 = ref object of OpenApiRestCall_563566
proc url_ReplicationRecoveryPlansTestFailoverCleanup_565578(protocol: Scheme;
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

proc validate_ReplicationRecoveryPlansTestFailoverCleanup_565577(path: JsonNode;
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
  var valid_565579 = path.getOrDefault("recoveryPlanName")
  valid_565579 = validateParameter(valid_565579, JString, required = true,
                                 default = nil)
  if valid_565579 != nil:
    section.add "recoveryPlanName", valid_565579
  var valid_565580 = path.getOrDefault("subscriptionId")
  valid_565580 = validateParameter(valid_565580, JString, required = true,
                                 default = nil)
  if valid_565580 != nil:
    section.add "subscriptionId", valid_565580
  var valid_565581 = path.getOrDefault("resourceGroupName")
  valid_565581 = validateParameter(valid_565581, JString, required = true,
                                 default = nil)
  if valid_565581 != nil:
    section.add "resourceGroupName", valid_565581
  var valid_565582 = path.getOrDefault("resourceName")
  valid_565582 = validateParameter(valid_565582, JString, required = true,
                                 default = nil)
  if valid_565582 != nil:
    section.add "resourceName", valid_565582
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565583 = query.getOrDefault("api-version")
  valid_565583 = validateParameter(valid_565583, JString, required = true,
                                 default = nil)
  if valid_565583 != nil:
    section.add "api-version", valid_565583
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

proc call*(call_565585: Call_ReplicationRecoveryPlansTestFailoverCleanup_565576;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to cleanup test failover of a recovery plan.
  ## 
  let valid = call_565585.validator(path, query, header, formData, body)
  let scheme = call_565585.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565585.url(scheme.get, call_565585.host, call_565585.base,
                         call_565585.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565585, url, valid)

proc call*(call_565586: Call_ReplicationRecoveryPlansTestFailoverCleanup_565576;
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
  var path_565587 = newJObject()
  var query_565588 = newJObject()
  var body_565589 = newJObject()
  add(path_565587, "recoveryPlanName", newJString(recoveryPlanName))
  add(query_565588, "api-version", newJString(apiVersion))
  if input != nil:
    body_565589 = input
  add(path_565587, "subscriptionId", newJString(subscriptionId))
  add(path_565587, "resourceGroupName", newJString(resourceGroupName))
  add(path_565587, "resourceName", newJString(resourceName))
  result = call_565586.call(path_565587, query_565588, nil, nil, body_565589)

var replicationRecoveryPlansTestFailoverCleanup* = Call_ReplicationRecoveryPlansTestFailoverCleanup_565576(
    name: "replicationRecoveryPlansTestFailoverCleanup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/testFailoverCleanup",
    validator: validate_ReplicationRecoveryPlansTestFailoverCleanup_565577,
    base: "", url: url_ReplicationRecoveryPlansTestFailoverCleanup_565578,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansUnplannedFailover_565590 = ref object of OpenApiRestCall_563566
proc url_ReplicationRecoveryPlansUnplannedFailover_565592(protocol: Scheme;
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

proc validate_ReplicationRecoveryPlansUnplannedFailover_565591(path: JsonNode;
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
  var valid_565593 = path.getOrDefault("recoveryPlanName")
  valid_565593 = validateParameter(valid_565593, JString, required = true,
                                 default = nil)
  if valid_565593 != nil:
    section.add "recoveryPlanName", valid_565593
  var valid_565594 = path.getOrDefault("subscriptionId")
  valid_565594 = validateParameter(valid_565594, JString, required = true,
                                 default = nil)
  if valid_565594 != nil:
    section.add "subscriptionId", valid_565594
  var valid_565595 = path.getOrDefault("resourceGroupName")
  valid_565595 = validateParameter(valid_565595, JString, required = true,
                                 default = nil)
  if valid_565595 != nil:
    section.add "resourceGroupName", valid_565595
  var valid_565596 = path.getOrDefault("resourceName")
  valid_565596 = validateParameter(valid_565596, JString, required = true,
                                 default = nil)
  if valid_565596 != nil:
    section.add "resourceName", valid_565596
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565597 = query.getOrDefault("api-version")
  valid_565597 = validateParameter(valid_565597, JString, required = true,
                                 default = nil)
  if valid_565597 != nil:
    section.add "api-version", valid_565597
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

proc call*(call_565599: Call_ReplicationRecoveryPlansUnplannedFailover_565590;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to start the failover of a recovery plan.
  ## 
  let valid = call_565599.validator(path, query, header, formData, body)
  let scheme = call_565599.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565599.url(scheme.get, call_565599.host, call_565599.base,
                         call_565599.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565599, url, valid)

proc call*(call_565600: Call_ReplicationRecoveryPlansUnplannedFailover_565590;
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
  var path_565601 = newJObject()
  var query_565602 = newJObject()
  var body_565603 = newJObject()
  add(path_565601, "recoveryPlanName", newJString(recoveryPlanName))
  add(query_565602, "api-version", newJString(apiVersion))
  if input != nil:
    body_565603 = input
  add(path_565601, "subscriptionId", newJString(subscriptionId))
  add(path_565601, "resourceGroupName", newJString(resourceGroupName))
  add(path_565601, "resourceName", newJString(resourceName))
  result = call_565600.call(path_565601, query_565602, nil, nil, body_565603)

var replicationRecoveryPlansUnplannedFailover* = Call_ReplicationRecoveryPlansUnplannedFailover_565590(
    name: "replicationRecoveryPlansUnplannedFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/unplannedFailover",
    validator: validate_ReplicationRecoveryPlansUnplannedFailover_565591,
    base: "", url: url_ReplicationRecoveryPlansUnplannedFailover_565592,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersList_565604 = ref object of OpenApiRestCall_563566
proc url_ReplicationRecoveryServicesProvidersList_565606(protocol: Scheme;
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

proc validate_ReplicationRecoveryServicesProvidersList_565605(path: JsonNode;
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
  var valid_565607 = path.getOrDefault("subscriptionId")
  valid_565607 = validateParameter(valid_565607, JString, required = true,
                                 default = nil)
  if valid_565607 != nil:
    section.add "subscriptionId", valid_565607
  var valid_565608 = path.getOrDefault("resourceGroupName")
  valid_565608 = validateParameter(valid_565608, JString, required = true,
                                 default = nil)
  if valid_565608 != nil:
    section.add "resourceGroupName", valid_565608
  var valid_565609 = path.getOrDefault("resourceName")
  valid_565609 = validateParameter(valid_565609, JString, required = true,
                                 default = nil)
  if valid_565609 != nil:
    section.add "resourceName", valid_565609
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565610 = query.getOrDefault("api-version")
  valid_565610 = validateParameter(valid_565610, JString, required = true,
                                 default = nil)
  if valid_565610 != nil:
    section.add "api-version", valid_565610
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565611: Call_ReplicationRecoveryServicesProvidersList_565604;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the registered recovery services providers in the vault
  ## 
  let valid = call_565611.validator(path, query, header, formData, body)
  let scheme = call_565611.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565611.url(scheme.get, call_565611.host, call_565611.base,
                         call_565611.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565611, url, valid)

proc call*(call_565612: Call_ReplicationRecoveryServicesProvidersList_565604;
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
  var path_565613 = newJObject()
  var query_565614 = newJObject()
  add(query_565614, "api-version", newJString(apiVersion))
  add(path_565613, "subscriptionId", newJString(subscriptionId))
  add(path_565613, "resourceGroupName", newJString(resourceGroupName))
  add(path_565613, "resourceName", newJString(resourceName))
  result = call_565612.call(path_565613, query_565614, nil, nil, nil)

var replicationRecoveryServicesProvidersList* = Call_ReplicationRecoveryServicesProvidersList_565604(
    name: "replicationRecoveryServicesProvidersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryServicesProviders",
    validator: validate_ReplicationRecoveryServicesProvidersList_565605, base: "",
    url: url_ReplicationRecoveryServicesProvidersList_565606,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsList_565615 = ref object of OpenApiRestCall_563566
proc url_ReplicationStorageClassificationMappingsList_565617(protocol: Scheme;
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

proc validate_ReplicationStorageClassificationMappingsList_565616(path: JsonNode;
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
  var valid_565618 = path.getOrDefault("subscriptionId")
  valid_565618 = validateParameter(valid_565618, JString, required = true,
                                 default = nil)
  if valid_565618 != nil:
    section.add "subscriptionId", valid_565618
  var valid_565619 = path.getOrDefault("resourceGroupName")
  valid_565619 = validateParameter(valid_565619, JString, required = true,
                                 default = nil)
  if valid_565619 != nil:
    section.add "resourceGroupName", valid_565619
  var valid_565620 = path.getOrDefault("resourceName")
  valid_565620 = validateParameter(valid_565620, JString, required = true,
                                 default = nil)
  if valid_565620 != nil:
    section.add "resourceName", valid_565620
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565621 = query.getOrDefault("api-version")
  valid_565621 = validateParameter(valid_565621, JString, required = true,
                                 default = nil)
  if valid_565621 != nil:
    section.add "api-version", valid_565621
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565622: Call_ReplicationStorageClassificationMappingsList_565615;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the storage classification mappings in the vault.
  ## 
  let valid = call_565622.validator(path, query, header, formData, body)
  let scheme = call_565622.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565622.url(scheme.get, call_565622.host, call_565622.base,
                         call_565622.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565622, url, valid)

proc call*(call_565623: Call_ReplicationStorageClassificationMappingsList_565615;
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
  var path_565624 = newJObject()
  var query_565625 = newJObject()
  add(query_565625, "api-version", newJString(apiVersion))
  add(path_565624, "subscriptionId", newJString(subscriptionId))
  add(path_565624, "resourceGroupName", newJString(resourceGroupName))
  add(path_565624, "resourceName", newJString(resourceName))
  result = call_565623.call(path_565624, query_565625, nil, nil, nil)

var replicationStorageClassificationMappingsList* = Call_ReplicationStorageClassificationMappingsList_565615(
    name: "replicationStorageClassificationMappingsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationStorageClassificationMappings",
    validator: validate_ReplicationStorageClassificationMappingsList_565616,
    base: "", url: url_ReplicationStorageClassificationMappingsList_565617,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationsList_565626 = ref object of OpenApiRestCall_563566
proc url_ReplicationStorageClassificationsList_565628(protocol: Scheme;
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

proc validate_ReplicationStorageClassificationsList_565627(path: JsonNode;
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
  var valid_565629 = path.getOrDefault("subscriptionId")
  valid_565629 = validateParameter(valid_565629, JString, required = true,
                                 default = nil)
  if valid_565629 != nil:
    section.add "subscriptionId", valid_565629
  var valid_565630 = path.getOrDefault("resourceGroupName")
  valid_565630 = validateParameter(valid_565630, JString, required = true,
                                 default = nil)
  if valid_565630 != nil:
    section.add "resourceGroupName", valid_565630
  var valid_565631 = path.getOrDefault("resourceName")
  valid_565631 = validateParameter(valid_565631, JString, required = true,
                                 default = nil)
  if valid_565631 != nil:
    section.add "resourceName", valid_565631
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565632 = query.getOrDefault("api-version")
  valid_565632 = validateParameter(valid_565632, JString, required = true,
                                 default = nil)
  if valid_565632 != nil:
    section.add "api-version", valid_565632
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565633: Call_ReplicationStorageClassificationsList_565626;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the storage classifications in the vault.
  ## 
  let valid = call_565633.validator(path, query, header, formData, body)
  let scheme = call_565633.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565633.url(scheme.get, call_565633.host, call_565633.base,
                         call_565633.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565633, url, valid)

proc call*(call_565634: Call_ReplicationStorageClassificationsList_565626;
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
  var path_565635 = newJObject()
  var query_565636 = newJObject()
  add(query_565636, "api-version", newJString(apiVersion))
  add(path_565635, "subscriptionId", newJString(subscriptionId))
  add(path_565635, "resourceGroupName", newJString(resourceGroupName))
  add(path_565635, "resourceName", newJString(resourceName))
  result = call_565634.call(path_565635, query_565636, nil, nil, nil)

var replicationStorageClassificationsList* = Call_ReplicationStorageClassificationsList_565626(
    name: "replicationStorageClassificationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationStorageClassifications",
    validator: validate_ReplicationStorageClassificationsList_565627, base: "",
    url: url_ReplicationStorageClassificationsList_565628, schemes: {Scheme.Https})
type
  Call_ReplicationVaultHealthGet_565637 = ref object of OpenApiRestCall_563566
proc url_ReplicationVaultHealthGet_565639(protocol: Scheme; host: string;
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

proc validate_ReplicationVaultHealthGet_565638(path: JsonNode; query: JsonNode;
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
  var valid_565640 = path.getOrDefault("subscriptionId")
  valid_565640 = validateParameter(valid_565640, JString, required = true,
                                 default = nil)
  if valid_565640 != nil:
    section.add "subscriptionId", valid_565640
  var valid_565641 = path.getOrDefault("resourceGroupName")
  valid_565641 = validateParameter(valid_565641, JString, required = true,
                                 default = nil)
  if valid_565641 != nil:
    section.add "resourceGroupName", valid_565641
  var valid_565642 = path.getOrDefault("resourceName")
  valid_565642 = validateParameter(valid_565642, JString, required = true,
                                 default = nil)
  if valid_565642 != nil:
    section.add "resourceName", valid_565642
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565643 = query.getOrDefault("api-version")
  valid_565643 = validateParameter(valid_565643, JString, required = true,
                                 default = nil)
  if valid_565643 != nil:
    section.add "api-version", valid_565643
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565644: Call_ReplicationVaultHealthGet_565637; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health details of the vault.
  ## 
  let valid = call_565644.validator(path, query, header, formData, body)
  let scheme = call_565644.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565644.url(scheme.get, call_565644.host, call_565644.base,
                         call_565644.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565644, url, valid)

proc call*(call_565645: Call_ReplicationVaultHealthGet_565637; apiVersion: string;
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
  var path_565646 = newJObject()
  var query_565647 = newJObject()
  add(query_565647, "api-version", newJString(apiVersion))
  add(path_565646, "subscriptionId", newJString(subscriptionId))
  add(path_565646, "resourceGroupName", newJString(resourceGroupName))
  add(path_565646, "resourceName", newJString(resourceName))
  result = call_565645.call(path_565646, query_565647, nil, nil, nil)

var replicationVaultHealthGet* = Call_ReplicationVaultHealthGet_565637(
    name: "replicationVaultHealthGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationVaultHealth",
    validator: validate_ReplicationVaultHealthGet_565638, base: "",
    url: url_ReplicationVaultHealthGet_565639, schemes: {Scheme.Https})
type
  Call_ReplicationVaultHealthRefresh_565648 = ref object of OpenApiRestCall_563566
proc url_ReplicationVaultHealthRefresh_565650(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/replicationVaultHealth/default/refresh")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationVaultHealthRefresh_565649(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_565651 = path.getOrDefault("subscriptionId")
  valid_565651 = validateParameter(valid_565651, JString, required = true,
                                 default = nil)
  if valid_565651 != nil:
    section.add "subscriptionId", valid_565651
  var valid_565652 = path.getOrDefault("resourceGroupName")
  valid_565652 = validateParameter(valid_565652, JString, required = true,
                                 default = nil)
  if valid_565652 != nil:
    section.add "resourceGroupName", valid_565652
  var valid_565653 = path.getOrDefault("resourceName")
  valid_565653 = validateParameter(valid_565653, JString, required = true,
                                 default = nil)
  if valid_565653 != nil:
    section.add "resourceName", valid_565653
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565654 = query.getOrDefault("api-version")
  valid_565654 = validateParameter(valid_565654, JString, required = true,
                                 default = nil)
  if valid_565654 != nil:
    section.add "api-version", valid_565654
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565655: Call_ReplicationVaultHealthRefresh_565648; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565655.validator(path, query, header, formData, body)
  let scheme = call_565655.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565655.url(scheme.get, call_565655.host, call_565655.base,
                         call_565655.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565655, url, valid)

proc call*(call_565656: Call_ReplicationVaultHealthRefresh_565648;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## replicationVaultHealthRefresh
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565657 = newJObject()
  var query_565658 = newJObject()
  add(query_565658, "api-version", newJString(apiVersion))
  add(path_565657, "subscriptionId", newJString(subscriptionId))
  add(path_565657, "resourceGroupName", newJString(resourceGroupName))
  add(path_565657, "resourceName", newJString(resourceName))
  result = call_565656.call(path_565657, query_565658, nil, nil, nil)

var replicationVaultHealthRefresh* = Call_ReplicationVaultHealthRefresh_565648(
    name: "replicationVaultHealthRefresh", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationVaultHealth/default/refresh",
    validator: validate_ReplicationVaultHealthRefresh_565649, base: "",
    url: url_ReplicationVaultHealthRefresh_565650, schemes: {Scheme.Https})
type
  Call_ReplicationvCentersList_565659 = ref object of OpenApiRestCall_563566
proc url_ReplicationvCentersList_565661(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationvCentersList_565660(path: JsonNode; query: JsonNode;
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
  var valid_565662 = path.getOrDefault("subscriptionId")
  valid_565662 = validateParameter(valid_565662, JString, required = true,
                                 default = nil)
  if valid_565662 != nil:
    section.add "subscriptionId", valid_565662
  var valid_565663 = path.getOrDefault("resourceGroupName")
  valid_565663 = validateParameter(valid_565663, JString, required = true,
                                 default = nil)
  if valid_565663 != nil:
    section.add "resourceGroupName", valid_565663
  var valid_565664 = path.getOrDefault("resourceName")
  valid_565664 = validateParameter(valid_565664, JString, required = true,
                                 default = nil)
  if valid_565664 != nil:
    section.add "resourceName", valid_565664
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565665 = query.getOrDefault("api-version")
  valid_565665 = validateParameter(valid_565665, JString, required = true,
                                 default = nil)
  if valid_565665 != nil:
    section.add "api-version", valid_565665
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565666: Call_ReplicationvCentersList_565659; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the vCenter servers registered in the vault.
  ## 
  let valid = call_565666.validator(path, query, header, formData, body)
  let scheme = call_565666.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565666.url(scheme.get, call_565666.host, call_565666.base,
                         call_565666.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565666, url, valid)

proc call*(call_565667: Call_ReplicationvCentersList_565659; apiVersion: string;
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
  var path_565668 = newJObject()
  var query_565669 = newJObject()
  add(query_565669, "api-version", newJString(apiVersion))
  add(path_565668, "subscriptionId", newJString(subscriptionId))
  add(path_565668, "resourceGroupName", newJString(resourceGroupName))
  add(path_565668, "resourceName", newJString(resourceName))
  result = call_565667.call(path_565668, query_565669, nil, nil, nil)

var replicationvCentersList* = Call_ReplicationvCentersList_565659(
    name: "replicationvCentersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationvCenters",
    validator: validate_ReplicationvCentersList_565660, base: "",
    url: url_ReplicationvCentersList_565661, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
