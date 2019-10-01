
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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
  Call_ReplicationProtectedItemsResolveHealthErrors_568821 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectedItemsResolveHealthErrors_568823(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsResolveHealthErrors_568822(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Operation to resolve health issues of the replication protected item.
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
  ##   resolveHealthInput: JObject (required)
  ##                     : Health issue input object.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568832: Call_ReplicationProtectedItemsResolveHealthErrors_568821;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to resolve health issues of the replication protected item.
  ## 
  let valid = call_568832.validator(path, query, header, formData, body)
  let scheme = call_568832.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568832.url(scheme.get, call_568832.host, call_568832.base,
                         call_568832.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568832, url, valid)

proc call*(call_568833: Call_ReplicationProtectedItemsResolveHealthErrors_568821;
          fabricName: string; resourceGroupName: string;
          resolveHealthInput: JsonNode; apiVersion: string; subscriptionId: string;
          resourceName: string; protectionContainerName: string;
          replicatedProtectedItemName: string): Recallable =
  ## replicationProtectedItemsResolveHealthErrors
  ## Operation to resolve health issues of the replication protected item.
  ##   fabricName: string (required)
  ##             : Unique fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   resolveHealthInput: JObject (required)
  ##                     : Health issue input object.
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
  var path_568834 = newJObject()
  var query_568835 = newJObject()
  var body_568836 = newJObject()
  add(path_568834, "fabricName", newJString(fabricName))
  add(path_568834, "resourceGroupName", newJString(resourceGroupName))
  if resolveHealthInput != nil:
    body_568836 = resolveHealthInput
  add(query_568835, "api-version", newJString(apiVersion))
  add(path_568834, "subscriptionId", newJString(subscriptionId))
  add(path_568834, "resourceName", newJString(resourceName))
  add(path_568834, "protectionContainerName", newJString(protectionContainerName))
  add(path_568834, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568833.call(path_568834, query_568835, nil, nil, body_568836)

var replicationProtectedItemsResolveHealthErrors* = Call_ReplicationProtectedItemsResolveHealthErrors_568821(
    name: "replicationProtectedItemsResolveHealthErrors",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/ResolveHealthErrors",
    validator: validate_ReplicationProtectedItemsResolveHealthErrors_568822,
    base: "", url: url_ReplicationProtectedItemsResolveHealthErrors_568823,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsAddDisks_568837 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectedItemsAddDisks_568839(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectedItemsAddDisks_568838(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Operation to add disks(s) to the replication protected item.
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
  ## parameters in `body` object:
  ##   addDisksInput: JObject (required)
  ##                : Add disks input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568848: Call_ReplicationProtectedItemsAddDisks_568837;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to add disks(s) to the replication protected item.
  ## 
  let valid = call_568848.validator(path, query, header, formData, body)
  let scheme = call_568848.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568848.url(scheme.get, call_568848.host, call_568848.base,
                         call_568848.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568848, url, valid)

proc call*(call_568849: Call_ReplicationProtectedItemsAddDisks_568837;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          addDisksInput: JsonNode; subscriptionId: string; resourceName: string;
          protectionContainerName: string; replicatedProtectedItemName: string): Recallable =
  ## replicationProtectedItemsAddDisks
  ## Operation to add disks(s) to the replication protected item.
  ##   fabricName: string (required)
  ##             : Unique fabric name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   addDisksInput: JObject (required)
  ##                : Add disks input.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   protectionContainerName: string (required)
  ##                          : Protection container name.
  ##   replicatedProtectedItemName: string (required)
  ##                              : Replication protected item name.
  var path_568850 = newJObject()
  var query_568851 = newJObject()
  var body_568852 = newJObject()
  add(path_568850, "fabricName", newJString(fabricName))
  add(path_568850, "resourceGroupName", newJString(resourceGroupName))
  add(query_568851, "api-version", newJString(apiVersion))
  if addDisksInput != nil:
    body_568852 = addDisksInput
  add(path_568850, "subscriptionId", newJString(subscriptionId))
  add(path_568850, "resourceName", newJString(resourceName))
  add(path_568850, "protectionContainerName", newJString(protectionContainerName))
  add(path_568850, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568849.call(path_568850, query_568851, nil, nil, body_568852)

var replicationProtectedItemsAddDisks* = Call_ReplicationProtectedItemsAddDisks_568837(
    name: "replicationProtectedItemsAddDisks", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/addDisks",
    validator: validate_ReplicationProtectedItemsAddDisks_568838, base: "",
    url: url_ReplicationProtectedItemsAddDisks_568839, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsApplyRecoveryPoint_568853 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectedItemsApplyRecoveryPoint_568855(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsApplyRecoveryPoint_568854(path: JsonNode;
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
  var valid_568856 = path.getOrDefault("fabricName")
  valid_568856 = validateParameter(valid_568856, JString, required = true,
                                 default = nil)
  if valid_568856 != nil:
    section.add "fabricName", valid_568856
  var valid_568857 = path.getOrDefault("resourceGroupName")
  valid_568857 = validateParameter(valid_568857, JString, required = true,
                                 default = nil)
  if valid_568857 != nil:
    section.add "resourceGroupName", valid_568857
  var valid_568858 = path.getOrDefault("subscriptionId")
  valid_568858 = validateParameter(valid_568858, JString, required = true,
                                 default = nil)
  if valid_568858 != nil:
    section.add "subscriptionId", valid_568858
  var valid_568859 = path.getOrDefault("resourceName")
  valid_568859 = validateParameter(valid_568859, JString, required = true,
                                 default = nil)
  if valid_568859 != nil:
    section.add "resourceName", valid_568859
  var valid_568860 = path.getOrDefault("protectionContainerName")
  valid_568860 = validateParameter(valid_568860, JString, required = true,
                                 default = nil)
  if valid_568860 != nil:
    section.add "protectionContainerName", valid_568860
  var valid_568861 = path.getOrDefault("replicatedProtectedItemName")
  valid_568861 = validateParameter(valid_568861, JString, required = true,
                                 default = nil)
  if valid_568861 != nil:
    section.add "replicatedProtectedItemName", valid_568861
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568862 = query.getOrDefault("api-version")
  valid_568862 = validateParameter(valid_568862, JString, required = true,
                                 default = nil)
  if valid_568862 != nil:
    section.add "api-version", valid_568862
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

proc call*(call_568864: Call_ReplicationProtectedItemsApplyRecoveryPoint_568853;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to change the recovery point of a failed over replication protected item.
  ## 
  let valid = call_568864.validator(path, query, header, formData, body)
  let scheme = call_568864.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568864.url(scheme.get, call_568864.host, call_568864.base,
                         call_568864.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568864, url, valid)

proc call*(call_568865: Call_ReplicationProtectedItemsApplyRecoveryPoint_568853;
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
  var path_568866 = newJObject()
  var query_568867 = newJObject()
  var body_568868 = newJObject()
  add(path_568866, "fabricName", newJString(fabricName))
  add(path_568866, "resourceGroupName", newJString(resourceGroupName))
  add(query_568867, "api-version", newJString(apiVersion))
  if applyRecoveryPointInput != nil:
    body_568868 = applyRecoveryPointInput
  add(path_568866, "subscriptionId", newJString(subscriptionId))
  add(path_568866, "resourceName", newJString(resourceName))
  add(path_568866, "protectionContainerName", newJString(protectionContainerName))
  add(path_568866, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568865.call(path_568866, query_568867, nil, nil, body_568868)

var replicationProtectedItemsApplyRecoveryPoint* = Call_ReplicationProtectedItemsApplyRecoveryPoint_568853(
    name: "replicationProtectedItemsApplyRecoveryPoint",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/applyRecoveryPoint",
    validator: validate_ReplicationProtectedItemsApplyRecoveryPoint_568854,
    base: "", url: url_ReplicationProtectedItemsApplyRecoveryPoint_568855,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsFailoverCommit_568869 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectedItemsFailoverCommit_568871(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsFailoverCommit_568870(path: JsonNode;
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
  var valid_568872 = path.getOrDefault("fabricName")
  valid_568872 = validateParameter(valid_568872, JString, required = true,
                                 default = nil)
  if valid_568872 != nil:
    section.add "fabricName", valid_568872
  var valid_568873 = path.getOrDefault("resourceGroupName")
  valid_568873 = validateParameter(valid_568873, JString, required = true,
                                 default = nil)
  if valid_568873 != nil:
    section.add "resourceGroupName", valid_568873
  var valid_568874 = path.getOrDefault("subscriptionId")
  valid_568874 = validateParameter(valid_568874, JString, required = true,
                                 default = nil)
  if valid_568874 != nil:
    section.add "subscriptionId", valid_568874
  var valid_568875 = path.getOrDefault("resourceName")
  valid_568875 = validateParameter(valid_568875, JString, required = true,
                                 default = nil)
  if valid_568875 != nil:
    section.add "resourceName", valid_568875
  var valid_568876 = path.getOrDefault("protectionContainerName")
  valid_568876 = validateParameter(valid_568876, JString, required = true,
                                 default = nil)
  if valid_568876 != nil:
    section.add "protectionContainerName", valid_568876
  var valid_568877 = path.getOrDefault("replicatedProtectedItemName")
  valid_568877 = validateParameter(valid_568877, JString, required = true,
                                 default = nil)
  if valid_568877 != nil:
    section.add "replicatedProtectedItemName", valid_568877
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568878 = query.getOrDefault("api-version")
  valid_568878 = validateParameter(valid_568878, JString, required = true,
                                 default = nil)
  if valid_568878 != nil:
    section.add "api-version", valid_568878
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568879: Call_ReplicationProtectedItemsFailoverCommit_568869;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to commit the failover of the replication protected item.
  ## 
  let valid = call_568879.validator(path, query, header, formData, body)
  let scheme = call_568879.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568879.url(scheme.get, call_568879.host, call_568879.base,
                         call_568879.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568879, url, valid)

proc call*(call_568880: Call_ReplicationProtectedItemsFailoverCommit_568869;
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
  var path_568881 = newJObject()
  var query_568882 = newJObject()
  add(path_568881, "fabricName", newJString(fabricName))
  add(path_568881, "resourceGroupName", newJString(resourceGroupName))
  add(query_568882, "api-version", newJString(apiVersion))
  add(path_568881, "subscriptionId", newJString(subscriptionId))
  add(path_568881, "resourceName", newJString(resourceName))
  add(path_568881, "protectionContainerName", newJString(protectionContainerName))
  add(path_568881, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568880.call(path_568881, query_568882, nil, nil, nil)

var replicationProtectedItemsFailoverCommit* = Call_ReplicationProtectedItemsFailoverCommit_568869(
    name: "replicationProtectedItemsFailoverCommit", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/failoverCommit",
    validator: validate_ReplicationProtectedItemsFailoverCommit_568870, base: "",
    url: url_ReplicationProtectedItemsFailoverCommit_568871,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsPlannedFailover_568883 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectedItemsPlannedFailover_568885(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsPlannedFailover_568884(path: JsonNode;
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
  ## parameters in `body` object:
  ##   failoverInput: JObject (required)
  ##                : Disable protection input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568894: Call_ReplicationProtectedItemsPlannedFailover_568883;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to initiate a planned failover of the replication protected item.
  ## 
  let valid = call_568894.validator(path, query, header, formData, body)
  let scheme = call_568894.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568894.url(scheme.get, call_568894.host, call_568894.base,
                         call_568894.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568894, url, valid)

proc call*(call_568895: Call_ReplicationProtectedItemsPlannedFailover_568883;
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
  var path_568896 = newJObject()
  var query_568897 = newJObject()
  var body_568898 = newJObject()
  add(path_568896, "fabricName", newJString(fabricName))
  add(path_568896, "resourceGroupName", newJString(resourceGroupName))
  add(query_568897, "api-version", newJString(apiVersion))
  add(path_568896, "subscriptionId", newJString(subscriptionId))
  add(path_568896, "resourceName", newJString(resourceName))
  add(path_568896, "protectionContainerName", newJString(protectionContainerName))
  if failoverInput != nil:
    body_568898 = failoverInput
  add(path_568896, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568895.call(path_568896, query_568897, nil, nil, body_568898)

var replicationProtectedItemsPlannedFailover* = Call_ReplicationProtectedItemsPlannedFailover_568883(
    name: "replicationProtectedItemsPlannedFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/plannedFailover",
    validator: validate_ReplicationProtectedItemsPlannedFailover_568884, base: "",
    url: url_ReplicationProtectedItemsPlannedFailover_568885,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsReprotect_568899 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectedItemsReprotect_568901(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectedItemsReprotect_568900(path: JsonNode;
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
  var valid_568902 = path.getOrDefault("fabricName")
  valid_568902 = validateParameter(valid_568902, JString, required = true,
                                 default = nil)
  if valid_568902 != nil:
    section.add "fabricName", valid_568902
  var valid_568903 = path.getOrDefault("resourceGroupName")
  valid_568903 = validateParameter(valid_568903, JString, required = true,
                                 default = nil)
  if valid_568903 != nil:
    section.add "resourceGroupName", valid_568903
  var valid_568904 = path.getOrDefault("subscriptionId")
  valid_568904 = validateParameter(valid_568904, JString, required = true,
                                 default = nil)
  if valid_568904 != nil:
    section.add "subscriptionId", valid_568904
  var valid_568905 = path.getOrDefault("resourceName")
  valid_568905 = validateParameter(valid_568905, JString, required = true,
                                 default = nil)
  if valid_568905 != nil:
    section.add "resourceName", valid_568905
  var valid_568906 = path.getOrDefault("protectionContainerName")
  valid_568906 = validateParameter(valid_568906, JString, required = true,
                                 default = nil)
  if valid_568906 != nil:
    section.add "protectionContainerName", valid_568906
  var valid_568907 = path.getOrDefault("replicatedProtectedItemName")
  valid_568907 = validateParameter(valid_568907, JString, required = true,
                                 default = nil)
  if valid_568907 != nil:
    section.add "replicatedProtectedItemName", valid_568907
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568908 = query.getOrDefault("api-version")
  valid_568908 = validateParameter(valid_568908, JString, required = true,
                                 default = nil)
  if valid_568908 != nil:
    section.add "api-version", valid_568908
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

proc call*(call_568910: Call_ReplicationProtectedItemsReprotect_568899;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to reprotect or reverse replicate a failed over replication protected item.
  ## 
  let valid = call_568910.validator(path, query, header, formData, body)
  let scheme = call_568910.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568910.url(scheme.get, call_568910.host, call_568910.base,
                         call_568910.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568910, url, valid)

proc call*(call_568911: Call_ReplicationProtectedItemsReprotect_568899;
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
  var path_568912 = newJObject()
  var query_568913 = newJObject()
  var body_568914 = newJObject()
  add(path_568912, "fabricName", newJString(fabricName))
  add(path_568912, "resourceGroupName", newJString(resourceGroupName))
  add(query_568913, "api-version", newJString(apiVersion))
  add(path_568912, "subscriptionId", newJString(subscriptionId))
  add(path_568912, "resourceName", newJString(resourceName))
  add(path_568912, "protectionContainerName", newJString(protectionContainerName))
  if rrInput != nil:
    body_568914 = rrInput
  add(path_568912, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568911.call(path_568912, query_568913, nil, nil, body_568914)

var replicationProtectedItemsReprotect* = Call_ReplicationProtectedItemsReprotect_568899(
    name: "replicationProtectedItemsReprotect", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/reProtect",
    validator: validate_ReplicationProtectedItemsReprotect_568900, base: "",
    url: url_ReplicationProtectedItemsReprotect_568901, schemes: {Scheme.Https})
type
  Call_RecoveryPointsListByReplicationProtectedItems_568915 = ref object of OpenApiRestCall_567668
proc url_RecoveryPointsListByReplicationProtectedItems_568917(protocol: Scheme;
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

proc validate_RecoveryPointsListByReplicationProtectedItems_568916(
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
  var valid_568918 = path.getOrDefault("fabricName")
  valid_568918 = validateParameter(valid_568918, JString, required = true,
                                 default = nil)
  if valid_568918 != nil:
    section.add "fabricName", valid_568918
  var valid_568919 = path.getOrDefault("resourceGroupName")
  valid_568919 = validateParameter(valid_568919, JString, required = true,
                                 default = nil)
  if valid_568919 != nil:
    section.add "resourceGroupName", valid_568919
  var valid_568920 = path.getOrDefault("subscriptionId")
  valid_568920 = validateParameter(valid_568920, JString, required = true,
                                 default = nil)
  if valid_568920 != nil:
    section.add "subscriptionId", valid_568920
  var valid_568921 = path.getOrDefault("resourceName")
  valid_568921 = validateParameter(valid_568921, JString, required = true,
                                 default = nil)
  if valid_568921 != nil:
    section.add "resourceName", valid_568921
  var valid_568922 = path.getOrDefault("protectionContainerName")
  valid_568922 = validateParameter(valid_568922, JString, required = true,
                                 default = nil)
  if valid_568922 != nil:
    section.add "protectionContainerName", valid_568922
  var valid_568923 = path.getOrDefault("replicatedProtectedItemName")
  valid_568923 = validateParameter(valid_568923, JString, required = true,
                                 default = nil)
  if valid_568923 != nil:
    section.add "replicatedProtectedItemName", valid_568923
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568924 = query.getOrDefault("api-version")
  valid_568924 = validateParameter(valid_568924, JString, required = true,
                                 default = nil)
  if valid_568924 != nil:
    section.add "api-version", valid_568924
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568925: Call_RecoveryPointsListByReplicationProtectedItems_568915;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the available recovery points for a replication protected item.
  ## 
  let valid = call_568925.validator(path, query, header, formData, body)
  let scheme = call_568925.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568925.url(scheme.get, call_568925.host, call_568925.base,
                         call_568925.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568925, url, valid)

proc call*(call_568926: Call_RecoveryPointsListByReplicationProtectedItems_568915;
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
  var path_568927 = newJObject()
  var query_568928 = newJObject()
  add(path_568927, "fabricName", newJString(fabricName))
  add(path_568927, "resourceGroupName", newJString(resourceGroupName))
  add(query_568928, "api-version", newJString(apiVersion))
  add(path_568927, "subscriptionId", newJString(subscriptionId))
  add(path_568927, "resourceName", newJString(resourceName))
  add(path_568927, "protectionContainerName", newJString(protectionContainerName))
  add(path_568927, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568926.call(path_568927, query_568928, nil, nil, nil)

var recoveryPointsListByReplicationProtectedItems* = Call_RecoveryPointsListByReplicationProtectedItems_568915(
    name: "recoveryPointsListByReplicationProtectedItems",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/recoveryPoints",
    validator: validate_RecoveryPointsListByReplicationProtectedItems_568916,
    base: "", url: url_RecoveryPointsListByReplicationProtectedItems_568917,
    schemes: {Scheme.Https})
type
  Call_RecoveryPointsGet_568929 = ref object of OpenApiRestCall_567668
proc url_RecoveryPointsGet_568931(protocol: Scheme; host: string; base: string;
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

proc validate_RecoveryPointsGet_568930(path: JsonNode; query: JsonNode;
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
  var valid_568932 = path.getOrDefault("fabricName")
  valid_568932 = validateParameter(valid_568932, JString, required = true,
                                 default = nil)
  if valid_568932 != nil:
    section.add "fabricName", valid_568932
  var valid_568933 = path.getOrDefault("resourceGroupName")
  valid_568933 = validateParameter(valid_568933, JString, required = true,
                                 default = nil)
  if valid_568933 != nil:
    section.add "resourceGroupName", valid_568933
  var valid_568934 = path.getOrDefault("subscriptionId")
  valid_568934 = validateParameter(valid_568934, JString, required = true,
                                 default = nil)
  if valid_568934 != nil:
    section.add "subscriptionId", valid_568934
  var valid_568935 = path.getOrDefault("resourceName")
  valid_568935 = validateParameter(valid_568935, JString, required = true,
                                 default = nil)
  if valid_568935 != nil:
    section.add "resourceName", valid_568935
  var valid_568936 = path.getOrDefault("recoveryPointName")
  valid_568936 = validateParameter(valid_568936, JString, required = true,
                                 default = nil)
  if valid_568936 != nil:
    section.add "recoveryPointName", valid_568936
  var valid_568937 = path.getOrDefault("protectionContainerName")
  valid_568937 = validateParameter(valid_568937, JString, required = true,
                                 default = nil)
  if valid_568937 != nil:
    section.add "protectionContainerName", valid_568937
  var valid_568938 = path.getOrDefault("replicatedProtectedItemName")
  valid_568938 = validateParameter(valid_568938, JString, required = true,
                                 default = nil)
  if valid_568938 != nil:
    section.add "replicatedProtectedItemName", valid_568938
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568939 = query.getOrDefault("api-version")
  valid_568939 = validateParameter(valid_568939, JString, required = true,
                                 default = nil)
  if valid_568939 != nil:
    section.add "api-version", valid_568939
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568940: Call_RecoveryPointsGet_568929; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the details of specified recovery point.
  ## 
  let valid = call_568940.validator(path, query, header, formData, body)
  let scheme = call_568940.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568940.url(scheme.get, call_568940.host, call_568940.base,
                         call_568940.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568940, url, valid)

proc call*(call_568941: Call_RecoveryPointsGet_568929; fabricName: string;
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
  var path_568942 = newJObject()
  var query_568943 = newJObject()
  add(path_568942, "fabricName", newJString(fabricName))
  add(path_568942, "resourceGroupName", newJString(resourceGroupName))
  add(query_568943, "api-version", newJString(apiVersion))
  add(path_568942, "subscriptionId", newJString(subscriptionId))
  add(path_568942, "resourceName", newJString(resourceName))
  add(path_568942, "recoveryPointName", newJString(recoveryPointName))
  add(path_568942, "protectionContainerName", newJString(protectionContainerName))
  add(path_568942, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568941.call(path_568942, query_568943, nil, nil, nil)

var recoveryPointsGet* = Call_RecoveryPointsGet_568929(name: "recoveryPointsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/recoveryPoints/{recoveryPointName}",
    validator: validate_RecoveryPointsGet_568930, base: "",
    url: url_RecoveryPointsGet_568931, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsDelete_568944 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectedItemsDelete_568946(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectedItemsDelete_568945(path: JsonNode;
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
  var valid_568947 = path.getOrDefault("fabricName")
  valid_568947 = validateParameter(valid_568947, JString, required = true,
                                 default = nil)
  if valid_568947 != nil:
    section.add "fabricName", valid_568947
  var valid_568948 = path.getOrDefault("resourceGroupName")
  valid_568948 = validateParameter(valid_568948, JString, required = true,
                                 default = nil)
  if valid_568948 != nil:
    section.add "resourceGroupName", valid_568948
  var valid_568949 = path.getOrDefault("subscriptionId")
  valid_568949 = validateParameter(valid_568949, JString, required = true,
                                 default = nil)
  if valid_568949 != nil:
    section.add "subscriptionId", valid_568949
  var valid_568950 = path.getOrDefault("resourceName")
  valid_568950 = validateParameter(valid_568950, JString, required = true,
                                 default = nil)
  if valid_568950 != nil:
    section.add "resourceName", valid_568950
  var valid_568951 = path.getOrDefault("protectionContainerName")
  valid_568951 = validateParameter(valid_568951, JString, required = true,
                                 default = nil)
  if valid_568951 != nil:
    section.add "protectionContainerName", valid_568951
  var valid_568952 = path.getOrDefault("replicatedProtectedItemName")
  valid_568952 = validateParameter(valid_568952, JString, required = true,
                                 default = nil)
  if valid_568952 != nil:
    section.add "replicatedProtectedItemName", valid_568952
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568953 = query.getOrDefault("api-version")
  valid_568953 = validateParameter(valid_568953, JString, required = true,
                                 default = nil)
  if valid_568953 != nil:
    section.add "api-version", valid_568953
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

proc call*(call_568955: Call_ReplicationProtectedItemsDelete_568944;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to disable replication on a replication protected item. This will also remove the item.
  ## 
  let valid = call_568955.validator(path, query, header, formData, body)
  let scheme = call_568955.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568955.url(scheme.get, call_568955.host, call_568955.base,
                         call_568955.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568955, url, valid)

proc call*(call_568956: Call_ReplicationProtectedItemsDelete_568944;
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
  var path_568957 = newJObject()
  var query_568958 = newJObject()
  var body_568959 = newJObject()
  add(path_568957, "fabricName", newJString(fabricName))
  add(path_568957, "resourceGroupName", newJString(resourceGroupName))
  add(query_568958, "api-version", newJString(apiVersion))
  add(path_568957, "subscriptionId", newJString(subscriptionId))
  add(path_568957, "resourceName", newJString(resourceName))
  add(path_568957, "protectionContainerName", newJString(protectionContainerName))
  if disableProtectionInput != nil:
    body_568959 = disableProtectionInput
  add(path_568957, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568956.call(path_568957, query_568958, nil, nil, body_568959)

var replicationProtectedItemsDelete* = Call_ReplicationProtectedItemsDelete_568944(
    name: "replicationProtectedItemsDelete", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/remove",
    validator: validate_ReplicationProtectedItemsDelete_568945, base: "",
    url: url_ReplicationProtectedItemsDelete_568946, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsRemoveDisks_568960 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectedItemsRemoveDisks_568962(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsRemoveDisks_568961(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Operation to remove disk(s) from the replication protected item.
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
  var valid_568963 = path.getOrDefault("fabricName")
  valid_568963 = validateParameter(valid_568963, JString, required = true,
                                 default = nil)
  if valid_568963 != nil:
    section.add "fabricName", valid_568963
  var valid_568964 = path.getOrDefault("resourceGroupName")
  valid_568964 = validateParameter(valid_568964, JString, required = true,
                                 default = nil)
  if valid_568964 != nil:
    section.add "resourceGroupName", valid_568964
  var valid_568965 = path.getOrDefault("subscriptionId")
  valid_568965 = validateParameter(valid_568965, JString, required = true,
                                 default = nil)
  if valid_568965 != nil:
    section.add "subscriptionId", valid_568965
  var valid_568966 = path.getOrDefault("resourceName")
  valid_568966 = validateParameter(valid_568966, JString, required = true,
                                 default = nil)
  if valid_568966 != nil:
    section.add "resourceName", valid_568966
  var valid_568967 = path.getOrDefault("protectionContainerName")
  valid_568967 = validateParameter(valid_568967, JString, required = true,
                                 default = nil)
  if valid_568967 != nil:
    section.add "protectionContainerName", valid_568967
  var valid_568968 = path.getOrDefault("replicatedProtectedItemName")
  valid_568968 = validateParameter(valid_568968, JString, required = true,
                                 default = nil)
  if valid_568968 != nil:
    section.add "replicatedProtectedItemName", valid_568968
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568969 = query.getOrDefault("api-version")
  valid_568969 = validateParameter(valid_568969, JString, required = true,
                                 default = nil)
  if valid_568969 != nil:
    section.add "api-version", valid_568969
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

proc call*(call_568971: Call_ReplicationProtectedItemsRemoveDisks_568960;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to remove disk(s) from the replication protected item.
  ## 
  let valid = call_568971.validator(path, query, header, formData, body)
  let scheme = call_568971.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568971.url(scheme.get, call_568971.host, call_568971.base,
                         call_568971.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568971, url, valid)

proc call*(call_568972: Call_ReplicationProtectedItemsRemoveDisks_568960;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string; removeDisksInput: JsonNode;
          replicatedProtectedItemName: string): Recallable =
  ## replicationProtectedItemsRemoveDisks
  ## Operation to remove disk(s) from the replication protected item.
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
  ##   removeDisksInput: JObject (required)
  ##                   : Remove disks input.
  ##   replicatedProtectedItemName: string (required)
  ##                              : Replication protected item name.
  var path_568973 = newJObject()
  var query_568974 = newJObject()
  var body_568975 = newJObject()
  add(path_568973, "fabricName", newJString(fabricName))
  add(path_568973, "resourceGroupName", newJString(resourceGroupName))
  add(query_568974, "api-version", newJString(apiVersion))
  add(path_568973, "subscriptionId", newJString(subscriptionId))
  add(path_568973, "resourceName", newJString(resourceName))
  add(path_568973, "protectionContainerName", newJString(protectionContainerName))
  if removeDisksInput != nil:
    body_568975 = removeDisksInput
  add(path_568973, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568972.call(path_568973, query_568974, nil, nil, body_568975)

var replicationProtectedItemsRemoveDisks* = Call_ReplicationProtectedItemsRemoveDisks_568960(
    name: "replicationProtectedItemsRemoveDisks", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/removeDisks",
    validator: validate_ReplicationProtectedItemsRemoveDisks_568961, base: "",
    url: url_ReplicationProtectedItemsRemoveDisks_568962, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsRepairReplication_568976 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectedItemsRepairReplication_568978(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsRepairReplication_568977(path: JsonNode;
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
  var valid_568979 = path.getOrDefault("fabricName")
  valid_568979 = validateParameter(valid_568979, JString, required = true,
                                 default = nil)
  if valid_568979 != nil:
    section.add "fabricName", valid_568979
  var valid_568980 = path.getOrDefault("resourceGroupName")
  valid_568980 = validateParameter(valid_568980, JString, required = true,
                                 default = nil)
  if valid_568980 != nil:
    section.add "resourceGroupName", valid_568980
  var valid_568981 = path.getOrDefault("subscriptionId")
  valid_568981 = validateParameter(valid_568981, JString, required = true,
                                 default = nil)
  if valid_568981 != nil:
    section.add "subscriptionId", valid_568981
  var valid_568982 = path.getOrDefault("resourceName")
  valid_568982 = validateParameter(valid_568982, JString, required = true,
                                 default = nil)
  if valid_568982 != nil:
    section.add "resourceName", valid_568982
  var valid_568983 = path.getOrDefault("protectionContainerName")
  valid_568983 = validateParameter(valid_568983, JString, required = true,
                                 default = nil)
  if valid_568983 != nil:
    section.add "protectionContainerName", valid_568983
  var valid_568984 = path.getOrDefault("replicatedProtectedItemName")
  valid_568984 = validateParameter(valid_568984, JString, required = true,
                                 default = nil)
  if valid_568984 != nil:
    section.add "replicatedProtectedItemName", valid_568984
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568985 = query.getOrDefault("api-version")
  valid_568985 = validateParameter(valid_568985, JString, required = true,
                                 default = nil)
  if valid_568985 != nil:
    section.add "api-version", valid_568985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568986: Call_ReplicationProtectedItemsRepairReplication_568976;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to start resynchronize/repair replication for a replication protected item requiring resynchronization.
  ## 
  let valid = call_568986.validator(path, query, header, formData, body)
  let scheme = call_568986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568986.url(scheme.get, call_568986.host, call_568986.base,
                         call_568986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568986, url, valid)

proc call*(call_568987: Call_ReplicationProtectedItemsRepairReplication_568976;
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
  var path_568988 = newJObject()
  var query_568989 = newJObject()
  add(path_568988, "fabricName", newJString(fabricName))
  add(path_568988, "resourceGroupName", newJString(resourceGroupName))
  add(query_568989, "api-version", newJString(apiVersion))
  add(path_568988, "subscriptionId", newJString(subscriptionId))
  add(path_568988, "resourceName", newJString(resourceName))
  add(path_568988, "protectionContainerName", newJString(protectionContainerName))
  add(path_568988, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568987.call(path_568988, query_568989, nil, nil, nil)

var replicationProtectedItemsRepairReplication* = Call_ReplicationProtectedItemsRepairReplication_568976(
    name: "replicationProtectedItemsRepairReplication", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/repairReplication",
    validator: validate_ReplicationProtectedItemsRepairReplication_568977,
    base: "", url: url_ReplicationProtectedItemsRepairReplication_568978,
    schemes: {Scheme.Https})
type
  Call_TargetComputeSizesListByReplicationProtectedItems_568990 = ref object of OpenApiRestCall_567668
proc url_TargetComputeSizesListByReplicationProtectedItems_568992(
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

proc validate_TargetComputeSizesListByReplicationProtectedItems_568991(
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
  var valid_568993 = path.getOrDefault("fabricName")
  valid_568993 = validateParameter(valid_568993, JString, required = true,
                                 default = nil)
  if valid_568993 != nil:
    section.add "fabricName", valid_568993
  var valid_568994 = path.getOrDefault("resourceGroupName")
  valid_568994 = validateParameter(valid_568994, JString, required = true,
                                 default = nil)
  if valid_568994 != nil:
    section.add "resourceGroupName", valid_568994
  var valid_568995 = path.getOrDefault("subscriptionId")
  valid_568995 = validateParameter(valid_568995, JString, required = true,
                                 default = nil)
  if valid_568995 != nil:
    section.add "subscriptionId", valid_568995
  var valid_568996 = path.getOrDefault("resourceName")
  valid_568996 = validateParameter(valid_568996, JString, required = true,
                                 default = nil)
  if valid_568996 != nil:
    section.add "resourceName", valid_568996
  var valid_568997 = path.getOrDefault("protectionContainerName")
  valid_568997 = validateParameter(valid_568997, JString, required = true,
                                 default = nil)
  if valid_568997 != nil:
    section.add "protectionContainerName", valid_568997
  var valid_568998 = path.getOrDefault("replicatedProtectedItemName")
  valid_568998 = validateParameter(valid_568998, JString, required = true,
                                 default = nil)
  if valid_568998 != nil:
    section.add "replicatedProtectedItemName", valid_568998
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568999 = query.getOrDefault("api-version")
  valid_568999 = validateParameter(valid_568999, JString, required = true,
                                 default = nil)
  if valid_568999 != nil:
    section.add "api-version", valid_568999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569000: Call_TargetComputeSizesListByReplicationProtectedItems_568990;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the available target compute sizes for a replication protected item.
  ## 
  let valid = call_569000.validator(path, query, header, formData, body)
  let scheme = call_569000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569000.url(scheme.get, call_569000.host, call_569000.base,
                         call_569000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569000, url, valid)

proc call*(call_569001: Call_TargetComputeSizesListByReplicationProtectedItems_568990;
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
  var path_569002 = newJObject()
  var query_569003 = newJObject()
  add(path_569002, "fabricName", newJString(fabricName))
  add(path_569002, "resourceGroupName", newJString(resourceGroupName))
  add(query_569003, "api-version", newJString(apiVersion))
  add(path_569002, "subscriptionId", newJString(subscriptionId))
  add(path_569002, "resourceName", newJString(resourceName))
  add(path_569002, "protectionContainerName", newJString(protectionContainerName))
  add(path_569002, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_569001.call(path_569002, query_569003, nil, nil, nil)

var targetComputeSizesListByReplicationProtectedItems* = Call_TargetComputeSizesListByReplicationProtectedItems_568990(
    name: "targetComputeSizesListByReplicationProtectedItems",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/targetComputeSizes",
    validator: validate_TargetComputeSizesListByReplicationProtectedItems_568991,
    base: "", url: url_TargetComputeSizesListByReplicationProtectedItems_568992,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsTestFailover_569004 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectedItemsTestFailover_569006(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsTestFailover_569005(path: JsonNode;
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
  var valid_569012 = path.getOrDefault("replicatedProtectedItemName")
  valid_569012 = validateParameter(valid_569012, JString, required = true,
                                 default = nil)
  if valid_569012 != nil:
    section.add "replicatedProtectedItemName", valid_569012
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
  ##   failoverInput: JObject (required)
  ##                : Test failover input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569015: Call_ReplicationProtectedItemsTestFailover_569004;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to perform a test failover of the replication protected item.
  ## 
  let valid = call_569015.validator(path, query, header, formData, body)
  let scheme = call_569015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569015.url(scheme.get, call_569015.host, call_569015.base,
                         call_569015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569015, url, valid)

proc call*(call_569016: Call_ReplicationProtectedItemsTestFailover_569004;
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
  var path_569017 = newJObject()
  var query_569018 = newJObject()
  var body_569019 = newJObject()
  add(path_569017, "fabricName", newJString(fabricName))
  add(path_569017, "resourceGroupName", newJString(resourceGroupName))
  add(query_569018, "api-version", newJString(apiVersion))
  add(path_569017, "subscriptionId", newJString(subscriptionId))
  add(path_569017, "resourceName", newJString(resourceName))
  add(path_569017, "protectionContainerName", newJString(protectionContainerName))
  if failoverInput != nil:
    body_569019 = failoverInput
  add(path_569017, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_569016.call(path_569017, query_569018, nil, nil, body_569019)

var replicationProtectedItemsTestFailover* = Call_ReplicationProtectedItemsTestFailover_569004(
    name: "replicationProtectedItemsTestFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/testFailover",
    validator: validate_ReplicationProtectedItemsTestFailover_569005, base: "",
    url: url_ReplicationProtectedItemsTestFailover_569006, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsTestFailoverCleanup_569020 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectedItemsTestFailoverCleanup_569022(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsTestFailoverCleanup_569021(path: JsonNode;
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
  var valid_569028 = path.getOrDefault("replicatedProtectedItemName")
  valid_569028 = validateParameter(valid_569028, JString, required = true,
                                 default = nil)
  if valid_569028 != nil:
    section.add "replicatedProtectedItemName", valid_569028
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569029 = query.getOrDefault("api-version")
  valid_569029 = validateParameter(valid_569029, JString, required = true,
                                 default = nil)
  if valid_569029 != nil:
    section.add "api-version", valid_569029
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

proc call*(call_569031: Call_ReplicationProtectedItemsTestFailoverCleanup_569020;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to clean up the test failover of a replication protected item.
  ## 
  let valid = call_569031.validator(path, query, header, formData, body)
  let scheme = call_569031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569031.url(scheme.get, call_569031.host, call_569031.base,
                         call_569031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569031, url, valid)

proc call*(call_569032: Call_ReplicationProtectedItemsTestFailoverCleanup_569020;
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
  var path_569033 = newJObject()
  var query_569034 = newJObject()
  var body_569035 = newJObject()
  add(path_569033, "fabricName", newJString(fabricName))
  add(path_569033, "resourceGroupName", newJString(resourceGroupName))
  add(query_569034, "api-version", newJString(apiVersion))
  if cleanupInput != nil:
    body_569035 = cleanupInput
  add(path_569033, "subscriptionId", newJString(subscriptionId))
  add(path_569033, "resourceName", newJString(resourceName))
  add(path_569033, "protectionContainerName", newJString(protectionContainerName))
  add(path_569033, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_569032.call(path_569033, query_569034, nil, nil, body_569035)

var replicationProtectedItemsTestFailoverCleanup* = Call_ReplicationProtectedItemsTestFailoverCleanup_569020(
    name: "replicationProtectedItemsTestFailoverCleanup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/testFailoverCleanup",
    validator: validate_ReplicationProtectedItemsTestFailoverCleanup_569021,
    base: "", url: url_ReplicationProtectedItemsTestFailoverCleanup_569022,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsUnplannedFailover_569036 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectedItemsUnplannedFailover_569038(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsUnplannedFailover_569037(path: JsonNode;
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
  var valid_569039 = path.getOrDefault("fabricName")
  valid_569039 = validateParameter(valid_569039, JString, required = true,
                                 default = nil)
  if valid_569039 != nil:
    section.add "fabricName", valid_569039
  var valid_569040 = path.getOrDefault("resourceGroupName")
  valid_569040 = validateParameter(valid_569040, JString, required = true,
                                 default = nil)
  if valid_569040 != nil:
    section.add "resourceGroupName", valid_569040
  var valid_569041 = path.getOrDefault("subscriptionId")
  valid_569041 = validateParameter(valid_569041, JString, required = true,
                                 default = nil)
  if valid_569041 != nil:
    section.add "subscriptionId", valid_569041
  var valid_569042 = path.getOrDefault("resourceName")
  valid_569042 = validateParameter(valid_569042, JString, required = true,
                                 default = nil)
  if valid_569042 != nil:
    section.add "resourceName", valid_569042
  var valid_569043 = path.getOrDefault("protectionContainerName")
  valid_569043 = validateParameter(valid_569043, JString, required = true,
                                 default = nil)
  if valid_569043 != nil:
    section.add "protectionContainerName", valid_569043
  var valid_569044 = path.getOrDefault("replicatedProtectedItemName")
  valid_569044 = validateParameter(valid_569044, JString, required = true,
                                 default = nil)
  if valid_569044 != nil:
    section.add "replicatedProtectedItemName", valid_569044
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569045 = query.getOrDefault("api-version")
  valid_569045 = validateParameter(valid_569045, JString, required = true,
                                 default = nil)
  if valid_569045 != nil:
    section.add "api-version", valid_569045
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

proc call*(call_569047: Call_ReplicationProtectedItemsUnplannedFailover_569036;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to initiate a failover of the replication protected item.
  ## 
  let valid = call_569047.validator(path, query, header, formData, body)
  let scheme = call_569047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569047.url(scheme.get, call_569047.host, call_569047.base,
                         call_569047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569047, url, valid)

proc call*(call_569048: Call_ReplicationProtectedItemsUnplannedFailover_569036;
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
  var path_569049 = newJObject()
  var query_569050 = newJObject()
  var body_569051 = newJObject()
  add(path_569049, "fabricName", newJString(fabricName))
  add(path_569049, "resourceGroupName", newJString(resourceGroupName))
  add(query_569050, "api-version", newJString(apiVersion))
  add(path_569049, "subscriptionId", newJString(subscriptionId))
  add(path_569049, "resourceName", newJString(resourceName))
  add(path_569049, "protectionContainerName", newJString(protectionContainerName))
  if failoverInput != nil:
    body_569051 = failoverInput
  add(path_569049, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_569048.call(path_569049, query_569050, nil, nil, body_569051)

var replicationProtectedItemsUnplannedFailover* = Call_ReplicationProtectedItemsUnplannedFailover_569036(
    name: "replicationProtectedItemsUnplannedFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/unplannedFailover",
    validator: validate_ReplicationProtectedItemsUnplannedFailover_569037,
    base: "", url: url_ReplicationProtectedItemsUnplannedFailover_569038,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsUpdateMobilityService_569052 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectedItemsUpdateMobilityService_569054(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsUpdateMobilityService_569053(
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
  var valid_569055 = path.getOrDefault("fabricName")
  valid_569055 = validateParameter(valid_569055, JString, required = true,
                                 default = nil)
  if valid_569055 != nil:
    section.add "fabricName", valid_569055
  var valid_569056 = path.getOrDefault("resourceGroupName")
  valid_569056 = validateParameter(valid_569056, JString, required = true,
                                 default = nil)
  if valid_569056 != nil:
    section.add "resourceGroupName", valid_569056
  var valid_569057 = path.getOrDefault("subscriptionId")
  valid_569057 = validateParameter(valid_569057, JString, required = true,
                                 default = nil)
  if valid_569057 != nil:
    section.add "subscriptionId", valid_569057
  var valid_569058 = path.getOrDefault("resourceName")
  valid_569058 = validateParameter(valid_569058, JString, required = true,
                                 default = nil)
  if valid_569058 != nil:
    section.add "resourceName", valid_569058
  var valid_569059 = path.getOrDefault("protectionContainerName")
  valid_569059 = validateParameter(valid_569059, JString, required = true,
                                 default = nil)
  if valid_569059 != nil:
    section.add "protectionContainerName", valid_569059
  var valid_569060 = path.getOrDefault("replicationProtectedItemName")
  valid_569060 = validateParameter(valid_569060, JString, required = true,
                                 default = nil)
  if valid_569060 != nil:
    section.add "replicationProtectedItemName", valid_569060
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569061 = query.getOrDefault("api-version")
  valid_569061 = validateParameter(valid_569061, JString, required = true,
                                 default = nil)
  if valid_569061 != nil:
    section.add "api-version", valid_569061
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

proc call*(call_569063: Call_ReplicationProtectedItemsUpdateMobilityService_569052;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to update(push update) the installed mobility service software on a replication protected item to the latest available version.
  ## 
  let valid = call_569063.validator(path, query, header, formData, body)
  let scheme = call_569063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569063.url(scheme.get, call_569063.host, call_569063.base,
                         call_569063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569063, url, valid)

proc call*(call_569064: Call_ReplicationProtectedItemsUpdateMobilityService_569052;
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
  var path_569065 = newJObject()
  var query_569066 = newJObject()
  var body_569067 = newJObject()
  add(path_569065, "fabricName", newJString(fabricName))
  add(path_569065, "resourceGroupName", newJString(resourceGroupName))
  add(query_569066, "api-version", newJString(apiVersion))
  if updateMobilityServiceRequest != nil:
    body_569067 = updateMobilityServiceRequest
  add(path_569065, "subscriptionId", newJString(subscriptionId))
  add(path_569065, "resourceName", newJString(resourceName))
  add(path_569065, "protectionContainerName", newJString(protectionContainerName))
  add(path_569065, "replicationProtectedItemName",
      newJString(replicationProtectedItemName))
  result = call_569064.call(path_569065, query_569066, nil, nil, body_569067)

var replicationProtectedItemsUpdateMobilityService* = Call_ReplicationProtectedItemsUpdateMobilityService_569052(
    name: "replicationProtectedItemsUpdateMobilityService",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicationProtectedItemName}/updateMobilityService",
    validator: validate_ReplicationProtectedItemsUpdateMobilityService_569053,
    base: "", url: url_ReplicationProtectedItemsUpdateMobilityService_569054,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_569068 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_569070(
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

proc validate_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_569069(
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
  var valid_569071 = path.getOrDefault("fabricName")
  valid_569071 = validateParameter(valid_569071, JString, required = true,
                                 default = nil)
  if valid_569071 != nil:
    section.add "fabricName", valid_569071
  var valid_569072 = path.getOrDefault("resourceGroupName")
  valid_569072 = validateParameter(valid_569072, JString, required = true,
                                 default = nil)
  if valid_569072 != nil:
    section.add "resourceGroupName", valid_569072
  var valid_569073 = path.getOrDefault("subscriptionId")
  valid_569073 = validateParameter(valid_569073, JString, required = true,
                                 default = nil)
  if valid_569073 != nil:
    section.add "subscriptionId", valid_569073
  var valid_569074 = path.getOrDefault("resourceName")
  valid_569074 = validateParameter(valid_569074, JString, required = true,
                                 default = nil)
  if valid_569074 != nil:
    section.add "resourceName", valid_569074
  var valid_569075 = path.getOrDefault("protectionContainerName")
  valid_569075 = validateParameter(valid_569075, JString, required = true,
                                 default = nil)
  if valid_569075 != nil:
    section.add "protectionContainerName", valid_569075
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569076 = query.getOrDefault("api-version")
  valid_569076 = validateParameter(valid_569076, JString, required = true,
                                 default = nil)
  if valid_569076 != nil:
    section.add "api-version", valid_569076
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569077: Call_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_569068;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the protection container mappings for a protection container.
  ## 
  let valid = call_569077.validator(path, query, header, formData, body)
  let scheme = call_569077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569077.url(scheme.get, call_569077.host, call_569077.base,
                         call_569077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569077, url, valid)

proc call*(call_569078: Call_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_569068;
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
  var path_569079 = newJObject()
  var query_569080 = newJObject()
  add(path_569079, "fabricName", newJString(fabricName))
  add(path_569079, "resourceGroupName", newJString(resourceGroupName))
  add(query_569080, "api-version", newJString(apiVersion))
  add(path_569079, "subscriptionId", newJString(subscriptionId))
  add(path_569079, "resourceName", newJString(resourceName))
  add(path_569079, "protectionContainerName", newJString(protectionContainerName))
  result = call_569078.call(path_569079, query_569080, nil, nil, nil)

var replicationProtectionContainerMappingsListByReplicationProtectionContainers* = Call_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_569068(name: "replicationProtectionContainerMappingsListByReplicationProtectionContainers",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings", validator: validate_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_569069,
    base: "", url: url_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_569070,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsCreate_569095 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectionContainerMappingsCreate_569097(protocol: Scheme;
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

proc validate_ReplicationProtectionContainerMappingsCreate_569096(path: JsonNode;
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
  var valid_569098 = path.getOrDefault("fabricName")
  valid_569098 = validateParameter(valid_569098, JString, required = true,
                                 default = nil)
  if valid_569098 != nil:
    section.add "fabricName", valid_569098
  var valid_569099 = path.getOrDefault("resourceGroupName")
  valid_569099 = validateParameter(valid_569099, JString, required = true,
                                 default = nil)
  if valid_569099 != nil:
    section.add "resourceGroupName", valid_569099
  var valid_569100 = path.getOrDefault("mappingName")
  valid_569100 = validateParameter(valid_569100, JString, required = true,
                                 default = nil)
  if valid_569100 != nil:
    section.add "mappingName", valid_569100
  var valid_569101 = path.getOrDefault("subscriptionId")
  valid_569101 = validateParameter(valid_569101, JString, required = true,
                                 default = nil)
  if valid_569101 != nil:
    section.add "subscriptionId", valid_569101
  var valid_569102 = path.getOrDefault("resourceName")
  valid_569102 = validateParameter(valid_569102, JString, required = true,
                                 default = nil)
  if valid_569102 != nil:
    section.add "resourceName", valid_569102
  var valid_569103 = path.getOrDefault("protectionContainerName")
  valid_569103 = validateParameter(valid_569103, JString, required = true,
                                 default = nil)
  if valid_569103 != nil:
    section.add "protectionContainerName", valid_569103
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569104 = query.getOrDefault("api-version")
  valid_569104 = validateParameter(valid_569104, JString, required = true,
                                 default = nil)
  if valid_569104 != nil:
    section.add "api-version", valid_569104
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

proc call*(call_569106: Call_ReplicationProtectionContainerMappingsCreate_569095;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create a protection container mapping.
  ## 
  let valid = call_569106.validator(path, query, header, formData, body)
  let scheme = call_569106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569106.url(scheme.get, call_569106.host, call_569106.base,
                         call_569106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569106, url, valid)

proc call*(call_569107: Call_ReplicationProtectionContainerMappingsCreate_569095;
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
  var path_569108 = newJObject()
  var query_569109 = newJObject()
  var body_569110 = newJObject()
  add(path_569108, "fabricName", newJString(fabricName))
  add(path_569108, "resourceGroupName", newJString(resourceGroupName))
  add(query_569109, "api-version", newJString(apiVersion))
  add(path_569108, "mappingName", newJString(mappingName))
  if creationInput != nil:
    body_569110 = creationInput
  add(path_569108, "subscriptionId", newJString(subscriptionId))
  add(path_569108, "resourceName", newJString(resourceName))
  add(path_569108, "protectionContainerName", newJString(protectionContainerName))
  result = call_569107.call(path_569108, query_569109, nil, nil, body_569110)

var replicationProtectionContainerMappingsCreate* = Call_ReplicationProtectionContainerMappingsCreate_569095(
    name: "replicationProtectionContainerMappingsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}",
    validator: validate_ReplicationProtectionContainerMappingsCreate_569096,
    base: "", url: url_ReplicationProtectionContainerMappingsCreate_569097,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsGet_569081 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectionContainerMappingsGet_569083(protocol: Scheme;
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

proc validate_ReplicationProtectionContainerMappingsGet_569082(path: JsonNode;
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
  var valid_569084 = path.getOrDefault("fabricName")
  valid_569084 = validateParameter(valid_569084, JString, required = true,
                                 default = nil)
  if valid_569084 != nil:
    section.add "fabricName", valid_569084
  var valid_569085 = path.getOrDefault("resourceGroupName")
  valid_569085 = validateParameter(valid_569085, JString, required = true,
                                 default = nil)
  if valid_569085 != nil:
    section.add "resourceGroupName", valid_569085
  var valid_569086 = path.getOrDefault("mappingName")
  valid_569086 = validateParameter(valid_569086, JString, required = true,
                                 default = nil)
  if valid_569086 != nil:
    section.add "mappingName", valid_569086
  var valid_569087 = path.getOrDefault("subscriptionId")
  valid_569087 = validateParameter(valid_569087, JString, required = true,
                                 default = nil)
  if valid_569087 != nil:
    section.add "subscriptionId", valid_569087
  var valid_569088 = path.getOrDefault("resourceName")
  valid_569088 = validateParameter(valid_569088, JString, required = true,
                                 default = nil)
  if valid_569088 != nil:
    section.add "resourceName", valid_569088
  var valid_569089 = path.getOrDefault("protectionContainerName")
  valid_569089 = validateParameter(valid_569089, JString, required = true,
                                 default = nil)
  if valid_569089 != nil:
    section.add "protectionContainerName", valid_569089
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569090 = query.getOrDefault("api-version")
  valid_569090 = validateParameter(valid_569090, JString, required = true,
                                 default = nil)
  if valid_569090 != nil:
    section.add "api-version", valid_569090
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569091: Call_ReplicationProtectionContainerMappingsGet_569081;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of a protection container mapping.
  ## 
  let valid = call_569091.validator(path, query, header, formData, body)
  let scheme = call_569091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569091.url(scheme.get, call_569091.host, call_569091.base,
                         call_569091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569091, url, valid)

proc call*(call_569092: Call_ReplicationProtectionContainerMappingsGet_569081;
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
  var path_569093 = newJObject()
  var query_569094 = newJObject()
  add(path_569093, "fabricName", newJString(fabricName))
  add(path_569093, "resourceGroupName", newJString(resourceGroupName))
  add(query_569094, "api-version", newJString(apiVersion))
  add(path_569093, "mappingName", newJString(mappingName))
  add(path_569093, "subscriptionId", newJString(subscriptionId))
  add(path_569093, "resourceName", newJString(resourceName))
  add(path_569093, "protectionContainerName", newJString(protectionContainerName))
  result = call_569092.call(path_569093, query_569094, nil, nil, nil)

var replicationProtectionContainerMappingsGet* = Call_ReplicationProtectionContainerMappingsGet_569081(
    name: "replicationProtectionContainerMappingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}",
    validator: validate_ReplicationProtectionContainerMappingsGet_569082,
    base: "", url: url_ReplicationProtectionContainerMappingsGet_569083,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsUpdate_569125 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectionContainerMappingsUpdate_569127(protocol: Scheme;
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

proc validate_ReplicationProtectionContainerMappingsUpdate_569126(path: JsonNode;
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
  var valid_569128 = path.getOrDefault("fabricName")
  valid_569128 = validateParameter(valid_569128, JString, required = true,
                                 default = nil)
  if valid_569128 != nil:
    section.add "fabricName", valid_569128
  var valid_569129 = path.getOrDefault("resourceGroupName")
  valid_569129 = validateParameter(valid_569129, JString, required = true,
                                 default = nil)
  if valid_569129 != nil:
    section.add "resourceGroupName", valid_569129
  var valid_569130 = path.getOrDefault("mappingName")
  valid_569130 = validateParameter(valid_569130, JString, required = true,
                                 default = nil)
  if valid_569130 != nil:
    section.add "mappingName", valid_569130
  var valid_569131 = path.getOrDefault("subscriptionId")
  valid_569131 = validateParameter(valid_569131, JString, required = true,
                                 default = nil)
  if valid_569131 != nil:
    section.add "subscriptionId", valid_569131
  var valid_569132 = path.getOrDefault("resourceName")
  valid_569132 = validateParameter(valid_569132, JString, required = true,
                                 default = nil)
  if valid_569132 != nil:
    section.add "resourceName", valid_569132
  var valid_569133 = path.getOrDefault("protectionContainerName")
  valid_569133 = validateParameter(valid_569133, JString, required = true,
                                 default = nil)
  if valid_569133 != nil:
    section.add "protectionContainerName", valid_569133
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569134 = query.getOrDefault("api-version")
  valid_569134 = validateParameter(valid_569134, JString, required = true,
                                 default = nil)
  if valid_569134 != nil:
    section.add "api-version", valid_569134
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

proc call*(call_569136: Call_ReplicationProtectionContainerMappingsUpdate_569125;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to update protection container mapping.
  ## 
  let valid = call_569136.validator(path, query, header, formData, body)
  let scheme = call_569136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569136.url(scheme.get, call_569136.host, call_569136.base,
                         call_569136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569136, url, valid)

proc call*(call_569137: Call_ReplicationProtectionContainerMappingsUpdate_569125;
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
  var path_569138 = newJObject()
  var query_569139 = newJObject()
  var body_569140 = newJObject()
  add(path_569138, "fabricName", newJString(fabricName))
  add(path_569138, "resourceGroupName", newJString(resourceGroupName))
  add(query_569139, "api-version", newJString(apiVersion))
  add(path_569138, "mappingName", newJString(mappingName))
  add(path_569138, "subscriptionId", newJString(subscriptionId))
  if updateInput != nil:
    body_569140 = updateInput
  add(path_569138, "resourceName", newJString(resourceName))
  add(path_569138, "protectionContainerName", newJString(protectionContainerName))
  result = call_569137.call(path_569138, query_569139, nil, nil, body_569140)

var replicationProtectionContainerMappingsUpdate* = Call_ReplicationProtectionContainerMappingsUpdate_569125(
    name: "replicationProtectionContainerMappingsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}",
    validator: validate_ReplicationProtectionContainerMappingsUpdate_569126,
    base: "", url: url_ReplicationProtectionContainerMappingsUpdate_569127,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsPurge_569111 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectionContainerMappingsPurge_569113(protocol: Scheme;
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

proc validate_ReplicationProtectionContainerMappingsPurge_569112(path: JsonNode;
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
  var valid_569114 = path.getOrDefault("fabricName")
  valid_569114 = validateParameter(valid_569114, JString, required = true,
                                 default = nil)
  if valid_569114 != nil:
    section.add "fabricName", valid_569114
  var valid_569115 = path.getOrDefault("resourceGroupName")
  valid_569115 = validateParameter(valid_569115, JString, required = true,
                                 default = nil)
  if valid_569115 != nil:
    section.add "resourceGroupName", valid_569115
  var valid_569116 = path.getOrDefault("mappingName")
  valid_569116 = validateParameter(valid_569116, JString, required = true,
                                 default = nil)
  if valid_569116 != nil:
    section.add "mappingName", valid_569116
  var valid_569117 = path.getOrDefault("subscriptionId")
  valid_569117 = validateParameter(valid_569117, JString, required = true,
                                 default = nil)
  if valid_569117 != nil:
    section.add "subscriptionId", valid_569117
  var valid_569118 = path.getOrDefault("resourceName")
  valid_569118 = validateParameter(valid_569118, JString, required = true,
                                 default = nil)
  if valid_569118 != nil:
    section.add "resourceName", valid_569118
  var valid_569119 = path.getOrDefault("protectionContainerName")
  valid_569119 = validateParameter(valid_569119, JString, required = true,
                                 default = nil)
  if valid_569119 != nil:
    section.add "protectionContainerName", valid_569119
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569120 = query.getOrDefault("api-version")
  valid_569120 = validateParameter(valid_569120, JString, required = true,
                                 default = nil)
  if valid_569120 != nil:
    section.add "api-version", valid_569120
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569121: Call_ReplicationProtectionContainerMappingsPurge_569111;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to purge(force delete) a protection container mapping
  ## 
  let valid = call_569121.validator(path, query, header, formData, body)
  let scheme = call_569121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569121.url(scheme.get, call_569121.host, call_569121.base,
                         call_569121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569121, url, valid)

proc call*(call_569122: Call_ReplicationProtectionContainerMappingsPurge_569111;
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
  var path_569123 = newJObject()
  var query_569124 = newJObject()
  add(path_569123, "fabricName", newJString(fabricName))
  add(path_569123, "resourceGroupName", newJString(resourceGroupName))
  add(query_569124, "api-version", newJString(apiVersion))
  add(path_569123, "mappingName", newJString(mappingName))
  add(path_569123, "subscriptionId", newJString(subscriptionId))
  add(path_569123, "resourceName", newJString(resourceName))
  add(path_569123, "protectionContainerName", newJString(protectionContainerName))
  result = call_569122.call(path_569123, query_569124, nil, nil, nil)

var replicationProtectionContainerMappingsPurge* = Call_ReplicationProtectionContainerMappingsPurge_569111(
    name: "replicationProtectionContainerMappingsPurge",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}",
    validator: validate_ReplicationProtectionContainerMappingsPurge_569112,
    base: "", url: url_ReplicationProtectionContainerMappingsPurge_569113,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsDelete_569141 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectionContainerMappingsDelete_569143(protocol: Scheme;
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

proc validate_ReplicationProtectionContainerMappingsDelete_569142(path: JsonNode;
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
  var valid_569144 = path.getOrDefault("fabricName")
  valid_569144 = validateParameter(valid_569144, JString, required = true,
                                 default = nil)
  if valid_569144 != nil:
    section.add "fabricName", valid_569144
  var valid_569145 = path.getOrDefault("resourceGroupName")
  valid_569145 = validateParameter(valid_569145, JString, required = true,
                                 default = nil)
  if valid_569145 != nil:
    section.add "resourceGroupName", valid_569145
  var valid_569146 = path.getOrDefault("mappingName")
  valid_569146 = validateParameter(valid_569146, JString, required = true,
                                 default = nil)
  if valid_569146 != nil:
    section.add "mappingName", valid_569146
  var valid_569147 = path.getOrDefault("subscriptionId")
  valid_569147 = validateParameter(valid_569147, JString, required = true,
                                 default = nil)
  if valid_569147 != nil:
    section.add "subscriptionId", valid_569147
  var valid_569148 = path.getOrDefault("resourceName")
  valid_569148 = validateParameter(valid_569148, JString, required = true,
                                 default = nil)
  if valid_569148 != nil:
    section.add "resourceName", valid_569148
  var valid_569149 = path.getOrDefault("protectionContainerName")
  valid_569149 = validateParameter(valid_569149, JString, required = true,
                                 default = nil)
  if valid_569149 != nil:
    section.add "protectionContainerName", valid_569149
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569150 = query.getOrDefault("api-version")
  valid_569150 = validateParameter(valid_569150, JString, required = true,
                                 default = nil)
  if valid_569150 != nil:
    section.add "api-version", valid_569150
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

proc call*(call_569152: Call_ReplicationProtectionContainerMappingsDelete_569141;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete or remove a protection container mapping.
  ## 
  let valid = call_569152.validator(path, query, header, formData, body)
  let scheme = call_569152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569152.url(scheme.get, call_569152.host, call_569152.base,
                         call_569152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569152, url, valid)

proc call*(call_569153: Call_ReplicationProtectionContainerMappingsDelete_569141;
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
  var path_569154 = newJObject()
  var query_569155 = newJObject()
  var body_569156 = newJObject()
  add(path_569154, "fabricName", newJString(fabricName))
  add(path_569154, "resourceGroupName", newJString(resourceGroupName))
  add(query_569155, "api-version", newJString(apiVersion))
  add(path_569154, "mappingName", newJString(mappingName))
  add(path_569154, "subscriptionId", newJString(subscriptionId))
  add(path_569154, "resourceName", newJString(resourceName))
  add(path_569154, "protectionContainerName", newJString(protectionContainerName))
  if removalInput != nil:
    body_569156 = removalInput
  result = call_569153.call(path_569154, query_569155, nil, nil, body_569156)

var replicationProtectionContainerMappingsDelete* = Call_ReplicationProtectionContainerMappingsDelete_569141(
    name: "replicationProtectionContainerMappingsDelete",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}/remove",
    validator: validate_ReplicationProtectionContainerMappingsDelete_569142,
    base: "", url: url_ReplicationProtectionContainerMappingsDelete_569143,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersSwitchProtection_569157 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectionContainersSwitchProtection_569159(protocol: Scheme;
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

proc validate_ReplicationProtectionContainersSwitchProtection_569158(
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
  var valid_569160 = path.getOrDefault("fabricName")
  valid_569160 = validateParameter(valid_569160, JString, required = true,
                                 default = nil)
  if valid_569160 != nil:
    section.add "fabricName", valid_569160
  var valid_569161 = path.getOrDefault("resourceGroupName")
  valid_569161 = validateParameter(valid_569161, JString, required = true,
                                 default = nil)
  if valid_569161 != nil:
    section.add "resourceGroupName", valid_569161
  var valid_569162 = path.getOrDefault("subscriptionId")
  valid_569162 = validateParameter(valid_569162, JString, required = true,
                                 default = nil)
  if valid_569162 != nil:
    section.add "subscriptionId", valid_569162
  var valid_569163 = path.getOrDefault("resourceName")
  valid_569163 = validateParameter(valid_569163, JString, required = true,
                                 default = nil)
  if valid_569163 != nil:
    section.add "resourceName", valid_569163
  var valid_569164 = path.getOrDefault("protectionContainerName")
  valid_569164 = validateParameter(valid_569164, JString, required = true,
                                 default = nil)
  if valid_569164 != nil:
    section.add "protectionContainerName", valid_569164
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569165 = query.getOrDefault("api-version")
  valid_569165 = validateParameter(valid_569165, JString, required = true,
                                 default = nil)
  if valid_569165 != nil:
    section.add "api-version", valid_569165
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

proc call*(call_569167: Call_ReplicationProtectionContainersSwitchProtection_569157;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to switch protection from one container to another or one replication provider to another.
  ## 
  let valid = call_569167.validator(path, query, header, formData, body)
  let scheme = call_569167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569167.url(scheme.get, call_569167.host, call_569167.base,
                         call_569167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569167, url, valid)

proc call*(call_569168: Call_ReplicationProtectionContainersSwitchProtection_569157;
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
  var path_569169 = newJObject()
  var query_569170 = newJObject()
  var body_569171 = newJObject()
  add(path_569169, "fabricName", newJString(fabricName))
  add(path_569169, "resourceGroupName", newJString(resourceGroupName))
  add(query_569170, "api-version", newJString(apiVersion))
  add(path_569169, "subscriptionId", newJString(subscriptionId))
  add(path_569169, "resourceName", newJString(resourceName))
  add(path_569169, "protectionContainerName", newJString(protectionContainerName))
  if switchInput != nil:
    body_569171 = switchInput
  result = call_569168.call(path_569169, query_569170, nil, nil, body_569171)

var replicationProtectionContainersSwitchProtection* = Call_ReplicationProtectionContainersSwitchProtection_569157(
    name: "replicationProtectionContainersSwitchProtection",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/switchprotection",
    validator: validate_ReplicationProtectionContainersSwitchProtection_569158,
    base: "", url: url_ReplicationProtectionContainersSwitchProtection_569159,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersListByReplicationFabrics_569172 = ref object of OpenApiRestCall_567668
proc url_ReplicationRecoveryServicesProvidersListByReplicationFabrics_569174(
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

proc validate_ReplicationRecoveryServicesProvidersListByReplicationFabrics_569173(
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
  var valid_569175 = path.getOrDefault("fabricName")
  valid_569175 = validateParameter(valid_569175, JString, required = true,
                                 default = nil)
  if valid_569175 != nil:
    section.add "fabricName", valid_569175
  var valid_569176 = path.getOrDefault("resourceGroupName")
  valid_569176 = validateParameter(valid_569176, JString, required = true,
                                 default = nil)
  if valid_569176 != nil:
    section.add "resourceGroupName", valid_569176
  var valid_569177 = path.getOrDefault("subscriptionId")
  valid_569177 = validateParameter(valid_569177, JString, required = true,
                                 default = nil)
  if valid_569177 != nil:
    section.add "subscriptionId", valid_569177
  var valid_569178 = path.getOrDefault("resourceName")
  valid_569178 = validateParameter(valid_569178, JString, required = true,
                                 default = nil)
  if valid_569178 != nil:
    section.add "resourceName", valid_569178
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569179 = query.getOrDefault("api-version")
  valid_569179 = validateParameter(valid_569179, JString, required = true,
                                 default = nil)
  if valid_569179 != nil:
    section.add "api-version", valid_569179
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569180: Call_ReplicationRecoveryServicesProvidersListByReplicationFabrics_569172;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the registered recovery services providers for the specified fabric.
  ## 
  let valid = call_569180.validator(path, query, header, formData, body)
  let scheme = call_569180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569180.url(scheme.get, call_569180.host, call_569180.base,
                         call_569180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569180, url, valid)

proc call*(call_569181: Call_ReplicationRecoveryServicesProvidersListByReplicationFabrics_569172;
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
  var path_569182 = newJObject()
  var query_569183 = newJObject()
  add(path_569182, "fabricName", newJString(fabricName))
  add(path_569182, "resourceGroupName", newJString(resourceGroupName))
  add(query_569183, "api-version", newJString(apiVersion))
  add(path_569182, "subscriptionId", newJString(subscriptionId))
  add(path_569182, "resourceName", newJString(resourceName))
  result = call_569181.call(path_569182, query_569183, nil, nil, nil)

var replicationRecoveryServicesProvidersListByReplicationFabrics* = Call_ReplicationRecoveryServicesProvidersListByReplicationFabrics_569172(
    name: "replicationRecoveryServicesProvidersListByReplicationFabrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders", validator: validate_ReplicationRecoveryServicesProvidersListByReplicationFabrics_569173,
    base: "",
    url: url_ReplicationRecoveryServicesProvidersListByReplicationFabrics_569174,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersCreate_569197 = ref object of OpenApiRestCall_567668
proc url_ReplicationRecoveryServicesProvidersCreate_569199(protocol: Scheme;
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

proc validate_ReplicationRecoveryServicesProvidersCreate_569198(path: JsonNode;
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
  var valid_569200 = path.getOrDefault("fabricName")
  valid_569200 = validateParameter(valid_569200, JString, required = true,
                                 default = nil)
  if valid_569200 != nil:
    section.add "fabricName", valid_569200
  var valid_569201 = path.getOrDefault("resourceGroupName")
  valid_569201 = validateParameter(valid_569201, JString, required = true,
                                 default = nil)
  if valid_569201 != nil:
    section.add "resourceGroupName", valid_569201
  var valid_569202 = path.getOrDefault("subscriptionId")
  valid_569202 = validateParameter(valid_569202, JString, required = true,
                                 default = nil)
  if valid_569202 != nil:
    section.add "subscriptionId", valid_569202
  var valid_569203 = path.getOrDefault("resourceName")
  valid_569203 = validateParameter(valid_569203, JString, required = true,
                                 default = nil)
  if valid_569203 != nil:
    section.add "resourceName", valid_569203
  var valid_569204 = path.getOrDefault("providerName")
  valid_569204 = validateParameter(valid_569204, JString, required = true,
                                 default = nil)
  if valid_569204 != nil:
    section.add "providerName", valid_569204
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569205 = query.getOrDefault("api-version")
  valid_569205 = validateParameter(valid_569205, JString, required = true,
                                 default = nil)
  if valid_569205 != nil:
    section.add "api-version", valid_569205
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

proc call*(call_569207: Call_ReplicationRecoveryServicesProvidersCreate_569197;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to add a recovery services provider.
  ## 
  let valid = call_569207.validator(path, query, header, formData, body)
  let scheme = call_569207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569207.url(scheme.get, call_569207.host, call_569207.base,
                         call_569207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569207, url, valid)

proc call*(call_569208: Call_ReplicationRecoveryServicesProvidersCreate_569197;
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
  var path_569209 = newJObject()
  var query_569210 = newJObject()
  var body_569211 = newJObject()
  add(path_569209, "fabricName", newJString(fabricName))
  add(path_569209, "resourceGroupName", newJString(resourceGroupName))
  add(query_569210, "api-version", newJString(apiVersion))
  if addProviderInput != nil:
    body_569211 = addProviderInput
  add(path_569209, "subscriptionId", newJString(subscriptionId))
  add(path_569209, "resourceName", newJString(resourceName))
  add(path_569209, "providerName", newJString(providerName))
  result = call_569208.call(path_569209, query_569210, nil, nil, body_569211)

var replicationRecoveryServicesProvidersCreate* = Call_ReplicationRecoveryServicesProvidersCreate_569197(
    name: "replicationRecoveryServicesProvidersCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}",
    validator: validate_ReplicationRecoveryServicesProvidersCreate_569198,
    base: "", url: url_ReplicationRecoveryServicesProvidersCreate_569199,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersGet_569184 = ref object of OpenApiRestCall_567668
proc url_ReplicationRecoveryServicesProvidersGet_569186(protocol: Scheme;
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

proc validate_ReplicationRecoveryServicesProvidersGet_569185(path: JsonNode;
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
  var valid_569187 = path.getOrDefault("fabricName")
  valid_569187 = validateParameter(valid_569187, JString, required = true,
                                 default = nil)
  if valid_569187 != nil:
    section.add "fabricName", valid_569187
  var valid_569188 = path.getOrDefault("resourceGroupName")
  valid_569188 = validateParameter(valid_569188, JString, required = true,
                                 default = nil)
  if valid_569188 != nil:
    section.add "resourceGroupName", valid_569188
  var valid_569189 = path.getOrDefault("subscriptionId")
  valid_569189 = validateParameter(valid_569189, JString, required = true,
                                 default = nil)
  if valid_569189 != nil:
    section.add "subscriptionId", valid_569189
  var valid_569190 = path.getOrDefault("resourceName")
  valid_569190 = validateParameter(valid_569190, JString, required = true,
                                 default = nil)
  if valid_569190 != nil:
    section.add "resourceName", valid_569190
  var valid_569191 = path.getOrDefault("providerName")
  valid_569191 = validateParameter(valid_569191, JString, required = true,
                                 default = nil)
  if valid_569191 != nil:
    section.add "providerName", valid_569191
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569192 = query.getOrDefault("api-version")
  valid_569192 = validateParameter(valid_569192, JString, required = true,
                                 default = nil)
  if valid_569192 != nil:
    section.add "api-version", valid_569192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569193: Call_ReplicationRecoveryServicesProvidersGet_569184;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of registered recovery services provider.
  ## 
  let valid = call_569193.validator(path, query, header, formData, body)
  let scheme = call_569193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569193.url(scheme.get, call_569193.host, call_569193.base,
                         call_569193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569193, url, valid)

proc call*(call_569194: Call_ReplicationRecoveryServicesProvidersGet_569184;
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
  var path_569195 = newJObject()
  var query_569196 = newJObject()
  add(path_569195, "fabricName", newJString(fabricName))
  add(path_569195, "resourceGroupName", newJString(resourceGroupName))
  add(query_569196, "api-version", newJString(apiVersion))
  add(path_569195, "subscriptionId", newJString(subscriptionId))
  add(path_569195, "resourceName", newJString(resourceName))
  add(path_569195, "providerName", newJString(providerName))
  result = call_569194.call(path_569195, query_569196, nil, nil, nil)

var replicationRecoveryServicesProvidersGet* = Call_ReplicationRecoveryServicesProvidersGet_569184(
    name: "replicationRecoveryServicesProvidersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}",
    validator: validate_ReplicationRecoveryServicesProvidersGet_569185, base: "",
    url: url_ReplicationRecoveryServicesProvidersGet_569186,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersPurge_569212 = ref object of OpenApiRestCall_567668
proc url_ReplicationRecoveryServicesProvidersPurge_569214(protocol: Scheme;
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

proc validate_ReplicationRecoveryServicesProvidersPurge_569213(path: JsonNode;
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
  var valid_569215 = path.getOrDefault("fabricName")
  valid_569215 = validateParameter(valid_569215, JString, required = true,
                                 default = nil)
  if valid_569215 != nil:
    section.add "fabricName", valid_569215
  var valid_569216 = path.getOrDefault("resourceGroupName")
  valid_569216 = validateParameter(valid_569216, JString, required = true,
                                 default = nil)
  if valid_569216 != nil:
    section.add "resourceGroupName", valid_569216
  var valid_569217 = path.getOrDefault("subscriptionId")
  valid_569217 = validateParameter(valid_569217, JString, required = true,
                                 default = nil)
  if valid_569217 != nil:
    section.add "subscriptionId", valid_569217
  var valid_569218 = path.getOrDefault("resourceName")
  valid_569218 = validateParameter(valid_569218, JString, required = true,
                                 default = nil)
  if valid_569218 != nil:
    section.add "resourceName", valid_569218
  var valid_569219 = path.getOrDefault("providerName")
  valid_569219 = validateParameter(valid_569219, JString, required = true,
                                 default = nil)
  if valid_569219 != nil:
    section.add "providerName", valid_569219
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569220 = query.getOrDefault("api-version")
  valid_569220 = validateParameter(valid_569220, JString, required = true,
                                 default = nil)
  if valid_569220 != nil:
    section.add "api-version", valid_569220
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569221: Call_ReplicationRecoveryServicesProvidersPurge_569212;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to purge(force delete) a recovery services provider from the vault.
  ## 
  let valid = call_569221.validator(path, query, header, formData, body)
  let scheme = call_569221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569221.url(scheme.get, call_569221.host, call_569221.base,
                         call_569221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569221, url, valid)

proc call*(call_569222: Call_ReplicationRecoveryServicesProvidersPurge_569212;
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
  var path_569223 = newJObject()
  var query_569224 = newJObject()
  add(path_569223, "fabricName", newJString(fabricName))
  add(path_569223, "resourceGroupName", newJString(resourceGroupName))
  add(query_569224, "api-version", newJString(apiVersion))
  add(path_569223, "subscriptionId", newJString(subscriptionId))
  add(path_569223, "resourceName", newJString(resourceName))
  add(path_569223, "providerName", newJString(providerName))
  result = call_569222.call(path_569223, query_569224, nil, nil, nil)

var replicationRecoveryServicesProvidersPurge* = Call_ReplicationRecoveryServicesProvidersPurge_569212(
    name: "replicationRecoveryServicesProvidersPurge",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}",
    validator: validate_ReplicationRecoveryServicesProvidersPurge_569213,
    base: "", url: url_ReplicationRecoveryServicesProvidersPurge_569214,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersRefreshProvider_569225 = ref object of OpenApiRestCall_567668
proc url_ReplicationRecoveryServicesProvidersRefreshProvider_569227(
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

proc validate_ReplicationRecoveryServicesProvidersRefreshProvider_569226(
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
  var valid_569228 = path.getOrDefault("fabricName")
  valid_569228 = validateParameter(valid_569228, JString, required = true,
                                 default = nil)
  if valid_569228 != nil:
    section.add "fabricName", valid_569228
  var valid_569229 = path.getOrDefault("resourceGroupName")
  valid_569229 = validateParameter(valid_569229, JString, required = true,
                                 default = nil)
  if valid_569229 != nil:
    section.add "resourceGroupName", valid_569229
  var valid_569230 = path.getOrDefault("subscriptionId")
  valid_569230 = validateParameter(valid_569230, JString, required = true,
                                 default = nil)
  if valid_569230 != nil:
    section.add "subscriptionId", valid_569230
  var valid_569231 = path.getOrDefault("resourceName")
  valid_569231 = validateParameter(valid_569231, JString, required = true,
                                 default = nil)
  if valid_569231 != nil:
    section.add "resourceName", valid_569231
  var valid_569232 = path.getOrDefault("providerName")
  valid_569232 = validateParameter(valid_569232, JString, required = true,
                                 default = nil)
  if valid_569232 != nil:
    section.add "providerName", valid_569232
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569233 = query.getOrDefault("api-version")
  valid_569233 = validateParameter(valid_569233, JString, required = true,
                                 default = nil)
  if valid_569233 != nil:
    section.add "api-version", valid_569233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569234: Call_ReplicationRecoveryServicesProvidersRefreshProvider_569225;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to refresh the information from the recovery services provider.
  ## 
  let valid = call_569234.validator(path, query, header, formData, body)
  let scheme = call_569234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569234.url(scheme.get, call_569234.host, call_569234.base,
                         call_569234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569234, url, valid)

proc call*(call_569235: Call_ReplicationRecoveryServicesProvidersRefreshProvider_569225;
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
  var path_569236 = newJObject()
  var query_569237 = newJObject()
  add(path_569236, "fabricName", newJString(fabricName))
  add(path_569236, "resourceGroupName", newJString(resourceGroupName))
  add(query_569237, "api-version", newJString(apiVersion))
  add(path_569236, "subscriptionId", newJString(subscriptionId))
  add(path_569236, "resourceName", newJString(resourceName))
  add(path_569236, "providerName", newJString(providerName))
  result = call_569235.call(path_569236, query_569237, nil, nil, nil)

var replicationRecoveryServicesProvidersRefreshProvider* = Call_ReplicationRecoveryServicesProvidersRefreshProvider_569225(
    name: "replicationRecoveryServicesProvidersRefreshProvider",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}/refreshProvider",
    validator: validate_ReplicationRecoveryServicesProvidersRefreshProvider_569226,
    base: "", url: url_ReplicationRecoveryServicesProvidersRefreshProvider_569227,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersDelete_569238 = ref object of OpenApiRestCall_567668
proc url_ReplicationRecoveryServicesProvidersDelete_569240(protocol: Scheme;
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

proc validate_ReplicationRecoveryServicesProvidersDelete_569239(path: JsonNode;
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
  var valid_569241 = path.getOrDefault("fabricName")
  valid_569241 = validateParameter(valid_569241, JString, required = true,
                                 default = nil)
  if valid_569241 != nil:
    section.add "fabricName", valid_569241
  var valid_569242 = path.getOrDefault("resourceGroupName")
  valid_569242 = validateParameter(valid_569242, JString, required = true,
                                 default = nil)
  if valid_569242 != nil:
    section.add "resourceGroupName", valid_569242
  var valid_569243 = path.getOrDefault("subscriptionId")
  valid_569243 = validateParameter(valid_569243, JString, required = true,
                                 default = nil)
  if valid_569243 != nil:
    section.add "subscriptionId", valid_569243
  var valid_569244 = path.getOrDefault("resourceName")
  valid_569244 = validateParameter(valid_569244, JString, required = true,
                                 default = nil)
  if valid_569244 != nil:
    section.add "resourceName", valid_569244
  var valid_569245 = path.getOrDefault("providerName")
  valid_569245 = validateParameter(valid_569245, JString, required = true,
                                 default = nil)
  if valid_569245 != nil:
    section.add "providerName", valid_569245
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569246 = query.getOrDefault("api-version")
  valid_569246 = validateParameter(valid_569246, JString, required = true,
                                 default = nil)
  if valid_569246 != nil:
    section.add "api-version", valid_569246
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569247: Call_ReplicationRecoveryServicesProvidersDelete_569238;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to removes/delete(unregister) a recovery services provider from the vault
  ## 
  let valid = call_569247.validator(path, query, header, formData, body)
  let scheme = call_569247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569247.url(scheme.get, call_569247.host, call_569247.base,
                         call_569247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569247, url, valid)

proc call*(call_569248: Call_ReplicationRecoveryServicesProvidersDelete_569238;
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
  var path_569249 = newJObject()
  var query_569250 = newJObject()
  add(path_569249, "fabricName", newJString(fabricName))
  add(path_569249, "resourceGroupName", newJString(resourceGroupName))
  add(query_569250, "api-version", newJString(apiVersion))
  add(path_569249, "subscriptionId", newJString(subscriptionId))
  add(path_569249, "resourceName", newJString(resourceName))
  add(path_569249, "providerName", newJString(providerName))
  result = call_569248.call(path_569249, query_569250, nil, nil, nil)

var replicationRecoveryServicesProvidersDelete* = Call_ReplicationRecoveryServicesProvidersDelete_569238(
    name: "replicationRecoveryServicesProvidersDelete", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}/remove",
    validator: validate_ReplicationRecoveryServicesProvidersDelete_569239,
    base: "", url: url_ReplicationRecoveryServicesProvidersDelete_569240,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationsListByReplicationFabrics_569251 = ref object of OpenApiRestCall_567668
proc url_ReplicationStorageClassificationsListByReplicationFabrics_569253(
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

proc validate_ReplicationStorageClassificationsListByReplicationFabrics_569252(
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
  var valid_569254 = path.getOrDefault("fabricName")
  valid_569254 = validateParameter(valid_569254, JString, required = true,
                                 default = nil)
  if valid_569254 != nil:
    section.add "fabricName", valid_569254
  var valid_569255 = path.getOrDefault("resourceGroupName")
  valid_569255 = validateParameter(valid_569255, JString, required = true,
                                 default = nil)
  if valid_569255 != nil:
    section.add "resourceGroupName", valid_569255
  var valid_569256 = path.getOrDefault("subscriptionId")
  valid_569256 = validateParameter(valid_569256, JString, required = true,
                                 default = nil)
  if valid_569256 != nil:
    section.add "subscriptionId", valid_569256
  var valid_569257 = path.getOrDefault("resourceName")
  valid_569257 = validateParameter(valid_569257, JString, required = true,
                                 default = nil)
  if valid_569257 != nil:
    section.add "resourceName", valid_569257
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569258 = query.getOrDefault("api-version")
  valid_569258 = validateParameter(valid_569258, JString, required = true,
                                 default = nil)
  if valid_569258 != nil:
    section.add "api-version", valid_569258
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569259: Call_ReplicationStorageClassificationsListByReplicationFabrics_569251;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the storage classifications available in the specified fabric.
  ## 
  let valid = call_569259.validator(path, query, header, formData, body)
  let scheme = call_569259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569259.url(scheme.get, call_569259.host, call_569259.base,
                         call_569259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569259, url, valid)

proc call*(call_569260: Call_ReplicationStorageClassificationsListByReplicationFabrics_569251;
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
  var path_569261 = newJObject()
  var query_569262 = newJObject()
  add(path_569261, "fabricName", newJString(fabricName))
  add(path_569261, "resourceGroupName", newJString(resourceGroupName))
  add(query_569262, "api-version", newJString(apiVersion))
  add(path_569261, "subscriptionId", newJString(subscriptionId))
  add(path_569261, "resourceName", newJString(resourceName))
  result = call_569260.call(path_569261, query_569262, nil, nil, nil)

var replicationStorageClassificationsListByReplicationFabrics* = Call_ReplicationStorageClassificationsListByReplicationFabrics_569251(
    name: "replicationStorageClassificationsListByReplicationFabrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications", validator: validate_ReplicationStorageClassificationsListByReplicationFabrics_569252,
    base: "", url: url_ReplicationStorageClassificationsListByReplicationFabrics_569253,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationsGet_569263 = ref object of OpenApiRestCall_567668
proc url_ReplicationStorageClassificationsGet_569265(protocol: Scheme;
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

proc validate_ReplicationStorageClassificationsGet_569264(path: JsonNode;
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
  var valid_569266 = path.getOrDefault("fabricName")
  valid_569266 = validateParameter(valid_569266, JString, required = true,
                                 default = nil)
  if valid_569266 != nil:
    section.add "fabricName", valid_569266
  var valid_569267 = path.getOrDefault("resourceGroupName")
  valid_569267 = validateParameter(valid_569267, JString, required = true,
                                 default = nil)
  if valid_569267 != nil:
    section.add "resourceGroupName", valid_569267
  var valid_569268 = path.getOrDefault("subscriptionId")
  valid_569268 = validateParameter(valid_569268, JString, required = true,
                                 default = nil)
  if valid_569268 != nil:
    section.add "subscriptionId", valid_569268
  var valid_569269 = path.getOrDefault("resourceName")
  valid_569269 = validateParameter(valid_569269, JString, required = true,
                                 default = nil)
  if valid_569269 != nil:
    section.add "resourceName", valid_569269
  var valid_569270 = path.getOrDefault("storageClassificationName")
  valid_569270 = validateParameter(valid_569270, JString, required = true,
                                 default = nil)
  if valid_569270 != nil:
    section.add "storageClassificationName", valid_569270
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569271 = query.getOrDefault("api-version")
  valid_569271 = validateParameter(valid_569271, JString, required = true,
                                 default = nil)
  if valid_569271 != nil:
    section.add "api-version", valid_569271
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569272: Call_ReplicationStorageClassificationsGet_569263;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of the specified storage classification.
  ## 
  let valid = call_569272.validator(path, query, header, formData, body)
  let scheme = call_569272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569272.url(scheme.get, call_569272.host, call_569272.base,
                         call_569272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569272, url, valid)

proc call*(call_569273: Call_ReplicationStorageClassificationsGet_569263;
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
  var path_569274 = newJObject()
  var query_569275 = newJObject()
  add(path_569274, "fabricName", newJString(fabricName))
  add(path_569274, "resourceGroupName", newJString(resourceGroupName))
  add(query_569275, "api-version", newJString(apiVersion))
  add(path_569274, "subscriptionId", newJString(subscriptionId))
  add(path_569274, "resourceName", newJString(resourceName))
  add(path_569274, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_569273.call(path_569274, query_569275, nil, nil, nil)

var replicationStorageClassificationsGet* = Call_ReplicationStorageClassificationsGet_569263(
    name: "replicationStorageClassificationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}",
    validator: validate_ReplicationStorageClassificationsGet_569264, base: "",
    url: url_ReplicationStorageClassificationsGet_569265, schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_569276 = ref object of OpenApiRestCall_567668
proc url_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_569278(
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

proc validate_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_569277(
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
  var valid_569279 = path.getOrDefault("fabricName")
  valid_569279 = validateParameter(valid_569279, JString, required = true,
                                 default = nil)
  if valid_569279 != nil:
    section.add "fabricName", valid_569279
  var valid_569280 = path.getOrDefault("resourceGroupName")
  valid_569280 = validateParameter(valid_569280, JString, required = true,
                                 default = nil)
  if valid_569280 != nil:
    section.add "resourceGroupName", valid_569280
  var valid_569281 = path.getOrDefault("subscriptionId")
  valid_569281 = validateParameter(valid_569281, JString, required = true,
                                 default = nil)
  if valid_569281 != nil:
    section.add "subscriptionId", valid_569281
  var valid_569282 = path.getOrDefault("resourceName")
  valid_569282 = validateParameter(valid_569282, JString, required = true,
                                 default = nil)
  if valid_569282 != nil:
    section.add "resourceName", valid_569282
  var valid_569283 = path.getOrDefault("storageClassificationName")
  valid_569283 = validateParameter(valid_569283, JString, required = true,
                                 default = nil)
  if valid_569283 != nil:
    section.add "storageClassificationName", valid_569283
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569284 = query.getOrDefault("api-version")
  valid_569284 = validateParameter(valid_569284, JString, required = true,
                                 default = nil)
  if valid_569284 != nil:
    section.add "api-version", valid_569284
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569285: Call_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_569276;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the storage classification mappings for the fabric.
  ## 
  let valid = call_569285.validator(path, query, header, formData, body)
  let scheme = call_569285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569285.url(scheme.get, call_569285.host, call_569285.base,
                         call_569285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569285, url, valid)

proc call*(call_569286: Call_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_569276;
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
  var path_569287 = newJObject()
  var query_569288 = newJObject()
  add(path_569287, "fabricName", newJString(fabricName))
  add(path_569287, "resourceGroupName", newJString(resourceGroupName))
  add(query_569288, "api-version", newJString(apiVersion))
  add(path_569287, "subscriptionId", newJString(subscriptionId))
  add(path_569287, "resourceName", newJString(resourceName))
  add(path_569287, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_569286.call(path_569287, query_569288, nil, nil, nil)

var replicationStorageClassificationMappingsListByReplicationStorageClassifications* = Call_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_569276(name: "replicationStorageClassificationMappingsListByReplicationStorageClassifications",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}/replicationStorageClassificationMappings", validator: validate_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_569277,
    base: "", url: url_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_569278,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsCreate_569303 = ref object of OpenApiRestCall_567668
proc url_ReplicationStorageClassificationMappingsCreate_569305(protocol: Scheme;
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

proc validate_ReplicationStorageClassificationMappingsCreate_569304(
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
  var valid_569306 = path.getOrDefault("fabricName")
  valid_569306 = validateParameter(valid_569306, JString, required = true,
                                 default = nil)
  if valid_569306 != nil:
    section.add "fabricName", valid_569306
  var valid_569307 = path.getOrDefault("resourceGroupName")
  valid_569307 = validateParameter(valid_569307, JString, required = true,
                                 default = nil)
  if valid_569307 != nil:
    section.add "resourceGroupName", valid_569307
  var valid_569308 = path.getOrDefault("storageClassificationMappingName")
  valid_569308 = validateParameter(valid_569308, JString, required = true,
                                 default = nil)
  if valid_569308 != nil:
    section.add "storageClassificationMappingName", valid_569308
  var valid_569309 = path.getOrDefault("subscriptionId")
  valid_569309 = validateParameter(valid_569309, JString, required = true,
                                 default = nil)
  if valid_569309 != nil:
    section.add "subscriptionId", valid_569309
  var valid_569310 = path.getOrDefault("resourceName")
  valid_569310 = validateParameter(valid_569310, JString, required = true,
                                 default = nil)
  if valid_569310 != nil:
    section.add "resourceName", valid_569310
  var valid_569311 = path.getOrDefault("storageClassificationName")
  valid_569311 = validateParameter(valid_569311, JString, required = true,
                                 default = nil)
  if valid_569311 != nil:
    section.add "storageClassificationName", valid_569311
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569312 = query.getOrDefault("api-version")
  valid_569312 = validateParameter(valid_569312, JString, required = true,
                                 default = nil)
  if valid_569312 != nil:
    section.add "api-version", valid_569312
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

proc call*(call_569314: Call_ReplicationStorageClassificationMappingsCreate_569303;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create a storage classification mapping.
  ## 
  let valid = call_569314.validator(path, query, header, formData, body)
  let scheme = call_569314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569314.url(scheme.get, call_569314.host, call_569314.base,
                         call_569314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569314, url, valid)

proc call*(call_569315: Call_ReplicationStorageClassificationMappingsCreate_569303;
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
  var path_569316 = newJObject()
  var query_569317 = newJObject()
  var body_569318 = newJObject()
  add(path_569316, "fabricName", newJString(fabricName))
  add(path_569316, "resourceGroupName", newJString(resourceGroupName))
  add(query_569317, "api-version", newJString(apiVersion))
  add(path_569316, "storageClassificationMappingName",
      newJString(storageClassificationMappingName))
  if pairingInput != nil:
    body_569318 = pairingInput
  add(path_569316, "subscriptionId", newJString(subscriptionId))
  add(path_569316, "resourceName", newJString(resourceName))
  add(path_569316, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_569315.call(path_569316, query_569317, nil, nil, body_569318)

var replicationStorageClassificationMappingsCreate* = Call_ReplicationStorageClassificationMappingsCreate_569303(
    name: "replicationStorageClassificationMappingsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}/replicationStorageClassificationMappings/{storageClassificationMappingName}",
    validator: validate_ReplicationStorageClassificationMappingsCreate_569304,
    base: "", url: url_ReplicationStorageClassificationMappingsCreate_569305,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsGet_569289 = ref object of OpenApiRestCall_567668
proc url_ReplicationStorageClassificationMappingsGet_569291(protocol: Scheme;
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

proc validate_ReplicationStorageClassificationMappingsGet_569290(path: JsonNode;
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
  var valid_569292 = path.getOrDefault("fabricName")
  valid_569292 = validateParameter(valid_569292, JString, required = true,
                                 default = nil)
  if valid_569292 != nil:
    section.add "fabricName", valid_569292
  var valid_569293 = path.getOrDefault("resourceGroupName")
  valid_569293 = validateParameter(valid_569293, JString, required = true,
                                 default = nil)
  if valid_569293 != nil:
    section.add "resourceGroupName", valid_569293
  var valid_569294 = path.getOrDefault("storageClassificationMappingName")
  valid_569294 = validateParameter(valid_569294, JString, required = true,
                                 default = nil)
  if valid_569294 != nil:
    section.add "storageClassificationMappingName", valid_569294
  var valid_569295 = path.getOrDefault("subscriptionId")
  valid_569295 = validateParameter(valid_569295, JString, required = true,
                                 default = nil)
  if valid_569295 != nil:
    section.add "subscriptionId", valid_569295
  var valid_569296 = path.getOrDefault("resourceName")
  valid_569296 = validateParameter(valid_569296, JString, required = true,
                                 default = nil)
  if valid_569296 != nil:
    section.add "resourceName", valid_569296
  var valid_569297 = path.getOrDefault("storageClassificationName")
  valid_569297 = validateParameter(valid_569297, JString, required = true,
                                 default = nil)
  if valid_569297 != nil:
    section.add "storageClassificationName", valid_569297
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569298 = query.getOrDefault("api-version")
  valid_569298 = validateParameter(valid_569298, JString, required = true,
                                 default = nil)
  if valid_569298 != nil:
    section.add "api-version", valid_569298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569299: Call_ReplicationStorageClassificationMappingsGet_569289;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of the specified storage classification mapping.
  ## 
  let valid = call_569299.validator(path, query, header, formData, body)
  let scheme = call_569299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569299.url(scheme.get, call_569299.host, call_569299.base,
                         call_569299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569299, url, valid)

proc call*(call_569300: Call_ReplicationStorageClassificationMappingsGet_569289;
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
  var path_569301 = newJObject()
  var query_569302 = newJObject()
  add(path_569301, "fabricName", newJString(fabricName))
  add(path_569301, "resourceGroupName", newJString(resourceGroupName))
  add(query_569302, "api-version", newJString(apiVersion))
  add(path_569301, "storageClassificationMappingName",
      newJString(storageClassificationMappingName))
  add(path_569301, "subscriptionId", newJString(subscriptionId))
  add(path_569301, "resourceName", newJString(resourceName))
  add(path_569301, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_569300.call(path_569301, query_569302, nil, nil, nil)

var replicationStorageClassificationMappingsGet* = Call_ReplicationStorageClassificationMappingsGet_569289(
    name: "replicationStorageClassificationMappingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}/replicationStorageClassificationMappings/{storageClassificationMappingName}",
    validator: validate_ReplicationStorageClassificationMappingsGet_569290,
    base: "", url: url_ReplicationStorageClassificationMappingsGet_569291,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsDelete_569319 = ref object of OpenApiRestCall_567668
proc url_ReplicationStorageClassificationMappingsDelete_569321(protocol: Scheme;
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

proc validate_ReplicationStorageClassificationMappingsDelete_569320(
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
  var valid_569322 = path.getOrDefault("fabricName")
  valid_569322 = validateParameter(valid_569322, JString, required = true,
                                 default = nil)
  if valid_569322 != nil:
    section.add "fabricName", valid_569322
  var valid_569323 = path.getOrDefault("resourceGroupName")
  valid_569323 = validateParameter(valid_569323, JString, required = true,
                                 default = nil)
  if valid_569323 != nil:
    section.add "resourceGroupName", valid_569323
  var valid_569324 = path.getOrDefault("storageClassificationMappingName")
  valid_569324 = validateParameter(valid_569324, JString, required = true,
                                 default = nil)
  if valid_569324 != nil:
    section.add "storageClassificationMappingName", valid_569324
  var valid_569325 = path.getOrDefault("subscriptionId")
  valid_569325 = validateParameter(valid_569325, JString, required = true,
                                 default = nil)
  if valid_569325 != nil:
    section.add "subscriptionId", valid_569325
  var valid_569326 = path.getOrDefault("resourceName")
  valid_569326 = validateParameter(valid_569326, JString, required = true,
                                 default = nil)
  if valid_569326 != nil:
    section.add "resourceName", valid_569326
  var valid_569327 = path.getOrDefault("storageClassificationName")
  valid_569327 = validateParameter(valid_569327, JString, required = true,
                                 default = nil)
  if valid_569327 != nil:
    section.add "storageClassificationName", valid_569327
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569328 = query.getOrDefault("api-version")
  valid_569328 = validateParameter(valid_569328, JString, required = true,
                                 default = nil)
  if valid_569328 != nil:
    section.add "api-version", valid_569328
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569329: Call_ReplicationStorageClassificationMappingsDelete_569319;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete a storage classification mapping.
  ## 
  let valid = call_569329.validator(path, query, header, formData, body)
  let scheme = call_569329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569329.url(scheme.get, call_569329.host, call_569329.base,
                         call_569329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569329, url, valid)

proc call*(call_569330: Call_ReplicationStorageClassificationMappingsDelete_569319;
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
  var path_569331 = newJObject()
  var query_569332 = newJObject()
  add(path_569331, "fabricName", newJString(fabricName))
  add(path_569331, "resourceGroupName", newJString(resourceGroupName))
  add(query_569332, "api-version", newJString(apiVersion))
  add(path_569331, "storageClassificationMappingName",
      newJString(storageClassificationMappingName))
  add(path_569331, "subscriptionId", newJString(subscriptionId))
  add(path_569331, "resourceName", newJString(resourceName))
  add(path_569331, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_569330.call(path_569331, query_569332, nil, nil, nil)

var replicationStorageClassificationMappingsDelete* = Call_ReplicationStorageClassificationMappingsDelete_569319(
    name: "replicationStorageClassificationMappingsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}/replicationStorageClassificationMappings/{storageClassificationMappingName}",
    validator: validate_ReplicationStorageClassificationMappingsDelete_569320,
    base: "", url: url_ReplicationStorageClassificationMappingsDelete_569321,
    schemes: {Scheme.Https})
type
  Call_ReplicationvCentersListByReplicationFabrics_569333 = ref object of OpenApiRestCall_567668
proc url_ReplicationvCentersListByReplicationFabrics_569335(protocol: Scheme;
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

proc validate_ReplicationvCentersListByReplicationFabrics_569334(path: JsonNode;
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
  var valid_569336 = path.getOrDefault("fabricName")
  valid_569336 = validateParameter(valid_569336, JString, required = true,
                                 default = nil)
  if valid_569336 != nil:
    section.add "fabricName", valid_569336
  var valid_569337 = path.getOrDefault("resourceGroupName")
  valid_569337 = validateParameter(valid_569337, JString, required = true,
                                 default = nil)
  if valid_569337 != nil:
    section.add "resourceGroupName", valid_569337
  var valid_569338 = path.getOrDefault("subscriptionId")
  valid_569338 = validateParameter(valid_569338, JString, required = true,
                                 default = nil)
  if valid_569338 != nil:
    section.add "subscriptionId", valid_569338
  var valid_569339 = path.getOrDefault("resourceName")
  valid_569339 = validateParameter(valid_569339, JString, required = true,
                                 default = nil)
  if valid_569339 != nil:
    section.add "resourceName", valid_569339
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569340 = query.getOrDefault("api-version")
  valid_569340 = validateParameter(valid_569340, JString, required = true,
                                 default = nil)
  if valid_569340 != nil:
    section.add "api-version", valid_569340
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569341: Call_ReplicationvCentersListByReplicationFabrics_569333;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the vCenter servers registered in a fabric.
  ## 
  let valid = call_569341.validator(path, query, header, formData, body)
  let scheme = call_569341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569341.url(scheme.get, call_569341.host, call_569341.base,
                         call_569341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569341, url, valid)

proc call*(call_569342: Call_ReplicationvCentersListByReplicationFabrics_569333;
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
  var path_569343 = newJObject()
  var query_569344 = newJObject()
  add(path_569343, "fabricName", newJString(fabricName))
  add(path_569343, "resourceGroupName", newJString(resourceGroupName))
  add(query_569344, "api-version", newJString(apiVersion))
  add(path_569343, "subscriptionId", newJString(subscriptionId))
  add(path_569343, "resourceName", newJString(resourceName))
  result = call_569342.call(path_569343, query_569344, nil, nil, nil)

var replicationvCentersListByReplicationFabrics* = Call_ReplicationvCentersListByReplicationFabrics_569333(
    name: "replicationvCentersListByReplicationFabrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters",
    validator: validate_ReplicationvCentersListByReplicationFabrics_569334,
    base: "", url: url_ReplicationvCentersListByReplicationFabrics_569335,
    schemes: {Scheme.Https})
type
  Call_ReplicationvCentersCreate_569358 = ref object of OpenApiRestCall_567668
proc url_ReplicationvCentersCreate_569360(protocol: Scheme; host: string;
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

proc validate_ReplicationvCentersCreate_569359(path: JsonNode; query: JsonNode;
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
  var valid_569361 = path.getOrDefault("fabricName")
  valid_569361 = validateParameter(valid_569361, JString, required = true,
                                 default = nil)
  if valid_569361 != nil:
    section.add "fabricName", valid_569361
  var valid_569362 = path.getOrDefault("resourceGroupName")
  valid_569362 = validateParameter(valid_569362, JString, required = true,
                                 default = nil)
  if valid_569362 != nil:
    section.add "resourceGroupName", valid_569362
  var valid_569363 = path.getOrDefault("subscriptionId")
  valid_569363 = validateParameter(valid_569363, JString, required = true,
                                 default = nil)
  if valid_569363 != nil:
    section.add "subscriptionId", valid_569363
  var valid_569364 = path.getOrDefault("resourceName")
  valid_569364 = validateParameter(valid_569364, JString, required = true,
                                 default = nil)
  if valid_569364 != nil:
    section.add "resourceName", valid_569364
  var valid_569365 = path.getOrDefault("vCenterName")
  valid_569365 = validateParameter(valid_569365, JString, required = true,
                                 default = nil)
  if valid_569365 != nil:
    section.add "vCenterName", valid_569365
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569366 = query.getOrDefault("api-version")
  valid_569366 = validateParameter(valid_569366, JString, required = true,
                                 default = nil)
  if valid_569366 != nil:
    section.add "api-version", valid_569366
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

proc call*(call_569368: Call_ReplicationvCentersCreate_569358; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create a vCenter object..
  ## 
  let valid = call_569368.validator(path, query, header, formData, body)
  let scheme = call_569368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569368.url(scheme.get, call_569368.host, call_569368.base,
                         call_569368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569368, url, valid)

proc call*(call_569369: Call_ReplicationvCentersCreate_569358; fabricName: string;
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
  var path_569370 = newJObject()
  var query_569371 = newJObject()
  var body_569372 = newJObject()
  add(path_569370, "fabricName", newJString(fabricName))
  add(path_569370, "resourceGroupName", newJString(resourceGroupName))
  add(query_569371, "api-version", newJString(apiVersion))
  add(path_569370, "subscriptionId", newJString(subscriptionId))
  add(path_569370, "resourceName", newJString(resourceName))
  if addVCenterRequest != nil:
    body_569372 = addVCenterRequest
  add(path_569370, "vCenterName", newJString(vCenterName))
  result = call_569369.call(path_569370, query_569371, nil, nil, body_569372)

var replicationvCentersCreate* = Call_ReplicationvCentersCreate_569358(
    name: "replicationvCentersCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters/{vCenterName}",
    validator: validate_ReplicationvCentersCreate_569359, base: "",
    url: url_ReplicationvCentersCreate_569360, schemes: {Scheme.Https})
type
  Call_ReplicationvCentersGet_569345 = ref object of OpenApiRestCall_567668
proc url_ReplicationvCentersGet_569347(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationvCentersGet_569346(path: JsonNode; query: JsonNode;
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
  var valid_569348 = path.getOrDefault("fabricName")
  valid_569348 = validateParameter(valid_569348, JString, required = true,
                                 default = nil)
  if valid_569348 != nil:
    section.add "fabricName", valid_569348
  var valid_569349 = path.getOrDefault("resourceGroupName")
  valid_569349 = validateParameter(valid_569349, JString, required = true,
                                 default = nil)
  if valid_569349 != nil:
    section.add "resourceGroupName", valid_569349
  var valid_569350 = path.getOrDefault("subscriptionId")
  valid_569350 = validateParameter(valid_569350, JString, required = true,
                                 default = nil)
  if valid_569350 != nil:
    section.add "subscriptionId", valid_569350
  var valid_569351 = path.getOrDefault("resourceName")
  valid_569351 = validateParameter(valid_569351, JString, required = true,
                                 default = nil)
  if valid_569351 != nil:
    section.add "resourceName", valid_569351
  var valid_569352 = path.getOrDefault("vCenterName")
  valid_569352 = validateParameter(valid_569352, JString, required = true,
                                 default = nil)
  if valid_569352 != nil:
    section.add "vCenterName", valid_569352
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569353 = query.getOrDefault("api-version")
  valid_569353 = validateParameter(valid_569353, JString, required = true,
                                 default = nil)
  if valid_569353 != nil:
    section.add "api-version", valid_569353
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569354: Call_ReplicationvCentersGet_569345; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a registered vCenter server(Add vCenter server.)
  ## 
  let valid = call_569354.validator(path, query, header, formData, body)
  let scheme = call_569354.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569354.url(scheme.get, call_569354.host, call_569354.base,
                         call_569354.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569354, url, valid)

proc call*(call_569355: Call_ReplicationvCentersGet_569345; fabricName: string;
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
  var path_569356 = newJObject()
  var query_569357 = newJObject()
  add(path_569356, "fabricName", newJString(fabricName))
  add(path_569356, "resourceGroupName", newJString(resourceGroupName))
  add(query_569357, "api-version", newJString(apiVersion))
  add(path_569356, "subscriptionId", newJString(subscriptionId))
  add(path_569356, "resourceName", newJString(resourceName))
  add(path_569356, "vCenterName", newJString(vCenterName))
  result = call_569355.call(path_569356, query_569357, nil, nil, nil)

var replicationvCentersGet* = Call_ReplicationvCentersGet_569345(
    name: "replicationvCentersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters/{vCenterName}",
    validator: validate_ReplicationvCentersGet_569346, base: "",
    url: url_ReplicationvCentersGet_569347, schemes: {Scheme.Https})
type
  Call_ReplicationvCentersUpdate_569386 = ref object of OpenApiRestCall_567668
proc url_ReplicationvCentersUpdate_569388(protocol: Scheme; host: string;
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

proc validate_ReplicationvCentersUpdate_569387(path: JsonNode; query: JsonNode;
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
  var valid_569389 = path.getOrDefault("fabricName")
  valid_569389 = validateParameter(valid_569389, JString, required = true,
                                 default = nil)
  if valid_569389 != nil:
    section.add "fabricName", valid_569389
  var valid_569390 = path.getOrDefault("resourceGroupName")
  valid_569390 = validateParameter(valid_569390, JString, required = true,
                                 default = nil)
  if valid_569390 != nil:
    section.add "resourceGroupName", valid_569390
  var valid_569391 = path.getOrDefault("subscriptionId")
  valid_569391 = validateParameter(valid_569391, JString, required = true,
                                 default = nil)
  if valid_569391 != nil:
    section.add "subscriptionId", valid_569391
  var valid_569392 = path.getOrDefault("resourceName")
  valid_569392 = validateParameter(valid_569392, JString, required = true,
                                 default = nil)
  if valid_569392 != nil:
    section.add "resourceName", valid_569392
  var valid_569393 = path.getOrDefault("vCenterName")
  valid_569393 = validateParameter(valid_569393, JString, required = true,
                                 default = nil)
  if valid_569393 != nil:
    section.add "vCenterName", valid_569393
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569394 = query.getOrDefault("api-version")
  valid_569394 = validateParameter(valid_569394, JString, required = true,
                                 default = nil)
  if valid_569394 != nil:
    section.add "api-version", valid_569394
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

proc call*(call_569396: Call_ReplicationvCentersUpdate_569386; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a registered vCenter.
  ## 
  let valid = call_569396.validator(path, query, header, formData, body)
  let scheme = call_569396.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569396.url(scheme.get, call_569396.host, call_569396.base,
                         call_569396.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569396, url, valid)

proc call*(call_569397: Call_ReplicationvCentersUpdate_569386; fabricName: string;
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
  var path_569398 = newJObject()
  var query_569399 = newJObject()
  var body_569400 = newJObject()
  add(path_569398, "fabricName", newJString(fabricName))
  add(path_569398, "resourceGroupName", newJString(resourceGroupName))
  add(query_569399, "api-version", newJString(apiVersion))
  add(path_569398, "subscriptionId", newJString(subscriptionId))
  add(path_569398, "resourceName", newJString(resourceName))
  add(path_569398, "vCenterName", newJString(vCenterName))
  if updateVCenterRequest != nil:
    body_569400 = updateVCenterRequest
  result = call_569397.call(path_569398, query_569399, nil, nil, body_569400)

var replicationvCentersUpdate* = Call_ReplicationvCentersUpdate_569386(
    name: "replicationvCentersUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters/{vCenterName}",
    validator: validate_ReplicationvCentersUpdate_569387, base: "",
    url: url_ReplicationvCentersUpdate_569388, schemes: {Scheme.Https})
type
  Call_ReplicationvCentersDelete_569373 = ref object of OpenApiRestCall_567668
proc url_ReplicationvCentersDelete_569375(protocol: Scheme; host: string;
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

proc validate_ReplicationvCentersDelete_569374(path: JsonNode; query: JsonNode;
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
  var valid_569376 = path.getOrDefault("fabricName")
  valid_569376 = validateParameter(valid_569376, JString, required = true,
                                 default = nil)
  if valid_569376 != nil:
    section.add "fabricName", valid_569376
  var valid_569377 = path.getOrDefault("resourceGroupName")
  valid_569377 = validateParameter(valid_569377, JString, required = true,
                                 default = nil)
  if valid_569377 != nil:
    section.add "resourceGroupName", valid_569377
  var valid_569378 = path.getOrDefault("subscriptionId")
  valid_569378 = validateParameter(valid_569378, JString, required = true,
                                 default = nil)
  if valid_569378 != nil:
    section.add "subscriptionId", valid_569378
  var valid_569379 = path.getOrDefault("resourceName")
  valid_569379 = validateParameter(valid_569379, JString, required = true,
                                 default = nil)
  if valid_569379 != nil:
    section.add "resourceName", valid_569379
  var valid_569380 = path.getOrDefault("vCenterName")
  valid_569380 = validateParameter(valid_569380, JString, required = true,
                                 default = nil)
  if valid_569380 != nil:
    section.add "vCenterName", valid_569380
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569381 = query.getOrDefault("api-version")
  valid_569381 = validateParameter(valid_569381, JString, required = true,
                                 default = nil)
  if valid_569381 != nil:
    section.add "api-version", valid_569381
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569382: Call_ReplicationvCentersDelete_569373; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to remove(unregister) a registered vCenter server from the vault.
  ## 
  let valid = call_569382.validator(path, query, header, formData, body)
  let scheme = call_569382.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569382.url(scheme.get, call_569382.host, call_569382.base,
                         call_569382.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569382, url, valid)

proc call*(call_569383: Call_ReplicationvCentersDelete_569373; fabricName: string;
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
  var path_569384 = newJObject()
  var query_569385 = newJObject()
  add(path_569384, "fabricName", newJString(fabricName))
  add(path_569384, "resourceGroupName", newJString(resourceGroupName))
  add(query_569385, "api-version", newJString(apiVersion))
  add(path_569384, "subscriptionId", newJString(subscriptionId))
  add(path_569384, "resourceName", newJString(resourceName))
  add(path_569384, "vCenterName", newJString(vCenterName))
  result = call_569383.call(path_569384, query_569385, nil, nil, nil)

var replicationvCentersDelete* = Call_ReplicationvCentersDelete_569373(
    name: "replicationvCentersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters/{vCenterName}",
    validator: validate_ReplicationvCentersDelete_569374, base: "",
    url: url_ReplicationvCentersDelete_569375, schemes: {Scheme.Https})
type
  Call_ReplicationJobsList_569401 = ref object of OpenApiRestCall_567668
proc url_ReplicationJobsList_569403(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationJobsList_569402(path: JsonNode; query: JsonNode;
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
  var valid_569404 = path.getOrDefault("resourceGroupName")
  valid_569404 = validateParameter(valid_569404, JString, required = true,
                                 default = nil)
  if valid_569404 != nil:
    section.add "resourceGroupName", valid_569404
  var valid_569405 = path.getOrDefault("subscriptionId")
  valid_569405 = validateParameter(valid_569405, JString, required = true,
                                 default = nil)
  if valid_569405 != nil:
    section.add "subscriptionId", valid_569405
  var valid_569406 = path.getOrDefault("resourceName")
  valid_569406 = validateParameter(valid_569406, JString, required = true,
                                 default = nil)
  if valid_569406 != nil:
    section.add "resourceName", valid_569406
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569407 = query.getOrDefault("api-version")
  valid_569407 = validateParameter(valid_569407, JString, required = true,
                                 default = nil)
  if valid_569407 != nil:
    section.add "api-version", valid_569407
  var valid_569408 = query.getOrDefault("$filter")
  valid_569408 = validateParameter(valid_569408, JString, required = false,
                                 default = nil)
  if valid_569408 != nil:
    section.add "$filter", valid_569408
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569409: Call_ReplicationJobsList_569401; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of Azure Site Recovery Jobs for the vault.
  ## 
  let valid = call_569409.validator(path, query, header, formData, body)
  let scheme = call_569409.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569409.url(scheme.get, call_569409.host, call_569409.base,
                         call_569409.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569409, url, valid)

proc call*(call_569410: Call_ReplicationJobsList_569401; resourceGroupName: string;
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
  var path_569411 = newJObject()
  var query_569412 = newJObject()
  add(path_569411, "resourceGroupName", newJString(resourceGroupName))
  add(query_569412, "api-version", newJString(apiVersion))
  add(path_569411, "subscriptionId", newJString(subscriptionId))
  add(path_569411, "resourceName", newJString(resourceName))
  add(query_569412, "$filter", newJString(Filter))
  result = call_569410.call(path_569411, query_569412, nil, nil, nil)

var replicationJobsList* = Call_ReplicationJobsList_569401(
    name: "replicationJobsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs",
    validator: validate_ReplicationJobsList_569402, base: "",
    url: url_ReplicationJobsList_569403, schemes: {Scheme.Https})
type
  Call_ReplicationJobsExport_569413 = ref object of OpenApiRestCall_567668
proc url_ReplicationJobsExport_569415(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationJobsExport_569414(path: JsonNode; query: JsonNode;
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
  var valid_569416 = path.getOrDefault("resourceGroupName")
  valid_569416 = validateParameter(valid_569416, JString, required = true,
                                 default = nil)
  if valid_569416 != nil:
    section.add "resourceGroupName", valid_569416
  var valid_569417 = path.getOrDefault("subscriptionId")
  valid_569417 = validateParameter(valid_569417, JString, required = true,
                                 default = nil)
  if valid_569417 != nil:
    section.add "subscriptionId", valid_569417
  var valid_569418 = path.getOrDefault("resourceName")
  valid_569418 = validateParameter(valid_569418, JString, required = true,
                                 default = nil)
  if valid_569418 != nil:
    section.add "resourceName", valid_569418
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569419 = query.getOrDefault("api-version")
  valid_569419 = validateParameter(valid_569419, JString, required = true,
                                 default = nil)
  if valid_569419 != nil:
    section.add "api-version", valid_569419
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

proc call*(call_569421: Call_ReplicationJobsExport_569413; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to export the details of the Azure Site Recovery jobs of the vault.
  ## 
  let valid = call_569421.validator(path, query, header, formData, body)
  let scheme = call_569421.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569421.url(scheme.get, call_569421.host, call_569421.base,
                         call_569421.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569421, url, valid)

proc call*(call_569422: Call_ReplicationJobsExport_569413;
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
  var path_569423 = newJObject()
  var query_569424 = newJObject()
  var body_569425 = newJObject()
  add(path_569423, "resourceGroupName", newJString(resourceGroupName))
  add(query_569424, "api-version", newJString(apiVersion))
  add(path_569423, "subscriptionId", newJString(subscriptionId))
  add(path_569423, "resourceName", newJString(resourceName))
  if jobQueryParameter != nil:
    body_569425 = jobQueryParameter
  result = call_569422.call(path_569423, query_569424, nil, nil, body_569425)

var replicationJobsExport* = Call_ReplicationJobsExport_569413(
    name: "replicationJobsExport", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/export",
    validator: validate_ReplicationJobsExport_569414, base: "",
    url: url_ReplicationJobsExport_569415, schemes: {Scheme.Https})
type
  Call_ReplicationJobsGet_569426 = ref object of OpenApiRestCall_567668
proc url_ReplicationJobsGet_569428(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationJobsGet_569427(path: JsonNode; query: JsonNode;
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
  var valid_569429 = path.getOrDefault("resourceGroupName")
  valid_569429 = validateParameter(valid_569429, JString, required = true,
                                 default = nil)
  if valid_569429 != nil:
    section.add "resourceGroupName", valid_569429
  var valid_569430 = path.getOrDefault("subscriptionId")
  valid_569430 = validateParameter(valid_569430, JString, required = true,
                                 default = nil)
  if valid_569430 != nil:
    section.add "subscriptionId", valid_569430
  var valid_569431 = path.getOrDefault("jobName")
  valid_569431 = validateParameter(valid_569431, JString, required = true,
                                 default = nil)
  if valid_569431 != nil:
    section.add "jobName", valid_569431
  var valid_569432 = path.getOrDefault("resourceName")
  valid_569432 = validateParameter(valid_569432, JString, required = true,
                                 default = nil)
  if valid_569432 != nil:
    section.add "resourceName", valid_569432
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569433 = query.getOrDefault("api-version")
  valid_569433 = validateParameter(valid_569433, JString, required = true,
                                 default = nil)
  if valid_569433 != nil:
    section.add "api-version", valid_569433
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569434: Call_ReplicationJobsGet_569426; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the details of an Azure Site Recovery job.
  ## 
  let valid = call_569434.validator(path, query, header, formData, body)
  let scheme = call_569434.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569434.url(scheme.get, call_569434.host, call_569434.base,
                         call_569434.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569434, url, valid)

proc call*(call_569435: Call_ReplicationJobsGet_569426; resourceGroupName: string;
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
  var path_569436 = newJObject()
  var query_569437 = newJObject()
  add(path_569436, "resourceGroupName", newJString(resourceGroupName))
  add(query_569437, "api-version", newJString(apiVersion))
  add(path_569436, "subscriptionId", newJString(subscriptionId))
  add(path_569436, "jobName", newJString(jobName))
  add(path_569436, "resourceName", newJString(resourceName))
  result = call_569435.call(path_569436, query_569437, nil, nil, nil)

var replicationJobsGet* = Call_ReplicationJobsGet_569426(
    name: "replicationJobsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/{jobName}",
    validator: validate_ReplicationJobsGet_569427, base: "",
    url: url_ReplicationJobsGet_569428, schemes: {Scheme.Https})
type
  Call_ReplicationJobsCancel_569438 = ref object of OpenApiRestCall_567668
proc url_ReplicationJobsCancel_569440(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationJobsCancel_569439(path: JsonNode; query: JsonNode;
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
  var valid_569441 = path.getOrDefault("resourceGroupName")
  valid_569441 = validateParameter(valid_569441, JString, required = true,
                                 default = nil)
  if valid_569441 != nil:
    section.add "resourceGroupName", valid_569441
  var valid_569442 = path.getOrDefault("subscriptionId")
  valid_569442 = validateParameter(valid_569442, JString, required = true,
                                 default = nil)
  if valid_569442 != nil:
    section.add "subscriptionId", valid_569442
  var valid_569443 = path.getOrDefault("jobName")
  valid_569443 = validateParameter(valid_569443, JString, required = true,
                                 default = nil)
  if valid_569443 != nil:
    section.add "jobName", valid_569443
  var valid_569444 = path.getOrDefault("resourceName")
  valid_569444 = validateParameter(valid_569444, JString, required = true,
                                 default = nil)
  if valid_569444 != nil:
    section.add "resourceName", valid_569444
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569445 = query.getOrDefault("api-version")
  valid_569445 = validateParameter(valid_569445, JString, required = true,
                                 default = nil)
  if valid_569445 != nil:
    section.add "api-version", valid_569445
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569446: Call_ReplicationJobsCancel_569438; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to cancel an Azure Site Recovery job.
  ## 
  let valid = call_569446.validator(path, query, header, formData, body)
  let scheme = call_569446.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569446.url(scheme.get, call_569446.host, call_569446.base,
                         call_569446.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569446, url, valid)

proc call*(call_569447: Call_ReplicationJobsCancel_569438;
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
  var path_569448 = newJObject()
  var query_569449 = newJObject()
  add(path_569448, "resourceGroupName", newJString(resourceGroupName))
  add(query_569449, "api-version", newJString(apiVersion))
  add(path_569448, "subscriptionId", newJString(subscriptionId))
  add(path_569448, "jobName", newJString(jobName))
  add(path_569448, "resourceName", newJString(resourceName))
  result = call_569447.call(path_569448, query_569449, nil, nil, nil)

var replicationJobsCancel* = Call_ReplicationJobsCancel_569438(
    name: "replicationJobsCancel", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/{jobName}/cancel",
    validator: validate_ReplicationJobsCancel_569439, base: "",
    url: url_ReplicationJobsCancel_569440, schemes: {Scheme.Https})
type
  Call_ReplicationJobsRestart_569450 = ref object of OpenApiRestCall_567668
proc url_ReplicationJobsRestart_569452(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationJobsRestart_569451(path: JsonNode; query: JsonNode;
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
  var valid_569453 = path.getOrDefault("resourceGroupName")
  valid_569453 = validateParameter(valid_569453, JString, required = true,
                                 default = nil)
  if valid_569453 != nil:
    section.add "resourceGroupName", valid_569453
  var valid_569454 = path.getOrDefault("subscriptionId")
  valid_569454 = validateParameter(valid_569454, JString, required = true,
                                 default = nil)
  if valid_569454 != nil:
    section.add "subscriptionId", valid_569454
  var valid_569455 = path.getOrDefault("jobName")
  valid_569455 = validateParameter(valid_569455, JString, required = true,
                                 default = nil)
  if valid_569455 != nil:
    section.add "jobName", valid_569455
  var valid_569456 = path.getOrDefault("resourceName")
  valid_569456 = validateParameter(valid_569456, JString, required = true,
                                 default = nil)
  if valid_569456 != nil:
    section.add "resourceName", valid_569456
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569457 = query.getOrDefault("api-version")
  valid_569457 = validateParameter(valid_569457, JString, required = true,
                                 default = nil)
  if valid_569457 != nil:
    section.add "api-version", valid_569457
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569458: Call_ReplicationJobsRestart_569450; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to restart an Azure Site Recovery job.
  ## 
  let valid = call_569458.validator(path, query, header, formData, body)
  let scheme = call_569458.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569458.url(scheme.get, call_569458.host, call_569458.base,
                         call_569458.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569458, url, valid)

proc call*(call_569459: Call_ReplicationJobsRestart_569450;
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
  var path_569460 = newJObject()
  var query_569461 = newJObject()
  add(path_569460, "resourceGroupName", newJString(resourceGroupName))
  add(query_569461, "api-version", newJString(apiVersion))
  add(path_569460, "subscriptionId", newJString(subscriptionId))
  add(path_569460, "jobName", newJString(jobName))
  add(path_569460, "resourceName", newJString(resourceName))
  result = call_569459.call(path_569460, query_569461, nil, nil, nil)

var replicationJobsRestart* = Call_ReplicationJobsRestart_569450(
    name: "replicationJobsRestart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/{jobName}/restart",
    validator: validate_ReplicationJobsRestart_569451, base: "",
    url: url_ReplicationJobsRestart_569452, schemes: {Scheme.Https})
type
  Call_ReplicationJobsResume_569462 = ref object of OpenApiRestCall_567668
proc url_ReplicationJobsResume_569464(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationJobsResume_569463(path: JsonNode; query: JsonNode;
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
  var valid_569465 = path.getOrDefault("resourceGroupName")
  valid_569465 = validateParameter(valid_569465, JString, required = true,
                                 default = nil)
  if valid_569465 != nil:
    section.add "resourceGroupName", valid_569465
  var valid_569466 = path.getOrDefault("subscriptionId")
  valid_569466 = validateParameter(valid_569466, JString, required = true,
                                 default = nil)
  if valid_569466 != nil:
    section.add "subscriptionId", valid_569466
  var valid_569467 = path.getOrDefault("jobName")
  valid_569467 = validateParameter(valid_569467, JString, required = true,
                                 default = nil)
  if valid_569467 != nil:
    section.add "jobName", valid_569467
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
  ## parameters in `body` object:
  ##   resumeJobParams: JObject (required)
  ##                  : Resume rob comments.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569471: Call_ReplicationJobsResume_569462; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to resume an Azure Site Recovery job
  ## 
  let valid = call_569471.validator(path, query, header, formData, body)
  let scheme = call_569471.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569471.url(scheme.get, call_569471.host, call_569471.base,
                         call_569471.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569471, url, valid)

proc call*(call_569472: Call_ReplicationJobsResume_569462;
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
  var path_569473 = newJObject()
  var query_569474 = newJObject()
  var body_569475 = newJObject()
  add(path_569473, "resourceGroupName", newJString(resourceGroupName))
  add(query_569474, "api-version", newJString(apiVersion))
  if resumeJobParams != nil:
    body_569475 = resumeJobParams
  add(path_569473, "subscriptionId", newJString(subscriptionId))
  add(path_569473, "jobName", newJString(jobName))
  add(path_569473, "resourceName", newJString(resourceName))
  result = call_569472.call(path_569473, query_569474, nil, nil, body_569475)

var replicationJobsResume* = Call_ReplicationJobsResume_569462(
    name: "replicationJobsResume", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/{jobName}/resume",
    validator: validate_ReplicationJobsResume_569463, base: "",
    url: url_ReplicationJobsResume_569464, schemes: {Scheme.Https})
type
  Call_ReplicationMigrationItemsList_569476 = ref object of OpenApiRestCall_567668
proc url_ReplicationMigrationItemsList_569478(protocol: Scheme; host: string;
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

proc validate_ReplicationMigrationItemsList_569477(path: JsonNode; query: JsonNode;
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
  var valid_569479 = path.getOrDefault("resourceGroupName")
  valid_569479 = validateParameter(valid_569479, JString, required = true,
                                 default = nil)
  if valid_569479 != nil:
    section.add "resourceGroupName", valid_569479
  var valid_569480 = path.getOrDefault("subscriptionId")
  valid_569480 = validateParameter(valid_569480, JString, required = true,
                                 default = nil)
  if valid_569480 != nil:
    section.add "subscriptionId", valid_569480
  var valid_569481 = path.getOrDefault("resourceName")
  valid_569481 = validateParameter(valid_569481, JString, required = true,
                                 default = nil)
  if valid_569481 != nil:
    section.add "resourceName", valid_569481
  result.add "path", section
  ## parameters in `query` object:
  ##   skipToken: JString
  ##            : The pagination token.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  var valid_569482 = query.getOrDefault("skipToken")
  valid_569482 = validateParameter(valid_569482, JString, required = false,
                                 default = nil)
  if valid_569482 != nil:
    section.add "skipToken", valid_569482
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569483 = query.getOrDefault("api-version")
  valid_569483 = validateParameter(valid_569483, JString, required = true,
                                 default = nil)
  if valid_569483 != nil:
    section.add "api-version", valid_569483
  var valid_569484 = query.getOrDefault("$filter")
  valid_569484 = validateParameter(valid_569484, JString, required = false,
                                 default = nil)
  if valid_569484 != nil:
    section.add "$filter", valid_569484
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569485: Call_ReplicationMigrationItemsList_569476; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569485.validator(path, query, header, formData, body)
  let scheme = call_569485.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569485.url(scheme.get, call_569485.host, call_569485.base,
                         call_569485.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569485, url, valid)

proc call*(call_569486: Call_ReplicationMigrationItemsList_569476;
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
  var path_569487 = newJObject()
  var query_569488 = newJObject()
  add(path_569487, "resourceGroupName", newJString(resourceGroupName))
  add(query_569488, "skipToken", newJString(skipToken))
  add(query_569488, "api-version", newJString(apiVersion))
  add(path_569487, "subscriptionId", newJString(subscriptionId))
  add(path_569487, "resourceName", newJString(resourceName))
  add(query_569488, "$filter", newJString(Filter))
  result = call_569486.call(path_569487, query_569488, nil, nil, nil)

var replicationMigrationItemsList* = Call_ReplicationMigrationItemsList_569476(
    name: "replicationMigrationItemsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationMigrationItems",
    validator: validate_ReplicationMigrationItemsList_569477, base: "",
    url: url_ReplicationMigrationItemsList_569478, schemes: {Scheme.Https})
type
  Call_ReplicationNetworkMappingsList_569489 = ref object of OpenApiRestCall_567668
proc url_ReplicationNetworkMappingsList_569491(protocol: Scheme; host: string;
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

proc validate_ReplicationNetworkMappingsList_569490(path: JsonNode;
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
  var valid_569492 = path.getOrDefault("resourceGroupName")
  valid_569492 = validateParameter(valid_569492, JString, required = true,
                                 default = nil)
  if valid_569492 != nil:
    section.add "resourceGroupName", valid_569492
  var valid_569493 = path.getOrDefault("subscriptionId")
  valid_569493 = validateParameter(valid_569493, JString, required = true,
                                 default = nil)
  if valid_569493 != nil:
    section.add "subscriptionId", valid_569493
  var valid_569494 = path.getOrDefault("resourceName")
  valid_569494 = validateParameter(valid_569494, JString, required = true,
                                 default = nil)
  if valid_569494 != nil:
    section.add "resourceName", valid_569494
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569495 = query.getOrDefault("api-version")
  valid_569495 = validateParameter(valid_569495, JString, required = true,
                                 default = nil)
  if valid_569495 != nil:
    section.add "api-version", valid_569495
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569496: Call_ReplicationNetworkMappingsList_569489; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all ASR network mappings in the vault.
  ## 
  let valid = call_569496.validator(path, query, header, formData, body)
  let scheme = call_569496.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569496.url(scheme.get, call_569496.host, call_569496.base,
                         call_569496.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569496, url, valid)

proc call*(call_569497: Call_ReplicationNetworkMappingsList_569489;
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
  var path_569498 = newJObject()
  var query_569499 = newJObject()
  add(path_569498, "resourceGroupName", newJString(resourceGroupName))
  add(query_569499, "api-version", newJString(apiVersion))
  add(path_569498, "subscriptionId", newJString(subscriptionId))
  add(path_569498, "resourceName", newJString(resourceName))
  result = call_569497.call(path_569498, query_569499, nil, nil, nil)

var replicationNetworkMappingsList* = Call_ReplicationNetworkMappingsList_569489(
    name: "replicationNetworkMappingsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationNetworkMappings",
    validator: validate_ReplicationNetworkMappingsList_569490, base: "",
    url: url_ReplicationNetworkMappingsList_569491, schemes: {Scheme.Https})
type
  Call_ReplicationNetworksList_569500 = ref object of OpenApiRestCall_567668
proc url_ReplicationNetworksList_569502(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationNetworksList_569501(path: JsonNode; query: JsonNode;
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569506 = query.getOrDefault("api-version")
  valid_569506 = validateParameter(valid_569506, JString, required = true,
                                 default = nil)
  if valid_569506 != nil:
    section.add "api-version", valid_569506
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569507: Call_ReplicationNetworksList_569500; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the networks available in a vault
  ## 
  let valid = call_569507.validator(path, query, header, formData, body)
  let scheme = call_569507.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569507.url(scheme.get, call_569507.host, call_569507.base,
                         call_569507.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569507, url, valid)

proc call*(call_569508: Call_ReplicationNetworksList_569500;
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
  var path_569509 = newJObject()
  var query_569510 = newJObject()
  add(path_569509, "resourceGroupName", newJString(resourceGroupName))
  add(query_569510, "api-version", newJString(apiVersion))
  add(path_569509, "subscriptionId", newJString(subscriptionId))
  add(path_569509, "resourceName", newJString(resourceName))
  result = call_569508.call(path_569509, query_569510, nil, nil, nil)

var replicationNetworksList* = Call_ReplicationNetworksList_569500(
    name: "replicationNetworksList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationNetworks",
    validator: validate_ReplicationNetworksList_569501, base: "",
    url: url_ReplicationNetworksList_569502, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesList_569511 = ref object of OpenApiRestCall_567668
proc url_ReplicationPoliciesList_569513(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationPoliciesList_569512(path: JsonNode; query: JsonNode;
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
  var valid_569514 = path.getOrDefault("resourceGroupName")
  valid_569514 = validateParameter(valid_569514, JString, required = true,
                                 default = nil)
  if valid_569514 != nil:
    section.add "resourceGroupName", valid_569514
  var valid_569515 = path.getOrDefault("subscriptionId")
  valid_569515 = validateParameter(valid_569515, JString, required = true,
                                 default = nil)
  if valid_569515 != nil:
    section.add "subscriptionId", valid_569515
  var valid_569516 = path.getOrDefault("resourceName")
  valid_569516 = validateParameter(valid_569516, JString, required = true,
                                 default = nil)
  if valid_569516 != nil:
    section.add "resourceName", valid_569516
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569517 = query.getOrDefault("api-version")
  valid_569517 = validateParameter(valid_569517, JString, required = true,
                                 default = nil)
  if valid_569517 != nil:
    section.add "api-version", valid_569517
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569518: Call_ReplicationPoliciesList_569511; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the replication policies for a vault.
  ## 
  let valid = call_569518.validator(path, query, header, formData, body)
  let scheme = call_569518.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569518.url(scheme.get, call_569518.host, call_569518.base,
                         call_569518.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569518, url, valid)

proc call*(call_569519: Call_ReplicationPoliciesList_569511;
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
  var path_569520 = newJObject()
  var query_569521 = newJObject()
  add(path_569520, "resourceGroupName", newJString(resourceGroupName))
  add(query_569521, "api-version", newJString(apiVersion))
  add(path_569520, "subscriptionId", newJString(subscriptionId))
  add(path_569520, "resourceName", newJString(resourceName))
  result = call_569519.call(path_569520, query_569521, nil, nil, nil)

var replicationPoliciesList* = Call_ReplicationPoliciesList_569511(
    name: "replicationPoliciesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies",
    validator: validate_ReplicationPoliciesList_569512, base: "",
    url: url_ReplicationPoliciesList_569513, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesCreate_569534 = ref object of OpenApiRestCall_567668
proc url_ReplicationPoliciesCreate_569536(protocol: Scheme; host: string;
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

proc validate_ReplicationPoliciesCreate_569535(path: JsonNode; query: JsonNode;
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
  var valid_569537 = path.getOrDefault("resourceGroupName")
  valid_569537 = validateParameter(valid_569537, JString, required = true,
                                 default = nil)
  if valid_569537 != nil:
    section.add "resourceGroupName", valid_569537
  var valid_569538 = path.getOrDefault("subscriptionId")
  valid_569538 = validateParameter(valid_569538, JString, required = true,
                                 default = nil)
  if valid_569538 != nil:
    section.add "subscriptionId", valid_569538
  var valid_569539 = path.getOrDefault("resourceName")
  valid_569539 = validateParameter(valid_569539, JString, required = true,
                                 default = nil)
  if valid_569539 != nil:
    section.add "resourceName", valid_569539
  var valid_569540 = path.getOrDefault("policyName")
  valid_569540 = validateParameter(valid_569540, JString, required = true,
                                 default = nil)
  if valid_569540 != nil:
    section.add "policyName", valid_569540
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569541 = query.getOrDefault("api-version")
  valid_569541 = validateParameter(valid_569541, JString, required = true,
                                 default = nil)
  if valid_569541 != nil:
    section.add "api-version", valid_569541
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

proc call*(call_569543: Call_ReplicationPoliciesCreate_569534; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create a replication policy
  ## 
  let valid = call_569543.validator(path, query, header, formData, body)
  let scheme = call_569543.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569543.url(scheme.get, call_569543.host, call_569543.base,
                         call_569543.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569543, url, valid)

proc call*(call_569544: Call_ReplicationPoliciesCreate_569534;
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
  var path_569545 = newJObject()
  var query_569546 = newJObject()
  var body_569547 = newJObject()
  add(path_569545, "resourceGroupName", newJString(resourceGroupName))
  add(query_569546, "api-version", newJString(apiVersion))
  add(path_569545, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_569547 = input
  add(path_569545, "resourceName", newJString(resourceName))
  add(path_569545, "policyName", newJString(policyName))
  result = call_569544.call(path_569545, query_569546, nil, nil, body_569547)

var replicationPoliciesCreate* = Call_ReplicationPoliciesCreate_569534(
    name: "replicationPoliciesCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies/{policyName}",
    validator: validate_ReplicationPoliciesCreate_569535, base: "",
    url: url_ReplicationPoliciesCreate_569536, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesGet_569522 = ref object of OpenApiRestCall_567668
proc url_ReplicationPoliciesGet_569524(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationPoliciesGet_569523(path: JsonNode; query: JsonNode;
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
  var valid_569525 = path.getOrDefault("resourceGroupName")
  valid_569525 = validateParameter(valid_569525, JString, required = true,
                                 default = nil)
  if valid_569525 != nil:
    section.add "resourceGroupName", valid_569525
  var valid_569526 = path.getOrDefault("subscriptionId")
  valid_569526 = validateParameter(valid_569526, JString, required = true,
                                 default = nil)
  if valid_569526 != nil:
    section.add "subscriptionId", valid_569526
  var valid_569527 = path.getOrDefault("resourceName")
  valid_569527 = validateParameter(valid_569527, JString, required = true,
                                 default = nil)
  if valid_569527 != nil:
    section.add "resourceName", valid_569527
  var valid_569528 = path.getOrDefault("policyName")
  valid_569528 = validateParameter(valid_569528, JString, required = true,
                                 default = nil)
  if valid_569528 != nil:
    section.add "policyName", valid_569528
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569529 = query.getOrDefault("api-version")
  valid_569529 = validateParameter(valid_569529, JString, required = true,
                                 default = nil)
  if valid_569529 != nil:
    section.add "api-version", valid_569529
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569530: Call_ReplicationPoliciesGet_569522; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a replication policy.
  ## 
  let valid = call_569530.validator(path, query, header, formData, body)
  let scheme = call_569530.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569530.url(scheme.get, call_569530.host, call_569530.base,
                         call_569530.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569530, url, valid)

proc call*(call_569531: Call_ReplicationPoliciesGet_569522;
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
  var path_569532 = newJObject()
  var query_569533 = newJObject()
  add(path_569532, "resourceGroupName", newJString(resourceGroupName))
  add(query_569533, "api-version", newJString(apiVersion))
  add(path_569532, "subscriptionId", newJString(subscriptionId))
  add(path_569532, "resourceName", newJString(resourceName))
  add(path_569532, "policyName", newJString(policyName))
  result = call_569531.call(path_569532, query_569533, nil, nil, nil)

var replicationPoliciesGet* = Call_ReplicationPoliciesGet_569522(
    name: "replicationPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies/{policyName}",
    validator: validate_ReplicationPoliciesGet_569523, base: "",
    url: url_ReplicationPoliciesGet_569524, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesUpdate_569560 = ref object of OpenApiRestCall_567668
proc url_ReplicationPoliciesUpdate_569562(protocol: Scheme; host: string;
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

proc validate_ReplicationPoliciesUpdate_569561(path: JsonNode; query: JsonNode;
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
  var valid_569563 = path.getOrDefault("resourceGroupName")
  valid_569563 = validateParameter(valid_569563, JString, required = true,
                                 default = nil)
  if valid_569563 != nil:
    section.add "resourceGroupName", valid_569563
  var valid_569564 = path.getOrDefault("subscriptionId")
  valid_569564 = validateParameter(valid_569564, JString, required = true,
                                 default = nil)
  if valid_569564 != nil:
    section.add "subscriptionId", valid_569564
  var valid_569565 = path.getOrDefault("resourceName")
  valid_569565 = validateParameter(valid_569565, JString, required = true,
                                 default = nil)
  if valid_569565 != nil:
    section.add "resourceName", valid_569565
  var valid_569566 = path.getOrDefault("policyName")
  valid_569566 = validateParameter(valid_569566, JString, required = true,
                                 default = nil)
  if valid_569566 != nil:
    section.add "policyName", valid_569566
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
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Update Policy Input
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569569: Call_ReplicationPoliciesUpdate_569560; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a replication policy.
  ## 
  let valid = call_569569.validator(path, query, header, formData, body)
  let scheme = call_569569.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569569.url(scheme.get, call_569569.host, call_569569.base,
                         call_569569.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569569, url, valid)

proc call*(call_569570: Call_ReplicationPoliciesUpdate_569560;
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
  var path_569571 = newJObject()
  var query_569572 = newJObject()
  var body_569573 = newJObject()
  add(path_569571, "resourceGroupName", newJString(resourceGroupName))
  add(query_569572, "api-version", newJString(apiVersion))
  add(path_569571, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_569573 = input
  add(path_569571, "resourceName", newJString(resourceName))
  add(path_569571, "policyName", newJString(policyName))
  result = call_569570.call(path_569571, query_569572, nil, nil, body_569573)

var replicationPoliciesUpdate* = Call_ReplicationPoliciesUpdate_569560(
    name: "replicationPoliciesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies/{policyName}",
    validator: validate_ReplicationPoliciesUpdate_569561, base: "",
    url: url_ReplicationPoliciesUpdate_569562, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesDelete_569548 = ref object of OpenApiRestCall_567668
proc url_ReplicationPoliciesDelete_569550(protocol: Scheme; host: string;
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

proc validate_ReplicationPoliciesDelete_569549(path: JsonNode; query: JsonNode;
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
  var valid_569551 = path.getOrDefault("resourceGroupName")
  valid_569551 = validateParameter(valid_569551, JString, required = true,
                                 default = nil)
  if valid_569551 != nil:
    section.add "resourceGroupName", valid_569551
  var valid_569552 = path.getOrDefault("subscriptionId")
  valid_569552 = validateParameter(valid_569552, JString, required = true,
                                 default = nil)
  if valid_569552 != nil:
    section.add "subscriptionId", valid_569552
  var valid_569553 = path.getOrDefault("resourceName")
  valid_569553 = validateParameter(valid_569553, JString, required = true,
                                 default = nil)
  if valid_569553 != nil:
    section.add "resourceName", valid_569553
  var valid_569554 = path.getOrDefault("policyName")
  valid_569554 = validateParameter(valid_569554, JString, required = true,
                                 default = nil)
  if valid_569554 != nil:
    section.add "policyName", valid_569554
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569555 = query.getOrDefault("api-version")
  valid_569555 = validateParameter(valid_569555, JString, required = true,
                                 default = nil)
  if valid_569555 != nil:
    section.add "api-version", valid_569555
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569556: Call_ReplicationPoliciesDelete_569548; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete a replication policy.
  ## 
  let valid = call_569556.validator(path, query, header, formData, body)
  let scheme = call_569556.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569556.url(scheme.get, call_569556.host, call_569556.base,
                         call_569556.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569556, url, valid)

proc call*(call_569557: Call_ReplicationPoliciesDelete_569548;
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
  var path_569558 = newJObject()
  var query_569559 = newJObject()
  add(path_569558, "resourceGroupName", newJString(resourceGroupName))
  add(query_569559, "api-version", newJString(apiVersion))
  add(path_569558, "subscriptionId", newJString(subscriptionId))
  add(path_569558, "resourceName", newJString(resourceName))
  add(path_569558, "policyName", newJString(policyName))
  result = call_569557.call(path_569558, query_569559, nil, nil, nil)

var replicationPoliciesDelete* = Call_ReplicationPoliciesDelete_569548(
    name: "replicationPoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies/{policyName}",
    validator: validate_ReplicationPoliciesDelete_569549, base: "",
    url: url_ReplicationPoliciesDelete_569550, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsList_569574 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectedItemsList_569576(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectedItemsList_569575(path: JsonNode; query: JsonNode;
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
  var valid_569577 = path.getOrDefault("resourceGroupName")
  valid_569577 = validateParameter(valid_569577, JString, required = true,
                                 default = nil)
  if valid_569577 != nil:
    section.add "resourceGroupName", valid_569577
  var valid_569578 = path.getOrDefault("subscriptionId")
  valid_569578 = validateParameter(valid_569578, JString, required = true,
                                 default = nil)
  if valid_569578 != nil:
    section.add "subscriptionId", valid_569578
  var valid_569579 = path.getOrDefault("resourceName")
  valid_569579 = validateParameter(valid_569579, JString, required = true,
                                 default = nil)
  if valid_569579 != nil:
    section.add "resourceName", valid_569579
  result.add "path", section
  ## parameters in `query` object:
  ##   skipToken: JString
  ##            : The pagination token. Possible values: "FabricId" or "FabricId_CloudId" or null
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  var valid_569580 = query.getOrDefault("skipToken")
  valid_569580 = validateParameter(valid_569580, JString, required = false,
                                 default = nil)
  if valid_569580 != nil:
    section.add "skipToken", valid_569580
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569581 = query.getOrDefault("api-version")
  valid_569581 = validateParameter(valid_569581, JString, required = true,
                                 default = nil)
  if valid_569581 != nil:
    section.add "api-version", valid_569581
  var valid_569582 = query.getOrDefault("$filter")
  valid_569582 = validateParameter(valid_569582, JString, required = false,
                                 default = nil)
  if valid_569582 != nil:
    section.add "$filter", valid_569582
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569583: Call_ReplicationProtectedItemsList_569574; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of ASR replication protected items in the vault.
  ## 
  let valid = call_569583.validator(path, query, header, formData, body)
  let scheme = call_569583.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569583.url(scheme.get, call_569583.host, call_569583.base,
                         call_569583.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569583, url, valid)

proc call*(call_569584: Call_ReplicationProtectedItemsList_569574;
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
  var path_569585 = newJObject()
  var query_569586 = newJObject()
  add(path_569585, "resourceGroupName", newJString(resourceGroupName))
  add(query_569586, "skipToken", newJString(skipToken))
  add(query_569586, "api-version", newJString(apiVersion))
  add(path_569585, "subscriptionId", newJString(subscriptionId))
  add(path_569585, "resourceName", newJString(resourceName))
  add(query_569586, "$filter", newJString(Filter))
  result = call_569584.call(path_569585, query_569586, nil, nil, nil)

var replicationProtectedItemsList* = Call_ReplicationProtectedItemsList_569574(
    name: "replicationProtectedItemsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationProtectedItems",
    validator: validate_ReplicationProtectedItemsList_569575, base: "",
    url: url_ReplicationProtectedItemsList_569576, schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsList_569587 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectionContainerMappingsList_569589(protocol: Scheme;
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

proc validate_ReplicationProtectionContainerMappingsList_569588(path: JsonNode;
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
  var valid_569590 = path.getOrDefault("resourceGroupName")
  valid_569590 = validateParameter(valid_569590, JString, required = true,
                                 default = nil)
  if valid_569590 != nil:
    section.add "resourceGroupName", valid_569590
  var valid_569591 = path.getOrDefault("subscriptionId")
  valid_569591 = validateParameter(valid_569591, JString, required = true,
                                 default = nil)
  if valid_569591 != nil:
    section.add "subscriptionId", valid_569591
  var valid_569592 = path.getOrDefault("resourceName")
  valid_569592 = validateParameter(valid_569592, JString, required = true,
                                 default = nil)
  if valid_569592 != nil:
    section.add "resourceName", valid_569592
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569593 = query.getOrDefault("api-version")
  valid_569593 = validateParameter(valid_569593, JString, required = true,
                                 default = nil)
  if valid_569593 != nil:
    section.add "api-version", valid_569593
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569594: Call_ReplicationProtectionContainerMappingsList_569587;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the protection container mappings in the vault.
  ## 
  let valid = call_569594.validator(path, query, header, formData, body)
  let scheme = call_569594.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569594.url(scheme.get, call_569594.host, call_569594.base,
                         call_569594.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569594, url, valid)

proc call*(call_569595: Call_ReplicationProtectionContainerMappingsList_569587;
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
  var path_569596 = newJObject()
  var query_569597 = newJObject()
  add(path_569596, "resourceGroupName", newJString(resourceGroupName))
  add(query_569597, "api-version", newJString(apiVersion))
  add(path_569596, "subscriptionId", newJString(subscriptionId))
  add(path_569596, "resourceName", newJString(resourceName))
  result = call_569595.call(path_569596, query_569597, nil, nil, nil)

var replicationProtectionContainerMappingsList* = Call_ReplicationProtectionContainerMappingsList_569587(
    name: "replicationProtectionContainerMappingsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationProtectionContainerMappings",
    validator: validate_ReplicationProtectionContainerMappingsList_569588,
    base: "", url: url_ReplicationProtectionContainerMappingsList_569589,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersList_569598 = ref object of OpenApiRestCall_567668
proc url_ReplicationProtectionContainersList_569600(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectionContainersList_569599(path: JsonNode;
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
  var valid_569603 = path.getOrDefault("resourceName")
  valid_569603 = validateParameter(valid_569603, JString, required = true,
                                 default = nil)
  if valid_569603 != nil:
    section.add "resourceName", valid_569603
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569604 = query.getOrDefault("api-version")
  valid_569604 = validateParameter(valid_569604, JString, required = true,
                                 default = nil)
  if valid_569604 != nil:
    section.add "api-version", valid_569604
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569605: Call_ReplicationProtectionContainersList_569598;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the protection containers in a vault.
  ## 
  let valid = call_569605.validator(path, query, header, formData, body)
  let scheme = call_569605.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569605.url(scheme.get, call_569605.host, call_569605.base,
                         call_569605.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569605, url, valid)

proc call*(call_569606: Call_ReplicationProtectionContainersList_569598;
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
  var path_569607 = newJObject()
  var query_569608 = newJObject()
  add(path_569607, "resourceGroupName", newJString(resourceGroupName))
  add(query_569608, "api-version", newJString(apiVersion))
  add(path_569607, "subscriptionId", newJString(subscriptionId))
  add(path_569607, "resourceName", newJString(resourceName))
  result = call_569606.call(path_569607, query_569608, nil, nil, nil)

var replicationProtectionContainersList* = Call_ReplicationProtectionContainersList_569598(
    name: "replicationProtectionContainersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationProtectionContainers",
    validator: validate_ReplicationProtectionContainersList_569599, base: "",
    url: url_ReplicationProtectionContainersList_569600, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansList_569609 = ref object of OpenApiRestCall_567668
proc url_ReplicationRecoveryPlansList_569611(protocol: Scheme; host: string;
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

proc validate_ReplicationRecoveryPlansList_569610(path: JsonNode; query: JsonNode;
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
  var valid_569612 = path.getOrDefault("resourceGroupName")
  valid_569612 = validateParameter(valid_569612, JString, required = true,
                                 default = nil)
  if valid_569612 != nil:
    section.add "resourceGroupName", valid_569612
  var valid_569613 = path.getOrDefault("subscriptionId")
  valid_569613 = validateParameter(valid_569613, JString, required = true,
                                 default = nil)
  if valid_569613 != nil:
    section.add "subscriptionId", valid_569613
  var valid_569614 = path.getOrDefault("resourceName")
  valid_569614 = validateParameter(valid_569614, JString, required = true,
                                 default = nil)
  if valid_569614 != nil:
    section.add "resourceName", valid_569614
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569615 = query.getOrDefault("api-version")
  valid_569615 = validateParameter(valid_569615, JString, required = true,
                                 default = nil)
  if valid_569615 != nil:
    section.add "api-version", valid_569615
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569616: Call_ReplicationRecoveryPlansList_569609; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the recovery plans in the vault.
  ## 
  let valid = call_569616.validator(path, query, header, formData, body)
  let scheme = call_569616.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569616.url(scheme.get, call_569616.host, call_569616.base,
                         call_569616.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569616, url, valid)

proc call*(call_569617: Call_ReplicationRecoveryPlansList_569609;
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
  var path_569618 = newJObject()
  var query_569619 = newJObject()
  add(path_569618, "resourceGroupName", newJString(resourceGroupName))
  add(query_569619, "api-version", newJString(apiVersion))
  add(path_569618, "subscriptionId", newJString(subscriptionId))
  add(path_569618, "resourceName", newJString(resourceName))
  result = call_569617.call(path_569618, query_569619, nil, nil, nil)

var replicationRecoveryPlansList* = Call_ReplicationRecoveryPlansList_569609(
    name: "replicationRecoveryPlansList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans",
    validator: validate_ReplicationRecoveryPlansList_569610, base: "",
    url: url_ReplicationRecoveryPlansList_569611, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansCreate_569632 = ref object of OpenApiRestCall_567668
proc url_ReplicationRecoveryPlansCreate_569634(protocol: Scheme; host: string;
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

proc validate_ReplicationRecoveryPlansCreate_569633(path: JsonNode;
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
  var valid_569635 = path.getOrDefault("resourceGroupName")
  valid_569635 = validateParameter(valid_569635, JString, required = true,
                                 default = nil)
  if valid_569635 != nil:
    section.add "resourceGroupName", valid_569635
  var valid_569636 = path.getOrDefault("subscriptionId")
  valid_569636 = validateParameter(valid_569636, JString, required = true,
                                 default = nil)
  if valid_569636 != nil:
    section.add "subscriptionId", valid_569636
  var valid_569637 = path.getOrDefault("recoveryPlanName")
  valid_569637 = validateParameter(valid_569637, JString, required = true,
                                 default = nil)
  if valid_569637 != nil:
    section.add "recoveryPlanName", valid_569637
  var valid_569638 = path.getOrDefault("resourceName")
  valid_569638 = validateParameter(valid_569638, JString, required = true,
                                 default = nil)
  if valid_569638 != nil:
    section.add "resourceName", valid_569638
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569639 = query.getOrDefault("api-version")
  valid_569639 = validateParameter(valid_569639, JString, required = true,
                                 default = nil)
  if valid_569639 != nil:
    section.add "api-version", valid_569639
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

proc call*(call_569641: Call_ReplicationRecoveryPlansCreate_569632; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create a recovery plan.
  ## 
  let valid = call_569641.validator(path, query, header, formData, body)
  let scheme = call_569641.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569641.url(scheme.get, call_569641.host, call_569641.base,
                         call_569641.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569641, url, valid)

proc call*(call_569642: Call_ReplicationRecoveryPlansCreate_569632;
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
  var path_569643 = newJObject()
  var query_569644 = newJObject()
  var body_569645 = newJObject()
  add(path_569643, "resourceGroupName", newJString(resourceGroupName))
  add(query_569644, "api-version", newJString(apiVersion))
  add(path_569643, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_569645 = input
  add(path_569643, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_569643, "resourceName", newJString(resourceName))
  result = call_569642.call(path_569643, query_569644, nil, nil, body_569645)

var replicationRecoveryPlansCreate* = Call_ReplicationRecoveryPlansCreate_569632(
    name: "replicationRecoveryPlansCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}",
    validator: validate_ReplicationRecoveryPlansCreate_569633, base: "",
    url: url_ReplicationRecoveryPlansCreate_569634, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansGet_569620 = ref object of OpenApiRestCall_567668
proc url_ReplicationRecoveryPlansGet_569622(protocol: Scheme; host: string;
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

proc validate_ReplicationRecoveryPlansGet_569621(path: JsonNode; query: JsonNode;
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
  var valid_569623 = path.getOrDefault("resourceGroupName")
  valid_569623 = validateParameter(valid_569623, JString, required = true,
                                 default = nil)
  if valid_569623 != nil:
    section.add "resourceGroupName", valid_569623
  var valid_569624 = path.getOrDefault("subscriptionId")
  valid_569624 = validateParameter(valid_569624, JString, required = true,
                                 default = nil)
  if valid_569624 != nil:
    section.add "subscriptionId", valid_569624
  var valid_569625 = path.getOrDefault("recoveryPlanName")
  valid_569625 = validateParameter(valid_569625, JString, required = true,
                                 default = nil)
  if valid_569625 != nil:
    section.add "recoveryPlanName", valid_569625
  var valid_569626 = path.getOrDefault("resourceName")
  valid_569626 = validateParameter(valid_569626, JString, required = true,
                                 default = nil)
  if valid_569626 != nil:
    section.add "resourceName", valid_569626
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569627 = query.getOrDefault("api-version")
  valid_569627 = validateParameter(valid_569627, JString, required = true,
                                 default = nil)
  if valid_569627 != nil:
    section.add "api-version", valid_569627
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569628: Call_ReplicationRecoveryPlansGet_569620; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the recovery plan.
  ## 
  let valid = call_569628.validator(path, query, header, formData, body)
  let scheme = call_569628.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569628.url(scheme.get, call_569628.host, call_569628.base,
                         call_569628.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569628, url, valid)

proc call*(call_569629: Call_ReplicationRecoveryPlansGet_569620;
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
  var path_569630 = newJObject()
  var query_569631 = newJObject()
  add(path_569630, "resourceGroupName", newJString(resourceGroupName))
  add(query_569631, "api-version", newJString(apiVersion))
  add(path_569630, "subscriptionId", newJString(subscriptionId))
  add(path_569630, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_569630, "resourceName", newJString(resourceName))
  result = call_569629.call(path_569630, query_569631, nil, nil, nil)

var replicationRecoveryPlansGet* = Call_ReplicationRecoveryPlansGet_569620(
    name: "replicationRecoveryPlansGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}",
    validator: validate_ReplicationRecoveryPlansGet_569621, base: "",
    url: url_ReplicationRecoveryPlansGet_569622, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansUpdate_569658 = ref object of OpenApiRestCall_567668
proc url_ReplicationRecoveryPlansUpdate_569660(protocol: Scheme; host: string;
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

proc validate_ReplicationRecoveryPlansUpdate_569659(path: JsonNode;
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
  var valid_569661 = path.getOrDefault("resourceGroupName")
  valid_569661 = validateParameter(valid_569661, JString, required = true,
                                 default = nil)
  if valid_569661 != nil:
    section.add "resourceGroupName", valid_569661
  var valid_569662 = path.getOrDefault("subscriptionId")
  valid_569662 = validateParameter(valid_569662, JString, required = true,
                                 default = nil)
  if valid_569662 != nil:
    section.add "subscriptionId", valid_569662
  var valid_569663 = path.getOrDefault("recoveryPlanName")
  valid_569663 = validateParameter(valid_569663, JString, required = true,
                                 default = nil)
  if valid_569663 != nil:
    section.add "recoveryPlanName", valid_569663
  var valid_569664 = path.getOrDefault("resourceName")
  valid_569664 = validateParameter(valid_569664, JString, required = true,
                                 default = nil)
  if valid_569664 != nil:
    section.add "resourceName", valid_569664
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569665 = query.getOrDefault("api-version")
  valid_569665 = validateParameter(valid_569665, JString, required = true,
                                 default = nil)
  if valid_569665 != nil:
    section.add "api-version", valid_569665
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

proc call*(call_569667: Call_ReplicationRecoveryPlansUpdate_569658; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a recovery plan.
  ## 
  let valid = call_569667.validator(path, query, header, formData, body)
  let scheme = call_569667.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569667.url(scheme.get, call_569667.host, call_569667.base,
                         call_569667.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569667, url, valid)

proc call*(call_569668: Call_ReplicationRecoveryPlansUpdate_569658;
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
  var path_569669 = newJObject()
  var query_569670 = newJObject()
  var body_569671 = newJObject()
  add(path_569669, "resourceGroupName", newJString(resourceGroupName))
  add(query_569670, "api-version", newJString(apiVersion))
  add(path_569669, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_569671 = input
  add(path_569669, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_569669, "resourceName", newJString(resourceName))
  result = call_569668.call(path_569669, query_569670, nil, nil, body_569671)

var replicationRecoveryPlansUpdate* = Call_ReplicationRecoveryPlansUpdate_569658(
    name: "replicationRecoveryPlansUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}",
    validator: validate_ReplicationRecoveryPlansUpdate_569659, base: "",
    url: url_ReplicationRecoveryPlansUpdate_569660, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansDelete_569646 = ref object of OpenApiRestCall_567668
proc url_ReplicationRecoveryPlansDelete_569648(protocol: Scheme; host: string;
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

proc validate_ReplicationRecoveryPlansDelete_569647(path: JsonNode;
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
  var valid_569649 = path.getOrDefault("resourceGroupName")
  valid_569649 = validateParameter(valid_569649, JString, required = true,
                                 default = nil)
  if valid_569649 != nil:
    section.add "resourceGroupName", valid_569649
  var valid_569650 = path.getOrDefault("subscriptionId")
  valid_569650 = validateParameter(valid_569650, JString, required = true,
                                 default = nil)
  if valid_569650 != nil:
    section.add "subscriptionId", valid_569650
  var valid_569651 = path.getOrDefault("recoveryPlanName")
  valid_569651 = validateParameter(valid_569651, JString, required = true,
                                 default = nil)
  if valid_569651 != nil:
    section.add "recoveryPlanName", valid_569651
  var valid_569652 = path.getOrDefault("resourceName")
  valid_569652 = validateParameter(valid_569652, JString, required = true,
                                 default = nil)
  if valid_569652 != nil:
    section.add "resourceName", valid_569652
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569653 = query.getOrDefault("api-version")
  valid_569653 = validateParameter(valid_569653, JString, required = true,
                                 default = nil)
  if valid_569653 != nil:
    section.add "api-version", valid_569653
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569654: Call_ReplicationRecoveryPlansDelete_569646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a recovery plan.
  ## 
  let valid = call_569654.validator(path, query, header, formData, body)
  let scheme = call_569654.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569654.url(scheme.get, call_569654.host, call_569654.base,
                         call_569654.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569654, url, valid)

proc call*(call_569655: Call_ReplicationRecoveryPlansDelete_569646;
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
  var path_569656 = newJObject()
  var query_569657 = newJObject()
  add(path_569656, "resourceGroupName", newJString(resourceGroupName))
  add(query_569657, "api-version", newJString(apiVersion))
  add(path_569656, "subscriptionId", newJString(subscriptionId))
  add(path_569656, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_569656, "resourceName", newJString(resourceName))
  result = call_569655.call(path_569656, query_569657, nil, nil, nil)

var replicationRecoveryPlansDelete* = Call_ReplicationRecoveryPlansDelete_569646(
    name: "replicationRecoveryPlansDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}",
    validator: validate_ReplicationRecoveryPlansDelete_569647, base: "",
    url: url_ReplicationRecoveryPlansDelete_569648, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansFailoverCommit_569672 = ref object of OpenApiRestCall_567668
proc url_ReplicationRecoveryPlansFailoverCommit_569674(protocol: Scheme;
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

proc validate_ReplicationRecoveryPlansFailoverCommit_569673(path: JsonNode;
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
  var valid_569675 = path.getOrDefault("resourceGroupName")
  valid_569675 = validateParameter(valid_569675, JString, required = true,
                                 default = nil)
  if valid_569675 != nil:
    section.add "resourceGroupName", valid_569675
  var valid_569676 = path.getOrDefault("subscriptionId")
  valid_569676 = validateParameter(valid_569676, JString, required = true,
                                 default = nil)
  if valid_569676 != nil:
    section.add "subscriptionId", valid_569676
  var valid_569677 = path.getOrDefault("recoveryPlanName")
  valid_569677 = validateParameter(valid_569677, JString, required = true,
                                 default = nil)
  if valid_569677 != nil:
    section.add "recoveryPlanName", valid_569677
  var valid_569678 = path.getOrDefault("resourceName")
  valid_569678 = validateParameter(valid_569678, JString, required = true,
                                 default = nil)
  if valid_569678 != nil:
    section.add "resourceName", valid_569678
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569679 = query.getOrDefault("api-version")
  valid_569679 = validateParameter(valid_569679, JString, required = true,
                                 default = nil)
  if valid_569679 != nil:
    section.add "api-version", valid_569679
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569680: Call_ReplicationRecoveryPlansFailoverCommit_569672;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to commit the fail over of a recovery plan.
  ## 
  let valid = call_569680.validator(path, query, header, formData, body)
  let scheme = call_569680.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569680.url(scheme.get, call_569680.host, call_569680.base,
                         call_569680.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569680, url, valid)

proc call*(call_569681: Call_ReplicationRecoveryPlansFailoverCommit_569672;
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
  var path_569682 = newJObject()
  var query_569683 = newJObject()
  add(path_569682, "resourceGroupName", newJString(resourceGroupName))
  add(query_569683, "api-version", newJString(apiVersion))
  add(path_569682, "subscriptionId", newJString(subscriptionId))
  add(path_569682, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_569682, "resourceName", newJString(resourceName))
  result = call_569681.call(path_569682, query_569683, nil, nil, nil)

var replicationRecoveryPlansFailoverCommit* = Call_ReplicationRecoveryPlansFailoverCommit_569672(
    name: "replicationRecoveryPlansFailoverCommit", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/failoverCommit",
    validator: validate_ReplicationRecoveryPlansFailoverCommit_569673, base: "",
    url: url_ReplicationRecoveryPlansFailoverCommit_569674,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansPlannedFailover_569684 = ref object of OpenApiRestCall_567668
proc url_ReplicationRecoveryPlansPlannedFailover_569686(protocol: Scheme;
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

proc validate_ReplicationRecoveryPlansPlannedFailover_569685(path: JsonNode;
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
  var valid_569687 = path.getOrDefault("resourceGroupName")
  valid_569687 = validateParameter(valid_569687, JString, required = true,
                                 default = nil)
  if valid_569687 != nil:
    section.add "resourceGroupName", valid_569687
  var valid_569688 = path.getOrDefault("subscriptionId")
  valid_569688 = validateParameter(valid_569688, JString, required = true,
                                 default = nil)
  if valid_569688 != nil:
    section.add "subscriptionId", valid_569688
  var valid_569689 = path.getOrDefault("recoveryPlanName")
  valid_569689 = validateParameter(valid_569689, JString, required = true,
                                 default = nil)
  if valid_569689 != nil:
    section.add "recoveryPlanName", valid_569689
  var valid_569690 = path.getOrDefault("resourceName")
  valid_569690 = validateParameter(valid_569690, JString, required = true,
                                 default = nil)
  if valid_569690 != nil:
    section.add "resourceName", valid_569690
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569691 = query.getOrDefault("api-version")
  valid_569691 = validateParameter(valid_569691, JString, required = true,
                                 default = nil)
  if valid_569691 != nil:
    section.add "api-version", valid_569691
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

proc call*(call_569693: Call_ReplicationRecoveryPlansPlannedFailover_569684;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to start the planned failover of a recovery plan.
  ## 
  let valid = call_569693.validator(path, query, header, formData, body)
  let scheme = call_569693.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569693.url(scheme.get, call_569693.host, call_569693.base,
                         call_569693.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569693, url, valid)

proc call*(call_569694: Call_ReplicationRecoveryPlansPlannedFailover_569684;
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
  var path_569695 = newJObject()
  var query_569696 = newJObject()
  var body_569697 = newJObject()
  add(path_569695, "resourceGroupName", newJString(resourceGroupName))
  add(query_569696, "api-version", newJString(apiVersion))
  add(path_569695, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_569697 = input
  add(path_569695, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_569695, "resourceName", newJString(resourceName))
  result = call_569694.call(path_569695, query_569696, nil, nil, body_569697)

var replicationRecoveryPlansPlannedFailover* = Call_ReplicationRecoveryPlansPlannedFailover_569684(
    name: "replicationRecoveryPlansPlannedFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/plannedFailover",
    validator: validate_ReplicationRecoveryPlansPlannedFailover_569685, base: "",
    url: url_ReplicationRecoveryPlansPlannedFailover_569686,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansReprotect_569698 = ref object of OpenApiRestCall_567668
proc url_ReplicationRecoveryPlansReprotect_569700(protocol: Scheme; host: string;
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

proc validate_ReplicationRecoveryPlansReprotect_569699(path: JsonNode;
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
  var valid_569701 = path.getOrDefault("resourceGroupName")
  valid_569701 = validateParameter(valid_569701, JString, required = true,
                                 default = nil)
  if valid_569701 != nil:
    section.add "resourceGroupName", valid_569701
  var valid_569702 = path.getOrDefault("subscriptionId")
  valid_569702 = validateParameter(valid_569702, JString, required = true,
                                 default = nil)
  if valid_569702 != nil:
    section.add "subscriptionId", valid_569702
  var valid_569703 = path.getOrDefault("recoveryPlanName")
  valid_569703 = validateParameter(valid_569703, JString, required = true,
                                 default = nil)
  if valid_569703 != nil:
    section.add "recoveryPlanName", valid_569703
  var valid_569704 = path.getOrDefault("resourceName")
  valid_569704 = validateParameter(valid_569704, JString, required = true,
                                 default = nil)
  if valid_569704 != nil:
    section.add "resourceName", valid_569704
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569705 = query.getOrDefault("api-version")
  valid_569705 = validateParameter(valid_569705, JString, required = true,
                                 default = nil)
  if valid_569705 != nil:
    section.add "api-version", valid_569705
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569706: Call_ReplicationRecoveryPlansReprotect_569698;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to reprotect(reverse replicate) a recovery plan.
  ## 
  let valid = call_569706.validator(path, query, header, formData, body)
  let scheme = call_569706.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569706.url(scheme.get, call_569706.host, call_569706.base,
                         call_569706.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569706, url, valid)

proc call*(call_569707: Call_ReplicationRecoveryPlansReprotect_569698;
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
  var path_569708 = newJObject()
  var query_569709 = newJObject()
  add(path_569708, "resourceGroupName", newJString(resourceGroupName))
  add(query_569709, "api-version", newJString(apiVersion))
  add(path_569708, "subscriptionId", newJString(subscriptionId))
  add(path_569708, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_569708, "resourceName", newJString(resourceName))
  result = call_569707.call(path_569708, query_569709, nil, nil, nil)

var replicationRecoveryPlansReprotect* = Call_ReplicationRecoveryPlansReprotect_569698(
    name: "replicationRecoveryPlansReprotect", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/reProtect",
    validator: validate_ReplicationRecoveryPlansReprotect_569699, base: "",
    url: url_ReplicationRecoveryPlansReprotect_569700, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansTestFailover_569710 = ref object of OpenApiRestCall_567668
proc url_ReplicationRecoveryPlansTestFailover_569712(protocol: Scheme;
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

proc validate_ReplicationRecoveryPlansTestFailover_569711(path: JsonNode;
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
  var valid_569713 = path.getOrDefault("resourceGroupName")
  valid_569713 = validateParameter(valid_569713, JString, required = true,
                                 default = nil)
  if valid_569713 != nil:
    section.add "resourceGroupName", valid_569713
  var valid_569714 = path.getOrDefault("subscriptionId")
  valid_569714 = validateParameter(valid_569714, JString, required = true,
                                 default = nil)
  if valid_569714 != nil:
    section.add "subscriptionId", valid_569714
  var valid_569715 = path.getOrDefault("recoveryPlanName")
  valid_569715 = validateParameter(valid_569715, JString, required = true,
                                 default = nil)
  if valid_569715 != nil:
    section.add "recoveryPlanName", valid_569715
  var valid_569716 = path.getOrDefault("resourceName")
  valid_569716 = validateParameter(valid_569716, JString, required = true,
                                 default = nil)
  if valid_569716 != nil:
    section.add "resourceName", valid_569716
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569717 = query.getOrDefault("api-version")
  valid_569717 = validateParameter(valid_569717, JString, required = true,
                                 default = nil)
  if valid_569717 != nil:
    section.add "api-version", valid_569717
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

proc call*(call_569719: Call_ReplicationRecoveryPlansTestFailover_569710;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to start the test failover of a recovery plan.
  ## 
  let valid = call_569719.validator(path, query, header, formData, body)
  let scheme = call_569719.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569719.url(scheme.get, call_569719.host, call_569719.base,
                         call_569719.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569719, url, valid)

proc call*(call_569720: Call_ReplicationRecoveryPlansTestFailover_569710;
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
  var path_569721 = newJObject()
  var query_569722 = newJObject()
  var body_569723 = newJObject()
  add(path_569721, "resourceGroupName", newJString(resourceGroupName))
  add(query_569722, "api-version", newJString(apiVersion))
  add(path_569721, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_569723 = input
  add(path_569721, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_569721, "resourceName", newJString(resourceName))
  result = call_569720.call(path_569721, query_569722, nil, nil, body_569723)

var replicationRecoveryPlansTestFailover* = Call_ReplicationRecoveryPlansTestFailover_569710(
    name: "replicationRecoveryPlansTestFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/testFailover",
    validator: validate_ReplicationRecoveryPlansTestFailover_569711, base: "",
    url: url_ReplicationRecoveryPlansTestFailover_569712, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansTestFailoverCleanup_569724 = ref object of OpenApiRestCall_567668
proc url_ReplicationRecoveryPlansTestFailoverCleanup_569726(protocol: Scheme;
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

proc validate_ReplicationRecoveryPlansTestFailoverCleanup_569725(path: JsonNode;
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
  var valid_569727 = path.getOrDefault("resourceGroupName")
  valid_569727 = validateParameter(valid_569727, JString, required = true,
                                 default = nil)
  if valid_569727 != nil:
    section.add "resourceGroupName", valid_569727
  var valid_569728 = path.getOrDefault("subscriptionId")
  valid_569728 = validateParameter(valid_569728, JString, required = true,
                                 default = nil)
  if valid_569728 != nil:
    section.add "subscriptionId", valid_569728
  var valid_569729 = path.getOrDefault("recoveryPlanName")
  valid_569729 = validateParameter(valid_569729, JString, required = true,
                                 default = nil)
  if valid_569729 != nil:
    section.add "recoveryPlanName", valid_569729
  var valid_569730 = path.getOrDefault("resourceName")
  valid_569730 = validateParameter(valid_569730, JString, required = true,
                                 default = nil)
  if valid_569730 != nil:
    section.add "resourceName", valid_569730
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569731 = query.getOrDefault("api-version")
  valid_569731 = validateParameter(valid_569731, JString, required = true,
                                 default = nil)
  if valid_569731 != nil:
    section.add "api-version", valid_569731
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

proc call*(call_569733: Call_ReplicationRecoveryPlansTestFailoverCleanup_569724;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to cleanup test failover of a recovery plan.
  ## 
  let valid = call_569733.validator(path, query, header, formData, body)
  let scheme = call_569733.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569733.url(scheme.get, call_569733.host, call_569733.base,
                         call_569733.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569733, url, valid)

proc call*(call_569734: Call_ReplicationRecoveryPlansTestFailoverCleanup_569724;
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
  var path_569735 = newJObject()
  var query_569736 = newJObject()
  var body_569737 = newJObject()
  add(path_569735, "resourceGroupName", newJString(resourceGroupName))
  add(query_569736, "api-version", newJString(apiVersion))
  add(path_569735, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_569737 = input
  add(path_569735, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_569735, "resourceName", newJString(resourceName))
  result = call_569734.call(path_569735, query_569736, nil, nil, body_569737)

var replicationRecoveryPlansTestFailoverCleanup* = Call_ReplicationRecoveryPlansTestFailoverCleanup_569724(
    name: "replicationRecoveryPlansTestFailoverCleanup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/testFailoverCleanup",
    validator: validate_ReplicationRecoveryPlansTestFailoverCleanup_569725,
    base: "", url: url_ReplicationRecoveryPlansTestFailoverCleanup_569726,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansUnplannedFailover_569738 = ref object of OpenApiRestCall_567668
proc url_ReplicationRecoveryPlansUnplannedFailover_569740(protocol: Scheme;
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

proc validate_ReplicationRecoveryPlansUnplannedFailover_569739(path: JsonNode;
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
  var valid_569741 = path.getOrDefault("resourceGroupName")
  valid_569741 = validateParameter(valid_569741, JString, required = true,
                                 default = nil)
  if valid_569741 != nil:
    section.add "resourceGroupName", valid_569741
  var valid_569742 = path.getOrDefault("subscriptionId")
  valid_569742 = validateParameter(valid_569742, JString, required = true,
                                 default = nil)
  if valid_569742 != nil:
    section.add "subscriptionId", valid_569742
  var valid_569743 = path.getOrDefault("recoveryPlanName")
  valid_569743 = validateParameter(valid_569743, JString, required = true,
                                 default = nil)
  if valid_569743 != nil:
    section.add "recoveryPlanName", valid_569743
  var valid_569744 = path.getOrDefault("resourceName")
  valid_569744 = validateParameter(valid_569744, JString, required = true,
                                 default = nil)
  if valid_569744 != nil:
    section.add "resourceName", valid_569744
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569745 = query.getOrDefault("api-version")
  valid_569745 = validateParameter(valid_569745, JString, required = true,
                                 default = nil)
  if valid_569745 != nil:
    section.add "api-version", valid_569745
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

proc call*(call_569747: Call_ReplicationRecoveryPlansUnplannedFailover_569738;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to start the failover of a recovery plan.
  ## 
  let valid = call_569747.validator(path, query, header, formData, body)
  let scheme = call_569747.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569747.url(scheme.get, call_569747.host, call_569747.base,
                         call_569747.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569747, url, valid)

proc call*(call_569748: Call_ReplicationRecoveryPlansUnplannedFailover_569738;
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
  var path_569749 = newJObject()
  var query_569750 = newJObject()
  var body_569751 = newJObject()
  add(path_569749, "resourceGroupName", newJString(resourceGroupName))
  add(query_569750, "api-version", newJString(apiVersion))
  add(path_569749, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_569751 = input
  add(path_569749, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_569749, "resourceName", newJString(resourceName))
  result = call_569748.call(path_569749, query_569750, nil, nil, body_569751)

var replicationRecoveryPlansUnplannedFailover* = Call_ReplicationRecoveryPlansUnplannedFailover_569738(
    name: "replicationRecoveryPlansUnplannedFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/unplannedFailover",
    validator: validate_ReplicationRecoveryPlansUnplannedFailover_569739,
    base: "", url: url_ReplicationRecoveryPlansUnplannedFailover_569740,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersList_569752 = ref object of OpenApiRestCall_567668
proc url_ReplicationRecoveryServicesProvidersList_569754(protocol: Scheme;
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

proc validate_ReplicationRecoveryServicesProvidersList_569753(path: JsonNode;
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
  var valid_569755 = path.getOrDefault("resourceGroupName")
  valid_569755 = validateParameter(valid_569755, JString, required = true,
                                 default = nil)
  if valid_569755 != nil:
    section.add "resourceGroupName", valid_569755
  var valid_569756 = path.getOrDefault("subscriptionId")
  valid_569756 = validateParameter(valid_569756, JString, required = true,
                                 default = nil)
  if valid_569756 != nil:
    section.add "subscriptionId", valid_569756
  var valid_569757 = path.getOrDefault("resourceName")
  valid_569757 = validateParameter(valid_569757, JString, required = true,
                                 default = nil)
  if valid_569757 != nil:
    section.add "resourceName", valid_569757
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569758 = query.getOrDefault("api-version")
  valid_569758 = validateParameter(valid_569758, JString, required = true,
                                 default = nil)
  if valid_569758 != nil:
    section.add "api-version", valid_569758
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569759: Call_ReplicationRecoveryServicesProvidersList_569752;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the registered recovery services providers in the vault
  ## 
  let valid = call_569759.validator(path, query, header, formData, body)
  let scheme = call_569759.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569759.url(scheme.get, call_569759.host, call_569759.base,
                         call_569759.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569759, url, valid)

proc call*(call_569760: Call_ReplicationRecoveryServicesProvidersList_569752;
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
  var path_569761 = newJObject()
  var query_569762 = newJObject()
  add(path_569761, "resourceGroupName", newJString(resourceGroupName))
  add(query_569762, "api-version", newJString(apiVersion))
  add(path_569761, "subscriptionId", newJString(subscriptionId))
  add(path_569761, "resourceName", newJString(resourceName))
  result = call_569760.call(path_569761, query_569762, nil, nil, nil)

var replicationRecoveryServicesProvidersList* = Call_ReplicationRecoveryServicesProvidersList_569752(
    name: "replicationRecoveryServicesProvidersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryServicesProviders",
    validator: validate_ReplicationRecoveryServicesProvidersList_569753, base: "",
    url: url_ReplicationRecoveryServicesProvidersList_569754,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsList_569763 = ref object of OpenApiRestCall_567668
proc url_ReplicationStorageClassificationMappingsList_569765(protocol: Scheme;
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

proc validate_ReplicationStorageClassificationMappingsList_569764(path: JsonNode;
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
  var valid_569766 = path.getOrDefault("resourceGroupName")
  valid_569766 = validateParameter(valid_569766, JString, required = true,
                                 default = nil)
  if valid_569766 != nil:
    section.add "resourceGroupName", valid_569766
  var valid_569767 = path.getOrDefault("subscriptionId")
  valid_569767 = validateParameter(valid_569767, JString, required = true,
                                 default = nil)
  if valid_569767 != nil:
    section.add "subscriptionId", valid_569767
  var valid_569768 = path.getOrDefault("resourceName")
  valid_569768 = validateParameter(valid_569768, JString, required = true,
                                 default = nil)
  if valid_569768 != nil:
    section.add "resourceName", valid_569768
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569769 = query.getOrDefault("api-version")
  valid_569769 = validateParameter(valid_569769, JString, required = true,
                                 default = nil)
  if valid_569769 != nil:
    section.add "api-version", valid_569769
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569770: Call_ReplicationStorageClassificationMappingsList_569763;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the storage classification mappings in the vault.
  ## 
  let valid = call_569770.validator(path, query, header, formData, body)
  let scheme = call_569770.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569770.url(scheme.get, call_569770.host, call_569770.base,
                         call_569770.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569770, url, valid)

proc call*(call_569771: Call_ReplicationStorageClassificationMappingsList_569763;
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
  var path_569772 = newJObject()
  var query_569773 = newJObject()
  add(path_569772, "resourceGroupName", newJString(resourceGroupName))
  add(query_569773, "api-version", newJString(apiVersion))
  add(path_569772, "subscriptionId", newJString(subscriptionId))
  add(path_569772, "resourceName", newJString(resourceName))
  result = call_569771.call(path_569772, query_569773, nil, nil, nil)

var replicationStorageClassificationMappingsList* = Call_ReplicationStorageClassificationMappingsList_569763(
    name: "replicationStorageClassificationMappingsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationStorageClassificationMappings",
    validator: validate_ReplicationStorageClassificationMappingsList_569764,
    base: "", url: url_ReplicationStorageClassificationMappingsList_569765,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationsList_569774 = ref object of OpenApiRestCall_567668
proc url_ReplicationStorageClassificationsList_569776(protocol: Scheme;
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

proc validate_ReplicationStorageClassificationsList_569775(path: JsonNode;
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
  var valid_569777 = path.getOrDefault("resourceGroupName")
  valid_569777 = validateParameter(valid_569777, JString, required = true,
                                 default = nil)
  if valid_569777 != nil:
    section.add "resourceGroupName", valid_569777
  var valid_569778 = path.getOrDefault("subscriptionId")
  valid_569778 = validateParameter(valid_569778, JString, required = true,
                                 default = nil)
  if valid_569778 != nil:
    section.add "subscriptionId", valid_569778
  var valid_569779 = path.getOrDefault("resourceName")
  valid_569779 = validateParameter(valid_569779, JString, required = true,
                                 default = nil)
  if valid_569779 != nil:
    section.add "resourceName", valid_569779
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569780 = query.getOrDefault("api-version")
  valid_569780 = validateParameter(valid_569780, JString, required = true,
                                 default = nil)
  if valid_569780 != nil:
    section.add "api-version", valid_569780
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569781: Call_ReplicationStorageClassificationsList_569774;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the storage classifications in the vault.
  ## 
  let valid = call_569781.validator(path, query, header, formData, body)
  let scheme = call_569781.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569781.url(scheme.get, call_569781.host, call_569781.base,
                         call_569781.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569781, url, valid)

proc call*(call_569782: Call_ReplicationStorageClassificationsList_569774;
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
  var path_569783 = newJObject()
  var query_569784 = newJObject()
  add(path_569783, "resourceGroupName", newJString(resourceGroupName))
  add(query_569784, "api-version", newJString(apiVersion))
  add(path_569783, "subscriptionId", newJString(subscriptionId))
  add(path_569783, "resourceName", newJString(resourceName))
  result = call_569782.call(path_569783, query_569784, nil, nil, nil)

var replicationStorageClassificationsList* = Call_ReplicationStorageClassificationsList_569774(
    name: "replicationStorageClassificationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationStorageClassifications",
    validator: validate_ReplicationStorageClassificationsList_569775, base: "",
    url: url_ReplicationStorageClassificationsList_569776, schemes: {Scheme.Https})
type
  Call_SupportedOperatingSystemsGet_569785 = ref object of OpenApiRestCall_567668
proc url_SupportedOperatingSystemsGet_569787(protocol: Scheme; host: string;
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

proc validate_SupportedOperatingSystemsGet_569786(path: JsonNode; query: JsonNode;
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
  var valid_569788 = path.getOrDefault("resourceGroupName")
  valid_569788 = validateParameter(valid_569788, JString, required = true,
                                 default = nil)
  if valid_569788 != nil:
    section.add "resourceGroupName", valid_569788
  var valid_569789 = path.getOrDefault("subscriptionId")
  valid_569789 = validateParameter(valid_569789, JString, required = true,
                                 default = nil)
  if valid_569789 != nil:
    section.add "subscriptionId", valid_569789
  var valid_569790 = path.getOrDefault("resourceName")
  valid_569790 = validateParameter(valid_569790, JString, required = true,
                                 default = nil)
  if valid_569790 != nil:
    section.add "resourceName", valid_569790
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569791 = query.getOrDefault("api-version")
  valid_569791 = validateParameter(valid_569791, JString, required = true,
                                 default = nil)
  if valid_569791 != nil:
    section.add "api-version", valid_569791
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569792: Call_SupportedOperatingSystemsGet_569785; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569792.validator(path, query, header, formData, body)
  let scheme = call_569792.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569792.url(scheme.get, call_569792.host, call_569792.base,
                         call_569792.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569792, url, valid)

proc call*(call_569793: Call_SupportedOperatingSystemsGet_569785;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## supportedOperatingSystemsGet
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_569794 = newJObject()
  var query_569795 = newJObject()
  add(path_569794, "resourceGroupName", newJString(resourceGroupName))
  add(query_569795, "api-version", newJString(apiVersion))
  add(path_569794, "subscriptionId", newJString(subscriptionId))
  add(path_569794, "resourceName", newJString(resourceName))
  result = call_569793.call(path_569794, query_569795, nil, nil, nil)

var supportedOperatingSystemsGet* = Call_SupportedOperatingSystemsGet_569785(
    name: "supportedOperatingSystemsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationSupportedOperatingSystems",
    validator: validate_SupportedOperatingSystemsGet_569786, base: "",
    url: url_SupportedOperatingSystemsGet_569787, schemes: {Scheme.Https})
type
  Call_ReplicationVaultHealthGet_569796 = ref object of OpenApiRestCall_567668
proc url_ReplicationVaultHealthGet_569798(protocol: Scheme; host: string;
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

proc validate_ReplicationVaultHealthGet_569797(path: JsonNode; query: JsonNode;
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
  var valid_569799 = path.getOrDefault("resourceGroupName")
  valid_569799 = validateParameter(valid_569799, JString, required = true,
                                 default = nil)
  if valid_569799 != nil:
    section.add "resourceGroupName", valid_569799
  var valid_569800 = path.getOrDefault("subscriptionId")
  valid_569800 = validateParameter(valid_569800, JString, required = true,
                                 default = nil)
  if valid_569800 != nil:
    section.add "subscriptionId", valid_569800
  var valid_569801 = path.getOrDefault("resourceName")
  valid_569801 = validateParameter(valid_569801, JString, required = true,
                                 default = nil)
  if valid_569801 != nil:
    section.add "resourceName", valid_569801
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569802 = query.getOrDefault("api-version")
  valid_569802 = validateParameter(valid_569802, JString, required = true,
                                 default = nil)
  if valid_569802 != nil:
    section.add "api-version", valid_569802
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569803: Call_ReplicationVaultHealthGet_569796; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health details of the vault.
  ## 
  let valid = call_569803.validator(path, query, header, formData, body)
  let scheme = call_569803.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569803.url(scheme.get, call_569803.host, call_569803.base,
                         call_569803.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569803, url, valid)

proc call*(call_569804: Call_ReplicationVaultHealthGet_569796;
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
  var path_569805 = newJObject()
  var query_569806 = newJObject()
  add(path_569805, "resourceGroupName", newJString(resourceGroupName))
  add(query_569806, "api-version", newJString(apiVersion))
  add(path_569805, "subscriptionId", newJString(subscriptionId))
  add(path_569805, "resourceName", newJString(resourceName))
  result = call_569804.call(path_569805, query_569806, nil, nil, nil)

var replicationVaultHealthGet* = Call_ReplicationVaultHealthGet_569796(
    name: "replicationVaultHealthGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationVaultHealth",
    validator: validate_ReplicationVaultHealthGet_569797, base: "",
    url: url_ReplicationVaultHealthGet_569798, schemes: {Scheme.Https})
type
  Call_ReplicationVaultHealthRefresh_569807 = ref object of OpenApiRestCall_567668
proc url_ReplicationVaultHealthRefresh_569809(protocol: Scheme; host: string;
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

proc validate_ReplicationVaultHealthRefresh_569808(path: JsonNode; query: JsonNode;
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
  var valid_569810 = path.getOrDefault("resourceGroupName")
  valid_569810 = validateParameter(valid_569810, JString, required = true,
                                 default = nil)
  if valid_569810 != nil:
    section.add "resourceGroupName", valid_569810
  var valid_569811 = path.getOrDefault("subscriptionId")
  valid_569811 = validateParameter(valid_569811, JString, required = true,
                                 default = nil)
  if valid_569811 != nil:
    section.add "subscriptionId", valid_569811
  var valid_569812 = path.getOrDefault("resourceName")
  valid_569812 = validateParameter(valid_569812, JString, required = true,
                                 default = nil)
  if valid_569812 != nil:
    section.add "resourceName", valid_569812
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569813 = query.getOrDefault("api-version")
  valid_569813 = validateParameter(valid_569813, JString, required = true,
                                 default = nil)
  if valid_569813 != nil:
    section.add "api-version", valid_569813
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569814: Call_ReplicationVaultHealthRefresh_569807; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_569814.validator(path, query, header, formData, body)
  let scheme = call_569814.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569814.url(scheme.get, call_569814.host, call_569814.base,
                         call_569814.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569814, url, valid)

proc call*(call_569815: Call_ReplicationVaultHealthRefresh_569807;
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
  var path_569816 = newJObject()
  var query_569817 = newJObject()
  add(path_569816, "resourceGroupName", newJString(resourceGroupName))
  add(query_569817, "api-version", newJString(apiVersion))
  add(path_569816, "subscriptionId", newJString(subscriptionId))
  add(path_569816, "resourceName", newJString(resourceName))
  result = call_569815.call(path_569816, query_569817, nil, nil, nil)

var replicationVaultHealthRefresh* = Call_ReplicationVaultHealthRefresh_569807(
    name: "replicationVaultHealthRefresh", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationVaultHealth/default/refresh",
    validator: validate_ReplicationVaultHealthRefresh_569808, base: "",
    url: url_ReplicationVaultHealthRefresh_569809, schemes: {Scheme.Https})
type
  Call_ReplicationVaultSettingList_569818 = ref object of OpenApiRestCall_567668
proc url_ReplicationVaultSettingList_569820(protocol: Scheme; host: string;
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

proc validate_ReplicationVaultSettingList_569819(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the list of vault setting. This includes the Migration Hub connection settings.
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
  var valid_569821 = path.getOrDefault("resourceGroupName")
  valid_569821 = validateParameter(valid_569821, JString, required = true,
                                 default = nil)
  if valid_569821 != nil:
    section.add "resourceGroupName", valid_569821
  var valid_569822 = path.getOrDefault("subscriptionId")
  valid_569822 = validateParameter(valid_569822, JString, required = true,
                                 default = nil)
  if valid_569822 != nil:
    section.add "subscriptionId", valid_569822
  var valid_569823 = path.getOrDefault("resourceName")
  valid_569823 = validateParameter(valid_569823, JString, required = true,
                                 default = nil)
  if valid_569823 != nil:
    section.add "resourceName", valid_569823
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569824 = query.getOrDefault("api-version")
  valid_569824 = validateParameter(valid_569824, JString, required = true,
                                 default = nil)
  if valid_569824 != nil:
    section.add "api-version", valid_569824
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569825: Call_ReplicationVaultSettingList_569818; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of vault setting. This includes the Migration Hub connection settings.
  ## 
  let valid = call_569825.validator(path, query, header, formData, body)
  let scheme = call_569825.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569825.url(scheme.get, call_569825.host, call_569825.base,
                         call_569825.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569825, url, valid)

proc call*(call_569826: Call_ReplicationVaultSettingList_569818;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## replicationVaultSettingList
  ## Gets the list of vault setting. This includes the Migration Hub connection settings.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  var path_569827 = newJObject()
  var query_569828 = newJObject()
  add(path_569827, "resourceGroupName", newJString(resourceGroupName))
  add(query_569828, "api-version", newJString(apiVersion))
  add(path_569827, "subscriptionId", newJString(subscriptionId))
  add(path_569827, "resourceName", newJString(resourceName))
  result = call_569826.call(path_569827, query_569828, nil, nil, nil)

var replicationVaultSettingList* = Call_ReplicationVaultSettingList_569818(
    name: "replicationVaultSettingList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationVaultSettings",
    validator: validate_ReplicationVaultSettingList_569819, base: "",
    url: url_ReplicationVaultSettingList_569820, schemes: {Scheme.Https})
type
  Call_ReplicationVaultSettingCreate_569841 = ref object of OpenApiRestCall_567668
proc url_ReplicationVaultSettingCreate_569843(protocol: Scheme; host: string;
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

proc validate_ReplicationVaultSettingCreate_569842(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to configure vault setting.
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
  ##   vaultSettingName: JString (required)
  ##                   : Vault setting name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569844 = path.getOrDefault("resourceGroupName")
  valid_569844 = validateParameter(valid_569844, JString, required = true,
                                 default = nil)
  if valid_569844 != nil:
    section.add "resourceGroupName", valid_569844
  var valid_569845 = path.getOrDefault("subscriptionId")
  valid_569845 = validateParameter(valid_569845, JString, required = true,
                                 default = nil)
  if valid_569845 != nil:
    section.add "subscriptionId", valid_569845
  var valid_569846 = path.getOrDefault("resourceName")
  valid_569846 = validateParameter(valid_569846, JString, required = true,
                                 default = nil)
  if valid_569846 != nil:
    section.add "resourceName", valid_569846
  var valid_569847 = path.getOrDefault("vaultSettingName")
  valid_569847 = validateParameter(valid_569847, JString, required = true,
                                 default = nil)
  if valid_569847 != nil:
    section.add "vaultSettingName", valid_569847
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569848 = query.getOrDefault("api-version")
  valid_569848 = validateParameter(valid_569848, JString, required = true,
                                 default = nil)
  if valid_569848 != nil:
    section.add "api-version", valid_569848
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

proc call*(call_569850: Call_ReplicationVaultSettingCreate_569841; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to configure vault setting.
  ## 
  let valid = call_569850.validator(path, query, header, formData, body)
  let scheme = call_569850.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569850.url(scheme.get, call_569850.host, call_569850.base,
                         call_569850.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569850, url, valid)

proc call*(call_569851: Call_ReplicationVaultSettingCreate_569841;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          input: JsonNode; resourceName: string; vaultSettingName: string): Recallable =
  ## replicationVaultSettingCreate
  ## The operation to configure vault setting.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   input: JObject (required)
  ##        : Vault setting creation input.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   vaultSettingName: string (required)
  ##                   : Vault setting name.
  var path_569852 = newJObject()
  var query_569853 = newJObject()
  var body_569854 = newJObject()
  add(path_569852, "resourceGroupName", newJString(resourceGroupName))
  add(query_569853, "api-version", newJString(apiVersion))
  add(path_569852, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_569854 = input
  add(path_569852, "resourceName", newJString(resourceName))
  add(path_569852, "vaultSettingName", newJString(vaultSettingName))
  result = call_569851.call(path_569852, query_569853, nil, nil, body_569854)

var replicationVaultSettingCreate* = Call_ReplicationVaultSettingCreate_569841(
    name: "replicationVaultSettingCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationVaultSettings/{vaultSettingName}",
    validator: validate_ReplicationVaultSettingCreate_569842, base: "",
    url: url_ReplicationVaultSettingCreate_569843, schemes: {Scheme.Https})
type
  Call_ReplicationVaultSettingGet_569829 = ref object of OpenApiRestCall_567668
proc url_ReplicationVaultSettingGet_569831(protocol: Scheme; host: string;
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

proc validate_ReplicationVaultSettingGet_569830(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the vault setting. This includes the Migration Hub connection settings.
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
  ##   vaultSettingName: JString (required)
  ##                   : Vault setting name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569832 = path.getOrDefault("resourceGroupName")
  valid_569832 = validateParameter(valid_569832, JString, required = true,
                                 default = nil)
  if valid_569832 != nil:
    section.add "resourceGroupName", valid_569832
  var valid_569833 = path.getOrDefault("subscriptionId")
  valid_569833 = validateParameter(valid_569833, JString, required = true,
                                 default = nil)
  if valid_569833 != nil:
    section.add "subscriptionId", valid_569833
  var valid_569834 = path.getOrDefault("resourceName")
  valid_569834 = validateParameter(valid_569834, JString, required = true,
                                 default = nil)
  if valid_569834 != nil:
    section.add "resourceName", valid_569834
  var valid_569835 = path.getOrDefault("vaultSettingName")
  valid_569835 = validateParameter(valid_569835, JString, required = true,
                                 default = nil)
  if valid_569835 != nil:
    section.add "vaultSettingName", valid_569835
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569836 = query.getOrDefault("api-version")
  valid_569836 = validateParameter(valid_569836, JString, required = true,
                                 default = nil)
  if valid_569836 != nil:
    section.add "api-version", valid_569836
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569837: Call_ReplicationVaultSettingGet_569829; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the vault setting. This includes the Migration Hub connection settings.
  ## 
  let valid = call_569837.validator(path, query, header, formData, body)
  let scheme = call_569837.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569837.url(scheme.get, call_569837.host, call_569837.base,
                         call_569837.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569837, url, valid)

proc call*(call_569838: Call_ReplicationVaultSettingGet_569829;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; vaultSettingName: string): Recallable =
  ## replicationVaultSettingGet
  ## Gets the vault setting. This includes the Migration Hub connection settings.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   vaultSettingName: string (required)
  ##                   : Vault setting name.
  var path_569839 = newJObject()
  var query_569840 = newJObject()
  add(path_569839, "resourceGroupName", newJString(resourceGroupName))
  add(query_569840, "api-version", newJString(apiVersion))
  add(path_569839, "subscriptionId", newJString(subscriptionId))
  add(path_569839, "resourceName", newJString(resourceName))
  add(path_569839, "vaultSettingName", newJString(vaultSettingName))
  result = call_569838.call(path_569839, query_569840, nil, nil, nil)

var replicationVaultSettingGet* = Call_ReplicationVaultSettingGet_569829(
    name: "replicationVaultSettingGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationVaultSettings/{vaultSettingName}",
    validator: validate_ReplicationVaultSettingGet_569830, base: "",
    url: url_ReplicationVaultSettingGet_569831, schemes: {Scheme.Https})
type
  Call_ReplicationvCentersList_569855 = ref object of OpenApiRestCall_567668
proc url_ReplicationvCentersList_569857(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationvCentersList_569856(path: JsonNode; query: JsonNode;
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
  var valid_569858 = path.getOrDefault("resourceGroupName")
  valid_569858 = validateParameter(valid_569858, JString, required = true,
                                 default = nil)
  if valid_569858 != nil:
    section.add "resourceGroupName", valid_569858
  var valid_569859 = path.getOrDefault("subscriptionId")
  valid_569859 = validateParameter(valid_569859, JString, required = true,
                                 default = nil)
  if valid_569859 != nil:
    section.add "subscriptionId", valid_569859
  var valid_569860 = path.getOrDefault("resourceName")
  valid_569860 = validateParameter(valid_569860, JString, required = true,
                                 default = nil)
  if valid_569860 != nil:
    section.add "resourceName", valid_569860
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569861 = query.getOrDefault("api-version")
  valid_569861 = validateParameter(valid_569861, JString, required = true,
                                 default = nil)
  if valid_569861 != nil:
    section.add "api-version", valid_569861
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569862: Call_ReplicationvCentersList_569855; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the vCenter servers registered in the vault.
  ## 
  let valid = call_569862.validator(path, query, header, formData, body)
  let scheme = call_569862.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569862.url(scheme.get, call_569862.host, call_569862.base,
                         call_569862.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569862, url, valid)

proc call*(call_569863: Call_ReplicationvCentersList_569855;
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
  var path_569864 = newJObject()
  var query_569865 = newJObject()
  add(path_569864, "resourceGroupName", newJString(resourceGroupName))
  add(query_569865, "api-version", newJString(apiVersion))
  add(path_569864, "subscriptionId", newJString(subscriptionId))
  add(path_569864, "resourceName", newJString(resourceName))
  result = call_569863.call(path_569864, query_569865, nil, nil, nil)

var replicationvCentersList* = Call_ReplicationvCentersList_569855(
    name: "replicationvCentersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationvCenters",
    validator: validate_ReplicationvCentersList_569856, base: "",
    url: url_ReplicationvCentersList_569857, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
