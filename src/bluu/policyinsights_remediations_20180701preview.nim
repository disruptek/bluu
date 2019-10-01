
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: RemediationsClient
## version: 2018-07-01-preview
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

  OpenApiRestCall_567657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567657): Option[Scheme] {.used.} =
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
  macServiceName = "policyinsights-remediations"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_RemediationsListForManagementGroup_567879 = ref object of OpenApiRestCall_567657
proc url_RemediationsListForManagementGroup_567881(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupsNamespace" in path,
        "`managementGroupsNamespace` is a required path parameter"
  assert "managementGroupId" in path,
        "`managementGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "managementGroupsNamespace"),
               (kind: ConstantSegment, value: "/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/remediations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemediationsListForManagementGroup_567880(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all remediations for the management group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupsNamespace: JString (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  ##   managementGroupId: JString (required)
  ##                    : Management group ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `managementGroupsNamespace` field"
  var valid_568068 = path.getOrDefault("managementGroupsNamespace")
  valid_568068 = validateParameter(valid_568068, JString, required = true,
                                 default = newJString("Microsoft.Management"))
  if valid_568068 != nil:
    section.add "managementGroupsNamespace", valid_568068
  var valid_568069 = path.getOrDefault("managementGroupId")
  valid_568069 = validateParameter(valid_568069, JString, required = true,
                                 default = nil)
  if valid_568069 != nil:
    section.add "managementGroupId", valid_568069
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568070 = query.getOrDefault("api-version")
  valid_568070 = validateParameter(valid_568070, JString, required = true,
                                 default = nil)
  if valid_568070 != nil:
    section.add "api-version", valid_568070
  var valid_568071 = query.getOrDefault("$top")
  valid_568071 = validateParameter(valid_568071, JInt, required = false, default = nil)
  if valid_568071 != nil:
    section.add "$top", valid_568071
  var valid_568072 = query.getOrDefault("$filter")
  valid_568072 = validateParameter(valid_568072, JString, required = false,
                                 default = nil)
  if valid_568072 != nil:
    section.add "$filter", valid_568072
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568095: Call_RemediationsListForManagementGroup_567879;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all remediations for the management group.
  ## 
  let valid = call_568095.validator(path, query, header, formData, body)
  let scheme = call_568095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568095.url(scheme.get, call_568095.host, call_568095.base,
                         call_568095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568095, url, valid)

proc call*(call_568166: Call_RemediationsListForManagementGroup_567879;
          apiVersion: string; managementGroupId: string;
          managementGroupsNamespace: string = "Microsoft.Management"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## remediationsListForManagementGroup
  ## Gets all remediations for the management group.
  ##   managementGroupsNamespace: string (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   managementGroupId: string (required)
  ##                    : Management group ID.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Filter: string
  ##         : OData filter expression.
  var path_568167 = newJObject()
  var query_568169 = newJObject()
  add(path_568167, "managementGroupsNamespace",
      newJString(managementGroupsNamespace))
  add(query_568169, "api-version", newJString(apiVersion))
  add(path_568167, "managementGroupId", newJString(managementGroupId))
  add(query_568169, "$top", newJInt(Top))
  add(query_568169, "$filter", newJString(Filter))
  result = call_568166.call(path_568167, query_568169, nil, nil, nil)

var remediationsListForManagementGroup* = Call_RemediationsListForManagementGroup_567879(
    name: "remediationsListForManagementGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/{managementGroupsNamespace}/managementGroups/{managementGroupId}/providers/Microsoft.PolicyInsights/remediations",
    validator: validate_RemediationsListForManagementGroup_567880, base: "",
    url: url_RemediationsListForManagementGroup_567881, schemes: {Scheme.Https})
type
  Call_RemediationsCreateOrUpdateAtManagementGroup_568219 = ref object of OpenApiRestCall_567657
proc url_RemediationsCreateOrUpdateAtManagementGroup_568221(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupsNamespace" in path,
        "`managementGroupsNamespace` is a required path parameter"
  assert "managementGroupId" in path,
        "`managementGroupId` is a required path parameter"
  assert "remediationName" in path, "`remediationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "managementGroupsNamespace"),
               (kind: ConstantSegment, value: "/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/remediations/"),
               (kind: VariableSegment, value: "remediationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemediationsCreateOrUpdateAtManagementGroup_568220(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a remediation at management group scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupsNamespace: JString (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  ##   managementGroupId: JString (required)
  ##                    : Management group ID.
  ##   remediationName: JString (required)
  ##                  : The name of the remediation.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `managementGroupsNamespace` field"
  var valid_568239 = path.getOrDefault("managementGroupsNamespace")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = newJString("Microsoft.Management"))
  if valid_568239 != nil:
    section.add "managementGroupsNamespace", valid_568239
  var valid_568240 = path.getOrDefault("managementGroupId")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "managementGroupId", valid_568240
  var valid_568241 = path.getOrDefault("remediationName")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "remediationName", valid_568241
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568242 = query.getOrDefault("api-version")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "api-version", valid_568242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The remediation parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568244: Call_RemediationsCreateOrUpdateAtManagementGroup_568219;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a remediation at management group scope.
  ## 
  let valid = call_568244.validator(path, query, header, formData, body)
  let scheme = call_568244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568244.url(scheme.get, call_568244.host, call_568244.base,
                         call_568244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568244, url, valid)

proc call*(call_568245: Call_RemediationsCreateOrUpdateAtManagementGroup_568219;
          apiVersion: string; managementGroupId: string; parameters: JsonNode;
          remediationName: string;
          managementGroupsNamespace: string = "Microsoft.Management"): Recallable =
  ## remediationsCreateOrUpdateAtManagementGroup
  ## Creates or updates a remediation at management group scope.
  ##   managementGroupsNamespace: string (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   managementGroupId: string (required)
  ##                    : Management group ID.
  ##   parameters: JObject (required)
  ##             : The remediation parameters.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_568246 = newJObject()
  var query_568247 = newJObject()
  var body_568248 = newJObject()
  add(path_568246, "managementGroupsNamespace",
      newJString(managementGroupsNamespace))
  add(query_568247, "api-version", newJString(apiVersion))
  add(path_568246, "managementGroupId", newJString(managementGroupId))
  if parameters != nil:
    body_568248 = parameters
  add(path_568246, "remediationName", newJString(remediationName))
  result = call_568245.call(path_568246, query_568247, nil, nil, body_568248)

var remediationsCreateOrUpdateAtManagementGroup* = Call_RemediationsCreateOrUpdateAtManagementGroup_568219(
    name: "remediationsCreateOrUpdateAtManagementGroup", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/{managementGroupsNamespace}/managementGroups/{managementGroupId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}",
    validator: validate_RemediationsCreateOrUpdateAtManagementGroup_568220,
    base: "", url: url_RemediationsCreateOrUpdateAtManagementGroup_568221,
    schemes: {Scheme.Https})
type
  Call_RemediationsGetAtManagementGroup_568208 = ref object of OpenApiRestCall_567657
proc url_RemediationsGetAtManagementGroup_568210(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupsNamespace" in path,
        "`managementGroupsNamespace` is a required path parameter"
  assert "managementGroupId" in path,
        "`managementGroupId` is a required path parameter"
  assert "remediationName" in path, "`remediationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "managementGroupsNamespace"),
               (kind: ConstantSegment, value: "/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/remediations/"),
               (kind: VariableSegment, value: "remediationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemediationsGetAtManagementGroup_568209(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an existing remediation at management group scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupsNamespace: JString (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  ##   managementGroupId: JString (required)
  ##                    : Management group ID.
  ##   remediationName: JString (required)
  ##                  : The name of the remediation.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `managementGroupsNamespace` field"
  var valid_568211 = path.getOrDefault("managementGroupsNamespace")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = newJString("Microsoft.Management"))
  if valid_568211 != nil:
    section.add "managementGroupsNamespace", valid_568211
  var valid_568212 = path.getOrDefault("managementGroupId")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "managementGroupId", valid_568212
  var valid_568213 = path.getOrDefault("remediationName")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "remediationName", valid_568213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568214 = query.getOrDefault("api-version")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "api-version", valid_568214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568215: Call_RemediationsGetAtManagementGroup_568208;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an existing remediation at management group scope.
  ## 
  let valid = call_568215.validator(path, query, header, formData, body)
  let scheme = call_568215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568215.url(scheme.get, call_568215.host, call_568215.base,
                         call_568215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568215, url, valid)

proc call*(call_568216: Call_RemediationsGetAtManagementGroup_568208;
          apiVersion: string; managementGroupId: string; remediationName: string;
          managementGroupsNamespace: string = "Microsoft.Management"): Recallable =
  ## remediationsGetAtManagementGroup
  ## Gets an existing remediation at management group scope.
  ##   managementGroupsNamespace: string (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   managementGroupId: string (required)
  ##                    : Management group ID.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_568217 = newJObject()
  var query_568218 = newJObject()
  add(path_568217, "managementGroupsNamespace",
      newJString(managementGroupsNamespace))
  add(query_568218, "api-version", newJString(apiVersion))
  add(path_568217, "managementGroupId", newJString(managementGroupId))
  add(path_568217, "remediationName", newJString(remediationName))
  result = call_568216.call(path_568217, query_568218, nil, nil, nil)

var remediationsGetAtManagementGroup* = Call_RemediationsGetAtManagementGroup_568208(
    name: "remediationsGetAtManagementGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/{managementGroupsNamespace}/managementGroups/{managementGroupId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}",
    validator: validate_RemediationsGetAtManagementGroup_568209, base: "",
    url: url_RemediationsGetAtManagementGroup_568210, schemes: {Scheme.Https})
type
  Call_RemediationsDeleteAtManagementGroup_568249 = ref object of OpenApiRestCall_567657
proc url_RemediationsDeleteAtManagementGroup_568251(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupsNamespace" in path,
        "`managementGroupsNamespace` is a required path parameter"
  assert "managementGroupId" in path,
        "`managementGroupId` is a required path parameter"
  assert "remediationName" in path, "`remediationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "managementGroupsNamespace"),
               (kind: ConstantSegment, value: "/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/remediations/"),
               (kind: VariableSegment, value: "remediationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemediationsDeleteAtManagementGroup_568250(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing remediation at management group scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupsNamespace: JString (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  ##   managementGroupId: JString (required)
  ##                    : Management group ID.
  ##   remediationName: JString (required)
  ##                  : The name of the remediation.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `managementGroupsNamespace` field"
  var valid_568252 = path.getOrDefault("managementGroupsNamespace")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = newJString("Microsoft.Management"))
  if valid_568252 != nil:
    section.add "managementGroupsNamespace", valid_568252
  var valid_568253 = path.getOrDefault("managementGroupId")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "managementGroupId", valid_568253
  var valid_568254 = path.getOrDefault("remediationName")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "remediationName", valid_568254
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568255 = query.getOrDefault("api-version")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "api-version", valid_568255
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568256: Call_RemediationsDeleteAtManagementGroup_568249;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing remediation at management group scope.
  ## 
  let valid = call_568256.validator(path, query, header, formData, body)
  let scheme = call_568256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568256.url(scheme.get, call_568256.host, call_568256.base,
                         call_568256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568256, url, valid)

proc call*(call_568257: Call_RemediationsDeleteAtManagementGroup_568249;
          apiVersion: string; managementGroupId: string; remediationName: string;
          managementGroupsNamespace: string = "Microsoft.Management"): Recallable =
  ## remediationsDeleteAtManagementGroup
  ## Deletes an existing remediation at management group scope.
  ##   managementGroupsNamespace: string (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   managementGroupId: string (required)
  ##                    : Management group ID.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_568258 = newJObject()
  var query_568259 = newJObject()
  add(path_568258, "managementGroupsNamespace",
      newJString(managementGroupsNamespace))
  add(query_568259, "api-version", newJString(apiVersion))
  add(path_568258, "managementGroupId", newJString(managementGroupId))
  add(path_568258, "remediationName", newJString(remediationName))
  result = call_568257.call(path_568258, query_568259, nil, nil, nil)

var remediationsDeleteAtManagementGroup* = Call_RemediationsDeleteAtManagementGroup_568249(
    name: "remediationsDeleteAtManagementGroup", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/{managementGroupsNamespace}/managementGroups/{managementGroupId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}",
    validator: validate_RemediationsDeleteAtManagementGroup_568250, base: "",
    url: url_RemediationsDeleteAtManagementGroup_568251, schemes: {Scheme.Https})
type
  Call_RemediationsCancelAtManagementGroup_568260 = ref object of OpenApiRestCall_567657
proc url_RemediationsCancelAtManagementGroup_568262(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupsNamespace" in path,
        "`managementGroupsNamespace` is a required path parameter"
  assert "managementGroupId" in path,
        "`managementGroupId` is a required path parameter"
  assert "remediationName" in path, "`remediationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "managementGroupsNamespace"),
               (kind: ConstantSegment, value: "/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/remediations/"),
               (kind: VariableSegment, value: "remediationName"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemediationsCancelAtManagementGroup_568261(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels a remediation at management group scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupsNamespace: JString (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  ##   managementGroupId: JString (required)
  ##                    : Management group ID.
  ##   remediationName: JString (required)
  ##                  : The name of the remediation.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `managementGroupsNamespace` field"
  var valid_568263 = path.getOrDefault("managementGroupsNamespace")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = newJString("Microsoft.Management"))
  if valid_568263 != nil:
    section.add "managementGroupsNamespace", valid_568263
  var valid_568264 = path.getOrDefault("managementGroupId")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "managementGroupId", valid_568264
  var valid_568265 = path.getOrDefault("remediationName")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "remediationName", valid_568265
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568266 = query.getOrDefault("api-version")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "api-version", valid_568266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568267: Call_RemediationsCancelAtManagementGroup_568260;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels a remediation at management group scope.
  ## 
  let valid = call_568267.validator(path, query, header, formData, body)
  let scheme = call_568267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568267.url(scheme.get, call_568267.host, call_568267.base,
                         call_568267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568267, url, valid)

proc call*(call_568268: Call_RemediationsCancelAtManagementGroup_568260;
          apiVersion: string; managementGroupId: string; remediationName: string;
          managementGroupsNamespace: string = "Microsoft.Management"): Recallable =
  ## remediationsCancelAtManagementGroup
  ## Cancels a remediation at management group scope.
  ##   managementGroupsNamespace: string (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   managementGroupId: string (required)
  ##                    : Management group ID.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_568269 = newJObject()
  var query_568270 = newJObject()
  add(path_568269, "managementGroupsNamespace",
      newJString(managementGroupsNamespace))
  add(query_568270, "api-version", newJString(apiVersion))
  add(path_568269, "managementGroupId", newJString(managementGroupId))
  add(path_568269, "remediationName", newJString(remediationName))
  result = call_568268.call(path_568269, query_568270, nil, nil, nil)

var remediationsCancelAtManagementGroup* = Call_RemediationsCancelAtManagementGroup_568260(
    name: "remediationsCancelAtManagementGroup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/{managementGroupsNamespace}/managementGroups/{managementGroupId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}/cancel",
    validator: validate_RemediationsCancelAtManagementGroup_568261, base: "",
    url: url_RemediationsCancelAtManagementGroup_568262, schemes: {Scheme.Https})
type
  Call_RemediationsListDeploymentsAtManagementGroup_568271 = ref object of OpenApiRestCall_567657
proc url_RemediationsListDeploymentsAtManagementGroup_568273(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupsNamespace" in path,
        "`managementGroupsNamespace` is a required path parameter"
  assert "managementGroupId" in path,
        "`managementGroupId` is a required path parameter"
  assert "remediationName" in path, "`remediationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "managementGroupsNamespace"),
               (kind: ConstantSegment, value: "/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/remediations/"),
               (kind: VariableSegment, value: "remediationName"),
               (kind: ConstantSegment, value: "/listDeployments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemediationsListDeploymentsAtManagementGroup_568272(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all deployments for a remediation at management group scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupsNamespace: JString (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  ##   managementGroupId: JString (required)
  ##                    : Management group ID.
  ##   remediationName: JString (required)
  ##                  : The name of the remediation.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `managementGroupsNamespace` field"
  var valid_568274 = path.getOrDefault("managementGroupsNamespace")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = newJString("Microsoft.Management"))
  if valid_568274 != nil:
    section.add "managementGroupsNamespace", valid_568274
  var valid_568275 = path.getOrDefault("managementGroupId")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "managementGroupId", valid_568275
  var valid_568276 = path.getOrDefault("remediationName")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "remediationName", valid_568276
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : Maximum number of records to return.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568277 = query.getOrDefault("api-version")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "api-version", valid_568277
  var valid_568278 = query.getOrDefault("$top")
  valid_568278 = validateParameter(valid_568278, JInt, required = false, default = nil)
  if valid_568278 != nil:
    section.add "$top", valid_568278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568279: Call_RemediationsListDeploymentsAtManagementGroup_568271;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all deployments for a remediation at management group scope.
  ## 
  let valid = call_568279.validator(path, query, header, formData, body)
  let scheme = call_568279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568279.url(scheme.get, call_568279.host, call_568279.base,
                         call_568279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568279, url, valid)

proc call*(call_568280: Call_RemediationsListDeploymentsAtManagementGroup_568271;
          apiVersion: string; managementGroupId: string; remediationName: string;
          managementGroupsNamespace: string = "Microsoft.Management"; Top: int = 0): Recallable =
  ## remediationsListDeploymentsAtManagementGroup
  ## Gets all deployments for a remediation at management group scope.
  ##   managementGroupsNamespace: string (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   managementGroupId: string (required)
  ##                    : Management group ID.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_568281 = newJObject()
  var query_568282 = newJObject()
  add(path_568281, "managementGroupsNamespace",
      newJString(managementGroupsNamespace))
  add(query_568282, "api-version", newJString(apiVersion))
  add(path_568281, "managementGroupId", newJString(managementGroupId))
  add(query_568282, "$top", newJInt(Top))
  add(path_568281, "remediationName", newJString(remediationName))
  result = call_568280.call(path_568281, query_568282, nil, nil, nil)

var remediationsListDeploymentsAtManagementGroup* = Call_RemediationsListDeploymentsAtManagementGroup_568271(
    name: "remediationsListDeploymentsAtManagementGroup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/{managementGroupsNamespace}/managementGroups/{managementGroupId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}/listDeployments",
    validator: validate_RemediationsListDeploymentsAtManagementGroup_568272,
    base: "", url: url_RemediationsListDeploymentsAtManagementGroup_568273,
    schemes: {Scheme.Https})
type
  Call_RemediationsListForSubscription_568283 = ref object of OpenApiRestCall_567657
proc url_RemediationsListForSubscription_568285(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.PolicyInsights/remediations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemediationsListForSubscription_568284(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all remediations for the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568286 = path.getOrDefault("subscriptionId")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "subscriptionId", valid_568286
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568287 = query.getOrDefault("api-version")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "api-version", valid_568287
  var valid_568288 = query.getOrDefault("$top")
  valid_568288 = validateParameter(valid_568288, JInt, required = false, default = nil)
  if valid_568288 != nil:
    section.add "$top", valid_568288
  var valid_568289 = query.getOrDefault("$filter")
  valid_568289 = validateParameter(valid_568289, JString, required = false,
                                 default = nil)
  if valid_568289 != nil:
    section.add "$filter", valid_568289
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568290: Call_RemediationsListForSubscription_568283;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all remediations for the subscription.
  ## 
  let valid = call_568290.validator(path, query, header, formData, body)
  let scheme = call_568290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568290.url(scheme.get, call_568290.host, call_568290.base,
                         call_568290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568290, url, valid)

proc call*(call_568291: Call_RemediationsListForSubscription_568283;
          apiVersion: string; subscriptionId: string; Top: int = 0; Filter: string = ""): Recallable =
  ## remediationsListForSubscription
  ## Gets all remediations for the subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Filter: string
  ##         : OData filter expression.
  var path_568292 = newJObject()
  var query_568293 = newJObject()
  add(query_568293, "api-version", newJString(apiVersion))
  add(path_568292, "subscriptionId", newJString(subscriptionId))
  add(query_568293, "$top", newJInt(Top))
  add(query_568293, "$filter", newJString(Filter))
  result = call_568291.call(path_568292, query_568293, nil, nil, nil)

var remediationsListForSubscription* = Call_RemediationsListForSubscription_568283(
    name: "remediationsListForSubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PolicyInsights/remediations",
    validator: validate_RemediationsListForSubscription_568284, base: "",
    url: url_RemediationsListForSubscription_568285, schemes: {Scheme.Https})
type
  Call_RemediationsCreateOrUpdateAtSubscription_568304 = ref object of OpenApiRestCall_567657
proc url_RemediationsCreateOrUpdateAtSubscription_568306(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "remediationName" in path, "`remediationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/remediations/"),
               (kind: VariableSegment, value: "remediationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemediationsCreateOrUpdateAtSubscription_568305(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a remediation at subscription scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   remediationName: JString (required)
  ##                  : The name of the remediation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568307 = path.getOrDefault("subscriptionId")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "subscriptionId", valid_568307
  var valid_568308 = path.getOrDefault("remediationName")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "remediationName", valid_568308
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The remediation parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568311: Call_RemediationsCreateOrUpdateAtSubscription_568304;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a remediation at subscription scope.
  ## 
  let valid = call_568311.validator(path, query, header, formData, body)
  let scheme = call_568311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568311.url(scheme.get, call_568311.host, call_568311.base,
                         call_568311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568311, url, valid)

proc call*(call_568312: Call_RemediationsCreateOrUpdateAtSubscription_568304;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          remediationName: string): Recallable =
  ## remediationsCreateOrUpdateAtSubscription
  ## Creates or updates a remediation at subscription scope.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   parameters: JObject (required)
  ##             : The remediation parameters.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_568313 = newJObject()
  var query_568314 = newJObject()
  var body_568315 = newJObject()
  add(query_568314, "api-version", newJString(apiVersion))
  add(path_568313, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568315 = parameters
  add(path_568313, "remediationName", newJString(remediationName))
  result = call_568312.call(path_568313, query_568314, nil, nil, body_568315)

var remediationsCreateOrUpdateAtSubscription* = Call_RemediationsCreateOrUpdateAtSubscription_568304(
    name: "remediationsCreateOrUpdateAtSubscription", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}",
    validator: validate_RemediationsCreateOrUpdateAtSubscription_568305, base: "",
    url: url_RemediationsCreateOrUpdateAtSubscription_568306,
    schemes: {Scheme.Https})
type
  Call_RemediationsGetAtSubscription_568294 = ref object of OpenApiRestCall_567657
proc url_RemediationsGetAtSubscription_568296(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "remediationName" in path, "`remediationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/remediations/"),
               (kind: VariableSegment, value: "remediationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemediationsGetAtSubscription_568295(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an existing remediation at subscription scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   remediationName: JString (required)
  ##                  : The name of the remediation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568297 = path.getOrDefault("subscriptionId")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "subscriptionId", valid_568297
  var valid_568298 = path.getOrDefault("remediationName")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "remediationName", valid_568298
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568299 = query.getOrDefault("api-version")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "api-version", valid_568299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568300: Call_RemediationsGetAtSubscription_568294; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an existing remediation at subscription scope.
  ## 
  let valid = call_568300.validator(path, query, header, formData, body)
  let scheme = call_568300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568300.url(scheme.get, call_568300.host, call_568300.base,
                         call_568300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568300, url, valid)

proc call*(call_568301: Call_RemediationsGetAtSubscription_568294;
          apiVersion: string; subscriptionId: string; remediationName: string): Recallable =
  ## remediationsGetAtSubscription
  ## Gets an existing remediation at subscription scope.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_568302 = newJObject()
  var query_568303 = newJObject()
  add(query_568303, "api-version", newJString(apiVersion))
  add(path_568302, "subscriptionId", newJString(subscriptionId))
  add(path_568302, "remediationName", newJString(remediationName))
  result = call_568301.call(path_568302, query_568303, nil, nil, nil)

var remediationsGetAtSubscription* = Call_RemediationsGetAtSubscription_568294(
    name: "remediationsGetAtSubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}",
    validator: validate_RemediationsGetAtSubscription_568295, base: "",
    url: url_RemediationsGetAtSubscription_568296, schemes: {Scheme.Https})
type
  Call_RemediationsDeleteAtSubscription_568316 = ref object of OpenApiRestCall_567657
proc url_RemediationsDeleteAtSubscription_568318(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "remediationName" in path, "`remediationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/remediations/"),
               (kind: VariableSegment, value: "remediationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemediationsDeleteAtSubscription_568317(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing remediation at subscription scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   remediationName: JString (required)
  ##                  : The name of the remediation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568319 = path.getOrDefault("subscriptionId")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "subscriptionId", valid_568319
  var valid_568320 = path.getOrDefault("remediationName")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "remediationName", valid_568320
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

proc call*(call_568322: Call_RemediationsDeleteAtSubscription_568316;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing remediation at subscription scope.
  ## 
  let valid = call_568322.validator(path, query, header, formData, body)
  let scheme = call_568322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568322.url(scheme.get, call_568322.host, call_568322.base,
                         call_568322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568322, url, valid)

proc call*(call_568323: Call_RemediationsDeleteAtSubscription_568316;
          apiVersion: string; subscriptionId: string; remediationName: string): Recallable =
  ## remediationsDeleteAtSubscription
  ## Deletes an existing remediation at subscription scope.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_568324 = newJObject()
  var query_568325 = newJObject()
  add(query_568325, "api-version", newJString(apiVersion))
  add(path_568324, "subscriptionId", newJString(subscriptionId))
  add(path_568324, "remediationName", newJString(remediationName))
  result = call_568323.call(path_568324, query_568325, nil, nil, nil)

var remediationsDeleteAtSubscription* = Call_RemediationsDeleteAtSubscription_568316(
    name: "remediationsDeleteAtSubscription", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}",
    validator: validate_RemediationsDeleteAtSubscription_568317, base: "",
    url: url_RemediationsDeleteAtSubscription_568318, schemes: {Scheme.Https})
type
  Call_RemediationsCancelAtSubscription_568326 = ref object of OpenApiRestCall_567657
proc url_RemediationsCancelAtSubscription_568328(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "remediationName" in path, "`remediationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/remediations/"),
               (kind: VariableSegment, value: "remediationName"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemediationsCancelAtSubscription_568327(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels a remediation at subscription scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   remediationName: JString (required)
  ##                  : The name of the remediation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568329 = path.getOrDefault("subscriptionId")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "subscriptionId", valid_568329
  var valid_568330 = path.getOrDefault("remediationName")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "remediationName", valid_568330
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

proc call*(call_568332: Call_RemediationsCancelAtSubscription_568326;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels a remediation at subscription scope.
  ## 
  let valid = call_568332.validator(path, query, header, formData, body)
  let scheme = call_568332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568332.url(scheme.get, call_568332.host, call_568332.base,
                         call_568332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568332, url, valid)

proc call*(call_568333: Call_RemediationsCancelAtSubscription_568326;
          apiVersion: string; subscriptionId: string; remediationName: string): Recallable =
  ## remediationsCancelAtSubscription
  ## Cancels a remediation at subscription scope.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_568334 = newJObject()
  var query_568335 = newJObject()
  add(query_568335, "api-version", newJString(apiVersion))
  add(path_568334, "subscriptionId", newJString(subscriptionId))
  add(path_568334, "remediationName", newJString(remediationName))
  result = call_568333.call(path_568334, query_568335, nil, nil, nil)

var remediationsCancelAtSubscription* = Call_RemediationsCancelAtSubscription_568326(
    name: "remediationsCancelAtSubscription", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}/cancel",
    validator: validate_RemediationsCancelAtSubscription_568327, base: "",
    url: url_RemediationsCancelAtSubscription_568328, schemes: {Scheme.Https})
type
  Call_RemediationsListDeploymentsAtSubscription_568336 = ref object of OpenApiRestCall_567657
proc url_RemediationsListDeploymentsAtSubscription_568338(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "remediationName" in path, "`remediationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/remediations/"),
               (kind: VariableSegment, value: "remediationName"),
               (kind: ConstantSegment, value: "/listDeployments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemediationsListDeploymentsAtSubscription_568337(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all deployments for a remediation at subscription scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   remediationName: JString (required)
  ##                  : The name of the remediation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568339 = path.getOrDefault("subscriptionId")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "subscriptionId", valid_568339
  var valid_568340 = path.getOrDefault("remediationName")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = nil)
  if valid_568340 != nil:
    section.add "remediationName", valid_568340
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : Maximum number of records to return.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568341 = query.getOrDefault("api-version")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "api-version", valid_568341
  var valid_568342 = query.getOrDefault("$top")
  valid_568342 = validateParameter(valid_568342, JInt, required = false, default = nil)
  if valid_568342 != nil:
    section.add "$top", valid_568342
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568343: Call_RemediationsListDeploymentsAtSubscription_568336;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all deployments for a remediation at subscription scope.
  ## 
  let valid = call_568343.validator(path, query, header, formData, body)
  let scheme = call_568343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568343.url(scheme.get, call_568343.host, call_568343.base,
                         call_568343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568343, url, valid)

proc call*(call_568344: Call_RemediationsListDeploymentsAtSubscription_568336;
          apiVersion: string; subscriptionId: string; remediationName: string;
          Top: int = 0): Recallable =
  ## remediationsListDeploymentsAtSubscription
  ## Gets all deployments for a remediation at subscription scope.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_568345 = newJObject()
  var query_568346 = newJObject()
  add(query_568346, "api-version", newJString(apiVersion))
  add(path_568345, "subscriptionId", newJString(subscriptionId))
  add(query_568346, "$top", newJInt(Top))
  add(path_568345, "remediationName", newJString(remediationName))
  result = call_568344.call(path_568345, query_568346, nil, nil, nil)

var remediationsListDeploymentsAtSubscription* = Call_RemediationsListDeploymentsAtSubscription_568336(
    name: "remediationsListDeploymentsAtSubscription", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}/listDeployments",
    validator: validate_RemediationsListDeploymentsAtSubscription_568337,
    base: "", url: url_RemediationsListDeploymentsAtSubscription_568338,
    schemes: {Scheme.Https})
type
  Call_RemediationsListForResourceGroup_568347 = ref object of OpenApiRestCall_567657
proc url_RemediationsListForResourceGroup_568349(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/remediations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemediationsListForResourceGroup_568348(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all remediations for the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568350 = path.getOrDefault("resourceGroupName")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "resourceGroupName", valid_568350
  var valid_568351 = path.getOrDefault("subscriptionId")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "subscriptionId", valid_568351
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568352 = query.getOrDefault("api-version")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = nil)
  if valid_568352 != nil:
    section.add "api-version", valid_568352
  var valid_568353 = query.getOrDefault("$top")
  valid_568353 = validateParameter(valid_568353, JInt, required = false, default = nil)
  if valid_568353 != nil:
    section.add "$top", valid_568353
  var valid_568354 = query.getOrDefault("$filter")
  valid_568354 = validateParameter(valid_568354, JString, required = false,
                                 default = nil)
  if valid_568354 != nil:
    section.add "$filter", valid_568354
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568355: Call_RemediationsListForResourceGroup_568347;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all remediations for the subscription.
  ## 
  let valid = call_568355.validator(path, query, header, formData, body)
  let scheme = call_568355.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568355.url(scheme.get, call_568355.host, call_568355.base,
                         call_568355.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568355, url, valid)

proc call*(call_568356: Call_RemediationsListForResourceGroup_568347;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Top: int = 0; Filter: string = ""): Recallable =
  ## remediationsListForResourceGroup
  ## Gets all remediations for the subscription.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Filter: string
  ##         : OData filter expression.
  var path_568357 = newJObject()
  var query_568358 = newJObject()
  add(path_568357, "resourceGroupName", newJString(resourceGroupName))
  add(query_568358, "api-version", newJString(apiVersion))
  add(path_568357, "subscriptionId", newJString(subscriptionId))
  add(query_568358, "$top", newJInt(Top))
  add(query_568358, "$filter", newJString(Filter))
  result = call_568356.call(path_568357, query_568358, nil, nil, nil)

var remediationsListForResourceGroup* = Call_RemediationsListForResourceGroup_568347(
    name: "remediationsListForResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PolicyInsights/remediations",
    validator: validate_RemediationsListForResourceGroup_568348, base: "",
    url: url_RemediationsListForResourceGroup_568349, schemes: {Scheme.Https})
type
  Call_RemediationsCreateOrUpdateAtResourceGroup_568370 = ref object of OpenApiRestCall_567657
proc url_RemediationsCreateOrUpdateAtResourceGroup_568372(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "remediationName" in path, "`remediationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/remediations/"),
               (kind: VariableSegment, value: "remediationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemediationsCreateOrUpdateAtResourceGroup_568371(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a remediation at resource group scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   remediationName: JString (required)
  ##                  : The name of the remediation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568373 = path.getOrDefault("resourceGroupName")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "resourceGroupName", valid_568373
  var valid_568374 = path.getOrDefault("subscriptionId")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "subscriptionId", valid_568374
  var valid_568375 = path.getOrDefault("remediationName")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "remediationName", valid_568375
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568376 = query.getOrDefault("api-version")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "api-version", valid_568376
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The remediation parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568378: Call_RemediationsCreateOrUpdateAtResourceGroup_568370;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a remediation at resource group scope.
  ## 
  let valid = call_568378.validator(path, query, header, formData, body)
  let scheme = call_568378.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568378.url(scheme.get, call_568378.host, call_568378.base,
                         call_568378.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568378, url, valid)

proc call*(call_568379: Call_RemediationsCreateOrUpdateAtResourceGroup_568370;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; remediationName: string): Recallable =
  ## remediationsCreateOrUpdateAtResourceGroup
  ## Creates or updates a remediation at resource group scope.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   parameters: JObject (required)
  ##             : The remediation parameters.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_568380 = newJObject()
  var query_568381 = newJObject()
  var body_568382 = newJObject()
  add(path_568380, "resourceGroupName", newJString(resourceGroupName))
  add(query_568381, "api-version", newJString(apiVersion))
  add(path_568380, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568382 = parameters
  add(path_568380, "remediationName", newJString(remediationName))
  result = call_568379.call(path_568380, query_568381, nil, nil, body_568382)

var remediationsCreateOrUpdateAtResourceGroup* = Call_RemediationsCreateOrUpdateAtResourceGroup_568370(
    name: "remediationsCreateOrUpdateAtResourceGroup", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PolicyInsights/remediations/{remediationName}",
    validator: validate_RemediationsCreateOrUpdateAtResourceGroup_568371,
    base: "", url: url_RemediationsCreateOrUpdateAtResourceGroup_568372,
    schemes: {Scheme.Https})
type
  Call_RemediationsGetAtResourceGroup_568359 = ref object of OpenApiRestCall_567657
proc url_RemediationsGetAtResourceGroup_568361(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "remediationName" in path, "`remediationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/remediations/"),
               (kind: VariableSegment, value: "remediationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemediationsGetAtResourceGroup_568360(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an existing remediation at resource group scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   remediationName: JString (required)
  ##                  : The name of the remediation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568362 = path.getOrDefault("resourceGroupName")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = nil)
  if valid_568362 != nil:
    section.add "resourceGroupName", valid_568362
  var valid_568363 = path.getOrDefault("subscriptionId")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = nil)
  if valid_568363 != nil:
    section.add "subscriptionId", valid_568363
  var valid_568364 = path.getOrDefault("remediationName")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "remediationName", valid_568364
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568365 = query.getOrDefault("api-version")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "api-version", valid_568365
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568366: Call_RemediationsGetAtResourceGroup_568359; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an existing remediation at resource group scope.
  ## 
  let valid = call_568366.validator(path, query, header, formData, body)
  let scheme = call_568366.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568366.url(scheme.get, call_568366.host, call_568366.base,
                         call_568366.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568366, url, valid)

proc call*(call_568367: Call_RemediationsGetAtResourceGroup_568359;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          remediationName: string): Recallable =
  ## remediationsGetAtResourceGroup
  ## Gets an existing remediation at resource group scope.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_568368 = newJObject()
  var query_568369 = newJObject()
  add(path_568368, "resourceGroupName", newJString(resourceGroupName))
  add(query_568369, "api-version", newJString(apiVersion))
  add(path_568368, "subscriptionId", newJString(subscriptionId))
  add(path_568368, "remediationName", newJString(remediationName))
  result = call_568367.call(path_568368, query_568369, nil, nil, nil)

var remediationsGetAtResourceGroup* = Call_RemediationsGetAtResourceGroup_568359(
    name: "remediationsGetAtResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PolicyInsights/remediations/{remediationName}",
    validator: validate_RemediationsGetAtResourceGroup_568360, base: "",
    url: url_RemediationsGetAtResourceGroup_568361, schemes: {Scheme.Https})
type
  Call_RemediationsDeleteAtResourceGroup_568383 = ref object of OpenApiRestCall_567657
proc url_RemediationsDeleteAtResourceGroup_568385(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "remediationName" in path, "`remediationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/remediations/"),
               (kind: VariableSegment, value: "remediationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemediationsDeleteAtResourceGroup_568384(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing remediation at resource group scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   remediationName: JString (required)
  ##                  : The name of the remediation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568386 = path.getOrDefault("resourceGroupName")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "resourceGroupName", valid_568386
  var valid_568387 = path.getOrDefault("subscriptionId")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "subscriptionId", valid_568387
  var valid_568388 = path.getOrDefault("remediationName")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "remediationName", valid_568388
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568389 = query.getOrDefault("api-version")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "api-version", valid_568389
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568390: Call_RemediationsDeleteAtResourceGroup_568383;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing remediation at resource group scope.
  ## 
  let valid = call_568390.validator(path, query, header, formData, body)
  let scheme = call_568390.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568390.url(scheme.get, call_568390.host, call_568390.base,
                         call_568390.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568390, url, valid)

proc call*(call_568391: Call_RemediationsDeleteAtResourceGroup_568383;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          remediationName: string): Recallable =
  ## remediationsDeleteAtResourceGroup
  ## Deletes an existing remediation at resource group scope.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_568392 = newJObject()
  var query_568393 = newJObject()
  add(path_568392, "resourceGroupName", newJString(resourceGroupName))
  add(query_568393, "api-version", newJString(apiVersion))
  add(path_568392, "subscriptionId", newJString(subscriptionId))
  add(path_568392, "remediationName", newJString(remediationName))
  result = call_568391.call(path_568392, query_568393, nil, nil, nil)

var remediationsDeleteAtResourceGroup* = Call_RemediationsDeleteAtResourceGroup_568383(
    name: "remediationsDeleteAtResourceGroup", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PolicyInsights/remediations/{remediationName}",
    validator: validate_RemediationsDeleteAtResourceGroup_568384, base: "",
    url: url_RemediationsDeleteAtResourceGroup_568385, schemes: {Scheme.Https})
type
  Call_RemediationsCancelAtResourceGroup_568394 = ref object of OpenApiRestCall_567657
proc url_RemediationsCancelAtResourceGroup_568396(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "remediationName" in path, "`remediationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/remediations/"),
               (kind: VariableSegment, value: "remediationName"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemediationsCancelAtResourceGroup_568395(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels a remediation at resource group scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   remediationName: JString (required)
  ##                  : The name of the remediation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568397 = path.getOrDefault("resourceGroupName")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = nil)
  if valid_568397 != nil:
    section.add "resourceGroupName", valid_568397
  var valid_568398 = path.getOrDefault("subscriptionId")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = nil)
  if valid_568398 != nil:
    section.add "subscriptionId", valid_568398
  var valid_568399 = path.getOrDefault("remediationName")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "remediationName", valid_568399
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568400 = query.getOrDefault("api-version")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "api-version", valid_568400
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568401: Call_RemediationsCancelAtResourceGroup_568394;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels a remediation at resource group scope.
  ## 
  let valid = call_568401.validator(path, query, header, formData, body)
  let scheme = call_568401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568401.url(scheme.get, call_568401.host, call_568401.base,
                         call_568401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568401, url, valid)

proc call*(call_568402: Call_RemediationsCancelAtResourceGroup_568394;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          remediationName: string): Recallable =
  ## remediationsCancelAtResourceGroup
  ## Cancels a remediation at resource group scope.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_568403 = newJObject()
  var query_568404 = newJObject()
  add(path_568403, "resourceGroupName", newJString(resourceGroupName))
  add(query_568404, "api-version", newJString(apiVersion))
  add(path_568403, "subscriptionId", newJString(subscriptionId))
  add(path_568403, "remediationName", newJString(remediationName))
  result = call_568402.call(path_568403, query_568404, nil, nil, nil)

var remediationsCancelAtResourceGroup* = Call_RemediationsCancelAtResourceGroup_568394(
    name: "remediationsCancelAtResourceGroup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PolicyInsights/remediations/{remediationName}/cancel",
    validator: validate_RemediationsCancelAtResourceGroup_568395, base: "",
    url: url_RemediationsCancelAtResourceGroup_568396, schemes: {Scheme.Https})
type
  Call_RemediationsListDeploymentsAtResourceGroup_568405 = ref object of OpenApiRestCall_567657
proc url_RemediationsListDeploymentsAtResourceGroup_568407(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "remediationName" in path, "`remediationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/remediations/"),
               (kind: VariableSegment, value: "remediationName"),
               (kind: ConstantSegment, value: "/listDeployments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemediationsListDeploymentsAtResourceGroup_568406(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all deployments for a remediation at resource group scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   remediationName: JString (required)
  ##                  : The name of the remediation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568408 = path.getOrDefault("resourceGroupName")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = nil)
  if valid_568408 != nil:
    section.add "resourceGroupName", valid_568408
  var valid_568409 = path.getOrDefault("subscriptionId")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = nil)
  if valid_568409 != nil:
    section.add "subscriptionId", valid_568409
  var valid_568410 = path.getOrDefault("remediationName")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = nil)
  if valid_568410 != nil:
    section.add "remediationName", valid_568410
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : Maximum number of records to return.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568411 = query.getOrDefault("api-version")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "api-version", valid_568411
  var valid_568412 = query.getOrDefault("$top")
  valid_568412 = validateParameter(valid_568412, JInt, required = false, default = nil)
  if valid_568412 != nil:
    section.add "$top", valid_568412
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568413: Call_RemediationsListDeploymentsAtResourceGroup_568405;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all deployments for a remediation at resource group scope.
  ## 
  let valid = call_568413.validator(path, query, header, formData, body)
  let scheme = call_568413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568413.url(scheme.get, call_568413.host, call_568413.base,
                         call_568413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568413, url, valid)

proc call*(call_568414: Call_RemediationsListDeploymentsAtResourceGroup_568405;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          remediationName: string; Top: int = 0): Recallable =
  ## remediationsListDeploymentsAtResourceGroup
  ## Gets all deployments for a remediation at resource group scope.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_568415 = newJObject()
  var query_568416 = newJObject()
  add(path_568415, "resourceGroupName", newJString(resourceGroupName))
  add(query_568416, "api-version", newJString(apiVersion))
  add(path_568415, "subscriptionId", newJString(subscriptionId))
  add(query_568416, "$top", newJInt(Top))
  add(path_568415, "remediationName", newJString(remediationName))
  result = call_568414.call(path_568415, query_568416, nil, nil, nil)

var remediationsListDeploymentsAtResourceGroup* = Call_RemediationsListDeploymentsAtResourceGroup_568405(
    name: "remediationsListDeploymentsAtResourceGroup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PolicyInsights/remediations/{remediationName}/listDeployments",
    validator: validate_RemediationsListDeploymentsAtResourceGroup_568406,
    base: "", url: url_RemediationsListDeploymentsAtResourceGroup_568407,
    schemes: {Scheme.Https})
type
  Call_RemediationsListForResource_568417 = ref object of OpenApiRestCall_567657
proc url_RemediationsListForResource_568419(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/remediations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemediationsListForResource_568418(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all remediations for a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  ##             : Resource ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_568420 = path.getOrDefault("resourceId")
  valid_568420 = validateParameter(valid_568420, JString, required = true,
                                 default = nil)
  if valid_568420 != nil:
    section.add "resourceId", valid_568420
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568421 = query.getOrDefault("api-version")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = nil)
  if valid_568421 != nil:
    section.add "api-version", valid_568421
  var valid_568422 = query.getOrDefault("$top")
  valid_568422 = validateParameter(valid_568422, JInt, required = false, default = nil)
  if valid_568422 != nil:
    section.add "$top", valid_568422
  var valid_568423 = query.getOrDefault("$filter")
  valid_568423 = validateParameter(valid_568423, JString, required = false,
                                 default = nil)
  if valid_568423 != nil:
    section.add "$filter", valid_568423
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568424: Call_RemediationsListForResource_568417; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all remediations for a resource.
  ## 
  let valid = call_568424.validator(path, query, header, formData, body)
  let scheme = call_568424.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568424.url(scheme.get, call_568424.host, call_568424.base,
                         call_568424.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568424, url, valid)

proc call*(call_568425: Call_RemediationsListForResource_568417;
          apiVersion: string; resourceId: string; Top: int = 0; Filter: string = ""): Recallable =
  ## remediationsListForResource
  ## Gets all remediations for a resource.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   resourceId: string (required)
  ##             : Resource ID.
  ##   Filter: string
  ##         : OData filter expression.
  var path_568426 = newJObject()
  var query_568427 = newJObject()
  add(query_568427, "api-version", newJString(apiVersion))
  add(query_568427, "$top", newJInt(Top))
  add(path_568426, "resourceId", newJString(resourceId))
  add(query_568427, "$filter", newJString(Filter))
  result = call_568425.call(path_568426, query_568427, nil, nil, nil)

var remediationsListForResource* = Call_RemediationsListForResource_568417(
    name: "remediationsListForResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{resourceId}/providers/Microsoft.PolicyInsights/remediations",
    validator: validate_RemediationsListForResource_568418, base: "",
    url: url_RemediationsListForResource_568419, schemes: {Scheme.Https})
type
  Call_RemediationsCreateOrUpdateAtResource_568438 = ref object of OpenApiRestCall_567657
proc url_RemediationsCreateOrUpdateAtResource_568440(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  assert "remediationName" in path, "`remediationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/remediations/"),
               (kind: VariableSegment, value: "remediationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemediationsCreateOrUpdateAtResource_568439(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a remediation at resource scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  ##             : Resource ID.
  ##   remediationName: JString (required)
  ##                  : The name of the remediation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_568441 = path.getOrDefault("resourceId")
  valid_568441 = validateParameter(valid_568441, JString, required = true,
                                 default = nil)
  if valid_568441 != nil:
    section.add "resourceId", valid_568441
  var valid_568442 = path.getOrDefault("remediationName")
  valid_568442 = validateParameter(valid_568442, JString, required = true,
                                 default = nil)
  if valid_568442 != nil:
    section.add "remediationName", valid_568442
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568443 = query.getOrDefault("api-version")
  valid_568443 = validateParameter(valid_568443, JString, required = true,
                                 default = nil)
  if valid_568443 != nil:
    section.add "api-version", valid_568443
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The remediation parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568445: Call_RemediationsCreateOrUpdateAtResource_568438;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a remediation at resource scope.
  ## 
  let valid = call_568445.validator(path, query, header, formData, body)
  let scheme = call_568445.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568445.url(scheme.get, call_568445.host, call_568445.base,
                         call_568445.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568445, url, valid)

proc call*(call_568446: Call_RemediationsCreateOrUpdateAtResource_568438;
          apiVersion: string; resourceId: string; parameters: JsonNode;
          remediationName: string): Recallable =
  ## remediationsCreateOrUpdateAtResource
  ## Creates or updates a remediation at resource scope.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   resourceId: string (required)
  ##             : Resource ID.
  ##   parameters: JObject (required)
  ##             : The remediation parameters.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_568447 = newJObject()
  var query_568448 = newJObject()
  var body_568449 = newJObject()
  add(query_568448, "api-version", newJString(apiVersion))
  add(path_568447, "resourceId", newJString(resourceId))
  if parameters != nil:
    body_568449 = parameters
  add(path_568447, "remediationName", newJString(remediationName))
  result = call_568446.call(path_568447, query_568448, nil, nil, body_568449)

var remediationsCreateOrUpdateAtResource* = Call_RemediationsCreateOrUpdateAtResource_568438(
    name: "remediationsCreateOrUpdateAtResource", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}",
    validator: validate_RemediationsCreateOrUpdateAtResource_568439, base: "",
    url: url_RemediationsCreateOrUpdateAtResource_568440, schemes: {Scheme.Https})
type
  Call_RemediationsGetAtResource_568428 = ref object of OpenApiRestCall_567657
proc url_RemediationsGetAtResource_568430(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  assert "remediationName" in path, "`remediationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/remediations/"),
               (kind: VariableSegment, value: "remediationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemediationsGetAtResource_568429(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an existing remediation at resource scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  ##             : Resource ID.
  ##   remediationName: JString (required)
  ##                  : The name of the remediation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_568431 = path.getOrDefault("resourceId")
  valid_568431 = validateParameter(valid_568431, JString, required = true,
                                 default = nil)
  if valid_568431 != nil:
    section.add "resourceId", valid_568431
  var valid_568432 = path.getOrDefault("remediationName")
  valid_568432 = validateParameter(valid_568432, JString, required = true,
                                 default = nil)
  if valid_568432 != nil:
    section.add "remediationName", valid_568432
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568433 = query.getOrDefault("api-version")
  valid_568433 = validateParameter(valid_568433, JString, required = true,
                                 default = nil)
  if valid_568433 != nil:
    section.add "api-version", valid_568433
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568434: Call_RemediationsGetAtResource_568428; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an existing remediation at resource scope.
  ## 
  let valid = call_568434.validator(path, query, header, formData, body)
  let scheme = call_568434.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568434.url(scheme.get, call_568434.host, call_568434.base,
                         call_568434.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568434, url, valid)

proc call*(call_568435: Call_RemediationsGetAtResource_568428; apiVersion: string;
          resourceId: string; remediationName: string): Recallable =
  ## remediationsGetAtResource
  ## Gets an existing remediation at resource scope.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   resourceId: string (required)
  ##             : Resource ID.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_568436 = newJObject()
  var query_568437 = newJObject()
  add(query_568437, "api-version", newJString(apiVersion))
  add(path_568436, "resourceId", newJString(resourceId))
  add(path_568436, "remediationName", newJString(remediationName))
  result = call_568435.call(path_568436, query_568437, nil, nil, nil)

var remediationsGetAtResource* = Call_RemediationsGetAtResource_568428(
    name: "remediationsGetAtResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}",
    validator: validate_RemediationsGetAtResource_568429, base: "",
    url: url_RemediationsGetAtResource_568430, schemes: {Scheme.Https})
type
  Call_RemediationsDeleteAtResource_568450 = ref object of OpenApiRestCall_567657
proc url_RemediationsDeleteAtResource_568452(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  assert "remediationName" in path, "`remediationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/remediations/"),
               (kind: VariableSegment, value: "remediationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemediationsDeleteAtResource_568451(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing remediation at individual resource scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  ##             : Resource ID.
  ##   remediationName: JString (required)
  ##                  : The name of the remediation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_568453 = path.getOrDefault("resourceId")
  valid_568453 = validateParameter(valid_568453, JString, required = true,
                                 default = nil)
  if valid_568453 != nil:
    section.add "resourceId", valid_568453
  var valid_568454 = path.getOrDefault("remediationName")
  valid_568454 = validateParameter(valid_568454, JString, required = true,
                                 default = nil)
  if valid_568454 != nil:
    section.add "remediationName", valid_568454
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568455 = query.getOrDefault("api-version")
  valid_568455 = validateParameter(valid_568455, JString, required = true,
                                 default = nil)
  if valid_568455 != nil:
    section.add "api-version", valid_568455
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568456: Call_RemediationsDeleteAtResource_568450; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing remediation at individual resource scope.
  ## 
  let valid = call_568456.validator(path, query, header, formData, body)
  let scheme = call_568456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568456.url(scheme.get, call_568456.host, call_568456.base,
                         call_568456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568456, url, valid)

proc call*(call_568457: Call_RemediationsDeleteAtResource_568450;
          apiVersion: string; resourceId: string; remediationName: string): Recallable =
  ## remediationsDeleteAtResource
  ## Deletes an existing remediation at individual resource scope.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   resourceId: string (required)
  ##             : Resource ID.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_568458 = newJObject()
  var query_568459 = newJObject()
  add(query_568459, "api-version", newJString(apiVersion))
  add(path_568458, "resourceId", newJString(resourceId))
  add(path_568458, "remediationName", newJString(remediationName))
  result = call_568457.call(path_568458, query_568459, nil, nil, nil)

var remediationsDeleteAtResource* = Call_RemediationsDeleteAtResource_568450(
    name: "remediationsDeleteAtResource", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}",
    validator: validate_RemediationsDeleteAtResource_568451, base: "",
    url: url_RemediationsDeleteAtResource_568452, schemes: {Scheme.Https})
type
  Call_RemediationsCancelAtResource_568460 = ref object of OpenApiRestCall_567657
proc url_RemediationsCancelAtResource_568462(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  assert "remediationName" in path, "`remediationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/remediations/"),
               (kind: VariableSegment, value: "remediationName"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemediationsCancelAtResource_568461(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancel a remediation at resource scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  ##             : Resource ID.
  ##   remediationName: JString (required)
  ##                  : The name of the remediation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_568463 = path.getOrDefault("resourceId")
  valid_568463 = validateParameter(valid_568463, JString, required = true,
                                 default = nil)
  if valid_568463 != nil:
    section.add "resourceId", valid_568463
  var valid_568464 = path.getOrDefault("remediationName")
  valid_568464 = validateParameter(valid_568464, JString, required = true,
                                 default = nil)
  if valid_568464 != nil:
    section.add "remediationName", valid_568464
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568465 = query.getOrDefault("api-version")
  valid_568465 = validateParameter(valid_568465, JString, required = true,
                                 default = nil)
  if valid_568465 != nil:
    section.add "api-version", valid_568465
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568466: Call_RemediationsCancelAtResource_568460; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancel a remediation at resource scope.
  ## 
  let valid = call_568466.validator(path, query, header, formData, body)
  let scheme = call_568466.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568466.url(scheme.get, call_568466.host, call_568466.base,
                         call_568466.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568466, url, valid)

proc call*(call_568467: Call_RemediationsCancelAtResource_568460;
          apiVersion: string; resourceId: string; remediationName: string): Recallable =
  ## remediationsCancelAtResource
  ## Cancel a remediation at resource scope.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   resourceId: string (required)
  ##             : Resource ID.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_568468 = newJObject()
  var query_568469 = newJObject()
  add(query_568469, "api-version", newJString(apiVersion))
  add(path_568468, "resourceId", newJString(resourceId))
  add(path_568468, "remediationName", newJString(remediationName))
  result = call_568467.call(path_568468, query_568469, nil, nil, nil)

var remediationsCancelAtResource* = Call_RemediationsCancelAtResource_568460(
    name: "remediationsCancelAtResource", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}/cancel",
    validator: validate_RemediationsCancelAtResource_568461, base: "",
    url: url_RemediationsCancelAtResource_568462, schemes: {Scheme.Https})
type
  Call_RemediationsListDeploymentsAtResource_568470 = ref object of OpenApiRestCall_567657
proc url_RemediationsListDeploymentsAtResource_568472(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  assert "remediationName" in path, "`remediationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/remediations/"),
               (kind: VariableSegment, value: "remediationName"),
               (kind: ConstantSegment, value: "/listDeployments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemediationsListDeploymentsAtResource_568471(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all deployments for a remediation at resource scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  ##             : Resource ID.
  ##   remediationName: JString (required)
  ##                  : The name of the remediation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_568473 = path.getOrDefault("resourceId")
  valid_568473 = validateParameter(valid_568473, JString, required = true,
                                 default = nil)
  if valid_568473 != nil:
    section.add "resourceId", valid_568473
  var valid_568474 = path.getOrDefault("remediationName")
  valid_568474 = validateParameter(valid_568474, JString, required = true,
                                 default = nil)
  if valid_568474 != nil:
    section.add "remediationName", valid_568474
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : Maximum number of records to return.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568475 = query.getOrDefault("api-version")
  valid_568475 = validateParameter(valid_568475, JString, required = true,
                                 default = nil)
  if valid_568475 != nil:
    section.add "api-version", valid_568475
  var valid_568476 = query.getOrDefault("$top")
  valid_568476 = validateParameter(valid_568476, JInt, required = false, default = nil)
  if valid_568476 != nil:
    section.add "$top", valid_568476
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568477: Call_RemediationsListDeploymentsAtResource_568470;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all deployments for a remediation at resource scope.
  ## 
  let valid = call_568477.validator(path, query, header, formData, body)
  let scheme = call_568477.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568477.url(scheme.get, call_568477.host, call_568477.base,
                         call_568477.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568477, url, valid)

proc call*(call_568478: Call_RemediationsListDeploymentsAtResource_568470;
          apiVersion: string; resourceId: string; remediationName: string;
          Top: int = 0): Recallable =
  ## remediationsListDeploymentsAtResource
  ## Gets all deployments for a remediation at resource scope.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   resourceId: string (required)
  ##             : Resource ID.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_568479 = newJObject()
  var query_568480 = newJObject()
  add(query_568480, "api-version", newJString(apiVersion))
  add(query_568480, "$top", newJInt(Top))
  add(path_568479, "resourceId", newJString(resourceId))
  add(path_568479, "remediationName", newJString(remediationName))
  result = call_568478.call(path_568479, query_568480, nil, nil, nil)

var remediationsListDeploymentsAtResource* = Call_RemediationsListDeploymentsAtResource_568470(
    name: "remediationsListDeploymentsAtResource", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}/listDeployments",
    validator: validate_RemediationsListDeploymentsAtResource_568471, base: "",
    url: url_RemediationsListDeploymentsAtResource_568472, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
