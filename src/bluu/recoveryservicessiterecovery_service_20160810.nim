
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567666 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567666](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567666): Option[Scheme] {.used.} =
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
  Call_OperationsList_567888 = ref object of OpenApiRestCall_567666
proc url_OperationsList_567890(protocol: Scheme; host: string; base: string;
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

proc validate_OperationsList_567889(path: JsonNode; query: JsonNode;
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
  var valid_568063 = path.getOrDefault("resourceGroupName")
  valid_568063 = validateParameter(valid_568063, JString, required = true,
                                 default = nil)
  if valid_568063 != nil:
    section.add "resourceGroupName", valid_568063
  var valid_568064 = path.getOrDefault("subscriptionId")
  valid_568064 = validateParameter(valid_568064, JString, required = true,
                                 default = nil)
  if valid_568064 != nil:
    section.add "subscriptionId", valid_568064
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568065 = query.getOrDefault("api-version")
  valid_568065 = validateParameter(valid_568065, JString, required = true,
                                 default = nil)
  if valid_568065 != nil:
    section.add "api-version", valid_568065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568088: Call_OperationsList_567888; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Operation to return the list of available operations.
  ## 
  let valid = call_568088.validator(path, query, header, formData, body)
  let scheme = call_568088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568088.url(scheme.get, call_568088.host, call_568088.base,
                         call_568088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568088, url, valid)

proc call*(call_568159: Call_OperationsList_567888; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## operationsList
  ## Operation to return the list of available operations.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group where the recovery services vault is present.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The subscription Id.
  var path_568160 = newJObject()
  var query_568162 = newJObject()
  add(path_568160, "resourceGroupName", newJString(resourceGroupName))
  add(query_568162, "api-version", newJString(apiVersion))
  add(path_568160, "subscriptionId", newJString(subscriptionId))
  result = call_568159.call(path_568160, query_568162, nil, nil, nil)

var operationsList* = Call_OperationsList_567888(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/operations",
    validator: validate_OperationsList_567889, base: "", url: url_OperationsList_567890,
    schemes: {Scheme.Https})
type
  Call_ReplicationAlertSettingsList_568201 = ref object of OpenApiRestCall_567666
proc url_ReplicationAlertSettingsList_568203(protocol: Scheme; host: string;
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

proc validate_ReplicationAlertSettingsList_568202(path: JsonNode; query: JsonNode;
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
  var valid_568204 = path.getOrDefault("resourceGroupName")
  valid_568204 = validateParameter(valid_568204, JString, required = true,
                                 default = nil)
  if valid_568204 != nil:
    section.add "resourceGroupName", valid_568204
  var valid_568205 = path.getOrDefault("subscriptionId")
  valid_568205 = validateParameter(valid_568205, JString, required = true,
                                 default = nil)
  if valid_568205 != nil:
    section.add "subscriptionId", valid_568205
  var valid_568206 = path.getOrDefault("resourceName")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "resourceName", valid_568206
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568207 = query.getOrDefault("api-version")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = nil)
  if valid_568207 != nil:
    section.add "api-version", valid_568207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568208: Call_ReplicationAlertSettingsList_568201; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of email notification(alert) configurations for the vault.
  ## 
  let valid = call_568208.validator(path, query, header, formData, body)
  let scheme = call_568208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568208.url(scheme.get, call_568208.host, call_568208.base,
                         call_568208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568208, url, valid)

proc call*(call_568209: Call_ReplicationAlertSettingsList_568201;
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
  var path_568210 = newJObject()
  var query_568211 = newJObject()
  add(path_568210, "resourceGroupName", newJString(resourceGroupName))
  add(query_568211, "api-version", newJString(apiVersion))
  add(path_568210, "subscriptionId", newJString(subscriptionId))
  add(path_568210, "resourceName", newJString(resourceName))
  result = call_568209.call(path_568210, query_568211, nil, nil, nil)

var replicationAlertSettingsList* = Call_ReplicationAlertSettingsList_568201(
    name: "replicationAlertSettingsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationAlertSettings",
    validator: validate_ReplicationAlertSettingsList_568202, base: "",
    url: url_ReplicationAlertSettingsList_568203, schemes: {Scheme.Https})
type
  Call_ReplicationAlertSettingsCreate_568224 = ref object of OpenApiRestCall_567666
proc url_ReplicationAlertSettingsCreate_568226(protocol: Scheme; host: string;
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

proc validate_ReplicationAlertSettingsCreate_568225(path: JsonNode;
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
  var valid_568227 = path.getOrDefault("resourceGroupName")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = nil)
  if valid_568227 != nil:
    section.add "resourceGroupName", valid_568227
  var valid_568228 = path.getOrDefault("alertSettingName")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "alertSettingName", valid_568228
  var valid_568229 = path.getOrDefault("subscriptionId")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "subscriptionId", valid_568229
  var valid_568230 = path.getOrDefault("resourceName")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "resourceName", valid_568230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568231 = query.getOrDefault("api-version")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "api-version", valid_568231
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

proc call*(call_568233: Call_ReplicationAlertSettingsCreate_568224; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an email notification(alert) configuration.
  ## 
  let valid = call_568233.validator(path, query, header, formData, body)
  let scheme = call_568233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568233.url(scheme.get, call_568233.host, call_568233.base,
                         call_568233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568233, url, valid)

proc call*(call_568234: Call_ReplicationAlertSettingsCreate_568224;
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
  var path_568235 = newJObject()
  var query_568236 = newJObject()
  var body_568237 = newJObject()
  add(path_568235, "resourceGroupName", newJString(resourceGroupName))
  add(query_568236, "api-version", newJString(apiVersion))
  add(path_568235, "alertSettingName", newJString(alertSettingName))
  add(path_568235, "subscriptionId", newJString(subscriptionId))
  add(path_568235, "resourceName", newJString(resourceName))
  if request != nil:
    body_568237 = request
  result = call_568234.call(path_568235, query_568236, nil, nil, body_568237)

var replicationAlertSettingsCreate* = Call_ReplicationAlertSettingsCreate_568224(
    name: "replicationAlertSettingsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationAlertSettings/{alertSettingName}",
    validator: validate_ReplicationAlertSettingsCreate_568225, base: "",
    url: url_ReplicationAlertSettingsCreate_568226, schemes: {Scheme.Https})
type
  Call_ReplicationAlertSettingsGet_568212 = ref object of OpenApiRestCall_567666
proc url_ReplicationAlertSettingsGet_568214(protocol: Scheme; host: string;
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

proc validate_ReplicationAlertSettingsGet_568213(path: JsonNode; query: JsonNode;
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
  var valid_568215 = path.getOrDefault("resourceGroupName")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "resourceGroupName", valid_568215
  var valid_568216 = path.getOrDefault("alertSettingName")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "alertSettingName", valid_568216
  var valid_568217 = path.getOrDefault("subscriptionId")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "subscriptionId", valid_568217
  var valid_568218 = path.getOrDefault("resourceName")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "resourceName", valid_568218
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568219 = query.getOrDefault("api-version")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "api-version", valid_568219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568220: Call_ReplicationAlertSettingsGet_568212; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the specified email notification(alert) configuration.
  ## 
  let valid = call_568220.validator(path, query, header, formData, body)
  let scheme = call_568220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568220.url(scheme.get, call_568220.host, call_568220.base,
                         call_568220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568220, url, valid)

proc call*(call_568221: Call_ReplicationAlertSettingsGet_568212;
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
  var path_568222 = newJObject()
  var query_568223 = newJObject()
  add(path_568222, "resourceGroupName", newJString(resourceGroupName))
  add(query_568223, "api-version", newJString(apiVersion))
  add(path_568222, "alertSettingName", newJString(alertSettingName))
  add(path_568222, "subscriptionId", newJString(subscriptionId))
  add(path_568222, "resourceName", newJString(resourceName))
  result = call_568221.call(path_568222, query_568223, nil, nil, nil)

var replicationAlertSettingsGet* = Call_ReplicationAlertSettingsGet_568212(
    name: "replicationAlertSettingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationAlertSettings/{alertSettingName}",
    validator: validate_ReplicationAlertSettingsGet_568213, base: "",
    url: url_ReplicationAlertSettingsGet_568214, schemes: {Scheme.Https})
type
  Call_ReplicationEventsList_568238 = ref object of OpenApiRestCall_567666
proc url_ReplicationEventsList_568240(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationEventsList_568239(path: JsonNode; query: JsonNode;
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
  var valid_568242 = path.getOrDefault("resourceGroupName")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "resourceGroupName", valid_568242
  var valid_568243 = path.getOrDefault("subscriptionId")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "subscriptionId", valid_568243
  var valid_568244 = path.getOrDefault("resourceName")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "resourceName", valid_568244
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568245 = query.getOrDefault("api-version")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "api-version", valid_568245
  var valid_568246 = query.getOrDefault("$filter")
  valid_568246 = validateParameter(valid_568246, JString, required = false,
                                 default = nil)
  if valid_568246 != nil:
    section.add "$filter", valid_568246
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568247: Call_ReplicationEventsList_568238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of Azure Site Recovery events for the vault.
  ## 
  let valid = call_568247.validator(path, query, header, formData, body)
  let scheme = call_568247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568247.url(scheme.get, call_568247.host, call_568247.base,
                         call_568247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568247, url, valid)

proc call*(call_568248: Call_ReplicationEventsList_568238;
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
  var path_568249 = newJObject()
  var query_568250 = newJObject()
  add(path_568249, "resourceGroupName", newJString(resourceGroupName))
  add(query_568250, "api-version", newJString(apiVersion))
  add(path_568249, "subscriptionId", newJString(subscriptionId))
  add(path_568249, "resourceName", newJString(resourceName))
  add(query_568250, "$filter", newJString(Filter))
  result = call_568248.call(path_568249, query_568250, nil, nil, nil)

var replicationEventsList* = Call_ReplicationEventsList_568238(
    name: "replicationEventsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationEvents",
    validator: validate_ReplicationEventsList_568239, base: "",
    url: url_ReplicationEventsList_568240, schemes: {Scheme.Https})
type
  Call_ReplicationEventsGet_568251 = ref object of OpenApiRestCall_567666
proc url_ReplicationEventsGet_568253(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationEventsGet_568252(path: JsonNode; query: JsonNode;
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
  var valid_568254 = path.getOrDefault("resourceGroupName")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "resourceGroupName", valid_568254
  var valid_568255 = path.getOrDefault("subscriptionId")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "subscriptionId", valid_568255
  var valid_568256 = path.getOrDefault("resourceName")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "resourceName", valid_568256
  var valid_568257 = path.getOrDefault("eventName")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "eventName", valid_568257
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568258 = query.getOrDefault("api-version")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "api-version", valid_568258
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568259: Call_ReplicationEventsGet_568251; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to get the details of an Azure Site recovery event.
  ## 
  let valid = call_568259.validator(path, query, header, formData, body)
  let scheme = call_568259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568259.url(scheme.get, call_568259.host, call_568259.base,
                         call_568259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568259, url, valid)

proc call*(call_568260: Call_ReplicationEventsGet_568251;
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
  var path_568261 = newJObject()
  var query_568262 = newJObject()
  add(path_568261, "resourceGroupName", newJString(resourceGroupName))
  add(query_568262, "api-version", newJString(apiVersion))
  add(path_568261, "subscriptionId", newJString(subscriptionId))
  add(path_568261, "resourceName", newJString(resourceName))
  add(path_568261, "eventName", newJString(eventName))
  result = call_568260.call(path_568261, query_568262, nil, nil, nil)

var replicationEventsGet* = Call_ReplicationEventsGet_568251(
    name: "replicationEventsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationEvents/{eventName}",
    validator: validate_ReplicationEventsGet_568252, base: "",
    url: url_ReplicationEventsGet_568253, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsList_568263 = ref object of OpenApiRestCall_567666
proc url_ReplicationFabricsList_568265(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationFabricsList_568264(path: JsonNode; query: JsonNode;
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
  var valid_568266 = path.getOrDefault("resourceGroupName")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "resourceGroupName", valid_568266
  var valid_568267 = path.getOrDefault("subscriptionId")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "subscriptionId", valid_568267
  var valid_568268 = path.getOrDefault("resourceName")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "resourceName", valid_568268
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568269 = query.getOrDefault("api-version")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "api-version", valid_568269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568270: Call_ReplicationFabricsList_568263; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of the Azure Site Recovery fabrics in the vault.
  ## 
  let valid = call_568270.validator(path, query, header, formData, body)
  let scheme = call_568270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568270.url(scheme.get, call_568270.host, call_568270.base,
                         call_568270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568270, url, valid)

proc call*(call_568271: Call_ReplicationFabricsList_568263;
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
  var path_568272 = newJObject()
  var query_568273 = newJObject()
  add(path_568272, "resourceGroupName", newJString(resourceGroupName))
  add(query_568273, "api-version", newJString(apiVersion))
  add(path_568272, "subscriptionId", newJString(subscriptionId))
  add(path_568272, "resourceName", newJString(resourceName))
  result = call_568271.call(path_568272, query_568273, nil, nil, nil)

var replicationFabricsList* = Call_ReplicationFabricsList_568263(
    name: "replicationFabricsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics",
    validator: validate_ReplicationFabricsList_568264, base: "",
    url: url_ReplicationFabricsList_568265, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsCreate_568286 = ref object of OpenApiRestCall_567666
proc url_ReplicationFabricsCreate_568288(protocol: Scheme; host: string;
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

proc validate_ReplicationFabricsCreate_568287(path: JsonNode; query: JsonNode;
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
  var valid_568289 = path.getOrDefault("fabricName")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "fabricName", valid_568289
  var valid_568290 = path.getOrDefault("resourceGroupName")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "resourceGroupName", valid_568290
  var valid_568291 = path.getOrDefault("subscriptionId")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "subscriptionId", valid_568291
  var valid_568292 = path.getOrDefault("resourceName")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "resourceName", valid_568292
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568293 = query.getOrDefault("api-version")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "api-version", valid_568293
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

proc call*(call_568295: Call_ReplicationFabricsCreate_568286; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create an Azure Site Recovery fabric (for e.g. Hyper-V site)
  ## 
  let valid = call_568295.validator(path, query, header, formData, body)
  let scheme = call_568295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568295.url(scheme.get, call_568295.host, call_568295.base,
                         call_568295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568295, url, valid)

proc call*(call_568296: Call_ReplicationFabricsCreate_568286; fabricName: string;
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
  var path_568297 = newJObject()
  var query_568298 = newJObject()
  var body_568299 = newJObject()
  add(path_568297, "fabricName", newJString(fabricName))
  add(path_568297, "resourceGroupName", newJString(resourceGroupName))
  add(query_568298, "api-version", newJString(apiVersion))
  add(path_568297, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_568299 = input
  add(path_568297, "resourceName", newJString(resourceName))
  result = call_568296.call(path_568297, query_568298, nil, nil, body_568299)

var replicationFabricsCreate* = Call_ReplicationFabricsCreate_568286(
    name: "replicationFabricsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}",
    validator: validate_ReplicationFabricsCreate_568287, base: "",
    url: url_ReplicationFabricsCreate_568288, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsGet_568274 = ref object of OpenApiRestCall_567666
proc url_ReplicationFabricsGet_568276(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationFabricsGet_568275(path: JsonNode; query: JsonNode;
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
  var valid_568277 = path.getOrDefault("fabricName")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "fabricName", valid_568277
  var valid_568278 = path.getOrDefault("resourceGroupName")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "resourceGroupName", valid_568278
  var valid_568279 = path.getOrDefault("subscriptionId")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "subscriptionId", valid_568279
  var valid_568280 = path.getOrDefault("resourceName")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "resourceName", valid_568280
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568281 = query.getOrDefault("api-version")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "api-version", valid_568281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568282: Call_ReplicationFabricsGet_568274; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of an Azure Site Recovery fabric.
  ## 
  let valid = call_568282.validator(path, query, header, formData, body)
  let scheme = call_568282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568282.url(scheme.get, call_568282.host, call_568282.base,
                         call_568282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568282, url, valid)

proc call*(call_568283: Call_ReplicationFabricsGet_568274; fabricName: string;
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
  var path_568284 = newJObject()
  var query_568285 = newJObject()
  add(path_568284, "fabricName", newJString(fabricName))
  add(path_568284, "resourceGroupName", newJString(resourceGroupName))
  add(query_568285, "api-version", newJString(apiVersion))
  add(path_568284, "subscriptionId", newJString(subscriptionId))
  add(path_568284, "resourceName", newJString(resourceName))
  result = call_568283.call(path_568284, query_568285, nil, nil, nil)

var replicationFabricsGet* = Call_ReplicationFabricsGet_568274(
    name: "replicationFabricsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}",
    validator: validate_ReplicationFabricsGet_568275, base: "",
    url: url_ReplicationFabricsGet_568276, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsPurge_568300 = ref object of OpenApiRestCall_567666
proc url_ReplicationFabricsPurge_568302(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationFabricsPurge_568301(path: JsonNode; query: JsonNode;
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
  var valid_568303 = path.getOrDefault("fabricName")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "fabricName", valid_568303
  var valid_568304 = path.getOrDefault("resourceGroupName")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "resourceGroupName", valid_568304
  var valid_568305 = path.getOrDefault("subscriptionId")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "subscriptionId", valid_568305
  var valid_568306 = path.getOrDefault("resourceName")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "resourceName", valid_568306
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568307 = query.getOrDefault("api-version")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "api-version", valid_568307
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568308: Call_ReplicationFabricsPurge_568300; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to purge(force delete) an Azure Site Recovery fabric.
  ## 
  let valid = call_568308.validator(path, query, header, formData, body)
  let scheme = call_568308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568308.url(scheme.get, call_568308.host, call_568308.base,
                         call_568308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568308, url, valid)

proc call*(call_568309: Call_ReplicationFabricsPurge_568300; fabricName: string;
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
  var path_568310 = newJObject()
  var query_568311 = newJObject()
  add(path_568310, "fabricName", newJString(fabricName))
  add(path_568310, "resourceGroupName", newJString(resourceGroupName))
  add(query_568311, "api-version", newJString(apiVersion))
  add(path_568310, "subscriptionId", newJString(subscriptionId))
  add(path_568310, "resourceName", newJString(resourceName))
  result = call_568309.call(path_568310, query_568311, nil, nil, nil)

var replicationFabricsPurge* = Call_ReplicationFabricsPurge_568300(
    name: "replicationFabricsPurge", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}",
    validator: validate_ReplicationFabricsPurge_568301, base: "",
    url: url_ReplicationFabricsPurge_568302, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsCheckConsistency_568312 = ref object of OpenApiRestCall_567666
proc url_ReplicationFabricsCheckConsistency_568314(protocol: Scheme; host: string;
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

proc validate_ReplicationFabricsCheckConsistency_568313(path: JsonNode;
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
  var valid_568315 = path.getOrDefault("fabricName")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "fabricName", valid_568315
  var valid_568316 = path.getOrDefault("resourceGroupName")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "resourceGroupName", valid_568316
  var valid_568317 = path.getOrDefault("subscriptionId")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "subscriptionId", valid_568317
  var valid_568318 = path.getOrDefault("resourceName")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "resourceName", valid_568318
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568319 = query.getOrDefault("api-version")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "api-version", valid_568319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568320: Call_ReplicationFabricsCheckConsistency_568312;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to perform a consistency check on the fabric.
  ## 
  let valid = call_568320.validator(path, query, header, formData, body)
  let scheme = call_568320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568320.url(scheme.get, call_568320.host, call_568320.base,
                         call_568320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568320, url, valid)

proc call*(call_568321: Call_ReplicationFabricsCheckConsistency_568312;
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
  var path_568322 = newJObject()
  var query_568323 = newJObject()
  add(path_568322, "fabricName", newJString(fabricName))
  add(path_568322, "resourceGroupName", newJString(resourceGroupName))
  add(query_568323, "api-version", newJString(apiVersion))
  add(path_568322, "subscriptionId", newJString(subscriptionId))
  add(path_568322, "resourceName", newJString(resourceName))
  result = call_568321.call(path_568322, query_568323, nil, nil, nil)

var replicationFabricsCheckConsistency* = Call_ReplicationFabricsCheckConsistency_568312(
    name: "replicationFabricsCheckConsistency", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/checkConsistency",
    validator: validate_ReplicationFabricsCheckConsistency_568313, base: "",
    url: url_ReplicationFabricsCheckConsistency_568314, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsMigrateToAad_568324 = ref object of OpenApiRestCall_567666
proc url_ReplicationFabricsMigrateToAad_568326(protocol: Scheme; host: string;
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

proc validate_ReplicationFabricsMigrateToAad_568325(path: JsonNode;
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
  var valid_568327 = path.getOrDefault("fabricName")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "fabricName", valid_568327
  var valid_568328 = path.getOrDefault("resourceGroupName")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "resourceGroupName", valid_568328
  var valid_568329 = path.getOrDefault("subscriptionId")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "subscriptionId", valid_568329
  var valid_568330 = path.getOrDefault("resourceName")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "resourceName", valid_568330
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568331 = query.getOrDefault("api-version")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "api-version", valid_568331
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568332: Call_ReplicationFabricsMigrateToAad_568324; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to migrate an Azure Site Recovery fabric to AAD.
  ## 
  let valid = call_568332.validator(path, query, header, formData, body)
  let scheme = call_568332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568332.url(scheme.get, call_568332.host, call_568332.base,
                         call_568332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568332, url, valid)

proc call*(call_568333: Call_ReplicationFabricsMigrateToAad_568324;
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
  var path_568334 = newJObject()
  var query_568335 = newJObject()
  add(path_568334, "fabricName", newJString(fabricName))
  add(path_568334, "resourceGroupName", newJString(resourceGroupName))
  add(query_568335, "api-version", newJString(apiVersion))
  add(path_568334, "subscriptionId", newJString(subscriptionId))
  add(path_568334, "resourceName", newJString(resourceName))
  result = call_568333.call(path_568334, query_568335, nil, nil, nil)

var replicationFabricsMigrateToAad* = Call_ReplicationFabricsMigrateToAad_568324(
    name: "replicationFabricsMigrateToAad", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/migratetoaad",
    validator: validate_ReplicationFabricsMigrateToAad_568325, base: "",
    url: url_ReplicationFabricsMigrateToAad_568326, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsReassociateGateway_568336 = ref object of OpenApiRestCall_567666
proc url_ReplicationFabricsReassociateGateway_568338(protocol: Scheme;
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

proc validate_ReplicationFabricsReassociateGateway_568337(path: JsonNode;
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
  var valid_568339 = path.getOrDefault("fabricName")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "fabricName", valid_568339
  var valid_568340 = path.getOrDefault("resourceGroupName")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = nil)
  if valid_568340 != nil:
    section.add "resourceGroupName", valid_568340
  var valid_568341 = path.getOrDefault("subscriptionId")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "subscriptionId", valid_568341
  var valid_568342 = path.getOrDefault("resourceName")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "resourceName", valid_568342
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568343 = query.getOrDefault("api-version")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "api-version", valid_568343
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

proc call*(call_568345: Call_ReplicationFabricsReassociateGateway_568336;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to move replications from a process server to another process server.
  ## 
  let valid = call_568345.validator(path, query, header, formData, body)
  let scheme = call_568345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568345.url(scheme.get, call_568345.host, call_568345.base,
                         call_568345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568345, url, valid)

proc call*(call_568346: Call_ReplicationFabricsReassociateGateway_568336;
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
  var path_568347 = newJObject()
  var query_568348 = newJObject()
  var body_568349 = newJObject()
  add(path_568347, "fabricName", newJString(fabricName))
  add(path_568347, "resourceGroupName", newJString(resourceGroupName))
  add(query_568348, "api-version", newJString(apiVersion))
  if failoverProcessServerRequest != nil:
    body_568349 = failoverProcessServerRequest
  add(path_568347, "subscriptionId", newJString(subscriptionId))
  add(path_568347, "resourceName", newJString(resourceName))
  result = call_568346.call(path_568347, query_568348, nil, nil, body_568349)

var replicationFabricsReassociateGateway* = Call_ReplicationFabricsReassociateGateway_568336(
    name: "replicationFabricsReassociateGateway", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/reassociateGateway",
    validator: validate_ReplicationFabricsReassociateGateway_568337, base: "",
    url: url_ReplicationFabricsReassociateGateway_568338, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsDelete_568350 = ref object of OpenApiRestCall_567666
proc url_ReplicationFabricsDelete_568352(protocol: Scheme; host: string;
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

proc validate_ReplicationFabricsDelete_568351(path: JsonNode; query: JsonNode;
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
  var valid_568353 = path.getOrDefault("fabricName")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "fabricName", valid_568353
  var valid_568354 = path.getOrDefault("resourceGroupName")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "resourceGroupName", valid_568354
  var valid_568355 = path.getOrDefault("subscriptionId")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "subscriptionId", valid_568355
  var valid_568356 = path.getOrDefault("resourceName")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "resourceName", valid_568356
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568357 = query.getOrDefault("api-version")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = nil)
  if valid_568357 != nil:
    section.add "api-version", valid_568357
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568358: Call_ReplicationFabricsDelete_568350; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete or remove an Azure Site Recovery fabric.
  ## 
  let valid = call_568358.validator(path, query, header, formData, body)
  let scheme = call_568358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568358.url(scheme.get, call_568358.host, call_568358.base,
                         call_568358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568358, url, valid)

proc call*(call_568359: Call_ReplicationFabricsDelete_568350; fabricName: string;
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
  var path_568360 = newJObject()
  var query_568361 = newJObject()
  add(path_568360, "fabricName", newJString(fabricName))
  add(path_568360, "resourceGroupName", newJString(resourceGroupName))
  add(query_568361, "api-version", newJString(apiVersion))
  add(path_568360, "subscriptionId", newJString(subscriptionId))
  add(path_568360, "resourceName", newJString(resourceName))
  result = call_568359.call(path_568360, query_568361, nil, nil, nil)

var replicationFabricsDelete* = Call_ReplicationFabricsDelete_568350(
    name: "replicationFabricsDelete", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/remove",
    validator: validate_ReplicationFabricsDelete_568351, base: "",
    url: url_ReplicationFabricsDelete_568352, schemes: {Scheme.Https})
type
  Call_ReplicationFabricsRenewCertificate_568362 = ref object of OpenApiRestCall_567666
proc url_ReplicationFabricsRenewCertificate_568364(protocol: Scheme; host: string;
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

proc validate_ReplicationFabricsRenewCertificate_568363(path: JsonNode;
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
  var valid_568365 = path.getOrDefault("fabricName")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "fabricName", valid_568365
  var valid_568366 = path.getOrDefault("resourceGroupName")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "resourceGroupName", valid_568366
  var valid_568367 = path.getOrDefault("subscriptionId")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "subscriptionId", valid_568367
  var valid_568368 = path.getOrDefault("resourceName")
  valid_568368 = validateParameter(valid_568368, JString, required = true,
                                 default = nil)
  if valid_568368 != nil:
    section.add "resourceName", valid_568368
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568369 = query.getOrDefault("api-version")
  valid_568369 = validateParameter(valid_568369, JString, required = true,
                                 default = nil)
  if valid_568369 != nil:
    section.add "api-version", valid_568369
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

proc call*(call_568371: Call_ReplicationFabricsRenewCertificate_568362;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Renews the connection certificate for the ASR replication fabric.
  ## 
  let valid = call_568371.validator(path, query, header, formData, body)
  let scheme = call_568371.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568371.url(scheme.get, call_568371.host, call_568371.base,
                         call_568371.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568371, url, valid)

proc call*(call_568372: Call_ReplicationFabricsRenewCertificate_568362;
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
  var path_568373 = newJObject()
  var query_568374 = newJObject()
  var body_568375 = newJObject()
  add(path_568373, "fabricName", newJString(fabricName))
  add(path_568373, "resourceGroupName", newJString(resourceGroupName))
  add(query_568374, "api-version", newJString(apiVersion))
  add(path_568373, "subscriptionId", newJString(subscriptionId))
  if renewCertificate != nil:
    body_568375 = renewCertificate
  add(path_568373, "resourceName", newJString(resourceName))
  result = call_568372.call(path_568373, query_568374, nil, nil, body_568375)

var replicationFabricsRenewCertificate* = Call_ReplicationFabricsRenewCertificate_568362(
    name: "replicationFabricsRenewCertificate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/renewCertificate",
    validator: validate_ReplicationFabricsRenewCertificate_568363, base: "",
    url: url_ReplicationFabricsRenewCertificate_568364, schemes: {Scheme.Https})
type
  Call_ReplicationLogicalNetworksListByReplicationFabrics_568376 = ref object of OpenApiRestCall_567666
proc url_ReplicationLogicalNetworksListByReplicationFabrics_568378(
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

proc validate_ReplicationLogicalNetworksListByReplicationFabrics_568377(
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
  var valid_568379 = path.getOrDefault("fabricName")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = nil)
  if valid_568379 != nil:
    section.add "fabricName", valid_568379
  var valid_568380 = path.getOrDefault("resourceGroupName")
  valid_568380 = validateParameter(valid_568380, JString, required = true,
                                 default = nil)
  if valid_568380 != nil:
    section.add "resourceGroupName", valid_568380
  var valid_568381 = path.getOrDefault("subscriptionId")
  valid_568381 = validateParameter(valid_568381, JString, required = true,
                                 default = nil)
  if valid_568381 != nil:
    section.add "subscriptionId", valid_568381
  var valid_568382 = path.getOrDefault("resourceName")
  valid_568382 = validateParameter(valid_568382, JString, required = true,
                                 default = nil)
  if valid_568382 != nil:
    section.add "resourceName", valid_568382
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568383 = query.getOrDefault("api-version")
  valid_568383 = validateParameter(valid_568383, JString, required = true,
                                 default = nil)
  if valid_568383 != nil:
    section.add "api-version", valid_568383
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568384: Call_ReplicationLogicalNetworksListByReplicationFabrics_568376;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the logical networks of the Azure Site Recovery fabric
  ## 
  let valid = call_568384.validator(path, query, header, formData, body)
  let scheme = call_568384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568384.url(scheme.get, call_568384.host, call_568384.base,
                         call_568384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568384, url, valid)

proc call*(call_568385: Call_ReplicationLogicalNetworksListByReplicationFabrics_568376;
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
  var path_568386 = newJObject()
  var query_568387 = newJObject()
  add(path_568386, "fabricName", newJString(fabricName))
  add(path_568386, "resourceGroupName", newJString(resourceGroupName))
  add(query_568387, "api-version", newJString(apiVersion))
  add(path_568386, "subscriptionId", newJString(subscriptionId))
  add(path_568386, "resourceName", newJString(resourceName))
  result = call_568385.call(path_568386, query_568387, nil, nil, nil)

var replicationLogicalNetworksListByReplicationFabrics* = Call_ReplicationLogicalNetworksListByReplicationFabrics_568376(
    name: "replicationLogicalNetworksListByReplicationFabrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationLogicalNetworks",
    validator: validate_ReplicationLogicalNetworksListByReplicationFabrics_568377,
    base: "", url: url_ReplicationLogicalNetworksListByReplicationFabrics_568378,
    schemes: {Scheme.Https})
type
  Call_ReplicationLogicalNetworksGet_568388 = ref object of OpenApiRestCall_567666
proc url_ReplicationLogicalNetworksGet_568390(protocol: Scheme; host: string;
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

proc validate_ReplicationLogicalNetworksGet_568389(path: JsonNode; query: JsonNode;
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
  var valid_568391 = path.getOrDefault("fabricName")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = nil)
  if valid_568391 != nil:
    section.add "fabricName", valid_568391
  var valid_568392 = path.getOrDefault("resourceGroupName")
  valid_568392 = validateParameter(valid_568392, JString, required = true,
                                 default = nil)
  if valid_568392 != nil:
    section.add "resourceGroupName", valid_568392
  var valid_568393 = path.getOrDefault("logicalNetworkName")
  valid_568393 = validateParameter(valid_568393, JString, required = true,
                                 default = nil)
  if valid_568393 != nil:
    section.add "logicalNetworkName", valid_568393
  var valid_568394 = path.getOrDefault("subscriptionId")
  valid_568394 = validateParameter(valid_568394, JString, required = true,
                                 default = nil)
  if valid_568394 != nil:
    section.add "subscriptionId", valid_568394
  var valid_568395 = path.getOrDefault("resourceName")
  valid_568395 = validateParameter(valid_568395, JString, required = true,
                                 default = nil)
  if valid_568395 != nil:
    section.add "resourceName", valid_568395
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568396 = query.getOrDefault("api-version")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = nil)
  if valid_568396 != nil:
    section.add "api-version", valid_568396
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568397: Call_ReplicationLogicalNetworksGet_568388; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a logical network.
  ## 
  let valid = call_568397.validator(path, query, header, formData, body)
  let scheme = call_568397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568397.url(scheme.get, call_568397.host, call_568397.base,
                         call_568397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568397, url, valid)

proc call*(call_568398: Call_ReplicationLogicalNetworksGet_568388;
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
  var path_568399 = newJObject()
  var query_568400 = newJObject()
  add(path_568399, "fabricName", newJString(fabricName))
  add(path_568399, "resourceGroupName", newJString(resourceGroupName))
  add(query_568400, "api-version", newJString(apiVersion))
  add(path_568399, "logicalNetworkName", newJString(logicalNetworkName))
  add(path_568399, "subscriptionId", newJString(subscriptionId))
  add(path_568399, "resourceName", newJString(resourceName))
  result = call_568398.call(path_568399, query_568400, nil, nil, nil)

var replicationLogicalNetworksGet* = Call_ReplicationLogicalNetworksGet_568388(
    name: "replicationLogicalNetworksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationLogicalNetworks/{logicalNetworkName}",
    validator: validate_ReplicationLogicalNetworksGet_568389, base: "",
    url: url_ReplicationLogicalNetworksGet_568390, schemes: {Scheme.Https})
type
  Call_ReplicationNetworksListByReplicationFabrics_568401 = ref object of OpenApiRestCall_567666
proc url_ReplicationNetworksListByReplicationFabrics_568403(protocol: Scheme;
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

proc validate_ReplicationNetworksListByReplicationFabrics_568402(path: JsonNode;
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
  var valid_568404 = path.getOrDefault("fabricName")
  valid_568404 = validateParameter(valid_568404, JString, required = true,
                                 default = nil)
  if valid_568404 != nil:
    section.add "fabricName", valid_568404
  var valid_568405 = path.getOrDefault("resourceGroupName")
  valid_568405 = validateParameter(valid_568405, JString, required = true,
                                 default = nil)
  if valid_568405 != nil:
    section.add "resourceGroupName", valid_568405
  var valid_568406 = path.getOrDefault("subscriptionId")
  valid_568406 = validateParameter(valid_568406, JString, required = true,
                                 default = nil)
  if valid_568406 != nil:
    section.add "subscriptionId", valid_568406
  var valid_568407 = path.getOrDefault("resourceName")
  valid_568407 = validateParameter(valid_568407, JString, required = true,
                                 default = nil)
  if valid_568407 != nil:
    section.add "resourceName", valid_568407
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568408 = query.getOrDefault("api-version")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = nil)
  if valid_568408 != nil:
    section.add "api-version", valid_568408
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568409: Call_ReplicationNetworksListByReplicationFabrics_568401;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the networks available for a fabric.
  ## 
  let valid = call_568409.validator(path, query, header, formData, body)
  let scheme = call_568409.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568409.url(scheme.get, call_568409.host, call_568409.base,
                         call_568409.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568409, url, valid)

proc call*(call_568410: Call_ReplicationNetworksListByReplicationFabrics_568401;
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
  var path_568411 = newJObject()
  var query_568412 = newJObject()
  add(path_568411, "fabricName", newJString(fabricName))
  add(path_568411, "resourceGroupName", newJString(resourceGroupName))
  add(query_568412, "api-version", newJString(apiVersion))
  add(path_568411, "subscriptionId", newJString(subscriptionId))
  add(path_568411, "resourceName", newJString(resourceName))
  result = call_568410.call(path_568411, query_568412, nil, nil, nil)

var replicationNetworksListByReplicationFabrics* = Call_ReplicationNetworksListByReplicationFabrics_568401(
    name: "replicationNetworksListByReplicationFabrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationNetworks",
    validator: validate_ReplicationNetworksListByReplicationFabrics_568402,
    base: "", url: url_ReplicationNetworksListByReplicationFabrics_568403,
    schemes: {Scheme.Https})
type
  Call_ReplicationNetworksGet_568413 = ref object of OpenApiRestCall_567666
proc url_ReplicationNetworksGet_568415(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationNetworksGet_568414(path: JsonNode; query: JsonNode;
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
  var valid_568416 = path.getOrDefault("fabricName")
  valid_568416 = validateParameter(valid_568416, JString, required = true,
                                 default = nil)
  if valid_568416 != nil:
    section.add "fabricName", valid_568416
  var valid_568417 = path.getOrDefault("resourceGroupName")
  valid_568417 = validateParameter(valid_568417, JString, required = true,
                                 default = nil)
  if valid_568417 != nil:
    section.add "resourceGroupName", valid_568417
  var valid_568418 = path.getOrDefault("networkName")
  valid_568418 = validateParameter(valid_568418, JString, required = true,
                                 default = nil)
  if valid_568418 != nil:
    section.add "networkName", valid_568418
  var valid_568419 = path.getOrDefault("subscriptionId")
  valid_568419 = validateParameter(valid_568419, JString, required = true,
                                 default = nil)
  if valid_568419 != nil:
    section.add "subscriptionId", valid_568419
  var valid_568420 = path.getOrDefault("resourceName")
  valid_568420 = validateParameter(valid_568420, JString, required = true,
                                 default = nil)
  if valid_568420 != nil:
    section.add "resourceName", valid_568420
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568421 = query.getOrDefault("api-version")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = nil)
  if valid_568421 != nil:
    section.add "api-version", valid_568421
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568422: Call_ReplicationNetworksGet_568413; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a network.
  ## 
  let valid = call_568422.validator(path, query, header, formData, body)
  let scheme = call_568422.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568422.url(scheme.get, call_568422.host, call_568422.base,
                         call_568422.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568422, url, valid)

proc call*(call_568423: Call_ReplicationNetworksGet_568413; fabricName: string;
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
  var path_568424 = newJObject()
  var query_568425 = newJObject()
  add(path_568424, "fabricName", newJString(fabricName))
  add(path_568424, "resourceGroupName", newJString(resourceGroupName))
  add(query_568425, "api-version", newJString(apiVersion))
  add(path_568424, "networkName", newJString(networkName))
  add(path_568424, "subscriptionId", newJString(subscriptionId))
  add(path_568424, "resourceName", newJString(resourceName))
  result = call_568423.call(path_568424, query_568425, nil, nil, nil)

var replicationNetworksGet* = Call_ReplicationNetworksGet_568413(
    name: "replicationNetworksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationNetworks/{networkName}",
    validator: validate_ReplicationNetworksGet_568414, base: "",
    url: url_ReplicationNetworksGet_568415, schemes: {Scheme.Https})
type
  Call_ReplicationNetworkMappingsListByReplicationNetworks_568426 = ref object of OpenApiRestCall_567666
proc url_ReplicationNetworkMappingsListByReplicationNetworks_568428(
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

proc validate_ReplicationNetworkMappingsListByReplicationNetworks_568427(
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
  var valid_568429 = path.getOrDefault("fabricName")
  valid_568429 = validateParameter(valid_568429, JString, required = true,
                                 default = nil)
  if valid_568429 != nil:
    section.add "fabricName", valid_568429
  var valid_568430 = path.getOrDefault("resourceGroupName")
  valid_568430 = validateParameter(valid_568430, JString, required = true,
                                 default = nil)
  if valid_568430 != nil:
    section.add "resourceGroupName", valid_568430
  var valid_568431 = path.getOrDefault("networkName")
  valid_568431 = validateParameter(valid_568431, JString, required = true,
                                 default = nil)
  if valid_568431 != nil:
    section.add "networkName", valid_568431
  var valid_568432 = path.getOrDefault("subscriptionId")
  valid_568432 = validateParameter(valid_568432, JString, required = true,
                                 default = nil)
  if valid_568432 != nil:
    section.add "subscriptionId", valid_568432
  var valid_568433 = path.getOrDefault("resourceName")
  valid_568433 = validateParameter(valid_568433, JString, required = true,
                                 default = nil)
  if valid_568433 != nil:
    section.add "resourceName", valid_568433
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568434 = query.getOrDefault("api-version")
  valid_568434 = validateParameter(valid_568434, JString, required = true,
                                 default = nil)
  if valid_568434 != nil:
    section.add "api-version", valid_568434
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568435: Call_ReplicationNetworkMappingsListByReplicationNetworks_568426;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all ASR network mappings for the specified network.
  ## 
  let valid = call_568435.validator(path, query, header, formData, body)
  let scheme = call_568435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568435.url(scheme.get, call_568435.host, call_568435.base,
                         call_568435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568435, url, valid)

proc call*(call_568436: Call_ReplicationNetworkMappingsListByReplicationNetworks_568426;
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
  var path_568437 = newJObject()
  var query_568438 = newJObject()
  add(path_568437, "fabricName", newJString(fabricName))
  add(path_568437, "resourceGroupName", newJString(resourceGroupName))
  add(query_568438, "api-version", newJString(apiVersion))
  add(path_568437, "networkName", newJString(networkName))
  add(path_568437, "subscriptionId", newJString(subscriptionId))
  add(path_568437, "resourceName", newJString(resourceName))
  result = call_568436.call(path_568437, query_568438, nil, nil, nil)

var replicationNetworkMappingsListByReplicationNetworks* = Call_ReplicationNetworkMappingsListByReplicationNetworks_568426(
    name: "replicationNetworkMappingsListByReplicationNetworks",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationNetworks/{networkName}/replicationNetworkMappings",
    validator: validate_ReplicationNetworkMappingsListByReplicationNetworks_568427,
    base: "", url: url_ReplicationNetworkMappingsListByReplicationNetworks_568428,
    schemes: {Scheme.Https})
type
  Call_ReplicationNetworkMappingsCreate_568453 = ref object of OpenApiRestCall_567666
proc url_ReplicationNetworkMappingsCreate_568455(protocol: Scheme; host: string;
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

proc validate_ReplicationNetworkMappingsCreate_568454(path: JsonNode;
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
  var valid_568456 = path.getOrDefault("networkMappingName")
  valid_568456 = validateParameter(valid_568456, JString, required = true,
                                 default = nil)
  if valid_568456 != nil:
    section.add "networkMappingName", valid_568456
  var valid_568457 = path.getOrDefault("fabricName")
  valid_568457 = validateParameter(valid_568457, JString, required = true,
                                 default = nil)
  if valid_568457 != nil:
    section.add "fabricName", valid_568457
  var valid_568458 = path.getOrDefault("resourceGroupName")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "resourceGroupName", valid_568458
  var valid_568459 = path.getOrDefault("networkName")
  valid_568459 = validateParameter(valid_568459, JString, required = true,
                                 default = nil)
  if valid_568459 != nil:
    section.add "networkName", valid_568459
  var valid_568460 = path.getOrDefault("subscriptionId")
  valid_568460 = validateParameter(valid_568460, JString, required = true,
                                 default = nil)
  if valid_568460 != nil:
    section.add "subscriptionId", valid_568460
  var valid_568461 = path.getOrDefault("resourceName")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = nil)
  if valid_568461 != nil:
    section.add "resourceName", valid_568461
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568462 = query.getOrDefault("api-version")
  valid_568462 = validateParameter(valid_568462, JString, required = true,
                                 default = nil)
  if valid_568462 != nil:
    section.add "api-version", valid_568462
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

proc call*(call_568464: Call_ReplicationNetworkMappingsCreate_568453;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create an ASR network mapping.
  ## 
  let valid = call_568464.validator(path, query, header, formData, body)
  let scheme = call_568464.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568464.url(scheme.get, call_568464.host, call_568464.base,
                         call_568464.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568464, url, valid)

proc call*(call_568465: Call_ReplicationNetworkMappingsCreate_568453;
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
  var path_568466 = newJObject()
  var query_568467 = newJObject()
  var body_568468 = newJObject()
  add(path_568466, "networkMappingName", newJString(networkMappingName))
  add(path_568466, "fabricName", newJString(fabricName))
  add(path_568466, "resourceGroupName", newJString(resourceGroupName))
  add(query_568467, "api-version", newJString(apiVersion))
  add(path_568466, "networkName", newJString(networkName))
  add(path_568466, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_568468 = input
  add(path_568466, "resourceName", newJString(resourceName))
  result = call_568465.call(path_568466, query_568467, nil, nil, body_568468)

var replicationNetworkMappingsCreate* = Call_ReplicationNetworkMappingsCreate_568453(
    name: "replicationNetworkMappingsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationNetworks/{networkName}/replicationNetworkMappings/{networkMappingName}",
    validator: validate_ReplicationNetworkMappingsCreate_568454, base: "",
    url: url_ReplicationNetworkMappingsCreate_568455, schemes: {Scheme.Https})
type
  Call_ReplicationNetworkMappingsGet_568439 = ref object of OpenApiRestCall_567666
proc url_ReplicationNetworkMappingsGet_568441(protocol: Scheme; host: string;
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

proc validate_ReplicationNetworkMappingsGet_568440(path: JsonNode; query: JsonNode;
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
  var valid_568442 = path.getOrDefault("networkMappingName")
  valid_568442 = validateParameter(valid_568442, JString, required = true,
                                 default = nil)
  if valid_568442 != nil:
    section.add "networkMappingName", valid_568442
  var valid_568443 = path.getOrDefault("fabricName")
  valid_568443 = validateParameter(valid_568443, JString, required = true,
                                 default = nil)
  if valid_568443 != nil:
    section.add "fabricName", valid_568443
  var valid_568444 = path.getOrDefault("resourceGroupName")
  valid_568444 = validateParameter(valid_568444, JString, required = true,
                                 default = nil)
  if valid_568444 != nil:
    section.add "resourceGroupName", valid_568444
  var valid_568445 = path.getOrDefault("networkName")
  valid_568445 = validateParameter(valid_568445, JString, required = true,
                                 default = nil)
  if valid_568445 != nil:
    section.add "networkName", valid_568445
  var valid_568446 = path.getOrDefault("subscriptionId")
  valid_568446 = validateParameter(valid_568446, JString, required = true,
                                 default = nil)
  if valid_568446 != nil:
    section.add "subscriptionId", valid_568446
  var valid_568447 = path.getOrDefault("resourceName")
  valid_568447 = validateParameter(valid_568447, JString, required = true,
                                 default = nil)
  if valid_568447 != nil:
    section.add "resourceName", valid_568447
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568448 = query.getOrDefault("api-version")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = nil)
  if valid_568448 != nil:
    section.add "api-version", valid_568448
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568449: Call_ReplicationNetworkMappingsGet_568439; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of an ASR network mapping
  ## 
  let valid = call_568449.validator(path, query, header, formData, body)
  let scheme = call_568449.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568449.url(scheme.get, call_568449.host, call_568449.base,
                         call_568449.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568449, url, valid)

proc call*(call_568450: Call_ReplicationNetworkMappingsGet_568439;
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
  var path_568451 = newJObject()
  var query_568452 = newJObject()
  add(path_568451, "networkMappingName", newJString(networkMappingName))
  add(path_568451, "fabricName", newJString(fabricName))
  add(path_568451, "resourceGroupName", newJString(resourceGroupName))
  add(query_568452, "api-version", newJString(apiVersion))
  add(path_568451, "networkName", newJString(networkName))
  add(path_568451, "subscriptionId", newJString(subscriptionId))
  add(path_568451, "resourceName", newJString(resourceName))
  result = call_568450.call(path_568451, query_568452, nil, nil, nil)

var replicationNetworkMappingsGet* = Call_ReplicationNetworkMappingsGet_568439(
    name: "replicationNetworkMappingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationNetworks/{networkName}/replicationNetworkMappings/{networkMappingName}",
    validator: validate_ReplicationNetworkMappingsGet_568440, base: "",
    url: url_ReplicationNetworkMappingsGet_568441, schemes: {Scheme.Https})
type
  Call_ReplicationNetworkMappingsUpdate_568483 = ref object of OpenApiRestCall_567666
proc url_ReplicationNetworkMappingsUpdate_568485(protocol: Scheme; host: string;
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

proc validate_ReplicationNetworkMappingsUpdate_568484(path: JsonNode;
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
  var valid_568486 = path.getOrDefault("networkMappingName")
  valid_568486 = validateParameter(valid_568486, JString, required = true,
                                 default = nil)
  if valid_568486 != nil:
    section.add "networkMappingName", valid_568486
  var valid_568487 = path.getOrDefault("fabricName")
  valid_568487 = validateParameter(valid_568487, JString, required = true,
                                 default = nil)
  if valid_568487 != nil:
    section.add "fabricName", valid_568487
  var valid_568488 = path.getOrDefault("resourceGroupName")
  valid_568488 = validateParameter(valid_568488, JString, required = true,
                                 default = nil)
  if valid_568488 != nil:
    section.add "resourceGroupName", valid_568488
  var valid_568489 = path.getOrDefault("networkName")
  valid_568489 = validateParameter(valid_568489, JString, required = true,
                                 default = nil)
  if valid_568489 != nil:
    section.add "networkName", valid_568489
  var valid_568490 = path.getOrDefault("subscriptionId")
  valid_568490 = validateParameter(valid_568490, JString, required = true,
                                 default = nil)
  if valid_568490 != nil:
    section.add "subscriptionId", valid_568490
  var valid_568491 = path.getOrDefault("resourceName")
  valid_568491 = validateParameter(valid_568491, JString, required = true,
                                 default = nil)
  if valid_568491 != nil:
    section.add "resourceName", valid_568491
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568492 = query.getOrDefault("api-version")
  valid_568492 = validateParameter(valid_568492, JString, required = true,
                                 default = nil)
  if valid_568492 != nil:
    section.add "api-version", valid_568492
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

proc call*(call_568494: Call_ReplicationNetworkMappingsUpdate_568483;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to update an ASR network mapping.
  ## 
  let valid = call_568494.validator(path, query, header, formData, body)
  let scheme = call_568494.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568494.url(scheme.get, call_568494.host, call_568494.base,
                         call_568494.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568494, url, valid)

proc call*(call_568495: Call_ReplicationNetworkMappingsUpdate_568483;
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
  var path_568496 = newJObject()
  var query_568497 = newJObject()
  var body_568498 = newJObject()
  add(path_568496, "networkMappingName", newJString(networkMappingName))
  add(path_568496, "fabricName", newJString(fabricName))
  add(path_568496, "resourceGroupName", newJString(resourceGroupName))
  add(query_568497, "api-version", newJString(apiVersion))
  add(path_568496, "networkName", newJString(networkName))
  add(path_568496, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_568498 = input
  add(path_568496, "resourceName", newJString(resourceName))
  result = call_568495.call(path_568496, query_568497, nil, nil, body_568498)

var replicationNetworkMappingsUpdate* = Call_ReplicationNetworkMappingsUpdate_568483(
    name: "replicationNetworkMappingsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationNetworks/{networkName}/replicationNetworkMappings/{networkMappingName}",
    validator: validate_ReplicationNetworkMappingsUpdate_568484, base: "",
    url: url_ReplicationNetworkMappingsUpdate_568485, schemes: {Scheme.Https})
type
  Call_ReplicationNetworkMappingsDelete_568469 = ref object of OpenApiRestCall_567666
proc url_ReplicationNetworkMappingsDelete_568471(protocol: Scheme; host: string;
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

proc validate_ReplicationNetworkMappingsDelete_568470(path: JsonNode;
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
  var valid_568472 = path.getOrDefault("networkMappingName")
  valid_568472 = validateParameter(valid_568472, JString, required = true,
                                 default = nil)
  if valid_568472 != nil:
    section.add "networkMappingName", valid_568472
  var valid_568473 = path.getOrDefault("fabricName")
  valid_568473 = validateParameter(valid_568473, JString, required = true,
                                 default = nil)
  if valid_568473 != nil:
    section.add "fabricName", valid_568473
  var valid_568474 = path.getOrDefault("resourceGroupName")
  valid_568474 = validateParameter(valid_568474, JString, required = true,
                                 default = nil)
  if valid_568474 != nil:
    section.add "resourceGroupName", valid_568474
  var valid_568475 = path.getOrDefault("networkName")
  valid_568475 = validateParameter(valid_568475, JString, required = true,
                                 default = nil)
  if valid_568475 != nil:
    section.add "networkName", valid_568475
  var valid_568476 = path.getOrDefault("subscriptionId")
  valid_568476 = validateParameter(valid_568476, JString, required = true,
                                 default = nil)
  if valid_568476 != nil:
    section.add "subscriptionId", valid_568476
  var valid_568477 = path.getOrDefault("resourceName")
  valid_568477 = validateParameter(valid_568477, JString, required = true,
                                 default = nil)
  if valid_568477 != nil:
    section.add "resourceName", valid_568477
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568478 = query.getOrDefault("api-version")
  valid_568478 = validateParameter(valid_568478, JString, required = true,
                                 default = nil)
  if valid_568478 != nil:
    section.add "api-version", valid_568478
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568479: Call_ReplicationNetworkMappingsDelete_568469;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete a network mapping.
  ## 
  let valid = call_568479.validator(path, query, header, formData, body)
  let scheme = call_568479.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568479.url(scheme.get, call_568479.host, call_568479.base,
                         call_568479.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568479, url, valid)

proc call*(call_568480: Call_ReplicationNetworkMappingsDelete_568469;
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
  var path_568481 = newJObject()
  var query_568482 = newJObject()
  add(path_568481, "networkMappingName", newJString(networkMappingName))
  add(path_568481, "fabricName", newJString(fabricName))
  add(path_568481, "resourceGroupName", newJString(resourceGroupName))
  add(query_568482, "api-version", newJString(apiVersion))
  add(path_568481, "networkName", newJString(networkName))
  add(path_568481, "subscriptionId", newJString(subscriptionId))
  add(path_568481, "resourceName", newJString(resourceName))
  result = call_568480.call(path_568481, query_568482, nil, nil, nil)

var replicationNetworkMappingsDelete* = Call_ReplicationNetworkMappingsDelete_568469(
    name: "replicationNetworkMappingsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationNetworks/{networkName}/replicationNetworkMappings/{networkMappingName}",
    validator: validate_ReplicationNetworkMappingsDelete_568470, base: "",
    url: url_ReplicationNetworkMappingsDelete_568471, schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersListByReplicationFabrics_568499 = ref object of OpenApiRestCall_567666
proc url_ReplicationProtectionContainersListByReplicationFabrics_568501(
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

proc validate_ReplicationProtectionContainersListByReplicationFabrics_568500(
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
  var valid_568502 = path.getOrDefault("fabricName")
  valid_568502 = validateParameter(valid_568502, JString, required = true,
                                 default = nil)
  if valid_568502 != nil:
    section.add "fabricName", valid_568502
  var valid_568503 = path.getOrDefault("resourceGroupName")
  valid_568503 = validateParameter(valid_568503, JString, required = true,
                                 default = nil)
  if valid_568503 != nil:
    section.add "resourceGroupName", valid_568503
  var valid_568504 = path.getOrDefault("subscriptionId")
  valid_568504 = validateParameter(valid_568504, JString, required = true,
                                 default = nil)
  if valid_568504 != nil:
    section.add "subscriptionId", valid_568504
  var valid_568505 = path.getOrDefault("resourceName")
  valid_568505 = validateParameter(valid_568505, JString, required = true,
                                 default = nil)
  if valid_568505 != nil:
    section.add "resourceName", valid_568505
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568506 = query.getOrDefault("api-version")
  valid_568506 = validateParameter(valid_568506, JString, required = true,
                                 default = nil)
  if valid_568506 != nil:
    section.add "api-version", valid_568506
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568507: Call_ReplicationProtectionContainersListByReplicationFabrics_568499;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the protection containers in the specified fabric.
  ## 
  let valid = call_568507.validator(path, query, header, formData, body)
  let scheme = call_568507.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568507.url(scheme.get, call_568507.host, call_568507.base,
                         call_568507.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568507, url, valid)

proc call*(call_568508: Call_ReplicationProtectionContainersListByReplicationFabrics_568499;
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
  var path_568509 = newJObject()
  var query_568510 = newJObject()
  add(path_568509, "fabricName", newJString(fabricName))
  add(path_568509, "resourceGroupName", newJString(resourceGroupName))
  add(query_568510, "api-version", newJString(apiVersion))
  add(path_568509, "subscriptionId", newJString(subscriptionId))
  add(path_568509, "resourceName", newJString(resourceName))
  result = call_568508.call(path_568509, query_568510, nil, nil, nil)

var replicationProtectionContainersListByReplicationFabrics* = Call_ReplicationProtectionContainersListByReplicationFabrics_568499(
    name: "replicationProtectionContainersListByReplicationFabrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers", validator: validate_ReplicationProtectionContainersListByReplicationFabrics_568500,
    base: "", url: url_ReplicationProtectionContainersListByReplicationFabrics_568501,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersCreate_568524 = ref object of OpenApiRestCall_567666
proc url_ReplicationProtectionContainersCreate_568526(protocol: Scheme;
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

proc validate_ReplicationProtectionContainersCreate_568525(path: JsonNode;
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
  var valid_568527 = path.getOrDefault("fabricName")
  valid_568527 = validateParameter(valid_568527, JString, required = true,
                                 default = nil)
  if valid_568527 != nil:
    section.add "fabricName", valid_568527
  var valid_568528 = path.getOrDefault("resourceGroupName")
  valid_568528 = validateParameter(valid_568528, JString, required = true,
                                 default = nil)
  if valid_568528 != nil:
    section.add "resourceGroupName", valid_568528
  var valid_568529 = path.getOrDefault("subscriptionId")
  valid_568529 = validateParameter(valid_568529, JString, required = true,
                                 default = nil)
  if valid_568529 != nil:
    section.add "subscriptionId", valid_568529
  var valid_568530 = path.getOrDefault("resourceName")
  valid_568530 = validateParameter(valid_568530, JString, required = true,
                                 default = nil)
  if valid_568530 != nil:
    section.add "resourceName", valid_568530
  var valid_568531 = path.getOrDefault("protectionContainerName")
  valid_568531 = validateParameter(valid_568531, JString, required = true,
                                 default = nil)
  if valid_568531 != nil:
    section.add "protectionContainerName", valid_568531
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568532 = query.getOrDefault("api-version")
  valid_568532 = validateParameter(valid_568532, JString, required = true,
                                 default = nil)
  if valid_568532 != nil:
    section.add "api-version", valid_568532
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

proc call*(call_568534: Call_ReplicationProtectionContainersCreate_568524;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to create a protection container.
  ## 
  let valid = call_568534.validator(path, query, header, formData, body)
  let scheme = call_568534.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568534.url(scheme.get, call_568534.host, call_568534.base,
                         call_568534.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568534, url, valid)

proc call*(call_568535: Call_ReplicationProtectionContainersCreate_568524;
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
  var path_568536 = newJObject()
  var query_568537 = newJObject()
  var body_568538 = newJObject()
  add(path_568536, "fabricName", newJString(fabricName))
  add(path_568536, "resourceGroupName", newJString(resourceGroupName))
  add(query_568537, "api-version", newJString(apiVersion))
  if creationInput != nil:
    body_568538 = creationInput
  add(path_568536, "subscriptionId", newJString(subscriptionId))
  add(path_568536, "resourceName", newJString(resourceName))
  add(path_568536, "protectionContainerName", newJString(protectionContainerName))
  result = call_568535.call(path_568536, query_568537, nil, nil, body_568538)

var replicationProtectionContainersCreate* = Call_ReplicationProtectionContainersCreate_568524(
    name: "replicationProtectionContainersCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}",
    validator: validate_ReplicationProtectionContainersCreate_568525, base: "",
    url: url_ReplicationProtectionContainersCreate_568526, schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersGet_568511 = ref object of OpenApiRestCall_567666
proc url_ReplicationProtectionContainersGet_568513(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectionContainersGet_568512(path: JsonNode;
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
  var valid_568514 = path.getOrDefault("fabricName")
  valid_568514 = validateParameter(valid_568514, JString, required = true,
                                 default = nil)
  if valid_568514 != nil:
    section.add "fabricName", valid_568514
  var valid_568515 = path.getOrDefault("resourceGroupName")
  valid_568515 = validateParameter(valid_568515, JString, required = true,
                                 default = nil)
  if valid_568515 != nil:
    section.add "resourceGroupName", valid_568515
  var valid_568516 = path.getOrDefault("subscriptionId")
  valid_568516 = validateParameter(valid_568516, JString, required = true,
                                 default = nil)
  if valid_568516 != nil:
    section.add "subscriptionId", valid_568516
  var valid_568517 = path.getOrDefault("resourceName")
  valid_568517 = validateParameter(valid_568517, JString, required = true,
                                 default = nil)
  if valid_568517 != nil:
    section.add "resourceName", valid_568517
  var valid_568518 = path.getOrDefault("protectionContainerName")
  valid_568518 = validateParameter(valid_568518, JString, required = true,
                                 default = nil)
  if valid_568518 != nil:
    section.add "protectionContainerName", valid_568518
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568519 = query.getOrDefault("api-version")
  valid_568519 = validateParameter(valid_568519, JString, required = true,
                                 default = nil)
  if valid_568519 != nil:
    section.add "api-version", valid_568519
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568520: Call_ReplicationProtectionContainersGet_568511;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of a protection container.
  ## 
  let valid = call_568520.validator(path, query, header, formData, body)
  let scheme = call_568520.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568520.url(scheme.get, call_568520.host, call_568520.base,
                         call_568520.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568520, url, valid)

proc call*(call_568521: Call_ReplicationProtectionContainersGet_568511;
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
  var path_568522 = newJObject()
  var query_568523 = newJObject()
  add(path_568522, "fabricName", newJString(fabricName))
  add(path_568522, "resourceGroupName", newJString(resourceGroupName))
  add(query_568523, "api-version", newJString(apiVersion))
  add(path_568522, "subscriptionId", newJString(subscriptionId))
  add(path_568522, "resourceName", newJString(resourceName))
  add(path_568522, "protectionContainerName", newJString(protectionContainerName))
  result = call_568521.call(path_568522, query_568523, nil, nil, nil)

var replicationProtectionContainersGet* = Call_ReplicationProtectionContainersGet_568511(
    name: "replicationProtectionContainersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}",
    validator: validate_ReplicationProtectionContainersGet_568512, base: "",
    url: url_ReplicationProtectionContainersGet_568513, schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersDiscoverProtectableItem_568539 = ref object of OpenApiRestCall_567666
proc url_ReplicationProtectionContainersDiscoverProtectableItem_568541(
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

proc validate_ReplicationProtectionContainersDiscoverProtectableItem_568540(
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
  var valid_568542 = path.getOrDefault("fabricName")
  valid_568542 = validateParameter(valid_568542, JString, required = true,
                                 default = nil)
  if valid_568542 != nil:
    section.add "fabricName", valid_568542
  var valid_568543 = path.getOrDefault("resourceGroupName")
  valid_568543 = validateParameter(valid_568543, JString, required = true,
                                 default = nil)
  if valid_568543 != nil:
    section.add "resourceGroupName", valid_568543
  var valid_568544 = path.getOrDefault("subscriptionId")
  valid_568544 = validateParameter(valid_568544, JString, required = true,
                                 default = nil)
  if valid_568544 != nil:
    section.add "subscriptionId", valid_568544
  var valid_568545 = path.getOrDefault("resourceName")
  valid_568545 = validateParameter(valid_568545, JString, required = true,
                                 default = nil)
  if valid_568545 != nil:
    section.add "resourceName", valid_568545
  var valid_568546 = path.getOrDefault("protectionContainerName")
  valid_568546 = validateParameter(valid_568546, JString, required = true,
                                 default = nil)
  if valid_568546 != nil:
    section.add "protectionContainerName", valid_568546
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568547 = query.getOrDefault("api-version")
  valid_568547 = validateParameter(valid_568547, JString, required = true,
                                 default = nil)
  if valid_568547 != nil:
    section.add "api-version", valid_568547
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

proc call*(call_568549: Call_ReplicationProtectionContainersDiscoverProtectableItem_568539;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to a add a protectable item to a protection container(Add physical server.)
  ## 
  let valid = call_568549.validator(path, query, header, formData, body)
  let scheme = call_568549.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568549.url(scheme.get, call_568549.host, call_568549.base,
                         call_568549.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568549, url, valid)

proc call*(call_568550: Call_ReplicationProtectionContainersDiscoverProtectableItem_568539;
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
  var path_568551 = newJObject()
  var query_568552 = newJObject()
  var body_568553 = newJObject()
  add(path_568551, "fabricName", newJString(fabricName))
  add(path_568551, "resourceGroupName", newJString(resourceGroupName))
  add(query_568552, "api-version", newJString(apiVersion))
  add(path_568551, "subscriptionId", newJString(subscriptionId))
  add(path_568551, "resourceName", newJString(resourceName))
  add(path_568551, "protectionContainerName", newJString(protectionContainerName))
  if discoverProtectableItemRequest != nil:
    body_568553 = discoverProtectableItemRequest
  result = call_568550.call(path_568551, query_568552, nil, nil, body_568553)

var replicationProtectionContainersDiscoverProtectableItem* = Call_ReplicationProtectionContainersDiscoverProtectableItem_568539(
    name: "replicationProtectionContainersDiscoverProtectableItem",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/discoverProtectableItem",
    validator: validate_ReplicationProtectionContainersDiscoverProtectableItem_568540,
    base: "", url: url_ReplicationProtectionContainersDiscoverProtectableItem_568541,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersDelete_568554 = ref object of OpenApiRestCall_567666
proc url_ReplicationProtectionContainersDelete_568556(protocol: Scheme;
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

proc validate_ReplicationProtectionContainersDelete_568555(path: JsonNode;
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
  var valid_568557 = path.getOrDefault("fabricName")
  valid_568557 = validateParameter(valid_568557, JString, required = true,
                                 default = nil)
  if valid_568557 != nil:
    section.add "fabricName", valid_568557
  var valid_568558 = path.getOrDefault("resourceGroupName")
  valid_568558 = validateParameter(valid_568558, JString, required = true,
                                 default = nil)
  if valid_568558 != nil:
    section.add "resourceGroupName", valid_568558
  var valid_568559 = path.getOrDefault("subscriptionId")
  valid_568559 = validateParameter(valid_568559, JString, required = true,
                                 default = nil)
  if valid_568559 != nil:
    section.add "subscriptionId", valid_568559
  var valid_568560 = path.getOrDefault("resourceName")
  valid_568560 = validateParameter(valid_568560, JString, required = true,
                                 default = nil)
  if valid_568560 != nil:
    section.add "resourceName", valid_568560
  var valid_568561 = path.getOrDefault("protectionContainerName")
  valid_568561 = validateParameter(valid_568561, JString, required = true,
                                 default = nil)
  if valid_568561 != nil:
    section.add "protectionContainerName", valid_568561
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568562 = query.getOrDefault("api-version")
  valid_568562 = validateParameter(valid_568562, JString, required = true,
                                 default = nil)
  if valid_568562 != nil:
    section.add "api-version", valid_568562
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568563: Call_ReplicationProtectionContainersDelete_568554;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to remove a protection container.
  ## 
  let valid = call_568563.validator(path, query, header, formData, body)
  let scheme = call_568563.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568563.url(scheme.get, call_568563.host, call_568563.base,
                         call_568563.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568563, url, valid)

proc call*(call_568564: Call_ReplicationProtectionContainersDelete_568554;
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
  var path_568565 = newJObject()
  var query_568566 = newJObject()
  add(path_568565, "fabricName", newJString(fabricName))
  add(path_568565, "resourceGroupName", newJString(resourceGroupName))
  add(query_568566, "api-version", newJString(apiVersion))
  add(path_568565, "subscriptionId", newJString(subscriptionId))
  add(path_568565, "resourceName", newJString(resourceName))
  add(path_568565, "protectionContainerName", newJString(protectionContainerName))
  result = call_568564.call(path_568565, query_568566, nil, nil, nil)

var replicationProtectionContainersDelete* = Call_ReplicationProtectionContainersDelete_568554(
    name: "replicationProtectionContainersDelete", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/remove",
    validator: validate_ReplicationProtectionContainersDelete_568555, base: "",
    url: url_ReplicationProtectionContainersDelete_568556, schemes: {Scheme.Https})
type
  Call_ReplicationProtectableItemsListByReplicationProtectionContainers_568567 = ref object of OpenApiRestCall_567666
proc url_ReplicationProtectableItemsListByReplicationProtectionContainers_568569(
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

proc validate_ReplicationProtectableItemsListByReplicationProtectionContainers_568568(
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
  var valid_568570 = path.getOrDefault("fabricName")
  valid_568570 = validateParameter(valid_568570, JString, required = true,
                                 default = nil)
  if valid_568570 != nil:
    section.add "fabricName", valid_568570
  var valid_568571 = path.getOrDefault("resourceGroupName")
  valid_568571 = validateParameter(valid_568571, JString, required = true,
                                 default = nil)
  if valid_568571 != nil:
    section.add "resourceGroupName", valid_568571
  var valid_568572 = path.getOrDefault("subscriptionId")
  valid_568572 = validateParameter(valid_568572, JString, required = true,
                                 default = nil)
  if valid_568572 != nil:
    section.add "subscriptionId", valid_568572
  var valid_568573 = path.getOrDefault("resourceName")
  valid_568573 = validateParameter(valid_568573, JString, required = true,
                                 default = nil)
  if valid_568573 != nil:
    section.add "resourceName", valid_568573
  var valid_568574 = path.getOrDefault("protectionContainerName")
  valid_568574 = validateParameter(valid_568574, JString, required = true,
                                 default = nil)
  if valid_568574 != nil:
    section.add "protectionContainerName", valid_568574
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568575 = query.getOrDefault("api-version")
  valid_568575 = validateParameter(valid_568575, JString, required = true,
                                 default = nil)
  if valid_568575 != nil:
    section.add "api-version", valid_568575
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568576: Call_ReplicationProtectableItemsListByReplicationProtectionContainers_568567;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the protectable items in a protection container.
  ## 
  let valid = call_568576.validator(path, query, header, formData, body)
  let scheme = call_568576.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568576.url(scheme.get, call_568576.host, call_568576.base,
                         call_568576.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568576, url, valid)

proc call*(call_568577: Call_ReplicationProtectableItemsListByReplicationProtectionContainers_568567;
          fabricName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          protectionContainerName: string): Recallable =
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
  var path_568578 = newJObject()
  var query_568579 = newJObject()
  add(path_568578, "fabricName", newJString(fabricName))
  add(path_568578, "resourceGroupName", newJString(resourceGroupName))
  add(query_568579, "api-version", newJString(apiVersion))
  add(path_568578, "subscriptionId", newJString(subscriptionId))
  add(path_568578, "resourceName", newJString(resourceName))
  add(path_568578, "protectionContainerName", newJString(protectionContainerName))
  result = call_568577.call(path_568578, query_568579, nil, nil, nil)

var replicationProtectableItemsListByReplicationProtectionContainers* = Call_ReplicationProtectableItemsListByReplicationProtectionContainers_568567(
    name: "replicationProtectableItemsListByReplicationProtectionContainers",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectableItems", validator: validate_ReplicationProtectableItemsListByReplicationProtectionContainers_568568,
    base: "",
    url: url_ReplicationProtectableItemsListByReplicationProtectionContainers_568569,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectableItemsGet_568580 = ref object of OpenApiRestCall_567666
proc url_ReplicationProtectableItemsGet_568582(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectableItemsGet_568581(path: JsonNode;
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
  var valid_568583 = path.getOrDefault("fabricName")
  valid_568583 = validateParameter(valid_568583, JString, required = true,
                                 default = nil)
  if valid_568583 != nil:
    section.add "fabricName", valid_568583
  var valid_568584 = path.getOrDefault("resourceGroupName")
  valid_568584 = validateParameter(valid_568584, JString, required = true,
                                 default = nil)
  if valid_568584 != nil:
    section.add "resourceGroupName", valid_568584
  var valid_568585 = path.getOrDefault("protectableItemName")
  valid_568585 = validateParameter(valid_568585, JString, required = true,
                                 default = nil)
  if valid_568585 != nil:
    section.add "protectableItemName", valid_568585
  var valid_568586 = path.getOrDefault("subscriptionId")
  valid_568586 = validateParameter(valid_568586, JString, required = true,
                                 default = nil)
  if valid_568586 != nil:
    section.add "subscriptionId", valid_568586
  var valid_568587 = path.getOrDefault("resourceName")
  valid_568587 = validateParameter(valid_568587, JString, required = true,
                                 default = nil)
  if valid_568587 != nil:
    section.add "resourceName", valid_568587
  var valid_568588 = path.getOrDefault("protectionContainerName")
  valid_568588 = validateParameter(valid_568588, JString, required = true,
                                 default = nil)
  if valid_568588 != nil:
    section.add "protectionContainerName", valid_568588
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568589 = query.getOrDefault("api-version")
  valid_568589 = validateParameter(valid_568589, JString, required = true,
                                 default = nil)
  if valid_568589 != nil:
    section.add "api-version", valid_568589
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568590: Call_ReplicationProtectableItemsGet_568580; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to get the details of a protectable item.
  ## 
  let valid = call_568590.validator(path, query, header, formData, body)
  let scheme = call_568590.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568590.url(scheme.get, call_568590.host, call_568590.base,
                         call_568590.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568590, url, valid)

proc call*(call_568591: Call_ReplicationProtectableItemsGet_568580;
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
  var path_568592 = newJObject()
  var query_568593 = newJObject()
  add(path_568592, "fabricName", newJString(fabricName))
  add(path_568592, "resourceGroupName", newJString(resourceGroupName))
  add(path_568592, "protectableItemName", newJString(protectableItemName))
  add(query_568593, "api-version", newJString(apiVersion))
  add(path_568592, "subscriptionId", newJString(subscriptionId))
  add(path_568592, "resourceName", newJString(resourceName))
  add(path_568592, "protectionContainerName", newJString(protectionContainerName))
  result = call_568591.call(path_568592, query_568593, nil, nil, nil)

var replicationProtectableItemsGet* = Call_ReplicationProtectableItemsGet_568580(
    name: "replicationProtectableItemsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectableItems/{protectableItemName}",
    validator: validate_ReplicationProtectableItemsGet_568581, base: "",
    url: url_ReplicationProtectableItemsGet_568582, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsListByReplicationProtectionContainers_568594 = ref object of OpenApiRestCall_567666
proc url_ReplicationProtectedItemsListByReplicationProtectionContainers_568596(
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

proc validate_ReplicationProtectedItemsListByReplicationProtectionContainers_568595(
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
  var valid_568597 = path.getOrDefault("fabricName")
  valid_568597 = validateParameter(valid_568597, JString, required = true,
                                 default = nil)
  if valid_568597 != nil:
    section.add "fabricName", valid_568597
  var valid_568598 = path.getOrDefault("resourceGroupName")
  valid_568598 = validateParameter(valid_568598, JString, required = true,
                                 default = nil)
  if valid_568598 != nil:
    section.add "resourceGroupName", valid_568598
  var valid_568599 = path.getOrDefault("subscriptionId")
  valid_568599 = validateParameter(valid_568599, JString, required = true,
                                 default = nil)
  if valid_568599 != nil:
    section.add "subscriptionId", valid_568599
  var valid_568600 = path.getOrDefault("resourceName")
  valid_568600 = validateParameter(valid_568600, JString, required = true,
                                 default = nil)
  if valid_568600 != nil:
    section.add "resourceName", valid_568600
  var valid_568601 = path.getOrDefault("protectionContainerName")
  valid_568601 = validateParameter(valid_568601, JString, required = true,
                                 default = nil)
  if valid_568601 != nil:
    section.add "protectionContainerName", valid_568601
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568602 = query.getOrDefault("api-version")
  valid_568602 = validateParameter(valid_568602, JString, required = true,
                                 default = nil)
  if valid_568602 != nil:
    section.add "api-version", valid_568602
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568603: Call_ReplicationProtectedItemsListByReplicationProtectionContainers_568594;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the list of ASR replication protected items in the protection container.
  ## 
  let valid = call_568603.validator(path, query, header, formData, body)
  let scheme = call_568603.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568603.url(scheme.get, call_568603.host, call_568603.base,
                         call_568603.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568603, url, valid)

proc call*(call_568604: Call_ReplicationProtectedItemsListByReplicationProtectionContainers_568594;
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
  var path_568605 = newJObject()
  var query_568606 = newJObject()
  add(path_568605, "fabricName", newJString(fabricName))
  add(path_568605, "resourceGroupName", newJString(resourceGroupName))
  add(query_568606, "api-version", newJString(apiVersion))
  add(path_568605, "subscriptionId", newJString(subscriptionId))
  add(path_568605, "resourceName", newJString(resourceName))
  add(path_568605, "protectionContainerName", newJString(protectionContainerName))
  result = call_568604.call(path_568605, query_568606, nil, nil, nil)

var replicationProtectedItemsListByReplicationProtectionContainers* = Call_ReplicationProtectedItemsListByReplicationProtectionContainers_568594(
    name: "replicationProtectedItemsListByReplicationProtectionContainers",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems", validator: validate_ReplicationProtectedItemsListByReplicationProtectionContainers_568595,
    base: "",
    url: url_ReplicationProtectedItemsListByReplicationProtectionContainers_568596,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsCreate_568621 = ref object of OpenApiRestCall_567666
proc url_ReplicationProtectedItemsCreate_568623(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectedItemsCreate_568622(path: JsonNode;
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
  var valid_568624 = path.getOrDefault("fabricName")
  valid_568624 = validateParameter(valid_568624, JString, required = true,
                                 default = nil)
  if valid_568624 != nil:
    section.add "fabricName", valid_568624
  var valid_568625 = path.getOrDefault("resourceGroupName")
  valid_568625 = validateParameter(valid_568625, JString, required = true,
                                 default = nil)
  if valid_568625 != nil:
    section.add "resourceGroupName", valid_568625
  var valid_568626 = path.getOrDefault("subscriptionId")
  valid_568626 = validateParameter(valid_568626, JString, required = true,
                                 default = nil)
  if valid_568626 != nil:
    section.add "subscriptionId", valid_568626
  var valid_568627 = path.getOrDefault("resourceName")
  valid_568627 = validateParameter(valid_568627, JString, required = true,
                                 default = nil)
  if valid_568627 != nil:
    section.add "resourceName", valid_568627
  var valid_568628 = path.getOrDefault("protectionContainerName")
  valid_568628 = validateParameter(valid_568628, JString, required = true,
                                 default = nil)
  if valid_568628 != nil:
    section.add "protectionContainerName", valid_568628
  var valid_568629 = path.getOrDefault("replicatedProtectedItemName")
  valid_568629 = validateParameter(valid_568629, JString, required = true,
                                 default = nil)
  if valid_568629 != nil:
    section.add "replicatedProtectedItemName", valid_568629
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568630 = query.getOrDefault("api-version")
  valid_568630 = validateParameter(valid_568630, JString, required = true,
                                 default = nil)
  if valid_568630 != nil:
    section.add "api-version", valid_568630
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

proc call*(call_568632: Call_ReplicationProtectedItemsCreate_568621;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create an ASR replication protected item (Enable replication).
  ## 
  let valid = call_568632.validator(path, query, header, formData, body)
  let scheme = call_568632.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568632.url(scheme.get, call_568632.host, call_568632.base,
                         call_568632.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568632, url, valid)

proc call*(call_568633: Call_ReplicationProtectedItemsCreate_568621;
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
  var path_568634 = newJObject()
  var query_568635 = newJObject()
  var body_568636 = newJObject()
  add(path_568634, "fabricName", newJString(fabricName))
  add(path_568634, "resourceGroupName", newJString(resourceGroupName))
  add(query_568635, "api-version", newJString(apiVersion))
  add(path_568634, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_568636 = input
  add(path_568634, "resourceName", newJString(resourceName))
  add(path_568634, "protectionContainerName", newJString(protectionContainerName))
  add(path_568634, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568633.call(path_568634, query_568635, nil, nil, body_568636)

var replicationProtectedItemsCreate* = Call_ReplicationProtectedItemsCreate_568621(
    name: "replicationProtectedItemsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}",
    validator: validate_ReplicationProtectedItemsCreate_568622, base: "",
    url: url_ReplicationProtectedItemsCreate_568623, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsGet_568607 = ref object of OpenApiRestCall_567666
proc url_ReplicationProtectedItemsGet_568609(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectedItemsGet_568608(path: JsonNode; query: JsonNode;
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
  var valid_568610 = path.getOrDefault("fabricName")
  valid_568610 = validateParameter(valid_568610, JString, required = true,
                                 default = nil)
  if valid_568610 != nil:
    section.add "fabricName", valid_568610
  var valid_568611 = path.getOrDefault("resourceGroupName")
  valid_568611 = validateParameter(valid_568611, JString, required = true,
                                 default = nil)
  if valid_568611 != nil:
    section.add "resourceGroupName", valid_568611
  var valid_568612 = path.getOrDefault("subscriptionId")
  valid_568612 = validateParameter(valid_568612, JString, required = true,
                                 default = nil)
  if valid_568612 != nil:
    section.add "subscriptionId", valid_568612
  var valid_568613 = path.getOrDefault("resourceName")
  valid_568613 = validateParameter(valid_568613, JString, required = true,
                                 default = nil)
  if valid_568613 != nil:
    section.add "resourceName", valid_568613
  var valid_568614 = path.getOrDefault("protectionContainerName")
  valid_568614 = validateParameter(valid_568614, JString, required = true,
                                 default = nil)
  if valid_568614 != nil:
    section.add "protectionContainerName", valid_568614
  var valid_568615 = path.getOrDefault("replicatedProtectedItemName")
  valid_568615 = validateParameter(valid_568615, JString, required = true,
                                 default = nil)
  if valid_568615 != nil:
    section.add "replicatedProtectedItemName", valid_568615
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568616 = query.getOrDefault("api-version")
  valid_568616 = validateParameter(valid_568616, JString, required = true,
                                 default = nil)
  if valid_568616 != nil:
    section.add "api-version", valid_568616
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568617: Call_ReplicationProtectedItemsGet_568607; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of an ASR replication protected item.
  ## 
  let valid = call_568617.validator(path, query, header, formData, body)
  let scheme = call_568617.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568617.url(scheme.get, call_568617.host, call_568617.base,
                         call_568617.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568617, url, valid)

proc call*(call_568618: Call_ReplicationProtectedItemsGet_568607;
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
  var path_568619 = newJObject()
  var query_568620 = newJObject()
  add(path_568619, "fabricName", newJString(fabricName))
  add(path_568619, "resourceGroupName", newJString(resourceGroupName))
  add(query_568620, "api-version", newJString(apiVersion))
  add(path_568619, "subscriptionId", newJString(subscriptionId))
  add(path_568619, "resourceName", newJString(resourceName))
  add(path_568619, "protectionContainerName", newJString(protectionContainerName))
  add(path_568619, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568618.call(path_568619, query_568620, nil, nil, nil)

var replicationProtectedItemsGet* = Call_ReplicationProtectedItemsGet_568607(
    name: "replicationProtectedItemsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}",
    validator: validate_ReplicationProtectedItemsGet_568608, base: "",
    url: url_ReplicationProtectedItemsGet_568609, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsUpdate_568651 = ref object of OpenApiRestCall_567666
proc url_ReplicationProtectedItemsUpdate_568653(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectedItemsUpdate_568652(path: JsonNode;
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
  var valid_568654 = path.getOrDefault("fabricName")
  valid_568654 = validateParameter(valid_568654, JString, required = true,
                                 default = nil)
  if valid_568654 != nil:
    section.add "fabricName", valid_568654
  var valid_568655 = path.getOrDefault("resourceGroupName")
  valid_568655 = validateParameter(valid_568655, JString, required = true,
                                 default = nil)
  if valid_568655 != nil:
    section.add "resourceGroupName", valid_568655
  var valid_568656 = path.getOrDefault("subscriptionId")
  valid_568656 = validateParameter(valid_568656, JString, required = true,
                                 default = nil)
  if valid_568656 != nil:
    section.add "subscriptionId", valid_568656
  var valid_568657 = path.getOrDefault("resourceName")
  valid_568657 = validateParameter(valid_568657, JString, required = true,
                                 default = nil)
  if valid_568657 != nil:
    section.add "resourceName", valid_568657
  var valid_568658 = path.getOrDefault("protectionContainerName")
  valid_568658 = validateParameter(valid_568658, JString, required = true,
                                 default = nil)
  if valid_568658 != nil:
    section.add "protectionContainerName", valid_568658
  var valid_568659 = path.getOrDefault("replicatedProtectedItemName")
  valid_568659 = validateParameter(valid_568659, JString, required = true,
                                 default = nil)
  if valid_568659 != nil:
    section.add "replicatedProtectedItemName", valid_568659
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568660 = query.getOrDefault("api-version")
  valid_568660 = validateParameter(valid_568660, JString, required = true,
                                 default = nil)
  if valid_568660 != nil:
    section.add "api-version", valid_568660
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

proc call*(call_568662: Call_ReplicationProtectedItemsUpdate_568651;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to update the recovery settings of an ASR replication protected item.
  ## 
  let valid = call_568662.validator(path, query, header, formData, body)
  let scheme = call_568662.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568662.url(scheme.get, call_568662.host, call_568662.base,
                         call_568662.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568662, url, valid)

proc call*(call_568663: Call_ReplicationProtectedItemsUpdate_568651;
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
  var path_568664 = newJObject()
  var query_568665 = newJObject()
  var body_568666 = newJObject()
  if updateProtectionInput != nil:
    body_568666 = updateProtectionInput
  add(path_568664, "fabricName", newJString(fabricName))
  add(path_568664, "resourceGroupName", newJString(resourceGroupName))
  add(query_568665, "api-version", newJString(apiVersion))
  add(path_568664, "subscriptionId", newJString(subscriptionId))
  add(path_568664, "resourceName", newJString(resourceName))
  add(path_568664, "protectionContainerName", newJString(protectionContainerName))
  add(path_568664, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568663.call(path_568664, query_568665, nil, nil, body_568666)

var replicationProtectedItemsUpdate* = Call_ReplicationProtectedItemsUpdate_568651(
    name: "replicationProtectedItemsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}",
    validator: validate_ReplicationProtectedItemsUpdate_568652, base: "",
    url: url_ReplicationProtectedItemsUpdate_568653, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsPurge_568637 = ref object of OpenApiRestCall_567666
proc url_ReplicationProtectedItemsPurge_568639(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectedItemsPurge_568638(path: JsonNode;
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
  var valid_568640 = path.getOrDefault("fabricName")
  valid_568640 = validateParameter(valid_568640, JString, required = true,
                                 default = nil)
  if valid_568640 != nil:
    section.add "fabricName", valid_568640
  var valid_568641 = path.getOrDefault("resourceGroupName")
  valid_568641 = validateParameter(valid_568641, JString, required = true,
                                 default = nil)
  if valid_568641 != nil:
    section.add "resourceGroupName", valid_568641
  var valid_568642 = path.getOrDefault("subscriptionId")
  valid_568642 = validateParameter(valid_568642, JString, required = true,
                                 default = nil)
  if valid_568642 != nil:
    section.add "subscriptionId", valid_568642
  var valid_568643 = path.getOrDefault("resourceName")
  valid_568643 = validateParameter(valid_568643, JString, required = true,
                                 default = nil)
  if valid_568643 != nil:
    section.add "resourceName", valid_568643
  var valid_568644 = path.getOrDefault("protectionContainerName")
  valid_568644 = validateParameter(valid_568644, JString, required = true,
                                 default = nil)
  if valid_568644 != nil:
    section.add "protectionContainerName", valid_568644
  var valid_568645 = path.getOrDefault("replicatedProtectedItemName")
  valid_568645 = validateParameter(valid_568645, JString, required = true,
                                 default = nil)
  if valid_568645 != nil:
    section.add "replicatedProtectedItemName", valid_568645
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568646 = query.getOrDefault("api-version")
  valid_568646 = validateParameter(valid_568646, JString, required = true,
                                 default = nil)
  if valid_568646 != nil:
    section.add "api-version", valid_568646
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568647: Call_ReplicationProtectedItemsPurge_568637; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete or purge a replication protected item. This operation will force delete the replication protected item. Use the remove operation on replication protected item to perform a clean disable replication for the item.
  ## 
  let valid = call_568647.validator(path, query, header, formData, body)
  let scheme = call_568647.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568647.url(scheme.get, call_568647.host, call_568647.base,
                         call_568647.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568647, url, valid)

proc call*(call_568648: Call_ReplicationProtectedItemsPurge_568637;
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
  var path_568649 = newJObject()
  var query_568650 = newJObject()
  add(path_568649, "fabricName", newJString(fabricName))
  add(path_568649, "resourceGroupName", newJString(resourceGroupName))
  add(query_568650, "api-version", newJString(apiVersion))
  add(path_568649, "subscriptionId", newJString(subscriptionId))
  add(path_568649, "resourceName", newJString(resourceName))
  add(path_568649, "protectionContainerName", newJString(protectionContainerName))
  add(path_568649, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568648.call(path_568649, query_568650, nil, nil, nil)

var replicationProtectedItemsPurge* = Call_ReplicationProtectedItemsPurge_568637(
    name: "replicationProtectedItemsPurge", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}",
    validator: validate_ReplicationProtectedItemsPurge_568638, base: "",
    url: url_ReplicationProtectedItemsPurge_568639, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsApplyRecoveryPoint_568667 = ref object of OpenApiRestCall_567666
proc url_ReplicationProtectedItemsApplyRecoveryPoint_568669(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsApplyRecoveryPoint_568668(path: JsonNode;
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
  var valid_568670 = path.getOrDefault("fabricName")
  valid_568670 = validateParameter(valid_568670, JString, required = true,
                                 default = nil)
  if valid_568670 != nil:
    section.add "fabricName", valid_568670
  var valid_568671 = path.getOrDefault("resourceGroupName")
  valid_568671 = validateParameter(valid_568671, JString, required = true,
                                 default = nil)
  if valid_568671 != nil:
    section.add "resourceGroupName", valid_568671
  var valid_568672 = path.getOrDefault("subscriptionId")
  valid_568672 = validateParameter(valid_568672, JString, required = true,
                                 default = nil)
  if valid_568672 != nil:
    section.add "subscriptionId", valid_568672
  var valid_568673 = path.getOrDefault("resourceName")
  valid_568673 = validateParameter(valid_568673, JString, required = true,
                                 default = nil)
  if valid_568673 != nil:
    section.add "resourceName", valid_568673
  var valid_568674 = path.getOrDefault("protectionContainerName")
  valid_568674 = validateParameter(valid_568674, JString, required = true,
                                 default = nil)
  if valid_568674 != nil:
    section.add "protectionContainerName", valid_568674
  var valid_568675 = path.getOrDefault("replicatedProtectedItemName")
  valid_568675 = validateParameter(valid_568675, JString, required = true,
                                 default = nil)
  if valid_568675 != nil:
    section.add "replicatedProtectedItemName", valid_568675
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568676 = query.getOrDefault("api-version")
  valid_568676 = validateParameter(valid_568676, JString, required = true,
                                 default = nil)
  if valid_568676 != nil:
    section.add "api-version", valid_568676
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

proc call*(call_568678: Call_ReplicationProtectedItemsApplyRecoveryPoint_568667;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to change the recovery point of a failed over replication protected item.
  ## 
  let valid = call_568678.validator(path, query, header, formData, body)
  let scheme = call_568678.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568678.url(scheme.get, call_568678.host, call_568678.base,
                         call_568678.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568678, url, valid)

proc call*(call_568679: Call_ReplicationProtectedItemsApplyRecoveryPoint_568667;
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
  var path_568680 = newJObject()
  var query_568681 = newJObject()
  var body_568682 = newJObject()
  add(path_568680, "fabricName", newJString(fabricName))
  add(path_568680, "resourceGroupName", newJString(resourceGroupName))
  add(query_568681, "api-version", newJString(apiVersion))
  if applyRecoveryPointInput != nil:
    body_568682 = applyRecoveryPointInput
  add(path_568680, "subscriptionId", newJString(subscriptionId))
  add(path_568680, "resourceName", newJString(resourceName))
  add(path_568680, "protectionContainerName", newJString(protectionContainerName))
  add(path_568680, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568679.call(path_568680, query_568681, nil, nil, body_568682)

var replicationProtectedItemsApplyRecoveryPoint* = Call_ReplicationProtectedItemsApplyRecoveryPoint_568667(
    name: "replicationProtectedItemsApplyRecoveryPoint",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/applyRecoveryPoint",
    validator: validate_ReplicationProtectedItemsApplyRecoveryPoint_568668,
    base: "", url: url_ReplicationProtectedItemsApplyRecoveryPoint_568669,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsFailoverCommit_568683 = ref object of OpenApiRestCall_567666
proc url_ReplicationProtectedItemsFailoverCommit_568685(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsFailoverCommit_568684(path: JsonNode;
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
  var valid_568686 = path.getOrDefault("fabricName")
  valid_568686 = validateParameter(valid_568686, JString, required = true,
                                 default = nil)
  if valid_568686 != nil:
    section.add "fabricName", valid_568686
  var valid_568687 = path.getOrDefault("resourceGroupName")
  valid_568687 = validateParameter(valid_568687, JString, required = true,
                                 default = nil)
  if valid_568687 != nil:
    section.add "resourceGroupName", valid_568687
  var valid_568688 = path.getOrDefault("subscriptionId")
  valid_568688 = validateParameter(valid_568688, JString, required = true,
                                 default = nil)
  if valid_568688 != nil:
    section.add "subscriptionId", valid_568688
  var valid_568689 = path.getOrDefault("resourceName")
  valid_568689 = validateParameter(valid_568689, JString, required = true,
                                 default = nil)
  if valid_568689 != nil:
    section.add "resourceName", valid_568689
  var valid_568690 = path.getOrDefault("protectionContainerName")
  valid_568690 = validateParameter(valid_568690, JString, required = true,
                                 default = nil)
  if valid_568690 != nil:
    section.add "protectionContainerName", valid_568690
  var valid_568691 = path.getOrDefault("replicatedProtectedItemName")
  valid_568691 = validateParameter(valid_568691, JString, required = true,
                                 default = nil)
  if valid_568691 != nil:
    section.add "replicatedProtectedItemName", valid_568691
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568692 = query.getOrDefault("api-version")
  valid_568692 = validateParameter(valid_568692, JString, required = true,
                                 default = nil)
  if valid_568692 != nil:
    section.add "api-version", valid_568692
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568693: Call_ReplicationProtectedItemsFailoverCommit_568683;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to commit the failover of the replication protected item.
  ## 
  let valid = call_568693.validator(path, query, header, formData, body)
  let scheme = call_568693.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568693.url(scheme.get, call_568693.host, call_568693.base,
                         call_568693.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568693, url, valid)

proc call*(call_568694: Call_ReplicationProtectedItemsFailoverCommit_568683;
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
  var path_568695 = newJObject()
  var query_568696 = newJObject()
  add(path_568695, "fabricName", newJString(fabricName))
  add(path_568695, "resourceGroupName", newJString(resourceGroupName))
  add(query_568696, "api-version", newJString(apiVersion))
  add(path_568695, "subscriptionId", newJString(subscriptionId))
  add(path_568695, "resourceName", newJString(resourceName))
  add(path_568695, "protectionContainerName", newJString(protectionContainerName))
  add(path_568695, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568694.call(path_568695, query_568696, nil, nil, nil)

var replicationProtectedItemsFailoverCommit* = Call_ReplicationProtectedItemsFailoverCommit_568683(
    name: "replicationProtectedItemsFailoverCommit", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/failoverCommit",
    validator: validate_ReplicationProtectedItemsFailoverCommit_568684, base: "",
    url: url_ReplicationProtectedItemsFailoverCommit_568685,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsPlannedFailover_568697 = ref object of OpenApiRestCall_567666
proc url_ReplicationProtectedItemsPlannedFailover_568699(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsPlannedFailover_568698(path: JsonNode;
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
  var valid_568700 = path.getOrDefault("fabricName")
  valid_568700 = validateParameter(valid_568700, JString, required = true,
                                 default = nil)
  if valid_568700 != nil:
    section.add "fabricName", valid_568700
  var valid_568701 = path.getOrDefault("resourceGroupName")
  valid_568701 = validateParameter(valid_568701, JString, required = true,
                                 default = nil)
  if valid_568701 != nil:
    section.add "resourceGroupName", valid_568701
  var valid_568702 = path.getOrDefault("subscriptionId")
  valid_568702 = validateParameter(valid_568702, JString, required = true,
                                 default = nil)
  if valid_568702 != nil:
    section.add "subscriptionId", valid_568702
  var valid_568703 = path.getOrDefault("resourceName")
  valid_568703 = validateParameter(valid_568703, JString, required = true,
                                 default = nil)
  if valid_568703 != nil:
    section.add "resourceName", valid_568703
  var valid_568704 = path.getOrDefault("protectionContainerName")
  valid_568704 = validateParameter(valid_568704, JString, required = true,
                                 default = nil)
  if valid_568704 != nil:
    section.add "protectionContainerName", valid_568704
  var valid_568705 = path.getOrDefault("replicatedProtectedItemName")
  valid_568705 = validateParameter(valid_568705, JString, required = true,
                                 default = nil)
  if valid_568705 != nil:
    section.add "replicatedProtectedItemName", valid_568705
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568706 = query.getOrDefault("api-version")
  valid_568706 = validateParameter(valid_568706, JString, required = true,
                                 default = nil)
  if valid_568706 != nil:
    section.add "api-version", valid_568706
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

proc call*(call_568708: Call_ReplicationProtectedItemsPlannedFailover_568697;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to initiate a planned failover of the replication protected item.
  ## 
  let valid = call_568708.validator(path, query, header, formData, body)
  let scheme = call_568708.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568708.url(scheme.get, call_568708.host, call_568708.base,
                         call_568708.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568708, url, valid)

proc call*(call_568709: Call_ReplicationProtectedItemsPlannedFailover_568697;
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
  var path_568710 = newJObject()
  var query_568711 = newJObject()
  var body_568712 = newJObject()
  add(path_568710, "fabricName", newJString(fabricName))
  add(path_568710, "resourceGroupName", newJString(resourceGroupName))
  add(query_568711, "api-version", newJString(apiVersion))
  add(path_568710, "subscriptionId", newJString(subscriptionId))
  add(path_568710, "resourceName", newJString(resourceName))
  add(path_568710, "protectionContainerName", newJString(protectionContainerName))
  if failoverInput != nil:
    body_568712 = failoverInput
  add(path_568710, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568709.call(path_568710, query_568711, nil, nil, body_568712)

var replicationProtectedItemsPlannedFailover* = Call_ReplicationProtectedItemsPlannedFailover_568697(
    name: "replicationProtectedItemsPlannedFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/plannedFailover",
    validator: validate_ReplicationProtectedItemsPlannedFailover_568698, base: "",
    url: url_ReplicationProtectedItemsPlannedFailover_568699,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsReprotect_568713 = ref object of OpenApiRestCall_567666
proc url_ReplicationProtectedItemsReprotect_568715(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectedItemsReprotect_568714(path: JsonNode;
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
  var valid_568716 = path.getOrDefault("fabricName")
  valid_568716 = validateParameter(valid_568716, JString, required = true,
                                 default = nil)
  if valid_568716 != nil:
    section.add "fabricName", valid_568716
  var valid_568717 = path.getOrDefault("resourceGroupName")
  valid_568717 = validateParameter(valid_568717, JString, required = true,
                                 default = nil)
  if valid_568717 != nil:
    section.add "resourceGroupName", valid_568717
  var valid_568718 = path.getOrDefault("subscriptionId")
  valid_568718 = validateParameter(valid_568718, JString, required = true,
                                 default = nil)
  if valid_568718 != nil:
    section.add "subscriptionId", valid_568718
  var valid_568719 = path.getOrDefault("resourceName")
  valid_568719 = validateParameter(valid_568719, JString, required = true,
                                 default = nil)
  if valid_568719 != nil:
    section.add "resourceName", valid_568719
  var valid_568720 = path.getOrDefault("protectionContainerName")
  valid_568720 = validateParameter(valid_568720, JString, required = true,
                                 default = nil)
  if valid_568720 != nil:
    section.add "protectionContainerName", valid_568720
  var valid_568721 = path.getOrDefault("replicatedProtectedItemName")
  valid_568721 = validateParameter(valid_568721, JString, required = true,
                                 default = nil)
  if valid_568721 != nil:
    section.add "replicatedProtectedItemName", valid_568721
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568722 = query.getOrDefault("api-version")
  valid_568722 = validateParameter(valid_568722, JString, required = true,
                                 default = nil)
  if valid_568722 != nil:
    section.add "api-version", valid_568722
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

proc call*(call_568724: Call_ReplicationProtectedItemsReprotect_568713;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to reprotect or reverse replicate a failed over replication protected item.
  ## 
  let valid = call_568724.validator(path, query, header, formData, body)
  let scheme = call_568724.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568724.url(scheme.get, call_568724.host, call_568724.base,
                         call_568724.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568724, url, valid)

proc call*(call_568725: Call_ReplicationProtectedItemsReprotect_568713;
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
  var path_568726 = newJObject()
  var query_568727 = newJObject()
  var body_568728 = newJObject()
  add(path_568726, "fabricName", newJString(fabricName))
  add(path_568726, "resourceGroupName", newJString(resourceGroupName))
  add(query_568727, "api-version", newJString(apiVersion))
  add(path_568726, "subscriptionId", newJString(subscriptionId))
  add(path_568726, "resourceName", newJString(resourceName))
  add(path_568726, "protectionContainerName", newJString(protectionContainerName))
  if rrInput != nil:
    body_568728 = rrInput
  add(path_568726, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568725.call(path_568726, query_568727, nil, nil, body_568728)

var replicationProtectedItemsReprotect* = Call_ReplicationProtectedItemsReprotect_568713(
    name: "replicationProtectedItemsReprotect", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/reProtect",
    validator: validate_ReplicationProtectedItemsReprotect_568714, base: "",
    url: url_ReplicationProtectedItemsReprotect_568715, schemes: {Scheme.Https})
type
  Call_RecoveryPointsListByReplicationProtectedItems_568729 = ref object of OpenApiRestCall_567666
proc url_RecoveryPointsListByReplicationProtectedItems_568731(protocol: Scheme;
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

proc validate_RecoveryPointsListByReplicationProtectedItems_568730(
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
  var valid_568732 = path.getOrDefault("fabricName")
  valid_568732 = validateParameter(valid_568732, JString, required = true,
                                 default = nil)
  if valid_568732 != nil:
    section.add "fabricName", valid_568732
  var valid_568733 = path.getOrDefault("resourceGroupName")
  valid_568733 = validateParameter(valid_568733, JString, required = true,
                                 default = nil)
  if valid_568733 != nil:
    section.add "resourceGroupName", valid_568733
  var valid_568734 = path.getOrDefault("subscriptionId")
  valid_568734 = validateParameter(valid_568734, JString, required = true,
                                 default = nil)
  if valid_568734 != nil:
    section.add "subscriptionId", valid_568734
  var valid_568735 = path.getOrDefault("resourceName")
  valid_568735 = validateParameter(valid_568735, JString, required = true,
                                 default = nil)
  if valid_568735 != nil:
    section.add "resourceName", valid_568735
  var valid_568736 = path.getOrDefault("protectionContainerName")
  valid_568736 = validateParameter(valid_568736, JString, required = true,
                                 default = nil)
  if valid_568736 != nil:
    section.add "protectionContainerName", valid_568736
  var valid_568737 = path.getOrDefault("replicatedProtectedItemName")
  valid_568737 = validateParameter(valid_568737, JString, required = true,
                                 default = nil)
  if valid_568737 != nil:
    section.add "replicatedProtectedItemName", valid_568737
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568738 = query.getOrDefault("api-version")
  valid_568738 = validateParameter(valid_568738, JString, required = true,
                                 default = nil)
  if valid_568738 != nil:
    section.add "api-version", valid_568738
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568739: Call_RecoveryPointsListByReplicationProtectedItems_568729;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the available recovery points for a replication protected item.
  ## 
  let valid = call_568739.validator(path, query, header, formData, body)
  let scheme = call_568739.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568739.url(scheme.get, call_568739.host, call_568739.base,
                         call_568739.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568739, url, valid)

proc call*(call_568740: Call_RecoveryPointsListByReplicationProtectedItems_568729;
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
  var path_568741 = newJObject()
  var query_568742 = newJObject()
  add(path_568741, "fabricName", newJString(fabricName))
  add(path_568741, "resourceGroupName", newJString(resourceGroupName))
  add(query_568742, "api-version", newJString(apiVersion))
  add(path_568741, "subscriptionId", newJString(subscriptionId))
  add(path_568741, "resourceName", newJString(resourceName))
  add(path_568741, "protectionContainerName", newJString(protectionContainerName))
  add(path_568741, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568740.call(path_568741, query_568742, nil, nil, nil)

var recoveryPointsListByReplicationProtectedItems* = Call_RecoveryPointsListByReplicationProtectedItems_568729(
    name: "recoveryPointsListByReplicationProtectedItems",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/recoveryPoints",
    validator: validate_RecoveryPointsListByReplicationProtectedItems_568730,
    base: "", url: url_RecoveryPointsListByReplicationProtectedItems_568731,
    schemes: {Scheme.Https})
type
  Call_RecoveryPointsGet_568743 = ref object of OpenApiRestCall_567666
proc url_RecoveryPointsGet_568745(protocol: Scheme; host: string; base: string;
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

proc validate_RecoveryPointsGet_568744(path: JsonNode; query: JsonNode;
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
  var valid_568746 = path.getOrDefault("fabricName")
  valid_568746 = validateParameter(valid_568746, JString, required = true,
                                 default = nil)
  if valid_568746 != nil:
    section.add "fabricName", valid_568746
  var valid_568747 = path.getOrDefault("resourceGroupName")
  valid_568747 = validateParameter(valid_568747, JString, required = true,
                                 default = nil)
  if valid_568747 != nil:
    section.add "resourceGroupName", valid_568747
  var valid_568748 = path.getOrDefault("subscriptionId")
  valid_568748 = validateParameter(valid_568748, JString, required = true,
                                 default = nil)
  if valid_568748 != nil:
    section.add "subscriptionId", valid_568748
  var valid_568749 = path.getOrDefault("resourceName")
  valid_568749 = validateParameter(valid_568749, JString, required = true,
                                 default = nil)
  if valid_568749 != nil:
    section.add "resourceName", valid_568749
  var valid_568750 = path.getOrDefault("recoveryPointName")
  valid_568750 = validateParameter(valid_568750, JString, required = true,
                                 default = nil)
  if valid_568750 != nil:
    section.add "recoveryPointName", valid_568750
  var valid_568751 = path.getOrDefault("protectionContainerName")
  valid_568751 = validateParameter(valid_568751, JString, required = true,
                                 default = nil)
  if valid_568751 != nil:
    section.add "protectionContainerName", valid_568751
  var valid_568752 = path.getOrDefault("replicatedProtectedItemName")
  valid_568752 = validateParameter(valid_568752, JString, required = true,
                                 default = nil)
  if valid_568752 != nil:
    section.add "replicatedProtectedItemName", valid_568752
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568753 = query.getOrDefault("api-version")
  valid_568753 = validateParameter(valid_568753, JString, required = true,
                                 default = nil)
  if valid_568753 != nil:
    section.add "api-version", valid_568753
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568754: Call_RecoveryPointsGet_568743; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the details of specified recovery point.
  ## 
  let valid = call_568754.validator(path, query, header, formData, body)
  let scheme = call_568754.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568754.url(scheme.get, call_568754.host, call_568754.base,
                         call_568754.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568754, url, valid)

proc call*(call_568755: Call_RecoveryPointsGet_568743; fabricName: string;
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
  var path_568756 = newJObject()
  var query_568757 = newJObject()
  add(path_568756, "fabricName", newJString(fabricName))
  add(path_568756, "resourceGroupName", newJString(resourceGroupName))
  add(query_568757, "api-version", newJString(apiVersion))
  add(path_568756, "subscriptionId", newJString(subscriptionId))
  add(path_568756, "resourceName", newJString(resourceName))
  add(path_568756, "recoveryPointName", newJString(recoveryPointName))
  add(path_568756, "protectionContainerName", newJString(protectionContainerName))
  add(path_568756, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568755.call(path_568756, query_568757, nil, nil, nil)

var recoveryPointsGet* = Call_RecoveryPointsGet_568743(name: "recoveryPointsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/recoveryPoints/{recoveryPointName}",
    validator: validate_RecoveryPointsGet_568744, base: "",
    url: url_RecoveryPointsGet_568745, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsDelete_568758 = ref object of OpenApiRestCall_567666
proc url_ReplicationProtectedItemsDelete_568760(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectedItemsDelete_568759(path: JsonNode;
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
  var valid_568761 = path.getOrDefault("fabricName")
  valid_568761 = validateParameter(valid_568761, JString, required = true,
                                 default = nil)
  if valid_568761 != nil:
    section.add "fabricName", valid_568761
  var valid_568762 = path.getOrDefault("resourceGroupName")
  valid_568762 = validateParameter(valid_568762, JString, required = true,
                                 default = nil)
  if valid_568762 != nil:
    section.add "resourceGroupName", valid_568762
  var valid_568763 = path.getOrDefault("subscriptionId")
  valid_568763 = validateParameter(valid_568763, JString, required = true,
                                 default = nil)
  if valid_568763 != nil:
    section.add "subscriptionId", valid_568763
  var valid_568764 = path.getOrDefault("resourceName")
  valid_568764 = validateParameter(valid_568764, JString, required = true,
                                 default = nil)
  if valid_568764 != nil:
    section.add "resourceName", valid_568764
  var valid_568765 = path.getOrDefault("protectionContainerName")
  valid_568765 = validateParameter(valid_568765, JString, required = true,
                                 default = nil)
  if valid_568765 != nil:
    section.add "protectionContainerName", valid_568765
  var valid_568766 = path.getOrDefault("replicatedProtectedItemName")
  valid_568766 = validateParameter(valid_568766, JString, required = true,
                                 default = nil)
  if valid_568766 != nil:
    section.add "replicatedProtectedItemName", valid_568766
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568767 = query.getOrDefault("api-version")
  valid_568767 = validateParameter(valid_568767, JString, required = true,
                                 default = nil)
  if valid_568767 != nil:
    section.add "api-version", valid_568767
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

proc call*(call_568769: Call_ReplicationProtectedItemsDelete_568758;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to disable replication on a replication protected item. This will also remove the item.
  ## 
  let valid = call_568769.validator(path, query, header, formData, body)
  let scheme = call_568769.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568769.url(scheme.get, call_568769.host, call_568769.base,
                         call_568769.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568769, url, valid)

proc call*(call_568770: Call_ReplicationProtectedItemsDelete_568758;
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
  var path_568771 = newJObject()
  var query_568772 = newJObject()
  var body_568773 = newJObject()
  add(path_568771, "fabricName", newJString(fabricName))
  add(path_568771, "resourceGroupName", newJString(resourceGroupName))
  add(query_568772, "api-version", newJString(apiVersion))
  add(path_568771, "subscriptionId", newJString(subscriptionId))
  add(path_568771, "resourceName", newJString(resourceName))
  add(path_568771, "protectionContainerName", newJString(protectionContainerName))
  if disableProtectionInput != nil:
    body_568773 = disableProtectionInput
  add(path_568771, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568770.call(path_568771, query_568772, nil, nil, body_568773)

var replicationProtectedItemsDelete* = Call_ReplicationProtectedItemsDelete_568758(
    name: "replicationProtectedItemsDelete", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/remove",
    validator: validate_ReplicationProtectedItemsDelete_568759, base: "",
    url: url_ReplicationProtectedItemsDelete_568760, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsRepairReplication_568774 = ref object of OpenApiRestCall_567666
proc url_ReplicationProtectedItemsRepairReplication_568776(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsRepairReplication_568775(path: JsonNode;
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
  var valid_568777 = path.getOrDefault("fabricName")
  valid_568777 = validateParameter(valid_568777, JString, required = true,
                                 default = nil)
  if valid_568777 != nil:
    section.add "fabricName", valid_568777
  var valid_568778 = path.getOrDefault("resourceGroupName")
  valid_568778 = validateParameter(valid_568778, JString, required = true,
                                 default = nil)
  if valid_568778 != nil:
    section.add "resourceGroupName", valid_568778
  var valid_568779 = path.getOrDefault("subscriptionId")
  valid_568779 = validateParameter(valid_568779, JString, required = true,
                                 default = nil)
  if valid_568779 != nil:
    section.add "subscriptionId", valid_568779
  var valid_568780 = path.getOrDefault("resourceName")
  valid_568780 = validateParameter(valid_568780, JString, required = true,
                                 default = nil)
  if valid_568780 != nil:
    section.add "resourceName", valid_568780
  var valid_568781 = path.getOrDefault("protectionContainerName")
  valid_568781 = validateParameter(valid_568781, JString, required = true,
                                 default = nil)
  if valid_568781 != nil:
    section.add "protectionContainerName", valid_568781
  var valid_568782 = path.getOrDefault("replicatedProtectedItemName")
  valid_568782 = validateParameter(valid_568782, JString, required = true,
                                 default = nil)
  if valid_568782 != nil:
    section.add "replicatedProtectedItemName", valid_568782
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568783 = query.getOrDefault("api-version")
  valid_568783 = validateParameter(valid_568783, JString, required = true,
                                 default = nil)
  if valid_568783 != nil:
    section.add "api-version", valid_568783
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568784: Call_ReplicationProtectedItemsRepairReplication_568774;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to start resynchronize/repair replication for a replication protected item requiring resynchronization.
  ## 
  let valid = call_568784.validator(path, query, header, formData, body)
  let scheme = call_568784.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568784.url(scheme.get, call_568784.host, call_568784.base,
                         call_568784.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568784, url, valid)

proc call*(call_568785: Call_ReplicationProtectedItemsRepairReplication_568774;
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
  var path_568786 = newJObject()
  var query_568787 = newJObject()
  add(path_568786, "fabricName", newJString(fabricName))
  add(path_568786, "resourceGroupName", newJString(resourceGroupName))
  add(query_568787, "api-version", newJString(apiVersion))
  add(path_568786, "subscriptionId", newJString(subscriptionId))
  add(path_568786, "resourceName", newJString(resourceName))
  add(path_568786, "protectionContainerName", newJString(protectionContainerName))
  add(path_568786, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568785.call(path_568786, query_568787, nil, nil, nil)

var replicationProtectedItemsRepairReplication* = Call_ReplicationProtectedItemsRepairReplication_568774(
    name: "replicationProtectedItemsRepairReplication", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/repairReplication",
    validator: validate_ReplicationProtectedItemsRepairReplication_568775,
    base: "", url: url_ReplicationProtectedItemsRepairReplication_568776,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsTestFailover_568788 = ref object of OpenApiRestCall_567666
proc url_ReplicationProtectedItemsTestFailover_568790(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsTestFailover_568789(path: JsonNode;
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
  var valid_568791 = path.getOrDefault("fabricName")
  valid_568791 = validateParameter(valid_568791, JString, required = true,
                                 default = nil)
  if valid_568791 != nil:
    section.add "fabricName", valid_568791
  var valid_568792 = path.getOrDefault("resourceGroupName")
  valid_568792 = validateParameter(valid_568792, JString, required = true,
                                 default = nil)
  if valid_568792 != nil:
    section.add "resourceGroupName", valid_568792
  var valid_568793 = path.getOrDefault("subscriptionId")
  valid_568793 = validateParameter(valid_568793, JString, required = true,
                                 default = nil)
  if valid_568793 != nil:
    section.add "subscriptionId", valid_568793
  var valid_568794 = path.getOrDefault("resourceName")
  valid_568794 = validateParameter(valid_568794, JString, required = true,
                                 default = nil)
  if valid_568794 != nil:
    section.add "resourceName", valid_568794
  var valid_568795 = path.getOrDefault("protectionContainerName")
  valid_568795 = validateParameter(valid_568795, JString, required = true,
                                 default = nil)
  if valid_568795 != nil:
    section.add "protectionContainerName", valid_568795
  var valid_568796 = path.getOrDefault("replicatedProtectedItemName")
  valid_568796 = validateParameter(valid_568796, JString, required = true,
                                 default = nil)
  if valid_568796 != nil:
    section.add "replicatedProtectedItemName", valid_568796
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568797 = query.getOrDefault("api-version")
  valid_568797 = validateParameter(valid_568797, JString, required = true,
                                 default = nil)
  if valid_568797 != nil:
    section.add "api-version", valid_568797
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

proc call*(call_568799: Call_ReplicationProtectedItemsTestFailover_568788;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to perform a test failover of the replication protected item.
  ## 
  let valid = call_568799.validator(path, query, header, formData, body)
  let scheme = call_568799.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568799.url(scheme.get, call_568799.host, call_568799.base,
                         call_568799.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568799, url, valid)

proc call*(call_568800: Call_ReplicationProtectedItemsTestFailover_568788;
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
  var path_568801 = newJObject()
  var query_568802 = newJObject()
  var body_568803 = newJObject()
  add(path_568801, "fabricName", newJString(fabricName))
  add(path_568801, "resourceGroupName", newJString(resourceGroupName))
  add(query_568802, "api-version", newJString(apiVersion))
  add(path_568801, "subscriptionId", newJString(subscriptionId))
  add(path_568801, "resourceName", newJString(resourceName))
  add(path_568801, "protectionContainerName", newJString(protectionContainerName))
  if failoverInput != nil:
    body_568803 = failoverInput
  add(path_568801, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568800.call(path_568801, query_568802, nil, nil, body_568803)

var replicationProtectedItemsTestFailover* = Call_ReplicationProtectedItemsTestFailover_568788(
    name: "replicationProtectedItemsTestFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/testFailover",
    validator: validate_ReplicationProtectedItemsTestFailover_568789, base: "",
    url: url_ReplicationProtectedItemsTestFailover_568790, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsTestFailoverCleanup_568804 = ref object of OpenApiRestCall_567666
proc url_ReplicationProtectedItemsTestFailoverCleanup_568806(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsTestFailoverCleanup_568805(path: JsonNode;
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
  var valid_568807 = path.getOrDefault("fabricName")
  valid_568807 = validateParameter(valid_568807, JString, required = true,
                                 default = nil)
  if valid_568807 != nil:
    section.add "fabricName", valid_568807
  var valid_568808 = path.getOrDefault("resourceGroupName")
  valid_568808 = validateParameter(valid_568808, JString, required = true,
                                 default = nil)
  if valid_568808 != nil:
    section.add "resourceGroupName", valid_568808
  var valid_568809 = path.getOrDefault("subscriptionId")
  valid_568809 = validateParameter(valid_568809, JString, required = true,
                                 default = nil)
  if valid_568809 != nil:
    section.add "subscriptionId", valid_568809
  var valid_568810 = path.getOrDefault("resourceName")
  valid_568810 = validateParameter(valid_568810, JString, required = true,
                                 default = nil)
  if valid_568810 != nil:
    section.add "resourceName", valid_568810
  var valid_568811 = path.getOrDefault("protectionContainerName")
  valid_568811 = validateParameter(valid_568811, JString, required = true,
                                 default = nil)
  if valid_568811 != nil:
    section.add "protectionContainerName", valid_568811
  var valid_568812 = path.getOrDefault("replicatedProtectedItemName")
  valid_568812 = validateParameter(valid_568812, JString, required = true,
                                 default = nil)
  if valid_568812 != nil:
    section.add "replicatedProtectedItemName", valid_568812
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568813 = query.getOrDefault("api-version")
  valid_568813 = validateParameter(valid_568813, JString, required = true,
                                 default = nil)
  if valid_568813 != nil:
    section.add "api-version", valid_568813
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

proc call*(call_568815: Call_ReplicationProtectedItemsTestFailoverCleanup_568804;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to clean up the test failover of a replication protected item.
  ## 
  let valid = call_568815.validator(path, query, header, formData, body)
  let scheme = call_568815.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568815.url(scheme.get, call_568815.host, call_568815.base,
                         call_568815.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568815, url, valid)

proc call*(call_568816: Call_ReplicationProtectedItemsTestFailoverCleanup_568804;
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
  var path_568817 = newJObject()
  var query_568818 = newJObject()
  var body_568819 = newJObject()
  add(path_568817, "fabricName", newJString(fabricName))
  add(path_568817, "resourceGroupName", newJString(resourceGroupName))
  add(query_568818, "api-version", newJString(apiVersion))
  if cleanupInput != nil:
    body_568819 = cleanupInput
  add(path_568817, "subscriptionId", newJString(subscriptionId))
  add(path_568817, "resourceName", newJString(resourceName))
  add(path_568817, "protectionContainerName", newJString(protectionContainerName))
  add(path_568817, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568816.call(path_568817, query_568818, nil, nil, body_568819)

var replicationProtectedItemsTestFailoverCleanup* = Call_ReplicationProtectedItemsTestFailoverCleanup_568804(
    name: "replicationProtectedItemsTestFailoverCleanup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/testFailoverCleanup",
    validator: validate_ReplicationProtectedItemsTestFailoverCleanup_568805,
    base: "", url: url_ReplicationProtectedItemsTestFailoverCleanup_568806,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsUnplannedFailover_568820 = ref object of OpenApiRestCall_567666
proc url_ReplicationProtectedItemsUnplannedFailover_568822(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsUnplannedFailover_568821(path: JsonNode;
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
  var valid_568823 = path.getOrDefault("fabricName")
  valid_568823 = validateParameter(valid_568823, JString, required = true,
                                 default = nil)
  if valid_568823 != nil:
    section.add "fabricName", valid_568823
  var valid_568824 = path.getOrDefault("resourceGroupName")
  valid_568824 = validateParameter(valid_568824, JString, required = true,
                                 default = nil)
  if valid_568824 != nil:
    section.add "resourceGroupName", valid_568824
  var valid_568825 = path.getOrDefault("subscriptionId")
  valid_568825 = validateParameter(valid_568825, JString, required = true,
                                 default = nil)
  if valid_568825 != nil:
    section.add "subscriptionId", valid_568825
  var valid_568826 = path.getOrDefault("resourceName")
  valid_568826 = validateParameter(valid_568826, JString, required = true,
                                 default = nil)
  if valid_568826 != nil:
    section.add "resourceName", valid_568826
  var valid_568827 = path.getOrDefault("protectionContainerName")
  valid_568827 = validateParameter(valid_568827, JString, required = true,
                                 default = nil)
  if valid_568827 != nil:
    section.add "protectionContainerName", valid_568827
  var valid_568828 = path.getOrDefault("replicatedProtectedItemName")
  valid_568828 = validateParameter(valid_568828, JString, required = true,
                                 default = nil)
  if valid_568828 != nil:
    section.add "replicatedProtectedItemName", valid_568828
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568829 = query.getOrDefault("api-version")
  valid_568829 = validateParameter(valid_568829, JString, required = true,
                                 default = nil)
  if valid_568829 != nil:
    section.add "api-version", valid_568829
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

proc call*(call_568831: Call_ReplicationProtectedItemsUnplannedFailover_568820;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to initiate a failover of the replication protected item.
  ## 
  let valid = call_568831.validator(path, query, header, formData, body)
  let scheme = call_568831.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568831.url(scheme.get, call_568831.host, call_568831.base,
                         call_568831.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568831, url, valid)

proc call*(call_568832: Call_ReplicationProtectedItemsUnplannedFailover_568820;
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
  var path_568833 = newJObject()
  var query_568834 = newJObject()
  var body_568835 = newJObject()
  add(path_568833, "fabricName", newJString(fabricName))
  add(path_568833, "resourceGroupName", newJString(resourceGroupName))
  add(query_568834, "api-version", newJString(apiVersion))
  add(path_568833, "subscriptionId", newJString(subscriptionId))
  add(path_568833, "resourceName", newJString(resourceName))
  add(path_568833, "protectionContainerName", newJString(protectionContainerName))
  if failoverInput != nil:
    body_568835 = failoverInput
  add(path_568833, "replicatedProtectedItemName",
      newJString(replicatedProtectedItemName))
  result = call_568832.call(path_568833, query_568834, nil, nil, body_568835)

var replicationProtectedItemsUnplannedFailover* = Call_ReplicationProtectedItemsUnplannedFailover_568820(
    name: "replicationProtectedItemsUnplannedFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicatedProtectedItemName}/unplannedFailover",
    validator: validate_ReplicationProtectedItemsUnplannedFailover_568821,
    base: "", url: url_ReplicationProtectedItemsUnplannedFailover_568822,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsUpdateMobilityService_568836 = ref object of OpenApiRestCall_567666
proc url_ReplicationProtectedItemsUpdateMobilityService_568838(protocol: Scheme;
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

proc validate_ReplicationProtectedItemsUpdateMobilityService_568837(
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
  var valid_568839 = path.getOrDefault("fabricName")
  valid_568839 = validateParameter(valid_568839, JString, required = true,
                                 default = nil)
  if valid_568839 != nil:
    section.add "fabricName", valid_568839
  var valid_568840 = path.getOrDefault("resourceGroupName")
  valid_568840 = validateParameter(valid_568840, JString, required = true,
                                 default = nil)
  if valid_568840 != nil:
    section.add "resourceGroupName", valid_568840
  var valid_568841 = path.getOrDefault("subscriptionId")
  valid_568841 = validateParameter(valid_568841, JString, required = true,
                                 default = nil)
  if valid_568841 != nil:
    section.add "subscriptionId", valid_568841
  var valid_568842 = path.getOrDefault("resourceName")
  valid_568842 = validateParameter(valid_568842, JString, required = true,
                                 default = nil)
  if valid_568842 != nil:
    section.add "resourceName", valid_568842
  var valid_568843 = path.getOrDefault("protectionContainerName")
  valid_568843 = validateParameter(valid_568843, JString, required = true,
                                 default = nil)
  if valid_568843 != nil:
    section.add "protectionContainerName", valid_568843
  var valid_568844 = path.getOrDefault("replicationProtectedItemName")
  valid_568844 = validateParameter(valid_568844, JString, required = true,
                                 default = nil)
  if valid_568844 != nil:
    section.add "replicationProtectedItemName", valid_568844
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568845 = query.getOrDefault("api-version")
  valid_568845 = validateParameter(valid_568845, JString, required = true,
                                 default = nil)
  if valid_568845 != nil:
    section.add "api-version", valid_568845
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

proc call*(call_568847: Call_ReplicationProtectedItemsUpdateMobilityService_568836;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to update(push update) the installed mobility service software on a replication protected item to the latest available version.
  ## 
  let valid = call_568847.validator(path, query, header, formData, body)
  let scheme = call_568847.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568847.url(scheme.get, call_568847.host, call_568847.base,
                         call_568847.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568847, url, valid)

proc call*(call_568848: Call_ReplicationProtectedItemsUpdateMobilityService_568836;
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
  var path_568849 = newJObject()
  var query_568850 = newJObject()
  var body_568851 = newJObject()
  add(path_568849, "fabricName", newJString(fabricName))
  add(path_568849, "resourceGroupName", newJString(resourceGroupName))
  add(query_568850, "api-version", newJString(apiVersion))
  if updateMobilityServiceRequest != nil:
    body_568851 = updateMobilityServiceRequest
  add(path_568849, "subscriptionId", newJString(subscriptionId))
  add(path_568849, "resourceName", newJString(resourceName))
  add(path_568849, "protectionContainerName", newJString(protectionContainerName))
  add(path_568849, "replicationProtectedItemName",
      newJString(replicationProtectedItemName))
  result = call_568848.call(path_568849, query_568850, nil, nil, body_568851)

var replicationProtectedItemsUpdateMobilityService* = Call_ReplicationProtectedItemsUpdateMobilityService_568836(
    name: "replicationProtectedItemsUpdateMobilityService",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectedItems/{replicationProtectedItemName}/updateMobilityService",
    validator: validate_ReplicationProtectedItemsUpdateMobilityService_568837,
    base: "", url: url_ReplicationProtectedItemsUpdateMobilityService_568838,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_568852 = ref object of OpenApiRestCall_567666
proc url_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_568854(
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

proc validate_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_568853(
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
  var valid_568855 = path.getOrDefault("fabricName")
  valid_568855 = validateParameter(valid_568855, JString, required = true,
                                 default = nil)
  if valid_568855 != nil:
    section.add "fabricName", valid_568855
  var valid_568856 = path.getOrDefault("resourceGroupName")
  valid_568856 = validateParameter(valid_568856, JString, required = true,
                                 default = nil)
  if valid_568856 != nil:
    section.add "resourceGroupName", valid_568856
  var valid_568857 = path.getOrDefault("subscriptionId")
  valid_568857 = validateParameter(valid_568857, JString, required = true,
                                 default = nil)
  if valid_568857 != nil:
    section.add "subscriptionId", valid_568857
  var valid_568858 = path.getOrDefault("resourceName")
  valid_568858 = validateParameter(valid_568858, JString, required = true,
                                 default = nil)
  if valid_568858 != nil:
    section.add "resourceName", valid_568858
  var valid_568859 = path.getOrDefault("protectionContainerName")
  valid_568859 = validateParameter(valid_568859, JString, required = true,
                                 default = nil)
  if valid_568859 != nil:
    section.add "protectionContainerName", valid_568859
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
  if body != nil:
    result.add "body", body

proc call*(call_568861: Call_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_568852;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the protection container mappings for a protection container.
  ## 
  let valid = call_568861.validator(path, query, header, formData, body)
  let scheme = call_568861.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568861.url(scheme.get, call_568861.host, call_568861.base,
                         call_568861.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568861, url, valid)

proc call*(call_568862: Call_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_568852;
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
  var path_568863 = newJObject()
  var query_568864 = newJObject()
  add(path_568863, "fabricName", newJString(fabricName))
  add(path_568863, "resourceGroupName", newJString(resourceGroupName))
  add(query_568864, "api-version", newJString(apiVersion))
  add(path_568863, "subscriptionId", newJString(subscriptionId))
  add(path_568863, "resourceName", newJString(resourceName))
  add(path_568863, "protectionContainerName", newJString(protectionContainerName))
  result = call_568862.call(path_568863, query_568864, nil, nil, nil)

var replicationProtectionContainerMappingsListByReplicationProtectionContainers* = Call_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_568852(name: "replicationProtectionContainerMappingsListByReplicationProtectionContainers",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings", validator: validate_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_568853,
    base: "", url: url_ReplicationProtectionContainerMappingsListByReplicationProtectionContainers_568854,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsCreate_568879 = ref object of OpenApiRestCall_567666
proc url_ReplicationProtectionContainerMappingsCreate_568881(protocol: Scheme;
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

proc validate_ReplicationProtectionContainerMappingsCreate_568880(path: JsonNode;
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
  var valid_568882 = path.getOrDefault("fabricName")
  valid_568882 = validateParameter(valid_568882, JString, required = true,
                                 default = nil)
  if valid_568882 != nil:
    section.add "fabricName", valid_568882
  var valid_568883 = path.getOrDefault("resourceGroupName")
  valid_568883 = validateParameter(valid_568883, JString, required = true,
                                 default = nil)
  if valid_568883 != nil:
    section.add "resourceGroupName", valid_568883
  var valid_568884 = path.getOrDefault("mappingName")
  valid_568884 = validateParameter(valid_568884, JString, required = true,
                                 default = nil)
  if valid_568884 != nil:
    section.add "mappingName", valid_568884
  var valid_568885 = path.getOrDefault("subscriptionId")
  valid_568885 = validateParameter(valid_568885, JString, required = true,
                                 default = nil)
  if valid_568885 != nil:
    section.add "subscriptionId", valid_568885
  var valid_568886 = path.getOrDefault("resourceName")
  valid_568886 = validateParameter(valid_568886, JString, required = true,
                                 default = nil)
  if valid_568886 != nil:
    section.add "resourceName", valid_568886
  var valid_568887 = path.getOrDefault("protectionContainerName")
  valid_568887 = validateParameter(valid_568887, JString, required = true,
                                 default = nil)
  if valid_568887 != nil:
    section.add "protectionContainerName", valid_568887
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568888 = query.getOrDefault("api-version")
  valid_568888 = validateParameter(valid_568888, JString, required = true,
                                 default = nil)
  if valid_568888 != nil:
    section.add "api-version", valid_568888
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

proc call*(call_568890: Call_ReplicationProtectionContainerMappingsCreate_568879;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create a protection container mapping.
  ## 
  let valid = call_568890.validator(path, query, header, formData, body)
  let scheme = call_568890.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568890.url(scheme.get, call_568890.host, call_568890.base,
                         call_568890.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568890, url, valid)

proc call*(call_568891: Call_ReplicationProtectionContainerMappingsCreate_568879;
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
  var path_568892 = newJObject()
  var query_568893 = newJObject()
  var body_568894 = newJObject()
  add(path_568892, "fabricName", newJString(fabricName))
  add(path_568892, "resourceGroupName", newJString(resourceGroupName))
  add(query_568893, "api-version", newJString(apiVersion))
  add(path_568892, "mappingName", newJString(mappingName))
  if creationInput != nil:
    body_568894 = creationInput
  add(path_568892, "subscriptionId", newJString(subscriptionId))
  add(path_568892, "resourceName", newJString(resourceName))
  add(path_568892, "protectionContainerName", newJString(protectionContainerName))
  result = call_568891.call(path_568892, query_568893, nil, nil, body_568894)

var replicationProtectionContainerMappingsCreate* = Call_ReplicationProtectionContainerMappingsCreate_568879(
    name: "replicationProtectionContainerMappingsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}",
    validator: validate_ReplicationProtectionContainerMappingsCreate_568880,
    base: "", url: url_ReplicationProtectionContainerMappingsCreate_568881,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsGet_568865 = ref object of OpenApiRestCall_567666
proc url_ReplicationProtectionContainerMappingsGet_568867(protocol: Scheme;
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

proc validate_ReplicationProtectionContainerMappingsGet_568866(path: JsonNode;
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
  var valid_568868 = path.getOrDefault("fabricName")
  valid_568868 = validateParameter(valid_568868, JString, required = true,
                                 default = nil)
  if valid_568868 != nil:
    section.add "fabricName", valid_568868
  var valid_568869 = path.getOrDefault("resourceGroupName")
  valid_568869 = validateParameter(valid_568869, JString, required = true,
                                 default = nil)
  if valid_568869 != nil:
    section.add "resourceGroupName", valid_568869
  var valid_568870 = path.getOrDefault("mappingName")
  valid_568870 = validateParameter(valid_568870, JString, required = true,
                                 default = nil)
  if valid_568870 != nil:
    section.add "mappingName", valid_568870
  var valid_568871 = path.getOrDefault("subscriptionId")
  valid_568871 = validateParameter(valid_568871, JString, required = true,
                                 default = nil)
  if valid_568871 != nil:
    section.add "subscriptionId", valid_568871
  var valid_568872 = path.getOrDefault("resourceName")
  valid_568872 = validateParameter(valid_568872, JString, required = true,
                                 default = nil)
  if valid_568872 != nil:
    section.add "resourceName", valid_568872
  var valid_568873 = path.getOrDefault("protectionContainerName")
  valid_568873 = validateParameter(valid_568873, JString, required = true,
                                 default = nil)
  if valid_568873 != nil:
    section.add "protectionContainerName", valid_568873
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568874 = query.getOrDefault("api-version")
  valid_568874 = validateParameter(valid_568874, JString, required = true,
                                 default = nil)
  if valid_568874 != nil:
    section.add "api-version", valid_568874
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568875: Call_ReplicationProtectionContainerMappingsGet_568865;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of a protection container mapping.
  ## 
  let valid = call_568875.validator(path, query, header, formData, body)
  let scheme = call_568875.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568875.url(scheme.get, call_568875.host, call_568875.base,
                         call_568875.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568875, url, valid)

proc call*(call_568876: Call_ReplicationProtectionContainerMappingsGet_568865;
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
  var path_568877 = newJObject()
  var query_568878 = newJObject()
  add(path_568877, "fabricName", newJString(fabricName))
  add(path_568877, "resourceGroupName", newJString(resourceGroupName))
  add(query_568878, "api-version", newJString(apiVersion))
  add(path_568877, "mappingName", newJString(mappingName))
  add(path_568877, "subscriptionId", newJString(subscriptionId))
  add(path_568877, "resourceName", newJString(resourceName))
  add(path_568877, "protectionContainerName", newJString(protectionContainerName))
  result = call_568876.call(path_568877, query_568878, nil, nil, nil)

var replicationProtectionContainerMappingsGet* = Call_ReplicationProtectionContainerMappingsGet_568865(
    name: "replicationProtectionContainerMappingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}",
    validator: validate_ReplicationProtectionContainerMappingsGet_568866,
    base: "", url: url_ReplicationProtectionContainerMappingsGet_568867,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsPurge_568895 = ref object of OpenApiRestCall_567666
proc url_ReplicationProtectionContainerMappingsPurge_568897(protocol: Scheme;
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

proc validate_ReplicationProtectionContainerMappingsPurge_568896(path: JsonNode;
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
  var valid_568898 = path.getOrDefault("fabricName")
  valid_568898 = validateParameter(valid_568898, JString, required = true,
                                 default = nil)
  if valid_568898 != nil:
    section.add "fabricName", valid_568898
  var valid_568899 = path.getOrDefault("resourceGroupName")
  valid_568899 = validateParameter(valid_568899, JString, required = true,
                                 default = nil)
  if valid_568899 != nil:
    section.add "resourceGroupName", valid_568899
  var valid_568900 = path.getOrDefault("mappingName")
  valid_568900 = validateParameter(valid_568900, JString, required = true,
                                 default = nil)
  if valid_568900 != nil:
    section.add "mappingName", valid_568900
  var valid_568901 = path.getOrDefault("subscriptionId")
  valid_568901 = validateParameter(valid_568901, JString, required = true,
                                 default = nil)
  if valid_568901 != nil:
    section.add "subscriptionId", valid_568901
  var valid_568902 = path.getOrDefault("resourceName")
  valid_568902 = validateParameter(valid_568902, JString, required = true,
                                 default = nil)
  if valid_568902 != nil:
    section.add "resourceName", valid_568902
  var valid_568903 = path.getOrDefault("protectionContainerName")
  valid_568903 = validateParameter(valid_568903, JString, required = true,
                                 default = nil)
  if valid_568903 != nil:
    section.add "protectionContainerName", valid_568903
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568904 = query.getOrDefault("api-version")
  valid_568904 = validateParameter(valid_568904, JString, required = true,
                                 default = nil)
  if valid_568904 != nil:
    section.add "api-version", valid_568904
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568905: Call_ReplicationProtectionContainerMappingsPurge_568895;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to purge(force delete) a protection container mapping
  ## 
  let valid = call_568905.validator(path, query, header, formData, body)
  let scheme = call_568905.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568905.url(scheme.get, call_568905.host, call_568905.base,
                         call_568905.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568905, url, valid)

proc call*(call_568906: Call_ReplicationProtectionContainerMappingsPurge_568895;
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
  var path_568907 = newJObject()
  var query_568908 = newJObject()
  add(path_568907, "fabricName", newJString(fabricName))
  add(path_568907, "resourceGroupName", newJString(resourceGroupName))
  add(query_568908, "api-version", newJString(apiVersion))
  add(path_568907, "mappingName", newJString(mappingName))
  add(path_568907, "subscriptionId", newJString(subscriptionId))
  add(path_568907, "resourceName", newJString(resourceName))
  add(path_568907, "protectionContainerName", newJString(protectionContainerName))
  result = call_568906.call(path_568907, query_568908, nil, nil, nil)

var replicationProtectionContainerMappingsPurge* = Call_ReplicationProtectionContainerMappingsPurge_568895(
    name: "replicationProtectionContainerMappingsPurge",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}",
    validator: validate_ReplicationProtectionContainerMappingsPurge_568896,
    base: "", url: url_ReplicationProtectionContainerMappingsPurge_568897,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsDelete_568909 = ref object of OpenApiRestCall_567666
proc url_ReplicationProtectionContainerMappingsDelete_568911(protocol: Scheme;
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

proc validate_ReplicationProtectionContainerMappingsDelete_568910(path: JsonNode;
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
  var valid_568912 = path.getOrDefault("fabricName")
  valid_568912 = validateParameter(valid_568912, JString, required = true,
                                 default = nil)
  if valid_568912 != nil:
    section.add "fabricName", valid_568912
  var valid_568913 = path.getOrDefault("resourceGroupName")
  valid_568913 = validateParameter(valid_568913, JString, required = true,
                                 default = nil)
  if valid_568913 != nil:
    section.add "resourceGroupName", valid_568913
  var valid_568914 = path.getOrDefault("mappingName")
  valid_568914 = validateParameter(valid_568914, JString, required = true,
                                 default = nil)
  if valid_568914 != nil:
    section.add "mappingName", valid_568914
  var valid_568915 = path.getOrDefault("subscriptionId")
  valid_568915 = validateParameter(valid_568915, JString, required = true,
                                 default = nil)
  if valid_568915 != nil:
    section.add "subscriptionId", valid_568915
  var valid_568916 = path.getOrDefault("resourceName")
  valid_568916 = validateParameter(valid_568916, JString, required = true,
                                 default = nil)
  if valid_568916 != nil:
    section.add "resourceName", valid_568916
  var valid_568917 = path.getOrDefault("protectionContainerName")
  valid_568917 = validateParameter(valid_568917, JString, required = true,
                                 default = nil)
  if valid_568917 != nil:
    section.add "protectionContainerName", valid_568917
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568918 = query.getOrDefault("api-version")
  valid_568918 = validateParameter(valid_568918, JString, required = true,
                                 default = nil)
  if valid_568918 != nil:
    section.add "api-version", valid_568918
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

proc call*(call_568920: Call_ReplicationProtectionContainerMappingsDelete_568909;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete or remove a protection container mapping.
  ## 
  let valid = call_568920.validator(path, query, header, formData, body)
  let scheme = call_568920.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568920.url(scheme.get, call_568920.host, call_568920.base,
                         call_568920.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568920, url, valid)

proc call*(call_568921: Call_ReplicationProtectionContainerMappingsDelete_568909;
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
  var path_568922 = newJObject()
  var query_568923 = newJObject()
  var body_568924 = newJObject()
  add(path_568922, "fabricName", newJString(fabricName))
  add(path_568922, "resourceGroupName", newJString(resourceGroupName))
  add(query_568923, "api-version", newJString(apiVersion))
  add(path_568922, "mappingName", newJString(mappingName))
  add(path_568922, "subscriptionId", newJString(subscriptionId))
  add(path_568922, "resourceName", newJString(resourceName))
  add(path_568922, "protectionContainerName", newJString(protectionContainerName))
  if removalInput != nil:
    body_568924 = removalInput
  result = call_568921.call(path_568922, query_568923, nil, nil, body_568924)

var replicationProtectionContainerMappingsDelete* = Call_ReplicationProtectionContainerMappingsDelete_568909(
    name: "replicationProtectionContainerMappingsDelete",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/replicationProtectionContainerMappings/{mappingName}/remove",
    validator: validate_ReplicationProtectionContainerMappingsDelete_568910,
    base: "", url: url_ReplicationProtectionContainerMappingsDelete_568911,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersSwitchProtection_568925 = ref object of OpenApiRestCall_567666
proc url_ReplicationProtectionContainersSwitchProtection_568927(protocol: Scheme;
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

proc validate_ReplicationProtectionContainersSwitchProtection_568926(
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
  var valid_568928 = path.getOrDefault("fabricName")
  valid_568928 = validateParameter(valid_568928, JString, required = true,
                                 default = nil)
  if valid_568928 != nil:
    section.add "fabricName", valid_568928
  var valid_568929 = path.getOrDefault("resourceGroupName")
  valid_568929 = validateParameter(valid_568929, JString, required = true,
                                 default = nil)
  if valid_568929 != nil:
    section.add "resourceGroupName", valid_568929
  var valid_568930 = path.getOrDefault("subscriptionId")
  valid_568930 = validateParameter(valid_568930, JString, required = true,
                                 default = nil)
  if valid_568930 != nil:
    section.add "subscriptionId", valid_568930
  var valid_568931 = path.getOrDefault("resourceName")
  valid_568931 = validateParameter(valid_568931, JString, required = true,
                                 default = nil)
  if valid_568931 != nil:
    section.add "resourceName", valid_568931
  var valid_568932 = path.getOrDefault("protectionContainerName")
  valid_568932 = validateParameter(valid_568932, JString, required = true,
                                 default = nil)
  if valid_568932 != nil:
    section.add "protectionContainerName", valid_568932
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568933 = query.getOrDefault("api-version")
  valid_568933 = validateParameter(valid_568933, JString, required = true,
                                 default = nil)
  if valid_568933 != nil:
    section.add "api-version", valid_568933
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

proc call*(call_568935: Call_ReplicationProtectionContainersSwitchProtection_568925;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Operation to switch protection from one container to another or one replication provider to another.
  ## 
  let valid = call_568935.validator(path, query, header, formData, body)
  let scheme = call_568935.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568935.url(scheme.get, call_568935.host, call_568935.base,
                         call_568935.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568935, url, valid)

proc call*(call_568936: Call_ReplicationProtectionContainersSwitchProtection_568925;
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
  var path_568937 = newJObject()
  var query_568938 = newJObject()
  var body_568939 = newJObject()
  add(path_568937, "fabricName", newJString(fabricName))
  add(path_568937, "resourceGroupName", newJString(resourceGroupName))
  add(query_568938, "api-version", newJString(apiVersion))
  add(path_568937, "subscriptionId", newJString(subscriptionId))
  add(path_568937, "resourceName", newJString(resourceName))
  add(path_568937, "protectionContainerName", newJString(protectionContainerName))
  if switchInput != nil:
    body_568939 = switchInput
  result = call_568936.call(path_568937, query_568938, nil, nil, body_568939)

var replicationProtectionContainersSwitchProtection* = Call_ReplicationProtectionContainersSwitchProtection_568925(
    name: "replicationProtectionContainersSwitchProtection",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationProtectionContainers/{protectionContainerName}/switchprotection",
    validator: validate_ReplicationProtectionContainersSwitchProtection_568926,
    base: "", url: url_ReplicationProtectionContainersSwitchProtection_568927,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersListByReplicationFabrics_568940 = ref object of OpenApiRestCall_567666
proc url_ReplicationRecoveryServicesProvidersListByReplicationFabrics_568942(
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

proc validate_ReplicationRecoveryServicesProvidersListByReplicationFabrics_568941(
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
  var valid_568943 = path.getOrDefault("fabricName")
  valid_568943 = validateParameter(valid_568943, JString, required = true,
                                 default = nil)
  if valid_568943 != nil:
    section.add "fabricName", valid_568943
  var valid_568944 = path.getOrDefault("resourceGroupName")
  valid_568944 = validateParameter(valid_568944, JString, required = true,
                                 default = nil)
  if valid_568944 != nil:
    section.add "resourceGroupName", valid_568944
  var valid_568945 = path.getOrDefault("subscriptionId")
  valid_568945 = validateParameter(valid_568945, JString, required = true,
                                 default = nil)
  if valid_568945 != nil:
    section.add "subscriptionId", valid_568945
  var valid_568946 = path.getOrDefault("resourceName")
  valid_568946 = validateParameter(valid_568946, JString, required = true,
                                 default = nil)
  if valid_568946 != nil:
    section.add "resourceName", valid_568946
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568947 = query.getOrDefault("api-version")
  valid_568947 = validateParameter(valid_568947, JString, required = true,
                                 default = nil)
  if valid_568947 != nil:
    section.add "api-version", valid_568947
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568948: Call_ReplicationRecoveryServicesProvidersListByReplicationFabrics_568940;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the registered recovery services providers for the specified fabric.
  ## 
  let valid = call_568948.validator(path, query, header, formData, body)
  let scheme = call_568948.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568948.url(scheme.get, call_568948.host, call_568948.base,
                         call_568948.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568948, url, valid)

proc call*(call_568949: Call_ReplicationRecoveryServicesProvidersListByReplicationFabrics_568940;
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
  var path_568950 = newJObject()
  var query_568951 = newJObject()
  add(path_568950, "fabricName", newJString(fabricName))
  add(path_568950, "resourceGroupName", newJString(resourceGroupName))
  add(query_568951, "api-version", newJString(apiVersion))
  add(path_568950, "subscriptionId", newJString(subscriptionId))
  add(path_568950, "resourceName", newJString(resourceName))
  result = call_568949.call(path_568950, query_568951, nil, nil, nil)

var replicationRecoveryServicesProvidersListByReplicationFabrics* = Call_ReplicationRecoveryServicesProvidersListByReplicationFabrics_568940(
    name: "replicationRecoveryServicesProvidersListByReplicationFabrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders", validator: validate_ReplicationRecoveryServicesProvidersListByReplicationFabrics_568941,
    base: "",
    url: url_ReplicationRecoveryServicesProvidersListByReplicationFabrics_568942,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersGet_568952 = ref object of OpenApiRestCall_567666
proc url_ReplicationRecoveryServicesProvidersGet_568954(protocol: Scheme;
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

proc validate_ReplicationRecoveryServicesProvidersGet_568953(path: JsonNode;
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
  var valid_568955 = path.getOrDefault("fabricName")
  valid_568955 = validateParameter(valid_568955, JString, required = true,
                                 default = nil)
  if valid_568955 != nil:
    section.add "fabricName", valid_568955
  var valid_568956 = path.getOrDefault("resourceGroupName")
  valid_568956 = validateParameter(valid_568956, JString, required = true,
                                 default = nil)
  if valid_568956 != nil:
    section.add "resourceGroupName", valid_568956
  var valid_568957 = path.getOrDefault("subscriptionId")
  valid_568957 = validateParameter(valid_568957, JString, required = true,
                                 default = nil)
  if valid_568957 != nil:
    section.add "subscriptionId", valid_568957
  var valid_568958 = path.getOrDefault("resourceName")
  valid_568958 = validateParameter(valid_568958, JString, required = true,
                                 default = nil)
  if valid_568958 != nil:
    section.add "resourceName", valid_568958
  var valid_568959 = path.getOrDefault("providerName")
  valid_568959 = validateParameter(valid_568959, JString, required = true,
                                 default = nil)
  if valid_568959 != nil:
    section.add "providerName", valid_568959
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568960 = query.getOrDefault("api-version")
  valid_568960 = validateParameter(valid_568960, JString, required = true,
                                 default = nil)
  if valid_568960 != nil:
    section.add "api-version", valid_568960
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568961: Call_ReplicationRecoveryServicesProvidersGet_568952;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of registered recovery services provider.
  ## 
  let valid = call_568961.validator(path, query, header, formData, body)
  let scheme = call_568961.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568961.url(scheme.get, call_568961.host, call_568961.base,
                         call_568961.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568961, url, valid)

proc call*(call_568962: Call_ReplicationRecoveryServicesProvidersGet_568952;
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
  var path_568963 = newJObject()
  var query_568964 = newJObject()
  add(path_568963, "fabricName", newJString(fabricName))
  add(path_568963, "resourceGroupName", newJString(resourceGroupName))
  add(query_568964, "api-version", newJString(apiVersion))
  add(path_568963, "subscriptionId", newJString(subscriptionId))
  add(path_568963, "resourceName", newJString(resourceName))
  add(path_568963, "providerName", newJString(providerName))
  result = call_568962.call(path_568963, query_568964, nil, nil, nil)

var replicationRecoveryServicesProvidersGet* = Call_ReplicationRecoveryServicesProvidersGet_568952(
    name: "replicationRecoveryServicesProvidersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}",
    validator: validate_ReplicationRecoveryServicesProvidersGet_568953, base: "",
    url: url_ReplicationRecoveryServicesProvidersGet_568954,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersPurge_568965 = ref object of OpenApiRestCall_567666
proc url_ReplicationRecoveryServicesProvidersPurge_568967(protocol: Scheme;
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

proc validate_ReplicationRecoveryServicesProvidersPurge_568966(path: JsonNode;
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
  var valid_568968 = path.getOrDefault("fabricName")
  valid_568968 = validateParameter(valid_568968, JString, required = true,
                                 default = nil)
  if valid_568968 != nil:
    section.add "fabricName", valid_568968
  var valid_568969 = path.getOrDefault("resourceGroupName")
  valid_568969 = validateParameter(valid_568969, JString, required = true,
                                 default = nil)
  if valid_568969 != nil:
    section.add "resourceGroupName", valid_568969
  var valid_568970 = path.getOrDefault("subscriptionId")
  valid_568970 = validateParameter(valid_568970, JString, required = true,
                                 default = nil)
  if valid_568970 != nil:
    section.add "subscriptionId", valid_568970
  var valid_568971 = path.getOrDefault("resourceName")
  valid_568971 = validateParameter(valid_568971, JString, required = true,
                                 default = nil)
  if valid_568971 != nil:
    section.add "resourceName", valid_568971
  var valid_568972 = path.getOrDefault("providerName")
  valid_568972 = validateParameter(valid_568972, JString, required = true,
                                 default = nil)
  if valid_568972 != nil:
    section.add "providerName", valid_568972
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568973 = query.getOrDefault("api-version")
  valid_568973 = validateParameter(valid_568973, JString, required = true,
                                 default = nil)
  if valid_568973 != nil:
    section.add "api-version", valid_568973
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568974: Call_ReplicationRecoveryServicesProvidersPurge_568965;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to purge(force delete) a recovery services provider from the vault.
  ## 
  let valid = call_568974.validator(path, query, header, formData, body)
  let scheme = call_568974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568974.url(scheme.get, call_568974.host, call_568974.base,
                         call_568974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568974, url, valid)

proc call*(call_568975: Call_ReplicationRecoveryServicesProvidersPurge_568965;
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
  var path_568976 = newJObject()
  var query_568977 = newJObject()
  add(path_568976, "fabricName", newJString(fabricName))
  add(path_568976, "resourceGroupName", newJString(resourceGroupName))
  add(query_568977, "api-version", newJString(apiVersion))
  add(path_568976, "subscriptionId", newJString(subscriptionId))
  add(path_568976, "resourceName", newJString(resourceName))
  add(path_568976, "providerName", newJString(providerName))
  result = call_568975.call(path_568976, query_568977, nil, nil, nil)

var replicationRecoveryServicesProvidersPurge* = Call_ReplicationRecoveryServicesProvidersPurge_568965(
    name: "replicationRecoveryServicesProvidersPurge",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}",
    validator: validate_ReplicationRecoveryServicesProvidersPurge_568966,
    base: "", url: url_ReplicationRecoveryServicesProvidersPurge_568967,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersRefreshProvider_568978 = ref object of OpenApiRestCall_567666
proc url_ReplicationRecoveryServicesProvidersRefreshProvider_568980(
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

proc validate_ReplicationRecoveryServicesProvidersRefreshProvider_568979(
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
  var valid_568981 = path.getOrDefault("fabricName")
  valid_568981 = validateParameter(valid_568981, JString, required = true,
                                 default = nil)
  if valid_568981 != nil:
    section.add "fabricName", valid_568981
  var valid_568982 = path.getOrDefault("resourceGroupName")
  valid_568982 = validateParameter(valid_568982, JString, required = true,
                                 default = nil)
  if valid_568982 != nil:
    section.add "resourceGroupName", valid_568982
  var valid_568983 = path.getOrDefault("subscriptionId")
  valid_568983 = validateParameter(valid_568983, JString, required = true,
                                 default = nil)
  if valid_568983 != nil:
    section.add "subscriptionId", valid_568983
  var valid_568984 = path.getOrDefault("resourceName")
  valid_568984 = validateParameter(valid_568984, JString, required = true,
                                 default = nil)
  if valid_568984 != nil:
    section.add "resourceName", valid_568984
  var valid_568985 = path.getOrDefault("providerName")
  valid_568985 = validateParameter(valid_568985, JString, required = true,
                                 default = nil)
  if valid_568985 != nil:
    section.add "providerName", valid_568985
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568986 = query.getOrDefault("api-version")
  valid_568986 = validateParameter(valid_568986, JString, required = true,
                                 default = nil)
  if valid_568986 != nil:
    section.add "api-version", valid_568986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568987: Call_ReplicationRecoveryServicesProvidersRefreshProvider_568978;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to refresh the information from the recovery services provider.
  ## 
  let valid = call_568987.validator(path, query, header, formData, body)
  let scheme = call_568987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568987.url(scheme.get, call_568987.host, call_568987.base,
                         call_568987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568987, url, valid)

proc call*(call_568988: Call_ReplicationRecoveryServicesProvidersRefreshProvider_568978;
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
  var path_568989 = newJObject()
  var query_568990 = newJObject()
  add(path_568989, "fabricName", newJString(fabricName))
  add(path_568989, "resourceGroupName", newJString(resourceGroupName))
  add(query_568990, "api-version", newJString(apiVersion))
  add(path_568989, "subscriptionId", newJString(subscriptionId))
  add(path_568989, "resourceName", newJString(resourceName))
  add(path_568989, "providerName", newJString(providerName))
  result = call_568988.call(path_568989, query_568990, nil, nil, nil)

var replicationRecoveryServicesProvidersRefreshProvider* = Call_ReplicationRecoveryServicesProvidersRefreshProvider_568978(
    name: "replicationRecoveryServicesProvidersRefreshProvider",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}/refreshProvider",
    validator: validate_ReplicationRecoveryServicesProvidersRefreshProvider_568979,
    base: "", url: url_ReplicationRecoveryServicesProvidersRefreshProvider_568980,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersDelete_568991 = ref object of OpenApiRestCall_567666
proc url_ReplicationRecoveryServicesProvidersDelete_568993(protocol: Scheme;
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

proc validate_ReplicationRecoveryServicesProvidersDelete_568992(path: JsonNode;
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
  var valid_568994 = path.getOrDefault("fabricName")
  valid_568994 = validateParameter(valid_568994, JString, required = true,
                                 default = nil)
  if valid_568994 != nil:
    section.add "fabricName", valid_568994
  var valid_568995 = path.getOrDefault("resourceGroupName")
  valid_568995 = validateParameter(valid_568995, JString, required = true,
                                 default = nil)
  if valid_568995 != nil:
    section.add "resourceGroupName", valid_568995
  var valid_568996 = path.getOrDefault("subscriptionId")
  valid_568996 = validateParameter(valid_568996, JString, required = true,
                                 default = nil)
  if valid_568996 != nil:
    section.add "subscriptionId", valid_568996
  var valid_568997 = path.getOrDefault("resourceName")
  valid_568997 = validateParameter(valid_568997, JString, required = true,
                                 default = nil)
  if valid_568997 != nil:
    section.add "resourceName", valid_568997
  var valid_568998 = path.getOrDefault("providerName")
  valid_568998 = validateParameter(valid_568998, JString, required = true,
                                 default = nil)
  if valid_568998 != nil:
    section.add "providerName", valid_568998
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

proc call*(call_569000: Call_ReplicationRecoveryServicesProvidersDelete_568991;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to removes/delete(unregister) a recovery services provider from the vault
  ## 
  let valid = call_569000.validator(path, query, header, formData, body)
  let scheme = call_569000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569000.url(scheme.get, call_569000.host, call_569000.base,
                         call_569000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569000, url, valid)

proc call*(call_569001: Call_ReplicationRecoveryServicesProvidersDelete_568991;
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
  var path_569002 = newJObject()
  var query_569003 = newJObject()
  add(path_569002, "fabricName", newJString(fabricName))
  add(path_569002, "resourceGroupName", newJString(resourceGroupName))
  add(query_569003, "api-version", newJString(apiVersion))
  add(path_569002, "subscriptionId", newJString(subscriptionId))
  add(path_569002, "resourceName", newJString(resourceName))
  add(path_569002, "providerName", newJString(providerName))
  result = call_569001.call(path_569002, query_569003, nil, nil, nil)

var replicationRecoveryServicesProvidersDelete* = Call_ReplicationRecoveryServicesProvidersDelete_568991(
    name: "replicationRecoveryServicesProvidersDelete", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationRecoveryServicesProviders/{providerName}/remove",
    validator: validate_ReplicationRecoveryServicesProvidersDelete_568992,
    base: "", url: url_ReplicationRecoveryServicesProvidersDelete_568993,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationsListByReplicationFabrics_569004 = ref object of OpenApiRestCall_567666
proc url_ReplicationStorageClassificationsListByReplicationFabrics_569006(
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

proc validate_ReplicationStorageClassificationsListByReplicationFabrics_569005(
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569011 = query.getOrDefault("api-version")
  valid_569011 = validateParameter(valid_569011, JString, required = true,
                                 default = nil)
  if valid_569011 != nil:
    section.add "api-version", valid_569011
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569012: Call_ReplicationStorageClassificationsListByReplicationFabrics_569004;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the storage classifications available in the specified fabric.
  ## 
  let valid = call_569012.validator(path, query, header, formData, body)
  let scheme = call_569012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569012.url(scheme.get, call_569012.host, call_569012.base,
                         call_569012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569012, url, valid)

proc call*(call_569013: Call_ReplicationStorageClassificationsListByReplicationFabrics_569004;
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
  var path_569014 = newJObject()
  var query_569015 = newJObject()
  add(path_569014, "fabricName", newJString(fabricName))
  add(path_569014, "resourceGroupName", newJString(resourceGroupName))
  add(query_569015, "api-version", newJString(apiVersion))
  add(path_569014, "subscriptionId", newJString(subscriptionId))
  add(path_569014, "resourceName", newJString(resourceName))
  result = call_569013.call(path_569014, query_569015, nil, nil, nil)

var replicationStorageClassificationsListByReplicationFabrics* = Call_ReplicationStorageClassificationsListByReplicationFabrics_569004(
    name: "replicationStorageClassificationsListByReplicationFabrics",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications", validator: validate_ReplicationStorageClassificationsListByReplicationFabrics_569005,
    base: "", url: url_ReplicationStorageClassificationsListByReplicationFabrics_569006,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationsGet_569016 = ref object of OpenApiRestCall_567666
proc url_ReplicationStorageClassificationsGet_569018(protocol: Scheme;
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

proc validate_ReplicationStorageClassificationsGet_569017(path: JsonNode;
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
  var valid_569019 = path.getOrDefault("fabricName")
  valid_569019 = validateParameter(valid_569019, JString, required = true,
                                 default = nil)
  if valid_569019 != nil:
    section.add "fabricName", valid_569019
  var valid_569020 = path.getOrDefault("resourceGroupName")
  valid_569020 = validateParameter(valid_569020, JString, required = true,
                                 default = nil)
  if valid_569020 != nil:
    section.add "resourceGroupName", valid_569020
  var valid_569021 = path.getOrDefault("subscriptionId")
  valid_569021 = validateParameter(valid_569021, JString, required = true,
                                 default = nil)
  if valid_569021 != nil:
    section.add "subscriptionId", valid_569021
  var valid_569022 = path.getOrDefault("resourceName")
  valid_569022 = validateParameter(valid_569022, JString, required = true,
                                 default = nil)
  if valid_569022 != nil:
    section.add "resourceName", valid_569022
  var valid_569023 = path.getOrDefault("storageClassificationName")
  valid_569023 = validateParameter(valid_569023, JString, required = true,
                                 default = nil)
  if valid_569023 != nil:
    section.add "storageClassificationName", valid_569023
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569024 = query.getOrDefault("api-version")
  valid_569024 = validateParameter(valid_569024, JString, required = true,
                                 default = nil)
  if valid_569024 != nil:
    section.add "api-version", valid_569024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569025: Call_ReplicationStorageClassificationsGet_569016;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of the specified storage classification.
  ## 
  let valid = call_569025.validator(path, query, header, formData, body)
  let scheme = call_569025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569025.url(scheme.get, call_569025.host, call_569025.base,
                         call_569025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569025, url, valid)

proc call*(call_569026: Call_ReplicationStorageClassificationsGet_569016;
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
  var path_569027 = newJObject()
  var query_569028 = newJObject()
  add(path_569027, "fabricName", newJString(fabricName))
  add(path_569027, "resourceGroupName", newJString(resourceGroupName))
  add(query_569028, "api-version", newJString(apiVersion))
  add(path_569027, "subscriptionId", newJString(subscriptionId))
  add(path_569027, "resourceName", newJString(resourceName))
  add(path_569027, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_569026.call(path_569027, query_569028, nil, nil, nil)

var replicationStorageClassificationsGet* = Call_ReplicationStorageClassificationsGet_569016(
    name: "replicationStorageClassificationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}",
    validator: validate_ReplicationStorageClassificationsGet_569017, base: "",
    url: url_ReplicationStorageClassificationsGet_569018, schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_569029 = ref object of OpenApiRestCall_567666
proc url_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_569031(
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

proc validate_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_569030(
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
  var valid_569032 = path.getOrDefault("fabricName")
  valid_569032 = validateParameter(valid_569032, JString, required = true,
                                 default = nil)
  if valid_569032 != nil:
    section.add "fabricName", valid_569032
  var valid_569033 = path.getOrDefault("resourceGroupName")
  valid_569033 = validateParameter(valid_569033, JString, required = true,
                                 default = nil)
  if valid_569033 != nil:
    section.add "resourceGroupName", valid_569033
  var valid_569034 = path.getOrDefault("subscriptionId")
  valid_569034 = validateParameter(valid_569034, JString, required = true,
                                 default = nil)
  if valid_569034 != nil:
    section.add "subscriptionId", valid_569034
  var valid_569035 = path.getOrDefault("resourceName")
  valid_569035 = validateParameter(valid_569035, JString, required = true,
                                 default = nil)
  if valid_569035 != nil:
    section.add "resourceName", valid_569035
  var valid_569036 = path.getOrDefault("storageClassificationName")
  valid_569036 = validateParameter(valid_569036, JString, required = true,
                                 default = nil)
  if valid_569036 != nil:
    section.add "storageClassificationName", valid_569036
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569037 = query.getOrDefault("api-version")
  valid_569037 = validateParameter(valid_569037, JString, required = true,
                                 default = nil)
  if valid_569037 != nil:
    section.add "api-version", valid_569037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569038: Call_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_569029;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the storage classification mappings for the fabric.
  ## 
  let valid = call_569038.validator(path, query, header, formData, body)
  let scheme = call_569038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569038.url(scheme.get, call_569038.host, call_569038.base,
                         call_569038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569038, url, valid)

proc call*(call_569039: Call_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_569029;
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
  var path_569040 = newJObject()
  var query_569041 = newJObject()
  add(path_569040, "fabricName", newJString(fabricName))
  add(path_569040, "resourceGroupName", newJString(resourceGroupName))
  add(query_569041, "api-version", newJString(apiVersion))
  add(path_569040, "subscriptionId", newJString(subscriptionId))
  add(path_569040, "resourceName", newJString(resourceName))
  add(path_569040, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_569039.call(path_569040, query_569041, nil, nil, nil)

var replicationStorageClassificationMappingsListByReplicationStorageClassifications* = Call_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_569029(name: "replicationStorageClassificationMappingsListByReplicationStorageClassifications",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}/replicationStorageClassificationMappings", validator: validate_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_569030,
    base: "", url: url_ReplicationStorageClassificationMappingsListByReplicationStorageClassifications_569031,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsCreate_569056 = ref object of OpenApiRestCall_567666
proc url_ReplicationStorageClassificationMappingsCreate_569058(protocol: Scheme;
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

proc validate_ReplicationStorageClassificationMappingsCreate_569057(
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
  var valid_569059 = path.getOrDefault("fabricName")
  valid_569059 = validateParameter(valid_569059, JString, required = true,
                                 default = nil)
  if valid_569059 != nil:
    section.add "fabricName", valid_569059
  var valid_569060 = path.getOrDefault("resourceGroupName")
  valid_569060 = validateParameter(valid_569060, JString, required = true,
                                 default = nil)
  if valid_569060 != nil:
    section.add "resourceGroupName", valid_569060
  var valid_569061 = path.getOrDefault("storageClassificationMappingName")
  valid_569061 = validateParameter(valid_569061, JString, required = true,
                                 default = nil)
  if valid_569061 != nil:
    section.add "storageClassificationMappingName", valid_569061
  var valid_569062 = path.getOrDefault("subscriptionId")
  valid_569062 = validateParameter(valid_569062, JString, required = true,
                                 default = nil)
  if valid_569062 != nil:
    section.add "subscriptionId", valid_569062
  var valid_569063 = path.getOrDefault("resourceName")
  valid_569063 = validateParameter(valid_569063, JString, required = true,
                                 default = nil)
  if valid_569063 != nil:
    section.add "resourceName", valid_569063
  var valid_569064 = path.getOrDefault("storageClassificationName")
  valid_569064 = validateParameter(valid_569064, JString, required = true,
                                 default = nil)
  if valid_569064 != nil:
    section.add "storageClassificationName", valid_569064
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569065 = query.getOrDefault("api-version")
  valid_569065 = validateParameter(valid_569065, JString, required = true,
                                 default = nil)
  if valid_569065 != nil:
    section.add "api-version", valid_569065
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

proc call*(call_569067: Call_ReplicationStorageClassificationMappingsCreate_569056;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create a storage classification mapping.
  ## 
  let valid = call_569067.validator(path, query, header, formData, body)
  let scheme = call_569067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569067.url(scheme.get, call_569067.host, call_569067.base,
                         call_569067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569067, url, valid)

proc call*(call_569068: Call_ReplicationStorageClassificationMappingsCreate_569056;
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
  var path_569069 = newJObject()
  var query_569070 = newJObject()
  var body_569071 = newJObject()
  add(path_569069, "fabricName", newJString(fabricName))
  add(path_569069, "resourceGroupName", newJString(resourceGroupName))
  add(query_569070, "api-version", newJString(apiVersion))
  add(path_569069, "storageClassificationMappingName",
      newJString(storageClassificationMappingName))
  if pairingInput != nil:
    body_569071 = pairingInput
  add(path_569069, "subscriptionId", newJString(subscriptionId))
  add(path_569069, "resourceName", newJString(resourceName))
  add(path_569069, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_569068.call(path_569069, query_569070, nil, nil, body_569071)

var replicationStorageClassificationMappingsCreate* = Call_ReplicationStorageClassificationMappingsCreate_569056(
    name: "replicationStorageClassificationMappingsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}/replicationStorageClassificationMappings/{storageClassificationMappingName}",
    validator: validate_ReplicationStorageClassificationMappingsCreate_569057,
    base: "", url: url_ReplicationStorageClassificationMappingsCreate_569058,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsGet_569042 = ref object of OpenApiRestCall_567666
proc url_ReplicationStorageClassificationMappingsGet_569044(protocol: Scheme;
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

proc validate_ReplicationStorageClassificationMappingsGet_569043(path: JsonNode;
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
  var valid_569045 = path.getOrDefault("fabricName")
  valid_569045 = validateParameter(valid_569045, JString, required = true,
                                 default = nil)
  if valid_569045 != nil:
    section.add "fabricName", valid_569045
  var valid_569046 = path.getOrDefault("resourceGroupName")
  valid_569046 = validateParameter(valid_569046, JString, required = true,
                                 default = nil)
  if valid_569046 != nil:
    section.add "resourceGroupName", valid_569046
  var valid_569047 = path.getOrDefault("storageClassificationMappingName")
  valid_569047 = validateParameter(valid_569047, JString, required = true,
                                 default = nil)
  if valid_569047 != nil:
    section.add "storageClassificationMappingName", valid_569047
  var valid_569048 = path.getOrDefault("subscriptionId")
  valid_569048 = validateParameter(valid_569048, JString, required = true,
                                 default = nil)
  if valid_569048 != nil:
    section.add "subscriptionId", valid_569048
  var valid_569049 = path.getOrDefault("resourceName")
  valid_569049 = validateParameter(valid_569049, JString, required = true,
                                 default = nil)
  if valid_569049 != nil:
    section.add "resourceName", valid_569049
  var valid_569050 = path.getOrDefault("storageClassificationName")
  valid_569050 = validateParameter(valid_569050, JString, required = true,
                                 default = nil)
  if valid_569050 != nil:
    section.add "storageClassificationName", valid_569050
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569051 = query.getOrDefault("api-version")
  valid_569051 = validateParameter(valid_569051, JString, required = true,
                                 default = nil)
  if valid_569051 != nil:
    section.add "api-version", valid_569051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569052: Call_ReplicationStorageClassificationMappingsGet_569042;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of the specified storage classification mapping.
  ## 
  let valid = call_569052.validator(path, query, header, formData, body)
  let scheme = call_569052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569052.url(scheme.get, call_569052.host, call_569052.base,
                         call_569052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569052, url, valid)

proc call*(call_569053: Call_ReplicationStorageClassificationMappingsGet_569042;
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
  var path_569054 = newJObject()
  var query_569055 = newJObject()
  add(path_569054, "fabricName", newJString(fabricName))
  add(path_569054, "resourceGroupName", newJString(resourceGroupName))
  add(query_569055, "api-version", newJString(apiVersion))
  add(path_569054, "storageClassificationMappingName",
      newJString(storageClassificationMappingName))
  add(path_569054, "subscriptionId", newJString(subscriptionId))
  add(path_569054, "resourceName", newJString(resourceName))
  add(path_569054, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_569053.call(path_569054, query_569055, nil, nil, nil)

var replicationStorageClassificationMappingsGet* = Call_ReplicationStorageClassificationMappingsGet_569042(
    name: "replicationStorageClassificationMappingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}/replicationStorageClassificationMappings/{storageClassificationMappingName}",
    validator: validate_ReplicationStorageClassificationMappingsGet_569043,
    base: "", url: url_ReplicationStorageClassificationMappingsGet_569044,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsDelete_569072 = ref object of OpenApiRestCall_567666
proc url_ReplicationStorageClassificationMappingsDelete_569074(protocol: Scheme;
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

proc validate_ReplicationStorageClassificationMappingsDelete_569073(
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
  var valid_569075 = path.getOrDefault("fabricName")
  valid_569075 = validateParameter(valid_569075, JString, required = true,
                                 default = nil)
  if valid_569075 != nil:
    section.add "fabricName", valid_569075
  var valid_569076 = path.getOrDefault("resourceGroupName")
  valid_569076 = validateParameter(valid_569076, JString, required = true,
                                 default = nil)
  if valid_569076 != nil:
    section.add "resourceGroupName", valid_569076
  var valid_569077 = path.getOrDefault("storageClassificationMappingName")
  valid_569077 = validateParameter(valid_569077, JString, required = true,
                                 default = nil)
  if valid_569077 != nil:
    section.add "storageClassificationMappingName", valid_569077
  var valid_569078 = path.getOrDefault("subscriptionId")
  valid_569078 = validateParameter(valid_569078, JString, required = true,
                                 default = nil)
  if valid_569078 != nil:
    section.add "subscriptionId", valid_569078
  var valid_569079 = path.getOrDefault("resourceName")
  valid_569079 = validateParameter(valid_569079, JString, required = true,
                                 default = nil)
  if valid_569079 != nil:
    section.add "resourceName", valid_569079
  var valid_569080 = path.getOrDefault("storageClassificationName")
  valid_569080 = validateParameter(valid_569080, JString, required = true,
                                 default = nil)
  if valid_569080 != nil:
    section.add "storageClassificationName", valid_569080
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569081 = query.getOrDefault("api-version")
  valid_569081 = validateParameter(valid_569081, JString, required = true,
                                 default = nil)
  if valid_569081 != nil:
    section.add "api-version", valid_569081
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569082: Call_ReplicationStorageClassificationMappingsDelete_569072;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete a storage classification mapping.
  ## 
  let valid = call_569082.validator(path, query, header, formData, body)
  let scheme = call_569082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569082.url(scheme.get, call_569082.host, call_569082.base,
                         call_569082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569082, url, valid)

proc call*(call_569083: Call_ReplicationStorageClassificationMappingsDelete_569072;
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
  var path_569084 = newJObject()
  var query_569085 = newJObject()
  add(path_569084, "fabricName", newJString(fabricName))
  add(path_569084, "resourceGroupName", newJString(resourceGroupName))
  add(query_569085, "api-version", newJString(apiVersion))
  add(path_569084, "storageClassificationMappingName",
      newJString(storageClassificationMappingName))
  add(path_569084, "subscriptionId", newJString(subscriptionId))
  add(path_569084, "resourceName", newJString(resourceName))
  add(path_569084, "storageClassificationName",
      newJString(storageClassificationName))
  result = call_569083.call(path_569084, query_569085, nil, nil, nil)

var replicationStorageClassificationMappingsDelete* = Call_ReplicationStorageClassificationMappingsDelete_569072(
    name: "replicationStorageClassificationMappingsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationStorageClassifications/{storageClassificationName}/replicationStorageClassificationMappings/{storageClassificationMappingName}",
    validator: validate_ReplicationStorageClassificationMappingsDelete_569073,
    base: "", url: url_ReplicationStorageClassificationMappingsDelete_569074,
    schemes: {Scheme.Https})
type
  Call_ReplicationvCentersListByReplicationFabrics_569086 = ref object of OpenApiRestCall_567666
proc url_ReplicationvCentersListByReplicationFabrics_569088(protocol: Scheme;
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

proc validate_ReplicationvCentersListByReplicationFabrics_569087(path: JsonNode;
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
  var valid_569089 = path.getOrDefault("fabricName")
  valid_569089 = validateParameter(valid_569089, JString, required = true,
                                 default = nil)
  if valid_569089 != nil:
    section.add "fabricName", valid_569089
  var valid_569090 = path.getOrDefault("resourceGroupName")
  valid_569090 = validateParameter(valid_569090, JString, required = true,
                                 default = nil)
  if valid_569090 != nil:
    section.add "resourceGroupName", valid_569090
  var valid_569091 = path.getOrDefault("subscriptionId")
  valid_569091 = validateParameter(valid_569091, JString, required = true,
                                 default = nil)
  if valid_569091 != nil:
    section.add "subscriptionId", valid_569091
  var valid_569092 = path.getOrDefault("resourceName")
  valid_569092 = validateParameter(valid_569092, JString, required = true,
                                 default = nil)
  if valid_569092 != nil:
    section.add "resourceName", valid_569092
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569093 = query.getOrDefault("api-version")
  valid_569093 = validateParameter(valid_569093, JString, required = true,
                                 default = nil)
  if valid_569093 != nil:
    section.add "api-version", valid_569093
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569094: Call_ReplicationvCentersListByReplicationFabrics_569086;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the vCenter servers registered in a fabric.
  ## 
  let valid = call_569094.validator(path, query, header, formData, body)
  let scheme = call_569094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569094.url(scheme.get, call_569094.host, call_569094.base,
                         call_569094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569094, url, valid)

proc call*(call_569095: Call_ReplicationvCentersListByReplicationFabrics_569086;
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
  var path_569096 = newJObject()
  var query_569097 = newJObject()
  add(path_569096, "fabricName", newJString(fabricName))
  add(path_569096, "resourceGroupName", newJString(resourceGroupName))
  add(query_569097, "api-version", newJString(apiVersion))
  add(path_569096, "subscriptionId", newJString(subscriptionId))
  add(path_569096, "resourceName", newJString(resourceName))
  result = call_569095.call(path_569096, query_569097, nil, nil, nil)

var replicationvCentersListByReplicationFabrics* = Call_ReplicationvCentersListByReplicationFabrics_569086(
    name: "replicationvCentersListByReplicationFabrics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters",
    validator: validate_ReplicationvCentersListByReplicationFabrics_569087,
    base: "", url: url_ReplicationvCentersListByReplicationFabrics_569088,
    schemes: {Scheme.Https})
type
  Call_ReplicationvCentersCreate_569111 = ref object of OpenApiRestCall_567666
proc url_ReplicationvCentersCreate_569113(protocol: Scheme; host: string;
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

proc validate_ReplicationvCentersCreate_569112(path: JsonNode; query: JsonNode;
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
  var valid_569116 = path.getOrDefault("subscriptionId")
  valid_569116 = validateParameter(valid_569116, JString, required = true,
                                 default = nil)
  if valid_569116 != nil:
    section.add "subscriptionId", valid_569116
  var valid_569117 = path.getOrDefault("resourceName")
  valid_569117 = validateParameter(valid_569117, JString, required = true,
                                 default = nil)
  if valid_569117 != nil:
    section.add "resourceName", valid_569117
  var valid_569118 = path.getOrDefault("vCenterName")
  valid_569118 = validateParameter(valid_569118, JString, required = true,
                                 default = nil)
  if valid_569118 != nil:
    section.add "vCenterName", valid_569118
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569119 = query.getOrDefault("api-version")
  valid_569119 = validateParameter(valid_569119, JString, required = true,
                                 default = nil)
  if valid_569119 != nil:
    section.add "api-version", valid_569119
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

proc call*(call_569121: Call_ReplicationvCentersCreate_569111; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create a vCenter object..
  ## 
  let valid = call_569121.validator(path, query, header, formData, body)
  let scheme = call_569121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569121.url(scheme.get, call_569121.host, call_569121.base,
                         call_569121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569121, url, valid)

proc call*(call_569122: Call_ReplicationvCentersCreate_569111; fabricName: string;
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
  var path_569123 = newJObject()
  var query_569124 = newJObject()
  var body_569125 = newJObject()
  add(path_569123, "fabricName", newJString(fabricName))
  add(path_569123, "resourceGroupName", newJString(resourceGroupName))
  add(query_569124, "api-version", newJString(apiVersion))
  add(path_569123, "subscriptionId", newJString(subscriptionId))
  add(path_569123, "resourceName", newJString(resourceName))
  if addVCenterRequest != nil:
    body_569125 = addVCenterRequest
  add(path_569123, "vCenterName", newJString(vCenterName))
  result = call_569122.call(path_569123, query_569124, nil, nil, body_569125)

var replicationvCentersCreate* = Call_ReplicationvCentersCreate_569111(
    name: "replicationvCentersCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters/{vCenterName}",
    validator: validate_ReplicationvCentersCreate_569112, base: "",
    url: url_ReplicationvCentersCreate_569113, schemes: {Scheme.Https})
type
  Call_ReplicationvCentersGet_569098 = ref object of OpenApiRestCall_567666
proc url_ReplicationvCentersGet_569100(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationvCentersGet_569099(path: JsonNode; query: JsonNode;
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
  var valid_569101 = path.getOrDefault("fabricName")
  valid_569101 = validateParameter(valid_569101, JString, required = true,
                                 default = nil)
  if valid_569101 != nil:
    section.add "fabricName", valid_569101
  var valid_569102 = path.getOrDefault("resourceGroupName")
  valid_569102 = validateParameter(valid_569102, JString, required = true,
                                 default = nil)
  if valid_569102 != nil:
    section.add "resourceGroupName", valid_569102
  var valid_569103 = path.getOrDefault("subscriptionId")
  valid_569103 = validateParameter(valid_569103, JString, required = true,
                                 default = nil)
  if valid_569103 != nil:
    section.add "subscriptionId", valid_569103
  var valid_569104 = path.getOrDefault("resourceName")
  valid_569104 = validateParameter(valid_569104, JString, required = true,
                                 default = nil)
  if valid_569104 != nil:
    section.add "resourceName", valid_569104
  var valid_569105 = path.getOrDefault("vCenterName")
  valid_569105 = validateParameter(valid_569105, JString, required = true,
                                 default = nil)
  if valid_569105 != nil:
    section.add "vCenterName", valid_569105
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569106 = query.getOrDefault("api-version")
  valid_569106 = validateParameter(valid_569106, JString, required = true,
                                 default = nil)
  if valid_569106 != nil:
    section.add "api-version", valid_569106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569107: Call_ReplicationvCentersGet_569098; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a registered vCenter server(Add vCenter server.)
  ## 
  let valid = call_569107.validator(path, query, header, formData, body)
  let scheme = call_569107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569107.url(scheme.get, call_569107.host, call_569107.base,
                         call_569107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569107, url, valid)

proc call*(call_569108: Call_ReplicationvCentersGet_569098; fabricName: string;
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
  var path_569109 = newJObject()
  var query_569110 = newJObject()
  add(path_569109, "fabricName", newJString(fabricName))
  add(path_569109, "resourceGroupName", newJString(resourceGroupName))
  add(query_569110, "api-version", newJString(apiVersion))
  add(path_569109, "subscriptionId", newJString(subscriptionId))
  add(path_569109, "resourceName", newJString(resourceName))
  add(path_569109, "vCenterName", newJString(vCenterName))
  result = call_569108.call(path_569109, query_569110, nil, nil, nil)

var replicationvCentersGet* = Call_ReplicationvCentersGet_569098(
    name: "replicationvCentersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters/{vCenterName}",
    validator: validate_ReplicationvCentersGet_569099, base: "",
    url: url_ReplicationvCentersGet_569100, schemes: {Scheme.Https})
type
  Call_ReplicationvCentersUpdate_569139 = ref object of OpenApiRestCall_567666
proc url_ReplicationvCentersUpdate_569141(protocol: Scheme; host: string;
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

proc validate_ReplicationvCentersUpdate_569140(path: JsonNode; query: JsonNode;
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
  var valid_569142 = path.getOrDefault("fabricName")
  valid_569142 = validateParameter(valid_569142, JString, required = true,
                                 default = nil)
  if valid_569142 != nil:
    section.add "fabricName", valid_569142
  var valid_569143 = path.getOrDefault("resourceGroupName")
  valid_569143 = validateParameter(valid_569143, JString, required = true,
                                 default = nil)
  if valid_569143 != nil:
    section.add "resourceGroupName", valid_569143
  var valid_569144 = path.getOrDefault("subscriptionId")
  valid_569144 = validateParameter(valid_569144, JString, required = true,
                                 default = nil)
  if valid_569144 != nil:
    section.add "subscriptionId", valid_569144
  var valid_569145 = path.getOrDefault("resourceName")
  valid_569145 = validateParameter(valid_569145, JString, required = true,
                                 default = nil)
  if valid_569145 != nil:
    section.add "resourceName", valid_569145
  var valid_569146 = path.getOrDefault("vCenterName")
  valid_569146 = validateParameter(valid_569146, JString, required = true,
                                 default = nil)
  if valid_569146 != nil:
    section.add "vCenterName", valid_569146
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569147 = query.getOrDefault("api-version")
  valid_569147 = validateParameter(valid_569147, JString, required = true,
                                 default = nil)
  if valid_569147 != nil:
    section.add "api-version", valid_569147
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

proc call*(call_569149: Call_ReplicationvCentersUpdate_569139; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a registered vCenter.
  ## 
  let valid = call_569149.validator(path, query, header, formData, body)
  let scheme = call_569149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569149.url(scheme.get, call_569149.host, call_569149.base,
                         call_569149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569149, url, valid)

proc call*(call_569150: Call_ReplicationvCentersUpdate_569139; fabricName: string;
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
  var path_569151 = newJObject()
  var query_569152 = newJObject()
  var body_569153 = newJObject()
  add(path_569151, "fabricName", newJString(fabricName))
  add(path_569151, "resourceGroupName", newJString(resourceGroupName))
  add(query_569152, "api-version", newJString(apiVersion))
  add(path_569151, "subscriptionId", newJString(subscriptionId))
  add(path_569151, "resourceName", newJString(resourceName))
  add(path_569151, "vCenterName", newJString(vCenterName))
  if updateVCenterRequest != nil:
    body_569153 = updateVCenterRequest
  result = call_569150.call(path_569151, query_569152, nil, nil, body_569153)

var replicationvCentersUpdate* = Call_ReplicationvCentersUpdate_569139(
    name: "replicationvCentersUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters/{vCenterName}",
    validator: validate_ReplicationvCentersUpdate_569140, base: "",
    url: url_ReplicationvCentersUpdate_569141, schemes: {Scheme.Https})
type
  Call_ReplicationvCentersDelete_569126 = ref object of OpenApiRestCall_567666
proc url_ReplicationvCentersDelete_569128(protocol: Scheme; host: string;
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

proc validate_ReplicationvCentersDelete_569127(path: JsonNode; query: JsonNode;
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
  var valid_569129 = path.getOrDefault("fabricName")
  valid_569129 = validateParameter(valid_569129, JString, required = true,
                                 default = nil)
  if valid_569129 != nil:
    section.add "fabricName", valid_569129
  var valid_569130 = path.getOrDefault("resourceGroupName")
  valid_569130 = validateParameter(valid_569130, JString, required = true,
                                 default = nil)
  if valid_569130 != nil:
    section.add "resourceGroupName", valid_569130
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
  var valid_569133 = path.getOrDefault("vCenterName")
  valid_569133 = validateParameter(valid_569133, JString, required = true,
                                 default = nil)
  if valid_569133 != nil:
    section.add "vCenterName", valid_569133
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
  if body != nil:
    result.add "body", body

proc call*(call_569135: Call_ReplicationvCentersDelete_569126; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to remove(unregister) a registered vCenter server from the vault.
  ## 
  let valid = call_569135.validator(path, query, header, formData, body)
  let scheme = call_569135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569135.url(scheme.get, call_569135.host, call_569135.base,
                         call_569135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569135, url, valid)

proc call*(call_569136: Call_ReplicationvCentersDelete_569126; fabricName: string;
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
  var path_569137 = newJObject()
  var query_569138 = newJObject()
  add(path_569137, "fabricName", newJString(fabricName))
  add(path_569137, "resourceGroupName", newJString(resourceGroupName))
  add(query_569138, "api-version", newJString(apiVersion))
  add(path_569137, "subscriptionId", newJString(subscriptionId))
  add(path_569137, "resourceName", newJString(resourceName))
  add(path_569137, "vCenterName", newJString(vCenterName))
  result = call_569136.call(path_569137, query_569138, nil, nil, nil)

var replicationvCentersDelete* = Call_ReplicationvCentersDelete_569126(
    name: "replicationvCentersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationFabrics/{fabricName}/replicationvCenters/{vCenterName}",
    validator: validate_ReplicationvCentersDelete_569127, base: "",
    url: url_ReplicationvCentersDelete_569128, schemes: {Scheme.Https})
type
  Call_ReplicationJobsList_569154 = ref object of OpenApiRestCall_567666
proc url_ReplicationJobsList_569156(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationJobsList_569155(path: JsonNode; query: JsonNode;
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
  var valid_569157 = path.getOrDefault("resourceGroupName")
  valid_569157 = validateParameter(valid_569157, JString, required = true,
                                 default = nil)
  if valid_569157 != nil:
    section.add "resourceGroupName", valid_569157
  var valid_569158 = path.getOrDefault("subscriptionId")
  valid_569158 = validateParameter(valid_569158, JString, required = true,
                                 default = nil)
  if valid_569158 != nil:
    section.add "subscriptionId", valid_569158
  var valid_569159 = path.getOrDefault("resourceName")
  valid_569159 = validateParameter(valid_569159, JString, required = true,
                                 default = nil)
  if valid_569159 != nil:
    section.add "resourceName", valid_569159
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569160 = query.getOrDefault("api-version")
  valid_569160 = validateParameter(valid_569160, JString, required = true,
                                 default = nil)
  if valid_569160 != nil:
    section.add "api-version", valid_569160
  var valid_569161 = query.getOrDefault("$filter")
  valid_569161 = validateParameter(valid_569161, JString, required = false,
                                 default = nil)
  if valid_569161 != nil:
    section.add "$filter", valid_569161
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569162: Call_ReplicationJobsList_569154; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of Azure Site Recovery Jobs for the vault.
  ## 
  let valid = call_569162.validator(path, query, header, formData, body)
  let scheme = call_569162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569162.url(scheme.get, call_569162.host, call_569162.base,
                         call_569162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569162, url, valid)

proc call*(call_569163: Call_ReplicationJobsList_569154; resourceGroupName: string;
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
  var path_569164 = newJObject()
  var query_569165 = newJObject()
  add(path_569164, "resourceGroupName", newJString(resourceGroupName))
  add(query_569165, "api-version", newJString(apiVersion))
  add(path_569164, "subscriptionId", newJString(subscriptionId))
  add(path_569164, "resourceName", newJString(resourceName))
  add(query_569165, "$filter", newJString(Filter))
  result = call_569163.call(path_569164, query_569165, nil, nil, nil)

var replicationJobsList* = Call_ReplicationJobsList_569154(
    name: "replicationJobsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs",
    validator: validate_ReplicationJobsList_569155, base: "",
    url: url_ReplicationJobsList_569156, schemes: {Scheme.Https})
type
  Call_ReplicationJobsExport_569166 = ref object of OpenApiRestCall_567666
proc url_ReplicationJobsExport_569168(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationJobsExport_569167(path: JsonNode; query: JsonNode;
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
  var valid_569169 = path.getOrDefault("resourceGroupName")
  valid_569169 = validateParameter(valid_569169, JString, required = true,
                                 default = nil)
  if valid_569169 != nil:
    section.add "resourceGroupName", valid_569169
  var valid_569170 = path.getOrDefault("subscriptionId")
  valid_569170 = validateParameter(valid_569170, JString, required = true,
                                 default = nil)
  if valid_569170 != nil:
    section.add "subscriptionId", valid_569170
  var valid_569171 = path.getOrDefault("resourceName")
  valid_569171 = validateParameter(valid_569171, JString, required = true,
                                 default = nil)
  if valid_569171 != nil:
    section.add "resourceName", valid_569171
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
  ## parameters in `body` object:
  ##   jobQueryParameter: JObject (required)
  ##                    : job query filter.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569174: Call_ReplicationJobsExport_569166; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to export the details of the Azure Site Recovery jobs of the vault.
  ## 
  let valid = call_569174.validator(path, query, header, formData, body)
  let scheme = call_569174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569174.url(scheme.get, call_569174.host, call_569174.base,
                         call_569174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569174, url, valid)

proc call*(call_569175: Call_ReplicationJobsExport_569166;
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
  var path_569176 = newJObject()
  var query_569177 = newJObject()
  var body_569178 = newJObject()
  add(path_569176, "resourceGroupName", newJString(resourceGroupName))
  add(query_569177, "api-version", newJString(apiVersion))
  add(path_569176, "subscriptionId", newJString(subscriptionId))
  add(path_569176, "resourceName", newJString(resourceName))
  if jobQueryParameter != nil:
    body_569178 = jobQueryParameter
  result = call_569175.call(path_569176, query_569177, nil, nil, body_569178)

var replicationJobsExport* = Call_ReplicationJobsExport_569166(
    name: "replicationJobsExport", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/export",
    validator: validate_ReplicationJobsExport_569167, base: "",
    url: url_ReplicationJobsExport_569168, schemes: {Scheme.Https})
type
  Call_ReplicationJobsGet_569179 = ref object of OpenApiRestCall_567666
proc url_ReplicationJobsGet_569181(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationJobsGet_569180(path: JsonNode; query: JsonNode;
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
  var valid_569182 = path.getOrDefault("resourceGroupName")
  valid_569182 = validateParameter(valid_569182, JString, required = true,
                                 default = nil)
  if valid_569182 != nil:
    section.add "resourceGroupName", valid_569182
  var valid_569183 = path.getOrDefault("subscriptionId")
  valid_569183 = validateParameter(valid_569183, JString, required = true,
                                 default = nil)
  if valid_569183 != nil:
    section.add "subscriptionId", valid_569183
  var valid_569184 = path.getOrDefault("jobName")
  valid_569184 = validateParameter(valid_569184, JString, required = true,
                                 default = nil)
  if valid_569184 != nil:
    section.add "jobName", valid_569184
  var valid_569185 = path.getOrDefault("resourceName")
  valid_569185 = validateParameter(valid_569185, JString, required = true,
                                 default = nil)
  if valid_569185 != nil:
    section.add "resourceName", valid_569185
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569186 = query.getOrDefault("api-version")
  valid_569186 = validateParameter(valid_569186, JString, required = true,
                                 default = nil)
  if valid_569186 != nil:
    section.add "api-version", valid_569186
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569187: Call_ReplicationJobsGet_569179; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the details of an Azure Site Recovery job.
  ## 
  let valid = call_569187.validator(path, query, header, formData, body)
  let scheme = call_569187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569187.url(scheme.get, call_569187.host, call_569187.base,
                         call_569187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569187, url, valid)

proc call*(call_569188: Call_ReplicationJobsGet_569179; resourceGroupName: string;
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
  var path_569189 = newJObject()
  var query_569190 = newJObject()
  add(path_569189, "resourceGroupName", newJString(resourceGroupName))
  add(query_569190, "api-version", newJString(apiVersion))
  add(path_569189, "subscriptionId", newJString(subscriptionId))
  add(path_569189, "jobName", newJString(jobName))
  add(path_569189, "resourceName", newJString(resourceName))
  result = call_569188.call(path_569189, query_569190, nil, nil, nil)

var replicationJobsGet* = Call_ReplicationJobsGet_569179(
    name: "replicationJobsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/{jobName}",
    validator: validate_ReplicationJobsGet_569180, base: "",
    url: url_ReplicationJobsGet_569181, schemes: {Scheme.Https})
type
  Call_ReplicationJobsCancel_569191 = ref object of OpenApiRestCall_567666
proc url_ReplicationJobsCancel_569193(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationJobsCancel_569192(path: JsonNode; query: JsonNode;
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
  var valid_569196 = path.getOrDefault("jobName")
  valid_569196 = validateParameter(valid_569196, JString, required = true,
                                 default = nil)
  if valid_569196 != nil:
    section.add "jobName", valid_569196
  var valid_569197 = path.getOrDefault("resourceName")
  valid_569197 = validateParameter(valid_569197, JString, required = true,
                                 default = nil)
  if valid_569197 != nil:
    section.add "resourceName", valid_569197
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

proc call*(call_569199: Call_ReplicationJobsCancel_569191; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to cancel an Azure Site Recovery job.
  ## 
  let valid = call_569199.validator(path, query, header, formData, body)
  let scheme = call_569199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569199.url(scheme.get, call_569199.host, call_569199.base,
                         call_569199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569199, url, valid)

proc call*(call_569200: Call_ReplicationJobsCancel_569191;
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
  var path_569201 = newJObject()
  var query_569202 = newJObject()
  add(path_569201, "resourceGroupName", newJString(resourceGroupName))
  add(query_569202, "api-version", newJString(apiVersion))
  add(path_569201, "subscriptionId", newJString(subscriptionId))
  add(path_569201, "jobName", newJString(jobName))
  add(path_569201, "resourceName", newJString(resourceName))
  result = call_569200.call(path_569201, query_569202, nil, nil, nil)

var replicationJobsCancel* = Call_ReplicationJobsCancel_569191(
    name: "replicationJobsCancel", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/{jobName}/cancel",
    validator: validate_ReplicationJobsCancel_569192, base: "",
    url: url_ReplicationJobsCancel_569193, schemes: {Scheme.Https})
type
  Call_ReplicationJobsRestart_569203 = ref object of OpenApiRestCall_567666
proc url_ReplicationJobsRestart_569205(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationJobsRestart_569204(path: JsonNode; query: JsonNode;
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
  var valid_569206 = path.getOrDefault("resourceGroupName")
  valid_569206 = validateParameter(valid_569206, JString, required = true,
                                 default = nil)
  if valid_569206 != nil:
    section.add "resourceGroupName", valid_569206
  var valid_569207 = path.getOrDefault("subscriptionId")
  valid_569207 = validateParameter(valid_569207, JString, required = true,
                                 default = nil)
  if valid_569207 != nil:
    section.add "subscriptionId", valid_569207
  var valid_569208 = path.getOrDefault("jobName")
  valid_569208 = validateParameter(valid_569208, JString, required = true,
                                 default = nil)
  if valid_569208 != nil:
    section.add "jobName", valid_569208
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

proc call*(call_569211: Call_ReplicationJobsRestart_569203; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to restart an Azure Site Recovery job.
  ## 
  let valid = call_569211.validator(path, query, header, formData, body)
  let scheme = call_569211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569211.url(scheme.get, call_569211.host, call_569211.base,
                         call_569211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569211, url, valid)

proc call*(call_569212: Call_ReplicationJobsRestart_569203;
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
  var path_569213 = newJObject()
  var query_569214 = newJObject()
  add(path_569213, "resourceGroupName", newJString(resourceGroupName))
  add(query_569214, "api-version", newJString(apiVersion))
  add(path_569213, "subscriptionId", newJString(subscriptionId))
  add(path_569213, "jobName", newJString(jobName))
  add(path_569213, "resourceName", newJString(resourceName))
  result = call_569212.call(path_569213, query_569214, nil, nil, nil)

var replicationJobsRestart* = Call_ReplicationJobsRestart_569203(
    name: "replicationJobsRestart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/{jobName}/restart",
    validator: validate_ReplicationJobsRestart_569204, base: "",
    url: url_ReplicationJobsRestart_569205, schemes: {Scheme.Https})
type
  Call_ReplicationJobsResume_569215 = ref object of OpenApiRestCall_567666
proc url_ReplicationJobsResume_569217(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationJobsResume_569216(path: JsonNode; query: JsonNode;
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
  var valid_569218 = path.getOrDefault("resourceGroupName")
  valid_569218 = validateParameter(valid_569218, JString, required = true,
                                 default = nil)
  if valid_569218 != nil:
    section.add "resourceGroupName", valid_569218
  var valid_569219 = path.getOrDefault("subscriptionId")
  valid_569219 = validateParameter(valid_569219, JString, required = true,
                                 default = nil)
  if valid_569219 != nil:
    section.add "subscriptionId", valid_569219
  var valid_569220 = path.getOrDefault("jobName")
  valid_569220 = validateParameter(valid_569220, JString, required = true,
                                 default = nil)
  if valid_569220 != nil:
    section.add "jobName", valid_569220
  var valid_569221 = path.getOrDefault("resourceName")
  valid_569221 = validateParameter(valid_569221, JString, required = true,
                                 default = nil)
  if valid_569221 != nil:
    section.add "resourceName", valid_569221
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569222 = query.getOrDefault("api-version")
  valid_569222 = validateParameter(valid_569222, JString, required = true,
                                 default = nil)
  if valid_569222 != nil:
    section.add "api-version", valid_569222
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

proc call*(call_569224: Call_ReplicationJobsResume_569215; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to resume an Azure Site Recovery job
  ## 
  let valid = call_569224.validator(path, query, header, formData, body)
  let scheme = call_569224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569224.url(scheme.get, call_569224.host, call_569224.base,
                         call_569224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569224, url, valid)

proc call*(call_569225: Call_ReplicationJobsResume_569215;
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
  var path_569226 = newJObject()
  var query_569227 = newJObject()
  var body_569228 = newJObject()
  add(path_569226, "resourceGroupName", newJString(resourceGroupName))
  add(query_569227, "api-version", newJString(apiVersion))
  if resumeJobParams != nil:
    body_569228 = resumeJobParams
  add(path_569226, "subscriptionId", newJString(subscriptionId))
  add(path_569226, "jobName", newJString(jobName))
  add(path_569226, "resourceName", newJString(resourceName))
  result = call_569225.call(path_569226, query_569227, nil, nil, body_569228)

var replicationJobsResume* = Call_ReplicationJobsResume_569215(
    name: "replicationJobsResume", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationJobs/{jobName}/resume",
    validator: validate_ReplicationJobsResume_569216, base: "",
    url: url_ReplicationJobsResume_569217, schemes: {Scheme.Https})
type
  Call_ReplicationNetworkMappingsList_569229 = ref object of OpenApiRestCall_567666
proc url_ReplicationNetworkMappingsList_569231(protocol: Scheme; host: string;
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

proc validate_ReplicationNetworkMappingsList_569230(path: JsonNode;
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569235 = query.getOrDefault("api-version")
  valid_569235 = validateParameter(valid_569235, JString, required = true,
                                 default = nil)
  if valid_569235 != nil:
    section.add "api-version", valid_569235
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569236: Call_ReplicationNetworkMappingsList_569229; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all ASR network mappings in the vault.
  ## 
  let valid = call_569236.validator(path, query, header, formData, body)
  let scheme = call_569236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569236.url(scheme.get, call_569236.host, call_569236.base,
                         call_569236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569236, url, valid)

proc call*(call_569237: Call_ReplicationNetworkMappingsList_569229;
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
  var path_569238 = newJObject()
  var query_569239 = newJObject()
  add(path_569238, "resourceGroupName", newJString(resourceGroupName))
  add(query_569239, "api-version", newJString(apiVersion))
  add(path_569238, "subscriptionId", newJString(subscriptionId))
  add(path_569238, "resourceName", newJString(resourceName))
  result = call_569237.call(path_569238, query_569239, nil, nil, nil)

var replicationNetworkMappingsList* = Call_ReplicationNetworkMappingsList_569229(
    name: "replicationNetworkMappingsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationNetworkMappings",
    validator: validate_ReplicationNetworkMappingsList_569230, base: "",
    url: url_ReplicationNetworkMappingsList_569231, schemes: {Scheme.Https})
type
  Call_ReplicationNetworksList_569240 = ref object of OpenApiRestCall_567666
proc url_ReplicationNetworksList_569242(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationNetworksList_569241(path: JsonNode; query: JsonNode;
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
  var valid_569243 = path.getOrDefault("resourceGroupName")
  valid_569243 = validateParameter(valid_569243, JString, required = true,
                                 default = nil)
  if valid_569243 != nil:
    section.add "resourceGroupName", valid_569243
  var valid_569244 = path.getOrDefault("subscriptionId")
  valid_569244 = validateParameter(valid_569244, JString, required = true,
                                 default = nil)
  if valid_569244 != nil:
    section.add "subscriptionId", valid_569244
  var valid_569245 = path.getOrDefault("resourceName")
  valid_569245 = validateParameter(valid_569245, JString, required = true,
                                 default = nil)
  if valid_569245 != nil:
    section.add "resourceName", valid_569245
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

proc call*(call_569247: Call_ReplicationNetworksList_569240; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the networks available in a vault
  ## 
  let valid = call_569247.validator(path, query, header, formData, body)
  let scheme = call_569247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569247.url(scheme.get, call_569247.host, call_569247.base,
                         call_569247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569247, url, valid)

proc call*(call_569248: Call_ReplicationNetworksList_569240;
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
  var path_569249 = newJObject()
  var query_569250 = newJObject()
  add(path_569249, "resourceGroupName", newJString(resourceGroupName))
  add(query_569250, "api-version", newJString(apiVersion))
  add(path_569249, "subscriptionId", newJString(subscriptionId))
  add(path_569249, "resourceName", newJString(resourceName))
  result = call_569248.call(path_569249, query_569250, nil, nil, nil)

var replicationNetworksList* = Call_ReplicationNetworksList_569240(
    name: "replicationNetworksList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationNetworks",
    validator: validate_ReplicationNetworksList_569241, base: "",
    url: url_ReplicationNetworksList_569242, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesList_569251 = ref object of OpenApiRestCall_567666
proc url_ReplicationPoliciesList_569253(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationPoliciesList_569252(path: JsonNode; query: JsonNode;
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
  var valid_569254 = path.getOrDefault("resourceGroupName")
  valid_569254 = validateParameter(valid_569254, JString, required = true,
                                 default = nil)
  if valid_569254 != nil:
    section.add "resourceGroupName", valid_569254
  var valid_569255 = path.getOrDefault("subscriptionId")
  valid_569255 = validateParameter(valid_569255, JString, required = true,
                                 default = nil)
  if valid_569255 != nil:
    section.add "subscriptionId", valid_569255
  var valid_569256 = path.getOrDefault("resourceName")
  valid_569256 = validateParameter(valid_569256, JString, required = true,
                                 default = nil)
  if valid_569256 != nil:
    section.add "resourceName", valid_569256
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569257 = query.getOrDefault("api-version")
  valid_569257 = validateParameter(valid_569257, JString, required = true,
                                 default = nil)
  if valid_569257 != nil:
    section.add "api-version", valid_569257
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569258: Call_ReplicationPoliciesList_569251; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the replication policies for a vault.
  ## 
  let valid = call_569258.validator(path, query, header, formData, body)
  let scheme = call_569258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569258.url(scheme.get, call_569258.host, call_569258.base,
                         call_569258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569258, url, valid)

proc call*(call_569259: Call_ReplicationPoliciesList_569251;
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
  var path_569260 = newJObject()
  var query_569261 = newJObject()
  add(path_569260, "resourceGroupName", newJString(resourceGroupName))
  add(query_569261, "api-version", newJString(apiVersion))
  add(path_569260, "subscriptionId", newJString(subscriptionId))
  add(path_569260, "resourceName", newJString(resourceName))
  result = call_569259.call(path_569260, query_569261, nil, nil, nil)

var replicationPoliciesList* = Call_ReplicationPoliciesList_569251(
    name: "replicationPoliciesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies",
    validator: validate_ReplicationPoliciesList_569252, base: "",
    url: url_ReplicationPoliciesList_569253, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesCreate_569274 = ref object of OpenApiRestCall_567666
proc url_ReplicationPoliciesCreate_569276(protocol: Scheme; host: string;
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

proc validate_ReplicationPoliciesCreate_569275(path: JsonNode; query: JsonNode;
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
  var valid_569277 = path.getOrDefault("resourceGroupName")
  valid_569277 = validateParameter(valid_569277, JString, required = true,
                                 default = nil)
  if valid_569277 != nil:
    section.add "resourceGroupName", valid_569277
  var valid_569278 = path.getOrDefault("subscriptionId")
  valid_569278 = validateParameter(valid_569278, JString, required = true,
                                 default = nil)
  if valid_569278 != nil:
    section.add "subscriptionId", valid_569278
  var valid_569279 = path.getOrDefault("resourceName")
  valid_569279 = validateParameter(valid_569279, JString, required = true,
                                 default = nil)
  if valid_569279 != nil:
    section.add "resourceName", valid_569279
  var valid_569280 = path.getOrDefault("policyName")
  valid_569280 = validateParameter(valid_569280, JString, required = true,
                                 default = nil)
  if valid_569280 != nil:
    section.add "policyName", valid_569280
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569281 = query.getOrDefault("api-version")
  valid_569281 = validateParameter(valid_569281, JString, required = true,
                                 default = nil)
  if valid_569281 != nil:
    section.add "api-version", valid_569281
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

proc call*(call_569283: Call_ReplicationPoliciesCreate_569274; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create a replication policy
  ## 
  let valid = call_569283.validator(path, query, header, formData, body)
  let scheme = call_569283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569283.url(scheme.get, call_569283.host, call_569283.base,
                         call_569283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569283, url, valid)

proc call*(call_569284: Call_ReplicationPoliciesCreate_569274;
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
  var path_569285 = newJObject()
  var query_569286 = newJObject()
  var body_569287 = newJObject()
  add(path_569285, "resourceGroupName", newJString(resourceGroupName))
  add(query_569286, "api-version", newJString(apiVersion))
  add(path_569285, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_569287 = input
  add(path_569285, "resourceName", newJString(resourceName))
  add(path_569285, "policyName", newJString(policyName))
  result = call_569284.call(path_569285, query_569286, nil, nil, body_569287)

var replicationPoliciesCreate* = Call_ReplicationPoliciesCreate_569274(
    name: "replicationPoliciesCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies/{policyName}",
    validator: validate_ReplicationPoliciesCreate_569275, base: "",
    url: url_ReplicationPoliciesCreate_569276, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesGet_569262 = ref object of OpenApiRestCall_567666
proc url_ReplicationPoliciesGet_569264(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationPoliciesGet_569263(path: JsonNode; query: JsonNode;
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
  var valid_569265 = path.getOrDefault("resourceGroupName")
  valid_569265 = validateParameter(valid_569265, JString, required = true,
                                 default = nil)
  if valid_569265 != nil:
    section.add "resourceGroupName", valid_569265
  var valid_569266 = path.getOrDefault("subscriptionId")
  valid_569266 = validateParameter(valid_569266, JString, required = true,
                                 default = nil)
  if valid_569266 != nil:
    section.add "subscriptionId", valid_569266
  var valid_569267 = path.getOrDefault("resourceName")
  valid_569267 = validateParameter(valid_569267, JString, required = true,
                                 default = nil)
  if valid_569267 != nil:
    section.add "resourceName", valid_569267
  var valid_569268 = path.getOrDefault("policyName")
  valid_569268 = validateParameter(valid_569268, JString, required = true,
                                 default = nil)
  if valid_569268 != nil:
    section.add "policyName", valid_569268
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569269 = query.getOrDefault("api-version")
  valid_569269 = validateParameter(valid_569269, JString, required = true,
                                 default = nil)
  if valid_569269 != nil:
    section.add "api-version", valid_569269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569270: Call_ReplicationPoliciesGet_569262; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a replication policy.
  ## 
  let valid = call_569270.validator(path, query, header, formData, body)
  let scheme = call_569270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569270.url(scheme.get, call_569270.host, call_569270.base,
                         call_569270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569270, url, valid)

proc call*(call_569271: Call_ReplicationPoliciesGet_569262;
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
  var path_569272 = newJObject()
  var query_569273 = newJObject()
  add(path_569272, "resourceGroupName", newJString(resourceGroupName))
  add(query_569273, "api-version", newJString(apiVersion))
  add(path_569272, "subscriptionId", newJString(subscriptionId))
  add(path_569272, "resourceName", newJString(resourceName))
  add(path_569272, "policyName", newJString(policyName))
  result = call_569271.call(path_569272, query_569273, nil, nil, nil)

var replicationPoliciesGet* = Call_ReplicationPoliciesGet_569262(
    name: "replicationPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies/{policyName}",
    validator: validate_ReplicationPoliciesGet_569263, base: "",
    url: url_ReplicationPoliciesGet_569264, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesUpdate_569300 = ref object of OpenApiRestCall_567666
proc url_ReplicationPoliciesUpdate_569302(protocol: Scheme; host: string;
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

proc validate_ReplicationPoliciesUpdate_569301(path: JsonNode; query: JsonNode;
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
  ##             : Protection profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569303 = path.getOrDefault("resourceGroupName")
  valid_569303 = validateParameter(valid_569303, JString, required = true,
                                 default = nil)
  if valid_569303 != nil:
    section.add "resourceGroupName", valid_569303
  var valid_569304 = path.getOrDefault("subscriptionId")
  valid_569304 = validateParameter(valid_569304, JString, required = true,
                                 default = nil)
  if valid_569304 != nil:
    section.add "subscriptionId", valid_569304
  var valid_569305 = path.getOrDefault("resourceName")
  valid_569305 = validateParameter(valid_569305, JString, required = true,
                                 default = nil)
  if valid_569305 != nil:
    section.add "resourceName", valid_569305
  var valid_569306 = path.getOrDefault("policyName")
  valid_569306 = validateParameter(valid_569306, JString, required = true,
                                 default = nil)
  if valid_569306 != nil:
    section.add "policyName", valid_569306
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569307 = query.getOrDefault("api-version")
  valid_569307 = validateParameter(valid_569307, JString, required = true,
                                 default = nil)
  if valid_569307 != nil:
    section.add "api-version", valid_569307
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

proc call*(call_569309: Call_ReplicationPoliciesUpdate_569300; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a replication policy.
  ## 
  let valid = call_569309.validator(path, query, header, formData, body)
  let scheme = call_569309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569309.url(scheme.get, call_569309.host, call_569309.base,
                         call_569309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569309, url, valid)

proc call*(call_569310: Call_ReplicationPoliciesUpdate_569300;
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
  ##        : Update Protection Profile Input
  ##   resourceName: string (required)
  ##               : The name of the recovery services vault.
  ##   policyName: string (required)
  ##             : Protection profile Id.
  var path_569311 = newJObject()
  var query_569312 = newJObject()
  var body_569313 = newJObject()
  add(path_569311, "resourceGroupName", newJString(resourceGroupName))
  add(query_569312, "api-version", newJString(apiVersion))
  add(path_569311, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_569313 = input
  add(path_569311, "resourceName", newJString(resourceName))
  add(path_569311, "policyName", newJString(policyName))
  result = call_569310.call(path_569311, query_569312, nil, nil, body_569313)

var replicationPoliciesUpdate* = Call_ReplicationPoliciesUpdate_569300(
    name: "replicationPoliciesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies/{policyName}",
    validator: validate_ReplicationPoliciesUpdate_569301, base: "",
    url: url_ReplicationPoliciesUpdate_569302, schemes: {Scheme.Https})
type
  Call_ReplicationPoliciesDelete_569288 = ref object of OpenApiRestCall_567666
proc url_ReplicationPoliciesDelete_569290(protocol: Scheme; host: string;
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

proc validate_ReplicationPoliciesDelete_569289(path: JsonNode; query: JsonNode;
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
  var valid_569291 = path.getOrDefault("resourceGroupName")
  valid_569291 = validateParameter(valid_569291, JString, required = true,
                                 default = nil)
  if valid_569291 != nil:
    section.add "resourceGroupName", valid_569291
  var valid_569292 = path.getOrDefault("subscriptionId")
  valid_569292 = validateParameter(valid_569292, JString, required = true,
                                 default = nil)
  if valid_569292 != nil:
    section.add "subscriptionId", valid_569292
  var valid_569293 = path.getOrDefault("resourceName")
  valid_569293 = validateParameter(valid_569293, JString, required = true,
                                 default = nil)
  if valid_569293 != nil:
    section.add "resourceName", valid_569293
  var valid_569294 = path.getOrDefault("policyName")
  valid_569294 = validateParameter(valid_569294, JString, required = true,
                                 default = nil)
  if valid_569294 != nil:
    section.add "policyName", valid_569294
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569295 = query.getOrDefault("api-version")
  valid_569295 = validateParameter(valid_569295, JString, required = true,
                                 default = nil)
  if valid_569295 != nil:
    section.add "api-version", valid_569295
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569296: Call_ReplicationPoliciesDelete_569288; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete a replication policy.
  ## 
  let valid = call_569296.validator(path, query, header, formData, body)
  let scheme = call_569296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569296.url(scheme.get, call_569296.host, call_569296.base,
                         call_569296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569296, url, valid)

proc call*(call_569297: Call_ReplicationPoliciesDelete_569288;
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
  var path_569298 = newJObject()
  var query_569299 = newJObject()
  add(path_569298, "resourceGroupName", newJString(resourceGroupName))
  add(query_569299, "api-version", newJString(apiVersion))
  add(path_569298, "subscriptionId", newJString(subscriptionId))
  add(path_569298, "resourceName", newJString(resourceName))
  add(path_569298, "policyName", newJString(policyName))
  result = call_569297.call(path_569298, query_569299, nil, nil, nil)

var replicationPoliciesDelete* = Call_ReplicationPoliciesDelete_569288(
    name: "replicationPoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationPolicies/{policyName}",
    validator: validate_ReplicationPoliciesDelete_569289, base: "",
    url: url_ReplicationPoliciesDelete_569290, schemes: {Scheme.Https})
type
  Call_ReplicationProtectedItemsList_569314 = ref object of OpenApiRestCall_567666
proc url_ReplicationProtectedItemsList_569316(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectedItemsList_569315(path: JsonNode; query: JsonNode;
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
  var valid_569317 = path.getOrDefault("resourceGroupName")
  valid_569317 = validateParameter(valid_569317, JString, required = true,
                                 default = nil)
  if valid_569317 != nil:
    section.add "resourceGroupName", valid_569317
  var valid_569318 = path.getOrDefault("subscriptionId")
  valid_569318 = validateParameter(valid_569318, JString, required = true,
                                 default = nil)
  if valid_569318 != nil:
    section.add "subscriptionId", valid_569318
  var valid_569319 = path.getOrDefault("resourceName")
  valid_569319 = validateParameter(valid_569319, JString, required = true,
                                 default = nil)
  if valid_569319 != nil:
    section.add "resourceName", valid_569319
  result.add "path", section
  ## parameters in `query` object:
  ##   skipToken: JString
  ##            : The pagination token. Possible values: "FabricId" or "FabricId_CloudId" or null
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter options.
  section = newJObject()
  var valid_569320 = query.getOrDefault("skipToken")
  valid_569320 = validateParameter(valid_569320, JString, required = false,
                                 default = nil)
  if valid_569320 != nil:
    section.add "skipToken", valid_569320
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569321 = query.getOrDefault("api-version")
  valid_569321 = validateParameter(valid_569321, JString, required = true,
                                 default = nil)
  if valid_569321 != nil:
    section.add "api-version", valid_569321
  var valid_569322 = query.getOrDefault("$filter")
  valid_569322 = validateParameter(valid_569322, JString, required = false,
                                 default = nil)
  if valid_569322 != nil:
    section.add "$filter", valid_569322
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569323: Call_ReplicationProtectedItemsList_569314; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of ASR replication protected items in the vault.
  ## 
  let valid = call_569323.validator(path, query, header, formData, body)
  let scheme = call_569323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569323.url(scheme.get, call_569323.host, call_569323.base,
                         call_569323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569323, url, valid)

proc call*(call_569324: Call_ReplicationProtectedItemsList_569314;
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
  var path_569325 = newJObject()
  var query_569326 = newJObject()
  add(path_569325, "resourceGroupName", newJString(resourceGroupName))
  add(query_569326, "skipToken", newJString(skipToken))
  add(query_569326, "api-version", newJString(apiVersion))
  add(path_569325, "subscriptionId", newJString(subscriptionId))
  add(path_569325, "resourceName", newJString(resourceName))
  add(query_569326, "$filter", newJString(Filter))
  result = call_569324.call(path_569325, query_569326, nil, nil, nil)

var replicationProtectedItemsList* = Call_ReplicationProtectedItemsList_569314(
    name: "replicationProtectedItemsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationProtectedItems",
    validator: validate_ReplicationProtectedItemsList_569315, base: "",
    url: url_ReplicationProtectedItemsList_569316, schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainerMappingsList_569327 = ref object of OpenApiRestCall_567666
proc url_ReplicationProtectionContainerMappingsList_569329(protocol: Scheme;
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

proc validate_ReplicationProtectionContainerMappingsList_569328(path: JsonNode;
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
  var valid_569330 = path.getOrDefault("resourceGroupName")
  valid_569330 = validateParameter(valid_569330, JString, required = true,
                                 default = nil)
  if valid_569330 != nil:
    section.add "resourceGroupName", valid_569330
  var valid_569331 = path.getOrDefault("subscriptionId")
  valid_569331 = validateParameter(valid_569331, JString, required = true,
                                 default = nil)
  if valid_569331 != nil:
    section.add "subscriptionId", valid_569331
  var valid_569332 = path.getOrDefault("resourceName")
  valid_569332 = validateParameter(valid_569332, JString, required = true,
                                 default = nil)
  if valid_569332 != nil:
    section.add "resourceName", valid_569332
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

proc call*(call_569334: Call_ReplicationProtectionContainerMappingsList_569327;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the protection container mappings in the vault.
  ## 
  let valid = call_569334.validator(path, query, header, formData, body)
  let scheme = call_569334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569334.url(scheme.get, call_569334.host, call_569334.base,
                         call_569334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569334, url, valid)

proc call*(call_569335: Call_ReplicationProtectionContainerMappingsList_569327;
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
  var path_569336 = newJObject()
  var query_569337 = newJObject()
  add(path_569336, "resourceGroupName", newJString(resourceGroupName))
  add(query_569337, "api-version", newJString(apiVersion))
  add(path_569336, "subscriptionId", newJString(subscriptionId))
  add(path_569336, "resourceName", newJString(resourceName))
  result = call_569335.call(path_569336, query_569337, nil, nil, nil)

var replicationProtectionContainerMappingsList* = Call_ReplicationProtectionContainerMappingsList_569327(
    name: "replicationProtectionContainerMappingsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationProtectionContainerMappings",
    validator: validate_ReplicationProtectionContainerMappingsList_569328,
    base: "", url: url_ReplicationProtectionContainerMappingsList_569329,
    schemes: {Scheme.Https})
type
  Call_ReplicationProtectionContainersList_569338 = ref object of OpenApiRestCall_567666
proc url_ReplicationProtectionContainersList_569340(protocol: Scheme; host: string;
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

proc validate_ReplicationProtectionContainersList_569339(path: JsonNode;
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
  var valid_569341 = path.getOrDefault("resourceGroupName")
  valid_569341 = validateParameter(valid_569341, JString, required = true,
                                 default = nil)
  if valid_569341 != nil:
    section.add "resourceGroupName", valid_569341
  var valid_569342 = path.getOrDefault("subscriptionId")
  valid_569342 = validateParameter(valid_569342, JString, required = true,
                                 default = nil)
  if valid_569342 != nil:
    section.add "subscriptionId", valid_569342
  var valid_569343 = path.getOrDefault("resourceName")
  valid_569343 = validateParameter(valid_569343, JString, required = true,
                                 default = nil)
  if valid_569343 != nil:
    section.add "resourceName", valid_569343
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569344 = query.getOrDefault("api-version")
  valid_569344 = validateParameter(valid_569344, JString, required = true,
                                 default = nil)
  if valid_569344 != nil:
    section.add "api-version", valid_569344
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569345: Call_ReplicationProtectionContainersList_569338;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the protection containers in a vault.
  ## 
  let valid = call_569345.validator(path, query, header, formData, body)
  let scheme = call_569345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569345.url(scheme.get, call_569345.host, call_569345.base,
                         call_569345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569345, url, valid)

proc call*(call_569346: Call_ReplicationProtectionContainersList_569338;
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
  var path_569347 = newJObject()
  var query_569348 = newJObject()
  add(path_569347, "resourceGroupName", newJString(resourceGroupName))
  add(query_569348, "api-version", newJString(apiVersion))
  add(path_569347, "subscriptionId", newJString(subscriptionId))
  add(path_569347, "resourceName", newJString(resourceName))
  result = call_569346.call(path_569347, query_569348, nil, nil, nil)

var replicationProtectionContainersList* = Call_ReplicationProtectionContainersList_569338(
    name: "replicationProtectionContainersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationProtectionContainers",
    validator: validate_ReplicationProtectionContainersList_569339, base: "",
    url: url_ReplicationProtectionContainersList_569340, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansList_569349 = ref object of OpenApiRestCall_567666
proc url_ReplicationRecoveryPlansList_569351(protocol: Scheme; host: string;
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

proc validate_ReplicationRecoveryPlansList_569350(path: JsonNode; query: JsonNode;
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
  var valid_569352 = path.getOrDefault("resourceGroupName")
  valid_569352 = validateParameter(valid_569352, JString, required = true,
                                 default = nil)
  if valid_569352 != nil:
    section.add "resourceGroupName", valid_569352
  var valid_569353 = path.getOrDefault("subscriptionId")
  valid_569353 = validateParameter(valid_569353, JString, required = true,
                                 default = nil)
  if valid_569353 != nil:
    section.add "subscriptionId", valid_569353
  var valid_569354 = path.getOrDefault("resourceName")
  valid_569354 = validateParameter(valid_569354, JString, required = true,
                                 default = nil)
  if valid_569354 != nil:
    section.add "resourceName", valid_569354
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569355 = query.getOrDefault("api-version")
  valid_569355 = validateParameter(valid_569355, JString, required = true,
                                 default = nil)
  if valid_569355 != nil:
    section.add "api-version", valid_569355
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569356: Call_ReplicationRecoveryPlansList_569349; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the recovery plans in the vault.
  ## 
  let valid = call_569356.validator(path, query, header, formData, body)
  let scheme = call_569356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569356.url(scheme.get, call_569356.host, call_569356.base,
                         call_569356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569356, url, valid)

proc call*(call_569357: Call_ReplicationRecoveryPlansList_569349;
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
  var path_569358 = newJObject()
  var query_569359 = newJObject()
  add(path_569358, "resourceGroupName", newJString(resourceGroupName))
  add(query_569359, "api-version", newJString(apiVersion))
  add(path_569358, "subscriptionId", newJString(subscriptionId))
  add(path_569358, "resourceName", newJString(resourceName))
  result = call_569357.call(path_569358, query_569359, nil, nil, nil)

var replicationRecoveryPlansList* = Call_ReplicationRecoveryPlansList_569349(
    name: "replicationRecoveryPlansList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans",
    validator: validate_ReplicationRecoveryPlansList_569350, base: "",
    url: url_ReplicationRecoveryPlansList_569351, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansCreate_569372 = ref object of OpenApiRestCall_567666
proc url_ReplicationRecoveryPlansCreate_569374(protocol: Scheme; host: string;
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

proc validate_ReplicationRecoveryPlansCreate_569373(path: JsonNode;
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
  var valid_569375 = path.getOrDefault("resourceGroupName")
  valid_569375 = validateParameter(valid_569375, JString, required = true,
                                 default = nil)
  if valid_569375 != nil:
    section.add "resourceGroupName", valid_569375
  var valid_569376 = path.getOrDefault("subscriptionId")
  valid_569376 = validateParameter(valid_569376, JString, required = true,
                                 default = nil)
  if valid_569376 != nil:
    section.add "subscriptionId", valid_569376
  var valid_569377 = path.getOrDefault("recoveryPlanName")
  valid_569377 = validateParameter(valid_569377, JString, required = true,
                                 default = nil)
  if valid_569377 != nil:
    section.add "recoveryPlanName", valid_569377
  var valid_569378 = path.getOrDefault("resourceName")
  valid_569378 = validateParameter(valid_569378, JString, required = true,
                                 default = nil)
  if valid_569378 != nil:
    section.add "resourceName", valid_569378
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569379 = query.getOrDefault("api-version")
  valid_569379 = validateParameter(valid_569379, JString, required = true,
                                 default = nil)
  if valid_569379 != nil:
    section.add "api-version", valid_569379
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

proc call*(call_569381: Call_ReplicationRecoveryPlansCreate_569372; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create a recovery plan.
  ## 
  let valid = call_569381.validator(path, query, header, formData, body)
  let scheme = call_569381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569381.url(scheme.get, call_569381.host, call_569381.base,
                         call_569381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569381, url, valid)

proc call*(call_569382: Call_ReplicationRecoveryPlansCreate_569372;
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
  var path_569383 = newJObject()
  var query_569384 = newJObject()
  var body_569385 = newJObject()
  add(path_569383, "resourceGroupName", newJString(resourceGroupName))
  add(query_569384, "api-version", newJString(apiVersion))
  add(path_569383, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_569385 = input
  add(path_569383, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_569383, "resourceName", newJString(resourceName))
  result = call_569382.call(path_569383, query_569384, nil, nil, body_569385)

var replicationRecoveryPlansCreate* = Call_ReplicationRecoveryPlansCreate_569372(
    name: "replicationRecoveryPlansCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}",
    validator: validate_ReplicationRecoveryPlansCreate_569373, base: "",
    url: url_ReplicationRecoveryPlansCreate_569374, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansGet_569360 = ref object of OpenApiRestCall_567666
proc url_ReplicationRecoveryPlansGet_569362(protocol: Scheme; host: string;
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

proc validate_ReplicationRecoveryPlansGet_569361(path: JsonNode; query: JsonNode;
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
  var valid_569363 = path.getOrDefault("resourceGroupName")
  valid_569363 = validateParameter(valid_569363, JString, required = true,
                                 default = nil)
  if valid_569363 != nil:
    section.add "resourceGroupName", valid_569363
  var valid_569364 = path.getOrDefault("subscriptionId")
  valid_569364 = validateParameter(valid_569364, JString, required = true,
                                 default = nil)
  if valid_569364 != nil:
    section.add "subscriptionId", valid_569364
  var valid_569365 = path.getOrDefault("recoveryPlanName")
  valid_569365 = validateParameter(valid_569365, JString, required = true,
                                 default = nil)
  if valid_569365 != nil:
    section.add "recoveryPlanName", valid_569365
  var valid_569366 = path.getOrDefault("resourceName")
  valid_569366 = validateParameter(valid_569366, JString, required = true,
                                 default = nil)
  if valid_569366 != nil:
    section.add "resourceName", valid_569366
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569367 = query.getOrDefault("api-version")
  valid_569367 = validateParameter(valid_569367, JString, required = true,
                                 default = nil)
  if valid_569367 != nil:
    section.add "api-version", valid_569367
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569368: Call_ReplicationRecoveryPlansGet_569360; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the recovery plan.
  ## 
  let valid = call_569368.validator(path, query, header, formData, body)
  let scheme = call_569368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569368.url(scheme.get, call_569368.host, call_569368.base,
                         call_569368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569368, url, valid)

proc call*(call_569369: Call_ReplicationRecoveryPlansGet_569360;
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
  var path_569370 = newJObject()
  var query_569371 = newJObject()
  add(path_569370, "resourceGroupName", newJString(resourceGroupName))
  add(query_569371, "api-version", newJString(apiVersion))
  add(path_569370, "subscriptionId", newJString(subscriptionId))
  add(path_569370, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_569370, "resourceName", newJString(resourceName))
  result = call_569369.call(path_569370, query_569371, nil, nil, nil)

var replicationRecoveryPlansGet* = Call_ReplicationRecoveryPlansGet_569360(
    name: "replicationRecoveryPlansGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}",
    validator: validate_ReplicationRecoveryPlansGet_569361, base: "",
    url: url_ReplicationRecoveryPlansGet_569362, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansUpdate_569398 = ref object of OpenApiRestCall_567666
proc url_ReplicationRecoveryPlansUpdate_569400(protocol: Scheme; host: string;
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

proc validate_ReplicationRecoveryPlansUpdate_569399(path: JsonNode;
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
  var valid_569401 = path.getOrDefault("resourceGroupName")
  valid_569401 = validateParameter(valid_569401, JString, required = true,
                                 default = nil)
  if valid_569401 != nil:
    section.add "resourceGroupName", valid_569401
  var valid_569402 = path.getOrDefault("subscriptionId")
  valid_569402 = validateParameter(valid_569402, JString, required = true,
                                 default = nil)
  if valid_569402 != nil:
    section.add "subscriptionId", valid_569402
  var valid_569403 = path.getOrDefault("recoveryPlanName")
  valid_569403 = validateParameter(valid_569403, JString, required = true,
                                 default = nil)
  if valid_569403 != nil:
    section.add "recoveryPlanName", valid_569403
  var valid_569404 = path.getOrDefault("resourceName")
  valid_569404 = validateParameter(valid_569404, JString, required = true,
                                 default = nil)
  if valid_569404 != nil:
    section.add "resourceName", valid_569404
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569405 = query.getOrDefault("api-version")
  valid_569405 = validateParameter(valid_569405, JString, required = true,
                                 default = nil)
  if valid_569405 != nil:
    section.add "api-version", valid_569405
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

proc call*(call_569407: Call_ReplicationRecoveryPlansUpdate_569398; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a recovery plan.
  ## 
  let valid = call_569407.validator(path, query, header, formData, body)
  let scheme = call_569407.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569407.url(scheme.get, call_569407.host, call_569407.base,
                         call_569407.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569407, url, valid)

proc call*(call_569408: Call_ReplicationRecoveryPlansUpdate_569398;
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
  var path_569409 = newJObject()
  var query_569410 = newJObject()
  var body_569411 = newJObject()
  add(path_569409, "resourceGroupName", newJString(resourceGroupName))
  add(query_569410, "api-version", newJString(apiVersion))
  add(path_569409, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_569411 = input
  add(path_569409, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_569409, "resourceName", newJString(resourceName))
  result = call_569408.call(path_569409, query_569410, nil, nil, body_569411)

var replicationRecoveryPlansUpdate* = Call_ReplicationRecoveryPlansUpdate_569398(
    name: "replicationRecoveryPlansUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}",
    validator: validate_ReplicationRecoveryPlansUpdate_569399, base: "",
    url: url_ReplicationRecoveryPlansUpdate_569400, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansDelete_569386 = ref object of OpenApiRestCall_567666
proc url_ReplicationRecoveryPlansDelete_569388(protocol: Scheme; host: string;
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

proc validate_ReplicationRecoveryPlansDelete_569387(path: JsonNode;
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
  var valid_569389 = path.getOrDefault("resourceGroupName")
  valid_569389 = validateParameter(valid_569389, JString, required = true,
                                 default = nil)
  if valid_569389 != nil:
    section.add "resourceGroupName", valid_569389
  var valid_569390 = path.getOrDefault("subscriptionId")
  valid_569390 = validateParameter(valid_569390, JString, required = true,
                                 default = nil)
  if valid_569390 != nil:
    section.add "subscriptionId", valid_569390
  var valid_569391 = path.getOrDefault("recoveryPlanName")
  valid_569391 = validateParameter(valid_569391, JString, required = true,
                                 default = nil)
  if valid_569391 != nil:
    section.add "recoveryPlanName", valid_569391
  var valid_569392 = path.getOrDefault("resourceName")
  valid_569392 = validateParameter(valid_569392, JString, required = true,
                                 default = nil)
  if valid_569392 != nil:
    section.add "resourceName", valid_569392
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569393 = query.getOrDefault("api-version")
  valid_569393 = validateParameter(valid_569393, JString, required = true,
                                 default = nil)
  if valid_569393 != nil:
    section.add "api-version", valid_569393
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569394: Call_ReplicationRecoveryPlansDelete_569386; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a recovery plan.
  ## 
  let valid = call_569394.validator(path, query, header, formData, body)
  let scheme = call_569394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569394.url(scheme.get, call_569394.host, call_569394.base,
                         call_569394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569394, url, valid)

proc call*(call_569395: Call_ReplicationRecoveryPlansDelete_569386;
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
  var path_569396 = newJObject()
  var query_569397 = newJObject()
  add(path_569396, "resourceGroupName", newJString(resourceGroupName))
  add(query_569397, "api-version", newJString(apiVersion))
  add(path_569396, "subscriptionId", newJString(subscriptionId))
  add(path_569396, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_569396, "resourceName", newJString(resourceName))
  result = call_569395.call(path_569396, query_569397, nil, nil, nil)

var replicationRecoveryPlansDelete* = Call_ReplicationRecoveryPlansDelete_569386(
    name: "replicationRecoveryPlansDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}",
    validator: validate_ReplicationRecoveryPlansDelete_569387, base: "",
    url: url_ReplicationRecoveryPlansDelete_569388, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansFailoverCommit_569412 = ref object of OpenApiRestCall_567666
proc url_ReplicationRecoveryPlansFailoverCommit_569414(protocol: Scheme;
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

proc validate_ReplicationRecoveryPlansFailoverCommit_569413(path: JsonNode;
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
  var valid_569415 = path.getOrDefault("resourceGroupName")
  valid_569415 = validateParameter(valid_569415, JString, required = true,
                                 default = nil)
  if valid_569415 != nil:
    section.add "resourceGroupName", valid_569415
  var valid_569416 = path.getOrDefault("subscriptionId")
  valid_569416 = validateParameter(valid_569416, JString, required = true,
                                 default = nil)
  if valid_569416 != nil:
    section.add "subscriptionId", valid_569416
  var valid_569417 = path.getOrDefault("recoveryPlanName")
  valid_569417 = validateParameter(valid_569417, JString, required = true,
                                 default = nil)
  if valid_569417 != nil:
    section.add "recoveryPlanName", valid_569417
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
  if body != nil:
    result.add "body", body

proc call*(call_569420: Call_ReplicationRecoveryPlansFailoverCommit_569412;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to commit the fail over of a recovery plan.
  ## 
  let valid = call_569420.validator(path, query, header, formData, body)
  let scheme = call_569420.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569420.url(scheme.get, call_569420.host, call_569420.base,
                         call_569420.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569420, url, valid)

proc call*(call_569421: Call_ReplicationRecoveryPlansFailoverCommit_569412;
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
  var path_569422 = newJObject()
  var query_569423 = newJObject()
  add(path_569422, "resourceGroupName", newJString(resourceGroupName))
  add(query_569423, "api-version", newJString(apiVersion))
  add(path_569422, "subscriptionId", newJString(subscriptionId))
  add(path_569422, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_569422, "resourceName", newJString(resourceName))
  result = call_569421.call(path_569422, query_569423, nil, nil, nil)

var replicationRecoveryPlansFailoverCommit* = Call_ReplicationRecoveryPlansFailoverCommit_569412(
    name: "replicationRecoveryPlansFailoverCommit", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/failoverCommit",
    validator: validate_ReplicationRecoveryPlansFailoverCommit_569413, base: "",
    url: url_ReplicationRecoveryPlansFailoverCommit_569414,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansPlannedFailover_569424 = ref object of OpenApiRestCall_567666
proc url_ReplicationRecoveryPlansPlannedFailover_569426(protocol: Scheme;
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

proc validate_ReplicationRecoveryPlansPlannedFailover_569425(path: JsonNode;
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
  var valid_569427 = path.getOrDefault("resourceGroupName")
  valid_569427 = validateParameter(valid_569427, JString, required = true,
                                 default = nil)
  if valid_569427 != nil:
    section.add "resourceGroupName", valid_569427
  var valid_569428 = path.getOrDefault("subscriptionId")
  valid_569428 = validateParameter(valid_569428, JString, required = true,
                                 default = nil)
  if valid_569428 != nil:
    section.add "subscriptionId", valid_569428
  var valid_569429 = path.getOrDefault("recoveryPlanName")
  valid_569429 = validateParameter(valid_569429, JString, required = true,
                                 default = nil)
  if valid_569429 != nil:
    section.add "recoveryPlanName", valid_569429
  var valid_569430 = path.getOrDefault("resourceName")
  valid_569430 = validateParameter(valid_569430, JString, required = true,
                                 default = nil)
  if valid_569430 != nil:
    section.add "resourceName", valid_569430
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569431 = query.getOrDefault("api-version")
  valid_569431 = validateParameter(valid_569431, JString, required = true,
                                 default = nil)
  if valid_569431 != nil:
    section.add "api-version", valid_569431
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

proc call*(call_569433: Call_ReplicationRecoveryPlansPlannedFailover_569424;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to start the planned failover of a recovery plan.
  ## 
  let valid = call_569433.validator(path, query, header, formData, body)
  let scheme = call_569433.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569433.url(scheme.get, call_569433.host, call_569433.base,
                         call_569433.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569433, url, valid)

proc call*(call_569434: Call_ReplicationRecoveryPlansPlannedFailover_569424;
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
  var path_569435 = newJObject()
  var query_569436 = newJObject()
  var body_569437 = newJObject()
  add(path_569435, "resourceGroupName", newJString(resourceGroupName))
  add(query_569436, "api-version", newJString(apiVersion))
  add(path_569435, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_569437 = input
  add(path_569435, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_569435, "resourceName", newJString(resourceName))
  result = call_569434.call(path_569435, query_569436, nil, nil, body_569437)

var replicationRecoveryPlansPlannedFailover* = Call_ReplicationRecoveryPlansPlannedFailover_569424(
    name: "replicationRecoveryPlansPlannedFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/plannedFailover",
    validator: validate_ReplicationRecoveryPlansPlannedFailover_569425, base: "",
    url: url_ReplicationRecoveryPlansPlannedFailover_569426,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansReprotect_569438 = ref object of OpenApiRestCall_567666
proc url_ReplicationRecoveryPlansReprotect_569440(protocol: Scheme; host: string;
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

proc validate_ReplicationRecoveryPlansReprotect_569439(path: JsonNode;
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
  var valid_569443 = path.getOrDefault("recoveryPlanName")
  valid_569443 = validateParameter(valid_569443, JString, required = true,
                                 default = nil)
  if valid_569443 != nil:
    section.add "recoveryPlanName", valid_569443
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

proc call*(call_569446: Call_ReplicationRecoveryPlansReprotect_569438;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to reprotect(reverse replicate) a recovery plan.
  ## 
  let valid = call_569446.validator(path, query, header, formData, body)
  let scheme = call_569446.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569446.url(scheme.get, call_569446.host, call_569446.base,
                         call_569446.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569446, url, valid)

proc call*(call_569447: Call_ReplicationRecoveryPlansReprotect_569438;
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
  var path_569448 = newJObject()
  var query_569449 = newJObject()
  add(path_569448, "resourceGroupName", newJString(resourceGroupName))
  add(query_569449, "api-version", newJString(apiVersion))
  add(path_569448, "subscriptionId", newJString(subscriptionId))
  add(path_569448, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_569448, "resourceName", newJString(resourceName))
  result = call_569447.call(path_569448, query_569449, nil, nil, nil)

var replicationRecoveryPlansReprotect* = Call_ReplicationRecoveryPlansReprotect_569438(
    name: "replicationRecoveryPlansReprotect", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/reProtect",
    validator: validate_ReplicationRecoveryPlansReprotect_569439, base: "",
    url: url_ReplicationRecoveryPlansReprotect_569440, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansTestFailover_569450 = ref object of OpenApiRestCall_567666
proc url_ReplicationRecoveryPlansTestFailover_569452(protocol: Scheme;
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

proc validate_ReplicationRecoveryPlansTestFailover_569451(path: JsonNode;
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
  var valid_569455 = path.getOrDefault("recoveryPlanName")
  valid_569455 = validateParameter(valid_569455, JString, required = true,
                                 default = nil)
  if valid_569455 != nil:
    section.add "recoveryPlanName", valid_569455
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
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Failover input.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569459: Call_ReplicationRecoveryPlansTestFailover_569450;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to start the test failover of a recovery plan.
  ## 
  let valid = call_569459.validator(path, query, header, formData, body)
  let scheme = call_569459.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569459.url(scheme.get, call_569459.host, call_569459.base,
                         call_569459.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569459, url, valid)

proc call*(call_569460: Call_ReplicationRecoveryPlansTestFailover_569450;
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
  var path_569461 = newJObject()
  var query_569462 = newJObject()
  var body_569463 = newJObject()
  add(path_569461, "resourceGroupName", newJString(resourceGroupName))
  add(query_569462, "api-version", newJString(apiVersion))
  add(path_569461, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_569463 = input
  add(path_569461, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_569461, "resourceName", newJString(resourceName))
  result = call_569460.call(path_569461, query_569462, nil, nil, body_569463)

var replicationRecoveryPlansTestFailover* = Call_ReplicationRecoveryPlansTestFailover_569450(
    name: "replicationRecoveryPlansTestFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/testFailover",
    validator: validate_ReplicationRecoveryPlansTestFailover_569451, base: "",
    url: url_ReplicationRecoveryPlansTestFailover_569452, schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansTestFailoverCleanup_569464 = ref object of OpenApiRestCall_567666
proc url_ReplicationRecoveryPlansTestFailoverCleanup_569466(protocol: Scheme;
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

proc validate_ReplicationRecoveryPlansTestFailoverCleanup_569465(path: JsonNode;
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
  var valid_569467 = path.getOrDefault("resourceGroupName")
  valid_569467 = validateParameter(valid_569467, JString, required = true,
                                 default = nil)
  if valid_569467 != nil:
    section.add "resourceGroupName", valid_569467
  var valid_569468 = path.getOrDefault("subscriptionId")
  valid_569468 = validateParameter(valid_569468, JString, required = true,
                                 default = nil)
  if valid_569468 != nil:
    section.add "subscriptionId", valid_569468
  var valid_569469 = path.getOrDefault("recoveryPlanName")
  valid_569469 = validateParameter(valid_569469, JString, required = true,
                                 default = nil)
  if valid_569469 != nil:
    section.add "recoveryPlanName", valid_569469
  var valid_569470 = path.getOrDefault("resourceName")
  valid_569470 = validateParameter(valid_569470, JString, required = true,
                                 default = nil)
  if valid_569470 != nil:
    section.add "resourceName", valid_569470
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569471 = query.getOrDefault("api-version")
  valid_569471 = validateParameter(valid_569471, JString, required = true,
                                 default = nil)
  if valid_569471 != nil:
    section.add "api-version", valid_569471
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

proc call*(call_569473: Call_ReplicationRecoveryPlansTestFailoverCleanup_569464;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to cleanup test failover of a recovery plan.
  ## 
  let valid = call_569473.validator(path, query, header, formData, body)
  let scheme = call_569473.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569473.url(scheme.get, call_569473.host, call_569473.base,
                         call_569473.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569473, url, valid)

proc call*(call_569474: Call_ReplicationRecoveryPlansTestFailoverCleanup_569464;
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
  var path_569475 = newJObject()
  var query_569476 = newJObject()
  var body_569477 = newJObject()
  add(path_569475, "resourceGroupName", newJString(resourceGroupName))
  add(query_569476, "api-version", newJString(apiVersion))
  add(path_569475, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_569477 = input
  add(path_569475, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_569475, "resourceName", newJString(resourceName))
  result = call_569474.call(path_569475, query_569476, nil, nil, body_569477)

var replicationRecoveryPlansTestFailoverCleanup* = Call_ReplicationRecoveryPlansTestFailoverCleanup_569464(
    name: "replicationRecoveryPlansTestFailoverCleanup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/testFailoverCleanup",
    validator: validate_ReplicationRecoveryPlansTestFailoverCleanup_569465,
    base: "", url: url_ReplicationRecoveryPlansTestFailoverCleanup_569466,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryPlansUnplannedFailover_569478 = ref object of OpenApiRestCall_567666
proc url_ReplicationRecoveryPlansUnplannedFailover_569480(protocol: Scheme;
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

proc validate_ReplicationRecoveryPlansUnplannedFailover_569479(path: JsonNode;
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
  var valid_569481 = path.getOrDefault("resourceGroupName")
  valid_569481 = validateParameter(valid_569481, JString, required = true,
                                 default = nil)
  if valid_569481 != nil:
    section.add "resourceGroupName", valid_569481
  var valid_569482 = path.getOrDefault("subscriptionId")
  valid_569482 = validateParameter(valid_569482, JString, required = true,
                                 default = nil)
  if valid_569482 != nil:
    section.add "subscriptionId", valid_569482
  var valid_569483 = path.getOrDefault("recoveryPlanName")
  valid_569483 = validateParameter(valid_569483, JString, required = true,
                                 default = nil)
  if valid_569483 != nil:
    section.add "recoveryPlanName", valid_569483
  var valid_569484 = path.getOrDefault("resourceName")
  valid_569484 = validateParameter(valid_569484, JString, required = true,
                                 default = nil)
  if valid_569484 != nil:
    section.add "resourceName", valid_569484
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569485 = query.getOrDefault("api-version")
  valid_569485 = validateParameter(valid_569485, JString, required = true,
                                 default = nil)
  if valid_569485 != nil:
    section.add "api-version", valid_569485
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

proc call*(call_569487: Call_ReplicationRecoveryPlansUnplannedFailover_569478;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to start the failover of a recovery plan.
  ## 
  let valid = call_569487.validator(path, query, header, formData, body)
  let scheme = call_569487.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569487.url(scheme.get, call_569487.host, call_569487.base,
                         call_569487.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569487, url, valid)

proc call*(call_569488: Call_ReplicationRecoveryPlansUnplannedFailover_569478;
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
  var path_569489 = newJObject()
  var query_569490 = newJObject()
  var body_569491 = newJObject()
  add(path_569489, "resourceGroupName", newJString(resourceGroupName))
  add(query_569490, "api-version", newJString(apiVersion))
  add(path_569489, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_569491 = input
  add(path_569489, "recoveryPlanName", newJString(recoveryPlanName))
  add(path_569489, "resourceName", newJString(resourceName))
  result = call_569488.call(path_569489, query_569490, nil, nil, body_569491)

var replicationRecoveryPlansUnplannedFailover* = Call_ReplicationRecoveryPlansUnplannedFailover_569478(
    name: "replicationRecoveryPlansUnplannedFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryPlans/{recoveryPlanName}/unplannedFailover",
    validator: validate_ReplicationRecoveryPlansUnplannedFailover_569479,
    base: "", url: url_ReplicationRecoveryPlansUnplannedFailover_569480,
    schemes: {Scheme.Https})
type
  Call_ReplicationRecoveryServicesProvidersList_569492 = ref object of OpenApiRestCall_567666
proc url_ReplicationRecoveryServicesProvidersList_569494(protocol: Scheme;
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

proc validate_ReplicationRecoveryServicesProvidersList_569493(path: JsonNode;
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
  var valid_569495 = path.getOrDefault("resourceGroupName")
  valid_569495 = validateParameter(valid_569495, JString, required = true,
                                 default = nil)
  if valid_569495 != nil:
    section.add "resourceGroupName", valid_569495
  var valid_569496 = path.getOrDefault("subscriptionId")
  valid_569496 = validateParameter(valid_569496, JString, required = true,
                                 default = nil)
  if valid_569496 != nil:
    section.add "subscriptionId", valid_569496
  var valid_569497 = path.getOrDefault("resourceName")
  valid_569497 = validateParameter(valid_569497, JString, required = true,
                                 default = nil)
  if valid_569497 != nil:
    section.add "resourceName", valid_569497
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569498 = query.getOrDefault("api-version")
  valid_569498 = validateParameter(valid_569498, JString, required = true,
                                 default = nil)
  if valid_569498 != nil:
    section.add "api-version", valid_569498
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569499: Call_ReplicationRecoveryServicesProvidersList_569492;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the registered recovery services providers in the vault
  ## 
  let valid = call_569499.validator(path, query, header, formData, body)
  let scheme = call_569499.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569499.url(scheme.get, call_569499.host, call_569499.base,
                         call_569499.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569499, url, valid)

proc call*(call_569500: Call_ReplicationRecoveryServicesProvidersList_569492;
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
  var path_569501 = newJObject()
  var query_569502 = newJObject()
  add(path_569501, "resourceGroupName", newJString(resourceGroupName))
  add(query_569502, "api-version", newJString(apiVersion))
  add(path_569501, "subscriptionId", newJString(subscriptionId))
  add(path_569501, "resourceName", newJString(resourceName))
  result = call_569500.call(path_569501, query_569502, nil, nil, nil)

var replicationRecoveryServicesProvidersList* = Call_ReplicationRecoveryServicesProvidersList_569492(
    name: "replicationRecoveryServicesProvidersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationRecoveryServicesProviders",
    validator: validate_ReplicationRecoveryServicesProvidersList_569493, base: "",
    url: url_ReplicationRecoveryServicesProvidersList_569494,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationMappingsList_569503 = ref object of OpenApiRestCall_567666
proc url_ReplicationStorageClassificationMappingsList_569505(protocol: Scheme;
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

proc validate_ReplicationStorageClassificationMappingsList_569504(path: JsonNode;
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
  var valid_569506 = path.getOrDefault("resourceGroupName")
  valid_569506 = validateParameter(valid_569506, JString, required = true,
                                 default = nil)
  if valid_569506 != nil:
    section.add "resourceGroupName", valid_569506
  var valid_569507 = path.getOrDefault("subscriptionId")
  valid_569507 = validateParameter(valid_569507, JString, required = true,
                                 default = nil)
  if valid_569507 != nil:
    section.add "subscriptionId", valid_569507
  var valid_569508 = path.getOrDefault("resourceName")
  valid_569508 = validateParameter(valid_569508, JString, required = true,
                                 default = nil)
  if valid_569508 != nil:
    section.add "resourceName", valid_569508
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569509 = query.getOrDefault("api-version")
  valid_569509 = validateParameter(valid_569509, JString, required = true,
                                 default = nil)
  if valid_569509 != nil:
    section.add "api-version", valid_569509
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569510: Call_ReplicationStorageClassificationMappingsList_569503;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the storage classification mappings in the vault.
  ## 
  let valid = call_569510.validator(path, query, header, formData, body)
  let scheme = call_569510.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569510.url(scheme.get, call_569510.host, call_569510.base,
                         call_569510.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569510, url, valid)

proc call*(call_569511: Call_ReplicationStorageClassificationMappingsList_569503;
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
  var path_569512 = newJObject()
  var query_569513 = newJObject()
  add(path_569512, "resourceGroupName", newJString(resourceGroupName))
  add(query_569513, "api-version", newJString(apiVersion))
  add(path_569512, "subscriptionId", newJString(subscriptionId))
  add(path_569512, "resourceName", newJString(resourceName))
  result = call_569511.call(path_569512, query_569513, nil, nil, nil)

var replicationStorageClassificationMappingsList* = Call_ReplicationStorageClassificationMappingsList_569503(
    name: "replicationStorageClassificationMappingsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationStorageClassificationMappings",
    validator: validate_ReplicationStorageClassificationMappingsList_569504,
    base: "", url: url_ReplicationStorageClassificationMappingsList_569505,
    schemes: {Scheme.Https})
type
  Call_ReplicationStorageClassificationsList_569514 = ref object of OpenApiRestCall_567666
proc url_ReplicationStorageClassificationsList_569516(protocol: Scheme;
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

proc validate_ReplicationStorageClassificationsList_569515(path: JsonNode;
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
  var valid_569517 = path.getOrDefault("resourceGroupName")
  valid_569517 = validateParameter(valid_569517, JString, required = true,
                                 default = nil)
  if valid_569517 != nil:
    section.add "resourceGroupName", valid_569517
  var valid_569518 = path.getOrDefault("subscriptionId")
  valid_569518 = validateParameter(valid_569518, JString, required = true,
                                 default = nil)
  if valid_569518 != nil:
    section.add "subscriptionId", valid_569518
  var valid_569519 = path.getOrDefault("resourceName")
  valid_569519 = validateParameter(valid_569519, JString, required = true,
                                 default = nil)
  if valid_569519 != nil:
    section.add "resourceName", valid_569519
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569520 = query.getOrDefault("api-version")
  valid_569520 = validateParameter(valid_569520, JString, required = true,
                                 default = nil)
  if valid_569520 != nil:
    section.add "api-version", valid_569520
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569521: Call_ReplicationStorageClassificationsList_569514;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the storage classifications in the vault.
  ## 
  let valid = call_569521.validator(path, query, header, formData, body)
  let scheme = call_569521.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569521.url(scheme.get, call_569521.host, call_569521.base,
                         call_569521.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569521, url, valid)

proc call*(call_569522: Call_ReplicationStorageClassificationsList_569514;
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
  var path_569523 = newJObject()
  var query_569524 = newJObject()
  add(path_569523, "resourceGroupName", newJString(resourceGroupName))
  add(query_569524, "api-version", newJString(apiVersion))
  add(path_569523, "subscriptionId", newJString(subscriptionId))
  add(path_569523, "resourceName", newJString(resourceName))
  result = call_569522.call(path_569523, query_569524, nil, nil, nil)

var replicationStorageClassificationsList* = Call_ReplicationStorageClassificationsList_569514(
    name: "replicationStorageClassificationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationStorageClassifications",
    validator: validate_ReplicationStorageClassificationsList_569515, base: "",
    url: url_ReplicationStorageClassificationsList_569516, schemes: {Scheme.Https})
type
  Call_ReplicationVaultHealthGet_569525 = ref object of OpenApiRestCall_567666
proc url_ReplicationVaultHealthGet_569527(protocol: Scheme; host: string;
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

proc validate_ReplicationVaultHealthGet_569526(path: JsonNode; query: JsonNode;
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
  var valid_569528 = path.getOrDefault("resourceGroupName")
  valid_569528 = validateParameter(valid_569528, JString, required = true,
                                 default = nil)
  if valid_569528 != nil:
    section.add "resourceGroupName", valid_569528
  var valid_569529 = path.getOrDefault("subscriptionId")
  valid_569529 = validateParameter(valid_569529, JString, required = true,
                                 default = nil)
  if valid_569529 != nil:
    section.add "subscriptionId", valid_569529
  var valid_569530 = path.getOrDefault("resourceName")
  valid_569530 = validateParameter(valid_569530, JString, required = true,
                                 default = nil)
  if valid_569530 != nil:
    section.add "resourceName", valid_569530
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569531 = query.getOrDefault("api-version")
  valid_569531 = validateParameter(valid_569531, JString, required = true,
                                 default = nil)
  if valid_569531 != nil:
    section.add "api-version", valid_569531
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569532: Call_ReplicationVaultHealthGet_569525; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health details of the vault.
  ## 
  let valid = call_569532.validator(path, query, header, formData, body)
  let scheme = call_569532.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569532.url(scheme.get, call_569532.host, call_569532.base,
                         call_569532.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569532, url, valid)

proc call*(call_569533: Call_ReplicationVaultHealthGet_569525;
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
  var path_569534 = newJObject()
  var query_569535 = newJObject()
  add(path_569534, "resourceGroupName", newJString(resourceGroupName))
  add(query_569535, "api-version", newJString(apiVersion))
  add(path_569534, "subscriptionId", newJString(subscriptionId))
  add(path_569534, "resourceName", newJString(resourceName))
  result = call_569533.call(path_569534, query_569535, nil, nil, nil)

var replicationVaultHealthGet* = Call_ReplicationVaultHealthGet_569525(
    name: "replicationVaultHealthGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationVaultHealth",
    validator: validate_ReplicationVaultHealthGet_569526, base: "",
    url: url_ReplicationVaultHealthGet_569527, schemes: {Scheme.Https})
type
  Call_ReplicationvCentersList_569536 = ref object of OpenApiRestCall_567666
proc url_ReplicationvCentersList_569538(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicationvCentersList_569537(path: JsonNode; query: JsonNode;
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
  var valid_569539 = path.getOrDefault("resourceGroupName")
  valid_569539 = validateParameter(valid_569539, JString, required = true,
                                 default = nil)
  if valid_569539 != nil:
    section.add "resourceGroupName", valid_569539
  var valid_569540 = path.getOrDefault("subscriptionId")
  valid_569540 = validateParameter(valid_569540, JString, required = true,
                                 default = nil)
  if valid_569540 != nil:
    section.add "subscriptionId", valid_569540
  var valid_569541 = path.getOrDefault("resourceName")
  valid_569541 = validateParameter(valid_569541, JString, required = true,
                                 default = nil)
  if valid_569541 != nil:
    section.add "resourceName", valid_569541
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569542 = query.getOrDefault("api-version")
  valid_569542 = validateParameter(valid_569542, JString, required = true,
                                 default = nil)
  if valid_569542 != nil:
    section.add "api-version", valid_569542
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569543: Call_ReplicationvCentersList_569536; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the vCenter servers registered in the vault.
  ## 
  let valid = call_569543.validator(path, query, header, formData, body)
  let scheme = call_569543.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569543.url(scheme.get, call_569543.host, call_569543.base,
                         call_569543.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569543, url, valid)

proc call*(call_569544: Call_ReplicationvCentersList_569536;
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
  var path_569545 = newJObject()
  var query_569546 = newJObject()
  add(path_569545, "resourceGroupName", newJString(resourceGroupName))
  add(query_569546, "api-version", newJString(apiVersion))
  add(path_569545, "subscriptionId", newJString(subscriptionId))
  add(path_569545, "resourceName", newJString(resourceName))
  result = call_569544.call(path_569545, query_569546, nil, nil, nil)

var replicationvCentersList* = Call_ReplicationvCentersList_569536(
    name: "replicationvCentersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/Subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{resourceName}/replicationvCenters",
    validator: validate_ReplicationvCentersList_569537, base: "",
    url: url_ReplicationvCentersList_569538, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
