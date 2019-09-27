
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Security Center
## version: 2017-08-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## API spec for Microsoft.Security (Azure Security Center) resource provider
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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  macServiceName = "security-workspaceSettings"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_WorkspaceSettingsList_593630 = ref object of OpenApiRestCall_593408
proc url_WorkspaceSettingsList_593632(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/workspaceSettings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspaceSettingsList_593631(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Settings about where we should store your security data and logs. If the result is empty, it means that no custom-workspace configuration was set
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593792 = path.getOrDefault("subscriptionId")
  valid_593792 = validateParameter(valid_593792, JString, required = true,
                                 default = nil)
  if valid_593792 != nil:
    section.add "subscriptionId", valid_593792
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593793 = query.getOrDefault("api-version")
  valid_593793 = validateParameter(valid_593793, JString, required = true,
                                 default = nil)
  if valid_593793 != nil:
    section.add "api-version", valid_593793
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593820: Call_WorkspaceSettingsList_593630; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Settings about where we should store your security data and logs. If the result is empty, it means that no custom-workspace configuration was set
  ## 
  let valid = call_593820.validator(path, query, header, formData, body)
  let scheme = call_593820.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593820.url(scheme.get, call_593820.host, call_593820.base,
                         call_593820.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593820, url, valid)

proc call*(call_593891: Call_WorkspaceSettingsList_593630; apiVersion: string;
          subscriptionId: string): Recallable =
  ## workspaceSettingsList
  ## Settings about where we should store your security data and logs. If the result is empty, it means that no custom-workspace configuration was set
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_593892 = newJObject()
  var query_593894 = newJObject()
  add(query_593894, "api-version", newJString(apiVersion))
  add(path_593892, "subscriptionId", newJString(subscriptionId))
  result = call_593891.call(path_593892, query_593894, nil, nil, nil)

var workspaceSettingsList* = Call_WorkspaceSettingsList_593630(
    name: "workspaceSettingsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/workspaceSettings",
    validator: validate_WorkspaceSettingsList_593631, base: "",
    url: url_WorkspaceSettingsList_593632, schemes: {Scheme.Https})
type
  Call_WorkspaceSettingsCreate_593952 = ref object of OpenApiRestCall_593408
proc url_WorkspaceSettingsCreate_593954(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "workspaceSettingName" in path,
        "`workspaceSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/workspaceSettings/"),
               (kind: VariableSegment, value: "workspaceSettingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspaceSettingsCreate_593953(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## creating settings about where we should store your security data and logs
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceSettingName: JString (required)
  ##                       : Name of the security setting
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593955 = path.getOrDefault("subscriptionId")
  valid_593955 = validateParameter(valid_593955, JString, required = true,
                                 default = nil)
  if valid_593955 != nil:
    section.add "subscriptionId", valid_593955
  var valid_593956 = path.getOrDefault("workspaceSettingName")
  valid_593956 = validateParameter(valid_593956, JString, required = true,
                                 default = nil)
  if valid_593956 != nil:
    section.add "workspaceSettingName", valid_593956
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593957 = query.getOrDefault("api-version")
  valid_593957 = validateParameter(valid_593957, JString, required = true,
                                 default = nil)
  if valid_593957 != nil:
    section.add "api-version", valid_593957
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   workspaceSetting: JObject (required)
  ##                   : Security data setting object
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593959: Call_WorkspaceSettingsCreate_593952; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## creating settings about where we should store your security data and logs
  ## 
  let valid = call_593959.validator(path, query, header, formData, body)
  let scheme = call_593959.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593959.url(scheme.get, call_593959.host, call_593959.base,
                         call_593959.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593959, url, valid)

proc call*(call_593960: Call_WorkspaceSettingsCreate_593952; apiVersion: string;
          subscriptionId: string; workspaceSetting: JsonNode;
          workspaceSettingName: string): Recallable =
  ## workspaceSettingsCreate
  ## creating settings about where we should store your security data and logs
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceSetting: JObject (required)
  ##                   : Security data setting object
  ##   workspaceSettingName: string (required)
  ##                       : Name of the security setting
  var path_593961 = newJObject()
  var query_593962 = newJObject()
  var body_593963 = newJObject()
  add(query_593962, "api-version", newJString(apiVersion))
  add(path_593961, "subscriptionId", newJString(subscriptionId))
  if workspaceSetting != nil:
    body_593963 = workspaceSetting
  add(path_593961, "workspaceSettingName", newJString(workspaceSettingName))
  result = call_593960.call(path_593961, query_593962, nil, nil, body_593963)

var workspaceSettingsCreate* = Call_WorkspaceSettingsCreate_593952(
    name: "workspaceSettingsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/workspaceSettings/{workspaceSettingName}",
    validator: validate_WorkspaceSettingsCreate_593953, base: "",
    url: url_WorkspaceSettingsCreate_593954, schemes: {Scheme.Https})
type
  Call_WorkspaceSettingsGet_593933 = ref object of OpenApiRestCall_593408
proc url_WorkspaceSettingsGet_593935(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "workspaceSettingName" in path,
        "`workspaceSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/workspaceSettings/"),
               (kind: VariableSegment, value: "workspaceSettingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspaceSettingsGet_593934(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Settings about where we should store your security data and logs. If the result is empty, it means that no custom-workspace configuration was set
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceSettingName: JString (required)
  ##                       : Name of the security setting
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593945 = path.getOrDefault("subscriptionId")
  valid_593945 = validateParameter(valid_593945, JString, required = true,
                                 default = nil)
  if valid_593945 != nil:
    section.add "subscriptionId", valid_593945
  var valid_593946 = path.getOrDefault("workspaceSettingName")
  valid_593946 = validateParameter(valid_593946, JString, required = true,
                                 default = nil)
  if valid_593946 != nil:
    section.add "workspaceSettingName", valid_593946
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593947 = query.getOrDefault("api-version")
  valid_593947 = validateParameter(valid_593947, JString, required = true,
                                 default = nil)
  if valid_593947 != nil:
    section.add "api-version", valid_593947
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593948: Call_WorkspaceSettingsGet_593933; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Settings about where we should store your security data and logs. If the result is empty, it means that no custom-workspace configuration was set
  ## 
  let valid = call_593948.validator(path, query, header, formData, body)
  let scheme = call_593948.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593948.url(scheme.get, call_593948.host, call_593948.base,
                         call_593948.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593948, url, valid)

proc call*(call_593949: Call_WorkspaceSettingsGet_593933; apiVersion: string;
          subscriptionId: string; workspaceSettingName: string): Recallable =
  ## workspaceSettingsGet
  ## Settings about where we should store your security data and logs. If the result is empty, it means that no custom-workspace configuration was set
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceSettingName: string (required)
  ##                       : Name of the security setting
  var path_593950 = newJObject()
  var query_593951 = newJObject()
  add(query_593951, "api-version", newJString(apiVersion))
  add(path_593950, "subscriptionId", newJString(subscriptionId))
  add(path_593950, "workspaceSettingName", newJString(workspaceSettingName))
  result = call_593949.call(path_593950, query_593951, nil, nil, nil)

var workspaceSettingsGet* = Call_WorkspaceSettingsGet_593933(
    name: "workspaceSettingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/workspaceSettings/{workspaceSettingName}",
    validator: validate_WorkspaceSettingsGet_593934, base: "",
    url: url_WorkspaceSettingsGet_593935, schemes: {Scheme.Https})
type
  Call_WorkspaceSettingsUpdate_593974 = ref object of OpenApiRestCall_593408
proc url_WorkspaceSettingsUpdate_593976(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "workspaceSettingName" in path,
        "`workspaceSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/workspaceSettings/"),
               (kind: VariableSegment, value: "workspaceSettingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspaceSettingsUpdate_593975(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Settings about where we should store your security data and logs
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceSettingName: JString (required)
  ##                       : Name of the security setting
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593977 = path.getOrDefault("subscriptionId")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = nil)
  if valid_593977 != nil:
    section.add "subscriptionId", valid_593977
  var valid_593978 = path.getOrDefault("workspaceSettingName")
  valid_593978 = validateParameter(valid_593978, JString, required = true,
                                 default = nil)
  if valid_593978 != nil:
    section.add "workspaceSettingName", valid_593978
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593979 = query.getOrDefault("api-version")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "api-version", valid_593979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   workspaceSetting: JObject (required)
  ##                   : Security data setting object
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593981: Call_WorkspaceSettingsUpdate_593974; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Settings about where we should store your security data and logs
  ## 
  let valid = call_593981.validator(path, query, header, formData, body)
  let scheme = call_593981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593981.url(scheme.get, call_593981.host, call_593981.base,
                         call_593981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593981, url, valid)

proc call*(call_593982: Call_WorkspaceSettingsUpdate_593974; apiVersion: string;
          subscriptionId: string; workspaceSetting: JsonNode;
          workspaceSettingName: string): Recallable =
  ## workspaceSettingsUpdate
  ## Settings about where we should store your security data and logs
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceSetting: JObject (required)
  ##                   : Security data setting object
  ##   workspaceSettingName: string (required)
  ##                       : Name of the security setting
  var path_593983 = newJObject()
  var query_593984 = newJObject()
  var body_593985 = newJObject()
  add(query_593984, "api-version", newJString(apiVersion))
  add(path_593983, "subscriptionId", newJString(subscriptionId))
  if workspaceSetting != nil:
    body_593985 = workspaceSetting
  add(path_593983, "workspaceSettingName", newJString(workspaceSettingName))
  result = call_593982.call(path_593983, query_593984, nil, nil, body_593985)

var workspaceSettingsUpdate* = Call_WorkspaceSettingsUpdate_593974(
    name: "workspaceSettingsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/workspaceSettings/{workspaceSettingName}",
    validator: validate_WorkspaceSettingsUpdate_593975, base: "",
    url: url_WorkspaceSettingsUpdate_593976, schemes: {Scheme.Https})
type
  Call_WorkspaceSettingsDelete_593964 = ref object of OpenApiRestCall_593408
proc url_WorkspaceSettingsDelete_593966(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "workspaceSettingName" in path,
        "`workspaceSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/workspaceSettings/"),
               (kind: VariableSegment, value: "workspaceSettingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspaceSettingsDelete_593965(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the custom workspace settings for this subscription. new VMs will report to the default workspace
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceSettingName: JString (required)
  ##                       : Name of the security setting
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593967 = path.getOrDefault("subscriptionId")
  valid_593967 = validateParameter(valid_593967, JString, required = true,
                                 default = nil)
  if valid_593967 != nil:
    section.add "subscriptionId", valid_593967
  var valid_593968 = path.getOrDefault("workspaceSettingName")
  valid_593968 = validateParameter(valid_593968, JString, required = true,
                                 default = nil)
  if valid_593968 != nil:
    section.add "workspaceSettingName", valid_593968
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593969 = query.getOrDefault("api-version")
  valid_593969 = validateParameter(valid_593969, JString, required = true,
                                 default = nil)
  if valid_593969 != nil:
    section.add "api-version", valid_593969
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593970: Call_WorkspaceSettingsDelete_593964; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the custom workspace settings for this subscription. new VMs will report to the default workspace
  ## 
  let valid = call_593970.validator(path, query, header, formData, body)
  let scheme = call_593970.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593970.url(scheme.get, call_593970.host, call_593970.base,
                         call_593970.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593970, url, valid)

proc call*(call_593971: Call_WorkspaceSettingsDelete_593964; apiVersion: string;
          subscriptionId: string; workspaceSettingName: string): Recallable =
  ## workspaceSettingsDelete
  ## Deletes the custom workspace settings for this subscription. new VMs will report to the default workspace
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceSettingName: string (required)
  ##                       : Name of the security setting
  var path_593972 = newJObject()
  var query_593973 = newJObject()
  add(query_593973, "api-version", newJString(apiVersion))
  add(path_593972, "subscriptionId", newJString(subscriptionId))
  add(path_593972, "workspaceSettingName", newJString(workspaceSettingName))
  result = call_593971.call(path_593972, query_593973, nil, nil, nil)

var workspaceSettingsDelete* = Call_WorkspaceSettingsDelete_593964(
    name: "workspaceSettingsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/workspaceSettings/{workspaceSettingName}",
    validator: validate_WorkspaceSettingsDelete_593965, base: "",
    url: url_WorkspaceSettingsDelete_593966, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
