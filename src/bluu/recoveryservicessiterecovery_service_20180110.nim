
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567668 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567668](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567668): Option[Scheme] {.used.} =
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
  macServiceName = "recoveryservicessiterecovery-service"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567890 = ref object of OpenApiRestCall_567668
proc url_OperationsList_567892(protocol: Scheme; host: string; base: string;
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

proc validate_OperationsList_567891(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Operation to return the list of available operations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568065 = path.getOrDefault("resourceGroupName")
  valid_568065 = validateParameter(valid_568065, JString, required = true,
                                 default = nil)
  if valid_568065 != nil:
    section.add "resourceGroupName", valid_568065
  var valid_568066 = path.getOrDefault("subscriptionId")
  valid_568066 = validateParameter(valid_568066, JString, required = true,
                                 default = nil)
  if valid_568066 != nil:
    section.add "subscriptionId", valid_568066
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568067 = query.getOrDefault("api-version")
  valid_568067 = validateParameter(valid_568067, JString, required = true,
                                 default = nil)
  if valid_568067 != nil:
    section.add "api-version", valid_568067
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568090: Call_OperationsList_567890; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Operation to return the list of available operations.
  ## 
  let valid = call_568090.validator(path, query, header, formData, body)
  let scheme = call_568090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568090.url(scheme.get, call_568090.host, call_568090.base,
                         call_568090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568090, url, valid)

proc call*(call_568161: Call_OperationsList_567890; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## operationsList
  ## Operation to return the list of available operations.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  var path_568162 = newJObject()
  var query_568164 = newJObject()
  add(path_568162, "resourceGroupName", newJString(resourceGroupName))
  add(query_568164, "api-version", newJString(apiVersion))
  add(path_568162, "subscriptionId", newJString(subscriptionId))
  result = call_568161.call(path_568162, query_568164, nil, nil, nil)

var operationsList* = Call_OperationsList_567890(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/operations",
    validator: validate_OperationsList_567891, base: "", url: url_OperationsList_567892,
    schemes: {Scheme.Https})
type
  Call_ReplicationAlertSettingsList_568203 = ref object of OpenApiRestCall_567668
proc url_ReplicationAlertSettingsList_568205(protocol: Scheme; host: string;
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

proc validate_ReplicationAlertSettingsList_568204(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the list of email notification(alert) configurations for the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568206 = path.getOrDefault("resourceGroupName")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "resourceGroupName", valid_568206
  var valid_568207 = path.getOrDefault("subscriptionId")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = nil)
  if valid_568207 != nil:
    section.add "subscriptionId", valid_568207
  var valid_568208 = path.getOrDefault("resourceName")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "resourceName", valid_568208
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568209 = query.getOrDefault("api-version")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "api-version", valid_568209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568210: Call_ReplicationAlertSettingsList_568203; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of email notification(alert) configurations for the vault.
  ## 
  let valid = call_568210.validator(path, query, header, formData, body)
  let scheme = call_568210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568210.url(scheme.get, call_568210.host, call_568210.base,
                         call_568210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568210, url, valid)

proc call*(call_568211: Call_ReplicationAlertSettingsList_568203;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationAlertSettingsList
  ## Gets the list of email notification(alert) configurations for the vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_568212 = newJObject()
  var query_568213 = newJObject()
  add(path_568212, "resourceGroupName", newJString(resourceGroupName))
  add(query_568213, "api-version", newJString(apiVersion))
  add(path_568212, "subscriptionId", newJString(subscriptionId))
  add(path_568212, "resourceName", newJString(resourceName))
  result = call_568211.call(path_568212, query_568213, nil, nil, nil)

var replicationAlertSettingsList* = Call_ReplicationAlertSettingsList_568203(
    name: "replicationAlertSettingsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationAlertSettings",
    validator: validate_ReplicationAlertSettingsList_568204, base: "",
    url: url_ReplicationAlertSettingsList_568205, schemes: {Scheme.Https})
type
  Call_ReplicationAlertSettingsCreate_568226 = ref object of OpenApiRestCall_567668
proc url_ReplicationAlertSettingsCreate_568228(protocol: Scheme; host: string;
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

proc validate_ReplicationAlertSettingsCreate_568227(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an email notification(alert) configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   alertSettingName: JString (required)
  ##                   : The name of the email notification(alert) configuration.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568229 = path.getOrDefault("resourceGroupName")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "resourceGroupName", valid_568229
  var valid_568230 = path.getOrDefault("alertSettingName")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "alertSettingName", valid_568230
  var valid_568231 = path.getOrDefault("subscriptionId")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "subscriptionId", valid_568231
  var valid_568232 = path.getOrDefault("resourceName")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "resourceName", valid_568232
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568233 = query.getOrDefault("api-version")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "api-version", valid_568233
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

proc call*(call_568235: Call_ReplicationAlertSettingsCreate_568226; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an email notification(alert) configuration.
  ## 
  let valid = call_568235.validator(path, query, header, formData, body)
  let scheme = call_568235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568235.url(scheme.get, call_568235.host, call_568235.base,
                         call_568235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568235, url, valid)

proc call*(call_568236: Call_ReplicationAlertSettingsCreate_568226;
          resourceGroupName: string; apiVersion: string; alertSettingName: string;
          subscriptionId: string; resourceName: string; request: JsonNode): Recallable =
  ## replicationAlertSettingsCreate
  ## Create or update an email notification(alert) configuration.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   alertSettingName: string (required)
  ##                   : The name of the email notification(alert) configuration.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   request: JObject (required)
  ##          : The input to configure the email notification(alert).
  var path_568237 = newJObject()
  var query_568238 = newJObject()
  var body_568239 = newJObject()
  add(path_568237, "resourceGroupName", newJString(resourceGroupName))
  add(query_568238, "api-version", newJString(apiVersion))
  add(path_568237, "alertSettingName", newJString(alertSettingName))
  add(path_568237, "subscriptionId", newJString(subscriptionId))
  add(path_568237, "resourceName", newJString(resourceName))
  if request != nil:
    body_568239 = request
  result = call_568236.call(path_568237, query_568238, nil, nil, body_568239)

var replicationAlertSettingsCreate* = Call_ReplicationAlertSettingsCreate_568226(
    name: "replicationAlertSettingsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationAlertSettings/{alertSettingName}",
    validator: validate_ReplicationAlertSettingsCreate_568227, base: "",
    url: url_ReplicationAlertSettingsCreate_568228, schemes: {Scheme.Https})
type
  Call_ReplicationAlertSettingsGet_568214 = ref object of OpenApiRestCall_567668
proc url_ReplicationAlertSettingsGet_568216(protocol: Scheme; host: string;
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

proc validate_ReplicationAlertSettingsGet_568215(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the specified email notification(alert) configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   alertSettingName: JString (required)
  ##                   : The name of the email notification configuration.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568217 = path.getOrDefault("resourceGroupName")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "resourceGroupName", valid_568217
  var valid_568218 = path.getOrDefault("alertSettingName")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "alertSettingName", valid_568218
  var valid_568219 = path.getOrDefault("subscriptionId")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "subscriptionId", valid_568219
  var valid_568220 = path.getOrDefault("resourceName")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "resourceName", valid_568220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568221 = query.getOrDefault("api-version")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "api-version", valid_568221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568222: Call_ReplicationAlertSettingsGet_568214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the specified email notification(alert) configuration.
  ## 
  let valid = call_568222.validator(path, query, header, formData, body)
  let scheme = call_568222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568222.url(scheme.get, call_568222.host, call_568222.base,
                         call_568222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568222, url, valid)

proc call*(call_568223: Call_ReplicationAlertSettingsGet_568214;
          resourceGroupName: string; apiVersion: string; alertSettingName: string;
          subscriptionId: string; resourceName: string): Recallable =
  ## replicationAlertSettingsGet
  ## Gets the details of the specified email notification(alert) configuration.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   alertSettingName: string (required)
  ##                   : The name of the email notification configuration.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_568224 = newJObject()
  var query_568225 = newJObject()
  add(path_568224, "resourceGroupName", newJString(resourceGroupName))
  add(query_568225, "api-version", newJString(apiVersion))
  add(path_568224, "alertSettingName", newJString(alertSettingName))
  add(path_568224, "subscriptionId", newJString(subscriptionId))
  add(path_568224, "resourceName", newJString(resourceName))
  result = call_568223.call(path_568224, query_568225, nil, nil, nil)

var replicationAlertSettingsGet* = Call_ReplicationAlertSettingsGet_568214(
    name: "replicationAlertSettingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationAlertSettings/{alertSettingName}",
    validator: validate_ReplicationAlertSettingsGet_568215, base: "",
    url: url_ReplicationAlertSettingsGet_568216, schemes: {Scheme.Https})
type
  Call_ReplicationEventsList_568240 = ref object of OpenApiRestCall_567668
proc url_ReplicationEventsList_568242(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationEventsList_568241(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the list of Azure Site Recovery events for the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568244 = path.getOrDefault("resourceGroupName")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "resourceGroupName", valid_568244
  var valid_568245 = path.getOrDefault("subscriptionId")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "subscriptionId", valid_568245
  var valid_568246 = path.getOrDefault("resourceName")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "resourceName", valid_568246
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568247 = query.getOrDefault("api-version")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "api-version", valid_568247
  var valid_568248 = query.getOrDefault("$filter")
  valid_568248 = validateParameter(valid_568248, JString, required = false,
                                 default = nil)
  if valid_568248 != nil:
    section.add "$filter", valid_568248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568249: Call_ReplicationEventsList_568240; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of Azure Site Recovery events for the vault.
  ## 
  let valid = call_568249.validator(path, query, header, formData, body)
  let scheme = call_568249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568249.url(scheme.get, call_568249.host, call_568249.base,
                         call_568249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568249, url, valid)

proc call*(call_568250: Call_ReplicationEventsList_568240;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; Filter: string = ""): Recallable =
  ## replicationEventsList
  ## Gets the list of Azure Site Recovery events for the vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   Filter: string
  ##         : OData filter options.
  var path_568251 = newJObject()
  var query_568252 = newJObject()
  add(path_568251, "resourceGroupName", newJString(resourceGroupName))
  add(query_568252, "api-version", newJString(apiVersion))
  add(path_568251, "subscriptionId", newJString(subscriptionId))
  add(path_568251, "resourceName", newJString(resourceName))
  add(query_568252, "$filter", newJString(Filter))
  result = call_568250.call(path_568251, query_568252, nil, nil, nil)

var replicationEventsList* = Call_ReplicationEventsList_568240(
    name: "replicationEventsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationEvents",
    validator: validate_ReplicationEventsList_568241, base: "",
    url: url_ReplicationEventsList_568242, schemes: {Scheme.Https})
type
  Call_ReplicationEventsGet_568253 = ref object of OpenApiRestCall_567668
proc url_ReplicationEventsGet_568255(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationEventsGet_568254(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to get the details of an Azure Site recovery event.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   eventName: JString (required)
  ##            : The name of the Azure Site Recovery event.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568256 = path.getOrDefault("resourceGroupName")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "resourceGroupName", valid_568256
  var valid_568257 = path.getOrDefault("subscriptionId")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "subscriptionId", valid_568257
  var valid_568258 = path.getOrDefault("resourceName")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "resourceName", valid_568258
  var valid_568259 = path.getOrDefault("eventName")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "eventName", valid_568259
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568260 = query.getOrDefault("api-version")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "api-version", valid_568260
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568261: Call_ReplicationEventsGet_568253; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to get the details of an Azure Site recovery event.
  ## 
  let valid = call_568261.validator(path, query, header, formData, body)
  let scheme = call_568261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568261.url(scheme.get, call_568261.host, call_568261.base,
                         call_568261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568261, url, valid)

proc call*(call_568262: Call_ReplicationEventsGet_568253;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; eventName: string): Recallable =
  ## replicationEventsGet
  ## The operation to get the details of an Azure Site recovery event.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   eventName: string (required)
  ##            : The name of the Azure Site Recovery event.
  var path_568263 = newJObject()
  var query_568264 = newJObject()
  add(path_568263, "resourceGroupName", newJString(resourceGroupName))
  add(query_568264, "api-version", newJString(apiVersion))
  add(path_568263, "subscriptionId", newJString(subscriptionId))
  add(path_568263, "resourceName", newJString(resourceName))
  add(path_568263, "eventName", newJString(eventName))
  result = call_568262.call(path_568263, query_568264, nil, nil, nil)

var replicationEventsGet* = Call_ReplicationEventsGet_568253(
    name: "replicationEventsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationEvents/{eventName}",
    validator: validate_ReplicationEventsGet_568254, base: "",
    url: url_ReplicationEventsGet_568255, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsList_568265 = ref object of OpenApiRestCall_567668
proc url_ReplicationFabricsList_568267(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationFabricsList_568266(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of the Azure Site Recovery fabrics in the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568268 = path.getOrDefault("resourceGroupName")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "resourceGroupName", valid_568268
  var valid_568269 = path.getOrDefault("subscriptionId")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "subscriptionId", valid_568269
  var valid_568270 = path.getOrDefault("resourceName")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "resourceName", valid_568270
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568271 = query.getOrDefault("api-version")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "api-version", valid_568271
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568272: Call_ReplicationFabricsList_568265; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of the Azure Site Recovery fabrics in the vault.
  ## 
  let valid = call_568272.validator(path, query, header, formData, body)
  let scheme = call_568272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568272.url(scheme.get, call_568272.host, call_568272.base,
                         call_568272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568272, url, valid)

proc call*(call_568273: Call_ReplicationFabricsList_568265;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationFabricsList
  ## Gets a list of the Azure Site Recovery fabrics in the vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_568274 = newJObject()
  var query_568275 = newJObject()
  add(path_568274, "resourceGroupName", newJString(resourceGroupName))
  add(query_568275, "api-version", newJString(apiVersion))
  add(path_568274, "subscriptionId", newJString(subscriptionId))
  add(path_568274, "resourceName", newJString(resourceName))
  result = call_568273.call(path_568274, query_568275, nil, nil, nil)

var replicationFabricsList* = Call_ReplicationFabricsList_568265(
    name: "replicationFabricsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics",
    validator: validate_ReplicationFabricsList_568266, base: "",
    url: url_ReplicationFabricsList_568267, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsCreate_568288 = ref object of OpenApiRestCall_567668
proc url_ReplicationFabricsCreate_568290(protocol: Scheme; host: string;
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

proc validate_ReplicationFabricsCreate_568289(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create an Azure Site Recovery fabric (for e.g. Hyper-V site)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Name of the ASR fabric.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568291 = path.getOrDefault("fabricName")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "fabricName", valid_568291
  var valid_568292 = path.getOrDefault("resourceGroupName")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "resourceGroupName", valid_568292
  var valid_568293 = path.getOrDefault("subscriptionId")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "subscriptionId", valid_568293
  var valid_568294 = path.getOrDefault("resourceName")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "resourceName", valid_568294
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568295 = query.getOrDefault("api-version")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "api-version", valid_568295
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

proc call*(call_568297: Call_ReplicationFabricsCreate_568288; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create an Azure Site Recovery fabric (for e.g. Hyper-V site)
  ## 
  let valid = call_568297.validator(path, query, header, formData, body)
  let scheme = call_568297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568297.url(scheme.get, call_568297.host, call_568297.base,
                         call_568297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568297, url, valid)

proc call*(call_568298: Call_ReplicationFabricsCreate_568288; fabricName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          input: JsonNode; resourceName: string): Recallable =
  ## replicationFabricsCreate
  ## The operation to create an Azure Site Recovery fabric (for e.g. Hyper-V site)
  ##   fabricName: string (required)
  ##             : Name of the ASR fabric.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   input: JObject (required)
  ##        : Fabric creation input.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_568299 = newJObject()
  var query_568300 = newJObject()
  var body_568301 = newJObject()
  add(path_568299, "fabricName", newJString(fabricName))
  add(path_568299, "resourceGroupName", newJString(resourceGroupName))
  add(query_568300, "api-version", newJString(apiVersion))
  add(path_568299, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_568301 = input
  add(path_568299, "resourceName", newJString(resourceName))
  result = call_568298.call(path_568299, query_568300, nil, nil, body_568301)

var replicationFabricsCreate* = Call_ReplicationFabricsCreate_568288(
    name: "replicationFabricsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}",
    validator: validate_ReplicationFabricsCreate_568289, base: "",
    url: url_ReplicationFabricsCreate_568290, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsGet_568276 = ref object of OpenApiRestCall_567668
proc url_ReplicationFabricsGet_568278(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationFabricsGet_568277(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of an Azure Site Recovery fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568279 = path.getOrDefault("fabricName")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "fabricName", valid_568279
  var valid_568280 = path.getOrDefault("resourceGroupName")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "resourceGroupName", valid_568280
  var valid_568281 = path.getOrDefault("subscriptionId")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "subscriptionId", valid_568281
  var valid_568282 = path.getOrDefault("resourceName")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "resourceName", valid_568282
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568283 = query.getOrDefault("api-version")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "api-version", valid_568283
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568284: Call_ReplicationFabricsGet_568276; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of an Azure Site Recovery fabric.
  ## 
  let valid = call_568284.validator(path, query, header, formData, body)
  let scheme = call_568284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568284.url(scheme.get, call_568284.host, call_568284.base,
                         call_568284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568284, url, valid)

proc call*(call_568285: Call_ReplicationFabricsGet_568276; fabricName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationFabricsGet
  ## Gets the details of an Azure Site Recovery fabric.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_568286 = newJObject()
  var query_568287 = newJObject()
  add(path_568286, "fabricName", newJString(fabricName))
  add(path_568286, "resourceGroupName", newJString(resourceGroupName))
  add(query_568287, "api-version", newJString(apiVersion))
  add(path_568286, "subscriptionId", newJString(subscriptionId))
  add(path_568286, "resourceName", newJString(resourceName))
  result = call_568285.call(path_568286, query_568287, nil, nil, nil)

var replicationFabricsGet* = Call_ReplicationFabricsGet_568276(
    name: "replicationFabricsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}",
    validator: validate_ReplicationFabricsGet_568277, base: "",
    url: url_ReplicationFabricsGet_568278, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsPurge_568302 = ref object of OpenApiRestCall_567668
proc url_ReplicationFabricsPurge_568304(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationFabricsPurge_568303(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to purge(force delete) an Azure Site Recovery fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : ASR fabric to purge.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568305 = path.getOrDefault("fabricName")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "fabricName", valid_568305
  var valid_568306 = path.getOrDefault("resourceGroupName")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "resourceGroupName", valid_568306
  var valid_568307 = path.getOrDefault("subscriptionId")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "subscriptionId", valid_568307
  var valid_568308 = path.getOrDefault("resourceName")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "resourceName", valid_568308
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568309 = query.getOrDefault("api-version")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "api-version", valid_568309
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568310: Call_ReplicationFabricsPurge_568302; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to purge(force delete) an Azure Site Recovery fabric.
  ## 
  let valid = call_568310.validator(path, query, header, formData, body)
  let scheme = call_568310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568310.url(scheme.get, call_568310.host, call_568310.base,
                         call_568310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568310, url, valid)

proc call*(call_568311: Call_ReplicationFabricsPurge_568302; fabricName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationFabricsPurge
  ## The operation to purge(force delete) an Azure Site Recovery fabric.
  ##   fabricName: string (required)
  ##             : ASR fabric to purge.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_568312 = newJObject()
  var query_568313 = newJObject()
  add(path_568312, "fabricName", newJString(fabricName))
  add(path_568312, "resourceGroupName", newJString(resourceGroupName))
  add(query_568313, "api-version", newJString(apiVersion))
  add(path_568312, "subscriptionId", newJString(subscriptionId))
  add(path_568312, "resourceName", newJString(resourceName))
  result = call_568311.call(path_568312, query_568313, nil, nil, nil)

var replicationFabricsPurge* = Call_ReplicationFabricsPurge_568302(
    name: "replicationFabricsPurge", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}",
    validator: validate_ReplicationFabricsPurge_568303, base: "",
    url: url_ReplicationFabricsPurge_568304, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsCheckConsistency_568314 = ref object of OpenApiRestCall_567668
proc url_ReplicationFabricsCheckConsistency_568316(protocol: Scheme; host: string;
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

proc validate_ReplicationFabricsCheckConsistency_568315(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to perform a consistency check on the fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568317 = path.getOrDefault("fabricName")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "fabricName", valid_568317
  var valid_568318 = path.getOrDefault("resourceGroupName")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "resourceGroupName", valid_568318
  var valid_568319 = path.getOrDefault("subscriptionId")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "subscriptionId", valid_568319
  var valid_568320 = path.getOrDefault("resourceName")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "resourceName", valid_568320
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568321 = query.getOrDefault("api-version")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "api-version", valid_568321
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568322: Call_ReplicationFabricsCheckConsistency_568314;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to perform a consistency check on the fabric.
  ## 
  let valid = call_568322.validator(path, query, header, formData, body)
  let scheme = call_568322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568322.url(scheme.get, call_568322.host, call_568322.base,
                         call_568322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568322, url, valid)

proc call*(call_568323: Call_ReplicationFabricsCheckConsistency_568314;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string): Recallable =
  ## replicationFabricsCheckConsistency
  ## The operation to perform a consistency check on the fabric.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_568324 = newJObject()
  var query_568325 = newJObject()
  add(path_568324, "fabricName", newJString(fabricName))
  add(path_568324, "resourceGroupName", newJString(resourceGroupName))
  add(query_568325, "api-version", newJString(apiVersion))
  add(path_568324, "subscriptionId", newJString(subscriptionId))
  add(path_568324, "resourceName", newJString(resourceName))
  result = call_568323.call(path_568324, query_568325, nil, nil, nil)

var replicationFabricsCheckConsistency* = Call_ReplicationFabricsCheckConsistency_568314(
    name: "replicationFabricsCheckConsistency", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/checkConsistency",
    validator: validate_ReplicationFabricsCheckConsistency_568315, base: "",
    url: url_ReplicationFabricsCheckConsistency_568316, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsMigrateToAad_568326 = ref object of OpenApiRestCall_567668
proc url_ReplicationFabricsMigrateToAad_568328(protocol: Scheme; host: string;
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

proc validate_ReplicationFabricsMigrateToAad_568327(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to migrate an Azure Site Recovery fabric to AAD.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : ASR fabric to migrate.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568329 = path.getOrDefault("fabricName")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "fabricName", valid_568329
  var valid_568330 = path.getOrDefault("resourceGroupName")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "resourceGroupName", valid_568330
  var valid_568331 = path.getOrDefault("subscriptionId")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "subscriptionId", valid_568331
  var valid_568332 = path.getOrDefault("resourceName")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "resourceName", valid_568332
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568333 = query.getOrDefault("api-version")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "api-version", valid_568333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568334: Call_ReplicationFabricsMigrateToAad_568326; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to migrate an Azure Site Recovery fabric to AAD.
  ## 
  let valid = call_568334.validator(path, query, header, formData, body)
  let scheme = call_568334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568334.url(scheme.get, call_568334.host, call_568334.base,
                         call_568334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568334, url, valid)

proc call*(call_568335: Call_ReplicationFabricsMigrateToAad_568326;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string): Recallable =
  ## replicationFabricsMigrateToAad
  ## The operation to migrate an Azure Site Recovery fabric to AAD.
  ##   fabricName: string (required)
  ##             : ASR fabric to migrate.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_568336 = newJObject()
  var query_568337 = newJObject()
  add(path_568336, "fabricName", newJString(fabricName))
  add(path_568336, "resourceGroupName", newJString(resourceGroupName))
  add(query_568337, "api-version", newJString(apiVersion))
  add(path_568336, "subscriptionId", newJString(subscriptionId))
  add(path_568336, "resourceName", newJString(resourceName))
  result = call_568335.call(path_568336, query_568337, nil, nil, nil)

var replicationFabricsMigrateToAad* = Call_ReplicationFabricsMigrateToAad_568326(
    name: "replicationFabricsMigrateToAad", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/migratetoaad",
    validator: validate_ReplicationFabricsMigrateToAad_568327, base: "",
    url: url_ReplicationFabricsMigrateToAad_568328, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsReassociateGateway_568338 = ref object of OpenApiRestCall_567668
proc url_ReplicationFabricsReassociateGateway_568340(protocol: Scheme;
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

proc validate_ReplicationFabricsReassociateGateway_568339(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to move replications from a process server to another process server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The name of the fabric containing the process server.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568341 = path.getOrDefault("fabricName")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "fabricName", valid_568341
  var valid_568342 = path.getOrDefault("resourceGroupName")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "resourceGroupName", valid_568342
  var valid_568343 = path.getOrDefault("subscriptionId")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "subscriptionId", valid_568343
  var valid_568344 = path.getOrDefault("resourceName")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "resourceName", valid_568344
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568345 = query.getOrDefault("api-version")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "api-version", valid_568345
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

proc call*(call_568347: Call_ReplicationFabricsReassociateGateway_568338;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to move replications from a process server to another process server.
  ## 
  let valid = call_568347.validator(path, query, header, formData, body)
  let scheme = call_568347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568347.url(scheme.get, call_568347.host, call_568347.base,
                         call_568347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568347, url, valid)

proc call*(call_568348: Call_ReplicationFabricsReassociateGateway_568338;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          failoverProcessServerRequest: JsonNode; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationFabricsReassociateGateway
  ## The operation to move replications from a process server to another process server.
  ##   fabricName: string (required)
  ##             : The name of the fabric containing the process server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   failoverProcessServerRequest: JObject (required)
  ##                               : The input to the failover process server operation.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_568349 = newJObject()
  var query_568350 = newJObject()
  var body_568351 = newJObject()
  add(path_568349, "fabricName", newJString(fabricName))
  add(path_568349, "resourceGroupName", newJString(resourceGroupName))
  add(query_568350, "api-version", newJString(apiVersion))
  if failoverProcessServerRequest != nil:
    body_568351 = failoverProcessServerRequest
  add(path_568349, "subscriptionId", newJString(subscriptionId))
  add(path_568349, "resourceName", newJString(resourceName))
  result = call_568348.call(path_568349, query_568350, nil, nil, body_568351)

var replicationFabricsReassociateGateway* = Call_ReplicationFabricsReassociateGateway_568338(
    name: "replicationFabricsReassociateGateway", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/reassociateGateway",
    validator: validate_ReplicationFabricsReassociateGateway_568339, base: "",
    url: url_ReplicationFabricsReassociateGateway_568340, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsDelete_568352 = ref object of OpenApiRestCall_567668
proc url_ReplicationFabricsDelete_568354(protocol: Scheme; host: string;
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

proc validate_ReplicationFabricsDelete_568353(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete or remove an Azure Site Recovery fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : ASR fabric to delete
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568355 = path.getOrDefault("fabricName")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "fabricName", valid_568355
  var valid_568356 = path.getOrDefault("resourceGroupName")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "resourceGroupName", valid_568356
  var valid_568357 = path.getOrDefault("subscriptionId")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = nil)
  if valid_568357 != nil:
    section.add "subscriptionId", valid_568357
  var valid_568358 = path.getOrDefault("resourceName")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = nil)
  if valid_568358 != nil:
    section.add "resourceName", valid_568358
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568359 = query.getOrDefault("api-version")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = nil)
  if valid_568359 != nil:
    section.add "api-version", valid_568359
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568360: Call_ReplicationFabricsDelete_568352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete or remove an Azure Site Recovery fabric.
  ## 
  let valid = call_568360.validator(path, query, header, formData, body)
  let scheme = call_568360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568360.url(scheme.get, call_568360.host, call_568360.base,
                         call_568360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568360, url, valid)

proc call*(call_568361: Call_ReplicationFabricsDelete_568352; fabricName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationFabricsDelete
  ## The operation to delete or remove an Azure Site Recovery fabric.
  ##   fabricName: string (required)
  ##             : ASR fabric to delete
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_568362 = newJObject()
  var query_568363 = newJObject()
  add(path_568362, "fabricName", newJString(fabricName))
  add(path_568362, "resourceGroupName", newJString(resourceGroupName))
  add(query_568363, "api-version", newJString(apiVersion))
  add(path_568362, "subscriptionId", newJString(subscriptionId))
  add(path_568362, "resourceName", newJString(resourceName))
  result = call_568361.call(path_568362, query_568363, nil, nil, nil)

var replicationFabricsDelete* = Call_ReplicationFabricsDelete_568352(
    name: "replicationFabricsDelete", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/remove",
    validator: validate_ReplicationFabricsDelete_568353, base: "",
    url: url_ReplicationFabricsDelete_568354, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsRenewCertificate_568364 = ref object of OpenApiRestCall_567668
proc url_ReplicationFabricsRenewCertificate_568366(protocol: Scheme; host: string;
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

proc validate_ReplicationFabricsRenewCertificate_568365(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Renews the connection certificate for the ASR replication fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : fabric name to renew certs for.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568367 = path.getOrDefault("fabricName")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "fabricName", valid_568367
  var valid_568368 = path.getOrDefault("resourceGroupName")
  valid_568368 = validateParameter(valid_568368, JString, required = true,
                                 default = nil)
  if valid_568368 != nil:
    section.add "resourceGroupName", valid_568368
  var valid_568369 = path.getOrDefault("subscriptionId")
  valid_568369 = validateParameter(valid_568369, JString, required = true,
                                 default = nil)
  if valid_568369 != nil:
    section.add "subscriptionId", valid_568369
  var valid_568370 = path.getOrDefault("resourceName")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = nil)
  if valid_568370 != nil:
    section.add "resourceName", valid_568370
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568371 = query.getOrDefault("api-version")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "api-version", valid_568371
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

proc call*(call_568373: Call_ReplicationFabricsRenewCertificate_568364;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Renews the connection certificate for the ASR replication fabric.
  ## 
  let valid = call_568373.validator(path, query, header, formData, body)
  let scheme = call_568373.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568373.url(scheme.get, call_568373.host, call_568373.base,
                         call_568373.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568373, url, valid)

proc call*(call_568374: Call_ReplicationFabricsRenewCertificate_568364;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; renewCertificate: JsonNode; resourceName: string): Recallable =
  ## replicationFabricsRenewCertificate
  ## Renews the connection certificate for the ASR replication fabric.
  ##   fabricName: string (required)
  ##             : fabric name to renew certs for.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   renewCertificate: JObject (required)
  ##                   : Renew certificate input.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_568375 = newJObject()
  var query_568376 = newJObject()
  var body_568377 = newJObject()
  add(path_568375, "fabricName", newJString(fabricName))
  add(path_568375, "resourceGroupName", newJString(resourceGroupName))
  add(query_568376, "api-version", newJString(apiVersion))
  add(path_568375, "subscriptionId", newJString(subscriptionId))
  if renewCertificate != nil:
    body_568377 = renewCertificate
  add(path_568375, "resourceName", newJString(resourceName))
  result = call_568374.call(path_568375, query_568376, nil, nil, body_568377)

var replicationFabricsRenewCertificate* = Call_ReplicationFabricsRenewCertificate_568364(
    name: "replicationFabricsRenewCertificate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/renewCertificate",
    validator: validate_ReplicationFabricsRenewCertificate_568365, base: "",
    url: url_ReplicationFabricsRenewCertificate_568366, schemes: {Scheme.Https})
type
  Call_ReplicationLogicalNetworksListByReplicationFabrics_568378 = ref object of OpenApiRestCall_567668
proc url_ReplicationLogicalNetworksListByReplicationFabrics_568380(
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

proc validate_ReplicationLogicalNetworksListByReplicationFabrics_568379(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all the logical networks of the Azure Site Recovery fabric
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Server Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568381 = path.getOrDefault("fabricName")
  valid_568381 = validateParameter(valid_568381, JString, required = true,
                                 default = nil)
  if valid_568381 != nil:
    section.add "fabricName", valid_568381
  var valid_568382 = path.getOrDefault("resourceGroupName")
  valid_568382 = validateParameter(valid_568382, JString, required = true,
                                 default = nil)
  if valid_568382 != nil:
    section.add "resourceGroupName", valid_568382
  var valid_568383 = path.getOrDefault("subscriptionId")
  valid_568383 = validateParameter(valid_568383, JString, required = true,
                                 default = nil)
  if valid_568383 != nil:
    section.add "subscriptionId", valid_568383
  var valid_568384 = path.getOrDefault("resourceName")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = nil)
  if valid_568384 != nil:
    section.add "resourceName", valid_568384
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568385 = query.getOrDefault("api-version")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = nil)
  if valid_568385 != nil:
    section.add "api-version", valid_568385
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568386: Call_ReplicationLogicalNetworksListByReplicationFabrics_568378;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the logical networks of the Azure Site Recovery fabric
  ## 
  let valid = call_568386.validator(path, query, header, formData, body)
  let scheme = call_568386.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568386.url(scheme.get, call_568386.host, call_568386.base,
                         call_568386.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568386, url, valid)

proc call*(call_568387: Call_ReplicationLogicalNetworksListByReplicationFabrics_568378;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string): Recallable =
  ## replicationLogicalNetworksListByReplicationFabrics
  ## Lists all the logical networks of the Azure Site Recovery fabric
  ##   fabricName: string (required)
  ##             : Server Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_568388 = newJObject()
  var query_568389 = newJObject()
  add(path_568388, "fabricName", newJString(fabricName))
  add(path_568388, "resourceGroupName", newJString(resourceGroupName))
  add(query_568389, "api-version", newJString(apiVersion))
  add(path_568388, "subscriptionId", newJString(subscriptionId))
  add(path_568388, "resourceName", newJString(resourceName))
  result = call_568387.call(path_568388, query_568389, nil, nil, nil)

var replicationLogicalNetworksListByReplicationFabrics* = Call_ReplicationLogicalNetworksListByReplicationFabrics_568378(
    name: "replicationLogicalNetworksListByReplicationFabrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationLogicalNetworks",
    validator: validate_ReplicationLogicalNetworksListByReplicationFabrics_568379,
    base: "", url: url_ReplicationLogicalNetworksListByReplicationFabrics_568380,
    schemes: {Scheme.Https})
type
  Call_ReplicationLogicalNetworksGet_568390 = ref object of OpenApiRestCall_567668
proc url_ReplicationLogicalNetworksGet_568392(protocol: Scheme; host: string;
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

proc validate_ReplicationLogicalNetworksGet_568391(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of a logical network.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Server Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   logicalNetworkName: JString (required)
  ##                     : Logical network name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568393 = path.getOrDefault("fabricName")
  valid_568393 = validateParameter(valid_568393, JString, required = true,
                                 default = nil)
  if valid_568393 != nil:
    section.add "fabricName", valid_568393
  var valid_568394 = path.getOrDefault("resourceGroupName")
  valid_568394 = validateParameter(valid_568394, JString, required = true,
                                 default = nil)
  if valid_568394 != nil:
    section.add "resourceGroupName", valid_568394
  var valid_568395 = path.getOrDefault("logicalNetworkName")
  valid_568395 = validateParameter(valid_568395, JString, required = true,
                                 default = nil)
  if valid_568395 != nil:
    section.add "logicalNetworkName", valid_568395
  var valid_568396 = path.getOrDefault("subscriptionId")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = nil)
  if valid_568396 != nil:
    section.add "subscriptionId", valid_568396
  var valid_568397 = path.getOrDefault("resourceName")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = nil)
  if valid_568397 != nil:
    section.add "resourceName", valid_568397
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568398 = query.getOrDefault("api-version")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = nil)
  if valid_568398 != nil:
    section.add "api-version", valid_568398
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568399: Call_ReplicationLogicalNetworksGet_568390; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a logical network.
  ## 
  let valid = call_568399.validator(path, query, header, formData, body)
  let scheme = call_568399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568399.url(scheme.get, call_568399.host, call_568399.base,
                         call_568399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568399, url, valid)

proc call*(call_568400: Call_ReplicationLogicalNetworksGet_568390;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          logicalNetworkName: string; subscriptionId: string; resourceName: string): Recallable =
  ## replicationLogicalNetworksGet
  ## Gets the details of a logical network.
  ##   fabricName: string (required)
  ##             : Server Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   logicalNetworkName: string (required)
  ##                     : Logical network name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_568401 = newJObject()
  var query_568402 = newJObject()
  add(path_568401, "fabricName", newJString(fabricName))
  add(path_568401, "resourceGroupName", newJString(resourceGroupName))
  add(query_568402, "api-version", newJString(apiVersion))
  add(path_568401, "logicalNetworkName", newJString(logicalNetworkName))
  add(path_568401, "subscriptionId", newJString(subscriptionId))
  add(path_568401, "resourceName", newJString(resourceName))
  result = call_568400.call(path_568401, query_568402, nil, nil, nil)

var replicationLogicalNetworksGet* = Call_ReplicationLogicalNetworksGet_568390(
    name: "replicationLogicalNetworksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationLogicalNetworks/{logicalNetworkName}",
    validator: validate_ReplicationLogicalNetworksGet_568391, base: "",
    url: url_ReplicationLogicalNetworksGet_568392, schemes: {Scheme.Https})
type
  Call_ReplicationNetworksListByReplicationFabrics_568403 = ref object of OpenApiRestCall_567668
proc url_ReplicationNetworksListByReplicationFabrics_568405(protocol: Scheme;
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

proc validate_ReplicationNetworksListByReplicationFabrics_568404(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the networks available for a fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568406 = path.getOrDefault("fabricName")
  valid_568406 = validateParameter(valid_568406, JString, required = true,
                                 default = nil)
  if valid_568406 != nil:
    section.add "fabricName", valid_568406
  var valid_568407 = path.getOrDefault("resourceGroupName")
  valid_568407 = validateParameter(valid_568407, JString, required = true,
                                 default = nil)
  if valid_568407 != nil:
    section.add "resourceGroupName", valid_568407
  var valid_568408 = path.getOrDefault("subscriptionId")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = nil)
  if valid_568408 != nil:
    section.add "subscriptionId", valid_568408
  var valid_568409 = path.getOrDefault("resourceName")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = nil)
  if valid_568409 != nil:
    section.add "resourceName", valid_568409
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568410 = query.getOrDefault("api-version")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = nil)
  if valid_568410 != nil:
    section.add "api-version", valid_568410
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568411: Call_ReplicationNetworksListByReplicationFabrics_568403;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the networks available for a fabric.
  ## 
  let valid = call_568411.validator(path, query, header, formData, body)
  let scheme = call_568411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568411.url(scheme.get, call_568411.host, call_568411.base,
                         call_568411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568411, url, valid)

proc call*(call_568412: Call_ReplicationNetworksListByReplicationFabrics_568403;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string): Recallable =
  ## replicationNetworksListByReplicationFabrics
  ## Lists the networks available for a fabric.
  ##   fabricName: string (required)
  ##             : Fabric name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_568413 = newJObject()
  var query_568414 = newJObject()
  add(path_568413, "fabricName", newJString(fabricName))
  add(path_568413, "resourceGroupName", newJString(resourceGroupName))
  add(query_568414, "api-version", newJString(apiVersion))
  add(path_568413, "subscriptionId", newJString(subscriptionId))
  add(path_568413, "resourceName", newJString(resourceName))
  result = call_568412.call(path_568413, query_568414, nil, nil, nil)

var replicationNetworksListByReplicationFabrics* = Call_ReplicationNetworksListByReplicationFabrics_568403(
    name: "replicationNetworksListByReplicationFabrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationNetworks",
    validator: validate_ReplicationNetworksListByReplicationFabrics_568404,
    base: "", url: url_ReplicationNetworksListByReplicationFabrics_568405,
    schemes: {Scheme.Https})
type
  Call_ReplicationNetworksGet_568415 = ref object of OpenApiRestCall_567668
proc url_ReplicationNetworksGet_568417(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationNetworksGet_568416(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of a network.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Server Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   networkName: JString (required)
  ##              : Primary network name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568418 = path.getOrDefault("fabricName")
  valid_568418 = validateParameter(valid_568418, JString, required = true,
                                 default = nil)
  if valid_568418 != nil:
    section.add "fabricName", valid_568418
  var valid_568419 = path.getOrDefault("resourceGroupName")
  valid_568419 = validateParameter(valid_568419, JString, required = true,
                                 default = nil)
  if valid_568419 != nil:
    section.add "resourceGroupName", valid_568419
  var valid_568420 = path.getOrDefault("networkName")
  valid_568420 = validateParameter(valid_568420, JString, required = true,
                                 default = nil)
  if valid_568420 != nil:
    section.add "networkName", valid_568420
  var valid_568421 = path.getOrDefault("subscriptionId")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = nil)
  if valid_568421 != nil:
    section.add "subscriptionId", valid_568421
  var valid_568422 = path.getOrDefault("resourceName")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "resourceName", valid_568422
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568423 = query.getOrDefault("api-version")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "api-version", valid_568423
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568424: Call_ReplicationNetworksGet_568415; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a network.
  ## 
  let valid = call_568424.validator(path, query, header, formData, body)
  let scheme = call_568424.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568424.url(scheme.get, call_568424.host, call_568424.base,
                         call_568424.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568424, url, valid)

proc call*(call_568425: Call_ReplicationNetworksGet_568415; fabricName: string;
          resourceGroupName: string; apiVersion: string; networkName: string;
          subscriptionId: string; resourceName: string): Recallable =
  ## replicationNetworksGet
  ## Gets the details of a network.
  ##   fabricName: string (required)
  ##             : Server Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   networkName: string (required)
  ##              : Primary network name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_568426 = newJObject()
  var query_568427 = newJObject()
  add(path_568426, "fabricName", newJString(fabricName))
  add(path_568426, "resourceGroupName", newJString(resourceGroupName))
  add(query_568427, "api-version", newJString(apiVersion))
  add(path_568426, "networkName", newJString(networkName))
  add(path_568426, "subscriptionId", newJString(subscriptionId))
  add(path_568426, "resourceName", newJString(resourceName))
  result = call_568425.call(path_568426, query_568427, nil, nil, nil)

var replicationNetworksGet* = Call_ReplicationNetworksGet_568415(
    name: "replicationNetworksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationNetworks/{networkName}",
    validator: validate_ReplicationNetworksGet_568416, base: "",
    url: url_ReplicationNetworksGet_568417, schemes: {Scheme.Https})
type
  Call_ReplicationNetworkMappingsListByReplicationNetworks_568428 = ref object of OpenApiRestCall_567668
proc url_ReplicationNetworkMappingsListByReplicationNetworks_568430(
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

proc validate_ReplicationNetworkMappingsListByReplicationNetworks_568429(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all ASR network mappings for the specified network.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Primary fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   networkName: JString (required)
  ##              : Primary network name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568431 = path.getOrDefault("fabricName")
  valid_568431 = validateParameter(valid_568431, JString, required = true,
                                 default = nil)
  if valid_568431 != nil:
    section.add "fabricName", valid_568431
  var valid_568432 = path.getOrDefault("resourceGroupName")
  valid_568432 = validateParameter(valid_568432, JString, required = true,
                                 default = nil)
  if valid_568432 != nil:
    section.add "resourceGroupName", valid_568432
  var valid_568433 = path.getOrDefault("networkName")
  valid_568433 = validateParameter(valid_568433, JString, required = true,
                                 default = nil)
  if valid_568433 != nil:
    section.add "networkName", valid_568433
  var valid_568434 = path.getOrDefault("subscriptionId")
  valid_568434 = validateParameter(valid_568434, JString, required = true,
                                 default = nil)
  if valid_568434 != nil:
    section.add "subscriptionId", valid_568434
  var valid_568435 = path.getOrDefault("resourceName")
  valid_568435 = validateParameter(valid_568435, JString, required = true,
                                 default = nil)
  if valid_568435 != nil:
    section.add "resourceName", valid_568435
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568436 = query.getOrDefault("api-version")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "api-version", valid_568436
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568437: Call_ReplicationNetworkMappingsListByReplicationNetworks_568428;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all ASR network mappings for the specified network.
  ## 
  let valid = call_568437.validator(path, query, header, formData, body)
  let scheme = call_568437.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568437.url(scheme.get, call_568437.host, call_568437.base,
                         call_568437.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568437, url, valid)

proc call*(call_568438: Call_ReplicationNetworkMappingsListByReplicationNetworks_568428;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          networkName: string; subscriptionId: string; resourceName: string): Recallable =
  ## replicationNetworkMappingsListByReplicationNetworks
  ## Lists all ASR network mappings for the specified network.
  ##   fabricName: string (required)
  ##             : Primary fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   networkName: string (required)
  ##              : Primary network name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_568439 = newJObject()
  var query_568440 = newJObject()
  add(path_568439, "fabricName", newJString(fabricName))
  add(path_568439, "resourceGroupName", newJString(resourceGroupName))
  add(query_568440, "api-version", newJString(apiVersion))
  add(path_568439, "networkName", newJString(networkName))
  add(path_568439, "subscriptionId", newJString(subscriptionId))
  add(path_568439, "resourceName", newJString(resourceName))
  result = call_568438.call(path_568439, query_568440, nil, nil, nil)

var replicationNetworkMappingsListByReplicationNetworks* = Call_ReplicationNetworkMappingsListByReplicationNetworks_568428(
    name: "replicationNetworkMappingsListByReplicationNetworks",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationNetworks/{networkName}/replicationNetworkMappings",
    validator: validate_ReplicationNetworkMappingsListByReplicationNetworks_568429,
    base: "", url: url_ReplicationNetworkMappingsListByReplicationNetworks_568430,
    schemes: {Scheme.Https})
type
  Call_ReplicationNetworkMappingsCreate_568455 = ref object of OpenApiRestCall_567668
proc url_ReplicationNetworkMappingsCreate_568457(protocol: Scheme; host: string;
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

proc validate_ReplicationNetworkMappingsCreate_568456(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create an ASR network mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkMappingName: JString (required)
  ##                     : Network mapping name.
  ##   fabricName: JString (required)
  ##             : Primary fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   networkName: JString (required)
  ##              : Primary network name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkMappingName` field"
  var valid_568458 = path.getOrDefault("networkMappingName")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "networkMappingName", valid_568458
  var valid_568459 = path.getOrDefault("fabricName")
  valid_568459 = validateParameter(valid_568459, JString, required = true,
                                 default = nil)
  if valid_568459 != nil:
    section.add "fabricName", valid_568459
  var valid_568460 = path.getOrDefault("resourceGroupName")
  valid_568460 = validateParameter(valid_568460, JString, required = true,
                                 default = nil)
  if valid_568460 != nil:
    section.add "resourceGroupName", valid_568460
  var valid_568461 = path.getOrDefault("networkName")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = nil)
  if valid_568461 != nil:
    section.add "networkName", valid_568461
  var valid_568462 = path.getOrDefault("subscriptionId")
  valid_568462 = validateParameter(valid_568462, JString, required = true,
                                 default = nil)
  if valid_568462 != nil:
    section.add "subscriptionId", valid_568462
  var valid_568463 = path.getOrDefault("resourceName")
  valid_568463 = validateParameter(valid_568463, JString, required = true,
                                 default = nil)
  if valid_568463 != nil:
    section.add "resourceName", valid_568463
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568464 = query.getOrDefault("api-version")
  valid_568464 = validateParameter(valid_568464, JString, required = true,
                                 default = nil)
  if valid_568464 != nil:
    section.add "api-version", valid_568464
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

proc call*(call_568466: Call_ReplicationNetworkMappingsCreate_568455;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create an ASR network mapping.
  ## 
  let valid = call_568466.validator(path, query, header, formData, body)
  let scheme = call_568466.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568466.url(scheme.get, call_568466.host, call_568466.base,
                         call_568466.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568466, url, valid)

proc call*(call_568467: Call_ReplicationNetworkMappingsCreate_568455;
          networkMappingName: string; fabricName: string; resourceGroupName: string;
          apiVersion: string; networkName: string; subscriptionId: string;
          input: JsonNode; resourceName: string): Recallable =
  ## replicationNetworkMappingsCreate
  ## The operation to create an ASR network mapping.
  ##   networkMappingName: string (required)
  ##                     : Network mapping name.
  ##   fabricName: string (required)
  ##             : Primary fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   networkName: string (required)
  ##              : Primary network name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   input: JObject (required)
  ##        : Create network mapping input.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_568468 = newJObject()
  var query_568469 = newJObject()
  var body_568470 = newJObject()
  add(path_568468, "networkMappingName", newJString(networkMappingName))
  add(path_568468, "fabricName", newJString(fabricName))
  add(path_568468, "resourceGroupName", newJString(resourceGroupName))
  add(query_568469, "api-version", newJString(apiVersion))
  add(path_568468, "networkName", newJString(networkName))
  add(path_568468, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_568470 = input
  add(path_568468, "resourceName", newJString(resourceName))
  result = call_568467.call(path_568468, query_568469, nil, nil, body_568470)

var replicationNetworkMappingsCreate* = Call_ReplicationNetworkMappingsCreate_568455(
    name: "replicationNetworkMappingsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationNetworks/{networkName}/replicationNetworkMappings/{networkMappingName}",
    validator: validate_ReplicationNetworkMappingsCreate_568456, base: "",
    url: url_ReplicationNetworkMappingsCreate_568457, schemes: {Scheme.Https})
type
  Call_ReplicationNetworkMappingsGet_568441 = ref object of OpenApiRestCall_567668
proc url_ReplicationNetworkMappingsGet_568443(protocol: Scheme; host: string;
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

proc validate_ReplicationNetworkMappingsGet_568442(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of an ASR network mapping
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkMappingName: JString (required)
  ##                     : Network mapping name.
  ##   fabricName: JString (required)
  ##             : Primary fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   networkName: JString (required)
  ##              : Primary network name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkMappingName` field"
  var valid_568444 = path.getOrDefault("networkMappingName")
  valid_568444 = validateParameter(valid_568444, JString, required = true,
                                 default = nil)
  if valid_568444 != nil:
    section.add "networkMappingName", valid_568444
  var valid_568445 = path.getOrDefault("fabricName")
  valid_568445 = validateParameter(valid_568445, JString, required = true,
                                 default = nil)
  if valid_568445 != nil:
    section.add "fabricName", valid_568445
  var valid_568446 = path.getOrDefault("resourceGroupName")
  valid_568446 = validateParameter(valid_568446, JString, required = true,
                                 default = nil)
  if valid_568446 != nil:
    section.add "resourceGroupName", valid_568446
  var valid_568447 = path.getOrDefault("networkName")
  valid_568447 = validateParameter(valid_568447, JString, required = true,
                                 default = nil)
  if valid_568447 != nil:
    section.add "networkName", valid_568447
  var valid_568448 = path.getOrDefault("subscriptionId")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = nil)
  if valid_568448 != nil:
    section.add "subscriptionId", valid_568448
  var valid_568449 = path.getOrDefault("resourceName")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "resourceName", valid_568449
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568450 = query.getOrDefault("api-version")
  valid_568450 = validateParameter(valid_568450, JString, required = true,
                                 default = nil)
  if valid_568450 != nil:
    section.add "api-version", valid_568450
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568451: Call_ReplicationNetworkMappingsGet_568441; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of an ASR network mapping
  ## 
  let valid = call_568451.validator(path, query, header, formData, body)
  let scheme = call_568451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568451.url(scheme.get, call_568451.host, call_568451.base,
                         call_568451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568451, url, valid)

proc call*(call_568452: Call_ReplicationNetworkMappingsGet_568441;
          networkMappingName: string; fabricName: string; resourceGroupName: string;
          apiVersion: string; networkName: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationNetworkMappingsGet
  ## Gets the details of an ASR network mapping
  ##   networkMappingName: string (required)
  ##                     : Network mapping name.
  ##   fabricName: string (required)
  ##             : Primary fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   networkName: string (required)
  ##              : Primary network name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_568453 = newJObject()
  var query_568454 = newJObject()
  add(path_568453, "networkMappingName", newJString(networkMappingName))
  add(path_568453, "fabricName", newJString(fabricName))
  add(path_568453, "resourceGroupName", newJString(resourceGroupName))
  add(query_568454, "api-version", newJString(apiVersion))
  add(path_568453, "networkName", newJString(networkName))
  add(path_568453, "subscriptionId", newJString(subscriptionId))
  add(path_568453, "resourceName", newJString(resourceName))
  result = call_568452.call(path_568453, query_568454, nil, nil, nil)

var replicationNetworkMappingsGet* = Call_ReplicationNetworkMappingsGet_568441(
    name: "replicationNetworkMappingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationNetworks/{networkName}/replicationNetworkMappings/{networkMappingName}",
    validator: validate_ReplicationNetworkMappingsGet_568442, base: "",
    url: url_ReplicationNetworkMappingsGet_568443, schemes: {Scheme.Https})
type
  Call_ReplicationNetworkMappingsUpdate_568485 = ref object of OpenApiRestCall_567668
proc url_ReplicationNetworkMappingsUpdate_568487(protocol: Scheme; host: string;
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

proc validate_ReplicationNetworkMappingsUpdate_568486(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update an ASR network mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkMappingName: JString (required)
  ##                     : Network mapping name.
  ##   fabricName: JString (required)
  ##             : Primary fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   networkName: JString (required)
  ##              : Primary network name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkMappingName` field"
  var valid_568488 = path.getOrDefault("networkMappingName")
  valid_568488 = validateParameter(valid_568488, JString, required = true,
                                 default = nil)
  if valid_568488 != nil:
    section.add "networkMappingName", valid_568488
  var valid_568489 = path.getOrDefault("fabricName")
  valid_568489 = validateParameter(valid_568489, JString, required = true,
                                 default = nil)
  if valid_568489 != nil:
    section.add "fabricName", valid_568489
  var valid_568490 = path.getOrDefault("resourceGroupName")
  valid_568490 = validateParameter(valid_568490, JString, required = true,
                                 default = nil)
  if valid_568490 != nil:
    section.add "resourceGroupName", valid_568490
  var valid_568491 = path.getOrDefault("networkName")
  valid_568491 = validateParameter(valid_568491, JString, required = true,
                                 default = nil)
  if valid_568491 != nil:
    section.add "networkName", valid_568491
  var valid_568492 = path.getOrDefault("subscriptionId")
  valid_568492 = validateParameter(valid_568492, JString, required = true,
                                 default = nil)
  if valid_568492 != nil:
    section.add "subscriptionId", valid_568492
  var valid_568493 = path.getOrDefault("resourceName")
  valid_568493 = validateParameter(valid_568493, JString, required = true,
                                 default = nil)
  if valid_568493 != nil:
    section.add "resourceName", valid_568493
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568494 = query.getOrDefault("api-version")
  valid_568494 = validateParameter(valid_568494, JString, required = true,
                                 default = nil)
  if valid_568494 != nil:
    section.add "api-version", valid_568494
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

proc call*(call_568496: Call_ReplicationNetworkMappingsUpdate_568485;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to update an ASR network mapping.
  ## 
  let valid = call_568496.validator(path, query, header, formData, body)
  let scheme = call_568496.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568496.url(scheme.get, call_568496.host, call_568496.base,
                         call_568496.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568496, url, valid)

proc call*(call_568497: Call_ReplicationNetworkMappingsUpdate_568485;
          networkMappingName: string; fabricName: string; resourceGroupName: string;
          apiVersion: string; networkName: string; subscriptionId: string;
          input: JsonNode; resourceName: string): Recallable =
  ## replicationNetworkMappingsUpdate
  ## The operation to update an ASR network mapping.
  ##   networkMappingName: string (required)
  ##                     : Network mapping name.
  ##   fabricName: string (required)
  ##             : Primary fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   networkName: string (required)
  ##              : Primary network name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   input: JObject (required)
  ##        : Update network mapping input.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_568498 = newJObject()
  var query_568499 = newJObject()
  var body_568500 = newJObject()
  add(path_568498, "networkMappingName", newJString(networkMappingName))
  add(path_568498, "fabricName", newJString(fabricName))
  add(path_568498, "resourceGroupName", newJString(resourceGroupName))
  add(query_568499, "api-version", newJString(apiVersion))
  add(path_568498, "networkName", newJString(networkName))
  add(path_568498, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_568500 = input
  add(path_568498, "resourceName", newJString(resourceName))
  result = call_568497.call(path_568498, query_568499, nil, nil, body_568500)

var replicationNetworkMappingsUpdate* = Call_ReplicationNetworkMappingsUpdate_568485(
    name: "replicationNetworkMappingsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationNetworks/{networkName}/replicationNetworkMappings/{networkMappingName}",
    validator: validate_ReplicationNetworkMappingsUpdate_568486, base: "",
    url: url_ReplicationNetworkMappingsUpdate_568487, schemes: {Scheme.Https})
type
  Call_ReplicationNetworkMappingsDelete_568471 = ref object of OpenApiRestCall_567668
proc url_ReplicationNetworkMappingsDelete_568473(protocol: Scheme; host: string;
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

proc validate_ReplicationNetworkMappingsDelete_568472(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete a network mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkMappingName: JString (required)
  ##                     : ARM Resource Name for network mapping.
  ##   fabricName: JString (required)
  ##             : Primary fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   networkName: JString (required)
  ##              : Primary network name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkMappingName` field"
  var valid_568474 = path.getOrDefault("networkMappingName")
  valid_568474 = validateParameter(valid_568474, JString, required = true,
                                 default = nil)
  if valid_568474 != nil:
    section.add "networkMappingName", valid_568474
  var valid_568475 = path.getOrDefault("fabricName")
  valid_568475 = validateParameter(valid_568475, JString, required = true,
                                 default = nil)
  if valid_568475 != nil:
    section.add "fabricName", valid_568475
  var valid_568476 = path.getOrDefault("resourceGroupName")
  valid_568476 = validateParameter(valid_568476, JString, required = true,
                                 default = nil)
  if valid_568476 != nil:
    section.add "resourceGroupName", valid_568476
  var valid_568477 = path.getOrDefault("networkName")
  valid_568477 = validateParameter(valid_568477, JString, required = true,
                                 default = nil)
  if valid_568477 != nil:
    section.add "networkName", valid_568477
  var valid_568478 = path.getOrDefault("subscriptionId")
  valid_568478 = validateParameter(valid_568478, JString, required = true,
                                 default = nil)
  if valid_568478 != nil:
    section.add "subscriptionId", valid_568478
  var valid_568479 = path.getOrDefault("resourceName")
  valid_568479 = validateParameter(valid_568479, JString, required = true,
                                 default = nil)
  if valid_568479 != nil:
    section.add "resourceName", valid_568479
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568480 = query.getOrDefault("api-version")
  valid_568480 = validateParameter(valid_568480, JString, required = true,
                                 default = nil)
  if valid_568480 != nil:
    section.add "api-version", valid_568480
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568481: Call_ReplicationNetworkMappingsDelete_568471;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete a network mapping.
  ## 
  let valid = call_568481.validator(path, query, header, formData, body)
  let scheme = call_568481.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568481.url(scheme.get, call_568481.host, call_568481.base,
                         call_568481.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568481, url, valid)

proc call*(call_568482: Call_ReplicationNetworkMappingsDelete_568471;
          networkMappingName: string; fabricName: string; resourceGroupName: string;
          apiVersion: string; networkName: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationNetworkMappingsDelete
  ## The operation to delete a network mapping.
  ##   networkMappingName: string (required)
  ##                     : ARM Resource Name for network mapping.
  ##   fabricName: string (required)
  ##             : Primary fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   networkName: string (required)
  ##              : Primary network name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_568483 = newJObject()
  var query_568484 = newJObject()
  add(path_568483, "networkMappingName", newJString(networkMappingName))
  add(path_568483, "fabricName", newJString(fabricName))
  add(path_568483, "resourceGroupName", newJString(resourceGroupName))
  add(query_568484, "api-version", newJString(apiVersion))
  add(path_568483, "networkName", newJString(networkName))
  add(path_568483, "subscriptionId", newJString(subscriptionId))
  add(path_568483, "resourceName", newJString(resourceName))
  result = call_568482.call(path_568483, query_568484, nil, nil, nil)

var replicationNetworkMappingsDelete* = Call_ReplicationNetworkMappingsDelete_568471(
    name: "replicationNetworkMappingsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationNetworks/{networkName}/replicationNetworkMappings/{networkMappingName}",
    validator: validate_ReplicationNetworkMappingsDelete_568472, base: "",
    url: url_ReplicationNetworkMappingsDelete_568473, schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersListByReplicationFabrics_568501 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectionContainersListByReplicationFabrics_568503(
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

proc validate_ReplicationProtectionContainersListByReplicationFabrics_568502(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the protection containers in the specified fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568504 = path.getOrDefault("fabricName")
  valid_568504 = validateParameter(valid_568504, JString, required = true,
                                 default = nil)
  if valid_568504 != nil:
    section.add "fabricName", valid_568504
  var valid_568505 = path.getOrDefault("resourceGroupName")
  valid_568505 = validateParameter(valid_568505, JString, required = true,
                                 default = nil)
  if valid_568505 != nil:
    section.add "resourceGroupName", valid_568505
  var valid_568506 = path.getOrDefault("subscriptionId")
  valid_568506 = validateParameter(valid_568506, JString, required = true,
                                 default = nil)
  if valid_568506 != nil:
    section.add "subscriptionId", valid_568506
  var valid_568507 = path.getOrDefault("resourceName")
  valid_568507 = validateParameter(valid_568507, JString, required = true,
                                 default = nil)
  if valid_568507 != nil:
    section.add "resourceName", valid_568507
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568508 = query.getOrDefault("api-version")
  valid_568508 = validateParameter(valid_568508, JString, required = true,
                                 default = nil)
  if valid_568508 != nil:
    section.add "api-version", valid_568508
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568509: Call_ReplicationProtectionContainersListByReplicationFabrics_568501;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the protection containers in the specified fabric.
  ## 
  let valid = call_568509.validator(path, query, header, formData, body)
  let scheme = call_568509.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568509.url(scheme.get, call_568509.host, call_568509.base,
                         call_568509.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568509, url, valid)

proc call*(call_568510: Call_ReplicationProtectionContainersListByReplicationFabrics_568501;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string): Recallable =
  ## replicationProtectionContainersListByReplicationFabrics
  ## Lists the protection containers in the specified fabric.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_568511 = newJObject()
  var query_568512 = newJObject()
  add(path_568511, "fabricName", newJString(fabricName))
  add(path_568511, "resourceGroupName", newJString(resourceGroupName))
  add(query_568512, "api-version", newJString(apiVersion))
  add(path_568511, "subscriptionId", newJString(subscriptionId))
  add(path_568511, "resourceName", newJString(resourceName))
  result = call_568510.call(path_568511, query_568512, nil, nil, nil)

var replicationProtectionContainersListByReplicationFabrics* = Call_ReplicationProtectionContainersListByReplicationFabrics_568501(
    name: "replicationProtectionContainersListByReplicationFabrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers", validator: validate_ReplicationProtectionContainersListByReplicationFabrics_568502,
    base: "", url: url_ReplicationProtectionContainersListByReplicationFabrics_568503,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersCreate_568526 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectionContainersCreate_568528(protocol: Scheme;
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

proc validate_ReplicationProtectionContainersCreate_568527(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Operation to create a protection container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Unique fabric ARM name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Unique protection container ARM name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568529 = path.getOrDefault("fabricName")
  valid_568529 = validateParameter(valid_568529, JString, required = true,
                                 default = nil)
  if valid_568529 != nil:
    section.add "fabricName", valid_568529
  var valid_568530 = path.getOrDefault("resourceGroupName")
  valid_568530 = validateParameter(valid_568530, JString, required = true,
                                 default = nil)
  if valid_568530 != nil:
    section.add "resourceGroupName", valid_568530
  var valid_568531 = path.getOrDefault("subscriptionId")
  valid_568531 = validateParameter(valid_568531, JString, required = true,
                                 default = nil)
  if valid_568531 != nil:
    section.add "subscriptionId", valid_568531
  var valid_568532 = path.getOrDefault("resourceName")
  valid_568532 = validateParameter(valid_568532, JString, required = true,
                                 default = nil)
  if valid_568532 != nil:
    section.add "resourceName", valid_568532
  var valid_568533 = path.getOrDefault("protectionContainerName")
  valid_568533 = validateParameter(valid_568533, JString, required = true,
                                 default = nil)
  if valid_568533 != nil:
    section.add "protectionContainerName", valid_568533
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568534 = query.getOrDefault("api-version")
  valid_568534 = validateParameter(valid_568534, JString, required = true,
                                 default = nil)
  if valid_568534 != nil:
    section.add "api-version", valid_568534
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

proc call*(call_568536: Call_ReplicationProtectionContainersCreate_568526;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to create a protection container.
  ## 
  let valid = call_568536.validator(path, query, header, formData, body)
  let scheme = call_568536.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568536.url(scheme.get, call_568536.host, call_568536.base,
                         call_568536.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568536, url, valid)

proc call*(call_568537: Call_ReplicationProtectionContainersCreate_568526;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          creationInput: JsonNode; subscriptionId: string; resourceName: string;
          protectionContainerName: string): Recallable =
  ## replicationProtectionContainersCreate
  ## Operation to create a protection container.
  ##   fabricName: string (required)
  ##             : Unique fabric ARM name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   creationInput: JObject (required)
  ##                : Creation input.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Unique protection container ARM name.
  var path_568538 = newJObject()
  var query_568539 = newJObject()
  var body_568540 = newJObject()
  add(path_568538, "fabricName", newJString(fabricName))
  add(path_568538, "resourceGroupName", newJString(resourceGroupName))
  add(query_568539, "api-version", newJString(apiVersion))
  if creationInput != nil:
    body_568540 = creationInput
  add(path_568538, "subscriptionId", newJString(subscriptionId))
  add(path_568538, "resourceName", newJString(resourceName))
  add(path_568538, "protectionContainerName", newJString(protectionContainerName))
  result = call_568537.call(path_568538, query_568539, nil, nil, body_568540)

var replicationProtectionContainersCreate* = Call_ReplicationProtectionContainersCreate_568526(
    name: "replicationProtectionContainersCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}",
    validator: validate_ReplicationProtectionContainersCreate_568527, base: "",
    url: url_ReplicationProtectionContainersCreate_568528, schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersGet_568513 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectionContainersGet_568515(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectionContainersGet_568514(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of a protection container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568516 = path.getOrDefault("fabricName")
  valid_568516 = validateParameter(valid_568516, JString, required = true,
                                 default = nil)
  if valid_568516 != nil:
    section.add "fabricName", valid_568516
  var valid_568517 = path.getOrDefault("resourceGroupName")
  valid_568517 = validateParameter(valid_568517, JString, required = true,
                                 default = nil)
  if valid_568517 != nil:
    section.add "resourceGroupName", valid_568517
  var valid_568518 = path.getOrDefault("subscriptionId")
  valid_568518 = validateParameter(valid_568518, JString, required = true,
                                 default = nil)
  if valid_568518 != nil:
    section.add "subscriptionId", valid_568518
  var valid_568519 = path.getOrDefault("resourceName")
  valid_568519 = validateParameter(valid_568519, JString, required = true,
                                 default = nil)
  if valid_568519 != nil:
    section.add "resourceName", valid_568519
  var valid_568520 = path.getOrDefault("protectionContainerName")
  valid_568520 = validateParameter(valid_568520, JString, required = true,
                                 default = nil)
  if valid_568520 != nil:
    section.add "protectionContainerName", valid_568520
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568521 = query.getOrDefault("api-version")
  valid_568521 = validateParameter(valid_568521, JString, required = true,
                                 default = nil)
  if valid_568521 != nil:
    section.add "api-version", valid_568521
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568522: Call_ReplicationProtectionContainersGet_568513;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of a protection container.
  ## 
  let valid = call_568522.validator(path, query, header, formData, body)
  let scheme = call_568522.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568522.url(scheme.get, call_568522.host, call_568522.base,
                         call_568522.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568522, url, valid)

proc call*(call_568523: Call_ReplicationProtectionContainersGet_568513;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string): Recallable =
  ## replicationProtectionContainersGet
  ## Gets the details of a protection container.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  var path_568524 = newJObject()
  var query_568525 = newJObject()
  add(path_568524, "fabricName", newJString(fabricName))
  add(path_568524, "resourceGroupName", newJString(resourceGroupName))
  add(query_568525, "api-version", newJString(apiVersion))
  add(path_568524, "subscriptionId", newJString(subscriptionId))
  add(path_568524, "resourceName", newJString(resourceName))
  add(path_568524, "protectionContainerName", newJString(protectionContainerName))
  result = call_568523.call(path_568524, query_568525, nil, nil, nil)

var replicationProtectionContainersGet* = Call_ReplicationProtectionContainersGet_568513(
    name: "replicationProtectionContainersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}",
    validator: validate_ReplicationProtectionContainersGet_568514, base: "",
    url: url_ReplicationProtectionContainersGet_568515, schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersDiscoverProtectableItem_568541 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectionContainersDiscoverProtectableItem_568543(
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

proc validate_ReplicationProtectionContainersDiscoverProtectableItem_568542(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The operation to a add a protectable item to a protection container(Add physical server.)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The name of the fabric.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : The name of the protection container.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568544 = path.getOrDefault("fabricName")
  valid_568544 = validateParameter(valid_568544, JString, required = true,
                                 default = nil)
  if valid_568544 != nil:
    section.add "fabricName", valid_568544
  var valid_568545 = path.getOrDefault("resourceGroupName")
  valid_568545 = validateParameter(valid_568545, JString, required = true,
                                 default = nil)
  if valid_568545 != nil:
    section.add "resourceGroupName", valid_568545
  var valid_568546 = path.getOrDefault("subscriptionId")
  valid_568546 = validateParameter(valid_568546, JString, required = true,
                                 default = nil)
  if valid_568546 != nil:
    section.add "subscriptionId", valid_568546
  var valid_568547 = path.getOrDefault("resourceName")
  valid_568547 = validateParameter(valid_568547, JString, required = true,
                                 default = nil)
  if valid_568547 != nil:
    section.add "resourceName", valid_568547
  var valid_568548 = path.getOrDefault("protectionContainerName")
  valid_568548 = validateParameter(valid_568548, JString, required = true,
                                 default = nil)
  if valid_568548 != nil:
    section.add "protectionContainerName", valid_568548
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568549 = query.getOrDefault("api-version")
  valid_568549 = validateParameter(valid_568549, JString, required = true,
                                 default = nil)
  if valid_568549 != nil:
    section.add "api-version", valid_568549
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

proc call*(call_568551: Call_ReplicationProtectionContainersDiscoverProtectableItem_568541;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to a add a protectable item to a protection container(Add physical server.)
  ## 
  let valid = call_568551.validator(path, query, header, formData, body)
  let scheme = call_568551.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568551.url(scheme.get, call_568551.host, call_568551.base,
                         call_568551.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568551, url, valid)

proc call*(call_568552: Call_ReplicationProtectionContainersDiscoverProtectableItem_568541;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string;
          discoverProtectableItemRequest: JsonNode): Recallable =
  ## replicationProtectionContainersDiscoverProtectableItem
  ## The operation to a add a protectable item to a protection container(Add physical server.)
  ##   fabricName: string (required)
  ##             : The name of the fabric.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : The name of the protection container.
  ##   discoverProtectableItemRequest: JObject (required)
  ##                                 : The request object to add a protectable item.
  var path_568553 = newJObject()
  var query_568554 = newJObject()
  var body_568555 = newJObject()
  add(path_568553, "fabricName", newJString(fabricName))
  add(path_568553, "resourceGroupName", newJString(resourceGroupName))
  add(query_568554, "api-version", newJString(apiVersion))
  add(path_568553, "subscriptionId", newJString(subscriptionId))
  add(path_568553, "resourceName", newJString(resourceName))
  add(path_568553, "protectionContainerName", newJString(protectionContainerName))
  if discoverProtectableItemRequest != nil:
    body_568555 = discoverProtectableItemRequest
  result = call_568552.call(path_568553, query_568554, nil, nil, body_568555)

var replicationProtectionContainersDiscoverProtectableItem* = Call_ReplicationProtectionContainersDiscoverProtectableItem_568541(
    name: "replicationProtectionContainersDiscoverProtectableItem",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/discoverProtectableItem",
    validator: validate_ReplicationProtectionContainersDiscoverProtectableItem_568542,
    base: "", url: url_ReplicationProtectionContainersDiscoverProtectableItem_568543,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersDelete_568556 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectionContainersDelete_568558(protocol: Scheme;
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

proc validate_ReplicationProtectionContainersDelete_568557(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Operation to remove a protection container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Unique fabric ARM name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Unique protection container ARM name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568559 = path.getOrDefault("fabricName")
  valid_568559 = validateParameter(valid_568559, JString, required = true,
                                 default = nil)
  if valid_568559 != nil:
    section.add "fabricName", valid_568559
  var valid_568560 = path.getOrDefault("resourceGroupName")
  valid_568560 = validateParameter(valid_568560, JString, required = true,
                                 default = nil)
  if valid_568560 != nil:
    section.add "resourceGroupName", valid_568560
  var valid_568561 = path.getOrDefault("subscriptionId")
  valid_568561 = validateParameter(valid_568561, JString, required = true,
                                 default = nil)
  if valid_568561 != nil:
    section.add "subscriptionId", valid_568561
  var valid_568562 = path.getOrDefault("resourceName")
  valid_568562 = validateParameter(valid_568562, JString, required = true,
                                 default = nil)
  if valid_568562 != nil:
    section.add "resourceName", valid_568562
  var valid_568563 = path.getOrDefault("protectionContainerName")
  valid_568563 = validateParameter(valid_568563, JString, required = true,
                                 default = nil)
  if valid_568563 != nil:
    section.add "protectionContainerName", valid_568563
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568564 = query.getOrDefault("api-version")
  valid_568564 = validateParameter(valid_568564, JString, required = true,
                                 default = nil)
  if valid_568564 != nil:
    section.add "api-version", valid_568564
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568565: Call_ReplicationProtectionContainersDelete_568556;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to remove a protection container.
  ## 
  let valid = call_568565.validator(path, query, header, formData, body)
  let scheme = call_568565.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568565.url(scheme.get, call_568565.host, call_568565.base,
                         call_568565.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568565, url, valid)

proc call*(call_568566: Call_ReplicationProtectionContainersDelete_568556;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string): Recallable =
  ## replicationProtectionContainersDelete
  ## Operation to remove a protection container.
  ##   fabricName: string (required)
  ##             : Unique fabric ARM name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Unique protection container ARM name.
  var path_568567 = newJObject()
  var query_568568 = newJObject()
  add(path_568567, "fabricName", newJString(fabricName))
  add(path_568567, "resourceGroupName", newJString(resourceGroupName))
  add(query_568568, "api-version", newJString(apiVersion))
  add(path_568567, "subscriptionId", newJString(subscriptionId))
  add(path_568567, "resourceName", newJString(resourceName))
  add(path_568567, "protectionContainerName", newJString(protectionContainerName))
  result = call_568566.call(path_568567, query_568568, nil, nil, nil)

var replicationProtectionContainersDelete* = Call_ReplicationProtectionContainersDelete_568556(
    name: "replicationProtectionContainersDelete", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/remove",
    validator: validate_ReplicationProtectionContainersDelete_568557, base: "",
    url: url_ReplicationProtectionContainersDelete_568558, schemes: {Scheme.Https})
type
  Call_ReplicationMigrationItemsListByReplicationProtectionContainers_568569 = ref object of OpenApiRestCall_567668
proc url_ReplicationMigrationItemsListByReplicationProtectionContainers_568571(
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

proc validate_ReplicationMigrationItemsListByReplicationProtectionContainers_568570(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the list of ASR migration items in the protection container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568572 = path.getOrDefault("fabricName")
  valid_568572 = validateParameter(valid_568572, JString, required = true,
                                 default = nil)
  if valid_568572 != nil:
    section.add "fabricName", valid_568572
  var valid_568573 = path.getOrDefault("resourceGroupName")
  valid_568573 = validateParameter(valid_568573, JString, required = true,
                                 default = nil)
  if valid_568573 != nil:
    section.add "resourceGroupName", valid_568573
  var valid_568574 = path.getOrDefault("subscriptionId")
  valid_568574 = validateParameter(valid_568574, JString, required = true,
                                 default = nil)
  if valid_568574 != nil:
    section.add "subscriptionId", valid_568574
  var valid_568575 = path.getOrDefault("resourceName")
  valid_568575 = validateParameter(valid_568575, JString, required = true,
                                 default = nil)
  if valid_568575 != nil:
    section.add "resourceName", valid_568575
  var valid_568576 = path.getOrDefault("protectionContainerName")
  valid_568576 = validateParameter(valid_568576, JString, required = true,
                                 default = nil)
  if valid_568576 != nil:
    section.add "protectionContainerName", valid_568576
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568577 = query.getOrDefault("api-version")
  valid_568577 = validateParameter(valid_568577, JString, required = true,
                                 default = nil)
  if valid_568577 != nil:
    section.add "api-version", valid_568577
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568578: Call_ReplicationMigrationItemsListByReplicationProtectionContainers_568569;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the list of ASR migration items in the protection container.
  ## 
  let valid = call_568578.validator(path, query, header, formData, body)
  let scheme = call_568578.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568578.url(scheme.get, call_568578.host, call_568578.base,
                         call_568578.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568578, url, valid)

proc call*(call_568579: Call_ReplicationMigrationItemsListByReplicationProtectionContainers_568569;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string): Recallable =
  ## replicationMigrationItemsListByReplicationProtectionContainers
  ## Gets the list of ASR migration items in the protection container.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  var path_568580 = newJObject()
  var query_568581 = newJObject()
  add(path_568580, "fabricName", newJString(fabricName))
  add(path_568580, "resourceGroupName", newJString(resourceGroupName))
  add(query_568581, "api-version", newJString(apiVersion))
  add(path_568580, "subscriptionId", newJString(subscriptionId))
  add(path_568580, "resourceName", newJString(resourceName))
  add(path_568580, "protectionContainerName", newJString(protectionContainerName))
  result = call_568579.call(path_568580, query_568581, nil, nil, nil)

var replicationMigrationItemsListByReplicationProtectionContainers* = Call_ReplicationMigrationItemsListByReplicationProtectionContainers_568569(
    name: "replicationMigrationItemsListByReplicationProtectionContainers",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationMigrationItems", validator: validate_ReplicationMigrationItemsListByReplicationProtectionContainers_568570,
    base: "",
    url: url_ReplicationMigrationItemsListByReplicationProtectionContainers_568571,
    schemes: {Scheme.Https})
type
  Call_ReplicationMigrationItemsCreate_568596 = ref object of OpenApiRestCall_567668
proc url_ReplicationMigrationItemsCreate_568598(protocol: Scheme; host: string;
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

proc validate_ReplicationMigrationItemsCreate_568597(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create an ASR migration item (enable migration).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   migrationItemName: JString (required)
  ##                    : Migration item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568599 = path.getOrDefault("fabricName")
  valid_568599 = validateParameter(valid_568599, JString, required = true,
                                 default = nil)
  if valid_568599 != nil:
    section.add "fabricName", valid_568599
  var valid_568600 = path.getOrDefault("resourceGroupName")
  valid_568600 = validateParameter(valid_568600, JString, required = true,
                                 default = nil)
  if valid_568600 != nil:
    section.add "resourceGroupName", valid_568600
  var valid_568601 = path.getOrDefault("subscriptionId")
  valid_568601 = validateParameter(valid_568601, JString, required = true,
                                 default = nil)
  if valid_568601 != nil:
    section.add "subscriptionId", valid_568601
  var valid_568602 = path.getOrDefault("resourceName")
  valid_568602 = validateParameter(valid_568602, JString, required = true,
                                 default = nil)
  if valid_568602 != nil:
    section.add "resourceName", valid_568602
  var valid_568603 = path.getOrDefault("protectionContainerName")
  valid_568603 = validateParameter(valid_568603, JString, required = true,
                                 default = nil)
  if valid_568603 != nil:
    section.add "protectionContainerName", valid_568603
  var valid_568604 = path.getOrDefault("migrationItemName")
  valid_568604 = validateParameter(valid_568604, JString, required = true,
                                 default = nil)
  if valid_568604 != nil:
    section.add "migrationItemName", valid_568604
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568605 = query.getOrDefault("api-version")
  valid_568605 = validateParameter(valid_568605, JString, required = true,
                                 default = nil)
  if valid_568605 != nil:
    section.add "api-version", valid_568605
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

proc call*(call_568607: Call_ReplicationMigrationItemsCreate_568596;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create an ASR migration item (enable migration).
  ## 
  let valid = call_568607.validator(path, query, header, formData, body)
  let scheme = call_568607.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568607.url(scheme.get, call_568607.host, call_568607.base,
                         call_568607.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568607, url, valid)

proc call*(call_568608: Call_ReplicationMigrationItemsCreate_568596;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; input: JsonNode; resourceName: string;
          protectionContainerName: string; migrationItemName: string): Recallable =
  ## replicationMigrationItemsCreate
  ## The operation to create an ASR migration item (enable migration).
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   input: JObject (required)
  ##        : Enable migration input.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   migrationItemName: string (required)
  ##                    : Migration item name.
  var path_568609 = newJObject()
  var query_568610 = newJObject()
  var body_568611 = newJObject()
  add(path_568609, "fabricName", newJString(fabricName))
  add(path_568609, "resourceGroupName", newJString(resourceGroupName))
  add(query_568610, "api-version", newJString(apiVersion))
  add(path_568609, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_568611 = input
  add(path_568609, "resourceName", newJString(resourceName))
  add(path_568609, "protectionContainerName", newJString(protectionContainerName))
  add(path_568609, "migrationItemName", newJString(migrationItemName))
  result = call_568608.call(path_568609, query_568610, nil, nil, body_568611)

var replicationMigrationItemsCreate* = Call_ReplicationMigrationItemsCreate_568596(
    name: "replicationMigrationItemsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationMigrationItems/{migrationItemName}",
    validator: validate_ReplicationMigrationItemsCreate_568597, base: "",
    url: url_ReplicationMigrationItemsCreate_568598, schemes: {Scheme.Https})
type
  Call_ReplicationMigrationItemsGet_568582 = ref object of OpenApiRestCall_567668
proc url_ReplicationMigrationItemsGet_568584(protocol: Scheme; host: string;
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

proc validate_ReplicationMigrationItemsGet_568583(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric unique name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   migrationItemName: JString (required)
  ##                    : Migration item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568585 = path.getOrDefault("fabricName")
  valid_568585 = validateParameter(valid_568585, JString, required = true,
                                 default = nil)
  if valid_568585 != nil:
    section.add "fabricName", valid_568585
  var valid_568586 = path.getOrDefault("resourceGroupName")
  valid_568586 = validateParameter(valid_568586, JString, required = true,
                                 default = nil)
  if valid_568586 != nil:
    section.add "resourceGroupName", valid_568586
  var valid_568587 = path.getOrDefault("subscriptionId")
  valid_568587 = validateParameter(valid_568587, JString, required = true,
                                 default = nil)
  if valid_568587 != nil:
    section.add "subscriptionId", valid_568587
  var valid_568588 = path.getOrDefault("resourceName")
  valid_568588 = validateParameter(valid_568588, JString, required = true,
                                 default = nil)
  if valid_568588 != nil:
    section.add "resourceName", valid_568588
  var valid_568589 = path.getOrDefault("protectionContainerName")
  valid_568589 = validateParameter(valid_568589, JString, required = true,
                                 default = nil)
  if valid_568589 != nil:
    section.add "protectionContainerName", valid_568589
  var valid_568590 = path.getOrDefault("migrationItemName")
  valid_568590 = validateParameter(valid_568590, JString, required = true,
                                 default = nil)
  if valid_568590 != nil:
    section.add "migrationItemName", valid_568590
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568591 = query.getOrDefault("api-version")
  valid_568591 = validateParameter(valid_568591, JString, required = true,
                                 default = nil)
  if valid_568591 != nil:
    section.add "api-version", valid_568591
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568592: Call_ReplicationMigrationItemsGet_568582; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568592.validator(path, query, header, formData, body)
  let scheme = call_568592.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568592.url(scheme.get, call_568592.host, call_568592.base,
                         call_568592.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568592, url, valid)

proc call*(call_568593: Call_ReplicationMigrationItemsGet_568582;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; migrationItemName: string): Recallable =
  ## replicationMigrationItemsGet
  ##   fabricName: string (required)
  ##             : Fabric unique name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   migrationItemName: string (required)
  ##                    : Migration item name.
  var path_568594 = newJObject()
  var query_568595 = newJObject()
  add(path_568594, "fabricName", newJString(fabricName))
  add(path_568594, "resourceGroupName", newJString(resourceGroupName))
  add(query_568595, "api-version", newJString(apiVersion))
  add(path_568594, "subscriptionId", newJString(subscriptionId))
  add(path_568594, "resourceName", newJString(resourceName))
  add(path_568594, "protectionContainerName", newJString(protectionContainerName))
  add(path_568594, "migrationItemName", newJString(migrationItemName))
  result = call_568593.call(path_568594, query_568595, nil, nil, nil)

var replicationMigrationItemsGet* = Call_ReplicationMigrationItemsGet_568582(
    name: "replicationMigrationItemsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationMigrationItems/{migrationItemName}",
    validator: validate_ReplicationMigrationItemsGet_568583, base: "",
    url: url_ReplicationMigrationItemsGet_568584, schemes: {Scheme.Https})
type
  Call_ReplicationMigrationItemsUpdate_568627 = ref object of OpenApiRestCall_567668
proc url_ReplicationMigrationItemsUpdate_568629(protocol: Scheme; host: string;
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

proc validate_ReplicationMigrationItemsUpdate_568628(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update the recovery settings of an ASR migration item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   migrationItemName: JString (required)
  ##                    : Migration item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568630 = path.getOrDefault("fabricName")
  valid_568630 = validateParameter(valid_568630, JString, required = true,
                                 default = nil)
  if valid_568630 != nil:
    section.add "fabricName", valid_568630
  var valid_568631 = path.getOrDefault("resourceGroupName")
  valid_568631 = validateParameter(valid_568631, JString, required = true,
                                 default = nil)
  if valid_568631 != nil:
    section.add "resourceGroupName", valid_568631
  var valid_568632 = path.getOrDefault("subscriptionId")
  valid_568632 = validateParameter(valid_568632, JString, required = true,
                                 default = nil)
  if valid_568632 != nil:
    section.add "subscriptionId", valid_568632
  var valid_568633 = path.getOrDefault("resourceName")
  valid_568633 = validateParameter(valid_568633, JString, required = true,
                                 default = nil)
  if valid_568633 != nil:
    section.add "resourceName", valid_568633
  var valid_568634 = path.getOrDefault("protectionContainerName")
  valid_568634 = validateParameter(valid_568634, JString, required = true,
                                 default = nil)
  if valid_568634 != nil:
    section.add "protectionContainerName", valid_568634
  var valid_568635 = path.getOrDefault("migrationItemName")
  valid_568635 = validateParameter(valid_568635, JString, required = true,
                                 default = nil)
  if valid_568635 != nil:
    section.add "migrationItemName", valid_568635
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568636 = query.getOrDefault("api-version")
  valid_568636 = validateParameter(valid_568636, JString, required = true,
                                 default = nil)
  if valid_568636 != nil:
    section.add "api-version", valid_568636
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

proc call*(call_568638: Call_ReplicationMigrationItemsUpdate_568627;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to update the recovery settings of an ASR migration item.
  ## 
  let valid = call_568638.validator(path, query, header, formData, body)
  let scheme = call_568638.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568638.url(scheme.get, call_568638.host, call_568638.base,
                         call_568638.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568638, url, valid)

proc call*(call_568639: Call_ReplicationMigrationItemsUpdate_568627;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; input: JsonNode; resourceName: string;
          protectionContainerName: string; migrationItemName: string): Recallable =
  ## replicationMigrationItemsUpdate
  ## The operation to update the recovery settings of an ASR migration item.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   input: JObject (required)
  ##        : Update migration item input.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   migrationItemName: string (required)
  ##                    : Migration item name.
  var path_568640 = newJObject()
  var query_568641 = newJObject()
  var body_568642 = newJObject()
  add(path_568640, "fabricName", newJString(fabricName))
  add(path_568640, "resourceGroupName", newJString(resourceGroupName))
  add(query_568641, "api-version", newJString(apiVersion))
  add(path_568640, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_568642 = input
  add(path_568640, "resourceName", newJString(resourceName))
  add(path_568640, "protectionContainerName", newJString(protectionContainerName))
  add(path_568640, "migrationItemName", newJString(migrationItemName))
  result = call_568639.call(path_568640, query_568641, nil, nil, body_568642)

var replicationMigrationItemsUpdate* = Call_ReplicationMigrationItemsUpdate_568627(
    name: "replicationMigrationItemsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationMigrationItems/{migrationItemName}",
    validator: validate_ReplicationMigrationItemsUpdate_568628, base: "",
    url: url_ReplicationMigrationItemsUpdate_568629, schemes: {Scheme.Https})
type
  Call_ReplicationMigrationItemsDelete_568612 = ref object of OpenApiRestCall_567668
proc url_ReplicationMigrationItemsDelete_568614(protocol: Scheme; host: string;
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

proc validate_ReplicationMigrationItemsDelete_568613(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete an ASR migration item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   migrationItemName: JString (required)
  ##                    : Migration item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568615 = path.getOrDefault("fabricName")
  valid_568615 = validateParameter(valid_568615, JString, required = true,
                                 default = nil)
  if valid_568615 != nil:
    section.add "fabricName", valid_568615
  var valid_568616 = path.getOrDefault("resourceGroupName")
  valid_568616 = validateParameter(valid_568616, JString, required = true,
                                 default = nil)
  if valid_568616 != nil:
    section.add "resourceGroupName", valid_568616
  var valid_568617 = path.getOrDefault("subscriptionId")
  valid_568617 = validateParameter(valid_568617, JString, required = true,
                                 default = nil)
  if valid_568617 != nil:
    section.add "subscriptionId", valid_568617
  var valid_568618 = path.getOrDefault("resourceName")
  valid_568618 = validateParameter(valid_568618, JString, required = true,
                                 default = nil)
  if valid_568618 != nil:
    section.add "resourceName", valid_568618
  var valid_568619 = path.getOrDefault("protectionContainerName")
  valid_568619 = validateParameter(valid_568619, JString, required = true,
                                 default = nil)
  if valid_568619 != nil:
    section.add "protectionContainerName", valid_568619
  var valid_568620 = path.getOrDefault("migrationItemName")
  valid_568620 = validateParameter(valid_568620, JString, required = true,
                                 default = nil)
  if valid_568620 != nil:
    section.add "migrationItemName", valid_568620
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   deleteOption: JString
  ##               : The delete option.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568621 = query.getOrDefault("api-version")
  valid_568621 = validateParameter(valid_568621, JString, required = true,
                                 default = nil)
  if valid_568621 != nil:
    section.add "api-version", valid_568621
  var valid_568622 = query.getOrDefault("deleteOption")
  valid_568622 = validateParameter(valid_568622, JString, required = false,
                                 default = nil)
  if valid_568622 != nil:
    section.add "deleteOption", valid_568622
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568623: Call_ReplicationMigrationItemsDelete_568612;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete an ASR migration item.
  ## 
  let valid = call_568623.validator(path, query, header, formData, body)
  let scheme = call_568623.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568623.url(scheme.get, call_568623.host, call_568623.base,
                         call_568623.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568623, url, valid)

proc call*(call_568624: Call_ReplicationMigrationItemsDelete_568612;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; migrationItemName: string;
          deleteOption: string = ""): Recallable =
  ## replicationMigrationItemsDelete
  ## The operation to delete an ASR migration item.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   deleteOption: string
  ##               : The delete option.
  ##   migrationItemName: string (required)
  ##                    : Migration item name.
  var path_568625 = newJObject()
  var query_568626 = newJObject()
  add(path_568625, "fabricName", newJString(fabricName))
  add(path_568625, "resourceGroupName", newJString(resourceGroupName))
  add(query_568626, "api-version", newJString(apiVersion))
  add(path_568625, "subscriptionId", newJString(subscriptionId))
  add(path_568625, "resourceName", newJString(resourceName))
  add(path_568625, "protectionContainerName", newJString(protectionContainerName))
  add(query_568626, "deleteOption", newJString(deleteOption))
  add(path_568625, "migrationItemName", newJString(migrationItemName))
  result = call_568624.call(path_568625, query_568626, nil, nil, nil)

var replicationMigrationItemsDelete* = Call_ReplicationMigrationItemsDelete_568612(
    name: "replicationMigrationItemsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationMigrationItems/{migrationItemName}",
    validator: validate_ReplicationMigrationItemsDelete_568613, base: "",
    url: url_ReplicationMigrationItemsDelete_568614, schemes: {Scheme.Https})
type
  Call_ReplicationMigrationItemsMigrate_568643 = ref object of OpenApiRestCall_567668
proc url_ReplicationMigrationItemsMigrate_568645(protocol: Scheme; host: string;
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

proc validate_ReplicationMigrationItemsMigrate_568644(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to initiate migration of the item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   migrationItemName: JString (required)
  ##                    : Migration item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568646 = path.getOrDefault("fabricName")
  valid_568646 = validateParameter(valid_568646, JString, required = true,
                                 default = nil)
  if valid_568646 != nil:
    section.add "fabricName", valid_568646
  var valid_568647 = path.getOrDefault("resourceGroupName")
  valid_568647 = validateParameter(valid_568647, JString, required = true,
                                 default = nil)
  if valid_568647 != nil:
    section.add "resourceGroupName", valid_568647
  var valid_568648 = path.getOrDefault("subscriptionId")
  valid_568648 = validateParameter(valid_568648, JString, required = true,
                                 default = nil)
  if valid_568648 != nil:
    section.add "subscriptionId", valid_568648
  var valid_568649 = path.getOrDefault("resourceName")
  valid_568649 = validateParameter(valid_568649, JString, required = true,
                                 default = nil)
  if valid_568649 != nil:
    section.add "resourceName", valid_568649
  var valid_568650 = path.getOrDefault("protectionContainerName")
  valid_568650 = validateParameter(valid_568650, JString, required = true,
                                 default = nil)
  if valid_568650 != nil:
    section.add "protectionContainerName", valid_568650
  var valid_568651 = path.getOrDefault("migrationItemName")
  valid_568651 = validateParameter(valid_568651, JString, required = true,
                                 default = nil)
  if valid_568651 != nil:
    section.add "migrationItemName", valid_568651
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568652 = query.getOrDefault("api-version")
  valid_568652 = validateParameter(valid_568652, JString, required = true,
                                 default = nil)
  if valid_568652 != nil:
    section.add "api-version", valid_568652
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

proc call*(call_568654: Call_ReplicationMigrationItemsMigrate_568643;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to initiate migration of the item.
  ## 
  let valid = call_568654.validator(path, query, header, formData, body)
  let scheme = call_568654.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568654.url(scheme.get, call_568654.host, call_568654.base,
                         call_568654.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568654, url, valid)

proc call*(call_568655: Call_ReplicationMigrationItemsMigrate_568643;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; migrateInput: JsonNode;
          migrationItemName: string): Recallable =
  ## replicationMigrationItemsMigrate
  ## The operation to initiate migration of the item.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   migrateInput: JObject (required)
  ##               : Migrate input.
  ##   migrationItemName: string (required)
  ##                    : Migration item name.
  var path_568656 = newJObject()
  var query_568657 = newJObject()
  var body_568658 = newJObject()
  add(path_568656, "fabricName", newJString(fabricName))
  add(path_568656, "resourceGroupName", newJString(resourceGroupName))
  add(query_568657, "api-version", newJString(apiVersion))
  add(path_568656, "subscriptionId", newJString(subscriptionId))
  add(path_568656, "resourceName", newJString(resourceName))
  add(path_568656, "protectionContainerName", newJString(protectionContainerName))
  if migrateInput != nil:
    body_568658 = migrateInput
  add(path_568656, "migrationItemName", newJString(migrationItemName))
  result = call_568655.call(path_568656, query_568657, nil, nil, body_568658)

var replicationMigrationItemsMigrate* = Call_ReplicationMigrationItemsMigrate_568643(
    name: "replicationMigrationItemsMigrate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationMigrationItems/{migrationItemName}/migrate",
    validator: validate_ReplicationMigrationItemsMigrate_568644, base: "",
    url: url_ReplicationMigrationItemsMigrate_568645, schemes: {Scheme.Https})
type
  Call_MigrationRecoveryPointsListByReplicationMigrationItems_568659 = ref object of OpenApiRestCall_567668
proc url_MigrationRecoveryPointsListByReplicationMigrationItems_568661(
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

proc validate_MigrationRecoveryPointsListByReplicationMigrationItems_568660(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric unique name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   migrationItemName: JString (required)
  ##                    : Migration item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568662 = path.getOrDefault("fabricName")
  valid_568662 = validateParameter(valid_568662, JString, required = true,
                                 default = nil)
  if valid_568662 != nil:
    section.add "fabricName", valid_568662
  var valid_568663 = path.getOrDefault("resourceGroupName")
  valid_568663 = validateParameter(valid_568663, JString, required = true,
                                 default = nil)
  if valid_568663 != nil:
    section.add "resourceGroupName", valid_568663
  var valid_568664 = path.getOrDefault("subscriptionId")
  valid_568664 = validateParameter(valid_568664, JString, required = true,
                                 default = nil)
  if valid_568664 != nil:
    section.add "subscriptionId", valid_568664
  var valid_568665 = path.getOrDefault("resourceName")
  valid_568665 = validateParameter(valid_568665, JString, required = true,
                                 default = nil)
  if valid_568665 != nil:
    section.add "resourceName", valid_568665
  var valid_568666 = path.getOrDefault("protectionContainerName")
  valid_568666 = validateParameter(valid_568666, JString, required = true,
                                 default = nil)
  if valid_568666 != nil:
    section.add "protectionContainerName", valid_568666
  var valid_568667 = path.getOrDefault("migrationItemName")
  valid_568667 = validateParameter(valid_568667, JString, required = true,
                                 default = nil)
  if valid_568667 != nil:
    section.add "migrationItemName", valid_568667
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568668 = query.getOrDefault("api-version")
  valid_568668 = validateParameter(valid_568668, JString, required = true,
                                 default = nil)
  if valid_568668 != nil:
    section.add "api-version", valid_568668
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568669: Call_MigrationRecoveryPointsListByReplicationMigrationItems_568659;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_568669.validator(path, query, header, formData, body)
  let scheme = call_568669.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568669.url(scheme.get, call_568669.host, call_568669.base,
                         call_568669.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568669, url, valid)

proc call*(call_568670: Call_MigrationRecoveryPointsListByReplicationMigrationItems_568659;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; migrationItemName: string): Recallable =
  ## migrationRecoveryPointsListByReplicationMigrationItems
  ##   fabricName: string (required)
  ##             : Fabric unique name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   migrationItemName: string (required)
  ##                    : Migration item name.
  var path_568671 = newJObject()
  var query_568672 = newJObject()
  add(path_568671, "fabricName", newJString(fabricName))
  add(path_568671, "resourceGroupName", newJString(resourceGroupName))
  add(query_568672, "api-version", newJString(apiVersion))
  add(path_568671, "subscriptionId", newJString(subscriptionId))
  add(path_568671, "resourceName", newJString(resourceName))
  add(path_568671, "protectionContainerName", newJString(protectionContainerName))
  add(path_568671, "migrationItemName", newJString(migrationItemName))
  result = call_568670.call(path_568671, query_568672, nil, nil, nil)

var migrationRecoveryPointsListByReplicationMigrationItems* = Call_MigrationRecoveryPointsListByReplicationMigrationItems_568659(
    name: "migrationRecoveryPointsListByReplicationMigrationItems",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationMigrationItems/{migrationItemName}/migrationRecoveryPoints",
    validator: validate_MigrationRecoveryPointsListByReplicationMigrationItems_568660,
    base: "", url: url_MigrationRecoveryPointsListByReplicationMigrationItems_568661,
    schemes: {Scheme.Https})
type
  Call_MigrationRecoveryPointsGet_568673 = ref object of OpenApiRestCall_567668
proc url_MigrationRecoveryPointsGet_568675(protocol: Scheme; host: string;
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

proc validate_MigrationRecoveryPointsGet_568674(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric unique name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   migrationRecoveryPointName: JString (required)
  ##                             : The migration recovery point name.
  ##   migrationItemName: JString (required)
  ##                    : Migration item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568676 = path.getOrDefault("fabricName")
  valid_568676 = validateParameter(valid_568676, JString, required = true,
                                 default = nil)
  if valid_568676 != nil:
    section.add "fabricName", valid_568676
  var valid_568677 = path.getOrDefault("resourceGroupName")
  valid_568677 = validateParameter(valid_568677, JString, required = true,
                                 default = nil)
  if valid_568677 != nil:
    section.add "resourceGroupName", valid_568677
  var valid_568678 = path.getOrDefault("subscriptionId")
  valid_568678 = validateParameter(valid_568678, JString, required = true,
                                 default = nil)
  if valid_568678 != nil:
    section.add "subscriptionId", valid_568678
  var valid_568679 = path.getOrDefault("resourceName")
  valid_568679 = validateParameter(valid_568679, JString, required = true,
                                 default = nil)
  if valid_568679 != nil:
    section.add "resourceName", valid_568679
  var valid_568680 = path.getOrDefault("protectionContainerName")
  valid_568680 = validateParameter(valid_568680, JString, required = true,
                                 default = nil)
  if valid_568680 != nil:
    section.add "protectionContainerName", valid_568680
  var valid_568681 = path.getOrDefault("migrationRecoveryPointName")
  valid_568681 = validateParameter(valid_568681, JString, required = true,
                                 default = nil)
  if valid_568681 != nil:
    section.add "migrationRecoveryPointName", valid_568681
  var valid_568682 = path.getOrDefault("migrationItemName")
  valid_568682 = validateParameter(valid_568682, JString, required = true,
                                 default = nil)
  if valid_568682 != nil:
    section.add "migrationItemName", valid_568682
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568683 = query.getOrDefault("api-version")
  valid_568683 = validateParameter(valid_568683, JString, required = true,
                                 default = nil)
  if valid_568683 != nil:
    section.add "api-version", valid_568683
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568684: Call_MigrationRecoveryPointsGet_568673; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568684.validator(path, query, header, formData, body)
  let scheme = call_568684.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568684.url(scheme.get, call_568684.host, call_568684.base,
                         call_568684.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568684, url, valid)

proc call*(call_568685: Call_MigrationRecoveryPointsGet_568673; fabricName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; protectionContainerName: string;
          migrationRecoveryPointName: string; migrationItemName: string): Recallable =
  ## migrationRecoveryPointsGet
  ##   fabricName: string (required)
  ##             : Fabric unique name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   migrationRecoveryPointName: string (required)
  ##                             : The migration recovery point name.
  ##   migrationItemName: string (required)
  ##                    : Migration item name.
  var path_568686 = newJObject()
  var query_568687 = newJObject()
  add(path_568686, "fabricName", newJString(fabricName))
  add(path_568686, "resourceGroupName", newJString(resourceGroupName))
  add(query_568687, "api-version", newJString(apiVersion))
  add(path_568686, "subscriptionId", newJString(subscriptionId))
  add(path_568686, "resourceName", newJString(resourceName))
  add(path_568686, "protectionContainerName", newJString(protectionContainerName))
  add(path_568686, "migrationRecoveryPointName",
      newJString(migrationRecoveryPointName))
  add(path_568686, "migrationItemName", newJString(migrationItemName))
  result = call_568685.call(path_568686, query_568687, nil, nil, nil)

var migrationRecoveryPointsGet* = Call_MigrationRecoveryPointsGet_568673(
    name: "migrationRecoveryPointsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationMigrationItems/{migrationItemName}/migrationRecoveryPoints/{migrationRecoveryPointName}",
    validator: validate_MigrationRecoveryPointsGet_568674, base: "",
    url: url_MigrationRecoveryPointsGet_568675, schemes: {Scheme.Https})
type
  Call_ReplicationMigrationItemsTestMigrate_568688 = ref object of OpenApiRestCall_567668
proc url_ReplicationMigrationItemsTestMigrate_568690(protocol: Scheme;
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

proc validate_ReplicationMigrationItemsTestMigrate_568689(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to initiate test migration of the item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   migrationItemName: JString (required)
  ##                    : Migration item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568691 = path.getOrDefault("fabricName")
  valid_568691 = validateParameter(valid_568691, JString, required = true,
                                 default = nil)
  if valid_568691 != nil:
    section.add "fabricName", valid_568691
  var valid_568692 = path.getOrDefault("resourceGroupName")
  valid_568692 = validateParameter(valid_568692, JString, required = true,
                                 default = nil)
  if valid_568692 != nil:
    section.add "resourceGroupName", valid_568692
  var valid_568693 = path.getOrDefault("subscriptionId")
  valid_568693 = validateParameter(valid_568693, JString, required = true,
                                 default = nil)
  if valid_568693 != nil:
    section.add "subscriptionId", valid_568693
  var valid_568694 = path.getOrDefault("resourceName")
  valid_568694 = validateParameter(valid_568694, JString, required = true,
                                 default = nil)
  if valid_568694 != nil:
    section.add "resourceName", valid_568694
  var valid_568695 = path.getOrDefault("protectionContainerName")
  valid_568695 = validateParameter(valid_568695, JString, required = true,
                                 default = nil)
  if valid_568695 != nil:
    section.add "protectionContainerName", valid_568695
  var valid_568696 = path.getOrDefault("migrationItemName")
  valid_568696 = validateParameter(valid_568696, JString, required = true,
                                 default = nil)
  if valid_568696 != nil:
    section.add "migrationItemName", valid_568696
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568697 = query.getOrDefault("api-version")
  valid_568697 = validateParameter(valid_568697, JString, required = true,
                                 default = nil)
  if valid_568697 != nil:
    section.add "api-version", valid_568697
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

proc call*(call_568699: Call_ReplicationMigrationItemsTestMigrate_568688;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to initiate test migration of the item.
  ## 
  let valid = call_568699.validator(path, query, header, formData, body)
  let scheme = call_568699.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568699.url(scheme.get, call_568699.host, call_568699.base,
                         call_568699.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568699, url, valid)

proc call*(call_568700: Call_ReplicationMigrationItemsTestMigrate_568688;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; testMigrateInput: JsonNode;
          migrationItemName: string): Recallable =
  ## replicationMigrationItemsTestMigrate
  ## The operation to initiate test migration of the item.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   testMigrateInput: JObject (required)
  ##                   : Test migrate input.
  ##   migrationItemName: string (required)
  ##                    : Migration item name.
  var path_568701 = newJObject()
  var query_568702 = newJObject()
  var body_568703 = newJObject()
  add(path_568701, "fabricName", newJString(fabricName))
  add(path_568701, "resourceGroupName", newJString(resourceGroupName))
  add(query_568702, "api-version", newJString(apiVersion))
  add(path_568701, "subscriptionId", newJString(subscriptionId))
  add(path_568701, "resourceName", newJString(resourceName))
  add(path_568701, "protectionContainerName", newJString(protectionContainerName))
  if testMigrateInput != nil:
    body_568703 = testMigrateInput
  add(path_568701, "migrationItemName", newJString(migrationItemName))
  result = call_568700.call(path_568701, query_568702, nil, nil, body_568703)

var replicationMigrationItemsTestMigrate* = Call_ReplicationMigrationItemsTestMigrate_568688(
    name: "replicationMigrationItemsTestMigrate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationMigrationItems/{migrationItemName}/testMigrate",
    validator: validate_ReplicationMigrationItemsTestMigrate_568689, base: "",
    url: url_ReplicationMigrationItemsTestMigrate_568690, schemes: {Scheme.Https})
type
  Call_ReplicationMigrationItemsTestMigrateCleanup_568704 = ref object of OpenApiRestCall_567668
proc url_ReplicationMigrationItemsTestMigrateCleanup_568706(protocol: Scheme;
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

proc validate_ReplicationMigrationItemsTestMigrateCleanup_568705(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to initiate test migrate cleanup.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   migrationItemName: JString (required)
  ##                    : Migration item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568707 = path.getOrDefault("fabricName")
  valid_568707 = validateParameter(valid_568707, JString, required = true,
                                 default = nil)
  if valid_568707 != nil:
    section.add "fabricName", valid_568707
  var valid_568708 = path.getOrDefault("resourceGroupName")
  valid_568708 = validateParameter(valid_568708, JString, required = true,
                                 default = nil)
  if valid_568708 != nil:
    section.add "resourceGroupName", valid_568708
  var valid_568709 = path.getOrDefault("subscriptionId")
  valid_568709 = validateParameter(valid_568709, JString, required = true,
                                 default = nil)
  if valid_568709 != nil:
    section.add "subscriptionId", valid_568709
  var valid_568710 = path.getOrDefault("resourceName")
  valid_568710 = validateParameter(valid_568710, JString, required = true,
                                 default = nil)
  if valid_568710 != nil:
    section.add "resourceName", valid_568710
  var valid_568711 = path.getOrDefault("protectionContainerName")
  valid_568711 = validateParameter(valid_568711, JString, required = true,
                                 default = nil)
  if valid_568711 != nil:
    section.add "protectionContainerName", valid_568711
  var valid_568712 = path.getOrDefault("migrationItemName")
  valid_568712 = validateParameter(valid_568712, JString, required = true,
                                 default = nil)
  if valid_568712 != nil:
    section.add "migrationItemName", valid_568712
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568713 = query.getOrDefault("api-version")
  valid_568713 = validateParameter(valid_568713, JString, required = true,
                                 default = nil)
  if valid_568713 != nil:
    section.add "api-version", valid_568713
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

proc call*(call_568715: Call_ReplicationMigrationItemsTestMigrateCleanup_568704;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to initiate test migrate cleanup.
  ## 
  let valid = call_568715.validator(path, query, header, formData, body)
  let scheme = call_568715.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568715.url(scheme.get, call_568715.host, call_568715.base,
                         call_568715.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568715, url, valid)

proc call*(call_568716: Call_ReplicationMigrationItemsTestMigrateCleanup_568704;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; testMigrateCleanupInput: JsonNode;
          migrationItemName: string): Recallable =
  ## replicationMigrationItemsTestMigrateCleanup
  ## The operation to initiate test migrate cleanup.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   testMigrateCleanupInput: JObject (required)
  ##                          : Test migrate cleanup input.
  ##   migrationItemName: string (required)
  ##                    : Migration item name.
  var path_568717 = newJObject()
  var query_568718 = newJObject()
  var body_568719 = newJObject()
  add(path_568717, "fabricName", newJString(fabricName))
  add(path_568717, "resourceGroupName", newJString(resourceGroupName))
  add(query_568718, "api-version", newJString(apiVersion))
  add(path_568717, "subscriptionId", newJString(subscriptionId))
  add(path_568717, "resourceName", newJString(resourceName))
  add(path_568717, "protectionContainerName", newJString(protectionContainerName))
  if testMigrateCleanupInput != nil:
    body_568719 = testMigrateCleanupInput
  add(path_568717, "migrationItemName", newJString(migrationItemName))
  result = call_568716.call(path_568717, query_568718, nil, nil, body_568719)

var replicationMigrationItemsTestMigrateCleanup* = Call_ReplicationMigrationItemsTestMigrateCleanup_568704(
    name: "replicationMigrationItemsTestMigrateCleanup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationMigrationItems/{migrationItemName}/testMigrateCleanup",
    validator: validate_ReplicationMigrationItemsTestMigrateCleanup_568705,
    base: "", url: url_ReplicationMigrationItemsTestMigrateCleanup_568706,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectableItemsListByReplicationProtectionContainers_568720 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectableItemsListByReplicationProtectionContainers_568722(
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

proc validate_ReplicationProtectableItemsListByReplicationProtectionContainers_568721(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the protectable items in a protection container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568723 = path.getOrDefault("fabricName")
  valid_568723 = validateParameter(valid_568723, JString, required = true,
                                 default = nil)
  if valid_568723 != nil:
    section.add "fabricName", valid_568723
  var valid_568724 = path.getOrDefault("resourceGroupName")
  valid_568724 = validateParameter(valid_568724, JString, required = true,
                                 default = nil)
  if valid_568724 != nil:
    section.add "resourceGroupName", valid_568724
  var valid_568725 = path.getOrDefault("subscriptionId")
  valid_568725 = validateParameter(valid_568725, JString, required = true,
                                 default = nil)
  if valid_568725 != nil:
    section.add "subscriptionId", valid_568725
  var valid_568726 = path.getOrDefault("resourceName")
  valid_568726 = validateParameter(valid_568726, JString, required = true,
                                 default = nil)
  if valid_568726 != nil:
    section.add "resourceName", valid_568726
  var valid_568727 = path.getOrDefault("protectionContainerName")
  valid_568727 = validateParameter(valid_568727, JString, required = true,
                                 default = nil)
  if valid_568727 != nil:
    section.add "protectionContainerName", valid_568727
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568728 = query.getOrDefault("api-version")
  valid_568728 = validateParameter(valid_568728, JString, required = true,
                                 default = nil)
  if valid_568728 != nil:
    section.add "api-version", valid_568728
  var valid_568729 = query.getOrDefault("$filter")
  valid_568729 = validateParameter(valid_568729, JString, required = false,
                                 default = nil)
  if valid_568729 != nil:
    section.add "$filter", valid_568729
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568730: Call_ReplicationProtectableItemsListByReplicationProtectionContainers_568720;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the protectable items in a protection container.
  ## 
  let valid = call_568730.validator(path, query, header, formData, body)
  let scheme = call_568730.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568730.url(scheme.get, call_568730.host, call_568730.base,
                         call_568730.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568730, url, valid)

proc call*(call_568731: Call_ReplicationProtectableItemsListByReplicationProtectionContainers_568720;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; Filter: string = ""): Recallable =
  ## replicationProtectableItemsListByReplicationProtectionContainers
  ## Lists the protectable items in a protection container.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   Filter: string
  ##         : OData filter options.
  var path_568732 = newJObject()
  var query_568733 = newJObject()
  add(path_568732, "fabricName", newJString(fabricName))
  add(path_568732, "resourceGroupName", newJString(resourceGroupName))
  add(query_568733, "api-version", newJString(apiVersion))
  add(path_568732, "subscriptionId", newJString(subscriptionId))
  add(path_568732, "resourceName", newJString(resourceName))
  add(path_568732, "protectionContainerName", newJString(protectionContainerName))
  add(query_568733, "$filter", newJString(Filter))
  result = call_568731.call(path_568732, query_568733, nil, nil, nil)

var replicationProtectableItemsListByReplicationProtectionContainers* = Call_ReplicationProtectableItemsListByReplicationProtectionContainers_568720(
    name: "replicationProtectableItemsListByReplicationProtectionContainers",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectableItems", validator: validate_ReplicationProtectableItemsListByReplicationProtectionContainers_568721,
    base: "",
    url: url_ReplicationProtectableItemsListByReplicationProtectionContainers_568722,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectableItemsGet_568734 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectableItemsGet_568736(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectableItemsGet_568735(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to get the details of a protectable item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   protectableItemName: JString (required)
  ##                      : Protectable item name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568737 = path.getOrDefault("fabricName")
  valid_568737 = validateParameter(valid_568737, JString, required = true,
                                 default = nil)
  if valid_568737 != nil:
    section.add "fabricName", valid_568737
  var valid_568738 = path.getOrDefault("resourceGroupName")
  valid_568738 = validateParameter(valid_568738, JString, required = true,
                                 default = nil)
  if valid_568738 != nil:
    section.add "resourceGroupName", valid_568738
  var valid_568739 = path.getOrDefault("protectableItemName")
  valid_568739 = validateParameter(valid_568739, JString, required = true,
                                 default = nil)
  if valid_568739 != nil:
    section.add "protectableItemName", valid_568739
  var valid_568740 = path.getOrDefault("subscriptionId")
  valid_568740 = validateParameter(valid_568740, JString, required = true,
                                 default = nil)
  if valid_568740 != nil:
    section.add "subscriptionId", valid_568740
  var valid_568741 = path.getOrDefault("resourceName")
  valid_568741 = validateParameter(valid_568741, JString, required = true,
                                 default = nil)
  if valid_568741 != nil:
    section.add "resourceName", valid_568741
  var valid_568742 = path.getOrDefault("protectionContainerName")
  valid_568742 = validateParameter(valid_568742, JString, required = true,
                                 default = nil)
  if valid_568742 != nil:
    section.add "protectionContainerName", valid_568742
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568743 = query.getOrDefault("api-version")
  valid_568743 = validateParameter(valid_568743, JString, required = true,
                                 default = nil)
  if valid_568743 != nil:
    section.add "api-version", valid_568743
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568744: Call_ReplicationProtectableItemsGet_568734; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to get the details of a protectable item.
  ## 
  let valid = call_568744.validator(path, query, header, formData, body)
  let scheme = call_568744.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568744.url(scheme.get, call_568744.host, call_568744.base,
                         call_568744.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568744, url, valid)

proc call*(call_568745: Call_ReplicationProtectableItemsGet_568734;
          fabricName: string; resourceGroupName: string;
          protectableItemName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; protectionContainerName: string): Recallable =
  ## replicationProtectableItemsGet
  ## The operation to get the details of a protectable item.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   protectableItemName: string (required)
  ##                      : Protectable item name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  var path_568746 = newJObject()
  var query_568747 = newJObject()
  add(path_568746, "fabricName", newJString(fabricName))
  add(path_568746, "resourceGroupName", newJString(resourceGroupName))
  add(path_568746, "protectableItemName", newJString(protectableItemName))
  add(query_568747, "api-version", newJString(apiVersion))
  add(path_568746, "subscriptionId", newJString(subscriptionId))
  add(path_568746, "resourceName", newJString(resourceName))
  add(path_568746, "protectionContainerName", newJString(protectionContainerName))
  result = call_568745.call(path_568746, query_568747, nil, nil, nil)

var replicationProtectableItemsGet* = Call_ReplicationProtectableItemsGet_568734(
    name: "replicationProtectableItemsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectableItems/{protectableItemName}",
    validator: validate_ReplicationProtectableItemsGet_568735, base: "",
    url: url_ReplicationProtectableItemsGet_568736, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsListByReplicationProtectionContainers_568748 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectedItemsListByReplicationProtectionContainers_568750(
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

proc validate_ReplicationProtectedItemsListByReplicationProtectionContainers_568749(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the list of ASR replication protected items in the protection container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568751 = path.getOrDefault("fabricName")
  valid_568751 = validateParameter(valid_568751, JString, required = true,
                                 default = nil)
  if valid_568751 != nil:
    section.add "fabricName", valid_568751
  var valid_568752 = path.getOrDefault("resourceGroupName")
  valid_568752 = validateParameter(valid_568752, JString, required = true,
                                 default = nil)
  if valid_568752 != nil:
    section.add "resourceGroupName", valid_568752
  var valid_568753 = path.getOrDefault("subscriptionId")
  valid_568753 = validateParameter(valid_568753, JString, required = true,
                                 default = nil)
  if valid_568753 != nil:
    section.add "subscriptionId", valid_568753
  var valid_568754 = path.getOrDefault("resourceName")
  valid_568754 = validateParameter(valid_568754, JString, required = true,
                                 default = nil)
  if valid_568754 != nil:
    section.add "resourceName", valid_568754
  var valid_568755 = path.getOrDefault("protectionContainerName")
  valid_568755 = validateParameter(valid_568755, JString, required = true,
                                 default = nil)
  if valid_568755 != nil:
    section.add "protectionContainerName", valid_568755
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568756 = query.getOrDefault("api-version")
  valid_568756 = validateParameter(valid_568756, JString, required = true,
                                 default = nil)
  if valid_568756 != nil:
    section.add "api-version", valid_568756
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568757: Call_ReplicationProtectedItemsListByReplicationProtectionContainers_568748;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the list of ASR replication protected items in the protection container.
  ## 
  let valid = call_568757.validator(path, query, header, formData, body)
  let scheme = call_568757.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568757.url(scheme.get, call_568757.host, call_568757.base,
                         call_568757.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568757, url, valid)

proc call*(call_568758: Call_ReplicationProtectedItemsListByReplicationProtectionContainers_568748;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string): Recallable =
  ## replicationProtectedItemsListByReplicationProtectionContainers
  ## Gets the list of ASR replication protected items in the protection container.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  var path_568759 = newJObject()
  var query_568760 = newJObject()
  add(path_568759, "fabricName", newJString(fabricName))
  add(path_568759, "resourceGroupName", newJString(resourceGroupName))
  add(query_568760, "api-version", newJString(apiVersion))
  add(path_568759, "subscriptionId", newJString(subscriptionId))
  add(path_568759, "resourceName", newJString(resourceName))
  add(path_568759, "protectionContainerName", newJString(protectionContainerName))
  result = call_568758.call(path_568759, query_568760, nil, nil, nil)

var replicationProtectedItemsListByReplicationProtectionContainers* = Call_ReplicationProtectedItemsListByReplicationProtectionContainers_568748(
    name: "replicationProtectedItemsListByReplicationProtectionContainers",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems", validator: validate_ReplicationProtectedItemsListByReplicationProtectionContainers_568749,
    base: "",
    url: url_ReplicationProtectedItemsListByReplicationProtectionContainers_568750,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsCreate_568775 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectedItemsCreate_568777(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectedItemsCreate_568776(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create an ASR replication protected item (Enable replication).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Name of the fabric.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : A name for the replication protected item.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568778 = path.getOrDefault("fabricName")
  valid_568778 = validateParameter(valid_568778, JString, required = true,
                                 default = nil)
  if valid_568778 != nil:
    section.add "fabricName", valid_568778
  var valid_568779 = path.getOrDefault("resourceGroupName")
  valid_568779 = validateParameter(valid_568779, JString, required = true,
                                 default = nil)
  if valid_568779 != nil:
    section.add "resourceGroupName", valid_568779
  var valid_568780 = path.getOrDefault("subscriptionId")
  valid_568780 = validateParameter(valid_568780, JString, required = true,
                                 default = nil)
  if valid_568780 != nil:
    section.add "subscriptionId", valid_568780
  var valid_568781 = path.getOrDefault("resourceName")
  valid_568781 = validateParameter(valid_568781, JString, required = true,
                                 default = nil)
  if valid_568781 != nil:
    section.add "resourceName", valid_568781
  var valid_568782 = path.getOrDefault("protectionContainerName")
  valid_568782 = validateParameter(valid_568782, JString, required = true,
                                 default = nil)
  if valid_568782 != nil:
    section.add "protectionContainerName", valid_568782
  var valid_568783 = path.getOrDefault("replicatedProtectedItemName")
  valid_568783 = validateParameter(valid_568783, JString, required = true,
                                 default = nil)
  if valid_568783 != nil:
    section.add "replicatedProtectedItemName", valid_568783
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568784 = query.getOrDefault("api-version")
  valid_568784 = validateParameter(valid_568784, JString, required = true,
                                 default = nil)
  if valid_568784 != nil:
    section.add "api-version", valid_568784
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

proc call*(call_568786: Call_ReplicationProtectedItemsCreate_568775;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create an ASR replication protected item (Enable replication).
  ## 
  let valid = call_568786.validator(path, query, header, formData, body)
  let scheme = call_568786.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568786.url(scheme.get, call_568786.host, call_568786.base,
                         call_568786.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568786, url, valid)

proc call*(call_568787: Call_ReplicationProtectedItemsCreate_568775;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; input: JsonNode; resourceName: string;
          protectionContainerName: string; replicatedProtectedItemName: string): Recallable =
  ## replicationProtectedItemsCreate
  ## The operation to create an ASR replication protected item (Enable replication).
  ##   fabricName: string (required)
  ##             : Name of the fabric.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   input: JObject (required)
  ##        : Enable Protection Input.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: string (required)
  ##                              : A name for the replication protected item.
  var path_568788 = newJObject()
  var query_568789 = newJObject()
  var body_568790 = newJObject()
  add(path_568788, "fabricName", newJString(fabricName))
  add(path_568788, "resourceGroupName", newJString(resourceGroupName))
  add(query_568789, "api-version", newJString(apiVersion))
  add(path_568788, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_568790 = input
  add(path_568788, "resourceName", newJString(resourceName))
  add(path_568788, "protectionContainerName", newJString(protectionContainerName))
  add(path_568788, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568787.call(path_568788, query_568789, nil, nil, body_568790)

var replicationProtectedItemsCreate* = Call_ReplicationProtectedItemsCreate_568775(
    name: "replicationProtectedItemsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}",
    validator: validate_ReplicationProtectedItemsCreate_568776, base: "",
    url: url_ReplicationProtectedItemsCreate_568777, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsGet_568761 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectedItemsGet_568763(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectedItemsGet_568762(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of an ASR replication protected item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric unique name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : Replication protected item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568764 = path.getOrDefault("fabricName")
  valid_568764 = validateParameter(valid_568764, JString, required = true,
                                 default = nil)
  if valid_568764 != nil:
    section.add "fabricName", valid_568764
  var valid_568765 = path.getOrDefault("resourceGroupName")
  valid_568765 = validateParameter(valid_568765, JString, required = true,
                                 default = nil)
  if valid_568765 != nil:
    section.add "resourceGroupName", valid_568765
  var valid_568766 = path.getOrDefault("subscriptionId")
  valid_568766 = validateParameter(valid_568766, JString, required = true,
                                 default = nil)
  if valid_568766 != nil:
    section.add "subscriptionId", valid_568766
  var valid_568767 = path.getOrDefault("resourceName")
  valid_568767 = validateParameter(valid_568767, JString, required = true,
                                 default = nil)
  if valid_568767 != nil:
    section.add "resourceName", valid_568767
  var valid_568768 = path.getOrDefault("protectionContainerName")
  valid_568768 = validateParameter(valid_568768, JString, required = true,
                                 default = nil)
  if valid_568768 != nil:
    section.add "protectionContainerName", valid_568768
  var valid_568769 = path.getOrDefault("replicatedProtectedItemName")
  valid_568769 = validateParameter(valid_568769, JString, required = true,
                                 default = nil)
  if valid_568769 != nil:
    section.add "replicatedProtectedItemName", valid_568769
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568770 = query.getOrDefault("api-version")
  valid_568770 = validateParameter(valid_568770, JString, required = true,
                                 default = nil)
  if valid_568770 != nil:
    section.add "api-version", valid_568770
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568771: Call_ReplicationProtectedItemsGet_568761; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of an ASR replication protected item.
  ## 
  let valid = call_568771.validator(path, query, header, formData, body)
  let scheme = call_568771.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568771.url(scheme.get, call_568771.host, call_568771.base,
                         call_568771.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568771, url, valid)

proc call*(call_568772: Call_ReplicationProtectedItemsGet_568761;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; replicatedProtectedItemName: string): Recallable =
  ## replicationProtectedItemsGet
  ## Gets the details of an ASR replication protected item.
  ##   fabricName: string (required)
  ##             : Fabric unique name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: string (required)
  ##                              : Replication protected item name.
  var path_568773 = newJObject()
  var query_568774 = newJObject()
  add(path_568773, "fabricName", newJString(fabricName))
  add(path_568773, "resourceGroupName", newJString(resourceGroupName))
  add(query_568774, "api-version", newJString(apiVersion))
  add(path_568773, "subscriptionId", newJString(subscriptionId))
  add(path_568773, "resourceName", newJString(resourceName))
  add(path_568773, "protectionContainerName", newJString(protectionContainerName))
  add(path_568773, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568772.call(path_568773, query_568774, nil, nil, nil)

var replicationProtectedItemsGet* = Call_ReplicationProtectedItemsGet_568761(
    name: "replicationProtectedItemsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}",
    validator: validate_ReplicationProtectedItemsGet_568762, base: "",
    url: url_ReplicationProtectedItemsGet_568763, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsUpdate_568805 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectedItemsUpdate_568807(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectedItemsUpdate_568806(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update the recovery settings of an ASR replication protected item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : Replication protected item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568808 = path.getOrDefault("fabricName")
  valid_568808 = validateParameter(valid_568808, JString, required = true,
                                 default = nil)
  if valid_568808 != nil:
    section.add "fabricName", valid_568808
  var valid_568809 = path.getOrDefault("resourceGroupName")
  valid_568809 = validateParameter(valid_568809, JString, required = true,
                                 default = nil)
  if valid_568809 != nil:
    section.add "resourceGroupName", valid_568809
  var valid_568810 = path.getOrDefault("subscriptionId")
  valid_568810 = validateParameter(valid_568810, JString, required = true,
                                 default = nil)
  if valid_568810 != nil:
    section.add "subscriptionId", valid_568810
  var valid_568811 = path.getOrDefault("resourceName")
  valid_568811 = validateParameter(valid_568811, JString, required = true,
                                 default = nil)
  if valid_568811 != nil:
    section.add "resourceName", valid_568811
  var valid_568812 = path.getOrDefault("protectionContainerName")
  valid_568812 = validateParameter(valid_568812, JString, required = true,
                                 default = nil)
  if valid_568812 != nil:
    section.add "protectionContainerName", valid_568812
  var valid_568813 = path.getOrDefault("replicatedProtectedItemName")
  valid_568813 = validateParameter(valid_568813, JString, required = true,
                                 default = nil)
  if valid_568813 != nil:
    section.add "replicatedProtectedItemName", valid_568813
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568814 = query.getOrDefault("api-version")
  valid_568814 = validateParameter(valid_568814, JString, required = true,
                                 default = nil)
  if valid_568814 != nil:
    section.add "api-version", valid_568814
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

proc call*(call_568816: Call_ReplicationProtectedItemsUpdate_568805;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to update the recovery settings of an ASR replication protected item.
  ## 
  let valid = call_568816.validator(path, query, header, formData, body)
  let scheme = call_568816.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568816.url(scheme.get, call_568816.host, call_568816.base,
                         call_568816.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568816, url, valid)

proc call*(call_568817: Call_ReplicationProtectedItemsUpdate_568805;
          updateProtectionInput: JsonNode; fabricName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; protectionContainerName: string;
          replicatedProtectedItemName: string): Recallable =
  ## replicationProtectedItemsUpdate
  ## The operation to update the recovery settings of an ASR replication protected item.
  ##   updateProtectionInput: JObject (required)
  ##                        : Update protection input.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: string (required)
  ##                              : Replication protected item name.
  var path_568818 = newJObject()
  var query_568819 = newJObject()
  var body_568820 = newJObject()
  if updateProtectionInput != nil:
    body_568820 = updateProtectionInput
  add(path_568818, "fabricName", newJString(fabricName))
  add(path_568818, "resourceGroupName", newJString(resourceGroupName))
  add(query_568819, "api-version", newJString(apiVersion))
  add(path_568818, "subscriptionId", newJString(subscriptionId))
  add(path_568818, "resourceName", newJString(resourceName))
  add(path_568818, "protectionContainerName", newJString(protectionContainerName))
  add(path_568818, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568817.call(path_568818, query_568819, nil, nil, body_568820)

var replicationProtectedItemsUpdate* = Call_ReplicationProtectedItemsUpdate_568805(
    name: "replicationProtectedItemsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}",
    validator: validate_ReplicationProtectedItemsUpdate_568806, base: "",
    url: url_ReplicationProtectedItemsUpdate_568807, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsPurge_568791 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectedItemsPurge_568793(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectedItemsPurge_568792(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete or purge a replication protected item. This operation will force delete the replication protected item. Use the remove operation on replication protected item to perform a clean disable replication for the item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : Replication protected item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568794 = path.getOrDefault("fabricName")
  valid_568794 = validateParameter(valid_568794, JString, required = true,
                                 default = nil)
  if valid_568794 != nil:
    section.add "fabricName", valid_568794
  var valid_568795 = path.getOrDefault("resourceGroupName")
  valid_568795 = validateParameter(valid_568795, JString, required = true,
                                 default = nil)
  if valid_568795 != nil:
    section.add "resourceGroupName", valid_568795
  var valid_568796 = path.getOrDefault("subscriptionId")
  valid_568796 = validateParameter(valid_568796, JString, required = true,
                                 default = nil)
  if valid_568796 != nil:
    section.add "subscriptionId", valid_568796
  var valid_568797 = path.getOrDefault("resourceName")
  valid_568797 = validateParameter(valid_568797, JString, required = true,
                                 default = nil)
  if valid_568797 != nil:
    section.add "resourceName", valid_568797
  var valid_568798 = path.getOrDefault("protectionContainerName")
  valid_568798 = validateParameter(valid_568798, JString, required = true,
                                 default = nil)
  if valid_568798 != nil:
    section.add "protectionContainerName", valid_568798
  var valid_568799 = path.getOrDefault("replicatedProtectedItemName")
  valid_568799 = validateParameter(valid_568799, JString, required = true,
                                 default = nil)
  if valid_568799 != nil:
    section.add "replicatedProtectedItemName", valid_568799
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568800 = query.getOrDefault("api-version")
  valid_568800 = validateParameter(valid_568800, JString, required = true,
                                 default = nil)
  if valid_568800 != nil:
    section.add "api-version", valid_568800
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568801: Call_ReplicationProtectedItemsPurge_568791; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete or purge a replication protected item. This operation will force delete the replication protected item. Use the remove operation on replication protected item to perform a clean disable replication for the item.
  ## 
  let valid = call_568801.validator(path, query, header, formData, body)
  let scheme = call_568801.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568801.url(scheme.get, call_568801.host, call_568801.base,
                         call_568801.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568801, url, valid)

proc call*(call_568802: Call_ReplicationProtectedItemsPurge_568791;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; replicatedProtectedItemName: string): Recallable =
  ## replicationProtectedItemsPurge
  ## The operation to delete or purge a replication protected item. This operation will force delete the replication protected item. Use the remove operation on replication protected item to perform a clean disable replication for the item.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: string (required)
  ##                              : Replication protected item name.
  var path_568803 = newJObject()
  var query_568804 = newJObject()
  add(path_568803, "fabricName", newJString(fabricName))
  add(path_568803, "resourceGroupName", newJString(resourceGroupName))
  add(query_568804, "api-version", newJString(apiVersion))
  add(path_568803, "subscriptionId", newJString(subscriptionId))
  add(path_568803, "resourceName", newJString(resourceName))
  add(path_568803, "protectionContainerName", newJString(protectionContainerName))
  add(path_568803, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568802.call(path_568803, query_568804, nil, nil, nil)

var replicationProtectedItemsPurge* = Call_ReplicationProtectedItemsPurge_568791(
    name: "replicationProtectedItemsPurge", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}",
    validator: validate_ReplicationProtectedItemsPurge_568792, base: "",
    url: url_ReplicationProtectedItemsPurge_568793, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsApplyRecoveryPoint_568821 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectedItemsApplyRecoveryPoint_568823(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsApplyRecoveryPoint_568822(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to change the recovery point of a failed over replication protected item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The ARM fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : The protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : The replicated protected item's name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568824 = path.getOrDefault("fabricName")
  valid_568824 = validateParameter(valid_568824, JString, required = true,
                                 default = nil)
  if valid_568824 != nil:
    section.add "fabricName", valid_568824
  var valid_568825 = path.getOrDefault("resourceGroupName")
  valid_568825 = validateParameter(valid_568825, JString, required = true,
                                 default = nil)
  if valid_568825 != nil:
    section.add "resourceGroupName", valid_568825
  var valid_568826 = path.getOrDefault("subscriptionId")
  valid_568826 = validateParameter(valid_568826, JString, required = true,
                                 default = nil)
  if valid_568826 != nil:
    section.add "subscriptionId", valid_568826
  var valid_568827 = path.getOrDefault("resourceName")
  valid_568827 = validateParameter(valid_568827, JString, required = true,
                                 default = nil)
  if valid_568827 != nil:
    section.add "resourceName", valid_568827
  var valid_568828 = path.getOrDefault("protectionContainerName")
  valid_568828 = validateParameter(valid_568828, JString, required = true,
                                 default = nil)
  if valid_568828 != nil:
    section.add "protectionContainerName", valid_568828
  var valid_568829 = path.getOrDefault("replicatedProtectedItemName")
  valid_568829 = validateParameter(valid_568829, JString, required = true,
                                 default = nil)
  if valid_568829 != nil:
    section.add "replicatedProtectedItemName", valid_568829
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568830 = query.getOrDefault("api-version")
  valid_568830 = validateParameter(valid_568830, JString, required = true,
                                 default = nil)
  if valid_568830 != nil:
    section.add "api-version", valid_568830
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

proc call*(call_568832: Call_ReplicationProtectedItemsApplyRecoveryPoint_568821;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to change the recovery point of a failed over replication protected item.
  ## 
  let valid = call_568832.validator(path, query, header, formData, body)
  let scheme = call_568832.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568832.url(scheme.get, call_568832.host, call_568832.base,
                         call_568832.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568832, url, valid)

proc call*(call_568833: Call_ReplicationProtectedItemsApplyRecoveryPoint_568821;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          applyRecoveryPointInput: JsonNode; subscriptionId: string;
          resourceName: string; protectionContainerName: string;
          replicatedProtectedItemName: string): Recallable =
  ## replicationProtectedItemsApplyRecoveryPoint
  ## The operation to change the recovery point of a failed over replication protected item.
  ##   fabricName: string (required)
  ##             : The ARM fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   applyRecoveryPointInput: JObject (required)
  ##                          : The ApplyRecoveryPointInput.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : The protection container name.
  ##   replicatedProtectedItemName: string (required)
  ##                              : The replicated protected item's name.
  var path_568834 = newJObject()
  var query_568835 = newJObject()
  var body_568836 = newJObject()
  add(path_568834, "fabricName", newJString(fabricName))
  add(path_568834, "resourceGroupName", newJString(resourceGroupName))
  add(query_568835, "api-version", newJString(apiVersion))
  if applyRecoveryPointInput != nil:
    body_568836 = applyRecoveryPointInput
  add(path_568834, "subscriptionId", newJString(subscriptionId))
  add(path_568834, "resourceName", newJString(resourceName))
  add(path_568834, "protectionContainerName", newJString(protectionContainerName))
  add(path_568834, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568833.call(path_568834, query_568835, nil, nil, body_568836)

var replicationProtectedItemsApplyRecoveryPoint* = Call_ReplicationProtectedItemsApplyRecoveryPoint_568821(
    name: "replicationProtectedItemsApplyRecoveryPoint",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/applyRecoveryPoint",
    validator: validate_ReplicationProtectedItemsApplyRecoveryPoint_568822,
    base: "", url: url_ReplicationProtectedItemsApplyRecoveryPoint_568823,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsFailoverCommit_568837 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectedItemsFailoverCommit_568839(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsFailoverCommit_568838(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Operation to commit the failover of the replication protected item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Unique fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : Replication protected item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568840 = path.getOrDefault("fabricName")
  valid_568840 = validateParameter(valid_568840, JString, required = true,
                                 default = nil)
  if valid_568840 != nil:
    section.add "fabricName", valid_568840
  var valid_568841 = path.getOrDefault("resourceGroupName")
  valid_568841 = validateParameter(valid_568841, JString, required = true,
                                 default = nil)
  if valid_568841 != nil:
    section.add "resourceGroupName", valid_568841
  var valid_568842 = path.getOrDefault("subscriptionId")
  valid_568842 = validateParameter(valid_568842, JString, required = true,
                                 default = nil)
  if valid_568842 != nil:
    section.add "subscriptionId", valid_568842
  var valid_568843 = path.getOrDefault("resourceName")
  valid_568843 = validateParameter(valid_568843, JString, required = true,
                                 default = nil)
  if valid_568843 != nil:
    section.add "resourceName", valid_568843
  var valid_568844 = path.getOrDefault("protectionContainerName")
  valid_568844 = validateParameter(valid_568844, JString, required = true,
                                 default = nil)
  if valid_568844 != nil:
    section.add "protectionContainerName", valid_568844
  var valid_568845 = path.getOrDefault("replicatedProtectedItemName")
  valid_568845 = validateParameter(valid_568845, JString, required = true,
                                 default = nil)
  if valid_568845 != nil:
    section.add "replicatedProtectedItemName", valid_568845
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568846 = query.getOrDefault("api-version")
  valid_568846 = validateParameter(valid_568846, JString, required = true,
                                 default = nil)
  if valid_568846 != nil:
    section.add "api-version", valid_568846
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568847: Call_ReplicationProtectedItemsFailoverCommit_568837;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to commit the failover of the replication protected item.
  ## 
  let valid = call_568847.validator(path, query, header, formData, body)
  let scheme = call_568847.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568847.url(scheme.get, call_568847.host, call_568847.base,
                         call_568847.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568847, url, valid)

proc call*(call_568848: Call_ReplicationProtectedItemsFailoverCommit_568837;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; replicatedProtectedItemName: string): Recallable =
  ## replicationProtectedItemsFailoverCommit
  ## Operation to commit the failover of the replication protected item.
  ##   fabricName: string (required)
  ##             : Unique fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: string (required)
  ##                              : Replication protected item name.
  var path_568849 = newJObject()
  var query_568850 = newJObject()
  add(path_568849, "fabricName", newJString(fabricName))
  add(path_568849, "resourceGroupName", newJString(resourceGroupName))
  add(query_568850, "api-version", newJString(apiVersion))
  add(path_568849, "subscriptionId", newJString(subscriptionId))
  add(path_568849, "resourceName", newJString(resourceName))
  add(path_568849, "protectionContainerName", newJString(protectionContainerName))
  add(path_568849, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568848.call(path_568849, query_568850, nil, nil, nil)

var replicationProtectedItemsFailoverCommit* = Call_ReplicationProtectedItemsFailoverCommit_568837(
    name: "replicationProtectedItemsFailoverCommit", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/failoverCommit",
    validator: validate_ReplicationProtectedItemsFailoverCommit_568838, base: "",
    url: url_ReplicationProtectedItemsFailoverCommit_568839,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsPlannedFailover_568851 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectedItemsPlannedFailover_568853(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsPlannedFailover_568852(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Operation to initiate a planned failover of the replication protected item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Unique fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : Replication protected item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568854 = path.getOrDefault("fabricName")
  valid_568854 = validateParameter(valid_568854, JString, required = true,
                                 default = nil)
  if valid_568854 != nil:
    section.add "fabricName", valid_568854
  var valid_568855 = path.getOrDefault("resourceGroupName")
  valid_568855 = validateParameter(valid_568855, JString, required = true,
                                 default = nil)
  if valid_568855 != nil:
    section.add "resourceGroupName", valid_568855
  var valid_568856 = path.getOrDefault("subscriptionId")
  valid_568856 = validateParameter(valid_568856, JString, required = true,
                                 default = nil)
  if valid_568856 != nil:
    section.add "subscriptionId", valid_568856
  var valid_568857 = path.getOrDefault("resourceName")
  valid_568857 = validateParameter(valid_568857, JString, required = true,
                                 default = nil)
  if valid_568857 != nil:
    section.add "resourceName", valid_568857
  var valid_568858 = path.getOrDefault("protectionContainerName")
  valid_568858 = validateParameter(valid_568858, JString, required = true,
                                 default = nil)
  if valid_568858 != nil:
    section.add "protectionContainerName", valid_568858
  var valid_568859 = path.getOrDefault("replicatedProtectedItemName")
  valid_568859 = validateParameter(valid_568859, JString, required = true,
                                 default = nil)
  if valid_568859 != nil:
    section.add "replicatedProtectedItemName", valid_568859
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568860 = query.getOrDefault("api-version")
  valid_568860 = validateParameter(valid_568860, JString, required = true,
                                 default = nil)
  if valid_568860 != nil:
    section.add "api-version", valid_568860
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

proc call*(call_568862: Call_ReplicationProtectedItemsPlannedFailover_568851;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to initiate a planned failover of the replication protected item.
  ## 
  let valid = call_568862.validator(path, query, header, formData, body)
  let scheme = call_568862.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568862.url(scheme.get, call_568862.host, call_568862.base,
                         call_568862.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568862, url, valid)

proc call*(call_568863: Call_ReplicationProtectedItemsPlannedFailover_568851;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; failoverInput: JsonNode;
          replicatedProtectedItemName: string): Recallable =
  ## replicationProtectedItemsPlannedFailover
  ## Operation to initiate a planned failover of the replication protected item.
  ##   fabricName: string (required)
  ##             : Unique fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   failoverInput: JObject (required)
  ##                : Disable protection input.
  ##   replicatedProtectedItemName: string (required)
  ##                              : Replication protected item name.
  var path_568864 = newJObject()
  var query_568865 = newJObject()
  var body_568866 = newJObject()
  add(path_568864, "fabricName", newJString(fabricName))
  add(path_568864, "resourceGroupName", newJString(resourceGroupName))
  add(query_568865, "api-version", newJString(apiVersion))
  add(path_568864, "subscriptionId", newJString(subscriptionId))
  add(path_568864, "resourceName", newJString(resourceName))
  add(path_568864, "protectionContainerName", newJString(protectionContainerName))
  if failoverInput != nil:
    body_568866 = failoverInput
  add(path_568864, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568863.call(path_568864, query_568865, nil, nil, body_568866)

var replicationProtectedItemsPlannedFailover* = Call_ReplicationProtectedItemsPlannedFailover_568851(
    name: "replicationProtectedItemsPlannedFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/plannedFailover",
    validator: validate_ReplicationProtectedItemsPlannedFailover_568852, base: "",
    url: url_ReplicationProtectedItemsPlannedFailover_568853,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsReprotect_568867 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectedItemsReprotect_568869(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectedItemsReprotect_568868(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Operation to reprotect or reverse replicate a failed over replication protected item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Unique fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : Replication protected item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568870 = path.getOrDefault("fabricName")
  valid_568870 = validateParameter(valid_568870, JString, required = true,
                                 default = nil)
  if valid_568870 != nil:
    section.add "fabricName", valid_568870
  var valid_568871 = path.getOrDefault("resourceGroupName")
  valid_568871 = validateParameter(valid_568871, JString, required = true,
                                 default = nil)
  if valid_568871 != nil:
    section.add "resourceGroupName", valid_568871
  var valid_568872 = path.getOrDefault("subscriptionId")
  valid_568872 = validateParameter(valid_568872, JString, required = true,
                                 default = nil)
  if valid_568872 != nil:
    section.add "subscriptionId", valid_568872
  var valid_568873 = path.getOrDefault("resourceName")
  valid_568873 = validateParameter(valid_568873, JString, required = true,
                                 default = nil)
  if valid_568873 != nil:
    section.add "resourceName", valid_568873
  var valid_568874 = path.getOrDefault("protectionContainerName")
  valid_568874 = validateParameter(valid_568874, JString, required = true,
                                 default = nil)
  if valid_568874 != nil:
    section.add "protectionContainerName", valid_568874
  var valid_568875 = path.getOrDefault("replicatedProtectedItemName")
  valid_568875 = validateParameter(valid_568875, JString, required = true,
                                 default = nil)
  if valid_568875 != nil:
    section.add "replicatedProtectedItemName", valid_568875
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568876 = query.getOrDefault("api-version")
  valid_568876 = validateParameter(valid_568876, JString, required = true,
                                 default = nil)
  if valid_568876 != nil:
    section.add "api-version", valid_568876
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

proc call*(call_568878: Call_ReplicationProtectedItemsReprotect_568867;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to reprotect or reverse replicate a failed over replication protected item.
  ## 
  let valid = call_568878.validator(path, query, header, formData, body)
  let scheme = call_568878.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568878.url(scheme.get, call_568878.host, call_568878.base,
                         call_568878.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568878, url, valid)

proc call*(call_568879: Call_ReplicationProtectedItemsReprotect_568867;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; rrInput: JsonNode;
          replicatedProtectedItemName: string): Recallable =
  ## replicationProtectedItemsReprotect
  ## Operation to reprotect or reverse replicate a failed over replication protected item.
  ##   fabricName: string (required)
  ##             : Unique fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   rrInput: JObject (required)
  ##          : Disable protection input.
  ##   replicatedProtectedItemName: string (required)
  ##                              : Replication protected item name.
  var path_568880 = newJObject()
  var query_568881 = newJObject()
  var body_568882 = newJObject()
  add(path_568880, "fabricName", newJString(fabricName))
  add(path_568880, "resourceGroupName", newJString(resourceGroupName))
  add(query_568881, "api-version", newJString(apiVersion))
  add(path_568880, "subscriptionId", newJString(subscriptionId))
  add(path_568880, "resourceName", newJString(resourceName))
  add(path_568880, "protectionContainerName", newJString(protectionContainerName))
  if rrInput != nil:
    body_568882 = rrInput
  add(path_568880, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568879.call(path_568880, query_568881, nil, nil, body_568882)

var replicationProtectedItemsReprotect* = Call_ReplicationProtectedItemsReprotect_568867(
    name: "replicationProtectedItemsReprotect", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/reProtect",
    validator: validate_ReplicationProtectedItemsReprotect_568868, base: "",
    url: url_ReplicationProtectedItemsReprotect_568869, schemes: {Scheme.Https})
type
  Call_RecoveryPointsListByReplicationProtectedItems_568883 = ref object of OpenApiRestCall_567668
proc url_RecoveryPointsListByReplicationProtectedItems_568885(protocol: Scheme;
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

proc validate_RecoveryPointsListByReplicationProtectedItems_568884(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the available recovery points for a replication protected item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : The protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : The replication protected item's name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568886 = path.getOrDefault("fabricName")
  valid_568886 = validateParameter(valid_568886, JString, required = true,
                                 default = nil)
  if valid_568886 != nil:
    section.add "fabricName", valid_568886
  var valid_568887 = path.getOrDefault("resourceGroupName")
  valid_568887 = validateParameter(valid_568887, JString, required = true,
                                 default = nil)
  if valid_568887 != nil:
    section.add "resourceGroupName", valid_568887
  var valid_568888 = path.getOrDefault("subscriptionId")
  valid_568888 = validateParameter(valid_568888, JString, required = true,
                                 default = nil)
  if valid_568888 != nil:
    section.add "subscriptionId", valid_568888
  var valid_568889 = path.getOrDefault("resourceName")
  valid_568889 = validateParameter(valid_568889, JString, required = true,
                                 default = nil)
  if valid_568889 != nil:
    section.add "resourceName", valid_568889
  var valid_568890 = path.getOrDefault("protectionContainerName")
  valid_568890 = validateParameter(valid_568890, JString, required = true,
                                 default = nil)
  if valid_568890 != nil:
    section.add "protectionContainerName", valid_568890
  var valid_568891 = path.getOrDefault("replicatedProtectedItemName")
  valid_568891 = validateParameter(valid_568891, JString, required = true,
                                 default = nil)
  if valid_568891 != nil:
    section.add "replicatedProtectedItemName", valid_568891
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568892 = query.getOrDefault("api-version")
  valid_568892 = validateParameter(valid_568892, JString, required = true,
                                 default = nil)
  if valid_568892 != nil:
    section.add "api-version", valid_568892
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568893: Call_RecoveryPointsListByReplicationProtectedItems_568883;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the available recovery points for a replication protected item.
  ## 
  let valid = call_568893.validator(path, query, header, formData, body)
  let scheme = call_568893.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568893.url(scheme.get, call_568893.host, call_568893.base,
                         call_568893.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568893, url, valid)

proc call*(call_568894: Call_RecoveryPointsListByReplicationProtectedItems_568883;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; replicatedProtectedItemName: string): Recallable =
  ## recoveryPointsListByReplicationProtectedItems
  ## Lists the available recovery points for a replication protected item.
  ##   fabricName: string (required)
  ##             : The fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : The protection container name.
  ##   replicatedProtectedItemName: string (required)
  ##                              : The replication protected item's name.
  var path_568895 = newJObject()
  var query_568896 = newJObject()
  add(path_568895, "fabricName", newJString(fabricName))
  add(path_568895, "resourceGroupName", newJString(resourceGroupName))
  add(query_568896, "api-version", newJString(apiVersion))
  add(path_568895, "subscriptionId", newJString(subscriptionId))
  add(path_568895, "resourceName", newJString(resourceName))
  add(path_568895, "protectionContainerName", newJString(protectionContainerName))
  add(path_568895, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568894.call(path_568895, query_568896, nil, nil, nil)

var recoveryPointsListByReplicationProtectedItems* = Call_RecoveryPointsListByReplicationProtectedItems_568883(
    name: "recoveryPointsListByReplicationProtectedItems",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/recoveryPoints",
    validator: validate_RecoveryPointsListByReplicationProtectedItems_568884,
    base: "", url: url_RecoveryPointsListByReplicationProtectedItems_568885,
    schemes: {Scheme.Https})
type
  Call_RecoveryPointsGet_568897 = ref object of OpenApiRestCall_567668
proc url_RecoveryPointsGet_568899(protocol: Scheme; host: string; base: string;
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

proc validate_RecoveryPointsGet_568898(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get the details of specified recovery point.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   recoveryPointName: JString (required)
  ##                    : The recovery point name.
  ##   protectionContainerName: JString (required)
  ##                          : The protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : The replication protected item's name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568900 = path.getOrDefault("fabricName")
  valid_568900 = validateParameter(valid_568900, JString, required = true,
                                 default = nil)
  if valid_568900 != nil:
    section.add "fabricName", valid_568900
  var valid_568901 = path.getOrDefault("resourceGroupName")
  valid_568901 = validateParameter(valid_568901, JString, required = true,
                                 default = nil)
  if valid_568901 != nil:
    section.add "resourceGroupName", valid_568901
  var valid_568902 = path.getOrDefault("subscriptionId")
  valid_568902 = validateParameter(valid_568902, JString, required = true,
                                 default = nil)
  if valid_568902 != nil:
    section.add "subscriptionId", valid_568902
  var valid_568903 = path.getOrDefault("resourceName")
  valid_568903 = validateParameter(valid_568903, JString, required = true,
                                 default = nil)
  if valid_568903 != nil:
    section.add "resourceName", valid_568903
  var valid_568904 = path.getOrDefault("recoveryPointName")
  valid_568904 = validateParameter(valid_568904, JString, required = true,
                                 default = nil)
  if valid_568904 != nil:
    section.add "recoveryPointName", valid_568904
  var valid_568905 = path.getOrDefault("protectionContainerName")
  valid_568905 = validateParameter(valid_568905, JString, required = true,
                                 default = nil)
  if valid_568905 != nil:
    section.add "protectionContainerName", valid_568905
  var valid_568906 = path.getOrDefault("replicatedProtectedItemName")
  valid_568906 = validateParameter(valid_568906, JString, required = true,
                                 default = nil)
  if valid_568906 != nil:
    section.add "replicatedProtectedItemName", valid_568906
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568907 = query.getOrDefault("api-version")
  valid_568907 = validateParameter(valid_568907, JString, required = true,
                                 default = nil)
  if valid_568907 != nil:
    section.add "api-version", valid_568907
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568908: Call_RecoveryPointsGet_568897; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the details of specified recovery point.
  ## 
  let valid = call_568908.validator(path, query, header, formData, body)
  let scheme = call_568908.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568908.url(scheme.get, call_568908.host, call_568908.base,
                         call_568908.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568908, url, valid)

proc call*(call_568909: Call_RecoveryPointsGet_568897; fabricName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; recoveryPointName: string;
          protectionContainerName: string; replicatedProtectedItemName: string): Recallable =
  ## recoveryPointsGet
  ## Get the details of specified recovery point.
  ##   fabricName: string (required)
  ##             : The fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   recoveryPointName: string (required)
  ##                    : The recovery point name.
  ##   protectionContainerName: string (required)
  ##                          : The protection container name.
  ##   replicatedProtectedItemName: string (required)
  ##                              : The replication protected item's name.
  var path_568910 = newJObject()
  var query_568911 = newJObject()
  add(path_568910, "fabricName", newJString(fabricName))
  add(path_568910, "resourceGroupName", newJString(resourceGroupName))
  add(query_568911, "api-version", newJString(apiVersion))
  add(path_568910, "subscriptionId", newJString(subscriptionId))
  add(path_568910, "resourceName", newJString(resourceName))
  add(path_568910, "recoveryPointName", newJString(recoveryPointName))
  add(path_568910, "protectionContainerName", newJString(protectionContainerName))
  add(path_568910, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568909.call(path_568910, query_568911, nil, nil, nil)

var recoveryPointsGet* = Call_RecoveryPointsGet_568897(name: "recoveryPointsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/recoveryPoints/{recoveryPointName}",
    validator: validate_RecoveryPointsGet_568898, base: "",
    url: url_RecoveryPointsGet_568899, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsDelete_568912 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectedItemsDelete_568914(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectedItemsDelete_568913(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to disable replication on a replication protected item. This will also remove the item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : Replication protected item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568915 = path.getOrDefault("fabricName")
  valid_568915 = validateParameter(valid_568915, JString, required = true,
                                 default = nil)
  if valid_568915 != nil:
    section.add "fabricName", valid_568915
  var valid_568916 = path.getOrDefault("resourceGroupName")
  valid_568916 = validateParameter(valid_568916, JString, required = true,
                                 default = nil)
  if valid_568916 != nil:
    section.add "resourceGroupName", valid_568916
  var valid_568917 = path.getOrDefault("subscriptionId")
  valid_568917 = validateParameter(valid_568917, JString, required = true,
                                 default = nil)
  if valid_568917 != nil:
    section.add "subscriptionId", valid_568917
  var valid_568918 = path.getOrDefault("resourceName")
  valid_568918 = validateParameter(valid_568918, JString, required = true,
                                 default = nil)
  if valid_568918 != nil:
    section.add "resourceName", valid_568918
  var valid_568919 = path.getOrDefault("protectionContainerName")
  valid_568919 = validateParameter(valid_568919, JString, required = true,
                                 default = nil)
  if valid_568919 != nil:
    section.add "protectionContainerName", valid_568919
  var valid_568920 = path.getOrDefault("replicatedProtectedItemName")
  valid_568920 = validateParameter(valid_568920, JString, required = true,
                                 default = nil)
  if valid_568920 != nil:
    section.add "replicatedProtectedItemName", valid_568920
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568921 = query.getOrDefault("api-version")
  valid_568921 = validateParameter(valid_568921, JString, required = true,
                                 default = nil)
  if valid_568921 != nil:
    section.add "api-version", valid_568921
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

proc call*(call_568923: Call_ReplicationProtectedItemsDelete_568912;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to disable replication on a replication protected item. This will also remove the item.
  ## 
  let valid = call_568923.validator(path, query, header, formData, body)
  let scheme = call_568923.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568923.url(scheme.get, call_568923.host, call_568923.base,
                         call_568923.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568923, url, valid)

proc call*(call_568924: Call_ReplicationProtectedItemsDelete_568912;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; disableProtectionInput: JsonNode;
          replicatedProtectedItemName: string): Recallable =
  ## replicationProtectedItemsDelete
  ## The operation to disable replication on a replication protected item. This will also remove the item.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   disableProtectionInput: JObject (required)
  ##                         : Disable protection input.
  ##   replicatedProtectedItemName: string (required)
  ##                              : Replication protected item name.
  var path_568925 = newJObject()
  var query_568926 = newJObject()
  var body_568927 = newJObject()
  add(path_568925, "fabricName", newJString(fabricName))
  add(path_568925, "resourceGroupName", newJString(resourceGroupName))
  add(query_568926, "api-version", newJString(apiVersion))
  add(path_568925, "subscriptionId", newJString(subscriptionId))
  add(path_568925, "resourceName", newJString(resourceName))
  add(path_568925, "protectionContainerName", newJString(protectionContainerName))
  if disableProtectionInput != nil:
    body_568927 = disableProtectionInput
  add(path_568925, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568924.call(path_568925, query_568926, nil, nil, body_568927)

var replicationProtectedItemsDelete* = Call_ReplicationProtectedItemsDelete_568912(
    name: "replicationProtectedItemsDelete", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/remove",
    validator: validate_ReplicationProtectedItemsDelete_568913, base: "",
    url: url_ReplicationProtectedItemsDelete_568914, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsRepairReplication_568928 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectedItemsRepairReplication_568930(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsRepairReplication_568929(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to start resynchronize/repair replication for a replication protected item requiring resynchronization.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The name of the fabric.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : The name of the container.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : The name of the replication protected item.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568931 = path.getOrDefault("fabricName")
  valid_568931 = validateParameter(valid_568931, JString, required = true,
                                 default = nil)
  if valid_568931 != nil:
    section.add "fabricName", valid_568931
  var valid_568932 = path.getOrDefault("resourceGroupName")
  valid_568932 = validateParameter(valid_568932, JString, required = true,
                                 default = nil)
  if valid_568932 != nil:
    section.add "resourceGroupName", valid_568932
  var valid_568933 = path.getOrDefault("subscriptionId")
  valid_568933 = validateParameter(valid_568933, JString, required = true,
                                 default = nil)
  if valid_568933 != nil:
    section.add "subscriptionId", valid_568933
  var valid_568934 = path.getOrDefault("resourceName")
  valid_568934 = validateParameter(valid_568934, JString, required = true,
                                 default = nil)
  if valid_568934 != nil:
    section.add "resourceName", valid_568934
  var valid_568935 = path.getOrDefault("protectionContainerName")
  valid_568935 = validateParameter(valid_568935, JString, required = true,
                                 default = nil)
  if valid_568935 != nil:
    section.add "protectionContainerName", valid_568935
  var valid_568936 = path.getOrDefault("replicatedProtectedItemName")
  valid_568936 = validateParameter(valid_568936, JString, required = true,
                                 default = nil)
  if valid_568936 != nil:
    section.add "replicatedProtectedItemName", valid_568936
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568937 = query.getOrDefault("api-version")
  valid_568937 = validateParameter(valid_568937, JString, required = true,
                                 default = nil)
  if valid_568937 != nil:
    section.add "api-version", valid_568937
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568938: Call_ReplicationProtectedItemsRepairReplication_568928;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to start resynchronize/repair replication for a replication protected item requiring resynchronization.
  ## 
  let valid = call_568938.validator(path, query, header, formData, body)
  let scheme = call_568938.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568938.url(scheme.get, call_568938.host, call_568938.base,
                         call_568938.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568938, url, valid)

proc call*(call_568939: Call_ReplicationProtectedItemsRepairReplication_568928;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; replicatedProtectedItemName: string): Recallable =
  ## replicationProtectedItemsRepairReplication
  ## The operation to start resynchronize/repair replication for a replication protected item requiring resynchronization.
  ##   fabricName: string (required)
  ##             : The name of the fabric.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : The name of the container.
  ##   replicatedProtectedItemName: string (required)
  ##                              : The name of the replication protected item.
  var path_568940 = newJObject()
  var query_568941 = newJObject()
  add(path_568940, "fabricName", newJString(fabricName))
  add(path_568940, "resourceGroupName", newJString(resourceGroupName))
  add(query_568941, "api-version", newJString(apiVersion))
  add(path_568940, "subscriptionId", newJString(subscriptionId))
  add(path_568940, "resourceName", newJString(resourceName))
  add(path_568940, "protectionContainerName", newJString(protectionContainerName))
  add(path_568940, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568939.call(path_568940, query_568941, nil, nil, nil)

var replicationProtectedItemsRepairReplication* = Call_ReplicationProtectedItemsRepairReplication_568928(
    name: "replicationProtectedItemsRepairReplication", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/repairReplication",
    validator: validate_ReplicationProtectedItemsRepairReplication_568929,
    base: "", url: url_ReplicationProtectedItemsRepairReplication_568930,
    schemes: {Scheme.Https})
type
  Call_TargetComputeSizesListByReplicationProtectedItems_568942 = ref object of OpenApiRestCall_567668
proc url_TargetComputeSizesListByReplicationProtectedItems_568944(
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

proc validate_TargetComputeSizesListByReplicationProtectedItems_568943(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the available target compute sizes for a replication protected item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : Replication protected item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568945 = path.getOrDefault("fabricName")
  valid_568945 = validateParameter(valid_568945, JString, required = true,
                                 default = nil)
  if valid_568945 != nil:
    section.add "fabricName", valid_568945
  var valid_568946 = path.getOrDefault("resourceGroupName")
  valid_568946 = validateParameter(valid_568946, JString, required = true,
                                 default = nil)
  if valid_568946 != nil:
    section.add "resourceGroupName", valid_568946
  var valid_568947 = path.getOrDefault("subscriptionId")
  valid_568947 = validateParameter(valid_568947, JString, required = true,
                                 default = nil)
  if valid_568947 != nil:
    section.add "subscriptionId", valid_568947
  var valid_568948 = path.getOrDefault("resourceName")
  valid_568948 = validateParameter(valid_568948, JString, required = true,
                                 default = nil)
  if valid_568948 != nil:
    section.add "resourceName", valid_568948
  var valid_568949 = path.getOrDefault("protectionContainerName")
  valid_568949 = validateParameter(valid_568949, JString, required = true,
                                 default = nil)
  if valid_568949 != nil:
    section.add "protectionContainerName", valid_568949
  var valid_568950 = path.getOrDefault("replicatedProtectedItemName")
  valid_568950 = validateParameter(valid_568950, JString, required = true,
                                 default = nil)
  if valid_568950 != nil:
    section.add "replicatedProtectedItemName", valid_568950
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568951 = query.getOrDefault("api-version")
  valid_568951 = validateParameter(valid_568951, JString, required = true,
                                 default = nil)
  if valid_568951 != nil:
    section.add "api-version", valid_568951
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568952: Call_TargetComputeSizesListByReplicationProtectedItems_568942;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the available target compute sizes for a replication protected item.
  ## 
  let valid = call_568952.validator(path, query, header, formData, body)
  let scheme = call_568952.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568952.url(scheme.get, call_568952.host, call_568952.base,
                         call_568952.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568952, url, valid)

proc call*(call_568953: Call_TargetComputeSizesListByReplicationProtectedItems_568942;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; replicatedProtectedItemName: string): Recallable =
  ## targetComputeSizesListByReplicationProtectedItems
  ## Lists the available target compute sizes for a replication protected item.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : protection container name.
  ##   replicatedProtectedItemName: string (required)
  ##                              : Replication protected item name.
  var path_568954 = newJObject()
  var query_568955 = newJObject()
  add(path_568954, "fabricName", newJString(fabricName))
  add(path_568954, "resourceGroupName", newJString(resourceGroupName))
  add(query_568955, "api-version", newJString(apiVersion))
  add(path_568954, "subscriptionId", newJString(subscriptionId))
  add(path_568954, "resourceName", newJString(resourceName))
  add(path_568954, "protectionContainerName", newJString(protectionContainerName))
  add(path_568954, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568953.call(path_568954, query_568955, nil, nil, nil)

var targetComputeSizesListByReplicationProtectedItems* = Call_TargetComputeSizesListByReplicationProtectedItems_568942(
    name: "targetComputeSizesListByReplicationProtectedItems",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/targetComputeSizes",
    validator: validate_TargetComputeSizesListByReplicationProtectedItems_568943,
    base: "", url: url_TargetComputeSizesListByReplicationProtectedItems_568944,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsTestFailover_568956 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectedItemsTestFailover_568958(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsTestFailover_568957(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Operation to perform a test failover of the replication protected item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Unique fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : Replication protected item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568959 = path.getOrDefault("fabricName")
  valid_568959 = validateParameter(valid_568959, JString, required = true,
                                 default = nil)
  if valid_568959 != nil:
    section.add "fabricName", valid_568959
  var valid_568960 = path.getOrDefault("resourceGroupName")
  valid_568960 = validateParameter(valid_568960, JString, required = true,
                                 default = nil)
  if valid_568960 != nil:
    section.add "resourceGroupName", valid_568960
  var valid_568961 = path.getOrDefault("subscriptionId")
  valid_568961 = validateParameter(valid_568961, JString, required = true,
                                 default = nil)
  if valid_568961 != nil:
    section.add "subscriptionId", valid_568961
  var valid_568962 = path.getOrDefault("resourceName")
  valid_568962 = validateParameter(valid_568962, JString, required = true,
                                 default = nil)
  if valid_568962 != nil:
    section.add "resourceName", valid_568962
  var valid_568963 = path.getOrDefault("protectionContainerName")
  valid_568963 = validateParameter(valid_568963, JString, required = true,
                                 default = nil)
  if valid_568963 != nil:
    section.add "protectionContainerName", valid_568963
  var valid_568964 = path.getOrDefault("replicatedProtectedItemName")
  valid_568964 = validateParameter(valid_568964, JString, required = true,
                                 default = nil)
  if valid_568964 != nil:
    section.add "replicatedProtectedItemName", valid_568964
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568965 = query.getOrDefault("api-version")
  valid_568965 = validateParameter(valid_568965, JString, required = true,
                                 default = nil)
  if valid_568965 != nil:
    section.add "api-version", valid_568965
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

proc call*(call_568967: Call_ReplicationProtectedItemsTestFailover_568956;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to perform a test failover of the replication protected item.
  ## 
  let valid = call_568967.validator(path, query, header, formData, body)
  let scheme = call_568967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568967.url(scheme.get, call_568967.host, call_568967.base,
                         call_568967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568967, url, valid)

proc call*(call_568968: Call_ReplicationProtectedItemsTestFailover_568956;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; failoverInput: JsonNode;
          replicatedProtectedItemName: string): Recallable =
  ## replicationProtectedItemsTestFailover
  ## Operation to perform a test failover of the replication protected item.
  ##   fabricName: string (required)
  ##             : Unique fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   failoverInput: JObject (required)
  ##                : Test failover input.
  ##   replicatedProtectedItemName: string (required)
  ##                              : Replication protected item name.
  var path_568969 = newJObject()
  var query_568970 = newJObject()
  var body_568971 = newJObject()
  add(path_568969, "fabricName", newJString(fabricName))
  add(path_568969, "resourceGroupName", newJString(resourceGroupName))
  add(query_568970, "api-version", newJString(apiVersion))
  add(path_568969, "subscriptionId", newJString(subscriptionId))
  add(path_568969, "resourceName", newJString(resourceName))
  add(path_568969, "protectionContainerName", newJString(protectionContainerName))
  if failoverInput != nil:
    body_568971 = failoverInput
  add(path_568969, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568968.call(path_568969, query_568970, nil, nil, body_568971)

var replicationProtectedItemsTestFailover* = Call_ReplicationProtectedItemsTestFailover_568956(
    name: "replicationProtectedItemsTestFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/testFailover",
    validator: validate_ReplicationProtectedItemsTestFailover_568957, base: "",
    url: url_ReplicationProtectedItemsTestFailover_568958, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsTestFailoverCleanup_568972 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectedItemsTestFailoverCleanup_568974(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsTestFailoverCleanup_568973(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Operation to clean up the test failover of a replication protected item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Unique fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : Replication protected item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568975 = path.getOrDefault("fabricName")
  valid_568975 = validateParameter(valid_568975, JString, required = true,
                                 default = nil)
  if valid_568975 != nil:
    section.add "fabricName", valid_568975
  var valid_568976 = path.getOrDefault("resourceGroupName")
  valid_568976 = validateParameter(valid_568976, JString, required = true,
                                 default = nil)
  if valid_568976 != nil:
    section.add "resourceGroupName", valid_568976
  var valid_568977 = path.getOrDefault("subscriptionId")
  valid_568977 = validateParameter(valid_568977, JString, required = true,
                                 default = nil)
  if valid_568977 != nil:
    section.add "subscriptionId", valid_568977
  var valid_568978 = path.getOrDefault("resourceName")
  valid_568978 = validateParameter(valid_568978, JString, required = true,
                                 default = nil)
  if valid_568978 != nil:
    section.add "resourceName", valid_568978
  var valid_568979 = path.getOrDefault("protectionContainerName")
  valid_568979 = validateParameter(valid_568979, JString, required = true,
                                 default = nil)
  if valid_568979 != nil:
    section.add "protectionContainerName", valid_568979
  var valid_568980 = path.getOrDefault("replicatedProtectedItemName")
  valid_568980 = validateParameter(valid_568980, JString, required = true,
                                 default = nil)
  if valid_568980 != nil:
    section.add "replicatedProtectedItemName", valid_568980
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568981 = query.getOrDefault("api-version")
  valid_568981 = validateParameter(valid_568981, JString, required = true,
                                 default = nil)
  if valid_568981 != nil:
    section.add "api-version", valid_568981
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

proc call*(call_568983: Call_ReplicationProtectedItemsTestFailoverCleanup_568972;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to clean up the test failover of a replication protected item.
  ## 
  let valid = call_568983.validator(path, query, header, formData, body)
  let scheme = call_568983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568983.url(scheme.get, call_568983.host, call_568983.base,
                         call_568983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568983, url, valid)

proc call*(call_568984: Call_ReplicationProtectedItemsTestFailoverCleanup_568972;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          cleanupInput: JsonNode; subscriptionId: string; resourceName: string;
          protectionContainerName: string; replicatedProtectedItemName: string): Recallable =
  ## replicationProtectedItemsTestFailoverCleanup
  ## Operation to clean up the test failover of a replication protected item.
  ##   fabricName: string (required)
  ##             : Unique fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   cleanupInput: JObject (required)
  ##               : Test failover cleanup input.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: string (required)
  ##                              : Replication protected item name.
  var path_568985 = newJObject()
  var query_568986 = newJObject()
  var body_568987 = newJObject()
  add(path_568985, "fabricName", newJString(fabricName))
  add(path_568985, "resourceGroupName", newJString(resourceGroupName))
  add(query_568986, "api-version", newJString(apiVersion))
  if cleanupInput != nil:
    body_568987 = cleanupInput
  add(path_568985, "subscriptionId", newJString(subscriptionId))
  add(path_568985, "resourceName", newJString(resourceName))
  add(path_568985, "protectionContainerName", newJString(protectionContainerName))
  add(path_568985, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568984.call(path_568985, query_568986, nil, nil, body_568987)

var replicationProtectedItemsTestFailoverCleanup* = Call_ReplicationProtectedItemsTestFailoverCleanup_568972(
    name: "replicationProtectedItemsTestFailoverCleanup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/testFailoverCleanup",
    validator: validate_ReplicationProtectedItemsTestFailoverCleanup_568973,
    base: "", url: url_ReplicationProtectedItemsTestFailoverCleanup_568974,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsUnplannedFailover_568988 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectedItemsUnplannedFailover_568990(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsUnplannedFailover_568989(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Operation to initiate a failover of the replication protected item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Unique fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: JString (required)
  ##                              : Replication protected item name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_568991 = path.getOrDefault("fabricName")
  valid_568991 = validateParameter(valid_568991, JString, required = true,
                                 default = nil)
  if valid_568991 != nil:
    section.add "fabricName", valid_568991
  var valid_568992 = path.getOrDefault("resourceGroupName")
  valid_568992 = validateParameter(valid_568992, JString, required = true,
                                 default = nil)
  if valid_568992 != nil:
    section.add "resourceGroupName", valid_568992
  var valid_568993 = path.getOrDefault("subscriptionId")
  valid_568993 = validateParameter(valid_568993, JString, required = true,
                                 default = nil)
  if valid_568993 != nil:
    section.add "subscriptionId", valid_568993
  var valid_568994 = path.getOrDefault("resourceName")
  valid_568994 = validateParameter(valid_568994, JString, required = true,
                                 default = nil)
  if valid_568994 != nil:
    section.add "resourceName", valid_568994
  var valid_568995 = path.getOrDefault("protectionContainerName")
  valid_568995 = validateParameter(valid_568995, JString, required = true,
                                 default = nil)
  if valid_568995 != nil:
    section.add "protectionContainerName", valid_568995
  var valid_568996 = path.getOrDefault("replicatedProtectedItemName")
  valid_568996 = validateParameter(valid_568996, JString, required = true,
                                 default = nil)
  if valid_568996 != nil:
    section.add "replicatedProtectedItemName", valid_568996
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568997 = query.getOrDefault("api-version")
  valid_568997 = validateParameter(valid_568997, JString, required = true,
                                 default = nil)
  if valid_568997 != nil:
    section.add "api-version", valid_568997
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

proc call*(call_568999: Call_ReplicationProtectedItemsUnplannedFailover_568988;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to initiate a failover of the replication protected item.
  ## 
  let valid = call_568999.validator(path, query, header, formData, body)
  let scheme = call_568999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568999.url(scheme.get, call_568999.host, call_568999.base,
                         call_568999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568999, url, valid)

proc call*(call_569000: Call_ReplicationProtectedItemsUnplannedFailover_568988;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; failoverInput: JsonNode;
          replicatedProtectedItemName: string): Recallable =
  ## replicationProtectedItemsUnplannedFailover
  ## Operation to initiate a failover of the replication protected item.
  ##   fabricName: string (required)
  ##             : Unique fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   failoverInput: JObject (required)
  ##                : Disable protection input.
  ##   replicatedProtectedItemName: string (required)
  ##                              : Replication protected item name.
  var path_569001 = newJObject()
  var query_569002 = newJObject()
  var body_569003 = newJObject()
  add(path_569001, "fabricName", newJString(fabricName))
  add(path_569001, "resourceGroupName", newJString(resourceGroupName))
  add(query_569002, "api-version", newJString(apiVersion))
  add(path_569001, "subscriptionId", newJString(subscriptionId))
  add(path_569001, "resourceName", newJString(resourceName))
  add(path_569001, "protectionContainerName", newJString(protectionContainerName))
  if failoverInput != nil:
    body_569003 = failoverInput
  add(path_569001, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_569000.call(path_569001, query_569002, nil, nil, body_569003)

var replicationProtectedItemsUnplannedFailover* = Call_ReplicationProtectedItemsUnplannedFailover_568988(
    name: "replicationProtectedItemsUnplannedFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/unplannedFailover",
    validator: validate_ReplicationProtectedItemsUnplannedFailover_568989,
    base: "", url: url_ReplicationProtectedItemsUnplannedFailover_568990,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsUpdateMobilityService_569004 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectedItemsUpdateMobilityService_569006(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsUpdateMobilityService_569005(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The operation to update(push update) the installed mobility service software on a replication protected item to the latest available version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : The name of the fabric containing the protected item.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : The name of the container containing the protected item.
  ##   replicationProtectedItemName: JString (required)
  ##                               : The name of the protected item on which the agent is to be updated.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_569007 = path.getOrDefault("fabricName")
  valid_569007 = validateParameter(valid_569007, JString, required = true,
                                 default = nil)
  if valid_569007 != nil:
    section.add "fabricName", valid_569007
  var valid_569008 = path.getOrDefault("resourceGroupName")
  valid_569008 = validateParameter(valid_569008, JString, required = true,
                                 default = nil)
  if valid_569008 != nil:
    section.add "resourceGroupName", valid_569008
  var valid_569009 = path.getOrDefault("subscriptionId")
  valid_569009 = validateParameter(valid_569009, JString, required = true,
                                 default = nil)
  if valid_569009 != nil:
    section.add "subscriptionId", valid_569009
  var valid_569010 = path.getOrDefault("resourceName")
  valid_569010 = validateParameter(valid_569010, JString, required = true,
                                 default = nil)
  if valid_569010 != nil:
    section.add "resourceName", valid_569010
  var valid_569011 = path.getOrDefault("protectionContainerName")
  valid_569011 = validateParameter(valid_569011, JString, required = true,
                                 default = nil)
  if valid_569011 != nil:
    section.add "protectionContainerName", valid_569011
  var valid_569012 = path.getOrDefault("replicationProtectedItemName")
  valid_569012 = validateParameter(valid_569012, JString, required = true,
                                 default = nil)
  if valid_569012 != nil:
    section.add "replicationProtectedItemName", valid_569012
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569013 = query.getOrDefault("api-version")
  valid_569013 = validateParameter(valid_569013, JString, required = true,
                                 default = nil)
  if valid_569013 != nil:
    section.add "api-version", valid_569013
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

proc call*(call_569015: Call_ReplicationProtectedItemsUpdateMobilityService_569004;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to update(push update) the installed mobility service software on a replication protected item to the latest available version.
  ## 
  let valid = call_569015.validator(path, query, header, formData, body)
  let scheme = call_569015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569015.url(scheme.get, call_569015.host, call_569015.base,
                         call_569015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569015, url, valid)

proc call*(call_569016: Call_ReplicationProtectedItemsUpdateMobilityService_569004;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          updateMobilityServiceRequest: JsonNode; subscriptionId: string;
          resourceName: string; protectionContainerName: string;
          replicationProtectedItemName: string): Recallable =
  ## replicationProtectedItemsUpdateMobilityService
  ## The operation to update(push update) the installed mobility service software on a replication protected item to the latest available version.
  ##   fabricName: string (required)
  ##             : The name of the fabric containing the protected item.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   updateMobilityServiceRequest: JObject (required)
  ##                               : Request to update the mobility service on the protected item.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : The name of the container containing the protected item.
  ##   replicationProtectedItemName: string (required)
  ##                               : The name of the protected item on which the agent is to be updated.
  var path_569017 = newJObject()
  var query_569018 = newJObject()
  var body_569019 = newJObject()
  add(path_569017, "fabricName", newJString(fabricName))
  add(path_569017, "resourceGroupName", newJString(resourceGroupName))
  add(query_569018, "api-version", newJString(apiVersion))
  if updateMobilityServiceRequest != nil:
    body_569019 = updateMobilityServiceRequest
  add(path_569017, "subscriptionId", newJString(subscriptionId))
  add(path_569017, "resourceName", newJString(resourceName))
  add(path_569017, "protectionContainerName", newJString(protectionContainerName))
  add(path_569017, "replicationProtectedItemName",
      newJString(replicationProtectedItemName))
  result = call_569016.call(path_569017, query_569018, nil, nil, body_569019)

var replicationProtectedItemsUpdateMobilityService* = Call_ReplicationProtectedItemsUpdateMobilityService_569004(
    name: "replicationProtectedItemsUpdateMobilityService",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicationProtectedItemName}/updateMobilityService",
    validator: validate_ReplicationProtectedItemsUpdateMobilityService_569005,
    base: "", url: url_ReplicationProtectedItemsUpdateMobilityService_569006,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_569020 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_569022(
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

proc validate_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_569021(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the protection container mappings for a protection container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_569023 = path.getOrDefault("fabricName")
  valid_569023 = validateParameter(valid_569023, JString, required = true,
                                 default = nil)
  if valid_569023 != nil:
    section.add "fabricName", valid_569023
  var valid_569024 = path.getOrDefault("resourceGroupName")
  valid_569024 = validateParameter(valid_569024, JString, required = true,
                                 default = nil)
  if valid_569024 != nil:
    section.add "resourceGroupName", valid_569024
  var valid_569025 = path.getOrDefault("subscriptionId")
  valid_569025 = validateParameter(valid_569025, JString, required = true,
                                 default = nil)
  if valid_569025 != nil:
    section.add "subscriptionId", valid_569025
  var valid_569026 = path.getOrDefault("resourceName")
  valid_569026 = validateParameter(valid_569026, JString, required = true,
                                 default = nil)
  if valid_569026 != nil:
    section.add "resourceName", valid_569026
  var valid_569027 = path.getOrDefault("protectionContainerName")
  valid_569027 = validateParameter(valid_569027, JString, required = true,
                                 default = nil)
  if valid_569027 != nil:
    section.add "protectionContainerName", valid_569027
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569028 = query.getOrDefault("api-version")
  valid_569028 = validateParameter(valid_569028, JString, required = true,
                                 default = nil)
  if valid_569028 != nil:
    section.add "api-version", valid_569028
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569029: Call_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_569020;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the protection container mappings for a protection container.
  ## 
  let valid = call_569029.validator(path, query, header, formData, body)
  let scheme = call_569029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569029.url(scheme.get, call_569029.host, call_569029.base,
                         call_569029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569029, url, valid)

proc call*(call_569030: Call_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_569020;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string): Recallable =
  ## replicationProtectionContainerMappingsListByReplicationProtectionContainers
  ## Lists the protection container mappings for a protection container.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  var path_569031 = newJObject()
  var query_569032 = newJObject()
  add(path_569031, "fabricName", newJString(fabricName))
  add(path_569031, "resourceGroupName", newJString(resourceGroupName))
  add(query_569032, "api-version", newJString(apiVersion))
  add(path_569031, "subscriptionId", newJString(subscriptionId))
  add(path_569031, "resourceName", newJString(resourceName))
  add(path_569031, "protectionContainerName", newJString(protectionContainerName))
  result = call_569030.call(path_569031, query_569032, nil, nil, nil)

var replicationProtectionContainerMappingsListByReplicationProtectionContainers* = Call_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_569020(name: "replicationProtectionContainerMappingsListByReplicationProtectionContainers",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings", validator: validate_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_569021,
    base: "", url: url_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_569022,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsCreate_569047 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectionContainerMappingsCreate_569049(protocol: Scheme;
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

proc validate_ReplicationProtectionContainerMappingsCreate_569048(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create a protection container mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   mappingName: JString (required)
  ##              : Protection container mapping name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_569050 = path.getOrDefault("fabricName")
  valid_569050 = validateParameter(valid_569050, JString, required = true,
                                 default = nil)
  if valid_569050 != nil:
    section.add "fabricName", valid_569050
  var valid_569051 = path.getOrDefault("resourceGroupName")
  valid_569051 = validateParameter(valid_569051, JString, required = true,
                                 default = nil)
  if valid_569051 != nil:
    section.add "resourceGroupName", valid_569051
  var valid_569052 = path.getOrDefault("mappingName")
  valid_569052 = validateParameter(valid_569052, JString, required = true,
                                 default = nil)
  if valid_569052 != nil:
    section.add "mappingName", valid_569052
  var valid_569053 = path.getOrDefault("subscriptionId")
  valid_569053 = validateParameter(valid_569053, JString, required = true,
                                 default = nil)
  if valid_569053 != nil:
    section.add "subscriptionId", valid_569053
  var valid_569054 = path.getOrDefault("resourceName")
  valid_569054 = validateParameter(valid_569054, JString, required = true,
                                 default = nil)
  if valid_569054 != nil:
    section.add "resourceName", valid_569054
  var valid_569055 = path.getOrDefault("protectionContainerName")
  valid_569055 = validateParameter(valid_569055, JString, required = true,
                                 default = nil)
  if valid_569055 != nil:
    section.add "protectionContainerName", valid_569055
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569056 = query.getOrDefault("api-version")
  valid_569056 = validateParameter(valid_569056, JString, required = true,
                                 default = nil)
  if valid_569056 != nil:
    section.add "api-version", valid_569056
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

proc call*(call_569058: Call_ReplicationProtectionContainerMappingsCreate_569047;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create a protection container mapping.
  ## 
  let valid = call_569058.validator(path, query, header, formData, body)
  let scheme = call_569058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569058.url(scheme.get, call_569058.host, call_569058.base,
                         call_569058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569058, url, valid)

proc call*(call_569059: Call_ReplicationProtectionContainerMappingsCreate_569047;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          mappingName: string; creationInput: JsonNode; subscriptionId: string;
          resourceName: string; protectionContainerName: string): Recallable =
  ## replicationProtectionContainerMappingsCreate
  ## The operation to create a protection container mapping.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   mappingName: string (required)
  ##              : Protection container mapping name.
  ##   creationInput: JObject (required)
  ##                : Mapping creation input.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  var path_569060 = newJObject()
  var query_569061 = newJObject()
  var body_569062 = newJObject()
  add(path_569060, "fabricName", newJString(fabricName))
  add(path_569060, "resourceGroupName", newJString(resourceGroupName))
  add(query_569061, "api-version", newJString(apiVersion))
  add(path_569060, "mappingName", newJString(mappingName))
  if creationInput != nil:
    body_569062 = creationInput
  add(path_569060, "subscriptionId", newJString(subscriptionId))
  add(path_569060, "resourceName", newJString(resourceName))
  add(path_569060, "protectionContainerName", newJString(protectionContainerName))
  result = call_569059.call(path_569060, query_569061, nil, nil, body_569062)

var replicationProtectionContainerMappingsCreate* = Call_ReplicationProtectionContainerMappingsCreate_569047(
    name: "replicationProtectionContainerMappingsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}",
    validator: validate_ReplicationProtectionContainerMappingsCreate_569048,
    base: "", url: url_ReplicationProtectionContainerMappingsCreate_569049,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsGet_569033 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectionContainerMappingsGet_569035(protocol: Scheme;
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

proc validate_ReplicationProtectionContainerMappingsGet_569034(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of a protection container mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   mappingName: JString (required)
  ##              : Protection Container mapping name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_569036 = path.getOrDefault("fabricName")
  valid_569036 = validateParameter(valid_569036, JString, required = true,
                                 default = nil)
  if valid_569036 != nil:
    section.add "fabricName", valid_569036
  var valid_569037 = path.getOrDefault("resourceGroupName")
  valid_569037 = validateParameter(valid_569037, JString, required = true,
                                 default = nil)
  if valid_569037 != nil:
    section.add "resourceGroupName", valid_569037
  var valid_569038 = path.getOrDefault("mappingName")
  valid_569038 = validateParameter(valid_569038, JString, required = true,
                                 default = nil)
  if valid_569038 != nil:
    section.add "mappingName", valid_569038
  var valid_569039 = path.getOrDefault("subscriptionId")
  valid_569039 = validateParameter(valid_569039, JString, required = true,
                                 default = nil)
  if valid_569039 != nil:
    section.add "subscriptionId", valid_569039
  var valid_569040 = path.getOrDefault("resourceName")
  valid_569040 = validateParameter(valid_569040, JString, required = true,
                                 default = nil)
  if valid_569040 != nil:
    section.add "resourceName", valid_569040
  var valid_569041 = path.getOrDefault("protectionContainerName")
  valid_569041 = validateParameter(valid_569041, JString, required = true,
                                 default = nil)
  if valid_569041 != nil:
    section.add "protectionContainerName", valid_569041
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569042 = query.getOrDefault("api-version")
  valid_569042 = validateParameter(valid_569042, JString, required = true,
                                 default = nil)
  if valid_569042 != nil:
    section.add "api-version", valid_569042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569043: Call_ReplicationProtectionContainerMappingsGet_569033;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of a protection container mapping.
  ## 
  let valid = call_569043.validator(path, query, header, formData, body)
  let scheme = call_569043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569043.url(scheme.get, call_569043.host, call_569043.base,
                         call_569043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569043, url, valid)

proc call*(call_569044: Call_ReplicationProtectionContainerMappingsGet_569033;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          mappingName: string; subscriptionId: string; resourceName: string;
          protectionContainerName: string): Recallable =
  ## replicationProtectionContainerMappingsGet
  ## Gets the details of a protection container mapping.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   mappingName: string (required)
  ##              : Protection Container mapping name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  var path_569045 = newJObject()
  var query_569046 = newJObject()
  add(path_569045, "fabricName", newJString(fabricName))
  add(path_569045, "resourceGroupName", newJString(resourceGroupName))
  add(query_569046, "api-version", newJString(apiVersion))
  add(path_569045, "mappingName", newJString(mappingName))
  add(path_569045, "subscriptionId", newJString(subscriptionId))
  add(path_569045, "resourceName", newJString(resourceName))
  add(path_569045, "protectionContainerName", newJString(protectionContainerName))
  result = call_569044.call(path_569045, query_569046, nil, nil, nil)

var replicationProtectionContainerMappingsGet* = Call_ReplicationProtectionContainerMappingsGet_569033(
    name: "replicationProtectionContainerMappingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}",
    validator: validate_ReplicationProtectionContainerMappingsGet_569034,
    base: "", url: url_ReplicationProtectionContainerMappingsGet_569035,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsUpdate_569077 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectionContainerMappingsUpdate_569079(protocol: Scheme;
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

proc validate_ReplicationProtectionContainerMappingsUpdate_569078(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update protection container mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   mappingName: JString (required)
  ##              : Protection container mapping name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_569080 = path.getOrDefault("fabricName")
  valid_569080 = validateParameter(valid_569080, JString, required = true,
                                 default = nil)
  if valid_569080 != nil:
    section.add "fabricName", valid_569080
  var valid_569081 = path.getOrDefault("resourceGroupName")
  valid_569081 = validateParameter(valid_569081, JString, required = true,
                                 default = nil)
  if valid_569081 != nil:
    section.add "resourceGroupName", valid_569081
  var valid_569082 = path.getOrDefault("mappingName")
  valid_569082 = validateParameter(valid_569082, JString, required = true,
                                 default = nil)
  if valid_569082 != nil:
    section.add "mappingName", valid_569082
  var valid_569083 = path.getOrDefault("subscriptionId")
  valid_569083 = validateParameter(valid_569083, JString, required = true,
                                 default = nil)
  if valid_569083 != nil:
    section.add "subscriptionId", valid_569083
  var valid_569084 = path.getOrDefault("resourceName")
  valid_569084 = validateParameter(valid_569084, JString, required = true,
                                 default = nil)
  if valid_569084 != nil:
    section.add "resourceName", valid_569084
  var valid_569085 = path.getOrDefault("protectionContainerName")
  valid_569085 = validateParameter(valid_569085, JString, required = true,
                                 default = nil)
  if valid_569085 != nil:
    section.add "protectionContainerName", valid_569085
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569086 = query.getOrDefault("api-version")
  valid_569086 = validateParameter(valid_569086, JString, required = true,
                                 default = nil)
  if valid_569086 != nil:
    section.add "api-version", valid_569086
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

proc call*(call_569088: Call_ReplicationProtectionContainerMappingsUpdate_569077;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to update protection container mapping.
  ## 
  let valid = call_569088.validator(path, query, header, formData, body)
  let scheme = call_569088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569088.url(scheme.get, call_569088.host, call_569088.base,
                         call_569088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569088, url, valid)

proc call*(call_569089: Call_ReplicationProtectionContainerMappingsUpdate_569077;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          mappingName: string; subscriptionId: string; updateInput: JsonNode;
          resourceName: string; protectionContainerName: string): Recallable =
  ## replicationProtectionContainerMappingsUpdate
  ## The operation to update protection container mapping.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   mappingName: string (required)
  ##              : Protection container mapping name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   updateInput: JObject (required)
  ##              : Mapping update input.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  var path_569090 = newJObject()
  var query_569091 = newJObject()
  var body_569092 = newJObject()
  add(path_569090, "fabricName", newJString(fabricName))
  add(path_569090, "resourceGroupName", newJString(resourceGroupName))
  add(query_569091, "api-version", newJString(apiVersion))
  add(path_569090, "mappingName", newJString(mappingName))
  add(path_569090, "subscriptionId", newJString(subscriptionId))
  if updateInput != nil:
    body_569092 = updateInput
  add(path_569090, "resourceName", newJString(resourceName))
  add(path_569090, "protectionContainerName", newJString(protectionContainerName))
  result = call_569089.call(path_569090, query_569091, nil, nil, body_569092)

var replicationProtectionContainerMappingsUpdate* = Call_ReplicationProtectionContainerMappingsUpdate_569077(
    name: "replicationProtectionContainerMappingsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}",
    validator: validate_ReplicationProtectionContainerMappingsUpdate_569078,
    base: "", url: url_ReplicationProtectionContainerMappingsUpdate_569079,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsPurge_569063 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectionContainerMappingsPurge_569065(protocol: Scheme;
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

proc validate_ReplicationProtectionContainerMappingsPurge_569064(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to purge(force delete) a protection container mapping
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   mappingName: JString (required)
  ##              : Protection container mapping name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_569066 = path.getOrDefault("fabricName")
  valid_569066 = validateParameter(valid_569066, JString, required = true,
                                 default = nil)
  if valid_569066 != nil:
    section.add "fabricName", valid_569066
  var valid_569067 = path.getOrDefault("resourceGroupName")
  valid_569067 = validateParameter(valid_569067, JString, required = true,
                                 default = nil)
  if valid_569067 != nil:
    section.add "resourceGroupName", valid_569067
  var valid_569068 = path.getOrDefault("mappingName")
  valid_569068 = validateParameter(valid_569068, JString, required = true,
                                 default = nil)
  if valid_569068 != nil:
    section.add "mappingName", valid_569068
  var valid_569069 = path.getOrDefault("subscriptionId")
  valid_569069 = validateParameter(valid_569069, JString, required = true,
                                 default = nil)
  if valid_569069 != nil:
    section.add "subscriptionId", valid_569069
  var valid_569070 = path.getOrDefault("resourceName")
  valid_569070 = validateParameter(valid_569070, JString, required = true,
                                 default = nil)
  if valid_569070 != nil:
    section.add "resourceName", valid_569070
  var valid_569071 = path.getOrDefault("protectionContainerName")
  valid_569071 = validateParameter(valid_569071, JString, required = true,
                                 default = nil)
  if valid_569071 != nil:
    section.add "protectionContainerName", valid_569071
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569072 = query.getOrDefault("api-version")
  valid_569072 = validateParameter(valid_569072, JString, required = true,
                                 default = nil)
  if valid_569072 != nil:
    section.add "api-version", valid_569072
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569073: Call_ReplicationProtectionContainerMappingsPurge_569063;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to purge(force delete) a protection container mapping
  ## 
  let valid = call_569073.validator(path, query, header, formData, body)
  let scheme = call_569073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569073.url(scheme.get, call_569073.host, call_569073.base,
                         call_569073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569073, url, valid)

proc call*(call_569074: Call_ReplicationProtectionContainerMappingsPurge_569063;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          mappingName: string; subscriptionId: string; resourceName: string;
          protectionContainerName: string): Recallable =
  ## replicationProtectionContainerMappingsPurge
  ## The operation to purge(force delete) a protection container mapping
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   mappingName: string (required)
  ##              : Protection container mapping name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  var path_569075 = newJObject()
  var query_569076 = newJObject()
  add(path_569075, "fabricName", newJString(fabricName))
  add(path_569075, "resourceGroupName", newJString(resourceGroupName))
  add(query_569076, "api-version", newJString(apiVersion))
  add(path_569075, "mappingName", newJString(mappingName))
  add(path_569075, "subscriptionId", newJString(subscriptionId))
  add(path_569075, "resourceName", newJString(resourceName))
  add(path_569075, "protectionContainerName", newJString(protectionContainerName))
  result = call_569074.call(path_569075, query_569076, nil, nil, nil)

var replicationProtectionContainerMappingsPurge* = Call_ReplicationProtectionContainerMappingsPurge_569063(
    name: "replicationProtectionContainerMappingsPurge",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}",
    validator: validate_ReplicationProtectionContainerMappingsPurge_569064,
    base: "", url: url_ReplicationProtectionContainerMappingsPurge_569065,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsDelete_569093 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectionContainerMappingsDelete_569095(protocol: Scheme;
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

proc validate_ReplicationProtectionContainerMappingsDelete_569094(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete or remove a protection container mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   mappingName: JString (required)
  ##              : Protection container mapping name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_569096 = path.getOrDefault("fabricName")
  valid_569096 = validateParameter(valid_569096, JString, required = true,
                                 default = nil)
  if valid_569096 != nil:
    section.add "fabricName", valid_569096
  var valid_569097 = path.getOrDefault("resourceGroupName")
  valid_569097 = validateParameter(valid_569097, JString, required = true,
                                 default = nil)
  if valid_569097 != nil:
    section.add "resourceGroupName", valid_569097
  var valid_569098 = path.getOrDefault("mappingName")
  valid_569098 = validateParameter(valid_569098, JString, required = true,
                                 default = nil)
  if valid_569098 != nil:
    section.add "mappingName", valid_569098
  var valid_569099 = path.getOrDefault("subscriptionId")
  valid_569099 = validateParameter(valid_569099, JString, required = true,
                                 default = nil)
  if valid_569099 != nil:
    section.add "subscriptionId", valid_569099
  var valid_569100 = path.getOrDefault("resourceName")
  valid_569100 = validateParameter(valid_569100, JString, required = true,
                                 default = nil)
  if valid_569100 != nil:
    section.add "resourceName", valid_569100
  var valid_569101 = path.getOrDefault("protectionContainerName")
  valid_569101 = validateParameter(valid_569101, JString, required = true,
                                 default = nil)
  if valid_569101 != nil:
    section.add "protectionContainerName", valid_569101
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569102 = query.getOrDefault("api-version")
  valid_569102 = validateParameter(valid_569102, JString, required = true,
                                 default = nil)
  if valid_569102 != nil:
    section.add "api-version", valid_569102
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

proc call*(call_569104: Call_ReplicationProtectionContainerMappingsDelete_569093;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete or remove a protection container mapping.
  ## 
  let valid = call_569104.validator(path, query, header, formData, body)
  let scheme = call_569104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569104.url(scheme.get, call_569104.host, call_569104.base,
                         call_569104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569104, url, valid)

proc call*(call_569105: Call_ReplicationProtectionContainerMappingsDelete_569093;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          mappingName: string; subscriptionId: string; resourceName: string;
          protectionContainerName: string; removalInput: JsonNode): Recallable =
  ## replicationProtectionContainerMappingsDelete
  ## The operation to delete or remove a protection container mapping.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   mappingName: string (required)
  ##              : Protection container mapping name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   removalInput: JObject (required)
  ##               : Removal input.
  var path_569106 = newJObject()
  var query_569107 = newJObject()
  var body_569108 = newJObject()
  add(path_569106, "fabricName", newJString(fabricName))
  add(path_569106, "resourceGroupName", newJString(resourceGroupName))
  add(query_569107, "api-version", newJString(apiVersion))
  add(path_569106, "mappingName", newJString(mappingName))
  add(path_569106, "subscriptionId", newJString(subscriptionId))
  add(path_569106, "resourceName", newJString(resourceName))
  add(path_569106, "protectionContainerName", newJString(protectionContainerName))
  if removalInput != nil:
    body_569108 = removalInput
  result = call_569105.call(path_569106, query_569107, nil, nil, body_569108)

var replicationProtectionContainerMappingsDelete* = Call_ReplicationProtectionContainerMappingsDelete_569093(
    name: "replicationProtectionContainerMappingsDelete",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}/remove",
    validator: validate_ReplicationProtectionContainerMappingsDelete_569094,
    base: "", url: url_ReplicationProtectionContainerMappingsDelete_569095,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersSwitchProtection_569109 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectionContainersSwitchProtection_569111(protocol: Scheme;
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

proc validate_ReplicationProtectionContainersSwitchProtection_569110(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Operation to switch protection from one container to another or one replication provider to another.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Unique fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: JString (required)
  ##                          : Protection container name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_569112 = path.getOrDefault("fabricName")
  valid_569112 = validateParameter(valid_569112, JString, required = true,
                                 default = nil)
  if valid_569112 != nil:
    section.add "fabricName", valid_569112
  var valid_569113 = path.getOrDefault("resourceGroupName")
  valid_569113 = validateParameter(valid_569113, JString, required = true,
                                 default = nil)
  if valid_569113 != nil:
    section.add "resourceGroupName", valid_569113
  var valid_569114 = path.getOrDefault("subscriptionId")
  valid_569114 = validateParameter(valid_569114, JString, required = true,
                                 default = nil)
  if valid_569114 != nil:
    section.add "subscriptionId", valid_569114
  var valid_569115 = path.getOrDefault("resourceName")
  valid_569115 = validateParameter(valid_569115, JString, required = true,
                                 default = nil)
  if valid_569115 != nil:
    section.add "resourceName", valid_569115
  var valid_569116 = path.getOrDefault("protectionContainerName")
  valid_569116 = validateParameter(valid_569116, JString, required = true,
                                 default = nil)
  if valid_569116 != nil:
    section.add "protectionContainerName", valid_569116
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569117 = query.getOrDefault("api-version")
  valid_569117 = validateParameter(valid_569117, JString, required = true,
                                 default = nil)
  if valid_569117 != nil:
    section.add "api-version", valid_569117
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

proc call*(call_569119: Call_ReplicationProtectionContainersSwitchProtection_569109;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to switch protection from one container to another or one replication provider to another.
  ## 
  let valid = call_569119.validator(path, query, header, formData, body)
  let scheme = call_569119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569119.url(scheme.get, call_569119.host, call_569119.base,
                         call_569119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569119, url, valid)

proc call*(call_569120: Call_ReplicationProtectionContainersSwitchProtection_569109;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; switchInput: JsonNode): Recallable =
  ## replicationProtectionContainersSwitchProtection
  ## Operation to switch protection from one container to another or one replication provider to another.
  ##   fabricName: string (required)
  ##             : Unique fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   switchInput: JObject (required)
  ##              : Switch protection input.
  var path_569121 = newJObject()
  var query_569122 = newJObject()
  var body_569123 = newJObject()
  add(path_569121, "fabricName", newJString(fabricName))
  add(path_569121, "resourceGroupName", newJString(resourceGroupName))
  add(query_569122, "api-version", newJString(apiVersion))
  add(path_569121, "subscriptionId", newJString(subscriptionId))
  add(path_569121, "resourceName", newJString(resourceName))
  add(path_569121, "protectionContainerName", newJString(protectionContainerName))
  if switchInput != nil:
    body_569123 = switchInput
  result = call_569120.call(path_569121, query_569122, nil, nil, body_569123)

var replicationProtectionContainersSwitchProtection* = Call_ReplicationProtectionContainersSwitchProtection_569109(
    name: "replicationProtectionContainersSwitchProtection",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/switchprotection",
    validator: validate_ReplicationProtectionContainersSwitchProtection_569110,
    base: "", url: url_ReplicationProtectionContainersSwitchProtection_569111,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersListByReplicationFabrics_569124 = ref object of OpenApiRestCall_567668
proc url_ReplicationRecoveryServicesProvidersListByReplicationFabrics_569126(
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

proc validate_ReplicationRecoveryServicesProvidersListByReplicationFabrics_569125(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the registered recovery services providers for the specified fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_569127 = path.getOrDefault("fabricName")
  valid_569127 = validateParameter(valid_569127, JString, required = true,
                                 default = nil)
  if valid_569127 != nil:
    section.add "fabricName", valid_569127
  var valid_569128 = path.getOrDefault("resourceGroupName")
  valid_569128 = validateParameter(valid_569128, JString, required = true,
                                 default = nil)
  if valid_569128 != nil:
    section.add "resourceGroupName", valid_569128
  var valid_569129 = path.getOrDefault("subscriptionId")
  valid_569129 = validateParameter(valid_569129, JString, required = true,
                                 default = nil)
  if valid_569129 != nil:
    section.add "subscriptionId", valid_569129
  var valid_569130 = path.getOrDefault("resourceName")
  valid_569130 = validateParameter(valid_569130, JString, required = true,
                                 default = nil)
  if valid_569130 != nil:
    section.add "resourceName", valid_569130
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569131 = query.getOrDefault("api-version")
  valid_569131 = validateParameter(valid_569131, JString, required = true,
                                 default = nil)
  if valid_569131 != nil:
    section.add "api-version", valid_569131
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569132: Call_ReplicationRecoveryServicesProvidersListByReplicationFabrics_569124;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the registered recovery services providers for the specified fabric.
  ## 
  let valid = call_569132.validator(path, query, header, formData, body)
  let scheme = call_569132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569132.url(scheme.get, call_569132.host, call_569132.base,
                         call_569132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569132, url, valid)

proc call*(call_569133: Call_ReplicationRecoveryServicesProvidersListByReplicationFabrics_569124;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string): Recallable =
  ## replicationRecoveryServicesProvidersListByReplicationFabrics
  ## Lists the registered recovery services providers for the specified fabric.
  ##   fabricName: string (required)
  ##             : Fabric name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_569134 = newJObject()
  var query_569135 = newJObject()
  add(path_569134, "fabricName", newJString(fabricName))
  add(path_569134, "resourceGroupName", newJString(resourceGroupName))
  add(query_569135, "api-version", newJString(apiVersion))
  add(path_569134, "subscriptionId", newJString(subscriptionId))
  add(path_569134, "resourceName", newJString(resourceName))
  result = call_569133.call(path_569134, query_569135, nil, nil, nil)

var replicationRecoveryServicesProvidersListByReplicationFabrics* = Call_ReplicationRecoveryServicesProvidersListByReplicationFabrics_569124(
    name: "replicationRecoveryServicesProvidersListByReplicationFabrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders", validator: validate_ReplicationRecoveryServicesProvidersListByReplicationFabrics_569125,
    base: "",
    url: url_ReplicationRecoveryServicesProvidersListByReplicationFabrics_569126,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersCreate_569149 = ref object of OpenApiRestCall_567668
proc url_ReplicationRecoveryServicesProvidersCreate_569151(protocol: Scheme;
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

proc validate_ReplicationRecoveryServicesProvidersCreate_569150(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to add a recovery services provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   providerName: JString (required)
  ##               : Recovery services provider name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_569152 = path.getOrDefault("fabricName")
  valid_569152 = validateParameter(valid_569152, JString, required = true,
                                 default = nil)
  if valid_569152 != nil:
    section.add "fabricName", valid_569152
  var valid_569153 = path.getOrDefault("resourceGroupName")
  valid_569153 = validateParameter(valid_569153, JString, required = true,
                                 default = nil)
  if valid_569153 != nil:
    section.add "resourceGroupName", valid_569153
  var valid_569154 = path.getOrDefault("subscriptionId")
  valid_569154 = validateParameter(valid_569154, JString, required = true,
                                 default = nil)
  if valid_569154 != nil:
    section.add "subscriptionId", valid_569154
  var valid_569155 = path.getOrDefault("resourceName")
  valid_569155 = validateParameter(valid_569155, JString, required = true,
                                 default = nil)
  if valid_569155 != nil:
    section.add "resourceName", valid_569155
  var valid_569156 = path.getOrDefault("providerName")
  valid_569156 = validateParameter(valid_569156, JString, required = true,
                                 default = nil)
  if valid_569156 != nil:
    section.add "providerName", valid_569156
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569157 = query.getOrDefault("api-version")
  valid_569157 = validateParameter(valid_569157, JString, required = true,
                                 default = nil)
  if valid_569157 != nil:
    section.add "api-version", valid_569157
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

proc call*(call_569159: Call_ReplicationRecoveryServicesProvidersCreate_569149;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to add a recovery services provider.
  ## 
  let valid = call_569159.validator(path, query, header, formData, body)
  let scheme = call_569159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569159.url(scheme.get, call_569159.host, call_569159.base,
                         call_569159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569159, url, valid)

proc call*(call_569160: Call_ReplicationRecoveryServicesProvidersCreate_569149;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          addProviderInput: JsonNode; subscriptionId: string; resourceName: string;
          providerName: string): Recallable =
  ## replicationRecoveryServicesProvidersCreate
  ## The operation to add a recovery services provider.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   addProviderInput: JObject (required)
  ##                   : Add provider input.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   providerName: string (required)
  ##               : Recovery services provider name.
  var path_569161 = newJObject()
  var query_569162 = newJObject()
  var body_569163 = newJObject()
  add(path_569161, "fabricName", newJString(fabricName))
  add(path_569161, "resourceGroupName", newJString(resourceGroupName))
  add(query_569162, "api-version", newJString(apiVersion))
  if addProviderInput != nil:
    body_569163 = addProviderInput
  add(path_569161, "subscriptionId", newJString(subscriptionId))
  add(path_569161, "resourceName", newJString(resourceName))
  add(path_569161, "providerName", newJString(providerName))
  result = call_569160.call(path_569161, query_569162, nil, nil, body_569163)

var replicationRecoveryServicesProvidersCreate* = Call_ReplicationRecoveryServicesProvidersCreate_569149(
    name: "replicationRecoveryServicesProvidersCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}",
    validator: validate_ReplicationRecoveryServicesProvidersCreate_569150,
    base: "", url: url_ReplicationRecoveryServicesProvidersCreate_569151,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersGet_569136 = ref object of OpenApiRestCall_567668
proc url_ReplicationRecoveryServicesProvidersGet_569138(protocol: Scheme;
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

proc validate_ReplicationRecoveryServicesProvidersGet_569137(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of registered recovery services provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   providerName: JString (required)
  ##               : Recovery services provider name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_569139 = path.getOrDefault("fabricName")
  valid_569139 = validateParameter(valid_569139, JString, required = true,
                                 default = nil)
  if valid_569139 != nil:
    section.add "fabricName", valid_569139
  var valid_569140 = path.getOrDefault("resourceGroupName")
  valid_569140 = validateParameter(valid_569140, JString, required = true,
                                 default = nil)
  if valid_569140 != nil:
    section.add "resourceGroupName", valid_569140
  var valid_569141 = path.getOrDefault("subscriptionId")
  valid_569141 = validateParameter(valid_569141, JString, required = true,
                                 default = nil)
  if valid_569141 != nil:
    section.add "subscriptionId", valid_569141
  var valid_569142 = path.getOrDefault("resourceName")
  valid_569142 = validateParameter(valid_569142, JString, required = true,
                                 default = nil)
  if valid_569142 != nil:
    section.add "resourceName", valid_569142
  var valid_569143 = path.getOrDefault("providerName")
  valid_569143 = validateParameter(valid_569143, JString, required = true,
                                 default = nil)
  if valid_569143 != nil:
    section.add "providerName", valid_569143
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569144 = query.getOrDefault("api-version")
  valid_569144 = validateParameter(valid_569144, JString, required = true,
                                 default = nil)
  if valid_569144 != nil:
    section.add "api-version", valid_569144
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569145: Call_ReplicationRecoveryServicesProvidersGet_569136;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of registered recovery services provider.
  ## 
  let valid = call_569145.validator(path, query, header, formData, body)
  let scheme = call_569145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569145.url(scheme.get, call_569145.host, call_569145.base,
                         call_569145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569145, url, valid)

proc call*(call_569146: Call_ReplicationRecoveryServicesProvidersGet_569136;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string; providerName: string): Recallable =
  ## replicationRecoveryServicesProvidersGet
  ## Gets the details of registered recovery services provider.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   providerName: string (required)
  ##               : Recovery services provider name
  var path_569147 = newJObject()
  var query_569148 = newJObject()
  add(path_569147, "fabricName", newJString(fabricName))
  add(path_569147, "resourceGroupName", newJString(resourceGroupName))
  add(query_569148, "api-version", newJString(apiVersion))
  add(path_569147, "subscriptionId", newJString(subscriptionId))
  add(path_569147, "resourceName", newJString(resourceName))
  add(path_569147, "providerName", newJString(providerName))
  result = call_569146.call(path_569147, query_569148, nil, nil, nil)

var replicationRecoveryServicesProvidersGet* = Call_ReplicationRecoveryServicesProvidersGet_569136(
    name: "replicationRecoveryServicesProvidersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}",
    validator: validate_ReplicationRecoveryServicesProvidersGet_569137, base: "",
    url: url_ReplicationRecoveryServicesProvidersGet_569138,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersPurge_569164 = ref object of OpenApiRestCall_567668
proc url_ReplicationRecoveryServicesProvidersPurge_569166(protocol: Scheme;
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

proc validate_ReplicationRecoveryServicesProvidersPurge_569165(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to purge(force delete) a recovery services provider from the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   providerName: JString (required)
  ##               : Recovery services provider name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_569167 = path.getOrDefault("fabricName")
  valid_569167 = validateParameter(valid_569167, JString, required = true,
                                 default = nil)
  if valid_569167 != nil:
    section.add "fabricName", valid_569167
  var valid_569168 = path.getOrDefault("resourceGroupName")
  valid_569168 = validateParameter(valid_569168, JString, required = true,
                                 default = nil)
  if valid_569168 != nil:
    section.add "resourceGroupName", valid_569168
  var valid_569169 = path.getOrDefault("subscriptionId")
  valid_569169 = validateParameter(valid_569169, JString, required = true,
                                 default = nil)
  if valid_569169 != nil:
    section.add "subscriptionId", valid_569169
  var valid_569170 = path.getOrDefault("resourceName")
  valid_569170 = validateParameter(valid_569170, JString, required = true,
                                 default = nil)
  if valid_569170 != nil:
    section.add "resourceName", valid_569170
  var valid_569171 = path.getOrDefault("providerName")
  valid_569171 = validateParameter(valid_569171, JString, required = true,
                                 default = nil)
  if valid_569171 != nil:
    section.add "providerName", valid_569171
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569172 = query.getOrDefault("api-version")
  valid_569172 = validateParameter(valid_569172, JString, required = true,
                                 default = nil)
  if valid_569172 != nil:
    section.add "api-version", valid_569172
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569173: Call_ReplicationRecoveryServicesProvidersPurge_569164;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to purge(force delete) a recovery services provider from the vault.
  ## 
  let valid = call_569173.validator(path, query, header, formData, body)
  let scheme = call_569173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569173.url(scheme.get, call_569173.host, call_569173.base,
                         call_569173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569173, url, valid)

proc call*(call_569174: Call_ReplicationRecoveryServicesProvidersPurge_569164;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string; providerName: string): Recallable =
  ## replicationRecoveryServicesProvidersPurge
  ## The operation to purge(force delete) a recovery services provider from the vault.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   providerName: string (required)
  ##               : Recovery services provider name.
  var path_569175 = newJObject()
  var query_569176 = newJObject()
  add(path_569175, "fabricName", newJString(fabricName))
  add(path_569175, "resourceGroupName", newJString(resourceGroupName))
  add(query_569176, "api-version", newJString(apiVersion))
  add(path_569175, "subscriptionId", newJString(subscriptionId))
  add(path_569175, "resourceName", newJString(resourceName))
  add(path_569175, "providerName", newJString(providerName))
  result = call_569174.call(path_569175, query_569176, nil, nil, nil)

var replicationRecoveryServicesProvidersPurge* = Call_ReplicationRecoveryServicesProvidersPurge_569164(
    name: "replicationRecoveryServicesProvidersPurge",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}",
    validator: validate_ReplicationRecoveryServicesProvidersPurge_569165,
    base: "", url: url_ReplicationRecoveryServicesProvidersPurge_569166,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersRefreshProvider_569177 = ref object of OpenApiRestCall_567668
proc url_ReplicationRecoveryServicesProvidersRefreshProvider_569179(
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

proc validate_ReplicationRecoveryServicesProvidersRefreshProvider_569178(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The operation to refresh the information from the recovery services provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   providerName: JString (required)
  ##               : Recovery services provider name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_569180 = path.getOrDefault("fabricName")
  valid_569180 = validateParameter(valid_569180, JString, required = true,
                                 default = nil)
  if valid_569180 != nil:
    section.add "fabricName", valid_569180
  var valid_569181 = path.getOrDefault("resourceGroupName")
  valid_569181 = validateParameter(valid_569181, JString, required = true,
                                 default = nil)
  if valid_569181 != nil:
    section.add "resourceGroupName", valid_569181
  var valid_569182 = path.getOrDefault("subscriptionId")
  valid_569182 = validateParameter(valid_569182, JString, required = true,
                                 default = nil)
  if valid_569182 != nil:
    section.add "subscriptionId", valid_569182
  var valid_569183 = path.getOrDefault("resourceName")
  valid_569183 = validateParameter(valid_569183, JString, required = true,
                                 default = nil)
  if valid_569183 != nil:
    section.add "resourceName", valid_569183
  var valid_569184 = path.getOrDefault("providerName")
  valid_569184 = validateParameter(valid_569184, JString, required = true,
                                 default = nil)
  if valid_569184 != nil:
    section.add "providerName", valid_569184
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569185 = query.getOrDefault("api-version")
  valid_569185 = validateParameter(valid_569185, JString, required = true,
                                 default = nil)
  if valid_569185 != nil:
    section.add "api-version", valid_569185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569186: Call_ReplicationRecoveryServicesProvidersRefreshProvider_569177;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to refresh the information from the recovery services provider.
  ## 
  let valid = call_569186.validator(path, query, header, formData, body)
  let scheme = call_569186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569186.url(scheme.get, call_569186.host, call_569186.base,
                         call_569186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569186, url, valid)

proc call*(call_569187: Call_ReplicationRecoveryServicesProvidersRefreshProvider_569177;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string; providerName: string): Recallable =
  ## replicationRecoveryServicesProvidersRefreshProvider
  ## The operation to refresh the information from the recovery services provider.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   providerName: string (required)
  ##               : Recovery services provider name.
  var path_569188 = newJObject()
  var query_569189 = newJObject()
  add(path_569188, "fabricName", newJString(fabricName))
  add(path_569188, "resourceGroupName", newJString(resourceGroupName))
  add(query_569189, "api-version", newJString(apiVersion))
  add(path_569188, "subscriptionId", newJString(subscriptionId))
  add(path_569188, "resourceName", newJString(resourceName))
  add(path_569188, "providerName", newJString(providerName))
  result = call_569187.call(path_569188, query_569189, nil, nil, nil)

var replicationRecoveryServicesProvidersRefreshProvider* = Call_ReplicationRecoveryServicesProvidersRefreshProvider_569177(
    name: "replicationRecoveryServicesProvidersRefreshProvider",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}/refreshProvider",
    validator: validate_ReplicationRecoveryServicesProvidersRefreshProvider_569178,
    base: "", url: url_ReplicationRecoveryServicesProvidersRefreshProvider_569179,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersDelete_569190 = ref object of OpenApiRestCall_567668
proc url_ReplicationRecoveryServicesProvidersDelete_569192(protocol: Scheme;
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

proc validate_ReplicationRecoveryServicesProvidersDelete_569191(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to removes/delete(unregister) a recovery services provider from the vault
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   providerName: JString (required)
  ##               : Recovery services provider name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_569193 = path.getOrDefault("fabricName")
  valid_569193 = validateParameter(valid_569193, JString, required = true,
                                 default = nil)
  if valid_569193 != nil:
    section.add "fabricName", valid_569193
  var valid_569194 = path.getOrDefault("resourceGroupName")
  valid_569194 = validateParameter(valid_569194, JString, required = true,
                                 default = nil)
  if valid_569194 != nil:
    section.add "resourceGroupName", valid_569194
  var valid_569195 = path.getOrDefault("subscriptionId")
  valid_569195 = validateParameter(valid_569195, JString, required = true,
                                 default = nil)
  if valid_569195 != nil:
    section.add "subscriptionId", valid_569195
  var valid_569196 = path.getOrDefault("resourceName")
  valid_569196 = validateParameter(valid_569196, JString, required = true,
                                 default = nil)
  if valid_569196 != nil:
    section.add "resourceName", valid_569196
  var valid_569197 = path.getOrDefault("providerName")
  valid_569197 = validateParameter(valid_569197, JString, required = true,
                                 default = nil)
  if valid_569197 != nil:
    section.add "providerName", valid_569197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569198 = query.getOrDefault("api-version")
  valid_569198 = validateParameter(valid_569198, JString, required = true,
                                 default = nil)
  if valid_569198 != nil:
    section.add "api-version", valid_569198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569199: Call_ReplicationRecoveryServicesProvidersDelete_569190;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to removes/delete(unregister) a recovery services provider from the vault
  ## 
  let valid = call_569199.validator(path, query, header, formData, body)
  let scheme = call_569199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569199.url(scheme.get, call_569199.host, call_569199.base,
                         call_569199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569199, url, valid)

proc call*(call_569200: Call_ReplicationRecoveryServicesProvidersDelete_569190;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string; providerName: string): Recallable =
  ## replicationRecoveryServicesProvidersDelete
  ## The operation to removes/delete(unregister) a recovery services provider from the vault
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   providerName: string (required)
  ##               : Recovery services provider name.
  var path_569201 = newJObject()
  var query_569202 = newJObject()
  add(path_569201, "fabricName", newJString(fabricName))
  add(path_569201, "resourceGroupName", newJString(resourceGroupName))
  add(query_569202, "api-version", newJString(apiVersion))
  add(path_569201, "subscriptionId", newJString(subscriptionId))
  add(path_569201, "resourceName", newJString(resourceName))
  add(path_569201, "providerName", newJString(providerName))
  result = call_569200.call(path_569201, query_569202, nil, nil, nil)

var replicationRecoveryServicesProvidersDelete* = Call_ReplicationRecoveryServicesProvidersDelete_569190(
    name: "replicationRecoveryServicesProvidersDelete", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}/remove",
    validator: validate_ReplicationRecoveryServicesProvidersDelete_569191,
    base: "", url: url_ReplicationRecoveryServicesProvidersDelete_569192,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationsListByReplicationFabrics_569203 = ref object of OpenApiRestCall_567668
proc url_ReplicationStorageClassificationsListByReplicationFabrics_569205(
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

proc validate_ReplicationStorageClassificationsListByReplicationFabrics_569204(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the storage classifications available in the specified fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Site name of interest.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_569206 = path.getOrDefault("fabricName")
  valid_569206 = validateParameter(valid_569206, JString, required = true,
                                 default = nil)
  if valid_569206 != nil:
    section.add "fabricName", valid_569206
  var valid_569207 = path.getOrDefault("resourceGroupName")
  valid_569207 = validateParameter(valid_569207, JString, required = true,
                                 default = nil)
  if valid_569207 != nil:
    section.add "resourceGroupName", valid_569207
  var valid_569208 = path.getOrDefault("subscriptionId")
  valid_569208 = validateParameter(valid_569208, JString, required = true,
                                 default = nil)
  if valid_569208 != nil:
    section.add "subscriptionId", valid_569208
  var valid_569209 = path.getOrDefault("resourceName")
  valid_569209 = validateParameter(valid_569209, JString, required = true,
                                 default = nil)
  if valid_569209 != nil:
    section.add "resourceName", valid_569209
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569210 = query.getOrDefault("api-version")
  valid_569210 = validateParameter(valid_569210, JString, required = true,
                                 default = nil)
  if valid_569210 != nil:
    section.add "api-version", valid_569210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569211: Call_ReplicationStorageClassificationsListByReplicationFabrics_569203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the storage classifications available in the specified fabric.
  ## 
  let valid = call_569211.validator(path, query, header, formData, body)
  let scheme = call_569211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569211.url(scheme.get, call_569211.host, call_569211.base,
                         call_569211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569211, url, valid)

proc call*(call_569212: Call_ReplicationStorageClassificationsListByReplicationFabrics_569203;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string): Recallable =
  ## replicationStorageClassificationsListByReplicationFabrics
  ## Lists the storage classifications available in the specified fabric.
  ##   fabricName: string (required)
  ##             : Site name of interest.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_569213 = newJObject()
  var query_569214 = newJObject()
  add(path_569213, "fabricName", newJString(fabricName))
  add(path_569213, "resourceGroupName", newJString(resourceGroupName))
  add(query_569214, "api-version", newJString(apiVersion))
  add(path_569213, "subscriptionId", newJString(subscriptionId))
  add(path_569213, "resourceName", newJString(resourceName))
  result = call_569212.call(path_569213, query_569214, nil, nil, nil)

var replicationStorageClassificationsListByReplicationFabrics* = Call_ReplicationStorageClassificationsListByReplicationFabrics_569203(
    name: "replicationStorageClassificationsListByReplicationFabrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications", validator: validate_ReplicationStorageClassificationsListByReplicationFabrics_569204,
    base: "", url: url_ReplicationStorageClassificationsListByReplicationFabrics_569205,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationsGet_569215 = ref object of OpenApiRestCall_567668
proc url_ReplicationStorageClassificationsGet_569217(protocol: Scheme;
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

proc validate_ReplicationStorageClassificationsGet_569216(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the specified storage classification.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   storageClassificationName: JString (required)
  ##                            : Storage classification name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_569218 = path.getOrDefault("fabricName")
  valid_569218 = validateParameter(valid_569218, JString, required = true,
                                 default = nil)
  if valid_569218 != nil:
    section.add "fabricName", valid_569218
  var valid_569219 = path.getOrDefault("resourceGroupName")
  valid_569219 = validateParameter(valid_569219, JString, required = true,
                                 default = nil)
  if valid_569219 != nil:
    section.add "resourceGroupName", valid_569219
  var valid_569220 = path.getOrDefault("subscriptionId")
  valid_569220 = validateParameter(valid_569220, JString, required = true,
                                 default = nil)
  if valid_569220 != nil:
    section.add "subscriptionId", valid_569220
  var valid_569221 = path.getOrDefault("resourceName")
  valid_569221 = validateParameter(valid_569221, JString, required = true,
                                 default = nil)
  if valid_569221 != nil:
    section.add "resourceName", valid_569221
  var valid_569222 = path.getOrDefault("storageClassificationName")
  valid_569222 = validateParameter(valid_569222, JString, required = true,
                                 default = nil)
  if valid_569222 != nil:
    section.add "storageClassificationName", valid_569222
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569223 = query.getOrDefault("api-version")
  valid_569223 = validateParameter(valid_569223, JString, required = true,
                                 default = nil)
  if valid_569223 != nil:
    section.add "api-version", valid_569223
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569224: Call_ReplicationStorageClassificationsGet_569215;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of the specified storage classification.
  ## 
  let valid = call_569224.validator(path, query, header, formData, body)
  let scheme = call_569224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569224.url(scheme.get, call_569224.host, call_569224.base,
                         call_569224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569224, url, valid)

proc call*(call_569225: Call_ReplicationStorageClassificationsGet_569215;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          storageClassificationName: string): Recallable =
  ## replicationStorageClassificationsGet
  ## Gets the details of the specified storage classification.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   storageClassificationName: string (required)
  ##                            : Storage classification name.
  var path_569226 = newJObject()
  var query_569227 = newJObject()
  add(path_569226, "fabricName", newJString(fabricName))
  add(path_569226, "resourceGroupName", newJString(resourceGroupName))
  add(query_569227, "api-version", newJString(apiVersion))
  add(path_569226, "subscriptionId", newJString(subscriptionId))
  add(path_569226, "resourceName", newJString(resourceName))
  add(path_569226, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_569225.call(path_569226, query_569227, nil, nil, nil)

var replicationStorageClassificationsGet* = Call_ReplicationStorageClassificationsGet_569215(
    name: "replicationStorageClassificationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}",
    validator: validate_ReplicationStorageClassificationsGet_569216, base: "",
    url: url_ReplicationStorageClassificationsGet_569217, schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_569228 = ref object of OpenApiRestCall_567668
proc url_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_569230(
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

proc validate_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_569229(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the storage classification mappings for the fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   storageClassificationName: JString (required)
  ##                            : Storage classification name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_569231 = path.getOrDefault("fabricName")
  valid_569231 = validateParameter(valid_569231, JString, required = true,
                                 default = nil)
  if valid_569231 != nil:
    section.add "fabricName", valid_569231
  var valid_569232 = path.getOrDefault("resourceGroupName")
  valid_569232 = validateParameter(valid_569232, JString, required = true,
                                 default = nil)
  if valid_569232 != nil:
    section.add "resourceGroupName", valid_569232
  var valid_569233 = path.getOrDefault("subscriptionId")
  valid_569233 = validateParameter(valid_569233, JString, required = true,
                                 default = nil)
  if valid_569233 != nil:
    section.add "subscriptionId", valid_569233
  var valid_569234 = path.getOrDefault("resourceName")
  valid_569234 = validateParameter(valid_569234, JString, required = true,
                                 default = nil)
  if valid_569234 != nil:
    section.add "resourceName", valid_569234
  var valid_569235 = path.getOrDefault("storageClassificationName")
  valid_569235 = validateParameter(valid_569235, JString, required = true,
                                 default = nil)
  if valid_569235 != nil:
    section.add "storageClassificationName", valid_569235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569236 = query.getOrDefault("api-version")
  valid_569236 = validateParameter(valid_569236, JString, required = true,
                                 default = nil)
  if valid_569236 != nil:
    section.add "api-version", valid_569236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569237: Call_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_569228;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the storage classification mappings for the fabric.
  ## 
  let valid = call_569237.validator(path, query, header, formData, body)
  let scheme = call_569237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569237.url(scheme.get, call_569237.host, call_569237.base,
                         call_569237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569237, url, valid)

proc call*(call_569238: Call_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_569228;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          storageClassificationName: string): Recallable =
  ## replicationStorageClassificationMappingsListByReplicationStorageClassifications
  ## Lists the storage classification mappings for the fabric.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   storageClassificationName: string (required)
  ##                            : Storage classification name.
  var path_569239 = newJObject()
  var query_569240 = newJObject()
  add(path_569239, "fabricName", newJString(fabricName))
  add(path_569239, "resourceGroupName", newJString(resourceGroupName))
  add(query_569240, "api-version", newJString(apiVersion))
  add(path_569239, "subscriptionId", newJString(subscriptionId))
  add(path_569239, "resourceName", newJString(resourceName))
  add(path_569239, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_569238.call(path_569239, query_569240, nil, nil, nil)

var replicationStorageClassificationMappingsListByReplicationStorageClassifications* = Call_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_569228(name: "replicationStorageClassificationMappingsListByReplicationStorageClassifications",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}/replicationStorageClassificationMappings", validator: validate_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_569229,
    base: "", url: url_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_569230,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsCreate_569255 = ref object of OpenApiRestCall_567668
proc url_ReplicationStorageClassificationMappingsCreate_569257(protocol: Scheme;
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

proc validate_ReplicationStorageClassificationMappingsCreate_569256(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The operation to create a storage classification mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   storageClassificationMappingName: JString (required)
  ##                                   : Storage classification mapping name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   storageClassificationName: JString (required)
  ##                            : Storage classification name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_569258 = path.getOrDefault("fabricName")
  valid_569258 = validateParameter(valid_569258, JString, required = true,
                                 default = nil)
  if valid_569258 != nil:
    section.add "fabricName", valid_569258
  var valid_569259 = path.getOrDefault("resourceGroupName")
  valid_569259 = validateParameter(valid_569259, JString, required = true,
                                 default = nil)
  if valid_569259 != nil:
    section.add "resourceGroupName", valid_569259
  var valid_569260 = path.getOrDefault("storageClassificationMappingName")
  valid_569260 = validateParameter(valid_569260, JString, required = true,
                                 default = nil)
  if valid_569260 != nil:
    section.add "storageClassificationMappingName", valid_569260
  var valid_569261 = path.getOrDefault("subscriptionId")
  valid_569261 = validateParameter(valid_569261, JString, required = true,
                                 default = nil)
  if valid_569261 != nil:
    section.add "subscriptionId", valid_569261
  var valid_569262 = path.getOrDefault("resourceName")
  valid_569262 = validateParameter(valid_569262, JString, required = true,
                                 default = nil)
  if valid_569262 != nil:
    section.add "resourceName", valid_569262
  var valid_569263 = path.getOrDefault("storageClassificationName")
  valid_569263 = validateParameter(valid_569263, JString, required = true,
                                 default = nil)
  if valid_569263 != nil:
    section.add "storageClassificationName", valid_569263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569264 = query.getOrDefault("api-version")
  valid_569264 = validateParameter(valid_569264, JString, required = true,
                                 default = nil)
  if valid_569264 != nil:
    section.add "api-version", valid_569264
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

proc call*(call_569266: Call_ReplicationStorageClassificationMappingsCreate_569255;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create a storage classification mapping.
  ## 
  let valid = call_569266.validator(path, query, header, formData, body)
  let scheme = call_569266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569266.url(scheme.get, call_569266.host, call_569266.base,
                         call_569266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569266, url, valid)

proc call*(call_569267: Call_ReplicationStorageClassificationMappingsCreate_569255;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          storageClassificationMappingName: string; pairingInput: JsonNode;
          subscriptionId: string; resourceName: string;
          storageClassificationName: string): Recallable =
  ## replicationStorageClassificationMappingsCreate
  ## The operation to create a storage classification mapping.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   storageClassificationMappingName: string (required)
  ##                                   : Storage classification mapping name.
  ##   pairingInput: JObject (required)
  ##               : Pairing input.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   storageClassificationName: string (required)
  ##                            : Storage classification name.
  var path_569268 = newJObject()
  var query_569269 = newJObject()
  var body_569270 = newJObject()
  add(path_569268, "fabricName", newJString(fabricName))
  add(path_569268, "resourceGroupName", newJString(resourceGroupName))
  add(query_569269, "api-version", newJString(apiVersion))
  add(path_569268, "storageClassificationMappingName",
      newJString(storageClassificationMappingName))
  if pairingInput != nil:
    body_569270 = pairingInput
  add(path_569268, "subscriptionId", newJString(subscriptionId))
  add(path_569268, "resourceName", newJString(resourceName))
  add(path_569268, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_569267.call(path_569268, query_569269, nil, nil, body_569270)

var replicationStorageClassificationMappingsCreate* = Call_ReplicationStorageClassificationMappingsCreate_569255(
    name: "replicationStorageClassificationMappingsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}/replicationStorageClassificationMappings/{storageClassificationMappingName}",
    validator: validate_ReplicationStorageClassificationMappingsCreate_569256,
    base: "", url: url_ReplicationStorageClassificationMappingsCreate_569257,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsGet_569241 = ref object of OpenApiRestCall_567668
proc url_ReplicationStorageClassificationMappingsGet_569243(protocol: Scheme;
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

proc validate_ReplicationStorageClassificationMappingsGet_569242(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the specified storage classification mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   storageClassificationMappingName: JString (required)
  ##                                   : Storage classification mapping name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   storageClassificationName: JString (required)
  ##                            : Storage classification name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_569244 = path.getOrDefault("fabricName")
  valid_569244 = validateParameter(valid_569244, JString, required = true,
                                 default = nil)
  if valid_569244 != nil:
    section.add "fabricName", valid_569244
  var valid_569245 = path.getOrDefault("resourceGroupName")
  valid_569245 = validateParameter(valid_569245, JString, required = true,
                                 default = nil)
  if valid_569245 != nil:
    section.add "resourceGroupName", valid_569245
  var valid_569246 = path.getOrDefault("storageClassificationMappingName")
  valid_569246 = validateParameter(valid_569246, JString, required = true,
                                 default = nil)
  if valid_569246 != nil:
    section.add "storageClassificationMappingName", valid_569246
  var valid_569247 = path.getOrDefault("subscriptionId")
  valid_569247 = validateParameter(valid_569247, JString, required = true,
                                 default = nil)
  if valid_569247 != nil:
    section.add "subscriptionId", valid_569247
  var valid_569248 = path.getOrDefault("resourceName")
  valid_569248 = validateParameter(valid_569248, JString, required = true,
                                 default = nil)
  if valid_569248 != nil:
    section.add "resourceName", valid_569248
  var valid_569249 = path.getOrDefault("storageClassificationName")
  valid_569249 = validateParameter(valid_569249, JString, required = true,
                                 default = nil)
  if valid_569249 != nil:
    section.add "storageClassificationName", valid_569249
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569250 = query.getOrDefault("api-version")
  valid_569250 = validateParameter(valid_569250, JString, required = true,
                                 default = nil)
  if valid_569250 != nil:
    section.add "api-version", valid_569250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569251: Call_ReplicationStorageClassificationMappingsGet_569241;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of the specified storage classification mapping.
  ## 
  let valid = call_569251.validator(path, query, header, formData, body)
  let scheme = call_569251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569251.url(scheme.get, call_569251.host, call_569251.base,
                         call_569251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569251, url, valid)

proc call*(call_569252: Call_ReplicationStorageClassificationMappingsGet_569241;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          storageClassificationMappingName: string; subscriptionId: string;
          resourceName: string; storageClassificationName: string): Recallable =
  ## replicationStorageClassificationMappingsGet
  ## Gets the details of the specified storage classification mapping.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   storageClassificationMappingName: string (required)
  ##                                   : Storage classification mapping name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   storageClassificationName: string (required)
  ##                            : Storage classification name.
  var path_569253 = newJObject()
  var query_569254 = newJObject()
  add(path_569253, "fabricName", newJString(fabricName))
  add(path_569253, "resourceGroupName", newJString(resourceGroupName))
  add(query_569254, "api-version", newJString(apiVersion))
  add(path_569253, "storageClassificationMappingName",
      newJString(storageClassificationMappingName))
  add(path_569253, "subscriptionId", newJString(subscriptionId))
  add(path_569253, "resourceName", newJString(resourceName))
  add(path_569253, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_569252.call(path_569253, query_569254, nil, nil, nil)

var replicationStorageClassificationMappingsGet* = Call_ReplicationStorageClassificationMappingsGet_569241(
    name: "replicationStorageClassificationMappingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}/replicationStorageClassificationMappings/{storageClassificationMappingName}",
    validator: validate_ReplicationStorageClassificationMappingsGet_569242,
    base: "", url: url_ReplicationStorageClassificationMappingsGet_569243,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsDelete_569271 = ref object of OpenApiRestCall_567668
proc url_ReplicationStorageClassificationMappingsDelete_569273(protocol: Scheme;
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

proc validate_ReplicationStorageClassificationMappingsDelete_569272(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The operation to delete a storage classification mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   storageClassificationMappingName: JString (required)
  ##                                   : Storage classification mapping name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   storageClassificationName: JString (required)
  ##                            : Storage classification name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_569274 = path.getOrDefault("fabricName")
  valid_569274 = validateParameter(valid_569274, JString, required = true,
                                 default = nil)
  if valid_569274 != nil:
    section.add "fabricName", valid_569274
  var valid_569275 = path.getOrDefault("resourceGroupName")
  valid_569275 = validateParameter(valid_569275, JString, required = true,
                                 default = nil)
  if valid_569275 != nil:
    section.add "resourceGroupName", valid_569275
  var valid_569276 = path.getOrDefault("storageClassificationMappingName")
  valid_569276 = validateParameter(valid_569276, JString, required = true,
                                 default = nil)
  if valid_569276 != nil:
    section.add "storageClassificationMappingName", valid_569276
  var valid_569277 = path.getOrDefault("subscriptionId")
  valid_569277 = validateParameter(valid_569277, JString, required = true,
                                 default = nil)
  if valid_569277 != nil:
    section.add "subscriptionId", valid_569277
  var valid_569278 = path.getOrDefault("resourceName")
  valid_569278 = validateParameter(valid_569278, JString, required = true,
                                 default = nil)
  if valid_569278 != nil:
    section.add "resourceName", valid_569278
  var valid_569279 = path.getOrDefault("storageClassificationName")
  valid_569279 = validateParameter(valid_569279, JString, required = true,
                                 default = nil)
  if valid_569279 != nil:
    section.add "storageClassificationName", valid_569279
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569280 = query.getOrDefault("api-version")
  valid_569280 = validateParameter(valid_569280, JString, required = true,
                                 default = nil)
  if valid_569280 != nil:
    section.add "api-version", valid_569280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569281: Call_ReplicationStorageClassificationMappingsDelete_569271;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete a storage classification mapping.
  ## 
  let valid = call_569281.validator(path, query, header, formData, body)
  let scheme = call_569281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569281.url(scheme.get, call_569281.host, call_569281.base,
                         call_569281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569281, url, valid)

proc call*(call_569282: Call_ReplicationStorageClassificationMappingsDelete_569271;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          storageClassificationMappingName: string; subscriptionId: string;
          resourceName: string; storageClassificationName: string): Recallable =
  ## replicationStorageClassificationMappingsDelete
  ## The operation to delete a storage classification mapping.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   storageClassificationMappingName: string (required)
  ##                                   : Storage classification mapping name.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   storageClassificationName: string (required)
  ##                            : Storage classification name.
  var path_569283 = newJObject()
  var query_569284 = newJObject()
  add(path_569283, "fabricName", newJString(fabricName))
  add(path_569283, "resourceGroupName", newJString(resourceGroupName))
  add(query_569284, "api-version", newJString(apiVersion))
  add(path_569283, "storageClassificationMappingName",
      newJString(storageClassificationMappingName))
  add(path_569283, "subscriptionId", newJString(subscriptionId))
  add(path_569283, "resourceName", newJString(resourceName))
  add(path_569283, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_569282.call(path_569283, query_569284, nil, nil, nil)

var replicationStorageClassificationMappingsDelete* = Call_ReplicationStorageClassificationMappingsDelete_569271(
    name: "replicationStorageClassificationMappingsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}/replicationStorageClassificationMappings/{storageClassificationMappingName}",
    validator: validate_ReplicationStorageClassificationMappingsDelete_569272,
    base: "", url: url_ReplicationStorageClassificationMappingsDelete_569273,
    schemes: {Scheme.Https})
type
  Call_ReplicationvCentersListByReplicationFabrics_569285 = ref object of OpenApiRestCall_567668
proc url_ReplicationvCentersListByReplicationFabrics_569287(protocol: Scheme;
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

proc validate_ReplicationvCentersListByReplicationFabrics_569286(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the vCenter servers registered in a fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_569288 = path.getOrDefault("fabricName")
  valid_569288 = validateParameter(valid_569288, JString, required = true,
                                 default = nil)
  if valid_569288 != nil:
    section.add "fabricName", valid_569288
  var valid_569289 = path.getOrDefault("resourceGroupName")
  valid_569289 = validateParameter(valid_569289, JString, required = true,
                                 default = nil)
  if valid_569289 != nil:
    section.add "resourceGroupName", valid_569289
  var valid_569290 = path.getOrDefault("subscriptionId")
  valid_569290 = validateParameter(valid_569290, JString, required = true,
                                 default = nil)
  if valid_569290 != nil:
    section.add "subscriptionId", valid_569290
  var valid_569291 = path.getOrDefault("resourceName")
  valid_569291 = validateParameter(valid_569291, JString, required = true,
                                 default = nil)
  if valid_569291 != nil:
    section.add "resourceName", valid_569291
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569292 = query.getOrDefault("api-version")
  valid_569292 = validateParameter(valid_569292, JString, required = true,
                                 default = nil)
  if valid_569292 != nil:
    section.add "api-version", valid_569292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569293: Call_ReplicationvCentersListByReplicationFabrics_569285;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the vCenter servers registered in a fabric.
  ## 
  let valid = call_569293.validator(path, query, header, formData, body)
  let scheme = call_569293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569293.url(scheme.get, call_569293.host, call_569293.base,
                         call_569293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569293, url, valid)

proc call*(call_569294: Call_ReplicationvCentersListByReplicationFabrics_569285;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string): Recallable =
  ## replicationvCentersListByReplicationFabrics
  ## Lists the vCenter servers registered in a fabric.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_569295 = newJObject()
  var query_569296 = newJObject()
  add(path_569295, "fabricName", newJString(fabricName))
  add(path_569295, "resourceGroupName", newJString(resourceGroupName))
  add(query_569296, "api-version", newJString(apiVersion))
  add(path_569295, "subscriptionId", newJString(subscriptionId))
  add(path_569295, "resourceName", newJString(resourceName))
  result = call_569294.call(path_569295, query_569296, nil, nil, nil)

var replicationvCentersListByReplicationFabrics* = Call_ReplicationvCentersListByReplicationFabrics_569285(
    name: "replicationvCentersListByReplicationFabrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters",
    validator: validate_ReplicationvCentersListByReplicationFabrics_569286,
    base: "", url: url_ReplicationvCentersListByReplicationFabrics_569287,
    schemes: {Scheme.Https})
type
  Call_ReplicationvCentersCreate_569310 = ref object of OpenApiRestCall_567668
proc url_ReplicationvCentersCreate_569312(protocol: Scheme; host: string;
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

proc validate_ReplicationvCentersCreate_569311(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create a vCenter object..
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   vCenterName: JString (required)
  ##              : vCenter name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_569313 = path.getOrDefault("fabricName")
  valid_569313 = validateParameter(valid_569313, JString, required = true,
                                 default = nil)
  if valid_569313 != nil:
    section.add "fabricName", valid_569313
  var valid_569314 = path.getOrDefault("resourceGroupName")
  valid_569314 = validateParameter(valid_569314, JString, required = true,
                                 default = nil)
  if valid_569314 != nil:
    section.add "resourceGroupName", valid_569314
  var valid_569315 = path.getOrDefault("subscriptionId")
  valid_569315 = validateParameter(valid_569315, JString, required = true,
                                 default = nil)
  if valid_569315 != nil:
    section.add "subscriptionId", valid_569315
  var valid_569316 = path.getOrDefault("resourceName")
  valid_569316 = validateParameter(valid_569316, JString, required = true,
                                 default = nil)
  if valid_569316 != nil:
    section.add "resourceName", valid_569316
  var valid_569317 = path.getOrDefault("vCenterName")
  valid_569317 = validateParameter(valid_569317, JString, required = true,
                                 default = nil)
  if valid_569317 != nil:
    section.add "vCenterName", valid_569317
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569318 = query.getOrDefault("api-version")
  valid_569318 = validateParameter(valid_569318, JString, required = true,
                                 default = nil)
  if valid_569318 != nil:
    section.add "api-version", valid_569318
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

proc call*(call_569320: Call_ReplicationvCentersCreate_569310; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create a vCenter object..
  ## 
  let valid = call_569320.validator(path, query, header, formData, body)
  let scheme = call_569320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569320.url(scheme.get, call_569320.host, call_569320.base,
                         call_569320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569320, url, valid)

proc call*(call_569321: Call_ReplicationvCentersCreate_569310; fabricName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; addVCenterRequest: JsonNode; vCenterName: string): Recallable =
  ## replicationvCentersCreate
  ## The operation to create a vCenter object..
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   addVCenterRequest: JObject (required)
  ##                    : The input to the add vCenter operation.
  ##   vCenterName: string (required)
  ##              : vCenter name.
  var path_569322 = newJObject()
  var query_569323 = newJObject()
  var body_569324 = newJObject()
  add(path_569322, "fabricName", newJString(fabricName))
  add(path_569322, "resourceGroupName", newJString(resourceGroupName))
  add(query_569323, "api-version", newJString(apiVersion))
  add(path_569322, "subscriptionId", newJString(subscriptionId))
  add(path_569322, "resourceName", newJString(resourceName))
  if addVCenterRequest != nil:
    body_569324 = addVCenterRequest
  add(path_569322, "vCenterName", newJString(vCenterName))
  result = call_569321.call(path_569322, query_569323, nil, nil, body_569324)

var replicationvCentersCreate* = Call_ReplicationvCentersCreate_569310(
    name: "replicationvCentersCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters/{vCenterName}",
    validator: validate_ReplicationvCentersCreate_569311, base: "",
    url: url_ReplicationvCentersCreate_569312, schemes: {Scheme.Https})
type
  Call_ReplicationvCentersGet_569297 = ref object of OpenApiRestCall_567668
proc url_ReplicationvCentersGet_569299(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationvCentersGet_569298(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of a registered vCenter server(Add vCenter server.)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   vCenterName: JString (required)
  ##              : vCenter name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_569300 = path.getOrDefault("fabricName")
  valid_569300 = validateParameter(valid_569300, JString, required = true,
                                 default = nil)
  if valid_569300 != nil:
    section.add "fabricName", valid_569300
  var valid_569301 = path.getOrDefault("resourceGroupName")
  valid_569301 = validateParameter(valid_569301, JString, required = true,
                                 default = nil)
  if valid_569301 != nil:
    section.add "resourceGroupName", valid_569301
  var valid_569302 = path.getOrDefault("subscriptionId")
  valid_569302 = validateParameter(valid_569302, JString, required = true,
                                 default = nil)
  if valid_569302 != nil:
    section.add "subscriptionId", valid_569302
  var valid_569303 = path.getOrDefault("resourceName")
  valid_569303 = validateParameter(valid_569303, JString, required = true,
                                 default = nil)
  if valid_569303 != nil:
    section.add "resourceName", valid_569303
  var valid_569304 = path.getOrDefault("vCenterName")
  valid_569304 = validateParameter(valid_569304, JString, required = true,
                                 default = nil)
  if valid_569304 != nil:
    section.add "vCenterName", valid_569304
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569305 = query.getOrDefault("api-version")
  valid_569305 = validateParameter(valid_569305, JString, required = true,
                                 default = nil)
  if valid_569305 != nil:
    section.add "api-version", valid_569305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569306: Call_ReplicationvCentersGet_569297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a registered vCenter server(Add vCenter server.)
  ## 
  let valid = call_569306.validator(path, query, header, formData, body)
  let scheme = call_569306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569306.url(scheme.get, call_569306.host, call_569306.base,
                         call_569306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569306, url, valid)

proc call*(call_569307: Call_ReplicationvCentersGet_569297; fabricName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; vCenterName: string): Recallable =
  ## replicationvCentersGet
  ## Gets the details of a registered vCenter server(Add vCenter server.)
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   vCenterName: string (required)
  ##              : vCenter name.
  var path_569308 = newJObject()
  var query_569309 = newJObject()
  add(path_569308, "fabricName", newJString(fabricName))
  add(path_569308, "resourceGroupName", newJString(resourceGroupName))
  add(query_569309, "api-version", newJString(apiVersion))
  add(path_569308, "subscriptionId", newJString(subscriptionId))
  add(path_569308, "resourceName", newJString(resourceName))
  add(path_569308, "vCenterName", newJString(vCenterName))
  result = call_569307.call(path_569308, query_569309, nil, nil, nil)

var replicationvCentersGet* = Call_ReplicationvCentersGet_569297(
    name: "replicationvCentersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters/{vCenterName}",
    validator: validate_ReplicationvCentersGet_569298, base: "",
    url: url_ReplicationvCentersGet_569299, schemes: {Scheme.Https})
type
  Call_ReplicationvCentersUpdate_569338 = ref object of OpenApiRestCall_567668
proc url_ReplicationvCentersUpdate_569340(protocol: Scheme; host: string;
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

proc validate_ReplicationvCentersUpdate_569339(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update a registered vCenter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   vCenterName: JString (required)
  ##              : vCenter name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_569341 = path.getOrDefault("fabricName")
  valid_569341 = validateParameter(valid_569341, JString, required = true,
                                 default = nil)
  if valid_569341 != nil:
    section.add "fabricName", valid_569341
  var valid_569342 = path.getOrDefault("resourceGroupName")
  valid_569342 = validateParameter(valid_569342, JString, required = true,
                                 default = nil)
  if valid_569342 != nil:
    section.add "resourceGroupName", valid_569342
  var valid_569343 = path.getOrDefault("subscriptionId")
  valid_569343 = validateParameter(valid_569343, JString, required = true,
                                 default = nil)
  if valid_569343 != nil:
    section.add "subscriptionId", valid_569343
  var valid_569344 = path.getOrDefault("resourceName")
  valid_569344 = validateParameter(valid_569344, JString, required = true,
                                 default = nil)
  if valid_569344 != nil:
    section.add "resourceName", valid_569344
  var valid_569345 = path.getOrDefault("vCenterName")
  valid_569345 = validateParameter(valid_569345, JString, required = true,
                                 default = nil)
  if valid_569345 != nil:
    section.add "vCenterName", valid_569345
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569346 = query.getOrDefault("api-version")
  valid_569346 = validateParameter(valid_569346, JString, required = true,
                                 default = nil)
  if valid_569346 != nil:
    section.add "api-version", valid_569346
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

proc call*(call_569348: Call_ReplicationvCentersUpdate_569338; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a registered vCenter.
  ## 
  let valid = call_569348.validator(path, query, header, formData, body)
  let scheme = call_569348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569348.url(scheme.get, call_569348.host, call_569348.base,
                         call_569348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569348, url, valid)

proc call*(call_569349: Call_ReplicationvCentersUpdate_569338; fabricName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; vCenterName: string; updateVCenterRequest: JsonNode): Recallable =
  ## replicationvCentersUpdate
  ## The operation to update a registered vCenter.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   vCenterName: string (required)
  ##              : vCenter name
  ##   updateVCenterRequest: JObject (required)
  ##                       : The input to the update vCenter operation.
  var path_569350 = newJObject()
  var query_569351 = newJObject()
  var body_569352 = newJObject()
  add(path_569350, "fabricName", newJString(fabricName))
  add(path_569350, "resourceGroupName", newJString(resourceGroupName))
  add(query_569351, "api-version", newJString(apiVersion))
  add(path_569350, "subscriptionId", newJString(subscriptionId))
  add(path_569350, "resourceName", newJString(resourceName))
  add(path_569350, "vCenterName", newJString(vCenterName))
  if updateVCenterRequest != nil:
    body_569352 = updateVCenterRequest
  result = call_569349.call(path_569350, query_569351, nil, nil, body_569352)

var replicationvCentersUpdate* = Call_ReplicationvCentersUpdate_569338(
    name: "replicationvCentersUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters/{vCenterName}",
    validator: validate_ReplicationvCentersUpdate_569339, base: "",
    url: url_ReplicationvCentersUpdate_569340, schemes: {Scheme.Https})
type
  Call_ReplicationvCentersDelete_569325 = ref object of OpenApiRestCall_567668
proc url_ReplicationvCentersDelete_569327(protocol: Scheme; host: string;
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

proc validate_ReplicationvCentersDelete_569326(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to remove(unregister) a registered vCenter server from the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   fabricName: JString (required)
  ##             : Fabric name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   vCenterName: JString (required)
  ##              : vCenter name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `fabricName` field"
  var valid_569328 = path.getOrDefault("fabricName")
  valid_569328 = validateParameter(valid_569328, JString, required = true,
                                 default = nil)
  if valid_569328 != nil:
    section.add "fabricName", valid_569328
  var valid_569329 = path.getOrDefault("resourceGroupName")
  valid_569329 = validateParameter(valid_569329, JString, required = true,
                                 default = nil)
  if valid_569329 != nil:
    section.add "resourceGroupName", valid_569329
  var valid_569330 = path.getOrDefault("subscriptionId")
  valid_569330 = validateParameter(valid_569330, JString, required = true,
                                 default = nil)
  if valid_569330 != nil:
    section.add "subscriptionId", valid_569330
  var valid_569331 = path.getOrDefault("resourceName")
  valid_569331 = validateParameter(valid_569331, JString, required = true,
                                 default = nil)
  if valid_569331 != nil:
    section.add "resourceName", valid_569331
  var valid_569332 = path.getOrDefault("vCenterName")
  valid_569332 = validateParameter(valid_569332, JString, required = true,
                                 default = nil)
  if valid_569332 != nil:
    section.add "vCenterName", valid_569332
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569333 = query.getOrDefault("api-version")
  valid_569333 = validateParameter(valid_569333, JString, required = true,
                                 default = nil)
  if valid_569333 != nil:
    section.add "api-version", valid_569333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569334: Call_ReplicationvCentersDelete_569325; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to remove(unregister) a registered vCenter server from the vault.
  ## 
  let valid = call_569334.validator(path, query, header, formData, body)
  let scheme = call_569334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569334.url(scheme.get, call_569334.host, call_569334.base,
                         call_569334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569334, url, valid)

proc call*(call_569335: Call_ReplicationvCentersDelete_569325; fabricName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; vCenterName: string): Recallable =
  ## replicationvCentersDelete
  ## The operation to remove(unregister) a registered vCenter server from the vault.
  ##   fabricName: string (required)
  ##             : Fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   vCenterName: string (required)
  ##              : vCenter name.
  var path_569336 = newJObject()
  var query_569337 = newJObject()
  add(path_569336, "fabricName", newJString(fabricName))
  add(path_569336, "resourceGroupName", newJString(resourceGroupName))
  add(query_569337, "api-version", newJString(apiVersion))
  add(path_569336, "subscriptionId", newJString(subscriptionId))
  add(path_569336, "resourceName", newJString(resourceName))
  add(path_569336, "vCenterName", newJString(vCenterName))
  result = call_569335.call(path_569336, query_569337, nil, nil, nil)

var replicationvCentersDelete* = Call_ReplicationvCentersDelete_569325(
    name: "replicationvCentersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters/{vCenterName}",
    validator: validate_ReplicationvCentersDelete_569326, base: "",
    url: url_ReplicationvCentersDelete_569327, schemes: {Scheme.Https})
type
  Call_ReplicationJobsList_569353 = ref object of OpenApiRestCall_567668
proc url_ReplicationJobsList_569355(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationJobsList_569354(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets the list of Azure Site Recovery Jobs for the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569356 = path.getOrDefault("resourceGroupName")
  valid_569356 = validateParameter(valid_569356, JString, required = true,
                                 default = nil)
  if valid_569356 != nil:
    section.add "resourceGroupName", valid_569356
  var valid_569357 = path.getOrDefault("subscriptionId")
  valid_569357 = validateParameter(valid_569357, JString, required = true,
                                 default = nil)
  if valid_569357 != nil:
    section.add "subscriptionId", valid_569357
  var valid_569358 = path.getOrDefault("resourceName")
  valid_569358 = validateParameter(valid_569358, JString, required = true,
                                 default = nil)
  if valid_569358 != nil:
    section.add "resourceName", valid_569358
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569359 = query.getOrDefault("api-version")
  valid_569359 = validateParameter(valid_569359, JString, required = true,
                                 default = nil)
  if valid_569359 != nil:
    section.add "api-version", valid_569359
  var valid_569360 = query.getOrDefault("$filter")
  valid_569360 = validateParameter(valid_569360, JString, required = false,
                                 default = nil)
  if valid_569360 != nil:
    section.add "$filter", valid_569360
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569361: Call_ReplicationJobsList_569353; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of Azure Site Recovery Jobs for the vault.
  ## 
  let valid = call_569361.validator(path, query, header, formData, body)
  let scheme = call_569361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569361.url(scheme.get, call_569361.host, call_569361.base,
                         call_569361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569361, url, valid)

proc call*(call_569362: Call_ReplicationJobsList_569353; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          Filter: string = ""): Recallable =
  ## replicationJobsList
  ## Gets the list of Azure Site Recovery Jobs for the vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   Filter: string
  ##         : OData filter options.
  var path_569363 = newJObject()
  var query_569364 = newJObject()
  add(path_569363, "resourceGroupName", newJString(resourceGroupName))
  add(query_569364, "api-version", newJString(apiVersion))
  add(path_569363, "subscriptionId", newJString(subscriptionId))
  add(path_569363, "resourceName", newJString(resourceName))
  add(query_569364, "$filter", newJString(Filter))
  result = call_569362.call(path_569363, query_569364, nil, nil, nil)

var replicationJobsList* = Call_ReplicationJobsList_569353(
    name: "replicationJobsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs",
    validator: validate_ReplicationJobsList_569354, base: "",
    url: url_ReplicationJobsList_569355, schemes: {Scheme.Https})
type
  Call_ReplicationJobsExport_569365 = ref object of OpenApiRestCall_567668
proc url_ReplicationJobsExport_569367(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationJobsExport_569366(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to export the details of the Azure Site Recovery jobs of the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569368 = path.getOrDefault("resourceGroupName")
  valid_569368 = validateParameter(valid_569368, JString, required = true,
                                 default = nil)
  if valid_569368 != nil:
    section.add "resourceGroupName", valid_569368
  var valid_569369 = path.getOrDefault("subscriptionId")
  valid_569369 = validateParameter(valid_569369, JString, required = true,
                                 default = nil)
  if valid_569369 != nil:
    section.add "subscriptionId", valid_569369
  var valid_569370 = path.getOrDefault("resourceName")
  valid_569370 = validateParameter(valid_569370, JString, required = true,
                                 default = nil)
  if valid_569370 != nil:
    section.add "resourceName", valid_569370
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569371 = query.getOrDefault("api-version")
  valid_569371 = validateParameter(valid_569371, JString, required = true,
                                 default = nil)
  if valid_569371 != nil:
    section.add "api-version", valid_569371
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

proc call*(call_569373: Call_ReplicationJobsExport_569365; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to export the details of the Azure Site Recovery jobs of the vault.
  ## 
  let valid = call_569373.validator(path, query, header, formData, body)
  let scheme = call_569373.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569373.url(scheme.get, call_569373.host, call_569373.base,
                         call_569373.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569373, url, valid)

proc call*(call_569374: Call_ReplicationJobsExport_569365;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; jobQueryParameter: JsonNode): Recallable =
  ## replicationJobsExport
  ## The operation to export the details of the Azure Site Recovery jobs of the vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   jobQueryParameter: JObject (required)
  ##                    : job query filter.
  var path_569375 = newJObject()
  var query_569376 = newJObject()
  var body_569377 = newJObject()
  add(path_569375, "resourceGroupName", newJString(resourceGroupName))
  add(query_569376, "api-version", newJString(apiVersion))
  add(path_569375, "subscriptionId", newJString(subscriptionId))
  add(path_569375, "resourceName", newJString(resourceName))
  if jobQueryParameter != nil:
    body_569377 = jobQueryParameter
  result = call_569374.call(path_569375, query_569376, nil, nil, body_569377)

var replicationJobsExport* = Call_ReplicationJobsExport_569365(
    name: "replicationJobsExport", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/export",
    validator: validate_ReplicationJobsExport_569366, base: "",
    url: url_ReplicationJobsExport_569367, schemes: {Scheme.Https})
type
  Call_ReplicationJobsGet_569378 = ref object of OpenApiRestCall_567668
proc url_ReplicationJobsGet_569380(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationJobsGet_569379(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get the details of an Azure Site Recovery job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   jobName: JString (required)
  ##          : Job identifier
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569381 = path.getOrDefault("resourceGroupName")
  valid_569381 = validateParameter(valid_569381, JString, required = true,
                                 default = nil)
  if valid_569381 != nil:
    section.add "resourceGroupName", valid_569381
  var valid_569382 = path.getOrDefault("subscriptionId")
  valid_569382 = validateParameter(valid_569382, JString, required = true,
                                 default = nil)
  if valid_569382 != nil:
    section.add "subscriptionId", valid_569382
  var valid_569383 = path.getOrDefault("jobName")
  valid_569383 = validateParameter(valid_569383, JString, required = true,
                                 default = nil)
  if valid_569383 != nil:
    section.add "jobName", valid_569383
  var valid_569384 = path.getOrDefault("resourceName")
  valid_569384 = validateParameter(valid_569384, JString, required = true,
                                 default = nil)
  if valid_569384 != nil:
    section.add "resourceName", valid_569384
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569385 = query.getOrDefault("api-version")
  valid_569385 = validateParameter(valid_569385, JString, required = true,
                                 default = nil)
  if valid_569385 != nil:
    section.add "api-version", valid_569385
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569386: Call_ReplicationJobsGet_569378; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the details of an Azure Site Recovery job.
  ## 
  let valid = call_569386.validator(path, query, header, formData, body)
  let scheme = call_569386.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569386.url(scheme.get, call_569386.host, call_569386.base,
                         call_569386.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569386, url, valid)

proc call*(call_569387: Call_ReplicationJobsGet_569378; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string;
          resourceName: string): Recallable =
  ## replicationJobsGet
  ## Get the details of an Azure Site Recovery job.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   jobName: string (required)
  ##          : Job identifier
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_569388 = newJObject()
  var query_569389 = newJObject()
  add(path_569388, "resourceGroupName", newJString(resourceGroupName))
  add(query_569389, "api-version", newJString(apiVersion))
  add(path_569388, "subscriptionId", newJString(subscriptionId))
  add(path_569388, "jobName", newJString(jobName))
  add(path_569388, "resourceName", newJString(resourceName))
  result = call_569387.call(path_569388, query_569389, nil, nil, nil)

var replicationJobsGet* = Call_ReplicationJobsGet_569378(
    name: "replicationJobsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/{jobName}",
    validator: validate_ReplicationJobsGet_569379, base: "",
    url: url_ReplicationJobsGet_569380, schemes: {Scheme.Https})
type
  Call_ReplicationJobsCancel_569390 = ref object of OpenApiRestCall_567668
proc url_ReplicationJobsCancel_569392(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationJobsCancel_569391(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to cancel an Azure Site Recovery job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   jobName: JString (required)
  ##          : Job identifier.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569393 = path.getOrDefault("resourceGroupName")
  valid_569393 = validateParameter(valid_569393, JString, required = true,
                                 default = nil)
  if valid_569393 != nil:
    section.add "resourceGroupName", valid_569393
  var valid_569394 = path.getOrDefault("subscriptionId")
  valid_569394 = validateParameter(valid_569394, JString, required = true,
                                 default = nil)
  if valid_569394 != nil:
    section.add "subscriptionId", valid_569394
  var valid_569395 = path.getOrDefault("jobName")
  valid_569395 = validateParameter(valid_569395, JString, required = true,
                                 default = nil)
  if valid_569395 != nil:
    section.add "jobName", valid_569395
  var valid_569396 = path.getOrDefault("resourceName")
  valid_569396 = validateParameter(valid_569396, JString, required = true,
                                 default = nil)
  if valid_569396 != nil:
    section.add "resourceName", valid_569396
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569397 = query.getOrDefault("api-version")
  valid_569397 = validateParameter(valid_569397, JString, required = true,
                                 default = nil)
  if valid_569397 != nil:
    section.add "api-version", valid_569397
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569398: Call_ReplicationJobsCancel_569390; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to cancel an Azure Site Recovery job.
  ## 
  let valid = call_569398.validator(path, query, header, formData, body)
  let scheme = call_569398.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569398.url(scheme.get, call_569398.host, call_569398.base,
                         call_569398.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569398, url, valid)

proc call*(call_569399: Call_ReplicationJobsCancel_569390;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          jobName: string; resourceName: string): Recallable =
  ## replicationJobsCancel
  ## The operation to cancel an Azure Site Recovery job.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   jobName: string (required)
  ##          : Job identifier.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_569400 = newJObject()
  var query_569401 = newJObject()
  add(path_569400, "resourceGroupName", newJString(resourceGroupName))
  add(query_569401, "api-version", newJString(apiVersion))
  add(path_569400, "subscriptionId", newJString(subscriptionId))
  add(path_569400, "jobName", newJString(jobName))
  add(path_569400, "resourceName", newJString(resourceName))
  result = call_569399.call(path_569400, query_569401, nil, nil, nil)

var replicationJobsCancel* = Call_ReplicationJobsCancel_569390(
    name: "replicationJobsCancel", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/{jobName}/cancel",
    validator: validate_ReplicationJobsCancel_569391, base: "",
    url: url_ReplicationJobsCancel_569392, schemes: {Scheme.Https})
type
  Call_ReplicationJobsRestart_569402 = ref object of OpenApiRestCall_567668
proc url_ReplicationJobsRestart_569404(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationJobsRestart_569403(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to restart an Azure Site Recovery job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   jobName: JString (required)
  ##          : Job identifier.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569405 = path.getOrDefault("resourceGroupName")
  valid_569405 = validateParameter(valid_569405, JString, required = true,
                                 default = nil)
  if valid_569405 != nil:
    section.add "resourceGroupName", valid_569405
  var valid_569406 = path.getOrDefault("subscriptionId")
  valid_569406 = validateParameter(valid_569406, JString, required = true,
                                 default = nil)
  if valid_569406 != nil:
    section.add "subscriptionId", valid_569406
  var valid_569407 = path.getOrDefault("jobName")
  valid_569407 = validateParameter(valid_569407, JString, required = true,
                                 default = nil)
  if valid_569407 != nil:
    section.add "jobName", valid_569407
  var valid_569408 = path.getOrDefault("resourceName")
  valid_569408 = validateParameter(valid_569408, JString, required = true,
                                 default = nil)
  if valid_569408 != nil:
    section.add "resourceName", valid_569408
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569409 = query.getOrDefault("api-version")
  valid_569409 = validateParameter(valid_569409, JString, required = true,
                                 default = nil)
  if valid_569409 != nil:
    section.add "api-version", valid_569409
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569410: Call_ReplicationJobsRestart_569402; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to restart an Azure Site Recovery job.
  ## 
  let valid = call_569410.validator(path, query, header, formData, body)
  let scheme = call_569410.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569410.url(scheme.get, call_569410.host, call_569410.base,
                         call_569410.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569410, url, valid)

proc call*(call_569411: Call_ReplicationJobsRestart_569402;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          jobName: string; resourceName: string): Recallable =
  ## replicationJobsRestart
  ## The operation to restart an Azure Site Recovery job.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   jobName: string (required)
  ##          : Job identifier.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_569412 = newJObject()
  var query_569413 = newJObject()
  add(path_569412, "resourceGroupName", newJString(resourceGroupName))
  add(query_569413, "api-version", newJString(apiVersion))
  add(path_569412, "subscriptionId", newJString(subscriptionId))
  add(path_569412, "jobName", newJString(jobName))
  add(path_569412, "resourceName", newJString(resourceName))
  result = call_569411.call(path_569412, query_569413, nil, nil, nil)

var replicationJobsRestart* = Call_ReplicationJobsRestart_569402(
    name: "replicationJobsRestart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/{jobName}/restart",
    validator: validate_ReplicationJobsRestart_569403, base: "",
    url: url_ReplicationJobsRestart_569404, schemes: {Scheme.Https})
type
  Call_ReplicationJobsResume_569414 = ref object of OpenApiRestCall_567668
proc url_ReplicationJobsResume_569416(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationJobsResume_569415(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to resume an Azure Site Recovery job
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   jobName: JString (required)
  ##          : Job identifier.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569417 = path.getOrDefault("resourceGroupName")
  valid_569417 = validateParameter(valid_569417, JString, required = true,
                                 default = nil)
  if valid_569417 != nil:
    section.add "resourceGroupName", valid_569417
  var valid_569418 = path.getOrDefault("subscriptionId")
  valid_569418 = validateParameter(valid_569418, JString, required = true,
                                 default = nil)
  if valid_569418 != nil:
    section.add "subscriptionId", valid_569418
  var valid_569419 = path.getOrDefault("jobName")
  valid_569419 = validateParameter(valid_569419, JString, required = true,
                                 default = nil)
  if valid_569419 != nil:
    section.add "jobName", valid_569419
  var valid_569420 = path.getOrDefault("resourceName")
  valid_569420 = validateParameter(valid_569420, JString, required = true,
                                 default = nil)
  if valid_569420 != nil:
    section.add "resourceName", valid_569420
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569421 = query.getOrDefault("api-version")
  valid_569421 = validateParameter(valid_569421, JString, required = true,
                                 default = nil)
  if valid_569421 != nil:
    section.add "api-version", valid_569421
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

proc call*(call_569423: Call_ReplicationJobsResume_569414; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to resume an Azure Site Recovery job
  ## 
  let valid = call_569423.validator(path, query, header, formData, body)
  let scheme = call_569423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569423.url(scheme.get, call_569423.host, call_569423.base,
                         call_569423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569423, url, valid)

proc call*(call_569424: Call_ReplicationJobsResume_569414;
          resourceGroupName: string; apiVersion: string; resumeJobParams: JsonNode;
          subscriptionId: string; jobName: string; resourceName: string): Recallable =
  ## replicationJobsResume
  ## The operation to resume an Azure Site Recovery job
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   resumeJobParams: JObject (required)
  ##                  : Resume rob comments.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   jobName: string (required)
  ##          : Job identifier.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_569425 = newJObject()
  var query_569426 = newJObject()
  var body_569427 = newJObject()
  add(path_569425, "resourceGroupName", newJString(resourceGroupName))
  add(query_569426, "api-version", newJString(apiVersion))
  if resumeJobParams != nil:
    body_569427 = resumeJobParams
  add(path_569425, "subscriptionId", newJString(subscriptionId))
  add(path_569425, "jobName", newJString(jobName))
  add(path_569425, "resourceName", newJString(resourceName))
  result = call_569424.call(path_569425, query_569426, nil, nil, body_569427)

var replicationJobsResume* = Call_ReplicationJobsResume_569414(
    name: "replicationJobsResume", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/{jobName}/resume",
    validator: validate_ReplicationJobsResume_569415, base: "",
    url: url_ReplicationJobsResume_569416, schemes: {Scheme.Https})
type
  Call_ReplicationMigrationItemsList_569428 = ref object of OpenApiRestCall_567668
proc url_ReplicationMigrationItemsList_569430(protocol: Scheme; host: string;
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

proc validate_ReplicationMigrationItemsList_569429(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569431 = path.getOrDefault("resourceGroupName")
  valid_569431 = validateParameter(valid_569431, JString, required = true,
                                 default = nil)
  if valid_569431 != nil:
    section.add "resourceGroupName", valid_569431
  var valid_569432 = path.getOrDefault("subscriptionId")
  valid_569432 = validateParameter(valid_569432, JString, required = true,
                                 default = nil)
  if valid_569432 != nil:
    section.add "subscriptionId", valid_569432
  var valid_569433 = path.getOrDefault("resourceName")
  valid_569433 = validateParameter(valid_569433, JString, required = true,
                                 default = nil)
  if valid_569433 != nil:
    section.add "resourceName", valid_569433
  result.add "path", section
  ## parameters in `query` object:
  ##   skipToken: JString
  ##            : The pagination token.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  var valid_569434 = query.getOrDefault("skipToken")
  valid_569434 = validateParameter(valid_569434, JString, required = false,
                                 default = nil)
  if valid_569434 != nil:
    section.add "skipToken", valid_569434
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569435 = query.getOrDefault("api-version")
  valid_569435 = validateParameter(valid_569435, JString, required = true,
                                 default = nil)
  if valid_569435 != nil:
    section.add "api-version", valid_569435
  var valid_569436 = query.getOrDefault("$filter")
  valid_569436 = validateParameter(valid_569436, JString, required = false,
                                 default = nil)
  if valid_569436 != nil:
    section.add "$filter", valid_569436
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569437: Call_ReplicationMigrationItemsList_569428; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569437.validator(path, query, header, formData, body)
  let scheme = call_569437.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569437.url(scheme.get, call_569437.host, call_569437.base,
                         call_569437.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569437, url, valid)

proc call*(call_569438: Call_ReplicationMigrationItemsList_569428;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; skipToken: string = ""; Filter: string = ""): Recallable =
  ## replicationMigrationItemsList
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   skipToken: string
  ##            : The pagination token.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   Filter: string
  ##         : OData filter options.
  var path_569439 = newJObject()
  var query_569440 = newJObject()
  add(path_569439, "resourceGroupName", newJString(resourceGroupName))
  add(query_569440, "skipToken", newJString(skipToken))
  add(query_569440, "api-version", newJString(apiVersion))
  add(path_569439, "subscriptionId", newJString(subscriptionId))
  add(path_569439, "resourceName", newJString(resourceName))
  add(query_569440, "$filter", newJString(Filter))
  result = call_569438.call(path_569439, query_569440, nil, nil, nil)

var replicationMigrationItemsList* = Call_ReplicationMigrationItemsList_569428(
    name: "replicationMigrationItemsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationMigrationItems",
    validator: validate_ReplicationMigrationItemsList_569429, base: "",
    url: url_ReplicationMigrationItemsList_569430, schemes: {Scheme.Https})
type
  Call_ReplicationNetworkMappingsList_569441 = ref object of OpenApiRestCall_567668
proc url_ReplicationNetworkMappingsList_569443(protocol: Scheme; host: string;
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

proc validate_ReplicationNetworkMappingsList_569442(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all ASR network mappings in the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569444 = path.getOrDefault("resourceGroupName")
  valid_569444 = validateParameter(valid_569444, JString, required = true,
                                 default = nil)
  if valid_569444 != nil:
    section.add "resourceGroupName", valid_569444
  var valid_569445 = path.getOrDefault("subscriptionId")
  valid_569445 = validateParameter(valid_569445, JString, required = true,
                                 default = nil)
  if valid_569445 != nil:
    section.add "subscriptionId", valid_569445
  var valid_569446 = path.getOrDefault("resourceName")
  valid_569446 = validateParameter(valid_569446, JString, required = true,
                                 default = nil)
  if valid_569446 != nil:
    section.add "resourceName", valid_569446
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569447 = query.getOrDefault("api-version")
  valid_569447 = validateParameter(valid_569447, JString, required = true,
                                 default = nil)
  if valid_569447 != nil:
    section.add "api-version", valid_569447
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569448: Call_ReplicationNetworkMappingsList_569441; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all ASR network mappings in the vault.
  ## 
  let valid = call_569448.validator(path, query, header, formData, body)
  let scheme = call_569448.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569448.url(scheme.get, call_569448.host, call_569448.base,
                         call_569448.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569448, url, valid)

proc call*(call_569449: Call_ReplicationNetworkMappingsList_569441;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationNetworkMappingsList
  ## Lists all ASR network mappings in the vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_569450 = newJObject()
  var query_569451 = newJObject()
  add(path_569450, "resourceGroupName", newJString(resourceGroupName))
  add(query_569451, "api-version", newJString(apiVersion))
  add(path_569450, "subscriptionId", newJString(subscriptionId))
  add(path_569450, "resourceName", newJString(resourceName))
  result = call_569449.call(path_569450, query_569451, nil, nil, nil)

var replicationNetworkMappingsList* = Call_ReplicationNetworkMappingsList_569441(
    name: "replicationNetworkMappingsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationNetworkMappings",
    validator: validate_ReplicationNetworkMappingsList_569442, base: "",
    url: url_ReplicationNetworkMappingsList_569443, schemes: {Scheme.Https})
type
  Call_ReplicationNetworksList_569452 = ref object of OpenApiRestCall_567668
proc url_ReplicationNetworksList_569454(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationNetworksList_569453(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the networks available in a vault
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569455 = path.getOrDefault("resourceGroupName")
  valid_569455 = validateParameter(valid_569455, JString, required = true,
                                 default = nil)
  if valid_569455 != nil:
    section.add "resourceGroupName", valid_569455
  var valid_569456 = path.getOrDefault("subscriptionId")
  valid_569456 = validateParameter(valid_569456, JString, required = true,
                                 default = nil)
  if valid_569456 != nil:
    section.add "subscriptionId", valid_569456
  var valid_569457 = path.getOrDefault("resourceName")
  valid_569457 = validateParameter(valid_569457, JString, required = true,
                                 default = nil)
  if valid_569457 != nil:
    section.add "resourceName", valid_569457
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569458 = query.getOrDefault("api-version")
  valid_569458 = validateParameter(valid_569458, JString, required = true,
                                 default = nil)
  if valid_569458 != nil:
    section.add "api-version", valid_569458
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569459: Call_ReplicationNetworksList_569452; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the networks available in a vault
  ## 
  let valid = call_569459.validator(path, query, header, formData, body)
  let scheme = call_569459.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569459.url(scheme.get, call_569459.host, call_569459.base,
                         call_569459.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569459, url, valid)

proc call*(call_569460: Call_ReplicationNetworksList_569452;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationNetworksList
  ## Lists the networks available in a vault
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_569461 = newJObject()
  var query_569462 = newJObject()
  add(path_569461, "resourceGroupName", newJString(resourceGroupName))
  add(query_569462, "api-version", newJString(apiVersion))
  add(path_569461, "subscriptionId", newJString(subscriptionId))
  add(path_569461, "resourceName", newJString(resourceName))
  result = call_569460.call(path_569461, query_569462, nil, nil, nil)

var replicationNetworksList* = Call_ReplicationNetworksList_569452(
    name: "replicationNetworksList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationNetworks",
    validator: validate_ReplicationNetworksList_569453, base: "",
    url: url_ReplicationNetworksList_569454, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesList_569463 = ref object of OpenApiRestCall_567668
proc url_ReplicationPoliciesList_569465(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationPoliciesList_569464(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the replication policies for a vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569466 = path.getOrDefault("resourceGroupName")
  valid_569466 = validateParameter(valid_569466, JString, required = true,
                                 default = nil)
  if valid_569466 != nil:
    section.add "resourceGroupName", valid_569466
  var valid_569467 = path.getOrDefault("subscriptionId")
  valid_569467 = validateParameter(valid_569467, JString, required = true,
                                 default = nil)
  if valid_569467 != nil:
    section.add "subscriptionId", valid_569467
  var valid_569468 = path.getOrDefault("resourceName")
  valid_569468 = validateParameter(valid_569468, JString, required = true,
                                 default = nil)
  if valid_569468 != nil:
    section.add "resourceName", valid_569468
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569469 = query.getOrDefault("api-version")
  valid_569469 = validateParameter(valid_569469, JString, required = true,
                                 default = nil)
  if valid_569469 != nil:
    section.add "api-version", valid_569469
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569470: Call_ReplicationPoliciesList_569463; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the replication policies for a vault.
  ## 
  let valid = call_569470.validator(path, query, header, formData, body)
  let scheme = call_569470.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569470.url(scheme.get, call_569470.host, call_569470.base,
                         call_569470.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569470, url, valid)

proc call*(call_569471: Call_ReplicationPoliciesList_569463;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationPoliciesList
  ## Lists the replication policies for a vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_569472 = newJObject()
  var query_569473 = newJObject()
  add(path_569472, "resourceGroupName", newJString(resourceGroupName))
  add(query_569473, "api-version", newJString(apiVersion))
  add(path_569472, "subscriptionId", newJString(subscriptionId))
  add(path_569472, "resourceName", newJString(resourceName))
  result = call_569471.call(path_569472, query_569473, nil, nil, nil)

var replicationPoliciesList* = Call_ReplicationPoliciesList_569463(
    name: "replicationPoliciesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies",
    validator: validate_ReplicationPoliciesList_569464, base: "",
    url: url_ReplicationPoliciesList_569465, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesCreate_569486 = ref object of OpenApiRestCall_567668
proc url_ReplicationPoliciesCreate_569488(protocol: Scheme; host: string;
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

proc validate_ReplicationPoliciesCreate_569487(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create a replication policy
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   policyName: JString (required)
  ##             : Replication policy name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569489 = path.getOrDefault("resourceGroupName")
  valid_569489 = validateParameter(valid_569489, JString, required = true,
                                 default = nil)
  if valid_569489 != nil:
    section.add "resourceGroupName", valid_569489
  var valid_569490 = path.getOrDefault("subscriptionId")
  valid_569490 = validateParameter(valid_569490, JString, required = true,
                                 default = nil)
  if valid_569490 != nil:
    section.add "subscriptionId", valid_569490
  var valid_569491 = path.getOrDefault("resourceName")
  valid_569491 = validateParameter(valid_569491, JString, required = true,
                                 default = nil)
  if valid_569491 != nil:
    section.add "resourceName", valid_569491
  var valid_569492 = path.getOrDefault("policyName")
  valid_569492 = validateParameter(valid_569492, JString, required = true,
                                 default = nil)
  if valid_569492 != nil:
    section.add "policyName", valid_569492
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569493 = query.getOrDefault("api-version")
  valid_569493 = validateParameter(valid_569493, JString, required = true,
                                 default = nil)
  if valid_569493 != nil:
    section.add "api-version", valid_569493
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

proc call*(call_569495: Call_ReplicationPoliciesCreate_569486; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create a replication policy
  ## 
  let valid = call_569495.validator(path, query, header, formData, body)
  let scheme = call_569495.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569495.url(scheme.get, call_569495.host, call_569495.base,
                         call_569495.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569495, url, valid)

proc call*(call_569496: Call_ReplicationPoliciesCreate_569486;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          input: JsonNode; resourceName: string; policyName: string): Recallable =
  ## replicationPoliciesCreate
  ## The operation to create a replication policy
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   input: JObject (required)
  ##        : Create policy input
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   policyName: string (required)
  ##             : Replication policy name
  var path_569497 = newJObject()
  var query_569498 = newJObject()
  var body_569499 = newJObject()
  add(path_569497, "resourceGroupName", newJString(resourceGroupName))
  add(query_569498, "api-version", newJString(apiVersion))
  add(path_569497, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_569499 = input
  add(path_569497, "resourceName", newJString(resourceName))
  add(path_569497, "policyName", newJString(policyName))
  result = call_569496.call(path_569497, query_569498, nil, nil, body_569499)

var replicationPoliciesCreate* = Call_ReplicationPoliciesCreate_569486(
    name: "replicationPoliciesCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies/{policyName}",
    validator: validate_ReplicationPoliciesCreate_569487, base: "",
    url: url_ReplicationPoliciesCreate_569488, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesGet_569474 = ref object of OpenApiRestCall_567668
proc url_ReplicationPoliciesGet_569476(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationPoliciesGet_569475(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of a replication policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   policyName: JString (required)
  ##             : Replication policy name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569477 = path.getOrDefault("resourceGroupName")
  valid_569477 = validateParameter(valid_569477, JString, required = true,
                                 default = nil)
  if valid_569477 != nil:
    section.add "resourceGroupName", valid_569477
  var valid_569478 = path.getOrDefault("subscriptionId")
  valid_569478 = validateParameter(valid_569478, JString, required = true,
                                 default = nil)
  if valid_569478 != nil:
    section.add "subscriptionId", valid_569478
  var valid_569479 = path.getOrDefault("resourceName")
  valid_569479 = validateParameter(valid_569479, JString, required = true,
                                 default = nil)
  if valid_569479 != nil:
    section.add "resourceName", valid_569479
  var valid_569480 = path.getOrDefault("policyName")
  valid_569480 = validateParameter(valid_569480, JString, required = true,
                                 default = nil)
  if valid_569480 != nil:
    section.add "policyName", valid_569480
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569481 = query.getOrDefault("api-version")
  valid_569481 = validateParameter(valid_569481, JString, required = true,
                                 default = nil)
  if valid_569481 != nil:
    section.add "api-version", valid_569481
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569482: Call_ReplicationPoliciesGet_569474; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a replication policy.
  ## 
  let valid = call_569482.validator(path, query, header, formData, body)
  let scheme = call_569482.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569482.url(scheme.get, call_569482.host, call_569482.base,
                         call_569482.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569482, url, valid)

proc call*(call_569483: Call_ReplicationPoliciesGet_569474;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; policyName: string): Recallable =
  ## replicationPoliciesGet
  ## Gets the details of a replication policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   policyName: string (required)
  ##             : Replication policy name.
  var path_569484 = newJObject()
  var query_569485 = newJObject()
  add(path_569484, "resourceGroupName", newJString(resourceGroupName))
  add(query_569485, "api-version", newJString(apiVersion))
  add(path_569484, "subscriptionId", newJString(subscriptionId))
  add(path_569484, "resourceName", newJString(resourceName))
  add(path_569484, "policyName", newJString(policyName))
  result = call_569483.call(path_569484, query_569485, nil, nil, nil)

var replicationPoliciesGet* = Call_ReplicationPoliciesGet_569474(
    name: "replicationPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies/{policyName}",
    validator: validate_ReplicationPoliciesGet_569475, base: "",
    url: url_ReplicationPoliciesGet_569476, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesUpdate_569512 = ref object of OpenApiRestCall_567668
proc url_ReplicationPoliciesUpdate_569514(protocol: Scheme; host: string;
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

proc validate_ReplicationPoliciesUpdate_569513(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update a replication policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   policyName: JString (required)
  ##             : Policy Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569515 = path.getOrDefault("resourceGroupName")
  valid_569515 = validateParameter(valid_569515, JString, required = true,
                                 default = nil)
  if valid_569515 != nil:
    section.add "resourceGroupName", valid_569515
  var valid_569516 = path.getOrDefault("subscriptionId")
  valid_569516 = validateParameter(valid_569516, JString, required = true,
                                 default = nil)
  if valid_569516 != nil:
    section.add "subscriptionId", valid_569516
  var valid_569517 = path.getOrDefault("resourceName")
  valid_569517 = validateParameter(valid_569517, JString, required = true,
                                 default = nil)
  if valid_569517 != nil:
    section.add "resourceName", valid_569517
  var valid_569518 = path.getOrDefault("policyName")
  valid_569518 = validateParameter(valid_569518, JString, required = true,
                                 default = nil)
  if valid_569518 != nil:
    section.add "policyName", valid_569518
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569519 = query.getOrDefault("api-version")
  valid_569519 = validateParameter(valid_569519, JString, required = true,
                                 default = nil)
  if valid_569519 != nil:
    section.add "api-version", valid_569519
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

proc call*(call_569521: Call_ReplicationPoliciesUpdate_569512; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a replication policy.
  ## 
  let valid = call_569521.validator(path, query, header, formData, body)
  let scheme = call_569521.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569521.url(scheme.get, call_569521.host, call_569521.base,
                         call_569521.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569521, url, valid)

proc call*(call_569522: Call_ReplicationPoliciesUpdate_569512;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          input: JsonNode; resourceName: string; policyName: string): Recallable =
  ## replicationPoliciesUpdate
  ## The operation to update a replication policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   input: JObject (required)
  ##        : Update Policy Input
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   policyName: string (required)
  ##             : Policy Id.
  var path_569523 = newJObject()
  var query_569524 = newJObject()
  var body_569525 = newJObject()
  add(path_569523, "resourceGroupName", newJString(resourceGroupName))
  add(query_569524, "api-version", newJString(apiVersion))
  add(path_569523, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_569525 = input
  add(path_569523, "resourceName", newJString(resourceName))
  add(path_569523, "policyName", newJString(policyName))
  result = call_569522.call(path_569523, query_569524, nil, nil, body_569525)

var replicationPoliciesUpdate* = Call_ReplicationPoliciesUpdate_569512(
    name: "replicationPoliciesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies/{policyName}",
    validator: validate_ReplicationPoliciesUpdate_569513, base: "",
    url: url_ReplicationPoliciesUpdate_569514, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesDelete_569500 = ref object of OpenApiRestCall_567668
proc url_ReplicationPoliciesDelete_569502(protocol: Scheme; host: string;
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

proc validate_ReplicationPoliciesDelete_569501(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete a replication policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  ##   policyName: JString (required)
  ##             : Replication policy name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569503 = path.getOrDefault("resourceGroupName")
  valid_569503 = validateParameter(valid_569503, JString, required = true,
                                 default = nil)
  if valid_569503 != nil:
    section.add "resourceGroupName", valid_569503
  var valid_569504 = path.getOrDefault("subscriptionId")
  valid_569504 = validateParameter(valid_569504, JString, required = true,
                                 default = nil)
  if valid_569504 != nil:
    section.add "subscriptionId", valid_569504
  var valid_569505 = path.getOrDefault("resourceName")
  valid_569505 = validateParameter(valid_569505, JString, required = true,
                                 default = nil)
  if valid_569505 != nil:
    section.add "resourceName", valid_569505
  var valid_569506 = path.getOrDefault("policyName")
  valid_569506 = validateParameter(valid_569506, JString, required = true,
                                 default = nil)
  if valid_569506 != nil:
    section.add "policyName", valid_569506
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569507 = query.getOrDefault("api-version")
  valid_569507 = validateParameter(valid_569507, JString, required = true,
                                 default = nil)
  if valid_569507 != nil:
    section.add "api-version", valid_569507
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569508: Call_ReplicationPoliciesDelete_569500; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete a replication policy.
  ## 
  let valid = call_569508.validator(path, query, header, formData, body)
  let scheme = call_569508.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569508.url(scheme.get, call_569508.host, call_569508.base,
                         call_569508.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569508, url, valid)

proc call*(call_569509: Call_ReplicationPoliciesDelete_569500;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; policyName: string): Recallable =
  ## replicationPoliciesDelete
  ## The operation to delete a replication policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   policyName: string (required)
  ##             : Replication policy name.
  var path_569510 = newJObject()
  var query_569511 = newJObject()
  add(path_569510, "resourceGroupName", newJString(resourceGroupName))
  add(query_569511, "api-version", newJString(apiVersion))
  add(path_569510, "subscriptionId", newJString(subscriptionId))
  add(path_569510, "resourceName", newJString(resourceName))
  add(path_569510, "policyName", newJString(policyName))
  result = call_569509.call(path_569510, query_569511, nil, nil, nil)

var replicationPoliciesDelete* = Call_ReplicationPoliciesDelete_569500(
    name: "replicationPoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies/{policyName}",
    validator: validate_ReplicationPoliciesDelete_569501, base: "",
    url: url_ReplicationPoliciesDelete_569502, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsList_569526 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectedItemsList_569528(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectedItemsList_569527(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the list of ASR replication protected items in the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569529 = path.getOrDefault("resourceGroupName")
  valid_569529 = validateParameter(valid_569529, JString, required = true,
                                 default = nil)
  if valid_569529 != nil:
    section.add "resourceGroupName", valid_569529
  var valid_569530 = path.getOrDefault("subscriptionId")
  valid_569530 = validateParameter(valid_569530, JString, required = true,
                                 default = nil)
  if valid_569530 != nil:
    section.add "subscriptionId", valid_569530
  var valid_569531 = path.getOrDefault("resourceName")
  valid_569531 = validateParameter(valid_569531, JString, required = true,
                                 default = nil)
  if valid_569531 != nil:
    section.add "resourceName", valid_569531
  result.add "path", section
  ## parameters in `query` object:
  ##   skipToken: JString
  ##            : The pagination token. Possible values: "FabricId" or "FabricId_CloudId" or null
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  var valid_569532 = query.getOrDefault("skipToken")
  valid_569532 = validateParameter(valid_569532, JString, required = false,
                                 default = nil)
  if valid_569532 != nil:
    section.add "skipToken", valid_569532
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569533 = query.getOrDefault("api-version")
  valid_569533 = validateParameter(valid_569533, JString, required = true,
                                 default = nil)
  if valid_569533 != nil:
    section.add "api-version", valid_569533
  var valid_569534 = query.getOrDefault("$filter")
  valid_569534 = validateParameter(valid_569534, JString, required = false,
                                 default = nil)
  if valid_569534 != nil:
    section.add "$filter", valid_569534
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569535: Call_ReplicationProtectedItemsList_569526; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of ASR replication protected items in the vault.
  ## 
  let valid = call_569535.validator(path, query, header, formData, body)
  let scheme = call_569535.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569535.url(scheme.get, call_569535.host, call_569535.base,
                         call_569535.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569535, url, valid)

proc call*(call_569536: Call_ReplicationProtectedItemsList_569526;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; skipToken: string = ""; Filter: string = ""): Recallable =
  ## replicationProtectedItemsList
  ## Gets the list of ASR replication protected items in the vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   skipToken: string
  ##            : The pagination token. Possible values: "FabricId" or "FabricId_CloudId" or null
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   Filter: string
  ##         : OData filter options.
  var path_569537 = newJObject()
  var query_569538 = newJObject()
  add(path_569537, "resourceGroupName", newJString(resourceGroupName))
  add(query_569538, "skipToken", newJString(skipToken))
  add(query_569538, "api-version", newJString(apiVersion))
  add(path_569537, "subscriptionId", newJString(subscriptionId))
  add(path_569537, "resourceName", newJString(resourceName))
  add(query_569538, "$filter", newJString(Filter))
  result = call_569536.call(path_569537, query_569538, nil, nil, nil)

var replicationProtectedItemsList* = Call_ReplicationProtectedItemsList_569526(
    name: "replicationProtectedItemsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationProtectedItems",
    validator: validate_ReplicationProtectedItemsList_569527, base: "",
    url: url_ReplicationProtectedItemsList_569528, schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsList_569539 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectionContainerMappingsList_569541(protocol: Scheme;
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

proc validate_ReplicationProtectionContainerMappingsList_569540(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the protection container mappings in the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569542 = path.getOrDefault("resourceGroupName")
  valid_569542 = validateParameter(valid_569542, JString, required = true,
                                 default = nil)
  if valid_569542 != nil:
    section.add "resourceGroupName", valid_569542
  var valid_569543 = path.getOrDefault("subscriptionId")
  valid_569543 = validateParameter(valid_569543, JString, required = true,
                                 default = nil)
  if valid_569543 != nil:
    section.add "subscriptionId", valid_569543
  var valid_569544 = path.getOrDefault("resourceName")
  valid_569544 = validateParameter(valid_569544, JString, required = true,
                                 default = nil)
  if valid_569544 != nil:
    section.add "resourceName", valid_569544
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569545 = query.getOrDefault("api-version")
  valid_569545 = validateParameter(valid_569545, JString, required = true,
                                 default = nil)
  if valid_569545 != nil:
    section.add "api-version", valid_569545
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569546: Call_ReplicationProtectionContainerMappingsList_569539;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the protection container mappings in the vault.
  ## 
  let valid = call_569546.validator(path, query, header, formData, body)
  let scheme = call_569546.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569546.url(scheme.get, call_569546.host, call_569546.base,
                         call_569546.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569546, url, valid)

proc call*(call_569547: Call_ReplicationProtectionContainerMappingsList_569539;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationProtectionContainerMappingsList
  ## Lists the protection container mappings in the vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_569548 = newJObject()
  var query_569549 = newJObject()
  add(path_569548, "resourceGroupName", newJString(resourceGroupName))
  add(query_569549, "api-version", newJString(apiVersion))
  add(path_569548, "subscriptionId", newJString(subscriptionId))
  add(path_569548, "resourceName", newJString(resourceName))
  result = call_569547.call(path_569548, query_569549, nil, nil, nil)

var replicationProtectionContainerMappingsList* = Call_ReplicationProtectionContainerMappingsList_569539(
    name: "replicationProtectionContainerMappingsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationProtectionContainerMappings",
    validator: validate_ReplicationProtectionContainerMappingsList_569540,
    base: "", url: url_ReplicationProtectionContainerMappingsList_569541,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersList_569550 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectionContainersList_569552(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectionContainersList_569551(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the protection containers in a vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569553 = path.getOrDefault("resourceGroupName")
  valid_569553 = validateParameter(valid_569553, JString, required = true,
                                 default = nil)
  if valid_569553 != nil:
    section.add "resourceGroupName", valid_569553
  var valid_569554 = path.getOrDefault("subscriptionId")
  valid_569554 = validateParameter(valid_569554, JString, required = true,
                                 default = nil)
  if valid_569554 != nil:
    section.add "subscriptionId", valid_569554
  var valid_569555 = path.getOrDefault("resourceName")
  valid_569555 = validateParameter(valid_569555, JString, required = true,
                                 default = nil)
  if valid_569555 != nil:
    section.add "resourceName", valid_569555
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569556 = query.getOrDefault("api-version")
  valid_569556 = validateParameter(valid_569556, JString, required = true,
                                 default = nil)
  if valid_569556 != nil:
    section.add "api-version", valid_569556
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569557: Call_ReplicationProtectionContainersList_569550;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the protection containers in a vault.
  ## 
  let valid = call_569557.validator(path, query, header, formData, body)
  let scheme = call_569557.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569557.url(scheme.get, call_569557.host, call_569557.base,
                         call_569557.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569557, url, valid)

proc call*(call_569558: Call_ReplicationProtectionContainersList_569550;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationProtectionContainersList
  ## Lists the protection containers in a vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_569559 = newJObject()
  var query_569560 = newJObject()
  add(path_569559, "resourceGroupName", newJString(resourceGroupName))
  add(query_569560, "api-version", newJString(apiVersion))
  add(path_569559, "subscriptionId", newJString(subscriptionId))
  add(path_569559, "resourceName", newJString(resourceName))
  result = call_569558.call(path_569559, query_569560, nil, nil, nil)

var replicationProtectionContainersList* = Call_ReplicationProtectionContainersList_569550(
    name: "replicationProtectionContainersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationProtectionContainers",
    validator: validate_ReplicationProtectionContainersList_569551, base: "",
    url: url_ReplicationProtectionContainersList_569552, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansList_569561 = ref object of OpenApiRestCall_567668
proc url_ReplicationRecoveryPlansList_569563(protocol: Scheme; host: string;
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

proc validate_ReplicationRecoveryPlansList_569562(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the recovery plans in the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569564 = path.getOrDefault("resourceGroupName")
  valid_569564 = validateParameter(valid_569564, JString, required = true,
                                 default = nil)
  if valid_569564 != nil:
    section.add "resourceGroupName", valid_569564
  var valid_569565 = path.getOrDefault("subscriptionId")
  valid_569565 = validateParameter(valid_569565, JString, required = true,
                                 default = nil)
  if valid_569565 != nil:
    section.add "subscriptionId", valid_569565
  var valid_569566 = path.getOrDefault("resourceName")
  valid_569566 = validateParameter(valid_569566, JString, required = true,
                                 default = nil)
  if valid_569566 != nil:
    section.add "resourceName", valid_569566
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569567 = query.getOrDefault("api-version")
  valid_569567 = validateParameter(valid_569567, JString, required = true,
                                 default = nil)
  if valid_569567 != nil:
    section.add "api-version", valid_569567
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569568: Call_ReplicationRecoveryPlansList_569561; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the recovery plans in the vault.
  ## 
  let valid = call_569568.validator(path, query, header, formData, body)
  let scheme = call_569568.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569568.url(scheme.get, call_569568.host, call_569568.base,
                         call_569568.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569568, url, valid)

proc call*(call_569569: Call_ReplicationRecoveryPlansList_569561;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationRecoveryPlansList
  ## Lists the recovery plans in the vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_569570 = newJObject()
  var query_569571 = newJObject()
  add(path_569570, "resourceGroupName", newJString(resourceGroupName))
  add(query_569571, "api-version", newJString(apiVersion))
  add(path_569570, "subscriptionId", newJString(subscriptionId))
  add(path_569570, "resourceName", newJString(resourceName))
  result = call_569569.call(path_569570, query_569571, nil, nil, nil)

var replicationRecoveryPlansList* = Call_ReplicationRecoveryPlansList_569561(
    name: "replicationRecoveryPlansList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans",
    validator: validate_ReplicationRecoveryPlansList_569562, base: "",
    url: url_ReplicationRecoveryPlansList_569563, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansCreate_569584 = ref object of OpenApiRestCall_567668
proc url_ReplicationRecoveryPlansCreate_569586(protocol: Scheme; host: string;
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

proc validate_ReplicationRecoveryPlansCreate_569585(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create a recovery plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   recoveryPlanName: JString (required)
  ##                   : Recovery plan name.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569587 = path.getOrDefault("resourceGroupName")
  valid_569587 = validateParameter(valid_569587, JString, required = true,
                                 default = nil)
  if valid_569587 != nil:
    section.add "resourceGroupName", valid_569587
  var valid_569588 = path.getOrDefault("subscriptionId")
  valid_569588 = validateParameter(valid_569588, JString, required = true,
                                 default = nil)
  if valid_569588 != nil:
    section.add "subscriptionId", valid_569588
  var valid_569589 = path.getOrDefault("recoveryPlanName")
  valid_569589 = validateParameter(valid_569589, JString, required = true,
                                 default = nil)
  if valid_569589 != nil:
    section.add "recoveryPlanName", valid_569589
  var valid_569590 = path.getOrDefault("resourceName")
  valid_569590 = validateParameter(valid_569590, JString, required = true,
                                 default = nil)
  if valid_569590 != nil:
    section.add "resourceName", valid_569590
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569591 = query.getOrDefault("api-version")
  valid_569591 = validateParameter(valid_569591, JString, required = true,
                                 default = nil)
  if valid_569591 != nil:
    section.add "api-version", valid_569591
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

proc call*(call_569593: Call_ReplicationRecoveryPlansCreate_569584; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create a recovery plan.
  ## 
  let valid = call_569593.validator(path, query, header, formData, body)
  let scheme = call_569593.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569593.url(scheme.get, call_569593.host, call_569593.base,
                         call_569593.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569593, url, valid)

proc call*(call_569594: Call_ReplicationRecoveryPlansCreate_569584;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          input: JsonNode; recoveryPlanName: string; resourceName: string): Recallable =
  ## replicationRecoveryPlansCreate
  ## The operation to create a recovery plan.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   input: JObject (required)
  ##        : Recovery Plan creation input.
  ##   recoveryPlanName: string (required)
  ##                   : Recovery plan name.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_569595 = newJObject()
  var query_569596 = newJObject()
  var body_569597 = newJObject()
  add(path_569595, "resourceGroupName", newJString(resourceGroupName))
  add(query_569596, "api-version", newJString(apiVersion))
  add(path_569595, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_569597 = input
  add(path_569595, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_569595, "resourceName", newJString(resourceName))
  result = call_569594.call(path_569595, query_569596, nil, nil, body_569597)

var replicationRecoveryPlansCreate* = Call_ReplicationRecoveryPlansCreate_569584(
    name: "replicationRecoveryPlansCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}",
    validator: validate_ReplicationRecoveryPlansCreate_569585, base: "",
    url: url_ReplicationRecoveryPlansCreate_569586, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansGet_569572 = ref object of OpenApiRestCall_567668
proc url_ReplicationRecoveryPlansGet_569574(protocol: Scheme; host: string;
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

proc validate_ReplicationRecoveryPlansGet_569573(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the recovery plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   recoveryPlanName: JString (required)
  ##                   : Name of the recovery plan.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569575 = path.getOrDefault("resourceGroupName")
  valid_569575 = validateParameter(valid_569575, JString, required = true,
                                 default = nil)
  if valid_569575 != nil:
    section.add "resourceGroupName", valid_569575
  var valid_569576 = path.getOrDefault("subscriptionId")
  valid_569576 = validateParameter(valid_569576, JString, required = true,
                                 default = nil)
  if valid_569576 != nil:
    section.add "subscriptionId", valid_569576
  var valid_569577 = path.getOrDefault("recoveryPlanName")
  valid_569577 = validateParameter(valid_569577, JString, required = true,
                                 default = nil)
  if valid_569577 != nil:
    section.add "recoveryPlanName", valid_569577
  var valid_569578 = path.getOrDefault("resourceName")
  valid_569578 = validateParameter(valid_569578, JString, required = true,
                                 default = nil)
  if valid_569578 != nil:
    section.add "resourceName", valid_569578
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569579 = query.getOrDefault("api-version")
  valid_569579 = validateParameter(valid_569579, JString, required = true,
                                 default = nil)
  if valid_569579 != nil:
    section.add "api-version", valid_569579
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569580: Call_ReplicationRecoveryPlansGet_569572; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the recovery plan.
  ## 
  let valid = call_569580.validator(path, query, header, formData, body)
  let scheme = call_569580.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569580.url(scheme.get, call_569580.host, call_569580.base,
                         call_569580.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569580, url, valid)

proc call*(call_569581: Call_ReplicationRecoveryPlansGet_569572;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          recoveryPlanName: string; resourceName: string): Recallable =
  ## replicationRecoveryPlansGet
  ## Gets the details of the recovery plan.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   recoveryPlanName: string (required)
  ##                   : Name of the recovery plan.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_569582 = newJObject()
  var query_569583 = newJObject()
  add(path_569582, "resourceGroupName", newJString(resourceGroupName))
  add(query_569583, "api-version", newJString(apiVersion))
  add(path_569582, "subscriptionId", newJString(subscriptionId))
  add(path_569582, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_569582, "resourceName", newJString(resourceName))
  result = call_569581.call(path_569582, query_569583, nil, nil, nil)

var replicationRecoveryPlansGet* = Call_ReplicationRecoveryPlansGet_569572(
    name: "replicationRecoveryPlansGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}",
    validator: validate_ReplicationRecoveryPlansGet_569573, base: "",
    url: url_ReplicationRecoveryPlansGet_569574, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansUpdate_569610 = ref object of OpenApiRestCall_567668
proc url_ReplicationRecoveryPlansUpdate_569612(protocol: Scheme; host: string;
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

proc validate_ReplicationRecoveryPlansUpdate_569611(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update a recovery plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   recoveryPlanName: JString (required)
  ##                   : Recovery plan name.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569613 = path.getOrDefault("resourceGroupName")
  valid_569613 = validateParameter(valid_569613, JString, required = true,
                                 default = nil)
  if valid_569613 != nil:
    section.add "resourceGroupName", valid_569613
  var valid_569614 = path.getOrDefault("subscriptionId")
  valid_569614 = validateParameter(valid_569614, JString, required = true,
                                 default = nil)
  if valid_569614 != nil:
    section.add "subscriptionId", valid_569614
  var valid_569615 = path.getOrDefault("recoveryPlanName")
  valid_569615 = validateParameter(valid_569615, JString, required = true,
                                 default = nil)
  if valid_569615 != nil:
    section.add "recoveryPlanName", valid_569615
  var valid_569616 = path.getOrDefault("resourceName")
  valid_569616 = validateParameter(valid_569616, JString, required = true,
                                 default = nil)
  if valid_569616 != nil:
    section.add "resourceName", valid_569616
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569617 = query.getOrDefault("api-version")
  valid_569617 = validateParameter(valid_569617, JString, required = true,
                                 default = nil)
  if valid_569617 != nil:
    section.add "api-version", valid_569617
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

proc call*(call_569619: Call_ReplicationRecoveryPlansUpdate_569610; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a recovery plan.
  ## 
  let valid = call_569619.validator(path, query, header, formData, body)
  let scheme = call_569619.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569619.url(scheme.get, call_569619.host, call_569619.base,
                         call_569619.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569619, url, valid)

proc call*(call_569620: Call_ReplicationRecoveryPlansUpdate_569610;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          input: JsonNode; recoveryPlanName: string; resourceName: string): Recallable =
  ## replicationRecoveryPlansUpdate
  ## The operation to update a recovery plan.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   input: JObject (required)
  ##        : Update recovery plan input
  ##   recoveryPlanName: string (required)
  ##                   : Recovery plan name.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_569621 = newJObject()
  var query_569622 = newJObject()
  var body_569623 = newJObject()
  add(path_569621, "resourceGroupName", newJString(resourceGroupName))
  add(query_569622, "api-version", newJString(apiVersion))
  add(path_569621, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_569623 = input
  add(path_569621, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_569621, "resourceName", newJString(resourceName))
  result = call_569620.call(path_569621, query_569622, nil, nil, body_569623)

var replicationRecoveryPlansUpdate* = Call_ReplicationRecoveryPlansUpdate_569610(
    name: "replicationRecoveryPlansUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}",
    validator: validate_ReplicationRecoveryPlansUpdate_569611, base: "",
    url: url_ReplicationRecoveryPlansUpdate_569612, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansDelete_569598 = ref object of OpenApiRestCall_567668
proc url_ReplicationRecoveryPlansDelete_569600(protocol: Scheme; host: string;
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

proc validate_ReplicationRecoveryPlansDelete_569599(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a recovery plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   recoveryPlanName: JString (required)
  ##                   : Recovery plan name.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569601 = path.getOrDefault("resourceGroupName")
  valid_569601 = validateParameter(valid_569601, JString, required = true,
                                 default = nil)
  if valid_569601 != nil:
    section.add "resourceGroupName", valid_569601
  var valid_569602 = path.getOrDefault("subscriptionId")
  valid_569602 = validateParameter(valid_569602, JString, required = true,
                                 default = nil)
  if valid_569602 != nil:
    section.add "subscriptionId", valid_569602
  var valid_569603 = path.getOrDefault("recoveryPlanName")
  valid_569603 = validateParameter(valid_569603, JString, required = true,
                                 default = nil)
  if valid_569603 != nil:
    section.add "recoveryPlanName", valid_569603
  var valid_569604 = path.getOrDefault("resourceName")
  valid_569604 = validateParameter(valid_569604, JString, required = true,
                                 default = nil)
  if valid_569604 != nil:
    section.add "resourceName", valid_569604
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569605 = query.getOrDefault("api-version")
  valid_569605 = validateParameter(valid_569605, JString, required = true,
                                 default = nil)
  if valid_569605 != nil:
    section.add "api-version", valid_569605
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569606: Call_ReplicationRecoveryPlansDelete_569598; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a recovery plan.
  ## 
  let valid = call_569606.validator(path, query, header, formData, body)
  let scheme = call_569606.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569606.url(scheme.get, call_569606.host, call_569606.base,
                         call_569606.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569606, url, valid)

proc call*(call_569607: Call_ReplicationRecoveryPlansDelete_569598;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          recoveryPlanName: string; resourceName: string): Recallable =
  ## replicationRecoveryPlansDelete
  ## Delete a recovery plan.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   recoveryPlanName: string (required)
  ##                   : Recovery plan name.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_569608 = newJObject()
  var query_569609 = newJObject()
  add(path_569608, "resourceGroupName", newJString(resourceGroupName))
  add(query_569609, "api-version", newJString(apiVersion))
  add(path_569608, "subscriptionId", newJString(subscriptionId))
  add(path_569608, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_569608, "resourceName", newJString(resourceName))
  result = call_569607.call(path_569608, query_569609, nil, nil, nil)

var replicationRecoveryPlansDelete* = Call_ReplicationRecoveryPlansDelete_569598(
    name: "replicationRecoveryPlansDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}",
    validator: validate_ReplicationRecoveryPlansDelete_569599, base: "",
    url: url_ReplicationRecoveryPlansDelete_569600, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansFailoverCommit_569624 = ref object of OpenApiRestCall_567668
proc url_ReplicationRecoveryPlansFailoverCommit_569626(protocol: Scheme;
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

proc validate_ReplicationRecoveryPlansFailoverCommit_569625(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to commit the fail over of a recovery plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   recoveryPlanName: JString (required)
  ##                   : Recovery plan name.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569627 = path.getOrDefault("resourceGroupName")
  valid_569627 = validateParameter(valid_569627, JString, required = true,
                                 default = nil)
  if valid_569627 != nil:
    section.add "resourceGroupName", valid_569627
  var valid_569628 = path.getOrDefault("subscriptionId")
  valid_569628 = validateParameter(valid_569628, JString, required = true,
                                 default = nil)
  if valid_569628 != nil:
    section.add "subscriptionId", valid_569628
  var valid_569629 = path.getOrDefault("recoveryPlanName")
  valid_569629 = validateParameter(valid_569629, JString, required = true,
                                 default = nil)
  if valid_569629 != nil:
    section.add "recoveryPlanName", valid_569629
  var valid_569630 = path.getOrDefault("resourceName")
  valid_569630 = validateParameter(valid_569630, JString, required = true,
                                 default = nil)
  if valid_569630 != nil:
    section.add "resourceName", valid_569630
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569631 = query.getOrDefault("api-version")
  valid_569631 = validateParameter(valid_569631, JString, required = true,
                                 default = nil)
  if valid_569631 != nil:
    section.add "api-version", valid_569631
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569632: Call_ReplicationRecoveryPlansFailoverCommit_569624;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to commit the fail over of a recovery plan.
  ## 
  let valid = call_569632.validator(path, query, header, formData, body)
  let scheme = call_569632.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569632.url(scheme.get, call_569632.host, call_569632.base,
                         call_569632.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569632, url, valid)

proc call*(call_569633: Call_ReplicationRecoveryPlansFailoverCommit_569624;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          recoveryPlanName: string; resourceName: string): Recallable =
  ## replicationRecoveryPlansFailoverCommit
  ## The operation to commit the fail over of a recovery plan.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   recoveryPlanName: string (required)
  ##                   : Recovery plan name.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_569634 = newJObject()
  var query_569635 = newJObject()
  add(path_569634, "resourceGroupName", newJString(resourceGroupName))
  add(query_569635, "api-version", newJString(apiVersion))
  add(path_569634, "subscriptionId", newJString(subscriptionId))
  add(path_569634, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_569634, "resourceName", newJString(resourceName))
  result = call_569633.call(path_569634, query_569635, nil, nil, nil)

var replicationRecoveryPlansFailoverCommit* = Call_ReplicationRecoveryPlansFailoverCommit_569624(
    name: "replicationRecoveryPlansFailoverCommit", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/failoverCommit",
    validator: validate_ReplicationRecoveryPlansFailoverCommit_569625, base: "",
    url: url_ReplicationRecoveryPlansFailoverCommit_569626,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansPlannedFailover_569636 = ref object of OpenApiRestCall_567668
proc url_ReplicationRecoveryPlansPlannedFailover_569638(protocol: Scheme;
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

proc validate_ReplicationRecoveryPlansPlannedFailover_569637(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to start the planned failover of a recovery plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   recoveryPlanName: JString (required)
  ##                   : Recovery plan name.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569639 = path.getOrDefault("resourceGroupName")
  valid_569639 = validateParameter(valid_569639, JString, required = true,
                                 default = nil)
  if valid_569639 != nil:
    section.add "resourceGroupName", valid_569639
  var valid_569640 = path.getOrDefault("subscriptionId")
  valid_569640 = validateParameter(valid_569640, JString, required = true,
                                 default = nil)
  if valid_569640 != nil:
    section.add "subscriptionId", valid_569640
  var valid_569641 = path.getOrDefault("recoveryPlanName")
  valid_569641 = validateParameter(valid_569641, JString, required = true,
                                 default = nil)
  if valid_569641 != nil:
    section.add "recoveryPlanName", valid_569641
  var valid_569642 = path.getOrDefault("resourceName")
  valid_569642 = validateParameter(valid_569642, JString, required = true,
                                 default = nil)
  if valid_569642 != nil:
    section.add "resourceName", valid_569642
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569643 = query.getOrDefault("api-version")
  valid_569643 = validateParameter(valid_569643, JString, required = true,
                                 default = nil)
  if valid_569643 != nil:
    section.add "api-version", valid_569643
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

proc call*(call_569645: Call_ReplicationRecoveryPlansPlannedFailover_569636;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to start the planned failover of a recovery plan.
  ## 
  let valid = call_569645.validator(path, query, header, formData, body)
  let scheme = call_569645.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569645.url(scheme.get, call_569645.host, call_569645.base,
                         call_569645.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569645, url, valid)

proc call*(call_569646: Call_ReplicationRecoveryPlansPlannedFailover_569636;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          input: JsonNode; recoveryPlanName: string; resourceName: string): Recallable =
  ## replicationRecoveryPlansPlannedFailover
  ## The operation to start the planned failover of a recovery plan.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   input: JObject (required)
  ##        : Failover input.
  ##   recoveryPlanName: string (required)
  ##                   : Recovery plan name.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_569647 = newJObject()
  var query_569648 = newJObject()
  var body_569649 = newJObject()
  add(path_569647, "resourceGroupName", newJString(resourceGroupName))
  add(query_569648, "api-version", newJString(apiVersion))
  add(path_569647, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_569649 = input
  add(path_569647, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_569647, "resourceName", newJString(resourceName))
  result = call_569646.call(path_569647, query_569648, nil, nil, body_569649)

var replicationRecoveryPlansPlannedFailover* = Call_ReplicationRecoveryPlansPlannedFailover_569636(
    name: "replicationRecoveryPlansPlannedFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/plannedFailover",
    validator: validate_ReplicationRecoveryPlansPlannedFailover_569637, base: "",
    url: url_ReplicationRecoveryPlansPlannedFailover_569638,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansReprotect_569650 = ref object of OpenApiRestCall_567668
proc url_ReplicationRecoveryPlansReprotect_569652(protocol: Scheme; host: string;
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

proc validate_ReplicationRecoveryPlansReprotect_569651(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to reprotect(reverse replicate) a recovery plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   recoveryPlanName: JString (required)
  ##                   : Recovery plan name.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569653 = path.getOrDefault("resourceGroupName")
  valid_569653 = validateParameter(valid_569653, JString, required = true,
                                 default = nil)
  if valid_569653 != nil:
    section.add "resourceGroupName", valid_569653
  var valid_569654 = path.getOrDefault("subscriptionId")
  valid_569654 = validateParameter(valid_569654, JString, required = true,
                                 default = nil)
  if valid_569654 != nil:
    section.add "subscriptionId", valid_569654
  var valid_569655 = path.getOrDefault("recoveryPlanName")
  valid_569655 = validateParameter(valid_569655, JString, required = true,
                                 default = nil)
  if valid_569655 != nil:
    section.add "recoveryPlanName", valid_569655
  var valid_569656 = path.getOrDefault("resourceName")
  valid_569656 = validateParameter(valid_569656, JString, required = true,
                                 default = nil)
  if valid_569656 != nil:
    section.add "resourceName", valid_569656
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569657 = query.getOrDefault("api-version")
  valid_569657 = validateParameter(valid_569657, JString, required = true,
                                 default = nil)
  if valid_569657 != nil:
    section.add "api-version", valid_569657
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569658: Call_ReplicationRecoveryPlansReprotect_569650;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to reprotect(reverse replicate) a recovery plan.
  ## 
  let valid = call_569658.validator(path, query, header, formData, body)
  let scheme = call_569658.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569658.url(scheme.get, call_569658.host, call_569658.base,
                         call_569658.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569658, url, valid)

proc call*(call_569659: Call_ReplicationRecoveryPlansReprotect_569650;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          recoveryPlanName: string; resourceName: string): Recallable =
  ## replicationRecoveryPlansReprotect
  ## The operation to reprotect(reverse replicate) a recovery plan.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   recoveryPlanName: string (required)
  ##                   : Recovery plan name.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_569660 = newJObject()
  var query_569661 = newJObject()
  add(path_569660, "resourceGroupName", newJString(resourceGroupName))
  add(query_569661, "api-version", newJString(apiVersion))
  add(path_569660, "subscriptionId", newJString(subscriptionId))
  add(path_569660, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_569660, "resourceName", newJString(resourceName))
  result = call_569659.call(path_569660, query_569661, nil, nil, nil)

var replicationRecoveryPlansReprotect* = Call_ReplicationRecoveryPlansReprotect_569650(
    name: "replicationRecoveryPlansReprotect", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/reProtect",
    validator: validate_ReplicationRecoveryPlansReprotect_569651, base: "",
    url: url_ReplicationRecoveryPlansReprotect_569652, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansTestFailover_569662 = ref object of OpenApiRestCall_567668
proc url_ReplicationRecoveryPlansTestFailover_569664(protocol: Scheme;
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

proc validate_ReplicationRecoveryPlansTestFailover_569663(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to start the test failover of a recovery plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   recoveryPlanName: JString (required)
  ##                   : Recovery plan name.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569665 = path.getOrDefault("resourceGroupName")
  valid_569665 = validateParameter(valid_569665, JString, required = true,
                                 default = nil)
  if valid_569665 != nil:
    section.add "resourceGroupName", valid_569665
  var valid_569666 = path.getOrDefault("subscriptionId")
  valid_569666 = validateParameter(valid_569666, JString, required = true,
                                 default = nil)
  if valid_569666 != nil:
    section.add "subscriptionId", valid_569666
  var valid_569667 = path.getOrDefault("recoveryPlanName")
  valid_569667 = validateParameter(valid_569667, JString, required = true,
                                 default = nil)
  if valid_569667 != nil:
    section.add "recoveryPlanName", valid_569667
  var valid_569668 = path.getOrDefault("resourceName")
  valid_569668 = validateParameter(valid_569668, JString, required = true,
                                 default = nil)
  if valid_569668 != nil:
    section.add "resourceName", valid_569668
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569669 = query.getOrDefault("api-version")
  valid_569669 = validateParameter(valid_569669, JString, required = true,
                                 default = nil)
  if valid_569669 != nil:
    section.add "api-version", valid_569669
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

proc call*(call_569671: Call_ReplicationRecoveryPlansTestFailover_569662;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to start the test failover of a recovery plan.
  ## 
  let valid = call_569671.validator(path, query, header, formData, body)
  let scheme = call_569671.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569671.url(scheme.get, call_569671.host, call_569671.base,
                         call_569671.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569671, url, valid)

proc call*(call_569672: Call_ReplicationRecoveryPlansTestFailover_569662;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          input: JsonNode; recoveryPlanName: string; resourceName: string): Recallable =
  ## replicationRecoveryPlansTestFailover
  ## The operation to start the test failover of a recovery plan.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   input: JObject (required)
  ##        : Failover input.
  ##   recoveryPlanName: string (required)
  ##                   : Recovery plan name.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_569673 = newJObject()
  var query_569674 = newJObject()
  var body_569675 = newJObject()
  add(path_569673, "resourceGroupName", newJString(resourceGroupName))
  add(query_569674, "api-version", newJString(apiVersion))
  add(path_569673, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_569675 = input
  add(path_569673, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_569673, "resourceName", newJString(resourceName))
  result = call_569672.call(path_569673, query_569674, nil, nil, body_569675)

var replicationRecoveryPlansTestFailover* = Call_ReplicationRecoveryPlansTestFailover_569662(
    name: "replicationRecoveryPlansTestFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/testFailover",
    validator: validate_ReplicationRecoveryPlansTestFailover_569663, base: "",
    url: url_ReplicationRecoveryPlansTestFailover_569664, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansTestFailoverCleanup_569676 = ref object of OpenApiRestCall_567668
proc url_ReplicationRecoveryPlansTestFailoverCleanup_569678(protocol: Scheme;
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

proc validate_ReplicationRecoveryPlansTestFailoverCleanup_569677(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to cleanup test failover of a recovery plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   recoveryPlanName: JString (required)
  ##                   : Recovery plan name.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569679 = path.getOrDefault("resourceGroupName")
  valid_569679 = validateParameter(valid_569679, JString, required = true,
                                 default = nil)
  if valid_569679 != nil:
    section.add "resourceGroupName", valid_569679
  var valid_569680 = path.getOrDefault("subscriptionId")
  valid_569680 = validateParameter(valid_569680, JString, required = true,
                                 default = nil)
  if valid_569680 != nil:
    section.add "subscriptionId", valid_569680
  var valid_569681 = path.getOrDefault("recoveryPlanName")
  valid_569681 = validateParameter(valid_569681, JString, required = true,
                                 default = nil)
  if valid_569681 != nil:
    section.add "recoveryPlanName", valid_569681
  var valid_569682 = path.getOrDefault("resourceName")
  valid_569682 = validateParameter(valid_569682, JString, required = true,
                                 default = nil)
  if valid_569682 != nil:
    section.add "resourceName", valid_569682
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569683 = query.getOrDefault("api-version")
  valid_569683 = validateParameter(valid_569683, JString, required = true,
                                 default = nil)
  if valid_569683 != nil:
    section.add "api-version", valid_569683
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

proc call*(call_569685: Call_ReplicationRecoveryPlansTestFailoverCleanup_569676;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to cleanup test failover of a recovery plan.
  ## 
  let valid = call_569685.validator(path, query, header, formData, body)
  let scheme = call_569685.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569685.url(scheme.get, call_569685.host, call_569685.base,
                         call_569685.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569685, url, valid)

proc call*(call_569686: Call_ReplicationRecoveryPlansTestFailoverCleanup_569676;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          input: JsonNode; recoveryPlanName: string; resourceName: string): Recallable =
  ## replicationRecoveryPlansTestFailoverCleanup
  ## The operation to cleanup test failover of a recovery plan.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   input: JObject (required)
  ##        : Test failover cleanup input.
  ##   recoveryPlanName: string (required)
  ##                   : Recovery plan name.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_569687 = newJObject()
  var query_569688 = newJObject()
  var body_569689 = newJObject()
  add(path_569687, "resourceGroupName", newJString(resourceGroupName))
  add(query_569688, "api-version", newJString(apiVersion))
  add(path_569687, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_569689 = input
  add(path_569687, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_569687, "resourceName", newJString(resourceName))
  result = call_569686.call(path_569687, query_569688, nil, nil, body_569689)

var replicationRecoveryPlansTestFailoverCleanup* = Call_ReplicationRecoveryPlansTestFailoverCleanup_569676(
    name: "replicationRecoveryPlansTestFailoverCleanup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/testFailoverCleanup",
    validator: validate_ReplicationRecoveryPlansTestFailoverCleanup_569677,
    base: "", url: url_ReplicationRecoveryPlansTestFailoverCleanup_569678,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansUnplannedFailover_569690 = ref object of OpenApiRestCall_567668
proc url_ReplicationRecoveryPlansUnplannedFailover_569692(protocol: Scheme;
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

proc validate_ReplicationRecoveryPlansUnplannedFailover_569691(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to start the failover of a recovery plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   recoveryPlanName: JString (required)
  ##                   : Recovery plan name.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569693 = path.getOrDefault("resourceGroupName")
  valid_569693 = validateParameter(valid_569693, JString, required = true,
                                 default = nil)
  if valid_569693 != nil:
    section.add "resourceGroupName", valid_569693
  var valid_569694 = path.getOrDefault("subscriptionId")
  valid_569694 = validateParameter(valid_569694, JString, required = true,
                                 default = nil)
  if valid_569694 != nil:
    section.add "subscriptionId", valid_569694
  var valid_569695 = path.getOrDefault("recoveryPlanName")
  valid_569695 = validateParameter(valid_569695, JString, required = true,
                                 default = nil)
  if valid_569695 != nil:
    section.add "recoveryPlanName", valid_569695
  var valid_569696 = path.getOrDefault("resourceName")
  valid_569696 = validateParameter(valid_569696, JString, required = true,
                                 default = nil)
  if valid_569696 != nil:
    section.add "resourceName", valid_569696
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569697 = query.getOrDefault("api-version")
  valid_569697 = validateParameter(valid_569697, JString, required = true,
                                 default = nil)
  if valid_569697 != nil:
    section.add "api-version", valid_569697
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

proc call*(call_569699: Call_ReplicationRecoveryPlansUnplannedFailover_569690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to start the failover of a recovery plan.
  ## 
  let valid = call_569699.validator(path, query, header, formData, body)
  let scheme = call_569699.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569699.url(scheme.get, call_569699.host, call_569699.base,
                         call_569699.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569699, url, valid)

proc call*(call_569700: Call_ReplicationRecoveryPlansUnplannedFailover_569690;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          input: JsonNode; recoveryPlanName: string; resourceName: string): Recallable =
  ## replicationRecoveryPlansUnplannedFailover
  ## The operation to start the failover of a recovery plan.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   input: JObject (required)
  ##        : Failover input.
  ##   recoveryPlanName: string (required)
  ##                   : Recovery plan name.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_569701 = newJObject()
  var query_569702 = newJObject()
  var body_569703 = newJObject()
  add(path_569701, "resourceGroupName", newJString(resourceGroupName))
  add(query_569702, "api-version", newJString(apiVersion))
  add(path_569701, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_569703 = input
  add(path_569701, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_569701, "resourceName", newJString(resourceName))
  result = call_569700.call(path_569701, query_569702, nil, nil, body_569703)

var replicationRecoveryPlansUnplannedFailover* = Call_ReplicationRecoveryPlansUnplannedFailover_569690(
    name: "replicationRecoveryPlansUnplannedFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/unplannedFailover",
    validator: validate_ReplicationRecoveryPlansUnplannedFailover_569691,
    base: "", url: url_ReplicationRecoveryPlansUnplannedFailover_569692,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersList_569704 = ref object of OpenApiRestCall_567668
proc url_ReplicationRecoveryServicesProvidersList_569706(protocol: Scheme;
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

proc validate_ReplicationRecoveryServicesProvidersList_569705(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the registered recovery services providers in the vault
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569707 = path.getOrDefault("resourceGroupName")
  valid_569707 = validateParameter(valid_569707, JString, required = true,
                                 default = nil)
  if valid_569707 != nil:
    section.add "resourceGroupName", valid_569707
  var valid_569708 = path.getOrDefault("subscriptionId")
  valid_569708 = validateParameter(valid_569708, JString, required = true,
                                 default = nil)
  if valid_569708 != nil:
    section.add "subscriptionId", valid_569708
  var valid_569709 = path.getOrDefault("resourceName")
  valid_569709 = validateParameter(valid_569709, JString, required = true,
                                 default = nil)
  if valid_569709 != nil:
    section.add "resourceName", valid_569709
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569710 = query.getOrDefault("api-version")
  valid_569710 = validateParameter(valid_569710, JString, required = true,
                                 default = nil)
  if valid_569710 != nil:
    section.add "api-version", valid_569710
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569711: Call_ReplicationRecoveryServicesProvidersList_569704;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the registered recovery services providers in the vault
  ## 
  let valid = call_569711.validator(path, query, header, formData, body)
  let scheme = call_569711.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569711.url(scheme.get, call_569711.host, call_569711.base,
                         call_569711.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569711, url, valid)

proc call*(call_569712: Call_ReplicationRecoveryServicesProvidersList_569704;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationRecoveryServicesProvidersList
  ## Lists the registered recovery services providers in the vault
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_569713 = newJObject()
  var query_569714 = newJObject()
  add(path_569713, "resourceGroupName", newJString(resourceGroupName))
  add(query_569714, "api-version", newJString(apiVersion))
  add(path_569713, "subscriptionId", newJString(subscriptionId))
  add(path_569713, "resourceName", newJString(resourceName))
  result = call_569712.call(path_569713, query_569714, nil, nil, nil)

var replicationRecoveryServicesProvidersList* = Call_ReplicationRecoveryServicesProvidersList_569704(
    name: "replicationRecoveryServicesProvidersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryServicesProviders",
    validator: validate_ReplicationRecoveryServicesProvidersList_569705, base: "",
    url: url_ReplicationRecoveryServicesProvidersList_569706,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsList_569715 = ref object of OpenApiRestCall_567668
proc url_ReplicationStorageClassificationMappingsList_569717(protocol: Scheme;
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

proc validate_ReplicationStorageClassificationMappingsList_569716(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the storage classification mappings in the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569718 = path.getOrDefault("resourceGroupName")
  valid_569718 = validateParameter(valid_569718, JString, required = true,
                                 default = nil)
  if valid_569718 != nil:
    section.add "resourceGroupName", valid_569718
  var valid_569719 = path.getOrDefault("subscriptionId")
  valid_569719 = validateParameter(valid_569719, JString, required = true,
                                 default = nil)
  if valid_569719 != nil:
    section.add "subscriptionId", valid_569719
  var valid_569720 = path.getOrDefault("resourceName")
  valid_569720 = validateParameter(valid_569720, JString, required = true,
                                 default = nil)
  if valid_569720 != nil:
    section.add "resourceName", valid_569720
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569721 = query.getOrDefault("api-version")
  valid_569721 = validateParameter(valid_569721, JString, required = true,
                                 default = nil)
  if valid_569721 != nil:
    section.add "api-version", valid_569721
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569722: Call_ReplicationStorageClassificationMappingsList_569715;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the storage classification mappings in the vault.
  ## 
  let valid = call_569722.validator(path, query, header, formData, body)
  let scheme = call_569722.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569722.url(scheme.get, call_569722.host, call_569722.base,
                         call_569722.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569722, url, valid)

proc call*(call_569723: Call_ReplicationStorageClassificationMappingsList_569715;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationStorageClassificationMappingsList
  ## Lists the storage classification mappings in the vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_569724 = newJObject()
  var query_569725 = newJObject()
  add(path_569724, "resourceGroupName", newJString(resourceGroupName))
  add(query_569725, "api-version", newJString(apiVersion))
  add(path_569724, "subscriptionId", newJString(subscriptionId))
  add(path_569724, "resourceName", newJString(resourceName))
  result = call_569723.call(path_569724, query_569725, nil, nil, nil)

var replicationStorageClassificationMappingsList* = Call_ReplicationStorageClassificationMappingsList_569715(
    name: "replicationStorageClassificationMappingsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationStorageClassificationMappings",
    validator: validate_ReplicationStorageClassificationMappingsList_569716,
    base: "", url: url_ReplicationStorageClassificationMappingsList_569717,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationsList_569726 = ref object of OpenApiRestCall_567668
proc url_ReplicationStorageClassificationsList_569728(protocol: Scheme;
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

proc validate_ReplicationStorageClassificationsList_569727(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the storage classifications in the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569729 = path.getOrDefault("resourceGroupName")
  valid_569729 = validateParameter(valid_569729, JString, required = true,
                                 default = nil)
  if valid_569729 != nil:
    section.add "resourceGroupName", valid_569729
  var valid_569730 = path.getOrDefault("subscriptionId")
  valid_569730 = validateParameter(valid_569730, JString, required = true,
                                 default = nil)
  if valid_569730 != nil:
    section.add "subscriptionId", valid_569730
  var valid_569731 = path.getOrDefault("resourceName")
  valid_569731 = validateParameter(valid_569731, JString, required = true,
                                 default = nil)
  if valid_569731 != nil:
    section.add "resourceName", valid_569731
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569732 = query.getOrDefault("api-version")
  valid_569732 = validateParameter(valid_569732, JString, required = true,
                                 default = nil)
  if valid_569732 != nil:
    section.add "api-version", valid_569732
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569733: Call_ReplicationStorageClassificationsList_569726;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the storage classifications in the vault.
  ## 
  let valid = call_569733.validator(path, query, header, formData, body)
  let scheme = call_569733.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569733.url(scheme.get, call_569733.host, call_569733.base,
                         call_569733.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569733, url, valid)

proc call*(call_569734: Call_ReplicationStorageClassificationsList_569726;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationStorageClassificationsList
  ## Lists the storage classifications in the vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_569735 = newJObject()
  var query_569736 = newJObject()
  add(path_569735, "resourceGroupName", newJString(resourceGroupName))
  add(query_569736, "api-version", newJString(apiVersion))
  add(path_569735, "subscriptionId", newJString(subscriptionId))
  add(path_569735, "resourceName", newJString(resourceName))
  result = call_569734.call(path_569735, query_569736, nil, nil, nil)

var replicationStorageClassificationsList* = Call_ReplicationStorageClassificationsList_569726(
    name: "replicationStorageClassificationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationStorageClassifications",
    validator: validate_ReplicationStorageClassificationsList_569727, base: "",
    url: url_ReplicationStorageClassificationsList_569728, schemes: {Scheme.Https})
type
  Call_ReplicationVaultHealthGet_569737 = ref object of OpenApiRestCall_567668
proc url_ReplicationVaultHealthGet_569739(protocol: Scheme; host: string;
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

proc validate_ReplicationVaultHealthGet_569738(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the health details of the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569740 = path.getOrDefault("resourceGroupName")
  valid_569740 = validateParameter(valid_569740, JString, required = true,
                                 default = nil)
  if valid_569740 != nil:
    section.add "resourceGroupName", valid_569740
  var valid_569741 = path.getOrDefault("subscriptionId")
  valid_569741 = validateParameter(valid_569741, JString, required = true,
                                 default = nil)
  if valid_569741 != nil:
    section.add "subscriptionId", valid_569741
  var valid_569742 = path.getOrDefault("resourceName")
  valid_569742 = validateParameter(valid_569742, JString, required = true,
                                 default = nil)
  if valid_569742 != nil:
    section.add "resourceName", valid_569742
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569743 = query.getOrDefault("api-version")
  valid_569743 = validateParameter(valid_569743, JString, required = true,
                                 default = nil)
  if valid_569743 != nil:
    section.add "api-version", valid_569743
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569744: Call_ReplicationVaultHealthGet_569737; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health details of the vault.
  ## 
  let valid = call_569744.validator(path, query, header, formData, body)
  let scheme = call_569744.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569744.url(scheme.get, call_569744.host, call_569744.base,
                         call_569744.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569744, url, valid)

proc call*(call_569745: Call_ReplicationVaultHealthGet_569737;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationVaultHealthGet
  ## Gets the health details of the vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_569746 = newJObject()
  var query_569747 = newJObject()
  add(path_569746, "resourceGroupName", newJString(resourceGroupName))
  add(query_569747, "api-version", newJString(apiVersion))
  add(path_569746, "subscriptionId", newJString(subscriptionId))
  add(path_569746, "resourceName", newJString(resourceName))
  result = call_569745.call(path_569746, query_569747, nil, nil, nil)

var replicationVaultHealthGet* = Call_ReplicationVaultHealthGet_569737(
    name: "replicationVaultHealthGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationVaultHealth",
    validator: validate_ReplicationVaultHealthGet_569738, base: "",
    url: url_ReplicationVaultHealthGet_569739, schemes: {Scheme.Https})
type
  Call_ReplicationVaultHealthRefresh_569748 = ref object of OpenApiRestCall_567668
proc url_ReplicationVaultHealthRefresh_569750(protocol: Scheme; host: string;
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

proc validate_ReplicationVaultHealthRefresh_569749(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569751 = path.getOrDefault("resourceGroupName")
  valid_569751 = validateParameter(valid_569751, JString, required = true,
                                 default = nil)
  if valid_569751 != nil:
    section.add "resourceGroupName", valid_569751
  var valid_569752 = path.getOrDefault("subscriptionId")
  valid_569752 = validateParameter(valid_569752, JString, required = true,
                                 default = nil)
  if valid_569752 != nil:
    section.add "subscriptionId", valid_569752
  var valid_569753 = path.getOrDefault("resourceName")
  valid_569753 = validateParameter(valid_569753, JString, required = true,
                                 default = nil)
  if valid_569753 != nil:
    section.add "resourceName", valid_569753
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569754 = query.getOrDefault("api-version")
  valid_569754 = validateParameter(valid_569754, JString, required = true,
                                 default = nil)
  if valid_569754 != nil:
    section.add "api-version", valid_569754
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569755: Call_ReplicationVaultHealthRefresh_569748; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569755.validator(path, query, header, formData, body)
  let scheme = call_569755.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569755.url(scheme.get, call_569755.host, call_569755.base,
                         call_569755.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569755, url, valid)

proc call*(call_569756: Call_ReplicationVaultHealthRefresh_569748;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationVaultHealthRefresh
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_569757 = newJObject()
  var query_569758 = newJObject()
  add(path_569757, "resourceGroupName", newJString(resourceGroupName))
  add(query_569758, "api-version", newJString(apiVersion))
  add(path_569757, "subscriptionId", newJString(subscriptionId))
  add(path_569757, "resourceName", newJString(resourceName))
  result = call_569756.call(path_569757, query_569758, nil, nil, nil)

var replicationVaultHealthRefresh* = Call_ReplicationVaultHealthRefresh_569748(
    name: "replicationVaultHealthRefresh", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationVaultHealth/default/refresh",
    validator: validate_ReplicationVaultHealthRefresh_569749, base: "",
    url: url_ReplicationVaultHealthRefresh_569750, schemes: {Scheme.Https})
type
  Call_ReplicationvCentersList_569759 = ref object of OpenApiRestCall_567668
proc url_ReplicationvCentersList_569761(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationvCentersList_569760(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the vCenter servers registered in the vault.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   subscriptionId: JString (required)
  ##                 : The subscription Id.
  ##   resourceName: JString (required)
  ##               : The name of the recovery services vault.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569762 = path.getOrDefault("resourceGroupName")
  valid_569762 = validateParameter(valid_569762, JString, required = true,
                                 default = nil)
  if valid_569762 != nil:
    section.add "resourceGroupName", valid_569762
  var valid_569763 = path.getOrDefault("subscriptionId")
  valid_569763 = validateParameter(valid_569763, JString, required = true,
                                 default = nil)
  if valid_569763 != nil:
    section.add "subscriptionId", valid_569763
  var valid_569764 = path.getOrDefault("resourceName")
  valid_569764 = validateParameter(valid_569764, JString, required = true,
                                 default = nil)
  if valid_569764 != nil:
    section.add "resourceName", valid_569764
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569765 = query.getOrDefault("api-version")
  valid_569765 = validateParameter(valid_569765, JString, required = true,
                                 default = nil)
  if valid_569765 != nil:
    section.add "api-version", valid_569765
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569766: Call_ReplicationvCentersList_569759; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the vCenter servers registered in the vault.
  ## 
  let valid = call_569766.validator(path, query, header, formData, body)
  let scheme = call_569766.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569766.url(scheme.get, call_569766.host, call_569766.base,
                         call_569766.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569766, url, valid)

proc call*(call_569767: Call_ReplicationvCentersList_569759;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationvCentersList
  ## Lists the vCenter servers registered in the vault.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_569768 = newJObject()
  var query_569769 = newJObject()
  add(path_569768, "resourceGroupName", newJString(resourceGroupName))
  add(query_569769, "api-version", newJString(apiVersion))
  add(path_569768, "subscriptionId", newJString(subscriptionId))
  add(path_569768, "resourceName", newJString(resourceName))
  result = call_569767.call(path_569768, query_569769, nil, nil, nil)

var replicationvCentersList* = Call_ReplicationvCentersList_569759(
    name: "replicationvCentersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationvCenters",
    validator: validate_ReplicationvCentersList_569760, base: "",
    url: url_ReplicationvCentersList_569761, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
