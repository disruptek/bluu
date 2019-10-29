
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: SiteRecoveryManagementClient
## version: 2018-07-10
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
  Call_ReplicationProtectedItemsResolveHealthErrors_564721 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectedItemsResolveHealthErrors_564723(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/ResolveHealthErrors")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsResolveHealthErrors_564722(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Operation to resolve health issues of the replication protected item.
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
  ##   resolveHealthInput: JObject (required)
  ##                     : Health issue input object.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564732: Call_ReplicationProtectedItemsResolveHealthErrors_564721;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to resolve health issues of the replication protected item.
  ## 
  let valid = call_564732.validator(path, query, header, formData, body)
  let scheme = call_564732.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564732.url(scheme.get, call_564732.host, call_564732.base,
                         call_564732.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564732, url, valid)

proc call*(call_564733: Call_ReplicationProtectedItemsResolveHealthErrors_564721;
          protectionContainerName: string; resolveHealthInput: JsonNode;
          apiVersion: string; replicatedProtectedItemName: string;
          fabricName: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## replicationProtectedItemsResolveHealthErrors
  ## Operation to resolve health issues of the replication protected item.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   resolveHealthInput: JObject (required)
  ##                     : Health issue input object.
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
  var path_564734 = newJObject()
  var query_564735 = newJObject()
  var body_564736 = newJObject()
  add(path_564734, "protectionContainerName", newJString(protectionContainerName))
  if resolveHealthInput != nil:
    body_564736 = resolveHealthInput
  add(query_564735, "api-version", newJString(apiVersion))
  add(path_564734, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564734, "fabricName", newJString(fabricName))
  add(path_564734, "subscriptionId", newJString(subscriptionId))
  add(path_564734, "resourceGroupName", newJString(resourceGroupName))
  add(path_564734, "resourceName", newJString(resourceName))
  result = call_564733.call(path_564734, query_564735, nil, nil, body_564736)

var replicationProtectedItemsResolveHealthErrors* = Call_ReplicationProtectedItemsResolveHealthErrors_564721(
    name: "replicationProtectedItemsResolveHealthErrors",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/ResolveHealthErrors",
    validator: validate_ReplicationProtectedItemsResolveHealthErrors_564722,
    base: "", url: url_ReplicationProtectedItemsResolveHealthErrors_564723,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsAddDisks_564737 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectedItemsAddDisks_564739(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/addDisks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsAddDisks_564738(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Operation to add disks(s) to the replication protected item.
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
  ## parameters in `body` object:
  ##   addDisksInput: JObject (required)
  ##                : Add disks input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564748: Call_ReplicationProtectedItemsAddDisks_564737;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to add disks(s) to the replication protected item.
  ## 
  let valid = call_564748.validator(path, query, header, formData, body)
  let scheme = call_564748.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564748.url(scheme.get, call_564748.host, call_564748.base,
                         call_564748.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564748, url, valid)

proc call*(call_564749: Call_ReplicationProtectedItemsAddDisks_564737;
          protectionContainerName: string; apiVersion: string;
          addDisksInput: JsonNode; replicatedProtectedItemName: string;
          fabricName: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## replicationProtectedItemsAddDisks
  ## Operation to add disks(s) to the replication protected item.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   addDisksInput: JObject (required)
  ##                : Add disks input.
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
  var path_564750 = newJObject()
  var query_564751 = newJObject()
  var body_564752 = newJObject()
  add(path_564750, "protectionContainerName", newJString(protectionContainerName))
  add(query_564751, "api-version", newJString(apiVersion))
  if addDisksInput != nil:
    body_564752 = addDisksInput
  add(path_564750, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564750, "fabricName", newJString(fabricName))
  add(path_564750, "subscriptionId", newJString(subscriptionId))
  add(path_564750, "resourceGroupName", newJString(resourceGroupName))
  add(path_564750, "resourceName", newJString(resourceName))
  result = call_564749.call(path_564750, query_564751, nil, nil, body_564752)

var replicationProtectedItemsAddDisks* = Call_ReplicationProtectedItemsAddDisks_564737(
    name: "replicationProtectedItemsAddDisks", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/addDisks",
    validator: validate_ReplicationProtectedItemsAddDisks_564738, base: "",
    url: url_ReplicationProtectedItemsAddDisks_564739, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsApplyRecoveryPoint_564753 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectedItemsApplyRecoveryPoint_564755(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsApplyRecoveryPoint_564754(path: JsonNode;
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
  var valid_564756 = path.getOrDefault("protectionContainerName")
  valid_564756 = validateParameter(valid_564756, JString, required = true,
                                 default = nil)
  if valid_564756 != nil:
    section.add "protectionContainerName", valid_564756
  var valid_564757 = path.getOrDefault("replicatedProtectedItemName")
  valid_564757 = validateParameter(valid_564757, JString, required = true,
                                 default = nil)
  if valid_564757 != nil:
    section.add "replicatedProtectedItemName", valid_564757
  var valid_564758 = path.getOrDefault("fabricName")
  valid_564758 = validateParameter(valid_564758, JString, required = true,
                                 default = nil)
  if valid_564758 != nil:
    section.add "fabricName", valid_564758
  var valid_564759 = path.getOrDefault("subscriptionId")
  valid_564759 = validateParameter(valid_564759, JString, required = true,
                                 default = nil)
  if valid_564759 != nil:
    section.add "subscriptionId", valid_564759
  var valid_564760 = path.getOrDefault("resourceGroupName")
  valid_564760 = validateParameter(valid_564760, JString, required = true,
                                 default = nil)
  if valid_564760 != nil:
    section.add "resourceGroupName", valid_564760
  var valid_564761 = path.getOrDefault("resourceName")
  valid_564761 = validateParameter(valid_564761, JString, required = true,
                                 default = nil)
  if valid_564761 != nil:
    section.add "resourceName", valid_564761
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564762 = query.getOrDefault("api-version")
  valid_564762 = validateParameter(valid_564762, JString, required = true,
                                 default = nil)
  if valid_564762 != nil:
    section.add "api-version", valid_564762
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

proc call*(call_564764: Call_ReplicationProtectedItemsApplyRecoveryPoint_564753;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to change the recovery point of a failed over replication protected item.
  ## 
  let valid = call_564764.validator(path, query, header, formData, body)
  let scheme = call_564764.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564764.url(scheme.get, call_564764.host, call_564764.base,
                         call_564764.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564764, url, valid)

proc call*(call_564765: Call_ReplicationProtectedItemsApplyRecoveryPoint_564753;
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
  var path_564766 = newJObject()
  var query_564767 = newJObject()
  var body_564768 = newJObject()
  add(path_564766, "protectionContainerName", newJString(protectionContainerName))
  add(query_564767, "api-version", newJString(apiVersion))
  add(path_564766, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564766, "fabricName", newJString(fabricName))
  add(path_564766, "subscriptionId", newJString(subscriptionId))
  if applyRecoveryPointInput != nil:
    body_564768 = applyRecoveryPointInput
  add(path_564766, "resourceGroupName", newJString(resourceGroupName))
  add(path_564766, "resourceName", newJString(resourceName))
  result = call_564765.call(path_564766, query_564767, nil, nil, body_564768)

var replicationProtectedItemsApplyRecoveryPoint* = Call_ReplicationProtectedItemsApplyRecoveryPoint_564753(
    name: "replicationProtectedItemsApplyRecoveryPoint",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/applyRecoveryPoint",
    validator: validate_ReplicationProtectedItemsApplyRecoveryPoint_564754,
    base: "", url: url_ReplicationProtectedItemsApplyRecoveryPoint_564755,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsFailoverCommit_564769 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectedItemsFailoverCommit_564771(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsFailoverCommit_564770(path: JsonNode;
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
  var valid_564772 = path.getOrDefault("protectionContainerName")
  valid_564772 = validateParameter(valid_564772, JString, required = true,
                                 default = nil)
  if valid_564772 != nil:
    section.add "protectionContainerName", valid_564772
  var valid_564773 = path.getOrDefault("replicatedProtectedItemName")
  valid_564773 = validateParameter(valid_564773, JString, required = true,
                                 default = nil)
  if valid_564773 != nil:
    section.add "replicatedProtectedItemName", valid_564773
  var valid_564774 = path.getOrDefault("fabricName")
  valid_564774 = validateParameter(valid_564774, JString, required = true,
                                 default = nil)
  if valid_564774 != nil:
    section.add "fabricName", valid_564774
  var valid_564775 = path.getOrDefault("subscriptionId")
  valid_564775 = validateParameter(valid_564775, JString, required = true,
                                 default = nil)
  if valid_564775 != nil:
    section.add "subscriptionId", valid_564775
  var valid_564776 = path.getOrDefault("resourceGroupName")
  valid_564776 = validateParameter(valid_564776, JString, required = true,
                                 default = nil)
  if valid_564776 != nil:
    section.add "resourceGroupName", valid_564776
  var valid_564777 = path.getOrDefault("resourceName")
  valid_564777 = validateParameter(valid_564777, JString, required = true,
                                 default = nil)
  if valid_564777 != nil:
    section.add "resourceName", valid_564777
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564778 = query.getOrDefault("api-version")
  valid_564778 = validateParameter(valid_564778, JString, required = true,
                                 default = nil)
  if valid_564778 != nil:
    section.add "api-version", valid_564778
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564779: Call_ReplicationProtectedItemsFailoverCommit_564769;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to commit the failover of the replication protected item.
  ## 
  let valid = call_564779.validator(path, query, header, formData, body)
  let scheme = call_564779.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564779.url(scheme.get, call_564779.host, call_564779.base,
                         call_564779.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564779, url, valid)

proc call*(call_564780: Call_ReplicationProtectedItemsFailoverCommit_564769;
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
  var path_564781 = newJObject()
  var query_564782 = newJObject()
  add(path_564781, "protectionContainerName", newJString(protectionContainerName))
  add(query_564782, "api-version", newJString(apiVersion))
  add(path_564781, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564781, "fabricName", newJString(fabricName))
  add(path_564781, "subscriptionId", newJString(subscriptionId))
  add(path_564781, "resourceGroupName", newJString(resourceGroupName))
  add(path_564781, "resourceName", newJString(resourceName))
  result = call_564780.call(path_564781, query_564782, nil, nil, nil)

var replicationProtectedItemsFailoverCommit* = Call_ReplicationProtectedItemsFailoverCommit_564769(
    name: "replicationProtectedItemsFailoverCommit", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/failoverCommit",
    validator: validate_ReplicationProtectedItemsFailoverCommit_564770, base: "",
    url: url_ReplicationProtectedItemsFailoverCommit_564771,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsPlannedFailover_564783 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectedItemsPlannedFailover_564785(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsPlannedFailover_564784(path: JsonNode;
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
  ## parameters in `body` object:
  ##   failoverInput: JObject (required)
  ##                : Disable protection input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564794: Call_ReplicationProtectedItemsPlannedFailover_564783;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to initiate a planned failover of the replication protected item.
  ## 
  let valid = call_564794.validator(path, query, header, formData, body)
  let scheme = call_564794.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564794.url(scheme.get, call_564794.host, call_564794.base,
                         call_564794.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564794, url, valid)

proc call*(call_564795: Call_ReplicationProtectedItemsPlannedFailover_564783;
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
  var path_564796 = newJObject()
  var query_564797 = newJObject()
  var body_564798 = newJObject()
  add(path_564796, "protectionContainerName", newJString(protectionContainerName))
  add(query_564797, "api-version", newJString(apiVersion))
  add(path_564796, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564796, "fabricName", newJString(fabricName))
  add(path_564796, "subscriptionId", newJString(subscriptionId))
  add(path_564796, "resourceGroupName", newJString(resourceGroupName))
  if failoverInput != nil:
    body_564798 = failoverInput
  add(path_564796, "resourceName", newJString(resourceName))
  result = call_564795.call(path_564796, query_564797, nil, nil, body_564798)

var replicationProtectedItemsPlannedFailover* = Call_ReplicationProtectedItemsPlannedFailover_564783(
    name: "replicationProtectedItemsPlannedFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/plannedFailover",
    validator: validate_ReplicationProtectedItemsPlannedFailover_564784, base: "",
    url: url_ReplicationProtectedItemsPlannedFailover_564785,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsReprotect_564799 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectedItemsReprotect_564801(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectedItemsReprotect_564800(path: JsonNode;
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
  var valid_564802 = path.getOrDefault("protectionContainerName")
  valid_564802 = validateParameter(valid_564802, JString, required = true,
                                 default = nil)
  if valid_564802 != nil:
    section.add "protectionContainerName", valid_564802
  var valid_564803 = path.getOrDefault("replicatedProtectedItemName")
  valid_564803 = validateParameter(valid_564803, JString, required = true,
                                 default = nil)
  if valid_564803 != nil:
    section.add "replicatedProtectedItemName", valid_564803
  var valid_564804 = path.getOrDefault("fabricName")
  valid_564804 = validateParameter(valid_564804, JString, required = true,
                                 default = nil)
  if valid_564804 != nil:
    section.add "fabricName", valid_564804
  var valid_564805 = path.getOrDefault("subscriptionId")
  valid_564805 = validateParameter(valid_564805, JString, required = true,
                                 default = nil)
  if valid_564805 != nil:
    section.add "subscriptionId", valid_564805
  var valid_564806 = path.getOrDefault("resourceGroupName")
  valid_564806 = validateParameter(valid_564806, JString, required = true,
                                 default = nil)
  if valid_564806 != nil:
    section.add "resourceGroupName", valid_564806
  var valid_564807 = path.getOrDefault("resourceName")
  valid_564807 = validateParameter(valid_564807, JString, required = true,
                                 default = nil)
  if valid_564807 != nil:
    section.add "resourceName", valid_564807
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564808 = query.getOrDefault("api-version")
  valid_564808 = validateParameter(valid_564808, JString, required = true,
                                 default = nil)
  if valid_564808 != nil:
    section.add "api-version", valid_564808
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

proc call*(call_564810: Call_ReplicationProtectedItemsReprotect_564799;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to reprotect or reverse replicate a failed over replication protected item.
  ## 
  let valid = call_564810.validator(path, query, header, formData, body)
  let scheme = call_564810.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564810.url(scheme.get, call_564810.host, call_564810.base,
                         call_564810.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564810, url, valid)

proc call*(call_564811: Call_ReplicationProtectedItemsReprotect_564799;
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
  var path_564812 = newJObject()
  var query_564813 = newJObject()
  var body_564814 = newJObject()
  add(path_564812, "protectionContainerName", newJString(protectionContainerName))
  add(query_564813, "api-version", newJString(apiVersion))
  add(path_564812, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  if rrInput != nil:
    body_564814 = rrInput
  add(path_564812, "fabricName", newJString(fabricName))
  add(path_564812, "subscriptionId", newJString(subscriptionId))
  add(path_564812, "resourceGroupName", newJString(resourceGroupName))
  add(path_564812, "resourceName", newJString(resourceName))
  result = call_564811.call(path_564812, query_564813, nil, nil, body_564814)

var replicationProtectedItemsReprotect* = Call_ReplicationProtectedItemsReprotect_564799(
    name: "replicationProtectedItemsReprotect", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/reProtect",
    validator: validate_ReplicationProtectedItemsReprotect_564800, base: "",
    url: url_ReplicationProtectedItemsReprotect_564801, schemes: {Scheme.Https})
type
  Call_RecoveryPointsListByReplicationProtectedItems_564815 = ref object of OpenApiRestCall_563566
proc url_RecoveryPointsListByReplicationProtectedItems_564817(protocol: Scheme;
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

proc validate_RecoveryPointsListByReplicationProtectedItems_564816(
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
  var valid_564818 = path.getOrDefault("protectionContainerName")
  valid_564818 = validateParameter(valid_564818, JString, required = true,
                                 default = nil)
  if valid_564818 != nil:
    section.add "protectionContainerName", valid_564818
  var valid_564819 = path.getOrDefault("replicatedProtectedItemName")
  valid_564819 = validateParameter(valid_564819, JString, required = true,
                                 default = nil)
  if valid_564819 != nil:
    section.add "replicatedProtectedItemName", valid_564819
  var valid_564820 = path.getOrDefault("fabricName")
  valid_564820 = validateParameter(valid_564820, JString, required = true,
                                 default = nil)
  if valid_564820 != nil:
    section.add "fabricName", valid_564820
  var valid_564821 = path.getOrDefault("subscriptionId")
  valid_564821 = validateParameter(valid_564821, JString, required = true,
                                 default = nil)
  if valid_564821 != nil:
    section.add "subscriptionId", valid_564821
  var valid_564822 = path.getOrDefault("resourceGroupName")
  valid_564822 = validateParameter(valid_564822, JString, required = true,
                                 default = nil)
  if valid_564822 != nil:
    section.add "resourceGroupName", valid_564822
  var valid_564823 = path.getOrDefault("resourceName")
  valid_564823 = validateParameter(valid_564823, JString, required = true,
                                 default = nil)
  if valid_564823 != nil:
    section.add "resourceName", valid_564823
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564824 = query.getOrDefault("api-version")
  valid_564824 = validateParameter(valid_564824, JString, required = true,
                                 default = nil)
  if valid_564824 != nil:
    section.add "api-version", valid_564824
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564825: Call_RecoveryPointsListByReplicationProtectedItems_564815;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the available recovery points for a replication protected item.
  ## 
  let valid = call_564825.validator(path, query, header, formData, body)
  let scheme = call_564825.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564825.url(scheme.get, call_564825.host, call_564825.base,
                         call_564825.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564825, url, valid)

proc call*(call_564826: Call_RecoveryPointsListByReplicationProtectedItems_564815;
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
  var path_564827 = newJObject()
  var query_564828 = newJObject()
  add(path_564827, "protectionContainerName", newJString(protectionContainerName))
  add(query_564828, "api-version", newJString(apiVersion))
  add(path_564827, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564827, "fabricName", newJString(fabricName))
  add(path_564827, "subscriptionId", newJString(subscriptionId))
  add(path_564827, "resourceGroupName", newJString(resourceGroupName))
  add(path_564827, "resourceName", newJString(resourceName))
  result = call_564826.call(path_564827, query_564828, nil, nil, nil)

var recoveryPointsListByReplicationProtectedItems* = Call_RecoveryPointsListByReplicationProtectedItems_564815(
    name: "recoveryPointsListByReplicationProtectedItems",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/recoveryPoints",
    validator: validate_RecoveryPointsListByReplicationProtectedItems_564816,
    base: "", url: url_RecoveryPointsListByReplicationProtectedItems_564817,
    schemes: {Scheme.Https})
type
  Call_RecoveryPointsGet_564829 = ref object of OpenApiRestCall_563566
proc url_RecoveryPointsGet_564831(protocol: Scheme; host: string; base: string;
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

proc validate_RecoveryPointsGet_564830(path: JsonNode; query: JsonNode;
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
  var valid_564832 = path.getOrDefault("protectionContainerName")
  valid_564832 = validateParameter(valid_564832, JString, required = true,
                                 default = nil)
  if valid_564832 != nil:
    section.add "protectionContainerName", valid_564832
  var valid_564833 = path.getOrDefault("replicatedProtectedItemName")
  valid_564833 = validateParameter(valid_564833, JString, required = true,
                                 default = nil)
  if valid_564833 != nil:
    section.add "replicatedProtectedItemName", valid_564833
  var valid_564834 = path.getOrDefault("recoveryPointName")
  valid_564834 = validateParameter(valid_564834, JString, required = true,
                                 default = nil)
  if valid_564834 != nil:
    section.add "recoveryPointName", valid_564834
  var valid_564835 = path.getOrDefault("fabricName")
  valid_564835 = validateParameter(valid_564835, JString, required = true,
                                 default = nil)
  if valid_564835 != nil:
    section.add "fabricName", valid_564835
  var valid_564836 = path.getOrDefault("subscriptionId")
  valid_564836 = validateParameter(valid_564836, JString, required = true,
                                 default = nil)
  if valid_564836 != nil:
    section.add "subscriptionId", valid_564836
  var valid_564837 = path.getOrDefault("resourceGroupName")
  valid_564837 = validateParameter(valid_564837, JString, required = true,
                                 default = nil)
  if valid_564837 != nil:
    section.add "resourceGroupName", valid_564837
  var valid_564838 = path.getOrDefault("resourceName")
  valid_564838 = validateParameter(valid_564838, JString, required = true,
                                 default = nil)
  if valid_564838 != nil:
    section.add "resourceName", valid_564838
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564839 = query.getOrDefault("api-version")
  valid_564839 = validateParameter(valid_564839, JString, required = true,
                                 default = nil)
  if valid_564839 != nil:
    section.add "api-version", valid_564839
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564840: Call_RecoveryPointsGet_564829; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the details of specified recovery point.
  ## 
  let valid = call_564840.validator(path, query, header, formData, body)
  let scheme = call_564840.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564840.url(scheme.get, call_564840.host, call_564840.base,
                         call_564840.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564840, url, valid)

proc call*(call_564841: Call_RecoveryPointsGet_564829;
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
  var path_564842 = newJObject()
  var query_564843 = newJObject()
  add(path_564842, "protectionContainerName", newJString(protectionContainerName))
  add(query_564843, "api-version", newJString(apiVersion))
  add(path_564842, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564842, "recoveryPointName", newJString(recoveryPointName))
  add(path_564842, "fabricName", newJString(fabricName))
  add(path_564842, "subscriptionId", newJString(subscriptionId))
  add(path_564842, "resourceGroupName", newJString(resourceGroupName))
  add(path_564842, "resourceName", newJString(resourceName))
  result = call_564841.call(path_564842, query_564843, nil, nil, nil)

var recoveryPointsGet* = Call_RecoveryPointsGet_564829(name: "recoveryPointsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/recoveryPoints/{recoveryPointName}",
    validator: validate_RecoveryPointsGet_564830, base: "",
    url: url_RecoveryPointsGet_564831, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsDelete_564844 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectedItemsDelete_564846(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectedItemsDelete_564845(path: JsonNode;
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
  var valid_564847 = path.getOrDefault("protectionContainerName")
  valid_564847 = validateParameter(valid_564847, JString, required = true,
                                 default = nil)
  if valid_564847 != nil:
    section.add "protectionContainerName", valid_564847
  var valid_564848 = path.getOrDefault("replicatedProtectedItemName")
  valid_564848 = validateParameter(valid_564848, JString, required = true,
                                 default = nil)
  if valid_564848 != nil:
    section.add "replicatedProtectedItemName", valid_564848
  var valid_564849 = path.getOrDefault("fabricName")
  valid_564849 = validateParameter(valid_564849, JString, required = true,
                                 default = nil)
  if valid_564849 != nil:
    section.add "fabricName", valid_564849
  var valid_564850 = path.getOrDefault("subscriptionId")
  valid_564850 = validateParameter(valid_564850, JString, required = true,
                                 default = nil)
  if valid_564850 != nil:
    section.add "subscriptionId", valid_564850
  var valid_564851 = path.getOrDefault("resourceGroupName")
  valid_564851 = validateParameter(valid_564851, JString, required = true,
                                 default = nil)
  if valid_564851 != nil:
    section.add "resourceGroupName", valid_564851
  var valid_564852 = path.getOrDefault("resourceName")
  valid_564852 = validateParameter(valid_564852, JString, required = true,
                                 default = nil)
  if valid_564852 != nil:
    section.add "resourceName", valid_564852
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564853 = query.getOrDefault("api-version")
  valid_564853 = validateParameter(valid_564853, JString, required = true,
                                 default = nil)
  if valid_564853 != nil:
    section.add "api-version", valid_564853
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

proc call*(call_564855: Call_ReplicationProtectedItemsDelete_564844;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to disable replication on a replication protected item. This will also remove the item.
  ## 
  let valid = call_564855.validator(path, query, header, formData, body)
  let scheme = call_564855.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564855.url(scheme.get, call_564855.host, call_564855.base,
                         call_564855.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564855, url, valid)

proc call*(call_564856: Call_ReplicationProtectedItemsDelete_564844;
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
  var path_564857 = newJObject()
  var query_564858 = newJObject()
  var body_564859 = newJObject()
  add(path_564857, "protectionContainerName", newJString(protectionContainerName))
  add(query_564858, "api-version", newJString(apiVersion))
  add(path_564857, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564857, "fabricName", newJString(fabricName))
  if disableProtectionInput != nil:
    body_564859 = disableProtectionInput
  add(path_564857, "subscriptionId", newJString(subscriptionId))
  add(path_564857, "resourceGroupName", newJString(resourceGroupName))
  add(path_564857, "resourceName", newJString(resourceName))
  result = call_564856.call(path_564857, query_564858, nil, nil, body_564859)

var replicationProtectedItemsDelete* = Call_ReplicationProtectedItemsDelete_564844(
    name: "replicationProtectedItemsDelete", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/remove",
    validator: validate_ReplicationProtectedItemsDelete_564845, base: "",
    url: url_ReplicationProtectedItemsDelete_564846, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsRemoveDisks_564860 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectedItemsRemoveDisks_564862(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/removeDisks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationProtectedItemsRemoveDisks_564861(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Operation to remove disk(s) from the replication protected item.
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
  var valid_564863 = path.getOrDefault("protectionContainerName")
  valid_564863 = validateParameter(valid_564863, JString, required = true,
                                 default = nil)
  if valid_564863 != nil:
    section.add "protectionContainerName", valid_564863
  var valid_564864 = path.getOrDefault("replicatedProtectedItemName")
  valid_564864 = validateParameter(valid_564864, JString, required = true,
                                 default = nil)
  if valid_564864 != nil:
    section.add "replicatedProtectedItemName", valid_564864
  var valid_564865 = path.getOrDefault("fabricName")
  valid_564865 = validateParameter(valid_564865, JString, required = true,
                                 default = nil)
  if valid_564865 != nil:
    section.add "fabricName", valid_564865
  var valid_564866 = path.getOrDefault("subscriptionId")
  valid_564866 = validateParameter(valid_564866, JString, required = true,
                                 default = nil)
  if valid_564866 != nil:
    section.add "subscriptionId", valid_564866
  var valid_564867 = path.getOrDefault("resourceGroupName")
  valid_564867 = validateParameter(valid_564867, JString, required = true,
                                 default = nil)
  if valid_564867 != nil:
    section.add "resourceGroupName", valid_564867
  var valid_564868 = path.getOrDefault("resourceName")
  valid_564868 = validateParameter(valid_564868, JString, required = true,
                                 default = nil)
  if valid_564868 != nil:
    section.add "resourceName", valid_564868
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564869 = query.getOrDefault("api-version")
  valid_564869 = validateParameter(valid_564869, JString, required = true,
                                 default = nil)
  if valid_564869 != nil:
    section.add "api-version", valid_564869
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   removeDisksInput: JObject (required)
  ##                   : Remove disks input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564871: Call_ReplicationProtectedItemsRemoveDisks_564860;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to remove disk(s) from the replication protected item.
  ## 
  let valid = call_564871.validator(path, query, header, formData, body)
  let scheme = call_564871.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564871.url(scheme.get, call_564871.host, call_564871.base,
                         call_564871.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564871, url, valid)

proc call*(call_564872: Call_ReplicationProtectedItemsRemoveDisks_564860;
          protectionContainerName: string; apiVersion: string;
          replicatedProtectedItemName: string; fabricName: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string;
          removeDisksInput: JsonNode): Recallable =
  ## replicationProtectedItemsRemoveDisks
  ## Operation to remove disk(s) from the replication protected item.
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
  ##   removeDisksInput: JObject (required)
  ##                   : Remove disks input.
  var path_564873 = newJObject()
  var query_564874 = newJObject()
  var body_564875 = newJObject()
  add(path_564873, "protectionContainerName", newJString(protectionContainerName))
  add(query_564874, "api-version", newJString(apiVersion))
  add(path_564873, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564873, "fabricName", newJString(fabricName))
  add(path_564873, "subscriptionId", newJString(subscriptionId))
  add(path_564873, "resourceGroupName", newJString(resourceGroupName))
  add(path_564873, "resourceName", newJString(resourceName))
  if removeDisksInput != nil:
    body_564875 = removeDisksInput
  result = call_564872.call(path_564873, query_564874, nil, nil, body_564875)

var replicationProtectedItemsRemoveDisks* = Call_ReplicationProtectedItemsRemoveDisks_564860(
    name: "replicationProtectedItemsRemoveDisks", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/removeDisks",
    validator: validate_ReplicationProtectedItemsRemoveDisks_564861, base: "",
    url: url_ReplicationProtectedItemsRemoveDisks_564862, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsRepairReplication_564876 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectedItemsRepairReplication_564878(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsRepairReplication_564877(path: JsonNode;
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
  var valid_564879 = path.getOrDefault("protectionContainerName")
  valid_564879 = validateParameter(valid_564879, JString, required = true,
                                 default = nil)
  if valid_564879 != nil:
    section.add "protectionContainerName", valid_564879
  var valid_564880 = path.getOrDefault("replicatedProtectedItemName")
  valid_564880 = validateParameter(valid_564880, JString, required = true,
                                 default = nil)
  if valid_564880 != nil:
    section.add "replicatedProtectedItemName", valid_564880
  var valid_564881 = path.getOrDefault("fabricName")
  valid_564881 = validateParameter(valid_564881, JString, required = true,
                                 default = nil)
  if valid_564881 != nil:
    section.add "fabricName", valid_564881
  var valid_564882 = path.getOrDefault("subscriptionId")
  valid_564882 = validateParameter(valid_564882, JString, required = true,
                                 default = nil)
  if valid_564882 != nil:
    section.add "subscriptionId", valid_564882
  var valid_564883 = path.getOrDefault("resourceGroupName")
  valid_564883 = validateParameter(valid_564883, JString, required = true,
                                 default = nil)
  if valid_564883 != nil:
    section.add "resourceGroupName", valid_564883
  var valid_564884 = path.getOrDefault("resourceName")
  valid_564884 = validateParameter(valid_564884, JString, required = true,
                                 default = nil)
  if valid_564884 != nil:
    section.add "resourceName", valid_564884
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564885 = query.getOrDefault("api-version")
  valid_564885 = validateParameter(valid_564885, JString, required = true,
                                 default = nil)
  if valid_564885 != nil:
    section.add "api-version", valid_564885
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564886: Call_ReplicationProtectedItemsRepairReplication_564876;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to start resynchronize/repair replication for a replication protected item requiring resynchronization.
  ## 
  let valid = call_564886.validator(path, query, header, formData, body)
  let scheme = call_564886.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564886.url(scheme.get, call_564886.host, call_564886.base,
                         call_564886.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564886, url, valid)

proc call*(call_564887: Call_ReplicationProtectedItemsRepairReplication_564876;
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
  var path_564888 = newJObject()
  var query_564889 = newJObject()
  add(path_564888, "protectionContainerName", newJString(protectionContainerName))
  add(query_564889, "api-version", newJString(apiVersion))
  add(path_564888, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564888, "fabricName", newJString(fabricName))
  add(path_564888, "subscriptionId", newJString(subscriptionId))
  add(path_564888, "resourceGroupName", newJString(resourceGroupName))
  add(path_564888, "resourceName", newJString(resourceName))
  result = call_564887.call(path_564888, query_564889, nil, nil, nil)

var replicationProtectedItemsRepairReplication* = Call_ReplicationProtectedItemsRepairReplication_564876(
    name: "replicationProtectedItemsRepairReplication", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/repairReplication",
    validator: validate_ReplicationProtectedItemsRepairReplication_564877,
    base: "", url: url_ReplicationProtectedItemsRepairReplication_564878,
    schemes: {Scheme.Https})
type
  Call_TargetComputeSizesListByReplicationProtectedItems_564890 = ref object of OpenApiRestCall_563566
proc url_TargetComputeSizesListByReplicationProtectedItems_564892(
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

proc validate_TargetComputeSizesListByReplicationProtectedItems_564891(
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
  var valid_564893 = path.getOrDefault("protectionContainerName")
  valid_564893 = validateParameter(valid_564893, JString, required = true,
                                 default = nil)
  if valid_564893 != nil:
    section.add "protectionContainerName", valid_564893
  var valid_564894 = path.getOrDefault("replicatedProtectedItemName")
  valid_564894 = validateParameter(valid_564894, JString, required = true,
                                 default = nil)
  if valid_564894 != nil:
    section.add "replicatedProtectedItemName", valid_564894
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

proc call*(call_564900: Call_TargetComputeSizesListByReplicationProtectedItems_564890;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the available target compute sizes for a replication protected item.
  ## 
  let valid = call_564900.validator(path, query, header, formData, body)
  let scheme = call_564900.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564900.url(scheme.get, call_564900.host, call_564900.base,
                         call_564900.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564900, url, valid)

proc call*(call_564901: Call_TargetComputeSizesListByReplicationProtectedItems_564890;
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
  var path_564902 = newJObject()
  var query_564903 = newJObject()
  add(path_564902, "protectionContainerName", newJString(protectionContainerName))
  add(query_564903, "api-version", newJString(apiVersion))
  add(path_564902, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564902, "fabricName", newJString(fabricName))
  add(path_564902, "subscriptionId", newJString(subscriptionId))
  add(path_564902, "resourceGroupName", newJString(resourceGroupName))
  add(path_564902, "resourceName", newJString(resourceName))
  result = call_564901.call(path_564902, query_564903, nil, nil, nil)

var targetComputeSizesListByReplicationProtectedItems* = Call_TargetComputeSizesListByReplicationProtectedItems_564890(
    name: "targetComputeSizesListByReplicationProtectedItems",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/targetComputeSizes",
    validator: validate_TargetComputeSizesListByReplicationProtectedItems_564891,
    base: "", url: url_TargetComputeSizesListByReplicationProtectedItems_564892,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsTestFailover_564904 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectedItemsTestFailover_564906(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsTestFailover_564905(path: JsonNode;
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
  var valid_564907 = path.getOrDefault("protectionContainerName")
  valid_564907 = validateParameter(valid_564907, JString, required = true,
                                 default = nil)
  if valid_564907 != nil:
    section.add "protectionContainerName", valid_564907
  var valid_564908 = path.getOrDefault("replicatedProtectedItemName")
  valid_564908 = validateParameter(valid_564908, JString, required = true,
                                 default = nil)
  if valid_564908 != nil:
    section.add "replicatedProtectedItemName", valid_564908
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
  ##   failoverInput: JObject (required)
  ##                : Test failover input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564915: Call_ReplicationProtectedItemsTestFailover_564904;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to perform a test failover of the replication protected item.
  ## 
  let valid = call_564915.validator(path, query, header, formData, body)
  let scheme = call_564915.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564915.url(scheme.get, call_564915.host, call_564915.base,
                         call_564915.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564915, url, valid)

proc call*(call_564916: Call_ReplicationProtectedItemsTestFailover_564904;
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
  var path_564917 = newJObject()
  var query_564918 = newJObject()
  var body_564919 = newJObject()
  add(path_564917, "protectionContainerName", newJString(protectionContainerName))
  add(query_564918, "api-version", newJString(apiVersion))
  add(path_564917, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564917, "fabricName", newJString(fabricName))
  add(path_564917, "subscriptionId", newJString(subscriptionId))
  add(path_564917, "resourceGroupName", newJString(resourceGroupName))
  if failoverInput != nil:
    body_564919 = failoverInput
  add(path_564917, "resourceName", newJString(resourceName))
  result = call_564916.call(path_564917, query_564918, nil, nil, body_564919)

var replicationProtectedItemsTestFailover* = Call_ReplicationProtectedItemsTestFailover_564904(
    name: "replicationProtectedItemsTestFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/testFailover",
    validator: validate_ReplicationProtectedItemsTestFailover_564905, base: "",
    url: url_ReplicationProtectedItemsTestFailover_564906, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsTestFailoverCleanup_564920 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectedItemsTestFailoverCleanup_564922(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsTestFailoverCleanup_564921(path: JsonNode;
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
  var valid_564923 = path.getOrDefault("protectionContainerName")
  valid_564923 = validateParameter(valid_564923, JString, required = true,
                                 default = nil)
  if valid_564923 != nil:
    section.add "protectionContainerName", valid_564923
  var valid_564924 = path.getOrDefault("replicatedProtectedItemName")
  valid_564924 = validateParameter(valid_564924, JString, required = true,
                                 default = nil)
  if valid_564924 != nil:
    section.add "replicatedProtectedItemName", valid_564924
  var valid_564925 = path.getOrDefault("fabricName")
  valid_564925 = validateParameter(valid_564925, JString, required = true,
                                 default = nil)
  if valid_564925 != nil:
    section.add "fabricName", valid_564925
  var valid_564926 = path.getOrDefault("subscriptionId")
  valid_564926 = validateParameter(valid_564926, JString, required = true,
                                 default = nil)
  if valid_564926 != nil:
    section.add "subscriptionId", valid_564926
  var valid_564927 = path.getOrDefault("resourceGroupName")
  valid_564927 = validateParameter(valid_564927, JString, required = true,
                                 default = nil)
  if valid_564927 != nil:
    section.add "resourceGroupName", valid_564927
  var valid_564928 = path.getOrDefault("resourceName")
  valid_564928 = validateParameter(valid_564928, JString, required = true,
                                 default = nil)
  if valid_564928 != nil:
    section.add "resourceName", valid_564928
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564929 = query.getOrDefault("api-version")
  valid_564929 = validateParameter(valid_564929, JString, required = true,
                                 default = nil)
  if valid_564929 != nil:
    section.add "api-version", valid_564929
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

proc call*(call_564931: Call_ReplicationProtectedItemsTestFailoverCleanup_564920;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to clean up the test failover of a replication protected item.
  ## 
  let valid = call_564931.validator(path, query, header, formData, body)
  let scheme = call_564931.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564931.url(scheme.get, call_564931.host, call_564931.base,
                         call_564931.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564931, url, valid)

proc call*(call_564932: Call_ReplicationProtectedItemsTestFailoverCleanup_564920;
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
  var path_564933 = newJObject()
  var query_564934 = newJObject()
  var body_564935 = newJObject()
  add(path_564933, "protectionContainerName", newJString(protectionContainerName))
  add(query_564934, "api-version", newJString(apiVersion))
  add(path_564933, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564933, "fabricName", newJString(fabricName))
  add(path_564933, "subscriptionId", newJString(subscriptionId))
  if cleanupInput != nil:
    body_564935 = cleanupInput
  add(path_564933, "resourceGroupName", newJString(resourceGroupName))
  add(path_564933, "resourceName", newJString(resourceName))
  result = call_564932.call(path_564933, query_564934, nil, nil, body_564935)

var replicationProtectedItemsTestFailoverCleanup* = Call_ReplicationProtectedItemsTestFailoverCleanup_564920(
    name: "replicationProtectedItemsTestFailoverCleanup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/testFailoverCleanup",
    validator: validate_ReplicationProtectedItemsTestFailoverCleanup_564921,
    base: "", url: url_ReplicationProtectedItemsTestFailoverCleanup_564922,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsUnplannedFailover_564936 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectedItemsUnplannedFailover_564938(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsUnplannedFailover_564937(path: JsonNode;
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
  var valid_564939 = path.getOrDefault("protectionContainerName")
  valid_564939 = validateParameter(valid_564939, JString, required = true,
                                 default = nil)
  if valid_564939 != nil:
    section.add "protectionContainerName", valid_564939
  var valid_564940 = path.getOrDefault("replicatedProtectedItemName")
  valid_564940 = validateParameter(valid_564940, JString, required = true,
                                 default = nil)
  if valid_564940 != nil:
    section.add "replicatedProtectedItemName", valid_564940
  var valid_564941 = path.getOrDefault("fabricName")
  valid_564941 = validateParameter(valid_564941, JString, required = true,
                                 default = nil)
  if valid_564941 != nil:
    section.add "fabricName", valid_564941
  var valid_564942 = path.getOrDefault("subscriptionId")
  valid_564942 = validateParameter(valid_564942, JString, required = true,
                                 default = nil)
  if valid_564942 != nil:
    section.add "subscriptionId", valid_564942
  var valid_564943 = path.getOrDefault("resourceGroupName")
  valid_564943 = validateParameter(valid_564943, JString, required = true,
                                 default = nil)
  if valid_564943 != nil:
    section.add "resourceGroupName", valid_564943
  var valid_564944 = path.getOrDefault("resourceName")
  valid_564944 = validateParameter(valid_564944, JString, required = true,
                                 default = nil)
  if valid_564944 != nil:
    section.add "resourceName", valid_564944
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564945 = query.getOrDefault("api-version")
  valid_564945 = validateParameter(valid_564945, JString, required = true,
                                 default = nil)
  if valid_564945 != nil:
    section.add "api-version", valid_564945
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

proc call*(call_564947: Call_ReplicationProtectedItemsUnplannedFailover_564936;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to initiate a failover of the replication protected item.
  ## 
  let valid = call_564947.validator(path, query, header, formData, body)
  let scheme = call_564947.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564947.url(scheme.get, call_564947.host, call_564947.base,
                         call_564947.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564947, url, valid)

proc call*(call_564948: Call_ReplicationProtectedItemsUnplannedFailover_564936;
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
  var path_564949 = newJObject()
  var query_564950 = newJObject()
  var body_564951 = newJObject()
  add(path_564949, "protectionContainerName", newJString(protectionContainerName))
  add(query_564950, "api-version", newJString(apiVersion))
  add(path_564949, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  add(path_564949, "fabricName", newJString(fabricName))
  add(path_564949, "subscriptionId", newJString(subscriptionId))
  add(path_564949, "resourceGroupName", newJString(resourceGroupName))
  if failoverInput != nil:
    body_564951 = failoverInput
  add(path_564949, "resourceName", newJString(resourceName))
  result = call_564948.call(path_564949, query_564950, nil, nil, body_564951)

var replicationProtectedItemsUnplannedFailover* = Call_ReplicationProtectedItemsUnplannedFailover_564936(
    name: "replicationProtectedItemsUnplannedFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/unplannedFailover",
    validator: validate_ReplicationProtectedItemsUnplannedFailover_564937,
    base: "", url: url_ReplicationProtectedItemsUnplannedFailover_564938,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsUpdateMobilityService_564952 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectedItemsUpdateMobilityService_564954(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsUpdateMobilityService_564953(
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
  var valid_564955 = path.getOrDefault("protectionContainerName")
  valid_564955 = validateParameter(valid_564955, JString, required = true,
                                 default = nil)
  if valid_564955 != nil:
    section.add "protectionContainerName", valid_564955
  var valid_564956 = path.getOrDefault("replicationProtectedItemName")
  valid_564956 = validateParameter(valid_564956, JString, required = true,
                                 default = nil)
  if valid_564956 != nil:
    section.add "replicationProtectedItemName", valid_564956
  var valid_564957 = path.getOrDefault("fabricName")
  valid_564957 = validateParameter(valid_564957, JString, required = true,
                                 default = nil)
  if valid_564957 != nil:
    section.add "fabricName", valid_564957
  var valid_564958 = path.getOrDefault("subscriptionId")
  valid_564958 = validateParameter(valid_564958, JString, required = true,
                                 default = nil)
  if valid_564958 != nil:
    section.add "subscriptionId", valid_564958
  var valid_564959 = path.getOrDefault("resourceGroupName")
  valid_564959 = validateParameter(valid_564959, JString, required = true,
                                 default = nil)
  if valid_564959 != nil:
    section.add "resourceGroupName", valid_564959
  var valid_564960 = path.getOrDefault("resourceName")
  valid_564960 = validateParameter(valid_564960, JString, required = true,
                                 default = nil)
  if valid_564960 != nil:
    section.add "resourceName", valid_564960
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564961 = query.getOrDefault("api-version")
  valid_564961 = validateParameter(valid_564961, JString, required = true,
                                 default = nil)
  if valid_564961 != nil:
    section.add "api-version", valid_564961
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

proc call*(call_564963: Call_ReplicationProtectedItemsUpdateMobilityService_564952;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to update(push update) the installed mobility service software on a replication protected item to the latest available version.
  ## 
  let valid = call_564963.validator(path, query, header, formData, body)
  let scheme = call_564963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564963.url(scheme.get, call_564963.host, call_564963.base,
                         call_564963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564963, url, valid)

proc call*(call_564964: Call_ReplicationProtectedItemsUpdateMobilityService_564952;
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
  var path_564965 = newJObject()
  var query_564966 = newJObject()
  var body_564967 = newJObject()
  add(path_564965, "protectionContainerName", newJString(protectionContainerName))
  add(query_564966, "api-version", newJString(apiVersion))
  add(path_564965, "replicationProtectedItemName",
      newJString(replicationProtectedItemName))
  add(path_564965, "fabricName", newJString(fabricName))
  add(path_564965, "subscriptionId", newJString(subscriptionId))
  add(path_564965, "resourceGroupName", newJString(resourceGroupName))
  if updateMobilityServiceRequest != nil:
    body_564967 = updateMobilityServiceRequest
  add(path_564965, "resourceName", newJString(resourceName))
  result = call_564964.call(path_564965, query_564966, nil, nil, body_564967)

var replicationProtectedItemsUpdateMobilityService* = Call_ReplicationProtectedItemsUpdateMobilityService_564952(
    name: "replicationProtectedItemsUpdateMobilityService",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicationProtectedItemName}/updateMobilityService",
    validator: validate_ReplicationProtectedItemsUpdateMobilityService_564953,
    base: "", url: url_ReplicationProtectedItemsUpdateMobilityService_564954,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_564968 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_564970(
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

proc validate_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_564969(
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
  var valid_564971 = path.getOrDefault("protectionContainerName")
  valid_564971 = validateParameter(valid_564971, JString, required = true,
                                 default = nil)
  if valid_564971 != nil:
    section.add "protectionContainerName", valid_564971
  var valid_564972 = path.getOrDefault("fabricName")
  valid_564972 = validateParameter(valid_564972, JString, required = true,
                                 default = nil)
  if valid_564972 != nil:
    section.add "fabricName", valid_564972
  var valid_564973 = path.getOrDefault("subscriptionId")
  valid_564973 = validateParameter(valid_564973, JString, required = true,
                                 default = nil)
  if valid_564973 != nil:
    section.add "subscriptionId", valid_564973
  var valid_564974 = path.getOrDefault("resourceGroupName")
  valid_564974 = validateParameter(valid_564974, JString, required = true,
                                 default = nil)
  if valid_564974 != nil:
    section.add "resourceGroupName", valid_564974
  var valid_564975 = path.getOrDefault("resourceName")
  valid_564975 = validateParameter(valid_564975, JString, required = true,
                                 default = nil)
  if valid_564975 != nil:
    section.add "resourceName", valid_564975
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564976 = query.getOrDefault("api-version")
  valid_564976 = validateParameter(valid_564976, JString, required = true,
                                 default = nil)
  if valid_564976 != nil:
    section.add "api-version", valid_564976
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564977: Call_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_564968;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the protection container mappings for a protection container.
  ## 
  let valid = call_564977.validator(path, query, header, formData, body)
  let scheme = call_564977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564977.url(scheme.get, call_564977.host, call_564977.base,
                         call_564977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564977, url, valid)

proc call*(call_564978: Call_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_564968;
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
  var path_564979 = newJObject()
  var query_564980 = newJObject()
  add(path_564979, "protectionContainerName", newJString(protectionContainerName))
  add(query_564980, "api-version", newJString(apiVersion))
  add(path_564979, "fabricName", newJString(fabricName))
  add(path_564979, "subscriptionId", newJString(subscriptionId))
  add(path_564979, "resourceGroupName", newJString(resourceGroupName))
  add(path_564979, "resourceName", newJString(resourceName))
  result = call_564978.call(path_564979, query_564980, nil, nil, nil)

var replicationProtectionContainerMappingsListByReplicationProtectionContainers* = Call_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_564968(name: "replicationProtectionContainerMappingsListByReplicationProtectionContainers",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings", validator: validate_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_564969,
    base: "", url: url_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_564970,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsCreate_564995 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectionContainerMappingsCreate_564997(protocol: Scheme;
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

proc validate_ReplicationProtectionContainerMappingsCreate_564996(path: JsonNode;
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
  var valid_564998 = path.getOrDefault("protectionContainerName")
  valid_564998 = validateParameter(valid_564998, JString, required = true,
                                 default = nil)
  if valid_564998 != nil:
    section.add "protectionContainerName", valid_564998
  var valid_564999 = path.getOrDefault("fabricName")
  valid_564999 = validateParameter(valid_564999, JString, required = true,
                                 default = nil)
  if valid_564999 != nil:
    section.add "fabricName", valid_564999
  var valid_565000 = path.getOrDefault("subscriptionId")
  valid_565000 = validateParameter(valid_565000, JString, required = true,
                                 default = nil)
  if valid_565000 != nil:
    section.add "subscriptionId", valid_565000
  var valid_565001 = path.getOrDefault("mappingName")
  valid_565001 = validateParameter(valid_565001, JString, required = true,
                                 default = nil)
  if valid_565001 != nil:
    section.add "mappingName", valid_565001
  var valid_565002 = path.getOrDefault("resourceGroupName")
  valid_565002 = validateParameter(valid_565002, JString, required = true,
                                 default = nil)
  if valid_565002 != nil:
    section.add "resourceGroupName", valid_565002
  var valid_565003 = path.getOrDefault("resourceName")
  valid_565003 = validateParameter(valid_565003, JString, required = true,
                                 default = nil)
  if valid_565003 != nil:
    section.add "resourceName", valid_565003
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565004 = query.getOrDefault("api-version")
  valid_565004 = validateParameter(valid_565004, JString, required = true,
                                 default = nil)
  if valid_565004 != nil:
    section.add "api-version", valid_565004
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

proc call*(call_565006: Call_ReplicationProtectionContainerMappingsCreate_564995;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create a protection container mapping.
  ## 
  let valid = call_565006.validator(path, query, header, formData, body)
  let scheme = call_565006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565006.url(scheme.get, call_565006.host, call_565006.base,
                         call_565006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565006, url, valid)

proc call*(call_565007: Call_ReplicationProtectionContainerMappingsCreate_564995;
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
  var path_565008 = newJObject()
  var query_565009 = newJObject()
  var body_565010 = newJObject()
  add(path_565008, "protectionContainerName", newJString(protectionContainerName))
  add(query_565009, "api-version", newJString(apiVersion))
  if creationInput != nil:
    body_565010 = creationInput
  add(path_565008, "fabricName", newJString(fabricName))
  add(path_565008, "subscriptionId", newJString(subscriptionId))
  add(path_565008, "mappingName", newJString(mappingName))
  add(path_565008, "resourceGroupName", newJString(resourceGroupName))
  add(path_565008, "resourceName", newJString(resourceName))
  result = call_565007.call(path_565008, query_565009, nil, nil, body_565010)

var replicationProtectionContainerMappingsCreate* = Call_ReplicationProtectionContainerMappingsCreate_564995(
    name: "replicationProtectionContainerMappingsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}",
    validator: validate_ReplicationProtectionContainerMappingsCreate_564996,
    base: "", url: url_ReplicationProtectionContainerMappingsCreate_564997,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsGet_564981 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectionContainerMappingsGet_564983(protocol: Scheme;
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

proc validate_ReplicationProtectionContainerMappingsGet_564982(path: JsonNode;
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
  var valid_564984 = path.getOrDefault("protectionContainerName")
  valid_564984 = validateParameter(valid_564984, JString, required = true,
                                 default = nil)
  if valid_564984 != nil:
    section.add "protectionContainerName", valid_564984
  var valid_564985 = path.getOrDefault("fabricName")
  valid_564985 = validateParameter(valid_564985, JString, required = true,
                                 default = nil)
  if valid_564985 != nil:
    section.add "fabricName", valid_564985
  var valid_564986 = path.getOrDefault("subscriptionId")
  valid_564986 = validateParameter(valid_564986, JString, required = true,
                                 default = nil)
  if valid_564986 != nil:
    section.add "subscriptionId", valid_564986
  var valid_564987 = path.getOrDefault("mappingName")
  valid_564987 = validateParameter(valid_564987, JString, required = true,
                                 default = nil)
  if valid_564987 != nil:
    section.add "mappingName", valid_564987
  var valid_564988 = path.getOrDefault("resourceGroupName")
  valid_564988 = validateParameter(valid_564988, JString, required = true,
                                 default = nil)
  if valid_564988 != nil:
    section.add "resourceGroupName", valid_564988
  var valid_564989 = path.getOrDefault("resourceName")
  valid_564989 = validateParameter(valid_564989, JString, required = true,
                                 default = nil)
  if valid_564989 != nil:
    section.add "resourceName", valid_564989
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564990 = query.getOrDefault("api-version")
  valid_564990 = validateParameter(valid_564990, JString, required = true,
                                 default = nil)
  if valid_564990 != nil:
    section.add "api-version", valid_564990
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564991: Call_ReplicationProtectionContainerMappingsGet_564981;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of a protection container mapping.
  ## 
  let valid = call_564991.validator(path, query, header, formData, body)
  let scheme = call_564991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564991.url(scheme.get, call_564991.host, call_564991.base,
                         call_564991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564991, url, valid)

proc call*(call_564992: Call_ReplicationProtectionContainerMappingsGet_564981;
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
  var path_564993 = newJObject()
  var query_564994 = newJObject()
  add(path_564993, "protectionContainerName", newJString(protectionContainerName))
  add(query_564994, "api-version", newJString(apiVersion))
  add(path_564993, "fabricName", newJString(fabricName))
  add(path_564993, "subscriptionId", newJString(subscriptionId))
  add(path_564993, "mappingName", newJString(mappingName))
  add(path_564993, "resourceGroupName", newJString(resourceGroupName))
  add(path_564993, "resourceName", newJString(resourceName))
  result = call_564992.call(path_564993, query_564994, nil, nil, nil)

var replicationProtectionContainerMappingsGet* = Call_ReplicationProtectionContainerMappingsGet_564981(
    name: "replicationProtectionContainerMappingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}",
    validator: validate_ReplicationProtectionContainerMappingsGet_564982,
    base: "", url: url_ReplicationProtectionContainerMappingsGet_564983,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsUpdate_565025 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectionContainerMappingsUpdate_565027(protocol: Scheme;
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

proc validate_ReplicationProtectionContainerMappingsUpdate_565026(path: JsonNode;
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
  var valid_565028 = path.getOrDefault("protectionContainerName")
  valid_565028 = validateParameter(valid_565028, JString, required = true,
                                 default = nil)
  if valid_565028 != nil:
    section.add "protectionContainerName", valid_565028
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
  var valid_565031 = path.getOrDefault("mappingName")
  valid_565031 = validateParameter(valid_565031, JString, required = true,
                                 default = nil)
  if valid_565031 != nil:
    section.add "mappingName", valid_565031
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
  ## parameters in `body` object:
  ##   updateInput: JObject (required)
  ##              : Mapping update input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565036: Call_ReplicationProtectionContainerMappingsUpdate_565025;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to update protection container mapping.
  ## 
  let valid = call_565036.validator(path, query, header, formData, body)
  let scheme = call_565036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565036.url(scheme.get, call_565036.host, call_565036.base,
                         call_565036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565036, url, valid)

proc call*(call_565037: Call_ReplicationProtectionContainerMappingsUpdate_565025;
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
  var path_565038 = newJObject()
  var query_565039 = newJObject()
  var body_565040 = newJObject()
  add(path_565038, "protectionContainerName", newJString(protectionContainerName))
  add(query_565039, "api-version", newJString(apiVersion))
  add(path_565038, "fabricName", newJString(fabricName))
  add(path_565038, "subscriptionId", newJString(subscriptionId))
  add(path_565038, "mappingName", newJString(mappingName))
  add(path_565038, "resourceGroupName", newJString(resourceGroupName))
  add(path_565038, "resourceName", newJString(resourceName))
  if updateInput != nil:
    body_565040 = updateInput
  result = call_565037.call(path_565038, query_565039, nil, nil, body_565040)

var replicationProtectionContainerMappingsUpdate* = Call_ReplicationProtectionContainerMappingsUpdate_565025(
    name: "replicationProtectionContainerMappingsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}",
    validator: validate_ReplicationProtectionContainerMappingsUpdate_565026,
    base: "", url: url_ReplicationProtectionContainerMappingsUpdate_565027,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsPurge_565011 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectionContainerMappingsPurge_565013(protocol: Scheme;
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

proc validate_ReplicationProtectionContainerMappingsPurge_565012(path: JsonNode;
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
  var valid_565014 = path.getOrDefault("protectionContainerName")
  valid_565014 = validateParameter(valid_565014, JString, required = true,
                                 default = nil)
  if valid_565014 != nil:
    section.add "protectionContainerName", valid_565014
  var valid_565015 = path.getOrDefault("fabricName")
  valid_565015 = validateParameter(valid_565015, JString, required = true,
                                 default = nil)
  if valid_565015 != nil:
    section.add "fabricName", valid_565015
  var valid_565016 = path.getOrDefault("subscriptionId")
  valid_565016 = validateParameter(valid_565016, JString, required = true,
                                 default = nil)
  if valid_565016 != nil:
    section.add "subscriptionId", valid_565016
  var valid_565017 = path.getOrDefault("mappingName")
  valid_565017 = validateParameter(valid_565017, JString, required = true,
                                 default = nil)
  if valid_565017 != nil:
    section.add "mappingName", valid_565017
  var valid_565018 = path.getOrDefault("resourceGroupName")
  valid_565018 = validateParameter(valid_565018, JString, required = true,
                                 default = nil)
  if valid_565018 != nil:
    section.add "resourceGroupName", valid_565018
  var valid_565019 = path.getOrDefault("resourceName")
  valid_565019 = validateParameter(valid_565019, JString, required = true,
                                 default = nil)
  if valid_565019 != nil:
    section.add "resourceName", valid_565019
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565020 = query.getOrDefault("api-version")
  valid_565020 = validateParameter(valid_565020, JString, required = true,
                                 default = nil)
  if valid_565020 != nil:
    section.add "api-version", valid_565020
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565021: Call_ReplicationProtectionContainerMappingsPurge_565011;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to purge(force delete) a protection container mapping
  ## 
  let valid = call_565021.validator(path, query, header, formData, body)
  let scheme = call_565021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565021.url(scheme.get, call_565021.host, call_565021.base,
                         call_565021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565021, url, valid)

proc call*(call_565022: Call_ReplicationProtectionContainerMappingsPurge_565011;
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
  var path_565023 = newJObject()
  var query_565024 = newJObject()
  add(path_565023, "protectionContainerName", newJString(protectionContainerName))
  add(query_565024, "api-version", newJString(apiVersion))
  add(path_565023, "fabricName", newJString(fabricName))
  add(path_565023, "subscriptionId", newJString(subscriptionId))
  add(path_565023, "mappingName", newJString(mappingName))
  add(path_565023, "resourceGroupName", newJString(resourceGroupName))
  add(path_565023, "resourceName", newJString(resourceName))
  result = call_565022.call(path_565023, query_565024, nil, nil, nil)

var replicationProtectionContainerMappingsPurge* = Call_ReplicationProtectionContainerMappingsPurge_565011(
    name: "replicationProtectionContainerMappingsPurge",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}",
    validator: validate_ReplicationProtectionContainerMappingsPurge_565012,
    base: "", url: url_ReplicationProtectionContainerMappingsPurge_565013,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsDelete_565041 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectionContainerMappingsDelete_565043(protocol: Scheme;
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

proc validate_ReplicationProtectionContainerMappingsDelete_565042(path: JsonNode;
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
  var valid_565044 = path.getOrDefault("protectionContainerName")
  valid_565044 = validateParameter(valid_565044, JString, required = true,
                                 default = nil)
  if valid_565044 != nil:
    section.add "protectionContainerName", valid_565044
  var valid_565045 = path.getOrDefault("fabricName")
  valid_565045 = validateParameter(valid_565045, JString, required = true,
                                 default = nil)
  if valid_565045 != nil:
    section.add "fabricName", valid_565045
  var valid_565046 = path.getOrDefault("subscriptionId")
  valid_565046 = validateParameter(valid_565046, JString, required = true,
                                 default = nil)
  if valid_565046 != nil:
    section.add "subscriptionId", valid_565046
  var valid_565047 = path.getOrDefault("mappingName")
  valid_565047 = validateParameter(valid_565047, JString, required = true,
                                 default = nil)
  if valid_565047 != nil:
    section.add "mappingName", valid_565047
  var valid_565048 = path.getOrDefault("resourceGroupName")
  valid_565048 = validateParameter(valid_565048, JString, required = true,
                                 default = nil)
  if valid_565048 != nil:
    section.add "resourceGroupName", valid_565048
  var valid_565049 = path.getOrDefault("resourceName")
  valid_565049 = validateParameter(valid_565049, JString, required = true,
                                 default = nil)
  if valid_565049 != nil:
    section.add "resourceName", valid_565049
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565050 = query.getOrDefault("api-version")
  valid_565050 = validateParameter(valid_565050, JString, required = true,
                                 default = nil)
  if valid_565050 != nil:
    section.add "api-version", valid_565050
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

proc call*(call_565052: Call_ReplicationProtectionContainerMappingsDelete_565041;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete or remove a protection container mapping.
  ## 
  let valid = call_565052.validator(path, query, header, formData, body)
  let scheme = call_565052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565052.url(scheme.get, call_565052.host, call_565052.base,
                         call_565052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565052, url, valid)

proc call*(call_565053: Call_ReplicationProtectionContainerMappingsDelete_565041;
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
  var path_565054 = newJObject()
  var query_565055 = newJObject()
  var body_565056 = newJObject()
  add(path_565054, "protectionContainerName", newJString(protectionContainerName))
  add(query_565055, "api-version", newJString(apiVersion))
  add(path_565054, "fabricName", newJString(fabricName))
  add(path_565054, "subscriptionId", newJString(subscriptionId))
  add(path_565054, "mappingName", newJString(mappingName))
  add(path_565054, "resourceGroupName", newJString(resourceGroupName))
  if removalInput != nil:
    body_565056 = removalInput
  add(path_565054, "resourceName", newJString(resourceName))
  result = call_565053.call(path_565054, query_565055, nil, nil, body_565056)

var replicationProtectionContainerMappingsDelete* = Call_ReplicationProtectionContainerMappingsDelete_565041(
    name: "replicationProtectionContainerMappingsDelete",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}/remove",
    validator: validate_ReplicationProtectionContainerMappingsDelete_565042,
    base: "", url: url_ReplicationProtectionContainerMappingsDelete_565043,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersSwitchProtection_565057 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectionContainersSwitchProtection_565059(protocol: Scheme;
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

proc validate_ReplicationProtectionContainersSwitchProtection_565058(
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
  var valid_565060 = path.getOrDefault("protectionContainerName")
  valid_565060 = validateParameter(valid_565060, JString, required = true,
                                 default = nil)
  if valid_565060 != nil:
    section.add "protectionContainerName", valid_565060
  var valid_565061 = path.getOrDefault("fabricName")
  valid_565061 = validateParameter(valid_565061, JString, required = true,
                                 default = nil)
  if valid_565061 != nil:
    section.add "fabricName", valid_565061
  var valid_565062 = path.getOrDefault("subscriptionId")
  valid_565062 = validateParameter(valid_565062, JString, required = true,
                                 default = nil)
  if valid_565062 != nil:
    section.add "subscriptionId", valid_565062
  var valid_565063 = path.getOrDefault("resourceGroupName")
  valid_565063 = validateParameter(valid_565063, JString, required = true,
                                 default = nil)
  if valid_565063 != nil:
    section.add "resourceGroupName", valid_565063
  var valid_565064 = path.getOrDefault("resourceName")
  valid_565064 = validateParameter(valid_565064, JString, required = true,
                                 default = nil)
  if valid_565064 != nil:
    section.add "resourceName", valid_565064
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565065 = query.getOrDefault("api-version")
  valid_565065 = validateParameter(valid_565065, JString, required = true,
                                 default = nil)
  if valid_565065 != nil:
    section.add "api-version", valid_565065
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

proc call*(call_565067: Call_ReplicationProtectionContainersSwitchProtection_565057;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to switch protection from one container to another or one replication provider to another.
  ## 
  let valid = call_565067.validator(path, query, header, formData, body)
  let scheme = call_565067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565067.url(scheme.get, call_565067.host, call_565067.base,
                         call_565067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565067, url, valid)

proc call*(call_565068: Call_ReplicationProtectionContainersSwitchProtection_565057;
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
  var path_565069 = newJObject()
  var query_565070 = newJObject()
  var body_565071 = newJObject()
  add(path_565069, "protectionContainerName", newJString(protectionContainerName))
  add(query_565070, "api-version", newJString(apiVersion))
  add(path_565069, "fabricName", newJString(fabricName))
  add(path_565069, "subscriptionId", newJString(subscriptionId))
  add(path_565069, "resourceGroupName", newJString(resourceGroupName))
  add(path_565069, "resourceName", newJString(resourceName))
  if switchInput != nil:
    body_565071 = switchInput
  result = call_565068.call(path_565069, query_565070, nil, nil, body_565071)

var replicationProtectionContainersSwitchProtection* = Call_ReplicationProtectionContainersSwitchProtection_565057(
    name: "replicationProtectionContainersSwitchProtection",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/switchprotection",
    validator: validate_ReplicationProtectionContainersSwitchProtection_565058,
    base: "", url: url_ReplicationProtectionContainersSwitchProtection_565059,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersListByReplicationFabrics_565072 = ref object of OpenApiRestCall_563566
proc url_ReplicationRecoveryServicesProvidersListByReplicationFabrics_565074(
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

proc validate_ReplicationRecoveryServicesProvidersListByReplicationFabrics_565073(
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
  var valid_565075 = path.getOrDefault("fabricName")
  valid_565075 = validateParameter(valid_565075, JString, required = true,
                                 default = nil)
  if valid_565075 != nil:
    section.add "fabricName", valid_565075
  var valid_565076 = path.getOrDefault("subscriptionId")
  valid_565076 = validateParameter(valid_565076, JString, required = true,
                                 default = nil)
  if valid_565076 != nil:
    section.add "subscriptionId", valid_565076
  var valid_565077 = path.getOrDefault("resourceGroupName")
  valid_565077 = validateParameter(valid_565077, JString, required = true,
                                 default = nil)
  if valid_565077 != nil:
    section.add "resourceGroupName", valid_565077
  var valid_565078 = path.getOrDefault("resourceName")
  valid_565078 = validateParameter(valid_565078, JString, required = true,
                                 default = nil)
  if valid_565078 != nil:
    section.add "resourceName", valid_565078
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565079 = query.getOrDefault("api-version")
  valid_565079 = validateParameter(valid_565079, JString, required = true,
                                 default = nil)
  if valid_565079 != nil:
    section.add "api-version", valid_565079
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565080: Call_ReplicationRecoveryServicesProvidersListByReplicationFabrics_565072;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the registered recovery services providers for the specified fabric.
  ## 
  let valid = call_565080.validator(path, query, header, formData, body)
  let scheme = call_565080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565080.url(scheme.get, call_565080.host, call_565080.base,
                         call_565080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565080, url, valid)

proc call*(call_565081: Call_ReplicationRecoveryServicesProvidersListByReplicationFabrics_565072;
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
  var path_565082 = newJObject()
  var query_565083 = newJObject()
  add(query_565083, "api-version", newJString(apiVersion))
  add(path_565082, "fabricName", newJString(fabricName))
  add(path_565082, "subscriptionId", newJString(subscriptionId))
  add(path_565082, "resourceGroupName", newJString(resourceGroupName))
  add(path_565082, "resourceName", newJString(resourceName))
  result = call_565081.call(path_565082, query_565083, nil, nil, nil)

var replicationRecoveryServicesProvidersListByReplicationFabrics* = Call_ReplicationRecoveryServicesProvidersListByReplicationFabrics_565072(
    name: "replicationRecoveryServicesProvidersListByReplicationFabrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders", validator: validate_ReplicationRecoveryServicesProvidersListByReplicationFabrics_565073,
    base: "",
    url: url_ReplicationRecoveryServicesProvidersListByReplicationFabrics_565074,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersCreate_565097 = ref object of OpenApiRestCall_563566
proc url_ReplicationRecoveryServicesProvidersCreate_565099(protocol: Scheme;
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

proc validate_ReplicationRecoveryServicesProvidersCreate_565098(path: JsonNode;
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
  var valid_565100 = path.getOrDefault("providerName")
  valid_565100 = validateParameter(valid_565100, JString, required = true,
                                 default = nil)
  if valid_565100 != nil:
    section.add "providerName", valid_565100
  var valid_565101 = path.getOrDefault("fabricName")
  valid_565101 = validateParameter(valid_565101, JString, required = true,
                                 default = nil)
  if valid_565101 != nil:
    section.add "fabricName", valid_565101
  var valid_565102 = path.getOrDefault("subscriptionId")
  valid_565102 = validateParameter(valid_565102, JString, required = true,
                                 default = nil)
  if valid_565102 != nil:
    section.add "subscriptionId", valid_565102
  var valid_565103 = path.getOrDefault("resourceGroupName")
  valid_565103 = validateParameter(valid_565103, JString, required = true,
                                 default = nil)
  if valid_565103 != nil:
    section.add "resourceGroupName", valid_565103
  var valid_565104 = path.getOrDefault("resourceName")
  valid_565104 = validateParameter(valid_565104, JString, required = true,
                                 default = nil)
  if valid_565104 != nil:
    section.add "resourceName", valid_565104
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565105 = query.getOrDefault("api-version")
  valid_565105 = validateParameter(valid_565105, JString, required = true,
                                 default = nil)
  if valid_565105 != nil:
    section.add "api-version", valid_565105
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

proc call*(call_565107: Call_ReplicationRecoveryServicesProvidersCreate_565097;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to add a recovery services provider.
  ## 
  let valid = call_565107.validator(path, query, header, formData, body)
  let scheme = call_565107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565107.url(scheme.get, call_565107.host, call_565107.base,
                         call_565107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565107, url, valid)

proc call*(call_565108: Call_ReplicationRecoveryServicesProvidersCreate_565097;
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
  var path_565109 = newJObject()
  var query_565110 = newJObject()
  var body_565111 = newJObject()
  add(path_565109, "providerName", newJString(providerName))
  add(query_565110, "api-version", newJString(apiVersion))
  add(path_565109, "fabricName", newJString(fabricName))
  if addProviderInput != nil:
    body_565111 = addProviderInput
  add(path_565109, "subscriptionId", newJString(subscriptionId))
  add(path_565109, "resourceGroupName", newJString(resourceGroupName))
  add(path_565109, "resourceName", newJString(resourceName))
  result = call_565108.call(path_565109, query_565110, nil, nil, body_565111)

var replicationRecoveryServicesProvidersCreate* = Call_ReplicationRecoveryServicesProvidersCreate_565097(
    name: "replicationRecoveryServicesProvidersCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}",
    validator: validate_ReplicationRecoveryServicesProvidersCreate_565098,
    base: "", url: url_ReplicationRecoveryServicesProvidersCreate_565099,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersGet_565084 = ref object of OpenApiRestCall_563566
proc url_ReplicationRecoveryServicesProvidersGet_565086(protocol: Scheme;
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

proc validate_ReplicationRecoveryServicesProvidersGet_565085(path: JsonNode;
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
  var valid_565087 = path.getOrDefault("providerName")
  valid_565087 = validateParameter(valid_565087, JString, required = true,
                                 default = nil)
  if valid_565087 != nil:
    section.add "providerName", valid_565087
  var valid_565088 = path.getOrDefault("fabricName")
  valid_565088 = validateParameter(valid_565088, JString, required = true,
                                 default = nil)
  if valid_565088 != nil:
    section.add "fabricName", valid_565088
  var valid_565089 = path.getOrDefault("subscriptionId")
  valid_565089 = validateParameter(valid_565089, JString, required = true,
                                 default = nil)
  if valid_565089 != nil:
    section.add "subscriptionId", valid_565089
  var valid_565090 = path.getOrDefault("resourceGroupName")
  valid_565090 = validateParameter(valid_565090, JString, required = true,
                                 default = nil)
  if valid_565090 != nil:
    section.add "resourceGroupName", valid_565090
  var valid_565091 = path.getOrDefault("resourceName")
  valid_565091 = validateParameter(valid_565091, JString, required = true,
                                 default = nil)
  if valid_565091 != nil:
    section.add "resourceName", valid_565091
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565092 = query.getOrDefault("api-version")
  valid_565092 = validateParameter(valid_565092, JString, required = true,
                                 default = nil)
  if valid_565092 != nil:
    section.add "api-version", valid_565092
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565093: Call_ReplicationRecoveryServicesProvidersGet_565084;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of registered recovery services provider.
  ## 
  let valid = call_565093.validator(path, query, header, formData, body)
  let scheme = call_565093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565093.url(scheme.get, call_565093.host, call_565093.base,
                         call_565093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565093, url, valid)

proc call*(call_565094: Call_ReplicationRecoveryServicesProvidersGet_565084;
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
  var path_565095 = newJObject()
  var query_565096 = newJObject()
  add(path_565095, "providerName", newJString(providerName))
  add(query_565096, "api-version", newJString(apiVersion))
  add(path_565095, "fabricName", newJString(fabricName))
  add(path_565095, "subscriptionId", newJString(subscriptionId))
  add(path_565095, "resourceGroupName", newJString(resourceGroupName))
  add(path_565095, "resourceName", newJString(resourceName))
  result = call_565094.call(path_565095, query_565096, nil, nil, nil)

var replicationRecoveryServicesProvidersGet* = Call_ReplicationRecoveryServicesProvidersGet_565084(
    name: "replicationRecoveryServicesProvidersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}",
    validator: validate_ReplicationRecoveryServicesProvidersGet_565085, base: "",
    url: url_ReplicationRecoveryServicesProvidersGet_565086,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersPurge_565112 = ref object of OpenApiRestCall_563566
proc url_ReplicationRecoveryServicesProvidersPurge_565114(protocol: Scheme;
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

proc validate_ReplicationRecoveryServicesProvidersPurge_565113(path: JsonNode;
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
  var valid_565115 = path.getOrDefault("providerName")
  valid_565115 = validateParameter(valid_565115, JString, required = true,
                                 default = nil)
  if valid_565115 != nil:
    section.add "providerName", valid_565115
  var valid_565116 = path.getOrDefault("fabricName")
  valid_565116 = validateParameter(valid_565116, JString, required = true,
                                 default = nil)
  if valid_565116 != nil:
    section.add "fabricName", valid_565116
  var valid_565117 = path.getOrDefault("subscriptionId")
  valid_565117 = validateParameter(valid_565117, JString, required = true,
                                 default = nil)
  if valid_565117 != nil:
    section.add "subscriptionId", valid_565117
  var valid_565118 = path.getOrDefault("resourceGroupName")
  valid_565118 = validateParameter(valid_565118, JString, required = true,
                                 default = nil)
  if valid_565118 != nil:
    section.add "resourceGroupName", valid_565118
  var valid_565119 = path.getOrDefault("resourceName")
  valid_565119 = validateParameter(valid_565119, JString, required = true,
                                 default = nil)
  if valid_565119 != nil:
    section.add "resourceName", valid_565119
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565120 = query.getOrDefault("api-version")
  valid_565120 = validateParameter(valid_565120, JString, required = true,
                                 default = nil)
  if valid_565120 != nil:
    section.add "api-version", valid_565120
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565121: Call_ReplicationRecoveryServicesProvidersPurge_565112;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to purge(force delete) a recovery services provider from the vault.
  ## 
  let valid = call_565121.validator(path, query, header, formData, body)
  let scheme = call_565121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565121.url(scheme.get, call_565121.host, call_565121.base,
                         call_565121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565121, url, valid)

proc call*(call_565122: Call_ReplicationRecoveryServicesProvidersPurge_565112;
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
  var path_565123 = newJObject()
  var query_565124 = newJObject()
  add(path_565123, "providerName", newJString(providerName))
  add(query_565124, "api-version", newJString(apiVersion))
  add(path_565123, "fabricName", newJString(fabricName))
  add(path_565123, "subscriptionId", newJString(subscriptionId))
  add(path_565123, "resourceGroupName", newJString(resourceGroupName))
  add(path_565123, "resourceName", newJString(resourceName))
  result = call_565122.call(path_565123, query_565124, nil, nil, nil)

var replicationRecoveryServicesProvidersPurge* = Call_ReplicationRecoveryServicesProvidersPurge_565112(
    name: "replicationRecoveryServicesProvidersPurge",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}",
    validator: validate_ReplicationRecoveryServicesProvidersPurge_565113,
    base: "", url: url_ReplicationRecoveryServicesProvidersPurge_565114,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersRefreshProvider_565125 = ref object of OpenApiRestCall_563566
proc url_ReplicationRecoveryServicesProvidersRefreshProvider_565127(
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

proc validate_ReplicationRecoveryServicesProvidersRefreshProvider_565126(
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
  var valid_565128 = path.getOrDefault("providerName")
  valid_565128 = validateParameter(valid_565128, JString, required = true,
                                 default = nil)
  if valid_565128 != nil:
    section.add "providerName", valid_565128
  var valid_565129 = path.getOrDefault("fabricName")
  valid_565129 = validateParameter(valid_565129, JString, required = true,
                                 default = nil)
  if valid_565129 != nil:
    section.add "fabricName", valid_565129
  var valid_565130 = path.getOrDefault("subscriptionId")
  valid_565130 = validateParameter(valid_565130, JString, required = true,
                                 default = nil)
  if valid_565130 != nil:
    section.add "subscriptionId", valid_565130
  var valid_565131 = path.getOrDefault("resourceGroupName")
  valid_565131 = validateParameter(valid_565131, JString, required = true,
                                 default = nil)
  if valid_565131 != nil:
    section.add "resourceGroupName", valid_565131
  var valid_565132 = path.getOrDefault("resourceName")
  valid_565132 = validateParameter(valid_565132, JString, required = true,
                                 default = nil)
  if valid_565132 != nil:
    section.add "resourceName", valid_565132
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565133 = query.getOrDefault("api-version")
  valid_565133 = validateParameter(valid_565133, JString, required = true,
                                 default = nil)
  if valid_565133 != nil:
    section.add "api-version", valid_565133
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565134: Call_ReplicationRecoveryServicesProvidersRefreshProvider_565125;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to refresh the information from the recovery services provider.
  ## 
  let valid = call_565134.validator(path, query, header, formData, body)
  let scheme = call_565134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565134.url(scheme.get, call_565134.host, call_565134.base,
                         call_565134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565134, url, valid)

proc call*(call_565135: Call_ReplicationRecoveryServicesProvidersRefreshProvider_565125;
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
  var path_565136 = newJObject()
  var query_565137 = newJObject()
  add(path_565136, "providerName", newJString(providerName))
  add(query_565137, "api-version", newJString(apiVersion))
  add(path_565136, "fabricName", newJString(fabricName))
  add(path_565136, "subscriptionId", newJString(subscriptionId))
  add(path_565136, "resourceGroupName", newJString(resourceGroupName))
  add(path_565136, "resourceName", newJString(resourceName))
  result = call_565135.call(path_565136, query_565137, nil, nil, nil)

var replicationRecoveryServicesProvidersRefreshProvider* = Call_ReplicationRecoveryServicesProvidersRefreshProvider_565125(
    name: "replicationRecoveryServicesProvidersRefreshProvider",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}/refreshProvider",
    validator: validate_ReplicationRecoveryServicesProvidersRefreshProvider_565126,
    base: "", url: url_ReplicationRecoveryServicesProvidersRefreshProvider_565127,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersDelete_565138 = ref object of OpenApiRestCall_563566
proc url_ReplicationRecoveryServicesProvidersDelete_565140(protocol: Scheme;
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

proc validate_ReplicationRecoveryServicesProvidersDelete_565139(path: JsonNode;
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
  var valid_565141 = path.getOrDefault("providerName")
  valid_565141 = validateParameter(valid_565141, JString, required = true,
                                 default = nil)
  if valid_565141 != nil:
    section.add "providerName", valid_565141
  var valid_565142 = path.getOrDefault("fabricName")
  valid_565142 = validateParameter(valid_565142, JString, required = true,
                                 default = nil)
  if valid_565142 != nil:
    section.add "fabricName", valid_565142
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

proc call*(call_565147: Call_ReplicationRecoveryServicesProvidersDelete_565138;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to removes/delete(unregister) a recovery services provider from the vault
  ## 
  let valid = call_565147.validator(path, query, header, formData, body)
  let scheme = call_565147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565147.url(scheme.get, call_565147.host, call_565147.base,
                         call_565147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565147, url, valid)

proc call*(call_565148: Call_ReplicationRecoveryServicesProvidersDelete_565138;
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
  var path_565149 = newJObject()
  var query_565150 = newJObject()
  add(path_565149, "providerName", newJString(providerName))
  add(query_565150, "api-version", newJString(apiVersion))
  add(path_565149, "fabricName", newJString(fabricName))
  add(path_565149, "subscriptionId", newJString(subscriptionId))
  add(path_565149, "resourceGroupName", newJString(resourceGroupName))
  add(path_565149, "resourceName", newJString(resourceName))
  result = call_565148.call(path_565149, query_565150, nil, nil, nil)

var replicationRecoveryServicesProvidersDelete* = Call_ReplicationRecoveryServicesProvidersDelete_565138(
    name: "replicationRecoveryServicesProvidersDelete", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}/remove",
    validator: validate_ReplicationRecoveryServicesProvidersDelete_565139,
    base: "", url: url_ReplicationRecoveryServicesProvidersDelete_565140,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationsListByReplicationFabrics_565151 = ref object of OpenApiRestCall_563566
proc url_ReplicationStorageClassificationsListByReplicationFabrics_565153(
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

proc validate_ReplicationStorageClassificationsListByReplicationFabrics_565152(
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
  var valid_565154 = path.getOrDefault("fabricName")
  valid_565154 = validateParameter(valid_565154, JString, required = true,
                                 default = nil)
  if valid_565154 != nil:
    section.add "fabricName", valid_565154
  var valid_565155 = path.getOrDefault("subscriptionId")
  valid_565155 = validateParameter(valid_565155, JString, required = true,
                                 default = nil)
  if valid_565155 != nil:
    section.add "subscriptionId", valid_565155
  var valid_565156 = path.getOrDefault("resourceGroupName")
  valid_565156 = validateParameter(valid_565156, JString, required = true,
                                 default = nil)
  if valid_565156 != nil:
    section.add "resourceGroupName", valid_565156
  var valid_565157 = path.getOrDefault("resourceName")
  valid_565157 = validateParameter(valid_565157, JString, required = true,
                                 default = nil)
  if valid_565157 != nil:
    section.add "resourceName", valid_565157
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565158 = query.getOrDefault("api-version")
  valid_565158 = validateParameter(valid_565158, JString, required = true,
                                 default = nil)
  if valid_565158 != nil:
    section.add "api-version", valid_565158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565159: Call_ReplicationStorageClassificationsListByReplicationFabrics_565151;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the storage classifications available in the specified fabric.
  ## 
  let valid = call_565159.validator(path, query, header, formData, body)
  let scheme = call_565159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565159.url(scheme.get, call_565159.host, call_565159.base,
                         call_565159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565159, url, valid)

proc call*(call_565160: Call_ReplicationStorageClassificationsListByReplicationFabrics_565151;
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
  var path_565161 = newJObject()
  var query_565162 = newJObject()
  add(query_565162, "api-version", newJString(apiVersion))
  add(path_565161, "fabricName", newJString(fabricName))
  add(path_565161, "subscriptionId", newJString(subscriptionId))
  add(path_565161, "resourceGroupName", newJString(resourceGroupName))
  add(path_565161, "resourceName", newJString(resourceName))
  result = call_565160.call(path_565161, query_565162, nil, nil, nil)

var replicationStorageClassificationsListByReplicationFabrics* = Call_ReplicationStorageClassificationsListByReplicationFabrics_565151(
    name: "replicationStorageClassificationsListByReplicationFabrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications", validator: validate_ReplicationStorageClassificationsListByReplicationFabrics_565152,
    base: "", url: url_ReplicationStorageClassificationsListByReplicationFabrics_565153,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationsGet_565163 = ref object of OpenApiRestCall_563566
proc url_ReplicationStorageClassificationsGet_565165(protocol: Scheme;
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

proc validate_ReplicationStorageClassificationsGet_565164(path: JsonNode;
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
  var valid_565166 = path.getOrDefault("fabricName")
  valid_565166 = validateParameter(valid_565166, JString, required = true,
                                 default = nil)
  if valid_565166 != nil:
    section.add "fabricName", valid_565166
  var valid_565167 = path.getOrDefault("subscriptionId")
  valid_565167 = validateParameter(valid_565167, JString, required = true,
                                 default = nil)
  if valid_565167 != nil:
    section.add "subscriptionId", valid_565167
  var valid_565168 = path.getOrDefault("resourceGroupName")
  valid_565168 = validateParameter(valid_565168, JString, required = true,
                                 default = nil)
  if valid_565168 != nil:
    section.add "resourceGroupName", valid_565168
  var valid_565169 = path.getOrDefault("resourceName")
  valid_565169 = validateParameter(valid_565169, JString, required = true,
                                 default = nil)
  if valid_565169 != nil:
    section.add "resourceName", valid_565169
  var valid_565170 = path.getOrDefault("storageClassificationName")
  valid_565170 = validateParameter(valid_565170, JString, required = true,
                                 default = nil)
  if valid_565170 != nil:
    section.add "storageClassificationName", valid_565170
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565171 = query.getOrDefault("api-version")
  valid_565171 = validateParameter(valid_565171, JString, required = true,
                                 default = nil)
  if valid_565171 != nil:
    section.add "api-version", valid_565171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565172: Call_ReplicationStorageClassificationsGet_565163;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of the specified storage classification.
  ## 
  let valid = call_565172.validator(path, query, header, formData, body)
  let scheme = call_565172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565172.url(scheme.get, call_565172.host, call_565172.base,
                         call_565172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565172, url, valid)

proc call*(call_565173: Call_ReplicationStorageClassificationsGet_565163;
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
  var path_565174 = newJObject()
  var query_565175 = newJObject()
  add(query_565175, "api-version", newJString(apiVersion))
  add(path_565174, "fabricName", newJString(fabricName))
  add(path_565174, "subscriptionId", newJString(subscriptionId))
  add(path_565174, "resourceGroupName", newJString(resourceGroupName))
  add(path_565174, "resourceName", newJString(resourceName))
  add(path_565174, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_565173.call(path_565174, query_565175, nil, nil, nil)

var replicationStorageClassificationsGet* = Call_ReplicationStorageClassificationsGet_565163(
    name: "replicationStorageClassificationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}",
    validator: validate_ReplicationStorageClassificationsGet_565164, base: "",
    url: url_ReplicationStorageClassificationsGet_565165, schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_565176 = ref object of OpenApiRestCall_563566
proc url_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_565178(
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

proc validate_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_565177(
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
  var valid_565179 = path.getOrDefault("fabricName")
  valid_565179 = validateParameter(valid_565179, JString, required = true,
                                 default = nil)
  if valid_565179 != nil:
    section.add "fabricName", valid_565179
  var valid_565180 = path.getOrDefault("subscriptionId")
  valid_565180 = validateParameter(valid_565180, JString, required = true,
                                 default = nil)
  if valid_565180 != nil:
    section.add "subscriptionId", valid_565180
  var valid_565181 = path.getOrDefault("resourceGroupName")
  valid_565181 = validateParameter(valid_565181, JString, required = true,
                                 default = nil)
  if valid_565181 != nil:
    section.add "resourceGroupName", valid_565181
  var valid_565182 = path.getOrDefault("resourceName")
  valid_565182 = validateParameter(valid_565182, JString, required = true,
                                 default = nil)
  if valid_565182 != nil:
    section.add "resourceName", valid_565182
  var valid_565183 = path.getOrDefault("storageClassificationName")
  valid_565183 = validateParameter(valid_565183, JString, required = true,
                                 default = nil)
  if valid_565183 != nil:
    section.add "storageClassificationName", valid_565183
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565184 = query.getOrDefault("api-version")
  valid_565184 = validateParameter(valid_565184, JString, required = true,
                                 default = nil)
  if valid_565184 != nil:
    section.add "api-version", valid_565184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565185: Call_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_565176;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the storage classification mappings for the fabric.
  ## 
  let valid = call_565185.validator(path, query, header, formData, body)
  let scheme = call_565185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565185.url(scheme.get, call_565185.host, call_565185.base,
                         call_565185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565185, url, valid)

proc call*(call_565186: Call_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_565176;
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
  var path_565187 = newJObject()
  var query_565188 = newJObject()
  add(query_565188, "api-version", newJString(apiVersion))
  add(path_565187, "fabricName", newJString(fabricName))
  add(path_565187, "subscriptionId", newJString(subscriptionId))
  add(path_565187, "resourceGroupName", newJString(resourceGroupName))
  add(path_565187, "resourceName", newJString(resourceName))
  add(path_565187, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_565186.call(path_565187, query_565188, nil, nil, nil)

var replicationStorageClassificationMappingsListByReplicationStorageClassifications* = Call_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_565176(name: "replicationStorageClassificationMappingsListByReplicationStorageClassifications",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}/replicationStorageClassificationMappings", validator: validate_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_565177,
    base: "", url: url_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_565178,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsCreate_565203 = ref object of OpenApiRestCall_563566
proc url_ReplicationStorageClassificationMappingsCreate_565205(protocol: Scheme;
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

proc validate_ReplicationStorageClassificationMappingsCreate_565204(
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
  var valid_565206 = path.getOrDefault("fabricName")
  valid_565206 = validateParameter(valid_565206, JString, required = true,
                                 default = nil)
  if valid_565206 != nil:
    section.add "fabricName", valid_565206
  var valid_565207 = path.getOrDefault("subscriptionId")
  valid_565207 = validateParameter(valid_565207, JString, required = true,
                                 default = nil)
  if valid_565207 != nil:
    section.add "subscriptionId", valid_565207
  var valid_565208 = path.getOrDefault("storageClassificationMappingName")
  valid_565208 = validateParameter(valid_565208, JString, required = true,
                                 default = nil)
  if valid_565208 != nil:
    section.add "storageClassificationMappingName", valid_565208
  var valid_565209 = path.getOrDefault("resourceGroupName")
  valid_565209 = validateParameter(valid_565209, JString, required = true,
                                 default = nil)
  if valid_565209 != nil:
    section.add "resourceGroupName", valid_565209
  var valid_565210 = path.getOrDefault("resourceName")
  valid_565210 = validateParameter(valid_565210, JString, required = true,
                                 default = nil)
  if valid_565210 != nil:
    section.add "resourceName", valid_565210
  var valid_565211 = path.getOrDefault("storageClassificationName")
  valid_565211 = validateParameter(valid_565211, JString, required = true,
                                 default = nil)
  if valid_565211 != nil:
    section.add "storageClassificationName", valid_565211
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565212 = query.getOrDefault("api-version")
  valid_565212 = validateParameter(valid_565212, JString, required = true,
                                 default = nil)
  if valid_565212 != nil:
    section.add "api-version", valid_565212
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

proc call*(call_565214: Call_ReplicationStorageClassificationMappingsCreate_565203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create a storage classification mapping.
  ## 
  let valid = call_565214.validator(path, query, header, formData, body)
  let scheme = call_565214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565214.url(scheme.get, call_565214.host, call_565214.base,
                         call_565214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565214, url, valid)

proc call*(call_565215: Call_ReplicationStorageClassificationMappingsCreate_565203;
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
  var path_565216 = newJObject()
  var query_565217 = newJObject()
  var body_565218 = newJObject()
  if pairingInput != nil:
    body_565218 = pairingInput
  add(query_565217, "api-version", newJString(apiVersion))
  add(path_565216, "fabricName", newJString(fabricName))
  add(path_565216, "subscriptionId", newJString(subscriptionId))
  add(path_565216, "storageClassificationMappingName",
      newJString(storageClassificationMappingName))
  add(path_565216, "resourceGroupName", newJString(resourceGroupName))
  add(path_565216, "resourceName", newJString(resourceName))
  add(path_565216, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_565215.call(path_565216, query_565217, nil, nil, body_565218)

var replicationStorageClassificationMappingsCreate* = Call_ReplicationStorageClassificationMappingsCreate_565203(
    name: "replicationStorageClassificationMappingsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}/replicationStorageClassificationMappings/{storageClassificationMappingName}",
    validator: validate_ReplicationStorageClassificationMappingsCreate_565204,
    base: "", url: url_ReplicationStorageClassificationMappingsCreate_565205,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsGet_565189 = ref object of OpenApiRestCall_563566
proc url_ReplicationStorageClassificationMappingsGet_565191(protocol: Scheme;
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

proc validate_ReplicationStorageClassificationMappingsGet_565190(path: JsonNode;
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
  var valid_565192 = path.getOrDefault("fabricName")
  valid_565192 = validateParameter(valid_565192, JString, required = true,
                                 default = nil)
  if valid_565192 != nil:
    section.add "fabricName", valid_565192
  var valid_565193 = path.getOrDefault("subscriptionId")
  valid_565193 = validateParameter(valid_565193, JString, required = true,
                                 default = nil)
  if valid_565193 != nil:
    section.add "subscriptionId", valid_565193
  var valid_565194 = path.getOrDefault("storageClassificationMappingName")
  valid_565194 = validateParameter(valid_565194, JString, required = true,
                                 default = nil)
  if valid_565194 != nil:
    section.add "storageClassificationMappingName", valid_565194
  var valid_565195 = path.getOrDefault("resourceGroupName")
  valid_565195 = validateParameter(valid_565195, JString, required = true,
                                 default = nil)
  if valid_565195 != nil:
    section.add "resourceGroupName", valid_565195
  var valid_565196 = path.getOrDefault("resourceName")
  valid_565196 = validateParameter(valid_565196, JString, required = true,
                                 default = nil)
  if valid_565196 != nil:
    section.add "resourceName", valid_565196
  var valid_565197 = path.getOrDefault("storageClassificationName")
  valid_565197 = validateParameter(valid_565197, JString, required = true,
                                 default = nil)
  if valid_565197 != nil:
    section.add "storageClassificationName", valid_565197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565198 = query.getOrDefault("api-version")
  valid_565198 = validateParameter(valid_565198, JString, required = true,
                                 default = nil)
  if valid_565198 != nil:
    section.add "api-version", valid_565198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565199: Call_ReplicationStorageClassificationMappingsGet_565189;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of the specified storage classification mapping.
  ## 
  let valid = call_565199.validator(path, query, header, formData, body)
  let scheme = call_565199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565199.url(scheme.get, call_565199.host, call_565199.base,
                         call_565199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565199, url, valid)

proc call*(call_565200: Call_ReplicationStorageClassificationMappingsGet_565189;
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
  var path_565201 = newJObject()
  var query_565202 = newJObject()
  add(query_565202, "api-version", newJString(apiVersion))
  add(path_565201, "fabricName", newJString(fabricName))
  add(path_565201, "subscriptionId", newJString(subscriptionId))
  add(path_565201, "storageClassificationMappingName",
      newJString(storageClassificationMappingName))
  add(path_565201, "resourceGroupName", newJString(resourceGroupName))
  add(path_565201, "resourceName", newJString(resourceName))
  add(path_565201, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_565200.call(path_565201, query_565202, nil, nil, nil)

var replicationStorageClassificationMappingsGet* = Call_ReplicationStorageClassificationMappingsGet_565189(
    name: "replicationStorageClassificationMappingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}/replicationStorageClassificationMappings/{storageClassificationMappingName}",
    validator: validate_ReplicationStorageClassificationMappingsGet_565190,
    base: "", url: url_ReplicationStorageClassificationMappingsGet_565191,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsDelete_565219 = ref object of OpenApiRestCall_563566
proc url_ReplicationStorageClassificationMappingsDelete_565221(protocol: Scheme;
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

proc validate_ReplicationStorageClassificationMappingsDelete_565220(
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
  var valid_565222 = path.getOrDefault("fabricName")
  valid_565222 = validateParameter(valid_565222, JString, required = true,
                                 default = nil)
  if valid_565222 != nil:
    section.add "fabricName", valid_565222
  var valid_565223 = path.getOrDefault("subscriptionId")
  valid_565223 = validateParameter(valid_565223, JString, required = true,
                                 default = nil)
  if valid_565223 != nil:
    section.add "subscriptionId", valid_565223
  var valid_565224 = path.getOrDefault("storageClassificationMappingName")
  valid_565224 = validateParameter(valid_565224, JString, required = true,
                                 default = nil)
  if valid_565224 != nil:
    section.add "storageClassificationMappingName", valid_565224
  var valid_565225 = path.getOrDefault("resourceGroupName")
  valid_565225 = validateParameter(valid_565225, JString, required = true,
                                 default = nil)
  if valid_565225 != nil:
    section.add "resourceGroupName", valid_565225
  var valid_565226 = path.getOrDefault("resourceName")
  valid_565226 = validateParameter(valid_565226, JString, required = true,
                                 default = nil)
  if valid_565226 != nil:
    section.add "resourceName", valid_565226
  var valid_565227 = path.getOrDefault("storageClassificationName")
  valid_565227 = validateParameter(valid_565227, JString, required = true,
                                 default = nil)
  if valid_565227 != nil:
    section.add "storageClassificationName", valid_565227
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565228 = query.getOrDefault("api-version")
  valid_565228 = validateParameter(valid_565228, JString, required = true,
                                 default = nil)
  if valid_565228 != nil:
    section.add "api-version", valid_565228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565229: Call_ReplicationStorageClassificationMappingsDelete_565219;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete a storage classification mapping.
  ## 
  let valid = call_565229.validator(path, query, header, formData, body)
  let scheme = call_565229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565229.url(scheme.get, call_565229.host, call_565229.base,
                         call_565229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565229, url, valid)

proc call*(call_565230: Call_ReplicationStorageClassificationMappingsDelete_565219;
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
  var path_565231 = newJObject()
  var query_565232 = newJObject()
  add(query_565232, "api-version", newJString(apiVersion))
  add(path_565231, "fabricName", newJString(fabricName))
  add(path_565231, "subscriptionId", newJString(subscriptionId))
  add(path_565231, "storageClassificationMappingName",
      newJString(storageClassificationMappingName))
  add(path_565231, "resourceGroupName", newJString(resourceGroupName))
  add(path_565231, "resourceName", newJString(resourceName))
  add(path_565231, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_565230.call(path_565231, query_565232, nil, nil, nil)

var replicationStorageClassificationMappingsDelete* = Call_ReplicationStorageClassificationMappingsDelete_565219(
    name: "replicationStorageClassificationMappingsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}/replicationStorageClassificationMappings/{storageClassificationMappingName}",
    validator: validate_ReplicationStorageClassificationMappingsDelete_565220,
    base: "", url: url_ReplicationStorageClassificationMappingsDelete_565221,
    schemes: {Scheme.Https})
type
  Call_ReplicationvCentersListByReplicationFabrics_565233 = ref object of OpenApiRestCall_563566
proc url_ReplicationvCentersListByReplicationFabrics_565235(protocol: Scheme;
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

proc validate_ReplicationvCentersListByReplicationFabrics_565234(path: JsonNode;
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
  var valid_565236 = path.getOrDefault("fabricName")
  valid_565236 = validateParameter(valid_565236, JString, required = true,
                                 default = nil)
  if valid_565236 != nil:
    section.add "fabricName", valid_565236
  var valid_565237 = path.getOrDefault("subscriptionId")
  valid_565237 = validateParameter(valid_565237, JString, required = true,
                                 default = nil)
  if valid_565237 != nil:
    section.add "subscriptionId", valid_565237
  var valid_565238 = path.getOrDefault("resourceGroupName")
  valid_565238 = validateParameter(valid_565238, JString, required = true,
                                 default = nil)
  if valid_565238 != nil:
    section.add "resourceGroupName", valid_565238
  var valid_565239 = path.getOrDefault("resourceName")
  valid_565239 = validateParameter(valid_565239, JString, required = true,
                                 default = nil)
  if valid_565239 != nil:
    section.add "resourceName", valid_565239
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565240 = query.getOrDefault("api-version")
  valid_565240 = validateParameter(valid_565240, JString, required = true,
                                 default = nil)
  if valid_565240 != nil:
    section.add "api-version", valid_565240
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565241: Call_ReplicationvCentersListByReplicationFabrics_565233;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the vCenter servers registered in a fabric.
  ## 
  let valid = call_565241.validator(path, query, header, formData, body)
  let scheme = call_565241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565241.url(scheme.get, call_565241.host, call_565241.base,
                         call_565241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565241, url, valid)

proc call*(call_565242: Call_ReplicationvCentersListByReplicationFabrics_565233;
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
  var path_565243 = newJObject()
  var query_565244 = newJObject()
  add(query_565244, "api-version", newJString(apiVersion))
  add(path_565243, "fabricName", newJString(fabricName))
  add(path_565243, "subscriptionId", newJString(subscriptionId))
  add(path_565243, "resourceGroupName", newJString(resourceGroupName))
  add(path_565243, "resourceName", newJString(resourceName))
  result = call_565242.call(path_565243, query_565244, nil, nil, nil)

var replicationvCentersListByReplicationFabrics* = Call_ReplicationvCentersListByReplicationFabrics_565233(
    name: "replicationvCentersListByReplicationFabrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters",
    validator: validate_ReplicationvCentersListByReplicationFabrics_565234,
    base: "", url: url_ReplicationvCentersListByReplicationFabrics_565235,
    schemes: {Scheme.Https})
type
  Call_ReplicationvCentersCreate_565258 = ref object of OpenApiRestCall_563566
proc url_ReplicationvCentersCreate_565260(protocol: Scheme; host: string;
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

proc validate_ReplicationvCentersCreate_565259(path: JsonNode; query: JsonNode;
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
  var valid_565261 = path.getOrDefault("fabricName")
  valid_565261 = validateParameter(valid_565261, JString, required = true,
                                 default = nil)
  if valid_565261 != nil:
    section.add "fabricName", valid_565261
  var valid_565262 = path.getOrDefault("subscriptionId")
  valid_565262 = validateParameter(valid_565262, JString, required = true,
                                 default = nil)
  if valid_565262 != nil:
    section.add "subscriptionId", valid_565262
  var valid_565263 = path.getOrDefault("vCenterName")
  valid_565263 = validateParameter(valid_565263, JString, required = true,
                                 default = nil)
  if valid_565263 != nil:
    section.add "vCenterName", valid_565263
  var valid_565264 = path.getOrDefault("resourceGroupName")
  valid_565264 = validateParameter(valid_565264, JString, required = true,
                                 default = nil)
  if valid_565264 != nil:
    section.add "resourceGroupName", valid_565264
  var valid_565265 = path.getOrDefault("resourceName")
  valid_565265 = validateParameter(valid_565265, JString, required = true,
                                 default = nil)
  if valid_565265 != nil:
    section.add "resourceName", valid_565265
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565266 = query.getOrDefault("api-version")
  valid_565266 = validateParameter(valid_565266, JString, required = true,
                                 default = nil)
  if valid_565266 != nil:
    section.add "api-version", valid_565266
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

proc call*(call_565268: Call_ReplicationvCentersCreate_565258; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create a vCenter object..
  ## 
  let valid = call_565268.validator(path, query, header, formData, body)
  let scheme = call_565268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565268.url(scheme.get, call_565268.host, call_565268.base,
                         call_565268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565268, url, valid)

proc call*(call_565269: Call_ReplicationvCentersCreate_565258; apiVersion: string;
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
  var path_565270 = newJObject()
  var query_565271 = newJObject()
  var body_565272 = newJObject()
  add(query_565271, "api-version", newJString(apiVersion))
  add(path_565270, "fabricName", newJString(fabricName))
  add(path_565270, "subscriptionId", newJString(subscriptionId))
  add(path_565270, "vCenterName", newJString(vCenterName))
  add(path_565270, "resourceGroupName", newJString(resourceGroupName))
  add(path_565270, "resourceName", newJString(resourceName))
  if addVCenterRequest != nil:
    body_565272 = addVCenterRequest
  result = call_565269.call(path_565270, query_565271, nil, nil, body_565272)

var replicationvCentersCreate* = Call_ReplicationvCentersCreate_565258(
    name: "replicationvCentersCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters/{vCenterName}",
    validator: validate_ReplicationvCentersCreate_565259, base: "",
    url: url_ReplicationvCentersCreate_565260, schemes: {Scheme.Https})
type
  Call_ReplicationvCentersGet_565245 = ref object of OpenApiRestCall_563566
proc url_ReplicationvCentersGet_565247(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationvCentersGet_565246(path: JsonNode; query: JsonNode;
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
  var valid_565248 = path.getOrDefault("fabricName")
  valid_565248 = validateParameter(valid_565248, JString, required = true,
                                 default = nil)
  if valid_565248 != nil:
    section.add "fabricName", valid_565248
  var valid_565249 = path.getOrDefault("subscriptionId")
  valid_565249 = validateParameter(valid_565249, JString, required = true,
                                 default = nil)
  if valid_565249 != nil:
    section.add "subscriptionId", valid_565249
  var valid_565250 = path.getOrDefault("vCenterName")
  valid_565250 = validateParameter(valid_565250, JString, required = true,
                                 default = nil)
  if valid_565250 != nil:
    section.add "vCenterName", valid_565250
  var valid_565251 = path.getOrDefault("resourceGroupName")
  valid_565251 = validateParameter(valid_565251, JString, required = true,
                                 default = nil)
  if valid_565251 != nil:
    section.add "resourceGroupName", valid_565251
  var valid_565252 = path.getOrDefault("resourceName")
  valid_565252 = validateParameter(valid_565252, JString, required = true,
                                 default = nil)
  if valid_565252 != nil:
    section.add "resourceName", valid_565252
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565253 = query.getOrDefault("api-version")
  valid_565253 = validateParameter(valid_565253, JString, required = true,
                                 default = nil)
  if valid_565253 != nil:
    section.add "api-version", valid_565253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565254: Call_ReplicationvCentersGet_565245; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a registered vCenter server(Add vCenter server.)
  ## 
  let valid = call_565254.validator(path, query, header, formData, body)
  let scheme = call_565254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565254.url(scheme.get, call_565254.host, call_565254.base,
                         call_565254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565254, url, valid)

proc call*(call_565255: Call_ReplicationvCentersGet_565245; apiVersion: string;
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
  var path_565256 = newJObject()
  var query_565257 = newJObject()
  add(query_565257, "api-version", newJString(apiVersion))
  add(path_565256, "fabricName", newJString(fabricName))
  add(path_565256, "subscriptionId", newJString(subscriptionId))
  add(path_565256, "vCenterName", newJString(vCenterName))
  add(path_565256, "resourceGroupName", newJString(resourceGroupName))
  add(path_565256, "resourceName", newJString(resourceName))
  result = call_565255.call(path_565256, query_565257, nil, nil, nil)

var replicationvCentersGet* = Call_ReplicationvCentersGet_565245(
    name: "replicationvCentersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters/{vCenterName}",
    validator: validate_ReplicationvCentersGet_565246, base: "",
    url: url_ReplicationvCentersGet_565247, schemes: {Scheme.Https})
type
  Call_ReplicationvCentersUpdate_565286 = ref object of OpenApiRestCall_563566
proc url_ReplicationvCentersUpdate_565288(protocol: Scheme; host: string;
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

proc validate_ReplicationvCentersUpdate_565287(path: JsonNode; query: JsonNode;
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
  var valid_565289 = path.getOrDefault("fabricName")
  valid_565289 = validateParameter(valid_565289, JString, required = true,
                                 default = nil)
  if valid_565289 != nil:
    section.add "fabricName", valid_565289
  var valid_565290 = path.getOrDefault("subscriptionId")
  valid_565290 = validateParameter(valid_565290, JString, required = true,
                                 default = nil)
  if valid_565290 != nil:
    section.add "subscriptionId", valid_565290
  var valid_565291 = path.getOrDefault("vCenterName")
  valid_565291 = validateParameter(valid_565291, JString, required = true,
                                 default = nil)
  if valid_565291 != nil:
    section.add "vCenterName", valid_565291
  var valid_565292 = path.getOrDefault("resourceGroupName")
  valid_565292 = validateParameter(valid_565292, JString, required = true,
                                 default = nil)
  if valid_565292 != nil:
    section.add "resourceGroupName", valid_565292
  var valid_565293 = path.getOrDefault("resourceName")
  valid_565293 = validateParameter(valid_565293, JString, required = true,
                                 default = nil)
  if valid_565293 != nil:
    section.add "resourceName", valid_565293
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565294 = query.getOrDefault("api-version")
  valid_565294 = validateParameter(valid_565294, JString, required = true,
                                 default = nil)
  if valid_565294 != nil:
    section.add "api-version", valid_565294
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

proc call*(call_565296: Call_ReplicationvCentersUpdate_565286; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a registered vCenter.
  ## 
  let valid = call_565296.validator(path, query, header, formData, body)
  let scheme = call_565296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565296.url(scheme.get, call_565296.host, call_565296.base,
                         call_565296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565296, url, valid)

proc call*(call_565297: Call_ReplicationvCentersUpdate_565286; apiVersion: string;
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
  var path_565298 = newJObject()
  var query_565299 = newJObject()
  var body_565300 = newJObject()
  add(query_565299, "api-version", newJString(apiVersion))
  add(path_565298, "fabricName", newJString(fabricName))
  add(path_565298, "subscriptionId", newJString(subscriptionId))
  add(path_565298, "vCenterName", newJString(vCenterName))
  add(path_565298, "resourceGroupName", newJString(resourceGroupName))
  add(path_565298, "resourceName", newJString(resourceName))
  if updateVCenterRequest != nil:
    body_565300 = updateVCenterRequest
  result = call_565297.call(path_565298, query_565299, nil, nil, body_565300)

var replicationvCentersUpdate* = Call_ReplicationvCentersUpdate_565286(
    name: "replicationvCentersUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters/{vCenterName}",
    validator: validate_ReplicationvCentersUpdate_565287, base: "",
    url: url_ReplicationvCentersUpdate_565288, schemes: {Scheme.Https})
type
  Call_ReplicationvCentersDelete_565273 = ref object of OpenApiRestCall_563566
proc url_ReplicationvCentersDelete_565275(protocol: Scheme; host: string;
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

proc validate_ReplicationvCentersDelete_565274(path: JsonNode; query: JsonNode;
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
  var valid_565276 = path.getOrDefault("fabricName")
  valid_565276 = validateParameter(valid_565276, JString, required = true,
                                 default = nil)
  if valid_565276 != nil:
    section.add "fabricName", valid_565276
  var valid_565277 = path.getOrDefault("subscriptionId")
  valid_565277 = validateParameter(valid_565277, JString, required = true,
                                 default = nil)
  if valid_565277 != nil:
    section.add "subscriptionId", valid_565277
  var valid_565278 = path.getOrDefault("vCenterName")
  valid_565278 = validateParameter(valid_565278, JString, required = true,
                                 default = nil)
  if valid_565278 != nil:
    section.add "vCenterName", valid_565278
  var valid_565279 = path.getOrDefault("resourceGroupName")
  valid_565279 = validateParameter(valid_565279, JString, required = true,
                                 default = nil)
  if valid_565279 != nil:
    section.add "resourceGroupName", valid_565279
  var valid_565280 = path.getOrDefault("resourceName")
  valid_565280 = validateParameter(valid_565280, JString, required = true,
                                 default = nil)
  if valid_565280 != nil:
    section.add "resourceName", valid_565280
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565281 = query.getOrDefault("api-version")
  valid_565281 = validateParameter(valid_565281, JString, required = true,
                                 default = nil)
  if valid_565281 != nil:
    section.add "api-version", valid_565281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565282: Call_ReplicationvCentersDelete_565273; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to remove(unregister) a registered vCenter server from the vault.
  ## 
  let valid = call_565282.validator(path, query, header, formData, body)
  let scheme = call_565282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565282.url(scheme.get, call_565282.host, call_565282.base,
                         call_565282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565282, url, valid)

proc call*(call_565283: Call_ReplicationvCentersDelete_565273; apiVersion: string;
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
  var path_565284 = newJObject()
  var query_565285 = newJObject()
  add(query_565285, "api-version", newJString(apiVersion))
  add(path_565284, "fabricName", newJString(fabricName))
  add(path_565284, "subscriptionId", newJString(subscriptionId))
  add(path_565284, "vCenterName", newJString(vCenterName))
  add(path_565284, "resourceGroupName", newJString(resourceGroupName))
  add(path_565284, "resourceName", newJString(resourceName))
  result = call_565283.call(path_565284, query_565285, nil, nil, nil)

var replicationvCentersDelete* = Call_ReplicationvCentersDelete_565273(
    name: "replicationvCentersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters/{vCenterName}",
    validator: validate_ReplicationvCentersDelete_565274, base: "",
    url: url_ReplicationvCentersDelete_565275, schemes: {Scheme.Https})
type
  Call_ReplicationJobsList_565301 = ref object of OpenApiRestCall_563566
proc url_ReplicationJobsList_565303(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationJobsList_565302(path: JsonNode; query: JsonNode;
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
  var valid_565304 = path.getOrDefault("subscriptionId")
  valid_565304 = validateParameter(valid_565304, JString, required = true,
                                 default = nil)
  if valid_565304 != nil:
    section.add "subscriptionId", valid_565304
  var valid_565305 = path.getOrDefault("resourceGroupName")
  valid_565305 = validateParameter(valid_565305, JString, required = true,
                                 default = nil)
  if valid_565305 != nil:
    section.add "resourceGroupName", valid_565305
  var valid_565306 = path.getOrDefault("resourceName")
  valid_565306 = validateParameter(valid_565306, JString, required = true,
                                 default = nil)
  if valid_565306 != nil:
    section.add "resourceName", valid_565306
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565307 = query.getOrDefault("api-version")
  valid_565307 = validateParameter(valid_565307, JString, required = true,
                                 default = nil)
  if valid_565307 != nil:
    section.add "api-version", valid_565307
  var valid_565308 = query.getOrDefault("$filter")
  valid_565308 = validateParameter(valid_565308, JString, required = false,
                                 default = nil)
  if valid_565308 != nil:
    section.add "$filter", valid_565308
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565309: Call_ReplicationJobsList_565301; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of Azure Site Recovery Jobs for the vault.
  ## 
  let valid = call_565309.validator(path, query, header, formData, body)
  let scheme = call_565309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565309.url(scheme.get, call_565309.host, call_565309.base,
                         call_565309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565309, url, valid)

proc call*(call_565310: Call_ReplicationJobsList_565301; apiVersion: string;
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
  var path_565311 = newJObject()
  var query_565312 = newJObject()
  add(query_565312, "api-version", newJString(apiVersion))
  add(path_565311, "subscriptionId", newJString(subscriptionId))
  add(path_565311, "resourceGroupName", newJString(resourceGroupName))
  add(query_565312, "$filter", newJString(Filter))
  add(path_565311, "resourceName", newJString(resourceName))
  result = call_565310.call(path_565311, query_565312, nil, nil, nil)

var replicationJobsList* = Call_ReplicationJobsList_565301(
    name: "replicationJobsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs",
    validator: validate_ReplicationJobsList_565302, base: "",
    url: url_ReplicationJobsList_565303, schemes: {Scheme.Https})
type
  Call_ReplicationJobsExport_565313 = ref object of OpenApiRestCall_563566
proc url_ReplicationJobsExport_565315(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationJobsExport_565314(path: JsonNode; query: JsonNode;
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
  ## parameters in `body` object:
  ##   jobQueryParameter: JObject (required)
  ##                    : job query filter.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565321: Call_ReplicationJobsExport_565313; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to export the details of the Azure Site Recovery jobs of the vault.
  ## 
  let valid = call_565321.validator(path, query, header, formData, body)
  let scheme = call_565321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565321.url(scheme.get, call_565321.host, call_565321.base,
                         call_565321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565321, url, valid)

proc call*(call_565322: Call_ReplicationJobsExport_565313; apiVersion: string;
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
  var path_565323 = newJObject()
  var query_565324 = newJObject()
  var body_565325 = newJObject()
  add(query_565324, "api-version", newJString(apiVersion))
  add(path_565323, "subscriptionId", newJString(subscriptionId))
  if jobQueryParameter != nil:
    body_565325 = jobQueryParameter
  add(path_565323, "resourceGroupName", newJString(resourceGroupName))
  add(path_565323, "resourceName", newJString(resourceName))
  result = call_565322.call(path_565323, query_565324, nil, nil, body_565325)

var replicationJobsExport* = Call_ReplicationJobsExport_565313(
    name: "replicationJobsExport", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/export",
    validator: validate_ReplicationJobsExport_565314, base: "",
    url: url_ReplicationJobsExport_565315, schemes: {Scheme.Https})
type
  Call_ReplicationJobsGet_565326 = ref object of OpenApiRestCall_563566
proc url_ReplicationJobsGet_565328(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationJobsGet_565327(path: JsonNode; query: JsonNode;
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
  var valid_565329 = path.getOrDefault("subscriptionId")
  valid_565329 = validateParameter(valid_565329, JString, required = true,
                                 default = nil)
  if valid_565329 != nil:
    section.add "subscriptionId", valid_565329
  var valid_565330 = path.getOrDefault("resourceGroupName")
  valid_565330 = validateParameter(valid_565330, JString, required = true,
                                 default = nil)
  if valid_565330 != nil:
    section.add "resourceGroupName", valid_565330
  var valid_565331 = path.getOrDefault("resourceName")
  valid_565331 = validateParameter(valid_565331, JString, required = true,
                                 default = nil)
  if valid_565331 != nil:
    section.add "resourceName", valid_565331
  var valid_565332 = path.getOrDefault("jobName")
  valid_565332 = validateParameter(valid_565332, JString, required = true,
                                 default = nil)
  if valid_565332 != nil:
    section.add "jobName", valid_565332
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565333 = query.getOrDefault("api-version")
  valid_565333 = validateParameter(valid_565333, JString, required = true,
                                 default = nil)
  if valid_565333 != nil:
    section.add "api-version", valid_565333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565334: Call_ReplicationJobsGet_565326; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the details of an Azure Site Recovery job.
  ## 
  let valid = call_565334.validator(path, query, header, formData, body)
  let scheme = call_565334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565334.url(scheme.get, call_565334.host, call_565334.base,
                         call_565334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565334, url, valid)

proc call*(call_565335: Call_ReplicationJobsGet_565326; apiVersion: string;
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
  var path_565336 = newJObject()
  var query_565337 = newJObject()
  add(query_565337, "api-version", newJString(apiVersion))
  add(path_565336, "subscriptionId", newJString(subscriptionId))
  add(path_565336, "resourceGroupName", newJString(resourceGroupName))
  add(path_565336, "resourceName", newJString(resourceName))
  add(path_565336, "jobName", newJString(jobName))
  result = call_565335.call(path_565336, query_565337, nil, nil, nil)

var replicationJobsGet* = Call_ReplicationJobsGet_565326(
    name: "replicationJobsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/{jobName}",
    validator: validate_ReplicationJobsGet_565327, base: "",
    url: url_ReplicationJobsGet_565328, schemes: {Scheme.Https})
type
  Call_ReplicationJobsCancel_565338 = ref object of OpenApiRestCall_563566
proc url_ReplicationJobsCancel_565340(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationJobsCancel_565339(path: JsonNode; query: JsonNode;
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
  var valid_565341 = path.getOrDefault("subscriptionId")
  valid_565341 = validateParameter(valid_565341, JString, required = true,
                                 default = nil)
  if valid_565341 != nil:
    section.add "subscriptionId", valid_565341
  var valid_565342 = path.getOrDefault("resourceGroupName")
  valid_565342 = validateParameter(valid_565342, JString, required = true,
                                 default = nil)
  if valid_565342 != nil:
    section.add "resourceGroupName", valid_565342
  var valid_565343 = path.getOrDefault("resourceName")
  valid_565343 = validateParameter(valid_565343, JString, required = true,
                                 default = nil)
  if valid_565343 != nil:
    section.add "resourceName", valid_565343
  var valid_565344 = path.getOrDefault("jobName")
  valid_565344 = validateParameter(valid_565344, JString, required = true,
                                 default = nil)
  if valid_565344 != nil:
    section.add "jobName", valid_565344
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

proc call*(call_565346: Call_ReplicationJobsCancel_565338; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to cancel an Azure Site Recovery job.
  ## 
  let valid = call_565346.validator(path, query, header, formData, body)
  let scheme = call_565346.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565346.url(scheme.get, call_565346.host, call_565346.base,
                         call_565346.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565346, url, valid)

proc call*(call_565347: Call_ReplicationJobsCancel_565338; apiVersion: string;
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
  var path_565348 = newJObject()
  var query_565349 = newJObject()
  add(query_565349, "api-version", newJString(apiVersion))
  add(path_565348, "subscriptionId", newJString(subscriptionId))
  add(path_565348, "resourceGroupName", newJString(resourceGroupName))
  add(path_565348, "resourceName", newJString(resourceName))
  add(path_565348, "jobName", newJString(jobName))
  result = call_565347.call(path_565348, query_565349, nil, nil, nil)

var replicationJobsCancel* = Call_ReplicationJobsCancel_565338(
    name: "replicationJobsCancel", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/{jobName}/cancel",
    validator: validate_ReplicationJobsCancel_565339, base: "",
    url: url_ReplicationJobsCancel_565340, schemes: {Scheme.Https})
type
  Call_ReplicationJobsRestart_565350 = ref object of OpenApiRestCall_563566
proc url_ReplicationJobsRestart_565352(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationJobsRestart_565351(path: JsonNode; query: JsonNode;
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
  var valid_565353 = path.getOrDefault("subscriptionId")
  valid_565353 = validateParameter(valid_565353, JString, required = true,
                                 default = nil)
  if valid_565353 != nil:
    section.add "subscriptionId", valid_565353
  var valid_565354 = path.getOrDefault("resourceGroupName")
  valid_565354 = validateParameter(valid_565354, JString, required = true,
                                 default = nil)
  if valid_565354 != nil:
    section.add "resourceGroupName", valid_565354
  var valid_565355 = path.getOrDefault("resourceName")
  valid_565355 = validateParameter(valid_565355, JString, required = true,
                                 default = nil)
  if valid_565355 != nil:
    section.add "resourceName", valid_565355
  var valid_565356 = path.getOrDefault("jobName")
  valid_565356 = validateParameter(valid_565356, JString, required = true,
                                 default = nil)
  if valid_565356 != nil:
    section.add "jobName", valid_565356
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
  if body != nil:
    result.add "body", body

proc call*(call_565358: Call_ReplicationJobsRestart_565350; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to restart an Azure Site Recovery job.
  ## 
  let valid = call_565358.validator(path, query, header, formData, body)
  let scheme = call_565358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565358.url(scheme.get, call_565358.host, call_565358.base,
                         call_565358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565358, url, valid)

proc call*(call_565359: Call_ReplicationJobsRestart_565350; apiVersion: string;
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
  var path_565360 = newJObject()
  var query_565361 = newJObject()
  add(query_565361, "api-version", newJString(apiVersion))
  add(path_565360, "subscriptionId", newJString(subscriptionId))
  add(path_565360, "resourceGroupName", newJString(resourceGroupName))
  add(path_565360, "resourceName", newJString(resourceName))
  add(path_565360, "jobName", newJString(jobName))
  result = call_565359.call(path_565360, query_565361, nil, nil, nil)

var replicationJobsRestart* = Call_ReplicationJobsRestart_565350(
    name: "replicationJobsRestart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/{jobName}/restart",
    validator: validate_ReplicationJobsRestart_565351, base: "",
    url: url_ReplicationJobsRestart_565352, schemes: {Scheme.Https})
type
  Call_ReplicationJobsResume_565362 = ref object of OpenApiRestCall_563566
proc url_ReplicationJobsResume_565364(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationJobsResume_565363(path: JsonNode; query: JsonNode;
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
  var valid_565365 = path.getOrDefault("subscriptionId")
  valid_565365 = validateParameter(valid_565365, JString, required = true,
                                 default = nil)
  if valid_565365 != nil:
    section.add "subscriptionId", valid_565365
  var valid_565366 = path.getOrDefault("resourceGroupName")
  valid_565366 = validateParameter(valid_565366, JString, required = true,
                                 default = nil)
  if valid_565366 != nil:
    section.add "resourceGroupName", valid_565366
  var valid_565367 = path.getOrDefault("resourceName")
  valid_565367 = validateParameter(valid_565367, JString, required = true,
                                 default = nil)
  if valid_565367 != nil:
    section.add "resourceName", valid_565367
  var valid_565368 = path.getOrDefault("jobName")
  valid_565368 = validateParameter(valid_565368, JString, required = true,
                                 default = nil)
  if valid_565368 != nil:
    section.add "jobName", valid_565368
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
  ## parameters in `body` object:
  ##   resumeJobParams: JObject (required)
  ##                  : Resume rob comments.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565371: Call_ReplicationJobsResume_565362; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to resume an Azure Site Recovery job
  ## 
  let valid = call_565371.validator(path, query, header, formData, body)
  let scheme = call_565371.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565371.url(scheme.get, call_565371.host, call_565371.base,
                         call_565371.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565371, url, valid)

proc call*(call_565372: Call_ReplicationJobsResume_565362;
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
  var path_565373 = newJObject()
  var query_565374 = newJObject()
  var body_565375 = newJObject()
  if resumeJobParams != nil:
    body_565375 = resumeJobParams
  add(query_565374, "api-version", newJString(apiVersion))
  add(path_565373, "subscriptionId", newJString(subscriptionId))
  add(path_565373, "resourceGroupName", newJString(resourceGroupName))
  add(path_565373, "resourceName", newJString(resourceName))
  add(path_565373, "jobName", newJString(jobName))
  result = call_565372.call(path_565373, query_565374, nil, nil, body_565375)

var replicationJobsResume* = Call_ReplicationJobsResume_565362(
    name: "replicationJobsResume", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/{jobName}/resume",
    validator: validate_ReplicationJobsResume_565363, base: "",
    url: url_ReplicationJobsResume_565364, schemes: {Scheme.Https})
type
  Call_ReplicationMigrationItemsList_565376 = ref object of OpenApiRestCall_563566
proc url_ReplicationMigrationItemsList_565378(protocol: Scheme; host: string;
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

proc validate_ReplicationMigrationItemsList_565377(path: JsonNode; query: JsonNode;
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
  var valid_565379 = path.getOrDefault("subscriptionId")
  valid_565379 = validateParameter(valid_565379, JString, required = true,
                                 default = nil)
  if valid_565379 != nil:
    section.add "subscriptionId", valid_565379
  var valid_565380 = path.getOrDefault("resourceGroupName")
  valid_565380 = validateParameter(valid_565380, JString, required = true,
                                 default = nil)
  if valid_565380 != nil:
    section.add "resourceGroupName", valid_565380
  var valid_565381 = path.getOrDefault("resourceName")
  valid_565381 = validateParameter(valid_565381, JString, required = true,
                                 default = nil)
  if valid_565381 != nil:
    section.add "resourceName", valid_565381
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
  var valid_565382 = query.getOrDefault("api-version")
  valid_565382 = validateParameter(valid_565382, JString, required = true,
                                 default = nil)
  if valid_565382 != nil:
    section.add "api-version", valid_565382
  var valid_565383 = query.getOrDefault("skipToken")
  valid_565383 = validateParameter(valid_565383, JString, required = false,
                                 default = nil)
  if valid_565383 != nil:
    section.add "skipToken", valid_565383
  var valid_565384 = query.getOrDefault("$filter")
  valid_565384 = validateParameter(valid_565384, JString, required = false,
                                 default = nil)
  if valid_565384 != nil:
    section.add "$filter", valid_565384
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565385: Call_ReplicationMigrationItemsList_565376; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565385.validator(path, query, header, formData, body)
  let scheme = call_565385.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565385.url(scheme.get, call_565385.host, call_565385.base,
                         call_565385.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565385, url, valid)

proc call*(call_565386: Call_ReplicationMigrationItemsList_565376;
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
  var path_565387 = newJObject()
  var query_565388 = newJObject()
  add(query_565388, "api-version", newJString(apiVersion))
  add(query_565388, "skipToken", newJString(skipToken))
  add(path_565387, "subscriptionId", newJString(subscriptionId))
  add(path_565387, "resourceGroupName", newJString(resourceGroupName))
  add(query_565388, "$filter", newJString(Filter))
  add(path_565387, "resourceName", newJString(resourceName))
  result = call_565386.call(path_565387, query_565388, nil, nil, nil)

var replicationMigrationItemsList* = Call_ReplicationMigrationItemsList_565376(
    name: "replicationMigrationItemsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationMigrationItems",
    validator: validate_ReplicationMigrationItemsList_565377, base: "",
    url: url_ReplicationMigrationItemsList_565378, schemes: {Scheme.Https})
type
  Call_ReplicationNetworkMappingsList_565389 = ref object of OpenApiRestCall_563566
proc url_ReplicationNetworkMappingsList_565391(protocol: Scheme; host: string;
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

proc validate_ReplicationNetworkMappingsList_565390(path: JsonNode;
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
  var valid_565392 = path.getOrDefault("subscriptionId")
  valid_565392 = validateParameter(valid_565392, JString, required = true,
                                 default = nil)
  if valid_565392 != nil:
    section.add "subscriptionId", valid_565392
  var valid_565393 = path.getOrDefault("resourceGroupName")
  valid_565393 = validateParameter(valid_565393, JString, required = true,
                                 default = nil)
  if valid_565393 != nil:
    section.add "resourceGroupName", valid_565393
  var valid_565394 = path.getOrDefault("resourceName")
  valid_565394 = validateParameter(valid_565394, JString, required = true,
                                 default = nil)
  if valid_565394 != nil:
    section.add "resourceName", valid_565394
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565395 = query.getOrDefault("api-version")
  valid_565395 = validateParameter(valid_565395, JString, required = true,
                                 default = nil)
  if valid_565395 != nil:
    section.add "api-version", valid_565395
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565396: Call_ReplicationNetworkMappingsList_565389; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all ASR network mappings in the vault.
  ## 
  let valid = call_565396.validator(path, query, header, formData, body)
  let scheme = call_565396.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565396.url(scheme.get, call_565396.host, call_565396.base,
                         call_565396.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565396, url, valid)

proc call*(call_565397: Call_ReplicationNetworkMappingsList_565389;
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
  var path_565398 = newJObject()
  var query_565399 = newJObject()
  add(query_565399, "api-version", newJString(apiVersion))
  add(path_565398, "subscriptionId", newJString(subscriptionId))
  add(path_565398, "resourceGroupName", newJString(resourceGroupName))
  add(path_565398, "resourceName", newJString(resourceName))
  result = call_565397.call(path_565398, query_565399, nil, nil, nil)

var replicationNetworkMappingsList* = Call_ReplicationNetworkMappingsList_565389(
    name: "replicationNetworkMappingsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationNetworkMappings",
    validator: validate_ReplicationNetworkMappingsList_565390, base: "",
    url: url_ReplicationNetworkMappingsList_565391, schemes: {Scheme.Https})
type
  Call_ReplicationNetworksList_565400 = ref object of OpenApiRestCall_563566
proc url_ReplicationNetworksList_565402(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationNetworksList_565401(path: JsonNode; query: JsonNode;
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
  var valid_565403 = path.getOrDefault("subscriptionId")
  valid_565403 = validateParameter(valid_565403, JString, required = true,
                                 default = nil)
  if valid_565403 != nil:
    section.add "subscriptionId", valid_565403
  var valid_565404 = path.getOrDefault("resourceGroupName")
  valid_565404 = validateParameter(valid_565404, JString, required = true,
                                 default = nil)
  if valid_565404 != nil:
    section.add "resourceGroupName", valid_565404
  var valid_565405 = path.getOrDefault("resourceName")
  valid_565405 = validateParameter(valid_565405, JString, required = true,
                                 default = nil)
  if valid_565405 != nil:
    section.add "resourceName", valid_565405
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565406 = query.getOrDefault("api-version")
  valid_565406 = validateParameter(valid_565406, JString, required = true,
                                 default = nil)
  if valid_565406 != nil:
    section.add "api-version", valid_565406
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565407: Call_ReplicationNetworksList_565400; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the networks available in a vault
  ## 
  let valid = call_565407.validator(path, query, header, formData, body)
  let scheme = call_565407.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565407.url(scheme.get, call_565407.host, call_565407.base,
                         call_565407.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565407, url, valid)

proc call*(call_565408: Call_ReplicationNetworksList_565400; apiVersion: string;
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
  var path_565409 = newJObject()
  var query_565410 = newJObject()
  add(query_565410, "api-version", newJString(apiVersion))
  add(path_565409, "subscriptionId", newJString(subscriptionId))
  add(path_565409, "resourceGroupName", newJString(resourceGroupName))
  add(path_565409, "resourceName", newJString(resourceName))
  result = call_565408.call(path_565409, query_565410, nil, nil, nil)

var replicationNetworksList* = Call_ReplicationNetworksList_565400(
    name: "replicationNetworksList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationNetworks",
    validator: validate_ReplicationNetworksList_565401, base: "",
    url: url_ReplicationNetworksList_565402, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesList_565411 = ref object of OpenApiRestCall_563566
proc url_ReplicationPoliciesList_565413(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationPoliciesList_565412(path: JsonNode; query: JsonNode;
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
  var valid_565414 = path.getOrDefault("subscriptionId")
  valid_565414 = validateParameter(valid_565414, JString, required = true,
                                 default = nil)
  if valid_565414 != nil:
    section.add "subscriptionId", valid_565414
  var valid_565415 = path.getOrDefault("resourceGroupName")
  valid_565415 = validateParameter(valid_565415, JString, required = true,
                                 default = nil)
  if valid_565415 != nil:
    section.add "resourceGroupName", valid_565415
  var valid_565416 = path.getOrDefault("resourceName")
  valid_565416 = validateParameter(valid_565416, JString, required = true,
                                 default = nil)
  if valid_565416 != nil:
    section.add "resourceName", valid_565416
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565417 = query.getOrDefault("api-version")
  valid_565417 = validateParameter(valid_565417, JString, required = true,
                                 default = nil)
  if valid_565417 != nil:
    section.add "api-version", valid_565417
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565418: Call_ReplicationPoliciesList_565411; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the replication policies for a vault.
  ## 
  let valid = call_565418.validator(path, query, header, formData, body)
  let scheme = call_565418.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565418.url(scheme.get, call_565418.host, call_565418.base,
                         call_565418.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565418, url, valid)

proc call*(call_565419: Call_ReplicationPoliciesList_565411; apiVersion: string;
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
  var path_565420 = newJObject()
  var query_565421 = newJObject()
  add(query_565421, "api-version", newJString(apiVersion))
  add(path_565420, "subscriptionId", newJString(subscriptionId))
  add(path_565420, "resourceGroupName", newJString(resourceGroupName))
  add(path_565420, "resourceName", newJString(resourceName))
  result = call_565419.call(path_565420, query_565421, nil, nil, nil)

var replicationPoliciesList* = Call_ReplicationPoliciesList_565411(
    name: "replicationPoliciesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies",
    validator: validate_ReplicationPoliciesList_565412, base: "",
    url: url_ReplicationPoliciesList_565413, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesCreate_565434 = ref object of OpenApiRestCall_563566
proc url_ReplicationPoliciesCreate_565436(protocol: Scheme; host: string;
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

proc validate_ReplicationPoliciesCreate_565435(path: JsonNode; query: JsonNode;
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
  var valid_565437 = path.getOrDefault("policyName")
  valid_565437 = validateParameter(valid_565437, JString, required = true,
                                 default = nil)
  if valid_565437 != nil:
    section.add "policyName", valid_565437
  var valid_565438 = path.getOrDefault("subscriptionId")
  valid_565438 = validateParameter(valid_565438, JString, required = true,
                                 default = nil)
  if valid_565438 != nil:
    section.add "subscriptionId", valid_565438
  var valid_565439 = path.getOrDefault("resourceGroupName")
  valid_565439 = validateParameter(valid_565439, JString, required = true,
                                 default = nil)
  if valid_565439 != nil:
    section.add "resourceGroupName", valid_565439
  var valid_565440 = path.getOrDefault("resourceName")
  valid_565440 = validateParameter(valid_565440, JString, required = true,
                                 default = nil)
  if valid_565440 != nil:
    section.add "resourceName", valid_565440
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565441 = query.getOrDefault("api-version")
  valid_565441 = validateParameter(valid_565441, JString, required = true,
                                 default = nil)
  if valid_565441 != nil:
    section.add "api-version", valid_565441
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

proc call*(call_565443: Call_ReplicationPoliciesCreate_565434; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create a replication policy
  ## 
  let valid = call_565443.validator(path, query, header, formData, body)
  let scheme = call_565443.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565443.url(scheme.get, call_565443.host, call_565443.base,
                         call_565443.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565443, url, valid)

proc call*(call_565444: Call_ReplicationPoliciesCreate_565434; policyName: string;
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
  var path_565445 = newJObject()
  var query_565446 = newJObject()
  var body_565447 = newJObject()
  add(path_565445, "policyName", newJString(policyName))
  add(query_565446, "api-version", newJString(apiVersion))
  if input != nil:
    body_565447 = input
  add(path_565445, "subscriptionId", newJString(subscriptionId))
  add(path_565445, "resourceGroupName", newJString(resourceGroupName))
  add(path_565445, "resourceName", newJString(resourceName))
  result = call_565444.call(path_565445, query_565446, nil, nil, body_565447)

var replicationPoliciesCreate* = Call_ReplicationPoliciesCreate_565434(
    name: "replicationPoliciesCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies/{policyName}",
    validator: validate_ReplicationPoliciesCreate_565435, base: "",
    url: url_ReplicationPoliciesCreate_565436, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesGet_565422 = ref object of OpenApiRestCall_563566
proc url_ReplicationPoliciesGet_565424(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationPoliciesGet_565423(path: JsonNode; query: JsonNode;
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
  var valid_565425 = path.getOrDefault("policyName")
  valid_565425 = validateParameter(valid_565425, JString, required = true,
                                 default = nil)
  if valid_565425 != nil:
    section.add "policyName", valid_565425
  var valid_565426 = path.getOrDefault("subscriptionId")
  valid_565426 = validateParameter(valid_565426, JString, required = true,
                                 default = nil)
  if valid_565426 != nil:
    section.add "subscriptionId", valid_565426
  var valid_565427 = path.getOrDefault("resourceGroupName")
  valid_565427 = validateParameter(valid_565427, JString, required = true,
                                 default = nil)
  if valid_565427 != nil:
    section.add "resourceGroupName", valid_565427
  var valid_565428 = path.getOrDefault("resourceName")
  valid_565428 = validateParameter(valid_565428, JString, required = true,
                                 default = nil)
  if valid_565428 != nil:
    section.add "resourceName", valid_565428
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565429 = query.getOrDefault("api-version")
  valid_565429 = validateParameter(valid_565429, JString, required = true,
                                 default = nil)
  if valid_565429 != nil:
    section.add "api-version", valid_565429
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565430: Call_ReplicationPoliciesGet_565422; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a replication policy.
  ## 
  let valid = call_565430.validator(path, query, header, formData, body)
  let scheme = call_565430.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565430.url(scheme.get, call_565430.host, call_565430.base,
                         call_565430.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565430, url, valid)

proc call*(call_565431: Call_ReplicationPoliciesGet_565422; policyName: string;
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
  var path_565432 = newJObject()
  var query_565433 = newJObject()
  add(path_565432, "policyName", newJString(policyName))
  add(query_565433, "api-version", newJString(apiVersion))
  add(path_565432, "subscriptionId", newJString(subscriptionId))
  add(path_565432, "resourceGroupName", newJString(resourceGroupName))
  add(path_565432, "resourceName", newJString(resourceName))
  result = call_565431.call(path_565432, query_565433, nil, nil, nil)

var replicationPoliciesGet* = Call_ReplicationPoliciesGet_565422(
    name: "replicationPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies/{policyName}",
    validator: validate_ReplicationPoliciesGet_565423, base: "",
    url: url_ReplicationPoliciesGet_565424, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesUpdate_565460 = ref object of OpenApiRestCall_563566
proc url_ReplicationPoliciesUpdate_565462(protocol: Scheme; host: string;
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

proc validate_ReplicationPoliciesUpdate_565461(path: JsonNode; query: JsonNode;
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
  var valid_565463 = path.getOrDefault("policyName")
  valid_565463 = validateParameter(valid_565463, JString, required = true,
                                 default = nil)
  if valid_565463 != nil:
    section.add "policyName", valid_565463
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
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Update Policy Input
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565469: Call_ReplicationPoliciesUpdate_565460; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a replication policy.
  ## 
  let valid = call_565469.validator(path, query, header, formData, body)
  let scheme = call_565469.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565469.url(scheme.get, call_565469.host, call_565469.base,
                         call_565469.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565469, url, valid)

proc call*(call_565470: Call_ReplicationPoliciesUpdate_565460; policyName: string;
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
  var path_565471 = newJObject()
  var query_565472 = newJObject()
  var body_565473 = newJObject()
  add(path_565471, "policyName", newJString(policyName))
  add(query_565472, "api-version", newJString(apiVersion))
  if input != nil:
    body_565473 = input
  add(path_565471, "subscriptionId", newJString(subscriptionId))
  add(path_565471, "resourceGroupName", newJString(resourceGroupName))
  add(path_565471, "resourceName", newJString(resourceName))
  result = call_565470.call(path_565471, query_565472, nil, nil, body_565473)

var replicationPoliciesUpdate* = Call_ReplicationPoliciesUpdate_565460(
    name: "replicationPoliciesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies/{policyName}",
    validator: validate_ReplicationPoliciesUpdate_565461, base: "",
    url: url_ReplicationPoliciesUpdate_565462, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesDelete_565448 = ref object of OpenApiRestCall_563566
proc url_ReplicationPoliciesDelete_565450(protocol: Scheme; host: string;
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

proc validate_ReplicationPoliciesDelete_565449(path: JsonNode; query: JsonNode;
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
  var valid_565451 = path.getOrDefault("policyName")
  valid_565451 = validateParameter(valid_565451, JString, required = true,
                                 default = nil)
  if valid_565451 != nil:
    section.add "policyName", valid_565451
  var valid_565452 = path.getOrDefault("subscriptionId")
  valid_565452 = validateParameter(valid_565452, JString, required = true,
                                 default = nil)
  if valid_565452 != nil:
    section.add "subscriptionId", valid_565452
  var valid_565453 = path.getOrDefault("resourceGroupName")
  valid_565453 = validateParameter(valid_565453, JString, required = true,
                                 default = nil)
  if valid_565453 != nil:
    section.add "resourceGroupName", valid_565453
  var valid_565454 = path.getOrDefault("resourceName")
  valid_565454 = validateParameter(valid_565454, JString, required = true,
                                 default = nil)
  if valid_565454 != nil:
    section.add "resourceName", valid_565454
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565455 = query.getOrDefault("api-version")
  valid_565455 = validateParameter(valid_565455, JString, required = true,
                                 default = nil)
  if valid_565455 != nil:
    section.add "api-version", valid_565455
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565456: Call_ReplicationPoliciesDelete_565448; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete a replication policy.
  ## 
  let valid = call_565456.validator(path, query, header, formData, body)
  let scheme = call_565456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565456.url(scheme.get, call_565456.host, call_565456.base,
                         call_565456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565456, url, valid)

proc call*(call_565457: Call_ReplicationPoliciesDelete_565448; policyName: string;
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
  var path_565458 = newJObject()
  var query_565459 = newJObject()
  add(path_565458, "policyName", newJString(policyName))
  add(query_565459, "api-version", newJString(apiVersion))
  add(path_565458, "subscriptionId", newJString(subscriptionId))
  add(path_565458, "resourceGroupName", newJString(resourceGroupName))
  add(path_565458, "resourceName", newJString(resourceName))
  result = call_565457.call(path_565458, query_565459, nil, nil, nil)

var replicationPoliciesDelete* = Call_ReplicationPoliciesDelete_565448(
    name: "replicationPoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies/{policyName}",
    validator: validate_ReplicationPoliciesDelete_565449, base: "",
    url: url_ReplicationPoliciesDelete_565450, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsList_565474 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectedItemsList_565476(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectedItemsList_565475(path: JsonNode; query: JsonNode;
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
  var valid_565477 = path.getOrDefault("subscriptionId")
  valid_565477 = validateParameter(valid_565477, JString, required = true,
                                 default = nil)
  if valid_565477 != nil:
    section.add "subscriptionId", valid_565477
  var valid_565478 = path.getOrDefault("resourceGroupName")
  valid_565478 = validateParameter(valid_565478, JString, required = true,
                                 default = nil)
  if valid_565478 != nil:
    section.add "resourceGroupName", valid_565478
  var valid_565479 = path.getOrDefault("resourceName")
  valid_565479 = validateParameter(valid_565479, JString, required = true,
                                 default = nil)
  if valid_565479 != nil:
    section.add "resourceName", valid_565479
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
  var valid_565480 = query.getOrDefault("api-version")
  valid_565480 = validateParameter(valid_565480, JString, required = true,
                                 default = nil)
  if valid_565480 != nil:
    section.add "api-version", valid_565480
  var valid_565481 = query.getOrDefault("skipToken")
  valid_565481 = validateParameter(valid_565481, JString, required = false,
                                 default = nil)
  if valid_565481 != nil:
    section.add "skipToken", valid_565481
  var valid_565482 = query.getOrDefault("$filter")
  valid_565482 = validateParameter(valid_565482, JString, required = false,
                                 default = nil)
  if valid_565482 != nil:
    section.add "$filter", valid_565482
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565483: Call_ReplicationProtectedItemsList_565474; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of ASR replication protected items in the vault.
  ## 
  let valid = call_565483.validator(path, query, header, formData, body)
  let scheme = call_565483.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565483.url(scheme.get, call_565483.host, call_565483.base,
                         call_565483.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565483, url, valid)

proc call*(call_565484: Call_ReplicationProtectedItemsList_565474;
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
  var path_565485 = newJObject()
  var query_565486 = newJObject()
  add(query_565486, "api-version", newJString(apiVersion))
  add(query_565486, "skipToken", newJString(skipToken))
  add(path_565485, "subscriptionId", newJString(subscriptionId))
  add(path_565485, "resourceGroupName", newJString(resourceGroupName))
  add(query_565486, "$filter", newJString(Filter))
  add(path_565485, "resourceName", newJString(resourceName))
  result = call_565484.call(path_565485, query_565486, nil, nil, nil)

var replicationProtectedItemsList* = Call_ReplicationProtectedItemsList_565474(
    name: "replicationProtectedItemsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationProtectedItems",
    validator: validate_ReplicationProtectedItemsList_565475, base: "",
    url: url_ReplicationProtectedItemsList_565476, schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsList_565487 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectionContainerMappingsList_565489(protocol: Scheme;
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

proc validate_ReplicationProtectionContainerMappingsList_565488(path: JsonNode;
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
  var valid_565490 = path.getOrDefault("subscriptionId")
  valid_565490 = validateParameter(valid_565490, JString, required = true,
                                 default = nil)
  if valid_565490 != nil:
    section.add "subscriptionId", valid_565490
  var valid_565491 = path.getOrDefault("resourceGroupName")
  valid_565491 = validateParameter(valid_565491, JString, required = true,
                                 default = nil)
  if valid_565491 != nil:
    section.add "resourceGroupName", valid_565491
  var valid_565492 = path.getOrDefault("resourceName")
  valid_565492 = validateParameter(valid_565492, JString, required = true,
                                 default = nil)
  if valid_565492 != nil:
    section.add "resourceName", valid_565492
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565493 = query.getOrDefault("api-version")
  valid_565493 = validateParameter(valid_565493, JString, required = true,
                                 default = nil)
  if valid_565493 != nil:
    section.add "api-version", valid_565493
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565494: Call_ReplicationProtectionContainerMappingsList_565487;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the protection container mappings in the vault.
  ## 
  let valid = call_565494.validator(path, query, header, formData, body)
  let scheme = call_565494.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565494.url(scheme.get, call_565494.host, call_565494.base,
                         call_565494.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565494, url, valid)

proc call*(call_565495: Call_ReplicationProtectionContainerMappingsList_565487;
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
  var path_565496 = newJObject()
  var query_565497 = newJObject()
  add(query_565497, "api-version", newJString(apiVersion))
  add(path_565496, "subscriptionId", newJString(subscriptionId))
  add(path_565496, "resourceGroupName", newJString(resourceGroupName))
  add(path_565496, "resourceName", newJString(resourceName))
  result = call_565495.call(path_565496, query_565497, nil, nil, nil)

var replicationProtectionContainerMappingsList* = Call_ReplicationProtectionContainerMappingsList_565487(
    name: "replicationProtectionContainerMappingsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationProtectionContainerMappings",
    validator: validate_ReplicationProtectionContainerMappingsList_565488,
    base: "", url: url_ReplicationProtectionContainerMappingsList_565489,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersList_565498 = ref object of OpenApiRestCall_563566
proc url_ReplicationProtectionContainersList_565500(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectionContainersList_565499(path: JsonNode;
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
  var valid_565501 = path.getOrDefault("subscriptionId")
  valid_565501 = validateParameter(valid_565501, JString, required = true,
                                 default = nil)
  if valid_565501 != nil:
    section.add "subscriptionId", valid_565501
  var valid_565502 = path.getOrDefault("resourceGroupName")
  valid_565502 = validateParameter(valid_565502, JString, required = true,
                                 default = nil)
  if valid_565502 != nil:
    section.add "resourceGroupName", valid_565502
  var valid_565503 = path.getOrDefault("resourceName")
  valid_565503 = validateParameter(valid_565503, JString, required = true,
                                 default = nil)
  if valid_565503 != nil:
    section.add "resourceName", valid_565503
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565504 = query.getOrDefault("api-version")
  valid_565504 = validateParameter(valid_565504, JString, required = true,
                                 default = nil)
  if valid_565504 != nil:
    section.add "api-version", valid_565504
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565505: Call_ReplicationProtectionContainersList_565498;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the protection containers in a vault.
  ## 
  let valid = call_565505.validator(path, query, header, formData, body)
  let scheme = call_565505.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565505.url(scheme.get, call_565505.host, call_565505.base,
                         call_565505.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565505, url, valid)

proc call*(call_565506: Call_ReplicationProtectionContainersList_565498;
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
  var path_565507 = newJObject()
  var query_565508 = newJObject()
  add(query_565508, "api-version", newJString(apiVersion))
  add(path_565507, "subscriptionId", newJString(subscriptionId))
  add(path_565507, "resourceGroupName", newJString(resourceGroupName))
  add(path_565507, "resourceName", newJString(resourceName))
  result = call_565506.call(path_565507, query_565508, nil, nil, nil)

var replicationProtectionContainersList* = Call_ReplicationProtectionContainersList_565498(
    name: "replicationProtectionContainersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationProtectionContainers",
    validator: validate_ReplicationProtectionContainersList_565499, base: "",
    url: url_ReplicationProtectionContainersList_565500, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansList_565509 = ref object of OpenApiRestCall_563566
proc url_ReplicationRecoveryPlansList_565511(protocol: Scheme; host: string;
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

proc validate_ReplicationRecoveryPlansList_565510(path: JsonNode; query: JsonNode;
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
  var valid_565512 = path.getOrDefault("subscriptionId")
  valid_565512 = validateParameter(valid_565512, JString, required = true,
                                 default = nil)
  if valid_565512 != nil:
    section.add "subscriptionId", valid_565512
  var valid_565513 = path.getOrDefault("resourceGroupName")
  valid_565513 = validateParameter(valid_565513, JString, required = true,
                                 default = nil)
  if valid_565513 != nil:
    section.add "resourceGroupName", valid_565513
  var valid_565514 = path.getOrDefault("resourceName")
  valid_565514 = validateParameter(valid_565514, JString, required = true,
                                 default = nil)
  if valid_565514 != nil:
    section.add "resourceName", valid_565514
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565515 = query.getOrDefault("api-version")
  valid_565515 = validateParameter(valid_565515, JString, required = true,
                                 default = nil)
  if valid_565515 != nil:
    section.add "api-version", valid_565515
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565516: Call_ReplicationRecoveryPlansList_565509; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the recovery plans in the vault.
  ## 
  let valid = call_565516.validator(path, query, header, formData, body)
  let scheme = call_565516.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565516.url(scheme.get, call_565516.host, call_565516.base,
                         call_565516.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565516, url, valid)

proc call*(call_565517: Call_ReplicationRecoveryPlansList_565509;
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
  var path_565518 = newJObject()
  var query_565519 = newJObject()
  add(query_565519, "api-version", newJString(apiVersion))
  add(path_565518, "subscriptionId", newJString(subscriptionId))
  add(path_565518, "resourceGroupName", newJString(resourceGroupName))
  add(path_565518, "resourceName", newJString(resourceName))
  result = call_565517.call(path_565518, query_565519, nil, nil, nil)

var replicationRecoveryPlansList* = Call_ReplicationRecoveryPlansList_565509(
    name: "replicationRecoveryPlansList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans",
    validator: validate_ReplicationRecoveryPlansList_565510, base: "",
    url: url_ReplicationRecoveryPlansList_565511, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansCreate_565532 = ref object of OpenApiRestCall_563566
proc url_ReplicationRecoveryPlansCreate_565534(protocol: Scheme; host: string;
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

proc validate_ReplicationRecoveryPlansCreate_565533(path: JsonNode;
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
  var valid_565535 = path.getOrDefault("recoveryPlanName")
  valid_565535 = validateParameter(valid_565535, JString, required = true,
                                 default = nil)
  if valid_565535 != nil:
    section.add "recoveryPlanName", valid_565535
  var valid_565536 = path.getOrDefault("subscriptionId")
  valid_565536 = validateParameter(valid_565536, JString, required = true,
                                 default = nil)
  if valid_565536 != nil:
    section.add "subscriptionId", valid_565536
  var valid_565537 = path.getOrDefault("resourceGroupName")
  valid_565537 = validateParameter(valid_565537, JString, required = true,
                                 default = nil)
  if valid_565537 != nil:
    section.add "resourceGroupName", valid_565537
  var valid_565538 = path.getOrDefault("resourceName")
  valid_565538 = validateParameter(valid_565538, JString, required = true,
                                 default = nil)
  if valid_565538 != nil:
    section.add "resourceName", valid_565538
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565539 = query.getOrDefault("api-version")
  valid_565539 = validateParameter(valid_565539, JString, required = true,
                                 default = nil)
  if valid_565539 != nil:
    section.add "api-version", valid_565539
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

proc call*(call_565541: Call_ReplicationRecoveryPlansCreate_565532; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create a recovery plan.
  ## 
  let valid = call_565541.validator(path, query, header, formData, body)
  let scheme = call_565541.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565541.url(scheme.get, call_565541.host, call_565541.base,
                         call_565541.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565541, url, valid)

proc call*(call_565542: Call_ReplicationRecoveryPlansCreate_565532;
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
  var path_565543 = newJObject()
  var query_565544 = newJObject()
  var body_565545 = newJObject()
  add(path_565543, "recoveryPlanName", newJString(recoveryPlanName))
  add(query_565544, "api-version", newJString(apiVersion))
  if input != nil:
    body_565545 = input
  add(path_565543, "subscriptionId", newJString(subscriptionId))
  add(path_565543, "resourceGroupName", newJString(resourceGroupName))
  add(path_565543, "resourceName", newJString(resourceName))
  result = call_565542.call(path_565543, query_565544, nil, nil, body_565545)

var replicationRecoveryPlansCreate* = Call_ReplicationRecoveryPlansCreate_565532(
    name: "replicationRecoveryPlansCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}",
    validator: validate_ReplicationRecoveryPlansCreate_565533, base: "",
    url: url_ReplicationRecoveryPlansCreate_565534, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansGet_565520 = ref object of OpenApiRestCall_563566
proc url_ReplicationRecoveryPlansGet_565522(protocol: Scheme; host: string;
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

proc validate_ReplicationRecoveryPlansGet_565521(path: JsonNode; query: JsonNode;
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
  var valid_565523 = path.getOrDefault("recoveryPlanName")
  valid_565523 = validateParameter(valid_565523, JString, required = true,
                                 default = nil)
  if valid_565523 != nil:
    section.add "recoveryPlanName", valid_565523
  var valid_565524 = path.getOrDefault("subscriptionId")
  valid_565524 = validateParameter(valid_565524, JString, required = true,
                                 default = nil)
  if valid_565524 != nil:
    section.add "subscriptionId", valid_565524
  var valid_565525 = path.getOrDefault("resourceGroupName")
  valid_565525 = validateParameter(valid_565525, JString, required = true,
                                 default = nil)
  if valid_565525 != nil:
    section.add "resourceGroupName", valid_565525
  var valid_565526 = path.getOrDefault("resourceName")
  valid_565526 = validateParameter(valid_565526, JString, required = true,
                                 default = nil)
  if valid_565526 != nil:
    section.add "resourceName", valid_565526
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565527 = query.getOrDefault("api-version")
  valid_565527 = validateParameter(valid_565527, JString, required = true,
                                 default = nil)
  if valid_565527 != nil:
    section.add "api-version", valid_565527
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565528: Call_ReplicationRecoveryPlansGet_565520; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the recovery plan.
  ## 
  let valid = call_565528.validator(path, query, header, formData, body)
  let scheme = call_565528.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565528.url(scheme.get, call_565528.host, call_565528.base,
                         call_565528.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565528, url, valid)

proc call*(call_565529: Call_ReplicationRecoveryPlansGet_565520;
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
  var path_565530 = newJObject()
  var query_565531 = newJObject()
  add(path_565530, "recoveryPlanName", newJString(recoveryPlanName))
  add(query_565531, "api-version", newJString(apiVersion))
  add(path_565530, "subscriptionId", newJString(subscriptionId))
  add(path_565530, "resourceGroupName", newJString(resourceGroupName))
  add(path_565530, "resourceName", newJString(resourceName))
  result = call_565529.call(path_565530, query_565531, nil, nil, nil)

var replicationRecoveryPlansGet* = Call_ReplicationRecoveryPlansGet_565520(
    name: "replicationRecoveryPlansGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}",
    validator: validate_ReplicationRecoveryPlansGet_565521, base: "",
    url: url_ReplicationRecoveryPlansGet_565522, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansUpdate_565558 = ref object of OpenApiRestCall_563566
proc url_ReplicationRecoveryPlansUpdate_565560(protocol: Scheme; host: string;
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

proc validate_ReplicationRecoveryPlansUpdate_565559(path: JsonNode;
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
  var valid_565561 = path.getOrDefault("recoveryPlanName")
  valid_565561 = validateParameter(valid_565561, JString, required = true,
                                 default = nil)
  if valid_565561 != nil:
    section.add "recoveryPlanName", valid_565561
  var valid_565562 = path.getOrDefault("subscriptionId")
  valid_565562 = validateParameter(valid_565562, JString, required = true,
                                 default = nil)
  if valid_565562 != nil:
    section.add "subscriptionId", valid_565562
  var valid_565563 = path.getOrDefault("resourceGroupName")
  valid_565563 = validateParameter(valid_565563, JString, required = true,
                                 default = nil)
  if valid_565563 != nil:
    section.add "resourceGroupName", valid_565563
  var valid_565564 = path.getOrDefault("resourceName")
  valid_565564 = validateParameter(valid_565564, JString, required = true,
                                 default = nil)
  if valid_565564 != nil:
    section.add "resourceName", valid_565564
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565565 = query.getOrDefault("api-version")
  valid_565565 = validateParameter(valid_565565, JString, required = true,
                                 default = nil)
  if valid_565565 != nil:
    section.add "api-version", valid_565565
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

proc call*(call_565567: Call_ReplicationRecoveryPlansUpdate_565558; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a recovery plan.
  ## 
  let valid = call_565567.validator(path, query, header, formData, body)
  let scheme = call_565567.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565567.url(scheme.get, call_565567.host, call_565567.base,
                         call_565567.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565567, url, valid)

proc call*(call_565568: Call_ReplicationRecoveryPlansUpdate_565558;
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
  var path_565569 = newJObject()
  var query_565570 = newJObject()
  var body_565571 = newJObject()
  add(path_565569, "recoveryPlanName", newJString(recoveryPlanName))
  add(query_565570, "api-version", newJString(apiVersion))
  if input != nil:
    body_565571 = input
  add(path_565569, "subscriptionId", newJString(subscriptionId))
  add(path_565569, "resourceGroupName", newJString(resourceGroupName))
  add(path_565569, "resourceName", newJString(resourceName))
  result = call_565568.call(path_565569, query_565570, nil, nil, body_565571)

var replicationRecoveryPlansUpdate* = Call_ReplicationRecoveryPlansUpdate_565558(
    name: "replicationRecoveryPlansUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}",
    validator: validate_ReplicationRecoveryPlansUpdate_565559, base: "",
    url: url_ReplicationRecoveryPlansUpdate_565560, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansDelete_565546 = ref object of OpenApiRestCall_563566
proc url_ReplicationRecoveryPlansDelete_565548(protocol: Scheme; host: string;
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

proc validate_ReplicationRecoveryPlansDelete_565547(path: JsonNode;
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
  var valid_565549 = path.getOrDefault("recoveryPlanName")
  valid_565549 = validateParameter(valid_565549, JString, required = true,
                                 default = nil)
  if valid_565549 != nil:
    section.add "recoveryPlanName", valid_565549
  var valid_565550 = path.getOrDefault("subscriptionId")
  valid_565550 = validateParameter(valid_565550, JString, required = true,
                                 default = nil)
  if valid_565550 != nil:
    section.add "subscriptionId", valid_565550
  var valid_565551 = path.getOrDefault("resourceGroupName")
  valid_565551 = validateParameter(valid_565551, JString, required = true,
                                 default = nil)
  if valid_565551 != nil:
    section.add "resourceGroupName", valid_565551
  var valid_565552 = path.getOrDefault("resourceName")
  valid_565552 = validateParameter(valid_565552, JString, required = true,
                                 default = nil)
  if valid_565552 != nil:
    section.add "resourceName", valid_565552
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565553 = query.getOrDefault("api-version")
  valid_565553 = validateParameter(valid_565553, JString, required = true,
                                 default = nil)
  if valid_565553 != nil:
    section.add "api-version", valid_565553
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565554: Call_ReplicationRecoveryPlansDelete_565546; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a recovery plan.
  ## 
  let valid = call_565554.validator(path, query, header, formData, body)
  let scheme = call_565554.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565554.url(scheme.get, call_565554.host, call_565554.base,
                         call_565554.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565554, url, valid)

proc call*(call_565555: Call_ReplicationRecoveryPlansDelete_565546;
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
  var path_565556 = newJObject()
  var query_565557 = newJObject()
  add(path_565556, "recoveryPlanName", newJString(recoveryPlanName))
  add(query_565557, "api-version", newJString(apiVersion))
  add(path_565556, "subscriptionId", newJString(subscriptionId))
  add(path_565556, "resourceGroupName", newJString(resourceGroupName))
  add(path_565556, "resourceName", newJString(resourceName))
  result = call_565555.call(path_565556, query_565557, nil, nil, nil)

var replicationRecoveryPlansDelete* = Call_ReplicationRecoveryPlansDelete_565546(
    name: "replicationRecoveryPlansDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}",
    validator: validate_ReplicationRecoveryPlansDelete_565547, base: "",
    url: url_ReplicationRecoveryPlansDelete_565548, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansFailoverCommit_565572 = ref object of OpenApiRestCall_563566
proc url_ReplicationRecoveryPlansFailoverCommit_565574(protocol: Scheme;
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

proc validate_ReplicationRecoveryPlansFailoverCommit_565573(path: JsonNode;
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
  var valid_565575 = path.getOrDefault("recoveryPlanName")
  valid_565575 = validateParameter(valid_565575, JString, required = true,
                                 default = nil)
  if valid_565575 != nil:
    section.add "recoveryPlanName", valid_565575
  var valid_565576 = path.getOrDefault("subscriptionId")
  valid_565576 = validateParameter(valid_565576, JString, required = true,
                                 default = nil)
  if valid_565576 != nil:
    section.add "subscriptionId", valid_565576
  var valid_565577 = path.getOrDefault("resourceGroupName")
  valid_565577 = validateParameter(valid_565577, JString, required = true,
                                 default = nil)
  if valid_565577 != nil:
    section.add "resourceGroupName", valid_565577
  var valid_565578 = path.getOrDefault("resourceName")
  valid_565578 = validateParameter(valid_565578, JString, required = true,
                                 default = nil)
  if valid_565578 != nil:
    section.add "resourceName", valid_565578
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565579 = query.getOrDefault("api-version")
  valid_565579 = validateParameter(valid_565579, JString, required = true,
                                 default = nil)
  if valid_565579 != nil:
    section.add "api-version", valid_565579
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565580: Call_ReplicationRecoveryPlansFailoverCommit_565572;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to commit the fail over of a recovery plan.
  ## 
  let valid = call_565580.validator(path, query, header, formData, body)
  let scheme = call_565580.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565580.url(scheme.get, call_565580.host, call_565580.base,
                         call_565580.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565580, url, valid)

proc call*(call_565581: Call_ReplicationRecoveryPlansFailoverCommit_565572;
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
  var path_565582 = newJObject()
  var query_565583 = newJObject()
  add(path_565582, "recoveryPlanName", newJString(recoveryPlanName))
  add(query_565583, "api-version", newJString(apiVersion))
  add(path_565582, "subscriptionId", newJString(subscriptionId))
  add(path_565582, "resourceGroupName", newJString(resourceGroupName))
  add(path_565582, "resourceName", newJString(resourceName))
  result = call_565581.call(path_565582, query_565583, nil, nil, nil)

var replicationRecoveryPlansFailoverCommit* = Call_ReplicationRecoveryPlansFailoverCommit_565572(
    name: "replicationRecoveryPlansFailoverCommit", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/failoverCommit",
    validator: validate_ReplicationRecoveryPlansFailoverCommit_565573, base: "",
    url: url_ReplicationRecoveryPlansFailoverCommit_565574,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansPlannedFailover_565584 = ref object of OpenApiRestCall_563566
proc url_ReplicationRecoveryPlansPlannedFailover_565586(protocol: Scheme;
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

proc validate_ReplicationRecoveryPlansPlannedFailover_565585(path: JsonNode;
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
  var valid_565587 = path.getOrDefault("recoveryPlanName")
  valid_565587 = validateParameter(valid_565587, JString, required = true,
                                 default = nil)
  if valid_565587 != nil:
    section.add "recoveryPlanName", valid_565587
  var valid_565588 = path.getOrDefault("subscriptionId")
  valid_565588 = validateParameter(valid_565588, JString, required = true,
                                 default = nil)
  if valid_565588 != nil:
    section.add "subscriptionId", valid_565588
  var valid_565589 = path.getOrDefault("resourceGroupName")
  valid_565589 = validateParameter(valid_565589, JString, required = true,
                                 default = nil)
  if valid_565589 != nil:
    section.add "resourceGroupName", valid_565589
  var valid_565590 = path.getOrDefault("resourceName")
  valid_565590 = validateParameter(valid_565590, JString, required = true,
                                 default = nil)
  if valid_565590 != nil:
    section.add "resourceName", valid_565590
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565591 = query.getOrDefault("api-version")
  valid_565591 = validateParameter(valid_565591, JString, required = true,
                                 default = nil)
  if valid_565591 != nil:
    section.add "api-version", valid_565591
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

proc call*(call_565593: Call_ReplicationRecoveryPlansPlannedFailover_565584;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to start the planned failover of a recovery plan.
  ## 
  let valid = call_565593.validator(path, query, header, formData, body)
  let scheme = call_565593.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565593.url(scheme.get, call_565593.host, call_565593.base,
                         call_565593.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565593, url, valid)

proc call*(call_565594: Call_ReplicationRecoveryPlansPlannedFailover_565584;
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
  var path_565595 = newJObject()
  var query_565596 = newJObject()
  var body_565597 = newJObject()
  add(path_565595, "recoveryPlanName", newJString(recoveryPlanName))
  add(query_565596, "api-version", newJString(apiVersion))
  if input != nil:
    body_565597 = input
  add(path_565595, "subscriptionId", newJString(subscriptionId))
  add(path_565595, "resourceGroupName", newJString(resourceGroupName))
  add(path_565595, "resourceName", newJString(resourceName))
  result = call_565594.call(path_565595, query_565596, nil, nil, body_565597)

var replicationRecoveryPlansPlannedFailover* = Call_ReplicationRecoveryPlansPlannedFailover_565584(
    name: "replicationRecoveryPlansPlannedFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/plannedFailover",
    validator: validate_ReplicationRecoveryPlansPlannedFailover_565585, base: "",
    url: url_ReplicationRecoveryPlansPlannedFailover_565586,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansReprotect_565598 = ref object of OpenApiRestCall_563566
proc url_ReplicationRecoveryPlansReprotect_565600(protocol: Scheme; host: string;
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

proc validate_ReplicationRecoveryPlansReprotect_565599(path: JsonNode;
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
  var valid_565601 = path.getOrDefault("recoveryPlanName")
  valid_565601 = validateParameter(valid_565601, JString, required = true,
                                 default = nil)
  if valid_565601 != nil:
    section.add "recoveryPlanName", valid_565601
  var valid_565602 = path.getOrDefault("subscriptionId")
  valid_565602 = validateParameter(valid_565602, JString, required = true,
                                 default = nil)
  if valid_565602 != nil:
    section.add "subscriptionId", valid_565602
  var valid_565603 = path.getOrDefault("resourceGroupName")
  valid_565603 = validateParameter(valid_565603, JString, required = true,
                                 default = nil)
  if valid_565603 != nil:
    section.add "resourceGroupName", valid_565603
  var valid_565604 = path.getOrDefault("resourceName")
  valid_565604 = validateParameter(valid_565604, JString, required = true,
                                 default = nil)
  if valid_565604 != nil:
    section.add "resourceName", valid_565604
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565605 = query.getOrDefault("api-version")
  valid_565605 = validateParameter(valid_565605, JString, required = true,
                                 default = nil)
  if valid_565605 != nil:
    section.add "api-version", valid_565605
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565606: Call_ReplicationRecoveryPlansReprotect_565598;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to reprotect(reverse replicate) a recovery plan.
  ## 
  let valid = call_565606.validator(path, query, header, formData, body)
  let scheme = call_565606.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565606.url(scheme.get, call_565606.host, call_565606.base,
                         call_565606.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565606, url, valid)

proc call*(call_565607: Call_ReplicationRecoveryPlansReprotect_565598;
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
  var path_565608 = newJObject()
  var query_565609 = newJObject()
  add(path_565608, "recoveryPlanName", newJString(recoveryPlanName))
  add(query_565609, "api-version", newJString(apiVersion))
  add(path_565608, "subscriptionId", newJString(subscriptionId))
  add(path_565608, "resourceGroupName", newJString(resourceGroupName))
  add(path_565608, "resourceName", newJString(resourceName))
  result = call_565607.call(path_565608, query_565609, nil, nil, nil)

var replicationRecoveryPlansReprotect* = Call_ReplicationRecoveryPlansReprotect_565598(
    name: "replicationRecoveryPlansReprotect", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/reProtect",
    validator: validate_ReplicationRecoveryPlansReprotect_565599, base: "",
    url: url_ReplicationRecoveryPlansReprotect_565600, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansTestFailover_565610 = ref object of OpenApiRestCall_563566
proc url_ReplicationRecoveryPlansTestFailover_565612(protocol: Scheme;
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

proc validate_ReplicationRecoveryPlansTestFailover_565611(path: JsonNode;
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
  var valid_565613 = path.getOrDefault("recoveryPlanName")
  valid_565613 = validateParameter(valid_565613, JString, required = true,
                                 default = nil)
  if valid_565613 != nil:
    section.add "recoveryPlanName", valid_565613
  var valid_565614 = path.getOrDefault("subscriptionId")
  valid_565614 = validateParameter(valid_565614, JString, required = true,
                                 default = nil)
  if valid_565614 != nil:
    section.add "subscriptionId", valid_565614
  var valid_565615 = path.getOrDefault("resourceGroupName")
  valid_565615 = validateParameter(valid_565615, JString, required = true,
                                 default = nil)
  if valid_565615 != nil:
    section.add "resourceGroupName", valid_565615
  var valid_565616 = path.getOrDefault("resourceName")
  valid_565616 = validateParameter(valid_565616, JString, required = true,
                                 default = nil)
  if valid_565616 != nil:
    section.add "resourceName", valid_565616
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565617 = query.getOrDefault("api-version")
  valid_565617 = validateParameter(valid_565617, JString, required = true,
                                 default = nil)
  if valid_565617 != nil:
    section.add "api-version", valid_565617
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

proc call*(call_565619: Call_ReplicationRecoveryPlansTestFailover_565610;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to start the test failover of a recovery plan.
  ## 
  let valid = call_565619.validator(path, query, header, formData, body)
  let scheme = call_565619.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565619.url(scheme.get, call_565619.host, call_565619.base,
                         call_565619.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565619, url, valid)

proc call*(call_565620: Call_ReplicationRecoveryPlansTestFailover_565610;
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
  var path_565621 = newJObject()
  var query_565622 = newJObject()
  var body_565623 = newJObject()
  add(path_565621, "recoveryPlanName", newJString(recoveryPlanName))
  add(query_565622, "api-version", newJString(apiVersion))
  if input != nil:
    body_565623 = input
  add(path_565621, "subscriptionId", newJString(subscriptionId))
  add(path_565621, "resourceGroupName", newJString(resourceGroupName))
  add(path_565621, "resourceName", newJString(resourceName))
  result = call_565620.call(path_565621, query_565622, nil, nil, body_565623)

var replicationRecoveryPlansTestFailover* = Call_ReplicationRecoveryPlansTestFailover_565610(
    name: "replicationRecoveryPlansTestFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/testFailover",
    validator: validate_ReplicationRecoveryPlansTestFailover_565611, base: "",
    url: url_ReplicationRecoveryPlansTestFailover_565612, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansTestFailoverCleanup_565624 = ref object of OpenApiRestCall_563566
proc url_ReplicationRecoveryPlansTestFailoverCleanup_565626(protocol: Scheme;
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

proc validate_ReplicationRecoveryPlansTestFailoverCleanup_565625(path: JsonNode;
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
  var valid_565627 = path.getOrDefault("recoveryPlanName")
  valid_565627 = validateParameter(valid_565627, JString, required = true,
                                 default = nil)
  if valid_565627 != nil:
    section.add "recoveryPlanName", valid_565627
  var valid_565628 = path.getOrDefault("subscriptionId")
  valid_565628 = validateParameter(valid_565628, JString, required = true,
                                 default = nil)
  if valid_565628 != nil:
    section.add "subscriptionId", valid_565628
  var valid_565629 = path.getOrDefault("resourceGroupName")
  valid_565629 = validateParameter(valid_565629, JString, required = true,
                                 default = nil)
  if valid_565629 != nil:
    section.add "resourceGroupName", valid_565629
  var valid_565630 = path.getOrDefault("resourceName")
  valid_565630 = validateParameter(valid_565630, JString, required = true,
                                 default = nil)
  if valid_565630 != nil:
    section.add "resourceName", valid_565630
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565631 = query.getOrDefault("api-version")
  valid_565631 = validateParameter(valid_565631, JString, required = true,
                                 default = nil)
  if valid_565631 != nil:
    section.add "api-version", valid_565631
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

proc call*(call_565633: Call_ReplicationRecoveryPlansTestFailoverCleanup_565624;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to cleanup test failover of a recovery plan.
  ## 
  let valid = call_565633.validator(path, query, header, formData, body)
  let scheme = call_565633.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565633.url(scheme.get, call_565633.host, call_565633.base,
                         call_565633.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565633, url, valid)

proc call*(call_565634: Call_ReplicationRecoveryPlansTestFailoverCleanup_565624;
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
  var path_565635 = newJObject()
  var query_565636 = newJObject()
  var body_565637 = newJObject()
  add(path_565635, "recoveryPlanName", newJString(recoveryPlanName))
  add(query_565636, "api-version", newJString(apiVersion))
  if input != nil:
    body_565637 = input
  add(path_565635, "subscriptionId", newJString(subscriptionId))
  add(path_565635, "resourceGroupName", newJString(resourceGroupName))
  add(path_565635, "resourceName", newJString(resourceName))
  result = call_565634.call(path_565635, query_565636, nil, nil, body_565637)

var replicationRecoveryPlansTestFailoverCleanup* = Call_ReplicationRecoveryPlansTestFailoverCleanup_565624(
    name: "replicationRecoveryPlansTestFailoverCleanup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/testFailoverCleanup",
    validator: validate_ReplicationRecoveryPlansTestFailoverCleanup_565625,
    base: "", url: url_ReplicationRecoveryPlansTestFailoverCleanup_565626,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansUnplannedFailover_565638 = ref object of OpenApiRestCall_563566
proc url_ReplicationRecoveryPlansUnplannedFailover_565640(protocol: Scheme;
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

proc validate_ReplicationRecoveryPlansUnplannedFailover_565639(path: JsonNode;
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
  var valid_565641 = path.getOrDefault("recoveryPlanName")
  valid_565641 = validateParameter(valid_565641, JString, required = true,
                                 default = nil)
  if valid_565641 != nil:
    section.add "recoveryPlanName", valid_565641
  var valid_565642 = path.getOrDefault("subscriptionId")
  valid_565642 = validateParameter(valid_565642, JString, required = true,
                                 default = nil)
  if valid_565642 != nil:
    section.add "subscriptionId", valid_565642
  var valid_565643 = path.getOrDefault("resourceGroupName")
  valid_565643 = validateParameter(valid_565643, JString, required = true,
                                 default = nil)
  if valid_565643 != nil:
    section.add "resourceGroupName", valid_565643
  var valid_565644 = path.getOrDefault("resourceName")
  valid_565644 = validateParameter(valid_565644, JString, required = true,
                                 default = nil)
  if valid_565644 != nil:
    section.add "resourceName", valid_565644
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565645 = query.getOrDefault("api-version")
  valid_565645 = validateParameter(valid_565645, JString, required = true,
                                 default = nil)
  if valid_565645 != nil:
    section.add "api-version", valid_565645
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

proc call*(call_565647: Call_ReplicationRecoveryPlansUnplannedFailover_565638;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to start the failover of a recovery plan.
  ## 
  let valid = call_565647.validator(path, query, header, formData, body)
  let scheme = call_565647.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565647.url(scheme.get, call_565647.host, call_565647.base,
                         call_565647.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565647, url, valid)

proc call*(call_565648: Call_ReplicationRecoveryPlansUnplannedFailover_565638;
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
  var path_565649 = newJObject()
  var query_565650 = newJObject()
  var body_565651 = newJObject()
  add(path_565649, "recoveryPlanName", newJString(recoveryPlanName))
  add(query_565650, "api-version", newJString(apiVersion))
  if input != nil:
    body_565651 = input
  add(path_565649, "subscriptionId", newJString(subscriptionId))
  add(path_565649, "resourceGroupName", newJString(resourceGroupName))
  add(path_565649, "resourceName", newJString(resourceName))
  result = call_565648.call(path_565649, query_565650, nil, nil, body_565651)

var replicationRecoveryPlansUnplannedFailover* = Call_ReplicationRecoveryPlansUnplannedFailover_565638(
    name: "replicationRecoveryPlansUnplannedFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/unplannedFailover",
    validator: validate_ReplicationRecoveryPlansUnplannedFailover_565639,
    base: "", url: url_ReplicationRecoveryPlansUnplannedFailover_565640,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersList_565652 = ref object of OpenApiRestCall_563566
proc url_ReplicationRecoveryServicesProvidersList_565654(protocol: Scheme;
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

proc validate_ReplicationRecoveryServicesProvidersList_565653(path: JsonNode;
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
  var valid_565655 = path.getOrDefault("subscriptionId")
  valid_565655 = validateParameter(valid_565655, JString, required = true,
                                 default = nil)
  if valid_565655 != nil:
    section.add "subscriptionId", valid_565655
  var valid_565656 = path.getOrDefault("resourceGroupName")
  valid_565656 = validateParameter(valid_565656, JString, required = true,
                                 default = nil)
  if valid_565656 != nil:
    section.add "resourceGroupName", valid_565656
  var valid_565657 = path.getOrDefault("resourceName")
  valid_565657 = validateParameter(valid_565657, JString, required = true,
                                 default = nil)
  if valid_565657 != nil:
    section.add "resourceName", valid_565657
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565658 = query.getOrDefault("api-version")
  valid_565658 = validateParameter(valid_565658, JString, required = true,
                                 default = nil)
  if valid_565658 != nil:
    section.add "api-version", valid_565658
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565659: Call_ReplicationRecoveryServicesProvidersList_565652;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the registered recovery services providers in the vault
  ## 
  let valid = call_565659.validator(path, query, header, formData, body)
  let scheme = call_565659.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565659.url(scheme.get, call_565659.host, call_565659.base,
                         call_565659.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565659, url, valid)

proc call*(call_565660: Call_ReplicationRecoveryServicesProvidersList_565652;
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
  var path_565661 = newJObject()
  var query_565662 = newJObject()
  add(query_565662, "api-version", newJString(apiVersion))
  add(path_565661, "subscriptionId", newJString(subscriptionId))
  add(path_565661, "resourceGroupName", newJString(resourceGroupName))
  add(path_565661, "resourceName", newJString(resourceName))
  result = call_565660.call(path_565661, query_565662, nil, nil, nil)

var replicationRecoveryServicesProvidersList* = Call_ReplicationRecoveryServicesProvidersList_565652(
    name: "replicationRecoveryServicesProvidersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryServicesProviders",
    validator: validate_ReplicationRecoveryServicesProvidersList_565653, base: "",
    url: url_ReplicationRecoveryServicesProvidersList_565654,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsList_565663 = ref object of OpenApiRestCall_563566
proc url_ReplicationStorageClassificationMappingsList_565665(protocol: Scheme;
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

proc validate_ReplicationStorageClassificationMappingsList_565664(path: JsonNode;
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
  var valid_565666 = path.getOrDefault("subscriptionId")
  valid_565666 = validateParameter(valid_565666, JString, required = true,
                                 default = nil)
  if valid_565666 != nil:
    section.add "subscriptionId", valid_565666
  var valid_565667 = path.getOrDefault("resourceGroupName")
  valid_565667 = validateParameter(valid_565667, JString, required = true,
                                 default = nil)
  if valid_565667 != nil:
    section.add "resourceGroupName", valid_565667
  var valid_565668 = path.getOrDefault("resourceName")
  valid_565668 = validateParameter(valid_565668, JString, required = true,
                                 default = nil)
  if valid_565668 != nil:
    section.add "resourceName", valid_565668
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565669 = query.getOrDefault("api-version")
  valid_565669 = validateParameter(valid_565669, JString, required = true,
                                 default = nil)
  if valid_565669 != nil:
    section.add "api-version", valid_565669
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565670: Call_ReplicationStorageClassificationMappingsList_565663;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the storage classification mappings in the vault.
  ## 
  let valid = call_565670.validator(path, query, header, formData, body)
  let scheme = call_565670.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565670.url(scheme.get, call_565670.host, call_565670.base,
                         call_565670.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565670, url, valid)

proc call*(call_565671: Call_ReplicationStorageClassificationMappingsList_565663;
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
  var path_565672 = newJObject()
  var query_565673 = newJObject()
  add(query_565673, "api-version", newJString(apiVersion))
  add(path_565672, "subscriptionId", newJString(subscriptionId))
  add(path_565672, "resourceGroupName", newJString(resourceGroupName))
  add(path_565672, "resourceName", newJString(resourceName))
  result = call_565671.call(path_565672, query_565673, nil, nil, nil)

var replicationStorageClassificationMappingsList* = Call_ReplicationStorageClassificationMappingsList_565663(
    name: "replicationStorageClassificationMappingsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationStorageClassificationMappings",
    validator: validate_ReplicationStorageClassificationMappingsList_565664,
    base: "", url: url_ReplicationStorageClassificationMappingsList_565665,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationsList_565674 = ref object of OpenApiRestCall_563566
proc url_ReplicationStorageClassificationsList_565676(protocol: Scheme;
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

proc validate_ReplicationStorageClassificationsList_565675(path: JsonNode;
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
  var valid_565677 = path.getOrDefault("subscriptionId")
  valid_565677 = validateParameter(valid_565677, JString, required = true,
                                 default = nil)
  if valid_565677 != nil:
    section.add "subscriptionId", valid_565677
  var valid_565678 = path.getOrDefault("resourceGroupName")
  valid_565678 = validateParameter(valid_565678, JString, required = true,
                                 default = nil)
  if valid_565678 != nil:
    section.add "resourceGroupName", valid_565678
  var valid_565679 = path.getOrDefault("resourceName")
  valid_565679 = validateParameter(valid_565679, JString, required = true,
                                 default = nil)
  if valid_565679 != nil:
    section.add "resourceName", valid_565679
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565680 = query.getOrDefault("api-version")
  valid_565680 = validateParameter(valid_565680, JString, required = true,
                                 default = nil)
  if valid_565680 != nil:
    section.add "api-version", valid_565680
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565681: Call_ReplicationStorageClassificationsList_565674;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the storage classifications in the vault.
  ## 
  let valid = call_565681.validator(path, query, header, formData, body)
  let scheme = call_565681.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565681.url(scheme.get, call_565681.host, call_565681.base,
                         call_565681.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565681, url, valid)

proc call*(call_565682: Call_ReplicationStorageClassificationsList_565674;
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
  var path_565683 = newJObject()
  var query_565684 = newJObject()
  add(query_565684, "api-version", newJString(apiVersion))
  add(path_565683, "subscriptionId", newJString(subscriptionId))
  add(path_565683, "resourceGroupName", newJString(resourceGroupName))
  add(path_565683, "resourceName", newJString(resourceName))
  result = call_565682.call(path_565683, query_565684, nil, nil, nil)

var replicationStorageClassificationsList* = Call_ReplicationStorageClassificationsList_565674(
    name: "replicationStorageClassificationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationStorageClassifications",
    validator: validate_ReplicationStorageClassificationsList_565675, base: "",
    url: url_ReplicationStorageClassificationsList_565676, schemes: {Scheme.Https})
type
  Call_SupportedOperatingSystemsGet_565685 = ref object of OpenApiRestCall_563566
proc url_SupportedOperatingSystemsGet_565687(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/replicationSupportedOperatingSystems")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SupportedOperatingSystemsGet_565686(path: JsonNode; query: JsonNode;
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
  var valid_565688 = path.getOrDefault("subscriptionId")
  valid_565688 = validateParameter(valid_565688, JString, required = true,
                                 default = nil)
  if valid_565688 != nil:
    section.add "subscriptionId", valid_565688
  var valid_565689 = path.getOrDefault("resourceGroupName")
  valid_565689 = validateParameter(valid_565689, JString, required = true,
                                 default = nil)
  if valid_565689 != nil:
    section.add "resourceGroupName", valid_565689
  var valid_565690 = path.getOrDefault("resourceName")
  valid_565690 = validateParameter(valid_565690, JString, required = true,
                                 default = nil)
  if valid_565690 != nil:
    section.add "resourceName", valid_565690
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565691 = query.getOrDefault("api-version")
  valid_565691 = validateParameter(valid_565691, JString, required = true,
                                 default = nil)
  if valid_565691 != nil:
    section.add "api-version", valid_565691
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565692: Call_SupportedOperatingSystemsGet_565685; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565692.validator(path, query, header, formData, body)
  let scheme = call_565692.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565692.url(scheme.get, call_565692.host, call_565692.base,
                         call_565692.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565692, url, valid)

proc call*(call_565693: Call_SupportedOperatingSystemsGet_565685;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## supportedOperatingSystemsGet
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565694 = newJObject()
  var query_565695 = newJObject()
  add(query_565695, "api-version", newJString(apiVersion))
  add(path_565694, "subscriptionId", newJString(subscriptionId))
  add(path_565694, "resourceGroupName", newJString(resourceGroupName))
  add(path_565694, "resourceName", newJString(resourceName))
  result = call_565693.call(path_565694, query_565695, nil, nil, nil)

var supportedOperatingSystemsGet* = Call_SupportedOperatingSystemsGet_565685(
    name: "supportedOperatingSystemsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationSupportedOperatingSystems",
    validator: validate_SupportedOperatingSystemsGet_565686, base: "",
    url: url_SupportedOperatingSystemsGet_565687, schemes: {Scheme.Https})
type
  Call_ReplicationVaultHealthGet_565696 = ref object of OpenApiRestCall_563566
proc url_ReplicationVaultHealthGet_565698(protocol: Scheme; host: string;
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

proc validate_ReplicationVaultHealthGet_565697(path: JsonNode; query: JsonNode;
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
  var valid_565699 = path.getOrDefault("subscriptionId")
  valid_565699 = validateParameter(valid_565699, JString, required = true,
                                 default = nil)
  if valid_565699 != nil:
    section.add "subscriptionId", valid_565699
  var valid_565700 = path.getOrDefault("resourceGroupName")
  valid_565700 = validateParameter(valid_565700, JString, required = true,
                                 default = nil)
  if valid_565700 != nil:
    section.add "resourceGroupName", valid_565700
  var valid_565701 = path.getOrDefault("resourceName")
  valid_565701 = validateParameter(valid_565701, JString, required = true,
                                 default = nil)
  if valid_565701 != nil:
    section.add "resourceName", valid_565701
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565702 = query.getOrDefault("api-version")
  valid_565702 = validateParameter(valid_565702, JString, required = true,
                                 default = nil)
  if valid_565702 != nil:
    section.add "api-version", valid_565702
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565703: Call_ReplicationVaultHealthGet_565696; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health details of the vault.
  ## 
  let valid = call_565703.validator(path, query, header, formData, body)
  let scheme = call_565703.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565703.url(scheme.get, call_565703.host, call_565703.base,
                         call_565703.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565703, url, valid)

proc call*(call_565704: Call_ReplicationVaultHealthGet_565696; apiVersion: string;
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
  var path_565705 = newJObject()
  var query_565706 = newJObject()
  add(query_565706, "api-version", newJString(apiVersion))
  add(path_565705, "subscriptionId", newJString(subscriptionId))
  add(path_565705, "resourceGroupName", newJString(resourceGroupName))
  add(path_565705, "resourceName", newJString(resourceName))
  result = call_565704.call(path_565705, query_565706, nil, nil, nil)

var replicationVaultHealthGet* = Call_ReplicationVaultHealthGet_565696(
    name: "replicationVaultHealthGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationVaultHealth",
    validator: validate_ReplicationVaultHealthGet_565697, base: "",
    url: url_ReplicationVaultHealthGet_565698, schemes: {Scheme.Https})
type
  Call_ReplicationVaultHealthRefresh_565707 = ref object of OpenApiRestCall_563566
proc url_ReplicationVaultHealthRefresh_565709(protocol: Scheme; host: string;
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

proc validate_ReplicationVaultHealthRefresh_565708(path: JsonNode; query: JsonNode;
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
  var valid_565710 = path.getOrDefault("subscriptionId")
  valid_565710 = validateParameter(valid_565710, JString, required = true,
                                 default = nil)
  if valid_565710 != nil:
    section.add "subscriptionId", valid_565710
  var valid_565711 = path.getOrDefault("resourceGroupName")
  valid_565711 = validateParameter(valid_565711, JString, required = true,
                                 default = nil)
  if valid_565711 != nil:
    section.add "resourceGroupName", valid_565711
  var valid_565712 = path.getOrDefault("resourceName")
  valid_565712 = validateParameter(valid_565712, JString, required = true,
                                 default = nil)
  if valid_565712 != nil:
    section.add "resourceName", valid_565712
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565713 = query.getOrDefault("api-version")
  valid_565713 = validateParameter(valid_565713, JString, required = true,
                                 default = nil)
  if valid_565713 != nil:
    section.add "api-version", valid_565713
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565714: Call_ReplicationVaultHealthRefresh_565707; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_565714.validator(path, query, header, formData, body)
  let scheme = call_565714.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565714.url(scheme.get, call_565714.host, call_565714.base,
                         call_565714.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565714, url, valid)

proc call*(call_565715: Call_ReplicationVaultHealthRefresh_565707;
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
  var path_565716 = newJObject()
  var query_565717 = newJObject()
  add(query_565717, "api-version", newJString(apiVersion))
  add(path_565716, "subscriptionId", newJString(subscriptionId))
  add(path_565716, "resourceGroupName", newJString(resourceGroupName))
  add(path_565716, "resourceName", newJString(resourceName))
  result = call_565715.call(path_565716, query_565717, nil, nil, nil)

var replicationVaultHealthRefresh* = Call_ReplicationVaultHealthRefresh_565707(
    name: "replicationVaultHealthRefresh", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationVaultHealth/default/refresh",
    validator: validate_ReplicationVaultHealthRefresh_565708, base: "",
    url: url_ReplicationVaultHealthRefresh_565709, schemes: {Scheme.Https})
type
  Call_ReplicationVaultSettingList_565718 = ref object of OpenApiRestCall_563566
proc url_ReplicationVaultSettingList_565720(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/replicationVaultSettings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationVaultSettingList_565719(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the list of vault setting. This includes the Migration Hub connection settings.
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
  var valid_565721 = path.getOrDefault("subscriptionId")
  valid_565721 = validateParameter(valid_565721, JString, required = true,
                                 default = nil)
  if valid_565721 != nil:
    section.add "subscriptionId", valid_565721
  var valid_565722 = path.getOrDefault("resourceGroupName")
  valid_565722 = validateParameter(valid_565722, JString, required = true,
                                 default = nil)
  if valid_565722 != nil:
    section.add "resourceGroupName", valid_565722
  var valid_565723 = path.getOrDefault("resourceName")
  valid_565723 = validateParameter(valid_565723, JString, required = true,
                                 default = nil)
  if valid_565723 != nil:
    section.add "resourceName", valid_565723
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565724 = query.getOrDefault("api-version")
  valid_565724 = validateParameter(valid_565724, JString, required = true,
                                 default = nil)
  if valid_565724 != nil:
    section.add "api-version", valid_565724
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565725: Call_ReplicationVaultSettingList_565718; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of vault setting. This includes the Migration Hub connection settings.
  ## 
  let valid = call_565725.validator(path, query, header, formData, body)
  let scheme = call_565725.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565725.url(scheme.get, call_565725.host, call_565725.base,
                         call_565725.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565725, url, valid)

proc call*(call_565726: Call_ReplicationVaultSettingList_565718;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## replicationVaultSettingList
  ## Gets the list of vault setting. This includes the Migration Hub connection settings.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565727 = newJObject()
  var query_565728 = newJObject()
  add(query_565728, "api-version", newJString(apiVersion))
  add(path_565727, "subscriptionId", newJString(subscriptionId))
  add(path_565727, "resourceGroupName", newJString(resourceGroupName))
  add(path_565727, "resourceName", newJString(resourceName))
  result = call_565726.call(path_565727, query_565728, nil, nil, nil)

var replicationVaultSettingList* = Call_ReplicationVaultSettingList_565718(
    name: "replicationVaultSettingList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationVaultSettings",
    validator: validate_ReplicationVaultSettingList_565719, base: "",
    url: url_ReplicationVaultSettingList_565720, schemes: {Scheme.Https})
type
  Call_ReplicationVaultSettingCreate_565741 = ref object of OpenApiRestCall_563566
proc url_ReplicationVaultSettingCreate_565743(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "vaultSettingName" in path,
        "`vaultSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationVaultSettings/"),
               (kind: VariableSegment, value: "vaultSettingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationVaultSettingCreate_565742(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to configure vault setting.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultSettingName: JString (required)
  ##                   : Vault setting name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vaultSettingName` field"
  var valid_565744 = path.getOrDefault("vaultSettingName")
  valid_565744 = validateParameter(valid_565744, JString, required = true,
                                 default = nil)
  if valid_565744 != nil:
    section.add "vaultSettingName", valid_565744
  var valid_565745 = path.getOrDefault("subscriptionId")
  valid_565745 = validateParameter(valid_565745, JString, required = true,
                                 default = nil)
  if valid_565745 != nil:
    section.add "subscriptionId", valid_565745
  var valid_565746 = path.getOrDefault("resourceGroupName")
  valid_565746 = validateParameter(valid_565746, JString, required = true,
                                 default = nil)
  if valid_565746 != nil:
    section.add "resourceGroupName", valid_565746
  var valid_565747 = path.getOrDefault("resourceName")
  valid_565747 = validateParameter(valid_565747, JString, required = true,
                                 default = nil)
  if valid_565747 != nil:
    section.add "resourceName", valid_565747
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565748 = query.getOrDefault("api-version")
  valid_565748 = validateParameter(valid_565748, JString, required = true,
                                 default = nil)
  if valid_565748 != nil:
    section.add "api-version", valid_565748
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Vault setting creation input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565750: Call_ReplicationVaultSettingCreate_565741; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to configure vault setting.
  ## 
  let valid = call_565750.validator(path, query, header, formData, body)
  let scheme = call_565750.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565750.url(scheme.get, call_565750.host, call_565750.base,
                         call_565750.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565750, url, valid)

proc call*(call_565751: Call_ReplicationVaultSettingCreate_565741;
          apiVersion: string; input: JsonNode; vaultSettingName: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string): Recallable =
  ## replicationVaultSettingCreate
  ## The operation to configure vault setting.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   input: JObject (required)
  ##        : Vault setting creation input.
  ##   vaultSettingName: string (required)
  ##                   : Vault setting name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565752 = newJObject()
  var query_565753 = newJObject()
  var body_565754 = newJObject()
  add(query_565753, "api-version", newJString(apiVersion))
  if input != nil:
    body_565754 = input
  add(path_565752, "vaultSettingName", newJString(vaultSettingName))
  add(path_565752, "subscriptionId", newJString(subscriptionId))
  add(path_565752, "resourceGroupName", newJString(resourceGroupName))
  add(path_565752, "resourceName", newJString(resourceName))
  result = call_565751.call(path_565752, query_565753, nil, nil, body_565754)

var replicationVaultSettingCreate* = Call_ReplicationVaultSettingCreate_565741(
    name: "replicationVaultSettingCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationVaultSettings/{vaultSettingName}",
    validator: validate_ReplicationVaultSettingCreate_565742, base: "",
    url: url_ReplicationVaultSettingCreate_565743, schemes: {Scheme.Https})
type
  Call_ReplicationVaultSettingGet_565729 = ref object of OpenApiRestCall_563566
proc url_ReplicationVaultSettingGet_565731(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "vaultSettingName" in path,
        "`vaultSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.RecoveryServices/vaults/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/replicationVaultSettings/"),
               (kind: VariableSegment, value: "vaultSettingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicationVaultSettingGet_565730(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the vault setting. This includes the Migration Hub connection settings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vaultSettingName: JString (required)
  ##                   : Vault setting name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vaultSettingName` field"
  var valid_565732 = path.getOrDefault("vaultSettingName")
  valid_565732 = validateParameter(valid_565732, JString, required = true,
                                 default = nil)
  if valid_565732 != nil:
    section.add "vaultSettingName", valid_565732
  var valid_565733 = path.getOrDefault("subscriptionId")
  valid_565733 = validateParameter(valid_565733, JString, required = true,
                                 default = nil)
  if valid_565733 != nil:
    section.add "subscriptionId", valid_565733
  var valid_565734 = path.getOrDefault("resourceGroupName")
  valid_565734 = validateParameter(valid_565734, JString, required = true,
                                 default = nil)
  if valid_565734 != nil:
    section.add "resourceGroupName", valid_565734
  var valid_565735 = path.getOrDefault("resourceName")
  valid_565735 = validateParameter(valid_565735, JString, required = true,
                                 default = nil)
  if valid_565735 != nil:
    section.add "resourceName", valid_565735
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565736 = query.getOrDefault("api-version")
  valid_565736 = validateParameter(valid_565736, JString, required = true,
                                 default = nil)
  if valid_565736 != nil:
    section.add "api-version", valid_565736
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565737: Call_ReplicationVaultSettingGet_565729; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the vault setting. This includes the Migration Hub connection settings.
  ## 
  let valid = call_565737.validator(path, query, header, formData, body)
  let scheme = call_565737.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565737.url(scheme.get, call_565737.host, call_565737.base,
                         call_565737.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565737, url, valid)

proc call*(call_565738: Call_ReplicationVaultSettingGet_565729; apiVersion: string;
          vaultSettingName: string; subscriptionId: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## replicationVaultSettingGet
  ## Gets the vault setting. This includes the Migration Hub connection settings.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vaultSettingName: string (required)
  ##                   : Vault setting name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_565739 = newJObject()
  var query_565740 = newJObject()
  add(query_565740, "api-version", newJString(apiVersion))
  add(path_565739, "vaultSettingName", newJString(vaultSettingName))
  add(path_565739, "subscriptionId", newJString(subscriptionId))
  add(path_565739, "resourceGroupName", newJString(resourceGroupName))
  add(path_565739, "resourceName", newJString(resourceName))
  result = call_565738.call(path_565739, query_565740, nil, nil, nil)

var replicationVaultSettingGet* = Call_ReplicationVaultSettingGet_565729(
    name: "replicationVaultSettingGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationVaultSettings/{vaultSettingName}",
    validator: validate_ReplicationVaultSettingGet_565730, base: "",
    url: url_ReplicationVaultSettingGet_565731, schemes: {Scheme.Https})
type
  Call_ReplicationvCentersList_565755 = ref object of OpenApiRestCall_563566
proc url_ReplicationvCentersList_565757(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationvCentersList_565756(path: JsonNode; query: JsonNode;
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
  var valid_565758 = path.getOrDefault("subscriptionId")
  valid_565758 = validateParameter(valid_565758, JString, required = true,
                                 default = nil)
  if valid_565758 != nil:
    section.add "subscriptionId", valid_565758
  var valid_565759 = path.getOrDefault("resourceGroupName")
  valid_565759 = validateParameter(valid_565759, JString, required = true,
                                 default = nil)
  if valid_565759 != nil:
    section.add "resourceGroupName", valid_565759
  var valid_565760 = path.getOrDefault("resourceName")
  valid_565760 = validateParameter(valid_565760, JString, required = true,
                                 default = nil)
  if valid_565760 != nil:
    section.add "resourceName", valid_565760
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565761 = query.getOrDefault("api-version")
  valid_565761 = validateParameter(valid_565761, JString, required = true,
                                 default = nil)
  if valid_565761 != nil:
    section.add "api-version", valid_565761
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565762: Call_ReplicationvCentersList_565755; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the vCenter servers registered in the vault.
  ## 
  let valid = call_565762.validator(path, query, header, formData, body)
  let scheme = call_565762.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565762.url(scheme.get, call_565762.host, call_565762.base,
                         call_565762.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565762, url, valid)

proc call*(call_565763: Call_ReplicationvCentersList_565755; apiVersion: string;
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
  var path_565764 = newJObject()
  var query_565765 = newJObject()
  add(query_565765, "api-version", newJString(apiVersion))
  add(path_565764, "subscriptionId", newJString(subscriptionId))
  add(path_565764, "resourceGroupName", newJString(resourceGroupName))
  add(path_565764, "resourceName", newJString(resourceName))
  result = call_565763.call(path_565764, query_565765, nil, nil, nil)

var replicationvCentersList* = Call_ReplicationvCentersList_565755(
    name: "replicationvCentersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationvCenters",
    validator: validate_ReplicationvCentersList_565756, base: "",
    url: url_ReplicationvCentersList_565757, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
