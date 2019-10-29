
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563555 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563555](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563555): Option[Scheme] {.used.} =
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
  macServiceName = "policyinsights-remediations"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_RemediationsListForManagementGroup_563777 = ref object of OpenApiRestCall_563555
proc url_RemediationsListForManagementGroup_563779(protocol: Scheme; host: string;
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

proc validate_RemediationsListForManagementGroup_563778(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all remediations for the management group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupId: JString (required)
  ##                    : Management group ID.
  ##   managementGroupsNamespace: JString (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managementGroupId` field"
  var valid_563955 = path.getOrDefault("managementGroupId")
  valid_563955 = validateParameter(valid_563955, JString, required = true,
                                 default = nil)
  if valid_563955 != nil:
    section.add "managementGroupId", valid_563955
  var valid_563969 = path.getOrDefault("managementGroupsNamespace")
  valid_563969 = validateParameter(valid_563969, JString, required = true,
                                 default = newJString("Microsoft.Management"))
  if valid_563969 != nil:
    section.add "managementGroupsNamespace", valid_563969
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  var valid_563970 = query.getOrDefault("$top")
  valid_563970 = validateParameter(valid_563970, JInt, required = false, default = nil)
  if valid_563970 != nil:
    section.add "$top", valid_563970
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563971 = query.getOrDefault("api-version")
  valid_563971 = validateParameter(valid_563971, JString, required = true,
                                 default = nil)
  if valid_563971 != nil:
    section.add "api-version", valid_563971
  var valid_563972 = query.getOrDefault("$filter")
  valid_563972 = validateParameter(valid_563972, JString, required = false,
                                 default = nil)
  if valid_563972 != nil:
    section.add "$filter", valid_563972
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563995: Call_RemediationsListForManagementGroup_563777;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all remediations for the management group.
  ## 
  let valid = call_563995.validator(path, query, header, formData, body)
  let scheme = call_563995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563995.url(scheme.get, call_563995.host, call_563995.base,
                         call_563995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563995, url, valid)

proc call*(call_564066: Call_RemediationsListForManagementGroup_563777;
          managementGroupId: string; apiVersion: string; Top: int = 0;
          managementGroupsNamespace: string = "Microsoft.Management";
          Filter: string = ""): Recallable =
  ## remediationsListForManagementGroup
  ## Gets all remediations for the management group.
  ##   managementGroupId: string (required)
  ##                    : Management group ID.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   managementGroupsNamespace: string (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  ##   Filter: string
  ##         : OData filter expression.
  var path_564067 = newJObject()
  var query_564069 = newJObject()
  add(path_564067, "managementGroupId", newJString(managementGroupId))
  add(query_564069, "$top", newJInt(Top))
  add(query_564069, "api-version", newJString(apiVersion))
  add(path_564067, "managementGroupsNamespace",
      newJString(managementGroupsNamespace))
  add(query_564069, "$filter", newJString(Filter))
  result = call_564066.call(path_564067, query_564069, nil, nil, nil)

var remediationsListForManagementGroup* = Call_RemediationsListForManagementGroup_563777(
    name: "remediationsListForManagementGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/{managementGroupsNamespace}/managementGroups/{managementGroupId}/providers/Microsoft.PolicyInsights/remediations",
    validator: validate_RemediationsListForManagementGroup_563778, base: "",
    url: url_RemediationsListForManagementGroup_563779, schemes: {Scheme.Https})
type
  Call_RemediationsCreateOrUpdateAtManagementGroup_564119 = ref object of OpenApiRestCall_563555
proc url_RemediationsCreateOrUpdateAtManagementGroup_564121(protocol: Scheme;
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

proc validate_RemediationsCreateOrUpdateAtManagementGroup_564120(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a remediation at management group scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupId: JString (required)
  ##                    : Management group ID.
  ##   managementGroupsNamespace: JString (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  ##   remediationName: JString (required)
  ##                  : The name of the remediation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managementGroupId` field"
  var valid_564139 = path.getOrDefault("managementGroupId")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "managementGroupId", valid_564139
  var valid_564140 = path.getOrDefault("managementGroupsNamespace")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = newJString("Microsoft.Management"))
  if valid_564140 != nil:
    section.add "managementGroupsNamespace", valid_564140
  var valid_564141 = path.getOrDefault("remediationName")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "remediationName", valid_564141
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564142 = query.getOrDefault("api-version")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "api-version", valid_564142
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

proc call*(call_564144: Call_RemediationsCreateOrUpdateAtManagementGroup_564119;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a remediation at management group scope.
  ## 
  let valid = call_564144.validator(path, query, header, formData, body)
  let scheme = call_564144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564144.url(scheme.get, call_564144.host, call_564144.base,
                         call_564144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564144, url, valid)

proc call*(call_564145: Call_RemediationsCreateOrUpdateAtManagementGroup_564119;
          managementGroupId: string; apiVersion: string; parameters: JsonNode;
          remediationName: string;
          managementGroupsNamespace: string = "Microsoft.Management"): Recallable =
  ## remediationsCreateOrUpdateAtManagementGroup
  ## Creates or updates a remediation at management group scope.
  ##   managementGroupId: string (required)
  ##                    : Management group ID.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   managementGroupsNamespace: string (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  ##   parameters: JObject (required)
  ##             : The remediation parameters.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_564146 = newJObject()
  var query_564147 = newJObject()
  var body_564148 = newJObject()
  add(path_564146, "managementGroupId", newJString(managementGroupId))
  add(query_564147, "api-version", newJString(apiVersion))
  add(path_564146, "managementGroupsNamespace",
      newJString(managementGroupsNamespace))
  if parameters != nil:
    body_564148 = parameters
  add(path_564146, "remediationName", newJString(remediationName))
  result = call_564145.call(path_564146, query_564147, nil, nil, body_564148)

var remediationsCreateOrUpdateAtManagementGroup* = Call_RemediationsCreateOrUpdateAtManagementGroup_564119(
    name: "remediationsCreateOrUpdateAtManagementGroup", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/{managementGroupsNamespace}/managementGroups/{managementGroupId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}",
    validator: validate_RemediationsCreateOrUpdateAtManagementGroup_564120,
    base: "", url: url_RemediationsCreateOrUpdateAtManagementGroup_564121,
    schemes: {Scheme.Https})
type
  Call_RemediationsGetAtManagementGroup_564108 = ref object of OpenApiRestCall_563555
proc url_RemediationsGetAtManagementGroup_564110(protocol: Scheme; host: string;
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

proc validate_RemediationsGetAtManagementGroup_564109(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an existing remediation at management group scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupId: JString (required)
  ##                    : Management group ID.
  ##   managementGroupsNamespace: JString (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  ##   remediationName: JString (required)
  ##                  : The name of the remediation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managementGroupId` field"
  var valid_564111 = path.getOrDefault("managementGroupId")
  valid_564111 = validateParameter(valid_564111, JString, required = true,
                                 default = nil)
  if valid_564111 != nil:
    section.add "managementGroupId", valid_564111
  var valid_564112 = path.getOrDefault("managementGroupsNamespace")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = newJString("Microsoft.Management"))
  if valid_564112 != nil:
    section.add "managementGroupsNamespace", valid_564112
  var valid_564113 = path.getOrDefault("remediationName")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "remediationName", valid_564113
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564114 = query.getOrDefault("api-version")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "api-version", valid_564114
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564115: Call_RemediationsGetAtManagementGroup_564108;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an existing remediation at management group scope.
  ## 
  let valid = call_564115.validator(path, query, header, formData, body)
  let scheme = call_564115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564115.url(scheme.get, call_564115.host, call_564115.base,
                         call_564115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564115, url, valid)

proc call*(call_564116: Call_RemediationsGetAtManagementGroup_564108;
          managementGroupId: string; apiVersion: string; remediationName: string;
          managementGroupsNamespace: string = "Microsoft.Management"): Recallable =
  ## remediationsGetAtManagementGroup
  ## Gets an existing remediation at management group scope.
  ##   managementGroupId: string (required)
  ##                    : Management group ID.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   managementGroupsNamespace: string (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_564117 = newJObject()
  var query_564118 = newJObject()
  add(path_564117, "managementGroupId", newJString(managementGroupId))
  add(query_564118, "api-version", newJString(apiVersion))
  add(path_564117, "managementGroupsNamespace",
      newJString(managementGroupsNamespace))
  add(path_564117, "remediationName", newJString(remediationName))
  result = call_564116.call(path_564117, query_564118, nil, nil, nil)

var remediationsGetAtManagementGroup* = Call_RemediationsGetAtManagementGroup_564108(
    name: "remediationsGetAtManagementGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/{managementGroupsNamespace}/managementGroups/{managementGroupId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}",
    validator: validate_RemediationsGetAtManagementGroup_564109, base: "",
    url: url_RemediationsGetAtManagementGroup_564110, schemes: {Scheme.Https})
type
  Call_RemediationsDeleteAtManagementGroup_564149 = ref object of OpenApiRestCall_563555
proc url_RemediationsDeleteAtManagementGroup_564151(protocol: Scheme; host: string;
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

proc validate_RemediationsDeleteAtManagementGroup_564150(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing remediation at management group scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupId: JString (required)
  ##                    : Management group ID.
  ##   managementGroupsNamespace: JString (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  ##   remediationName: JString (required)
  ##                  : The name of the remediation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managementGroupId` field"
  var valid_564152 = path.getOrDefault("managementGroupId")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "managementGroupId", valid_564152
  var valid_564153 = path.getOrDefault("managementGroupsNamespace")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = newJString("Microsoft.Management"))
  if valid_564153 != nil:
    section.add "managementGroupsNamespace", valid_564153
  var valid_564154 = path.getOrDefault("remediationName")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "remediationName", valid_564154
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564155 = query.getOrDefault("api-version")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "api-version", valid_564155
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564156: Call_RemediationsDeleteAtManagementGroup_564149;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing remediation at management group scope.
  ## 
  let valid = call_564156.validator(path, query, header, formData, body)
  let scheme = call_564156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564156.url(scheme.get, call_564156.host, call_564156.base,
                         call_564156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564156, url, valid)

proc call*(call_564157: Call_RemediationsDeleteAtManagementGroup_564149;
          managementGroupId: string; apiVersion: string; remediationName: string;
          managementGroupsNamespace: string = "Microsoft.Management"): Recallable =
  ## remediationsDeleteAtManagementGroup
  ## Deletes an existing remediation at management group scope.
  ##   managementGroupId: string (required)
  ##                    : Management group ID.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   managementGroupsNamespace: string (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_564158 = newJObject()
  var query_564159 = newJObject()
  add(path_564158, "managementGroupId", newJString(managementGroupId))
  add(query_564159, "api-version", newJString(apiVersion))
  add(path_564158, "managementGroupsNamespace",
      newJString(managementGroupsNamespace))
  add(path_564158, "remediationName", newJString(remediationName))
  result = call_564157.call(path_564158, query_564159, nil, nil, nil)

var remediationsDeleteAtManagementGroup* = Call_RemediationsDeleteAtManagementGroup_564149(
    name: "remediationsDeleteAtManagementGroup", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/{managementGroupsNamespace}/managementGroups/{managementGroupId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}",
    validator: validate_RemediationsDeleteAtManagementGroup_564150, base: "",
    url: url_RemediationsDeleteAtManagementGroup_564151, schemes: {Scheme.Https})
type
  Call_RemediationsCancelAtManagementGroup_564160 = ref object of OpenApiRestCall_563555
proc url_RemediationsCancelAtManagementGroup_564162(protocol: Scheme; host: string;
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

proc validate_RemediationsCancelAtManagementGroup_564161(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels a remediation at management group scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupId: JString (required)
  ##                    : Management group ID.
  ##   managementGroupsNamespace: JString (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  ##   remediationName: JString (required)
  ##                  : The name of the remediation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managementGroupId` field"
  var valid_564163 = path.getOrDefault("managementGroupId")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "managementGroupId", valid_564163
  var valid_564164 = path.getOrDefault("managementGroupsNamespace")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = newJString("Microsoft.Management"))
  if valid_564164 != nil:
    section.add "managementGroupsNamespace", valid_564164
  var valid_564165 = path.getOrDefault("remediationName")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "remediationName", valid_564165
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564166 = query.getOrDefault("api-version")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "api-version", valid_564166
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564167: Call_RemediationsCancelAtManagementGroup_564160;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels a remediation at management group scope.
  ## 
  let valid = call_564167.validator(path, query, header, formData, body)
  let scheme = call_564167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564167.url(scheme.get, call_564167.host, call_564167.base,
                         call_564167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564167, url, valid)

proc call*(call_564168: Call_RemediationsCancelAtManagementGroup_564160;
          managementGroupId: string; apiVersion: string; remediationName: string;
          managementGroupsNamespace: string = "Microsoft.Management"): Recallable =
  ## remediationsCancelAtManagementGroup
  ## Cancels a remediation at management group scope.
  ##   managementGroupId: string (required)
  ##                    : Management group ID.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   managementGroupsNamespace: string (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_564169 = newJObject()
  var query_564170 = newJObject()
  add(path_564169, "managementGroupId", newJString(managementGroupId))
  add(query_564170, "api-version", newJString(apiVersion))
  add(path_564169, "managementGroupsNamespace",
      newJString(managementGroupsNamespace))
  add(path_564169, "remediationName", newJString(remediationName))
  result = call_564168.call(path_564169, query_564170, nil, nil, nil)

var remediationsCancelAtManagementGroup* = Call_RemediationsCancelAtManagementGroup_564160(
    name: "remediationsCancelAtManagementGroup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/{managementGroupsNamespace}/managementGroups/{managementGroupId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}/cancel",
    validator: validate_RemediationsCancelAtManagementGroup_564161, base: "",
    url: url_RemediationsCancelAtManagementGroup_564162, schemes: {Scheme.Https})
type
  Call_RemediationsListDeploymentsAtManagementGroup_564171 = ref object of OpenApiRestCall_563555
proc url_RemediationsListDeploymentsAtManagementGroup_564173(protocol: Scheme;
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

proc validate_RemediationsListDeploymentsAtManagementGroup_564172(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all deployments for a remediation at management group scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupId: JString (required)
  ##                    : Management group ID.
  ##   managementGroupsNamespace: JString (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  ##   remediationName: JString (required)
  ##                  : The name of the remediation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managementGroupId` field"
  var valid_564174 = path.getOrDefault("managementGroupId")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "managementGroupId", valid_564174
  var valid_564175 = path.getOrDefault("managementGroupsNamespace")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = newJString("Microsoft.Management"))
  if valid_564175 != nil:
    section.add "managementGroupsNamespace", valid_564175
  var valid_564176 = path.getOrDefault("remediationName")
  valid_564176 = validateParameter(valid_564176, JString, required = true,
                                 default = nil)
  if valid_564176 != nil:
    section.add "remediationName", valid_564176
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_564177 = query.getOrDefault("$top")
  valid_564177 = validateParameter(valid_564177, JInt, required = false, default = nil)
  if valid_564177 != nil:
    section.add "$top", valid_564177
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564178 = query.getOrDefault("api-version")
  valid_564178 = validateParameter(valid_564178, JString, required = true,
                                 default = nil)
  if valid_564178 != nil:
    section.add "api-version", valid_564178
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564179: Call_RemediationsListDeploymentsAtManagementGroup_564171;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all deployments for a remediation at management group scope.
  ## 
  let valid = call_564179.validator(path, query, header, formData, body)
  let scheme = call_564179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564179.url(scheme.get, call_564179.host, call_564179.base,
                         call_564179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564179, url, valid)

proc call*(call_564180: Call_RemediationsListDeploymentsAtManagementGroup_564171;
          managementGroupId: string; apiVersion: string; remediationName: string;
          Top: int = 0; managementGroupsNamespace: string = "Microsoft.Management"): Recallable =
  ## remediationsListDeploymentsAtManagementGroup
  ## Gets all deployments for a remediation at management group scope.
  ##   managementGroupId: string (required)
  ##                    : Management group ID.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   managementGroupsNamespace: string (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_564181 = newJObject()
  var query_564182 = newJObject()
  add(path_564181, "managementGroupId", newJString(managementGroupId))
  add(query_564182, "$top", newJInt(Top))
  add(query_564182, "api-version", newJString(apiVersion))
  add(path_564181, "managementGroupsNamespace",
      newJString(managementGroupsNamespace))
  add(path_564181, "remediationName", newJString(remediationName))
  result = call_564180.call(path_564181, query_564182, nil, nil, nil)

var remediationsListDeploymentsAtManagementGroup* = Call_RemediationsListDeploymentsAtManagementGroup_564171(
    name: "remediationsListDeploymentsAtManagementGroup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/{managementGroupsNamespace}/managementGroups/{managementGroupId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}/listDeployments",
    validator: validate_RemediationsListDeploymentsAtManagementGroup_564172,
    base: "", url: url_RemediationsListDeploymentsAtManagementGroup_564173,
    schemes: {Scheme.Https})
type
  Call_RemediationsListForSubscription_564183 = ref object of OpenApiRestCall_563555
proc url_RemediationsListForSubscription_564185(protocol: Scheme; host: string;
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

proc validate_RemediationsListForSubscription_564184(path: JsonNode;
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
  var valid_564186 = path.getOrDefault("subscriptionId")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = nil)
  if valid_564186 != nil:
    section.add "subscriptionId", valid_564186
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  var valid_564187 = query.getOrDefault("$top")
  valid_564187 = validateParameter(valid_564187, JInt, required = false, default = nil)
  if valid_564187 != nil:
    section.add "$top", valid_564187
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564188 = query.getOrDefault("api-version")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = nil)
  if valid_564188 != nil:
    section.add "api-version", valid_564188
  var valid_564189 = query.getOrDefault("$filter")
  valid_564189 = validateParameter(valid_564189, JString, required = false,
                                 default = nil)
  if valid_564189 != nil:
    section.add "$filter", valid_564189
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564190: Call_RemediationsListForSubscription_564183;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all remediations for the subscription.
  ## 
  let valid = call_564190.validator(path, query, header, formData, body)
  let scheme = call_564190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564190.url(scheme.get, call_564190.host, call_564190.base,
                         call_564190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564190, url, valid)

proc call*(call_564191: Call_RemediationsListForSubscription_564183;
          apiVersion: string; subscriptionId: string; Top: int = 0; Filter: string = ""): Recallable =
  ## remediationsListForSubscription
  ## Gets all remediations for the subscription.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   Filter: string
  ##         : OData filter expression.
  var path_564192 = newJObject()
  var query_564193 = newJObject()
  add(query_564193, "$top", newJInt(Top))
  add(query_564193, "api-version", newJString(apiVersion))
  add(path_564192, "subscriptionId", newJString(subscriptionId))
  add(query_564193, "$filter", newJString(Filter))
  result = call_564191.call(path_564192, query_564193, nil, nil, nil)

var remediationsListForSubscription* = Call_RemediationsListForSubscription_564183(
    name: "remediationsListForSubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PolicyInsights/remediations",
    validator: validate_RemediationsListForSubscription_564184, base: "",
    url: url_RemediationsListForSubscription_564185, schemes: {Scheme.Https})
type
  Call_RemediationsCreateOrUpdateAtSubscription_564204 = ref object of OpenApiRestCall_563555
proc url_RemediationsCreateOrUpdateAtSubscription_564206(protocol: Scheme;
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

proc validate_RemediationsCreateOrUpdateAtSubscription_564205(path: JsonNode;
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
  var valid_564207 = path.getOrDefault("subscriptionId")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "subscriptionId", valid_564207
  var valid_564208 = path.getOrDefault("remediationName")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "remediationName", valid_564208
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The remediation parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564211: Call_RemediationsCreateOrUpdateAtSubscription_564204;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a remediation at subscription scope.
  ## 
  let valid = call_564211.validator(path, query, header, formData, body)
  let scheme = call_564211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564211.url(scheme.get, call_564211.host, call_564211.base,
                         call_564211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564211, url, valid)

proc call*(call_564212: Call_RemediationsCreateOrUpdateAtSubscription_564204;
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
  var path_564213 = newJObject()
  var query_564214 = newJObject()
  var body_564215 = newJObject()
  add(query_564214, "api-version", newJString(apiVersion))
  add(path_564213, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_564215 = parameters
  add(path_564213, "remediationName", newJString(remediationName))
  result = call_564212.call(path_564213, query_564214, nil, nil, body_564215)

var remediationsCreateOrUpdateAtSubscription* = Call_RemediationsCreateOrUpdateAtSubscription_564204(
    name: "remediationsCreateOrUpdateAtSubscription", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}",
    validator: validate_RemediationsCreateOrUpdateAtSubscription_564205, base: "",
    url: url_RemediationsCreateOrUpdateAtSubscription_564206,
    schemes: {Scheme.Https})
type
  Call_RemediationsGetAtSubscription_564194 = ref object of OpenApiRestCall_563555
proc url_RemediationsGetAtSubscription_564196(protocol: Scheme; host: string;
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

proc validate_RemediationsGetAtSubscription_564195(path: JsonNode; query: JsonNode;
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
  var valid_564197 = path.getOrDefault("subscriptionId")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "subscriptionId", valid_564197
  var valid_564198 = path.getOrDefault("remediationName")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "remediationName", valid_564198
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564199 = query.getOrDefault("api-version")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "api-version", valid_564199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564200: Call_RemediationsGetAtSubscription_564194; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an existing remediation at subscription scope.
  ## 
  let valid = call_564200.validator(path, query, header, formData, body)
  let scheme = call_564200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564200.url(scheme.get, call_564200.host, call_564200.base,
                         call_564200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564200, url, valid)

proc call*(call_564201: Call_RemediationsGetAtSubscription_564194;
          apiVersion: string; subscriptionId: string; remediationName: string): Recallable =
  ## remediationsGetAtSubscription
  ## Gets an existing remediation at subscription scope.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_564202 = newJObject()
  var query_564203 = newJObject()
  add(query_564203, "api-version", newJString(apiVersion))
  add(path_564202, "subscriptionId", newJString(subscriptionId))
  add(path_564202, "remediationName", newJString(remediationName))
  result = call_564201.call(path_564202, query_564203, nil, nil, nil)

var remediationsGetAtSubscription* = Call_RemediationsGetAtSubscription_564194(
    name: "remediationsGetAtSubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}",
    validator: validate_RemediationsGetAtSubscription_564195, base: "",
    url: url_RemediationsGetAtSubscription_564196, schemes: {Scheme.Https})
type
  Call_RemediationsDeleteAtSubscription_564216 = ref object of OpenApiRestCall_563555
proc url_RemediationsDeleteAtSubscription_564218(protocol: Scheme; host: string;
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

proc validate_RemediationsDeleteAtSubscription_564217(path: JsonNode;
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
  var valid_564219 = path.getOrDefault("subscriptionId")
  valid_564219 = validateParameter(valid_564219, JString, required = true,
                                 default = nil)
  if valid_564219 != nil:
    section.add "subscriptionId", valid_564219
  var valid_564220 = path.getOrDefault("remediationName")
  valid_564220 = validateParameter(valid_564220, JString, required = true,
                                 default = nil)
  if valid_564220 != nil:
    section.add "remediationName", valid_564220
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

proc call*(call_564222: Call_RemediationsDeleteAtSubscription_564216;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing remediation at subscription scope.
  ## 
  let valid = call_564222.validator(path, query, header, formData, body)
  let scheme = call_564222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564222.url(scheme.get, call_564222.host, call_564222.base,
                         call_564222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564222, url, valid)

proc call*(call_564223: Call_RemediationsDeleteAtSubscription_564216;
          apiVersion: string; subscriptionId: string; remediationName: string): Recallable =
  ## remediationsDeleteAtSubscription
  ## Deletes an existing remediation at subscription scope.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_564224 = newJObject()
  var query_564225 = newJObject()
  add(query_564225, "api-version", newJString(apiVersion))
  add(path_564224, "subscriptionId", newJString(subscriptionId))
  add(path_564224, "remediationName", newJString(remediationName))
  result = call_564223.call(path_564224, query_564225, nil, nil, nil)

var remediationsDeleteAtSubscription* = Call_RemediationsDeleteAtSubscription_564216(
    name: "remediationsDeleteAtSubscription", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}",
    validator: validate_RemediationsDeleteAtSubscription_564217, base: "",
    url: url_RemediationsDeleteAtSubscription_564218, schemes: {Scheme.Https})
type
  Call_RemediationsCancelAtSubscription_564226 = ref object of OpenApiRestCall_563555
proc url_RemediationsCancelAtSubscription_564228(protocol: Scheme; host: string;
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

proc validate_RemediationsCancelAtSubscription_564227(path: JsonNode;
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
  var valid_564229 = path.getOrDefault("subscriptionId")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "subscriptionId", valid_564229
  var valid_564230 = path.getOrDefault("remediationName")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = nil)
  if valid_564230 != nil:
    section.add "remediationName", valid_564230
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

proc call*(call_564232: Call_RemediationsCancelAtSubscription_564226;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels a remediation at subscription scope.
  ## 
  let valid = call_564232.validator(path, query, header, formData, body)
  let scheme = call_564232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564232.url(scheme.get, call_564232.host, call_564232.base,
                         call_564232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564232, url, valid)

proc call*(call_564233: Call_RemediationsCancelAtSubscription_564226;
          apiVersion: string; subscriptionId: string; remediationName: string): Recallable =
  ## remediationsCancelAtSubscription
  ## Cancels a remediation at subscription scope.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_564234 = newJObject()
  var query_564235 = newJObject()
  add(query_564235, "api-version", newJString(apiVersion))
  add(path_564234, "subscriptionId", newJString(subscriptionId))
  add(path_564234, "remediationName", newJString(remediationName))
  result = call_564233.call(path_564234, query_564235, nil, nil, nil)

var remediationsCancelAtSubscription* = Call_RemediationsCancelAtSubscription_564226(
    name: "remediationsCancelAtSubscription", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}/cancel",
    validator: validate_RemediationsCancelAtSubscription_564227, base: "",
    url: url_RemediationsCancelAtSubscription_564228, schemes: {Scheme.Https})
type
  Call_RemediationsListDeploymentsAtSubscription_564236 = ref object of OpenApiRestCall_563555
proc url_RemediationsListDeploymentsAtSubscription_564238(protocol: Scheme;
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

proc validate_RemediationsListDeploymentsAtSubscription_564237(path: JsonNode;
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
  var valid_564239 = path.getOrDefault("subscriptionId")
  valid_564239 = validateParameter(valid_564239, JString, required = true,
                                 default = nil)
  if valid_564239 != nil:
    section.add "subscriptionId", valid_564239
  var valid_564240 = path.getOrDefault("remediationName")
  valid_564240 = validateParameter(valid_564240, JString, required = true,
                                 default = nil)
  if valid_564240 != nil:
    section.add "remediationName", valid_564240
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_564241 = query.getOrDefault("$top")
  valid_564241 = validateParameter(valid_564241, JInt, required = false, default = nil)
  if valid_564241 != nil:
    section.add "$top", valid_564241
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564242 = query.getOrDefault("api-version")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "api-version", valid_564242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564243: Call_RemediationsListDeploymentsAtSubscription_564236;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all deployments for a remediation at subscription scope.
  ## 
  let valid = call_564243.validator(path, query, header, formData, body)
  let scheme = call_564243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564243.url(scheme.get, call_564243.host, call_564243.base,
                         call_564243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564243, url, valid)

proc call*(call_564244: Call_RemediationsListDeploymentsAtSubscription_564236;
          apiVersion: string; subscriptionId: string; remediationName: string;
          Top: int = 0): Recallable =
  ## remediationsListDeploymentsAtSubscription
  ## Gets all deployments for a remediation at subscription scope.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_564245 = newJObject()
  var query_564246 = newJObject()
  add(query_564246, "$top", newJInt(Top))
  add(query_564246, "api-version", newJString(apiVersion))
  add(path_564245, "subscriptionId", newJString(subscriptionId))
  add(path_564245, "remediationName", newJString(remediationName))
  result = call_564244.call(path_564245, query_564246, nil, nil, nil)

var remediationsListDeploymentsAtSubscription* = Call_RemediationsListDeploymentsAtSubscription_564236(
    name: "remediationsListDeploymentsAtSubscription", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}/listDeployments",
    validator: validate_RemediationsListDeploymentsAtSubscription_564237,
    base: "", url: url_RemediationsListDeploymentsAtSubscription_564238,
    schemes: {Scheme.Https})
type
  Call_RemediationsListForResourceGroup_564247 = ref object of OpenApiRestCall_563555
proc url_RemediationsListForResourceGroup_564249(protocol: Scheme; host: string;
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

proc validate_RemediationsListForResourceGroup_564248(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all remediations for the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564250 = path.getOrDefault("subscriptionId")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "subscriptionId", valid_564250
  var valid_564251 = path.getOrDefault("resourceGroupName")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "resourceGroupName", valid_564251
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  var valid_564252 = query.getOrDefault("$top")
  valid_564252 = validateParameter(valid_564252, JInt, required = false, default = nil)
  if valid_564252 != nil:
    section.add "$top", valid_564252
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564253 = query.getOrDefault("api-version")
  valid_564253 = validateParameter(valid_564253, JString, required = true,
                                 default = nil)
  if valid_564253 != nil:
    section.add "api-version", valid_564253
  var valid_564254 = query.getOrDefault("$filter")
  valid_564254 = validateParameter(valid_564254, JString, required = false,
                                 default = nil)
  if valid_564254 != nil:
    section.add "$filter", valid_564254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564255: Call_RemediationsListForResourceGroup_564247;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all remediations for the subscription.
  ## 
  let valid = call_564255.validator(path, query, header, formData, body)
  let scheme = call_564255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564255.url(scheme.get, call_564255.host, call_564255.base,
                         call_564255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564255, url, valid)

proc call*(call_564256: Call_RemediationsListForResourceGroup_564247;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          Top: int = 0; Filter: string = ""): Recallable =
  ## remediationsListForResourceGroup
  ## Gets all remediations for the subscription.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   Filter: string
  ##         : OData filter expression.
  var path_564257 = newJObject()
  var query_564258 = newJObject()
  add(query_564258, "$top", newJInt(Top))
  add(query_564258, "api-version", newJString(apiVersion))
  add(path_564257, "subscriptionId", newJString(subscriptionId))
  add(path_564257, "resourceGroupName", newJString(resourceGroupName))
  add(query_564258, "$filter", newJString(Filter))
  result = call_564256.call(path_564257, query_564258, nil, nil, nil)

var remediationsListForResourceGroup* = Call_RemediationsListForResourceGroup_564247(
    name: "remediationsListForResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PolicyInsights/remediations",
    validator: validate_RemediationsListForResourceGroup_564248, base: "",
    url: url_RemediationsListForResourceGroup_564249, schemes: {Scheme.Https})
type
  Call_RemediationsCreateOrUpdateAtResourceGroup_564270 = ref object of OpenApiRestCall_563555
proc url_RemediationsCreateOrUpdateAtResourceGroup_564272(protocol: Scheme;
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

proc validate_RemediationsCreateOrUpdateAtResourceGroup_564271(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a remediation at resource group scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   remediationName: JString (required)
  ##                  : The name of the remediation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564273 = path.getOrDefault("subscriptionId")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "subscriptionId", valid_564273
  var valid_564274 = path.getOrDefault("resourceGroupName")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "resourceGroupName", valid_564274
  var valid_564275 = path.getOrDefault("remediationName")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "remediationName", valid_564275
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564276 = query.getOrDefault("api-version")
  valid_564276 = validateParameter(valid_564276, JString, required = true,
                                 default = nil)
  if valid_564276 != nil:
    section.add "api-version", valid_564276
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

proc call*(call_564278: Call_RemediationsCreateOrUpdateAtResourceGroup_564270;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a remediation at resource group scope.
  ## 
  let valid = call_564278.validator(path, query, header, formData, body)
  let scheme = call_564278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564278.url(scheme.get, call_564278.host, call_564278.base,
                         call_564278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564278, url, valid)

proc call*(call_564279: Call_RemediationsCreateOrUpdateAtResourceGroup_564270;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode; remediationName: string): Recallable =
  ## remediationsCreateOrUpdateAtResourceGroup
  ## Creates or updates a remediation at resource group scope.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   parameters: JObject (required)
  ##             : The remediation parameters.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_564280 = newJObject()
  var query_564281 = newJObject()
  var body_564282 = newJObject()
  add(query_564281, "api-version", newJString(apiVersion))
  add(path_564280, "subscriptionId", newJString(subscriptionId))
  add(path_564280, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564282 = parameters
  add(path_564280, "remediationName", newJString(remediationName))
  result = call_564279.call(path_564280, query_564281, nil, nil, body_564282)

var remediationsCreateOrUpdateAtResourceGroup* = Call_RemediationsCreateOrUpdateAtResourceGroup_564270(
    name: "remediationsCreateOrUpdateAtResourceGroup", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PolicyInsights/remediations/{remediationName}",
    validator: validate_RemediationsCreateOrUpdateAtResourceGroup_564271,
    base: "", url: url_RemediationsCreateOrUpdateAtResourceGroup_564272,
    schemes: {Scheme.Https})
type
  Call_RemediationsGetAtResourceGroup_564259 = ref object of OpenApiRestCall_563555
proc url_RemediationsGetAtResourceGroup_564261(protocol: Scheme; host: string;
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

proc validate_RemediationsGetAtResourceGroup_564260(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an existing remediation at resource group scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   remediationName: JString (required)
  ##                  : The name of the remediation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564262 = path.getOrDefault("subscriptionId")
  valid_564262 = validateParameter(valid_564262, JString, required = true,
                                 default = nil)
  if valid_564262 != nil:
    section.add "subscriptionId", valid_564262
  var valid_564263 = path.getOrDefault("resourceGroupName")
  valid_564263 = validateParameter(valid_564263, JString, required = true,
                                 default = nil)
  if valid_564263 != nil:
    section.add "resourceGroupName", valid_564263
  var valid_564264 = path.getOrDefault("remediationName")
  valid_564264 = validateParameter(valid_564264, JString, required = true,
                                 default = nil)
  if valid_564264 != nil:
    section.add "remediationName", valid_564264
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564265 = query.getOrDefault("api-version")
  valid_564265 = validateParameter(valid_564265, JString, required = true,
                                 default = nil)
  if valid_564265 != nil:
    section.add "api-version", valid_564265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564266: Call_RemediationsGetAtResourceGroup_564259; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an existing remediation at resource group scope.
  ## 
  let valid = call_564266.validator(path, query, header, formData, body)
  let scheme = call_564266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564266.url(scheme.get, call_564266.host, call_564266.base,
                         call_564266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564266, url, valid)

proc call*(call_564267: Call_RemediationsGetAtResourceGroup_564259;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          remediationName: string): Recallable =
  ## remediationsGetAtResourceGroup
  ## Gets an existing remediation at resource group scope.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_564268 = newJObject()
  var query_564269 = newJObject()
  add(query_564269, "api-version", newJString(apiVersion))
  add(path_564268, "subscriptionId", newJString(subscriptionId))
  add(path_564268, "resourceGroupName", newJString(resourceGroupName))
  add(path_564268, "remediationName", newJString(remediationName))
  result = call_564267.call(path_564268, query_564269, nil, nil, nil)

var remediationsGetAtResourceGroup* = Call_RemediationsGetAtResourceGroup_564259(
    name: "remediationsGetAtResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PolicyInsights/remediations/{remediationName}",
    validator: validate_RemediationsGetAtResourceGroup_564260, base: "",
    url: url_RemediationsGetAtResourceGroup_564261, schemes: {Scheme.Https})
type
  Call_RemediationsDeleteAtResourceGroup_564283 = ref object of OpenApiRestCall_563555
proc url_RemediationsDeleteAtResourceGroup_564285(protocol: Scheme; host: string;
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

proc validate_RemediationsDeleteAtResourceGroup_564284(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing remediation at resource group scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   remediationName: JString (required)
  ##                  : The name of the remediation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564286 = path.getOrDefault("subscriptionId")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "subscriptionId", valid_564286
  var valid_564287 = path.getOrDefault("resourceGroupName")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "resourceGroupName", valid_564287
  var valid_564288 = path.getOrDefault("remediationName")
  valid_564288 = validateParameter(valid_564288, JString, required = true,
                                 default = nil)
  if valid_564288 != nil:
    section.add "remediationName", valid_564288
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564289 = query.getOrDefault("api-version")
  valid_564289 = validateParameter(valid_564289, JString, required = true,
                                 default = nil)
  if valid_564289 != nil:
    section.add "api-version", valid_564289
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564290: Call_RemediationsDeleteAtResourceGroup_564283;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing remediation at resource group scope.
  ## 
  let valid = call_564290.validator(path, query, header, formData, body)
  let scheme = call_564290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564290.url(scheme.get, call_564290.host, call_564290.base,
                         call_564290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564290, url, valid)

proc call*(call_564291: Call_RemediationsDeleteAtResourceGroup_564283;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          remediationName: string): Recallable =
  ## remediationsDeleteAtResourceGroup
  ## Deletes an existing remediation at resource group scope.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_564292 = newJObject()
  var query_564293 = newJObject()
  add(query_564293, "api-version", newJString(apiVersion))
  add(path_564292, "subscriptionId", newJString(subscriptionId))
  add(path_564292, "resourceGroupName", newJString(resourceGroupName))
  add(path_564292, "remediationName", newJString(remediationName))
  result = call_564291.call(path_564292, query_564293, nil, nil, nil)

var remediationsDeleteAtResourceGroup* = Call_RemediationsDeleteAtResourceGroup_564283(
    name: "remediationsDeleteAtResourceGroup", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PolicyInsights/remediations/{remediationName}",
    validator: validate_RemediationsDeleteAtResourceGroup_564284, base: "",
    url: url_RemediationsDeleteAtResourceGroup_564285, schemes: {Scheme.Https})
type
  Call_RemediationsCancelAtResourceGroup_564294 = ref object of OpenApiRestCall_563555
proc url_RemediationsCancelAtResourceGroup_564296(protocol: Scheme; host: string;
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

proc validate_RemediationsCancelAtResourceGroup_564295(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels a remediation at resource group scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   remediationName: JString (required)
  ##                  : The name of the remediation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564297 = path.getOrDefault("subscriptionId")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = nil)
  if valid_564297 != nil:
    section.add "subscriptionId", valid_564297
  var valid_564298 = path.getOrDefault("resourceGroupName")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = nil)
  if valid_564298 != nil:
    section.add "resourceGroupName", valid_564298
  var valid_564299 = path.getOrDefault("remediationName")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = nil)
  if valid_564299 != nil:
    section.add "remediationName", valid_564299
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564300 = query.getOrDefault("api-version")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = nil)
  if valid_564300 != nil:
    section.add "api-version", valid_564300
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564301: Call_RemediationsCancelAtResourceGroup_564294;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels a remediation at resource group scope.
  ## 
  let valid = call_564301.validator(path, query, header, formData, body)
  let scheme = call_564301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564301.url(scheme.get, call_564301.host, call_564301.base,
                         call_564301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564301, url, valid)

proc call*(call_564302: Call_RemediationsCancelAtResourceGroup_564294;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          remediationName: string): Recallable =
  ## remediationsCancelAtResourceGroup
  ## Cancels a remediation at resource group scope.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_564303 = newJObject()
  var query_564304 = newJObject()
  add(query_564304, "api-version", newJString(apiVersion))
  add(path_564303, "subscriptionId", newJString(subscriptionId))
  add(path_564303, "resourceGroupName", newJString(resourceGroupName))
  add(path_564303, "remediationName", newJString(remediationName))
  result = call_564302.call(path_564303, query_564304, nil, nil, nil)

var remediationsCancelAtResourceGroup* = Call_RemediationsCancelAtResourceGroup_564294(
    name: "remediationsCancelAtResourceGroup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PolicyInsights/remediations/{remediationName}/cancel",
    validator: validate_RemediationsCancelAtResourceGroup_564295, base: "",
    url: url_RemediationsCancelAtResourceGroup_564296, schemes: {Scheme.Https})
type
  Call_RemediationsListDeploymentsAtResourceGroup_564305 = ref object of OpenApiRestCall_563555
proc url_RemediationsListDeploymentsAtResourceGroup_564307(protocol: Scheme;
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

proc validate_RemediationsListDeploymentsAtResourceGroup_564306(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all deployments for a remediation at resource group scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   remediationName: JString (required)
  ##                  : The name of the remediation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564308 = path.getOrDefault("subscriptionId")
  valid_564308 = validateParameter(valid_564308, JString, required = true,
                                 default = nil)
  if valid_564308 != nil:
    section.add "subscriptionId", valid_564308
  var valid_564309 = path.getOrDefault("resourceGroupName")
  valid_564309 = validateParameter(valid_564309, JString, required = true,
                                 default = nil)
  if valid_564309 != nil:
    section.add "resourceGroupName", valid_564309
  var valid_564310 = path.getOrDefault("remediationName")
  valid_564310 = validateParameter(valid_564310, JString, required = true,
                                 default = nil)
  if valid_564310 != nil:
    section.add "remediationName", valid_564310
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_564311 = query.getOrDefault("$top")
  valid_564311 = validateParameter(valid_564311, JInt, required = false, default = nil)
  if valid_564311 != nil:
    section.add "$top", valid_564311
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564312 = query.getOrDefault("api-version")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "api-version", valid_564312
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564313: Call_RemediationsListDeploymentsAtResourceGroup_564305;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all deployments for a remediation at resource group scope.
  ## 
  let valid = call_564313.validator(path, query, header, formData, body)
  let scheme = call_564313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564313.url(scheme.get, call_564313.host, call_564313.base,
                         call_564313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564313, url, valid)

proc call*(call_564314: Call_RemediationsListDeploymentsAtResourceGroup_564305;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          remediationName: string; Top: int = 0): Recallable =
  ## remediationsListDeploymentsAtResourceGroup
  ## Gets all deployments for a remediation at resource group scope.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_564315 = newJObject()
  var query_564316 = newJObject()
  add(query_564316, "$top", newJInt(Top))
  add(query_564316, "api-version", newJString(apiVersion))
  add(path_564315, "subscriptionId", newJString(subscriptionId))
  add(path_564315, "resourceGroupName", newJString(resourceGroupName))
  add(path_564315, "remediationName", newJString(remediationName))
  result = call_564314.call(path_564315, query_564316, nil, nil, nil)

var remediationsListDeploymentsAtResourceGroup* = Call_RemediationsListDeploymentsAtResourceGroup_564305(
    name: "remediationsListDeploymentsAtResourceGroup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PolicyInsights/remediations/{remediationName}/listDeployments",
    validator: validate_RemediationsListDeploymentsAtResourceGroup_564306,
    base: "", url: url_RemediationsListDeploymentsAtResourceGroup_564307,
    schemes: {Scheme.Https})
type
  Call_RemediationsListForResource_564317 = ref object of OpenApiRestCall_563555
proc url_RemediationsListForResource_564319(protocol: Scheme; host: string;
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

proc validate_RemediationsListForResource_564318(path: JsonNode; query: JsonNode;
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
  var valid_564320 = path.getOrDefault("resourceId")
  valid_564320 = validateParameter(valid_564320, JString, required = true,
                                 default = nil)
  if valid_564320 != nil:
    section.add "resourceId", valid_564320
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  var valid_564321 = query.getOrDefault("$top")
  valid_564321 = validateParameter(valid_564321, JInt, required = false, default = nil)
  if valid_564321 != nil:
    section.add "$top", valid_564321
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564322 = query.getOrDefault("api-version")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "api-version", valid_564322
  var valid_564323 = query.getOrDefault("$filter")
  valid_564323 = validateParameter(valid_564323, JString, required = false,
                                 default = nil)
  if valid_564323 != nil:
    section.add "$filter", valid_564323
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564324: Call_RemediationsListForResource_564317; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all remediations for a resource.
  ## 
  let valid = call_564324.validator(path, query, header, formData, body)
  let scheme = call_564324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564324.url(scheme.get, call_564324.host, call_564324.base,
                         call_564324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564324, url, valid)

proc call*(call_564325: Call_RemediationsListForResource_564317;
          apiVersion: string; resourceId: string; Top: int = 0; Filter: string = ""): Recallable =
  ## remediationsListForResource
  ## Gets all remediations for a resource.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Filter: string
  ##         : OData filter expression.
  ##   resourceId: string (required)
  ##             : Resource ID.
  var path_564326 = newJObject()
  var query_564327 = newJObject()
  add(query_564327, "$top", newJInt(Top))
  add(query_564327, "api-version", newJString(apiVersion))
  add(query_564327, "$filter", newJString(Filter))
  add(path_564326, "resourceId", newJString(resourceId))
  result = call_564325.call(path_564326, query_564327, nil, nil, nil)

var remediationsListForResource* = Call_RemediationsListForResource_564317(
    name: "remediationsListForResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{resourceId}/providers/Microsoft.PolicyInsights/remediations",
    validator: validate_RemediationsListForResource_564318, base: "",
    url: url_RemediationsListForResource_564319, schemes: {Scheme.Https})
type
  Call_RemediationsCreateOrUpdateAtResource_564338 = ref object of OpenApiRestCall_563555
proc url_RemediationsCreateOrUpdateAtResource_564340(protocol: Scheme;
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

proc validate_RemediationsCreateOrUpdateAtResource_564339(path: JsonNode;
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
  var valid_564341 = path.getOrDefault("resourceId")
  valid_564341 = validateParameter(valid_564341, JString, required = true,
                                 default = nil)
  if valid_564341 != nil:
    section.add "resourceId", valid_564341
  var valid_564342 = path.getOrDefault("remediationName")
  valid_564342 = validateParameter(valid_564342, JString, required = true,
                                 default = nil)
  if valid_564342 != nil:
    section.add "remediationName", valid_564342
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564343 = query.getOrDefault("api-version")
  valid_564343 = validateParameter(valid_564343, JString, required = true,
                                 default = nil)
  if valid_564343 != nil:
    section.add "api-version", valid_564343
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

proc call*(call_564345: Call_RemediationsCreateOrUpdateAtResource_564338;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a remediation at resource scope.
  ## 
  let valid = call_564345.validator(path, query, header, formData, body)
  let scheme = call_564345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564345.url(scheme.get, call_564345.host, call_564345.base,
                         call_564345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564345, url, valid)

proc call*(call_564346: Call_RemediationsCreateOrUpdateAtResource_564338;
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
  var path_564347 = newJObject()
  var query_564348 = newJObject()
  var body_564349 = newJObject()
  add(query_564348, "api-version", newJString(apiVersion))
  add(path_564347, "resourceId", newJString(resourceId))
  if parameters != nil:
    body_564349 = parameters
  add(path_564347, "remediationName", newJString(remediationName))
  result = call_564346.call(path_564347, query_564348, nil, nil, body_564349)

var remediationsCreateOrUpdateAtResource* = Call_RemediationsCreateOrUpdateAtResource_564338(
    name: "remediationsCreateOrUpdateAtResource", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}",
    validator: validate_RemediationsCreateOrUpdateAtResource_564339, base: "",
    url: url_RemediationsCreateOrUpdateAtResource_564340, schemes: {Scheme.Https})
type
  Call_RemediationsGetAtResource_564328 = ref object of OpenApiRestCall_563555
proc url_RemediationsGetAtResource_564330(protocol: Scheme; host: string;
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

proc validate_RemediationsGetAtResource_564329(path: JsonNode; query: JsonNode;
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
  var valid_564331 = path.getOrDefault("resourceId")
  valid_564331 = validateParameter(valid_564331, JString, required = true,
                                 default = nil)
  if valid_564331 != nil:
    section.add "resourceId", valid_564331
  var valid_564332 = path.getOrDefault("remediationName")
  valid_564332 = validateParameter(valid_564332, JString, required = true,
                                 default = nil)
  if valid_564332 != nil:
    section.add "remediationName", valid_564332
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564333 = query.getOrDefault("api-version")
  valid_564333 = validateParameter(valid_564333, JString, required = true,
                                 default = nil)
  if valid_564333 != nil:
    section.add "api-version", valid_564333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564334: Call_RemediationsGetAtResource_564328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an existing remediation at resource scope.
  ## 
  let valid = call_564334.validator(path, query, header, formData, body)
  let scheme = call_564334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564334.url(scheme.get, call_564334.host, call_564334.base,
                         call_564334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564334, url, valid)

proc call*(call_564335: Call_RemediationsGetAtResource_564328; apiVersion: string;
          resourceId: string; remediationName: string): Recallable =
  ## remediationsGetAtResource
  ## Gets an existing remediation at resource scope.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   resourceId: string (required)
  ##             : Resource ID.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_564336 = newJObject()
  var query_564337 = newJObject()
  add(query_564337, "api-version", newJString(apiVersion))
  add(path_564336, "resourceId", newJString(resourceId))
  add(path_564336, "remediationName", newJString(remediationName))
  result = call_564335.call(path_564336, query_564337, nil, nil, nil)

var remediationsGetAtResource* = Call_RemediationsGetAtResource_564328(
    name: "remediationsGetAtResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}",
    validator: validate_RemediationsGetAtResource_564329, base: "",
    url: url_RemediationsGetAtResource_564330, schemes: {Scheme.Https})
type
  Call_RemediationsDeleteAtResource_564350 = ref object of OpenApiRestCall_563555
proc url_RemediationsDeleteAtResource_564352(protocol: Scheme; host: string;
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

proc validate_RemediationsDeleteAtResource_564351(path: JsonNode; query: JsonNode;
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
  var valid_564353 = path.getOrDefault("resourceId")
  valid_564353 = validateParameter(valid_564353, JString, required = true,
                                 default = nil)
  if valid_564353 != nil:
    section.add "resourceId", valid_564353
  var valid_564354 = path.getOrDefault("remediationName")
  valid_564354 = validateParameter(valid_564354, JString, required = true,
                                 default = nil)
  if valid_564354 != nil:
    section.add "remediationName", valid_564354
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564355 = query.getOrDefault("api-version")
  valid_564355 = validateParameter(valid_564355, JString, required = true,
                                 default = nil)
  if valid_564355 != nil:
    section.add "api-version", valid_564355
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564356: Call_RemediationsDeleteAtResource_564350; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing remediation at individual resource scope.
  ## 
  let valid = call_564356.validator(path, query, header, formData, body)
  let scheme = call_564356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564356.url(scheme.get, call_564356.host, call_564356.base,
                         call_564356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564356, url, valid)

proc call*(call_564357: Call_RemediationsDeleteAtResource_564350;
          apiVersion: string; resourceId: string; remediationName: string): Recallable =
  ## remediationsDeleteAtResource
  ## Deletes an existing remediation at individual resource scope.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   resourceId: string (required)
  ##             : Resource ID.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_564358 = newJObject()
  var query_564359 = newJObject()
  add(query_564359, "api-version", newJString(apiVersion))
  add(path_564358, "resourceId", newJString(resourceId))
  add(path_564358, "remediationName", newJString(remediationName))
  result = call_564357.call(path_564358, query_564359, nil, nil, nil)

var remediationsDeleteAtResource* = Call_RemediationsDeleteAtResource_564350(
    name: "remediationsDeleteAtResource", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}",
    validator: validate_RemediationsDeleteAtResource_564351, base: "",
    url: url_RemediationsDeleteAtResource_564352, schemes: {Scheme.Https})
type
  Call_RemediationsCancelAtResource_564360 = ref object of OpenApiRestCall_563555
proc url_RemediationsCancelAtResource_564362(protocol: Scheme; host: string;
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

proc validate_RemediationsCancelAtResource_564361(path: JsonNode; query: JsonNode;
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
  var valid_564363 = path.getOrDefault("resourceId")
  valid_564363 = validateParameter(valid_564363, JString, required = true,
                                 default = nil)
  if valid_564363 != nil:
    section.add "resourceId", valid_564363
  var valid_564364 = path.getOrDefault("remediationName")
  valid_564364 = validateParameter(valid_564364, JString, required = true,
                                 default = nil)
  if valid_564364 != nil:
    section.add "remediationName", valid_564364
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564365 = query.getOrDefault("api-version")
  valid_564365 = validateParameter(valid_564365, JString, required = true,
                                 default = nil)
  if valid_564365 != nil:
    section.add "api-version", valid_564365
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564366: Call_RemediationsCancelAtResource_564360; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancel a remediation at resource scope.
  ## 
  let valid = call_564366.validator(path, query, header, formData, body)
  let scheme = call_564366.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564366.url(scheme.get, call_564366.host, call_564366.base,
                         call_564366.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564366, url, valid)

proc call*(call_564367: Call_RemediationsCancelAtResource_564360;
          apiVersion: string; resourceId: string; remediationName: string): Recallable =
  ## remediationsCancelAtResource
  ## Cancel a remediation at resource scope.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   resourceId: string (required)
  ##             : Resource ID.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_564368 = newJObject()
  var query_564369 = newJObject()
  add(query_564369, "api-version", newJString(apiVersion))
  add(path_564368, "resourceId", newJString(resourceId))
  add(path_564368, "remediationName", newJString(remediationName))
  result = call_564367.call(path_564368, query_564369, nil, nil, nil)

var remediationsCancelAtResource* = Call_RemediationsCancelAtResource_564360(
    name: "remediationsCancelAtResource", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}/cancel",
    validator: validate_RemediationsCancelAtResource_564361, base: "",
    url: url_RemediationsCancelAtResource_564362, schemes: {Scheme.Https})
type
  Call_RemediationsListDeploymentsAtResource_564370 = ref object of OpenApiRestCall_563555
proc url_RemediationsListDeploymentsAtResource_564372(protocol: Scheme;
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

proc validate_RemediationsListDeploymentsAtResource_564371(path: JsonNode;
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
  var valid_564373 = path.getOrDefault("resourceId")
  valid_564373 = validateParameter(valid_564373, JString, required = true,
                                 default = nil)
  if valid_564373 != nil:
    section.add "resourceId", valid_564373
  var valid_564374 = path.getOrDefault("remediationName")
  valid_564374 = validateParameter(valid_564374, JString, required = true,
                                 default = nil)
  if valid_564374 != nil:
    section.add "remediationName", valid_564374
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_564375 = query.getOrDefault("$top")
  valid_564375 = validateParameter(valid_564375, JInt, required = false, default = nil)
  if valid_564375 != nil:
    section.add "$top", valid_564375
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564376 = query.getOrDefault("api-version")
  valid_564376 = validateParameter(valid_564376, JString, required = true,
                                 default = nil)
  if valid_564376 != nil:
    section.add "api-version", valid_564376
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564377: Call_RemediationsListDeploymentsAtResource_564370;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all deployments for a remediation at resource scope.
  ## 
  let valid = call_564377.validator(path, query, header, formData, body)
  let scheme = call_564377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564377.url(scheme.get, call_564377.host, call_564377.base,
                         call_564377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564377, url, valid)

proc call*(call_564378: Call_RemediationsListDeploymentsAtResource_564370;
          apiVersion: string; resourceId: string; remediationName: string;
          Top: int = 0): Recallable =
  ## remediationsListDeploymentsAtResource
  ## Gets all deployments for a remediation at resource scope.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   resourceId: string (required)
  ##             : Resource ID.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_564379 = newJObject()
  var query_564380 = newJObject()
  add(query_564380, "$top", newJInt(Top))
  add(query_564380, "api-version", newJString(apiVersion))
  add(path_564379, "resourceId", newJString(resourceId))
  add(path_564379, "remediationName", newJString(remediationName))
  result = call_564378.call(path_564379, query_564380, nil, nil, nil)

var remediationsListDeploymentsAtResource* = Call_RemediationsListDeploymentsAtResource_564370(
    name: "remediationsListDeploymentsAtResource", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}/listDeployments",
    validator: validate_RemediationsListDeploymentsAtResource_564371, base: "",
    url: url_RemediationsListDeploymentsAtResource_564372, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
