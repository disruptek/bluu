
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
  macServiceName = "policyinsights-remediations"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_RemediationsListForManagementGroup_593646 = ref object of OpenApiRestCall_593424
proc url_RemediationsListForManagementGroup_593648(protocol: Scheme; host: string;
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

proc validate_RemediationsListForManagementGroup_593647(path: JsonNode;
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
  var valid_593835 = path.getOrDefault("managementGroupsNamespace")
  valid_593835 = validateParameter(valid_593835, JString, required = true,
                                 default = newJString("Microsoft.Management"))
  if valid_593835 != nil:
    section.add "managementGroupsNamespace", valid_593835
  var valid_593836 = path.getOrDefault("managementGroupId")
  valid_593836 = validateParameter(valid_593836, JString, required = true,
                                 default = nil)
  if valid_593836 != nil:
    section.add "managementGroupId", valid_593836
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
  var valid_593837 = query.getOrDefault("api-version")
  valid_593837 = validateParameter(valid_593837, JString, required = true,
                                 default = nil)
  if valid_593837 != nil:
    section.add "api-version", valid_593837
  var valid_593838 = query.getOrDefault("$top")
  valid_593838 = validateParameter(valid_593838, JInt, required = false, default = nil)
  if valid_593838 != nil:
    section.add "$top", valid_593838
  var valid_593839 = query.getOrDefault("$filter")
  valid_593839 = validateParameter(valid_593839, JString, required = false,
                                 default = nil)
  if valid_593839 != nil:
    section.add "$filter", valid_593839
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593862: Call_RemediationsListForManagementGroup_593646;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all remediations for the management group.
  ## 
  let valid = call_593862.validator(path, query, header, formData, body)
  let scheme = call_593862.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593862.url(scheme.get, call_593862.host, call_593862.base,
                         call_593862.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593862, url, valid)

proc call*(call_593933: Call_RemediationsListForManagementGroup_593646;
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
  var path_593934 = newJObject()
  var query_593936 = newJObject()
  add(path_593934, "managementGroupsNamespace",
      newJString(managementGroupsNamespace))
  add(query_593936, "api-version", newJString(apiVersion))
  add(path_593934, "managementGroupId", newJString(managementGroupId))
  add(query_593936, "$top", newJInt(Top))
  add(query_593936, "$filter", newJString(Filter))
  result = call_593933.call(path_593934, query_593936, nil, nil, nil)

var remediationsListForManagementGroup* = Call_RemediationsListForManagementGroup_593646(
    name: "remediationsListForManagementGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/{managementGroupsNamespace}/managementGroups/{managementGroupId}/providers/Microsoft.PolicyInsights/remediations",
    validator: validate_RemediationsListForManagementGroup_593647, base: "",
    url: url_RemediationsListForManagementGroup_593648, schemes: {Scheme.Https})
type
  Call_RemediationsCreateOrUpdateAtManagementGroup_593986 = ref object of OpenApiRestCall_593424
proc url_RemediationsCreateOrUpdateAtManagementGroup_593988(protocol: Scheme;
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

proc validate_RemediationsCreateOrUpdateAtManagementGroup_593987(path: JsonNode;
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
  var valid_594006 = path.getOrDefault("managementGroupsNamespace")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = newJString("Microsoft.Management"))
  if valid_594006 != nil:
    section.add "managementGroupsNamespace", valid_594006
  var valid_594007 = path.getOrDefault("managementGroupId")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "managementGroupId", valid_594007
  var valid_594008 = path.getOrDefault("remediationName")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "remediationName", valid_594008
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594009 = query.getOrDefault("api-version")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "api-version", valid_594009
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

proc call*(call_594011: Call_RemediationsCreateOrUpdateAtManagementGroup_593986;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a remediation at management group scope.
  ## 
  let valid = call_594011.validator(path, query, header, formData, body)
  let scheme = call_594011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594011.url(scheme.get, call_594011.host, call_594011.base,
                         call_594011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594011, url, valid)

proc call*(call_594012: Call_RemediationsCreateOrUpdateAtManagementGroup_593986;
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
  var path_594013 = newJObject()
  var query_594014 = newJObject()
  var body_594015 = newJObject()
  add(path_594013, "managementGroupsNamespace",
      newJString(managementGroupsNamespace))
  add(query_594014, "api-version", newJString(apiVersion))
  add(path_594013, "managementGroupId", newJString(managementGroupId))
  if parameters != nil:
    body_594015 = parameters
  add(path_594013, "remediationName", newJString(remediationName))
  result = call_594012.call(path_594013, query_594014, nil, nil, body_594015)

var remediationsCreateOrUpdateAtManagementGroup* = Call_RemediationsCreateOrUpdateAtManagementGroup_593986(
    name: "remediationsCreateOrUpdateAtManagementGroup", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/{managementGroupsNamespace}/managementGroups/{managementGroupId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}",
    validator: validate_RemediationsCreateOrUpdateAtManagementGroup_593987,
    base: "", url: url_RemediationsCreateOrUpdateAtManagementGroup_593988,
    schemes: {Scheme.Https})
type
  Call_RemediationsGetAtManagementGroup_593975 = ref object of OpenApiRestCall_593424
proc url_RemediationsGetAtManagementGroup_593977(protocol: Scheme; host: string;
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

proc validate_RemediationsGetAtManagementGroup_593976(path: JsonNode;
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
  var valid_593978 = path.getOrDefault("managementGroupsNamespace")
  valid_593978 = validateParameter(valid_593978, JString, required = true,
                                 default = newJString("Microsoft.Management"))
  if valid_593978 != nil:
    section.add "managementGroupsNamespace", valid_593978
  var valid_593979 = path.getOrDefault("managementGroupId")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "managementGroupId", valid_593979
  var valid_593980 = path.getOrDefault("remediationName")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "remediationName", valid_593980
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593981 = query.getOrDefault("api-version")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "api-version", valid_593981
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593982: Call_RemediationsGetAtManagementGroup_593975;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an existing remediation at management group scope.
  ## 
  let valid = call_593982.validator(path, query, header, formData, body)
  let scheme = call_593982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593982.url(scheme.get, call_593982.host, call_593982.base,
                         call_593982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593982, url, valid)

proc call*(call_593983: Call_RemediationsGetAtManagementGroup_593975;
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
  var path_593984 = newJObject()
  var query_593985 = newJObject()
  add(path_593984, "managementGroupsNamespace",
      newJString(managementGroupsNamespace))
  add(query_593985, "api-version", newJString(apiVersion))
  add(path_593984, "managementGroupId", newJString(managementGroupId))
  add(path_593984, "remediationName", newJString(remediationName))
  result = call_593983.call(path_593984, query_593985, nil, nil, nil)

var remediationsGetAtManagementGroup* = Call_RemediationsGetAtManagementGroup_593975(
    name: "remediationsGetAtManagementGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/{managementGroupsNamespace}/managementGroups/{managementGroupId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}",
    validator: validate_RemediationsGetAtManagementGroup_593976, base: "",
    url: url_RemediationsGetAtManagementGroup_593977, schemes: {Scheme.Https})
type
  Call_RemediationsDeleteAtManagementGroup_594016 = ref object of OpenApiRestCall_593424
proc url_RemediationsDeleteAtManagementGroup_594018(protocol: Scheme; host: string;
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

proc validate_RemediationsDeleteAtManagementGroup_594017(path: JsonNode;
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
  var valid_594019 = path.getOrDefault("managementGroupsNamespace")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = newJString("Microsoft.Management"))
  if valid_594019 != nil:
    section.add "managementGroupsNamespace", valid_594019
  var valid_594020 = path.getOrDefault("managementGroupId")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "managementGroupId", valid_594020
  var valid_594021 = path.getOrDefault("remediationName")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "remediationName", valid_594021
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594022 = query.getOrDefault("api-version")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "api-version", valid_594022
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594023: Call_RemediationsDeleteAtManagementGroup_594016;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing remediation at management group scope.
  ## 
  let valid = call_594023.validator(path, query, header, formData, body)
  let scheme = call_594023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594023.url(scheme.get, call_594023.host, call_594023.base,
                         call_594023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594023, url, valid)

proc call*(call_594024: Call_RemediationsDeleteAtManagementGroup_594016;
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
  var path_594025 = newJObject()
  var query_594026 = newJObject()
  add(path_594025, "managementGroupsNamespace",
      newJString(managementGroupsNamespace))
  add(query_594026, "api-version", newJString(apiVersion))
  add(path_594025, "managementGroupId", newJString(managementGroupId))
  add(path_594025, "remediationName", newJString(remediationName))
  result = call_594024.call(path_594025, query_594026, nil, nil, nil)

var remediationsDeleteAtManagementGroup* = Call_RemediationsDeleteAtManagementGroup_594016(
    name: "remediationsDeleteAtManagementGroup", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/{managementGroupsNamespace}/managementGroups/{managementGroupId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}",
    validator: validate_RemediationsDeleteAtManagementGroup_594017, base: "",
    url: url_RemediationsDeleteAtManagementGroup_594018, schemes: {Scheme.Https})
type
  Call_RemediationsCancelAtManagementGroup_594027 = ref object of OpenApiRestCall_593424
proc url_RemediationsCancelAtManagementGroup_594029(protocol: Scheme; host: string;
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

proc validate_RemediationsCancelAtManagementGroup_594028(path: JsonNode;
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
  var valid_594030 = path.getOrDefault("managementGroupsNamespace")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = newJString("Microsoft.Management"))
  if valid_594030 != nil:
    section.add "managementGroupsNamespace", valid_594030
  var valid_594031 = path.getOrDefault("managementGroupId")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "managementGroupId", valid_594031
  var valid_594032 = path.getOrDefault("remediationName")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "remediationName", valid_594032
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594033 = query.getOrDefault("api-version")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "api-version", valid_594033
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594034: Call_RemediationsCancelAtManagementGroup_594027;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels a remediation at management group scope.
  ## 
  let valid = call_594034.validator(path, query, header, formData, body)
  let scheme = call_594034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594034.url(scheme.get, call_594034.host, call_594034.base,
                         call_594034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594034, url, valid)

proc call*(call_594035: Call_RemediationsCancelAtManagementGroup_594027;
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
  var path_594036 = newJObject()
  var query_594037 = newJObject()
  add(path_594036, "managementGroupsNamespace",
      newJString(managementGroupsNamespace))
  add(query_594037, "api-version", newJString(apiVersion))
  add(path_594036, "managementGroupId", newJString(managementGroupId))
  add(path_594036, "remediationName", newJString(remediationName))
  result = call_594035.call(path_594036, query_594037, nil, nil, nil)

var remediationsCancelAtManagementGroup* = Call_RemediationsCancelAtManagementGroup_594027(
    name: "remediationsCancelAtManagementGroup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/{managementGroupsNamespace}/managementGroups/{managementGroupId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}/cancel",
    validator: validate_RemediationsCancelAtManagementGroup_594028, base: "",
    url: url_RemediationsCancelAtManagementGroup_594029, schemes: {Scheme.Https})
type
  Call_RemediationsListDeploymentsAtManagementGroup_594038 = ref object of OpenApiRestCall_593424
proc url_RemediationsListDeploymentsAtManagementGroup_594040(protocol: Scheme;
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

proc validate_RemediationsListDeploymentsAtManagementGroup_594039(path: JsonNode;
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
  var valid_594041 = path.getOrDefault("managementGroupsNamespace")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = newJString("Microsoft.Management"))
  if valid_594041 != nil:
    section.add "managementGroupsNamespace", valid_594041
  var valid_594042 = path.getOrDefault("managementGroupId")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "managementGroupId", valid_594042
  var valid_594043 = path.getOrDefault("remediationName")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "remediationName", valid_594043
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : Maximum number of records to return.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594044 = query.getOrDefault("api-version")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "api-version", valid_594044
  var valid_594045 = query.getOrDefault("$top")
  valid_594045 = validateParameter(valid_594045, JInt, required = false, default = nil)
  if valid_594045 != nil:
    section.add "$top", valid_594045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594046: Call_RemediationsListDeploymentsAtManagementGroup_594038;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all deployments for a remediation at management group scope.
  ## 
  let valid = call_594046.validator(path, query, header, formData, body)
  let scheme = call_594046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594046.url(scheme.get, call_594046.host, call_594046.base,
                         call_594046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594046, url, valid)

proc call*(call_594047: Call_RemediationsListDeploymentsAtManagementGroup_594038;
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
  var path_594048 = newJObject()
  var query_594049 = newJObject()
  add(path_594048, "managementGroupsNamespace",
      newJString(managementGroupsNamespace))
  add(query_594049, "api-version", newJString(apiVersion))
  add(path_594048, "managementGroupId", newJString(managementGroupId))
  add(query_594049, "$top", newJInt(Top))
  add(path_594048, "remediationName", newJString(remediationName))
  result = call_594047.call(path_594048, query_594049, nil, nil, nil)

var remediationsListDeploymentsAtManagementGroup* = Call_RemediationsListDeploymentsAtManagementGroup_594038(
    name: "remediationsListDeploymentsAtManagementGroup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/{managementGroupsNamespace}/managementGroups/{managementGroupId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}/listDeployments",
    validator: validate_RemediationsListDeploymentsAtManagementGroup_594039,
    base: "", url: url_RemediationsListDeploymentsAtManagementGroup_594040,
    schemes: {Scheme.Https})
type
  Call_RemediationsListForSubscription_594050 = ref object of OpenApiRestCall_593424
proc url_RemediationsListForSubscription_594052(protocol: Scheme; host: string;
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

proc validate_RemediationsListForSubscription_594051(path: JsonNode;
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
  var valid_594053 = path.getOrDefault("subscriptionId")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "subscriptionId", valid_594053
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
  var valid_594054 = query.getOrDefault("api-version")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "api-version", valid_594054
  var valid_594055 = query.getOrDefault("$top")
  valid_594055 = validateParameter(valid_594055, JInt, required = false, default = nil)
  if valid_594055 != nil:
    section.add "$top", valid_594055
  var valid_594056 = query.getOrDefault("$filter")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = nil)
  if valid_594056 != nil:
    section.add "$filter", valid_594056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594057: Call_RemediationsListForSubscription_594050;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all remediations for the subscription.
  ## 
  let valid = call_594057.validator(path, query, header, formData, body)
  let scheme = call_594057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594057.url(scheme.get, call_594057.host, call_594057.base,
                         call_594057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594057, url, valid)

proc call*(call_594058: Call_RemediationsListForSubscription_594050;
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
  var path_594059 = newJObject()
  var query_594060 = newJObject()
  add(query_594060, "api-version", newJString(apiVersion))
  add(path_594059, "subscriptionId", newJString(subscriptionId))
  add(query_594060, "$top", newJInt(Top))
  add(query_594060, "$filter", newJString(Filter))
  result = call_594058.call(path_594059, query_594060, nil, nil, nil)

var remediationsListForSubscription* = Call_RemediationsListForSubscription_594050(
    name: "remediationsListForSubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PolicyInsights/remediations",
    validator: validate_RemediationsListForSubscription_594051, base: "",
    url: url_RemediationsListForSubscription_594052, schemes: {Scheme.Https})
type
  Call_RemediationsCreateOrUpdateAtSubscription_594071 = ref object of OpenApiRestCall_593424
proc url_RemediationsCreateOrUpdateAtSubscription_594073(protocol: Scheme;
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

proc validate_RemediationsCreateOrUpdateAtSubscription_594072(path: JsonNode;
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
  var valid_594074 = path.getOrDefault("subscriptionId")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "subscriptionId", valid_594074
  var valid_594075 = path.getOrDefault("remediationName")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "remediationName", valid_594075
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594076 = query.getOrDefault("api-version")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "api-version", valid_594076
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

proc call*(call_594078: Call_RemediationsCreateOrUpdateAtSubscription_594071;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a remediation at subscription scope.
  ## 
  let valid = call_594078.validator(path, query, header, formData, body)
  let scheme = call_594078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594078.url(scheme.get, call_594078.host, call_594078.base,
                         call_594078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594078, url, valid)

proc call*(call_594079: Call_RemediationsCreateOrUpdateAtSubscription_594071;
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
  var path_594080 = newJObject()
  var query_594081 = newJObject()
  var body_594082 = newJObject()
  add(query_594081, "api-version", newJString(apiVersion))
  add(path_594080, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594082 = parameters
  add(path_594080, "remediationName", newJString(remediationName))
  result = call_594079.call(path_594080, query_594081, nil, nil, body_594082)

var remediationsCreateOrUpdateAtSubscription* = Call_RemediationsCreateOrUpdateAtSubscription_594071(
    name: "remediationsCreateOrUpdateAtSubscription", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}",
    validator: validate_RemediationsCreateOrUpdateAtSubscription_594072, base: "",
    url: url_RemediationsCreateOrUpdateAtSubscription_594073,
    schemes: {Scheme.Https})
type
  Call_RemediationsGetAtSubscription_594061 = ref object of OpenApiRestCall_593424
proc url_RemediationsGetAtSubscription_594063(protocol: Scheme; host: string;
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

proc validate_RemediationsGetAtSubscription_594062(path: JsonNode; query: JsonNode;
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
  var valid_594064 = path.getOrDefault("subscriptionId")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "subscriptionId", valid_594064
  var valid_594065 = path.getOrDefault("remediationName")
  valid_594065 = validateParameter(valid_594065, JString, required = true,
                                 default = nil)
  if valid_594065 != nil:
    section.add "remediationName", valid_594065
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594066 = query.getOrDefault("api-version")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "api-version", valid_594066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594067: Call_RemediationsGetAtSubscription_594061; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an existing remediation at subscription scope.
  ## 
  let valid = call_594067.validator(path, query, header, formData, body)
  let scheme = call_594067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594067.url(scheme.get, call_594067.host, call_594067.base,
                         call_594067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594067, url, valid)

proc call*(call_594068: Call_RemediationsGetAtSubscription_594061;
          apiVersion: string; subscriptionId: string; remediationName: string): Recallable =
  ## remediationsGetAtSubscription
  ## Gets an existing remediation at subscription scope.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_594069 = newJObject()
  var query_594070 = newJObject()
  add(query_594070, "api-version", newJString(apiVersion))
  add(path_594069, "subscriptionId", newJString(subscriptionId))
  add(path_594069, "remediationName", newJString(remediationName))
  result = call_594068.call(path_594069, query_594070, nil, nil, nil)

var remediationsGetAtSubscription* = Call_RemediationsGetAtSubscription_594061(
    name: "remediationsGetAtSubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}",
    validator: validate_RemediationsGetAtSubscription_594062, base: "",
    url: url_RemediationsGetAtSubscription_594063, schemes: {Scheme.Https})
type
  Call_RemediationsDeleteAtSubscription_594083 = ref object of OpenApiRestCall_593424
proc url_RemediationsDeleteAtSubscription_594085(protocol: Scheme; host: string;
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

proc validate_RemediationsDeleteAtSubscription_594084(path: JsonNode;
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
  var valid_594086 = path.getOrDefault("subscriptionId")
  valid_594086 = validateParameter(valid_594086, JString, required = true,
                                 default = nil)
  if valid_594086 != nil:
    section.add "subscriptionId", valid_594086
  var valid_594087 = path.getOrDefault("remediationName")
  valid_594087 = validateParameter(valid_594087, JString, required = true,
                                 default = nil)
  if valid_594087 != nil:
    section.add "remediationName", valid_594087
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594088 = query.getOrDefault("api-version")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "api-version", valid_594088
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594089: Call_RemediationsDeleteAtSubscription_594083;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing remediation at subscription scope.
  ## 
  let valid = call_594089.validator(path, query, header, formData, body)
  let scheme = call_594089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594089.url(scheme.get, call_594089.host, call_594089.base,
                         call_594089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594089, url, valid)

proc call*(call_594090: Call_RemediationsDeleteAtSubscription_594083;
          apiVersion: string; subscriptionId: string; remediationName: string): Recallable =
  ## remediationsDeleteAtSubscription
  ## Deletes an existing remediation at subscription scope.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_594091 = newJObject()
  var query_594092 = newJObject()
  add(query_594092, "api-version", newJString(apiVersion))
  add(path_594091, "subscriptionId", newJString(subscriptionId))
  add(path_594091, "remediationName", newJString(remediationName))
  result = call_594090.call(path_594091, query_594092, nil, nil, nil)

var remediationsDeleteAtSubscription* = Call_RemediationsDeleteAtSubscription_594083(
    name: "remediationsDeleteAtSubscription", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}",
    validator: validate_RemediationsDeleteAtSubscription_594084, base: "",
    url: url_RemediationsDeleteAtSubscription_594085, schemes: {Scheme.Https})
type
  Call_RemediationsCancelAtSubscription_594093 = ref object of OpenApiRestCall_593424
proc url_RemediationsCancelAtSubscription_594095(protocol: Scheme; host: string;
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

proc validate_RemediationsCancelAtSubscription_594094(path: JsonNode;
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
  var valid_594096 = path.getOrDefault("subscriptionId")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "subscriptionId", valid_594096
  var valid_594097 = path.getOrDefault("remediationName")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "remediationName", valid_594097
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594098 = query.getOrDefault("api-version")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "api-version", valid_594098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594099: Call_RemediationsCancelAtSubscription_594093;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels a remediation at subscription scope.
  ## 
  let valid = call_594099.validator(path, query, header, formData, body)
  let scheme = call_594099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594099.url(scheme.get, call_594099.host, call_594099.base,
                         call_594099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594099, url, valid)

proc call*(call_594100: Call_RemediationsCancelAtSubscription_594093;
          apiVersion: string; subscriptionId: string; remediationName: string): Recallable =
  ## remediationsCancelAtSubscription
  ## Cancels a remediation at subscription scope.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_594101 = newJObject()
  var query_594102 = newJObject()
  add(query_594102, "api-version", newJString(apiVersion))
  add(path_594101, "subscriptionId", newJString(subscriptionId))
  add(path_594101, "remediationName", newJString(remediationName))
  result = call_594100.call(path_594101, query_594102, nil, nil, nil)

var remediationsCancelAtSubscription* = Call_RemediationsCancelAtSubscription_594093(
    name: "remediationsCancelAtSubscription", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}/cancel",
    validator: validate_RemediationsCancelAtSubscription_594094, base: "",
    url: url_RemediationsCancelAtSubscription_594095, schemes: {Scheme.Https})
type
  Call_RemediationsListDeploymentsAtSubscription_594103 = ref object of OpenApiRestCall_593424
proc url_RemediationsListDeploymentsAtSubscription_594105(protocol: Scheme;
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

proc validate_RemediationsListDeploymentsAtSubscription_594104(path: JsonNode;
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
  var valid_594106 = path.getOrDefault("subscriptionId")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "subscriptionId", valid_594106
  var valid_594107 = path.getOrDefault("remediationName")
  valid_594107 = validateParameter(valid_594107, JString, required = true,
                                 default = nil)
  if valid_594107 != nil:
    section.add "remediationName", valid_594107
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : Maximum number of records to return.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594108 = query.getOrDefault("api-version")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "api-version", valid_594108
  var valid_594109 = query.getOrDefault("$top")
  valid_594109 = validateParameter(valid_594109, JInt, required = false, default = nil)
  if valid_594109 != nil:
    section.add "$top", valid_594109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594110: Call_RemediationsListDeploymentsAtSubscription_594103;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all deployments for a remediation at subscription scope.
  ## 
  let valid = call_594110.validator(path, query, header, formData, body)
  let scheme = call_594110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594110.url(scheme.get, call_594110.host, call_594110.base,
                         call_594110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594110, url, valid)

proc call*(call_594111: Call_RemediationsListDeploymentsAtSubscription_594103;
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
  var path_594112 = newJObject()
  var query_594113 = newJObject()
  add(query_594113, "api-version", newJString(apiVersion))
  add(path_594112, "subscriptionId", newJString(subscriptionId))
  add(query_594113, "$top", newJInt(Top))
  add(path_594112, "remediationName", newJString(remediationName))
  result = call_594111.call(path_594112, query_594113, nil, nil, nil)

var remediationsListDeploymentsAtSubscription* = Call_RemediationsListDeploymentsAtSubscription_594103(
    name: "remediationsListDeploymentsAtSubscription", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}/listDeployments",
    validator: validate_RemediationsListDeploymentsAtSubscription_594104,
    base: "", url: url_RemediationsListDeploymentsAtSubscription_594105,
    schemes: {Scheme.Https})
type
  Call_RemediationsListForResourceGroup_594114 = ref object of OpenApiRestCall_593424
proc url_RemediationsListForResourceGroup_594116(protocol: Scheme; host: string;
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

proc validate_RemediationsListForResourceGroup_594115(path: JsonNode;
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
  var valid_594117 = path.getOrDefault("resourceGroupName")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "resourceGroupName", valid_594117
  var valid_594118 = path.getOrDefault("subscriptionId")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "subscriptionId", valid_594118
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
  var valid_594119 = query.getOrDefault("api-version")
  valid_594119 = validateParameter(valid_594119, JString, required = true,
                                 default = nil)
  if valid_594119 != nil:
    section.add "api-version", valid_594119
  var valid_594120 = query.getOrDefault("$top")
  valid_594120 = validateParameter(valid_594120, JInt, required = false, default = nil)
  if valid_594120 != nil:
    section.add "$top", valid_594120
  var valid_594121 = query.getOrDefault("$filter")
  valid_594121 = validateParameter(valid_594121, JString, required = false,
                                 default = nil)
  if valid_594121 != nil:
    section.add "$filter", valid_594121
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594122: Call_RemediationsListForResourceGroup_594114;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all remediations for the subscription.
  ## 
  let valid = call_594122.validator(path, query, header, formData, body)
  let scheme = call_594122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594122.url(scheme.get, call_594122.host, call_594122.base,
                         call_594122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594122, url, valid)

proc call*(call_594123: Call_RemediationsListForResourceGroup_594114;
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
  var path_594124 = newJObject()
  var query_594125 = newJObject()
  add(path_594124, "resourceGroupName", newJString(resourceGroupName))
  add(query_594125, "api-version", newJString(apiVersion))
  add(path_594124, "subscriptionId", newJString(subscriptionId))
  add(query_594125, "$top", newJInt(Top))
  add(query_594125, "$filter", newJString(Filter))
  result = call_594123.call(path_594124, query_594125, nil, nil, nil)

var remediationsListForResourceGroup* = Call_RemediationsListForResourceGroup_594114(
    name: "remediationsListForResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PolicyInsights/remediations",
    validator: validate_RemediationsListForResourceGroup_594115, base: "",
    url: url_RemediationsListForResourceGroup_594116, schemes: {Scheme.Https})
type
  Call_RemediationsCreateOrUpdateAtResourceGroup_594137 = ref object of OpenApiRestCall_593424
proc url_RemediationsCreateOrUpdateAtResourceGroup_594139(protocol: Scheme;
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

proc validate_RemediationsCreateOrUpdateAtResourceGroup_594138(path: JsonNode;
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
  var valid_594140 = path.getOrDefault("resourceGroupName")
  valid_594140 = validateParameter(valid_594140, JString, required = true,
                                 default = nil)
  if valid_594140 != nil:
    section.add "resourceGroupName", valid_594140
  var valid_594141 = path.getOrDefault("subscriptionId")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "subscriptionId", valid_594141
  var valid_594142 = path.getOrDefault("remediationName")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "remediationName", valid_594142
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594143 = query.getOrDefault("api-version")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "api-version", valid_594143
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

proc call*(call_594145: Call_RemediationsCreateOrUpdateAtResourceGroup_594137;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a remediation at resource group scope.
  ## 
  let valid = call_594145.validator(path, query, header, formData, body)
  let scheme = call_594145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594145.url(scheme.get, call_594145.host, call_594145.base,
                         call_594145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594145, url, valid)

proc call*(call_594146: Call_RemediationsCreateOrUpdateAtResourceGroup_594137;
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
  var path_594147 = newJObject()
  var query_594148 = newJObject()
  var body_594149 = newJObject()
  add(path_594147, "resourceGroupName", newJString(resourceGroupName))
  add(query_594148, "api-version", newJString(apiVersion))
  add(path_594147, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594149 = parameters
  add(path_594147, "remediationName", newJString(remediationName))
  result = call_594146.call(path_594147, query_594148, nil, nil, body_594149)

var remediationsCreateOrUpdateAtResourceGroup* = Call_RemediationsCreateOrUpdateAtResourceGroup_594137(
    name: "remediationsCreateOrUpdateAtResourceGroup", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PolicyInsights/remediations/{remediationName}",
    validator: validate_RemediationsCreateOrUpdateAtResourceGroup_594138,
    base: "", url: url_RemediationsCreateOrUpdateAtResourceGroup_594139,
    schemes: {Scheme.Https})
type
  Call_RemediationsGetAtResourceGroup_594126 = ref object of OpenApiRestCall_593424
proc url_RemediationsGetAtResourceGroup_594128(protocol: Scheme; host: string;
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

proc validate_RemediationsGetAtResourceGroup_594127(path: JsonNode;
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
  var valid_594129 = path.getOrDefault("resourceGroupName")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "resourceGroupName", valid_594129
  var valid_594130 = path.getOrDefault("subscriptionId")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "subscriptionId", valid_594130
  var valid_594131 = path.getOrDefault("remediationName")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "remediationName", valid_594131
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594132 = query.getOrDefault("api-version")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "api-version", valid_594132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594133: Call_RemediationsGetAtResourceGroup_594126; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an existing remediation at resource group scope.
  ## 
  let valid = call_594133.validator(path, query, header, formData, body)
  let scheme = call_594133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594133.url(scheme.get, call_594133.host, call_594133.base,
                         call_594133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594133, url, valid)

proc call*(call_594134: Call_RemediationsGetAtResourceGroup_594126;
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
  var path_594135 = newJObject()
  var query_594136 = newJObject()
  add(path_594135, "resourceGroupName", newJString(resourceGroupName))
  add(query_594136, "api-version", newJString(apiVersion))
  add(path_594135, "subscriptionId", newJString(subscriptionId))
  add(path_594135, "remediationName", newJString(remediationName))
  result = call_594134.call(path_594135, query_594136, nil, nil, nil)

var remediationsGetAtResourceGroup* = Call_RemediationsGetAtResourceGroup_594126(
    name: "remediationsGetAtResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PolicyInsights/remediations/{remediationName}",
    validator: validate_RemediationsGetAtResourceGroup_594127, base: "",
    url: url_RemediationsGetAtResourceGroup_594128, schemes: {Scheme.Https})
type
  Call_RemediationsDeleteAtResourceGroup_594150 = ref object of OpenApiRestCall_593424
proc url_RemediationsDeleteAtResourceGroup_594152(protocol: Scheme; host: string;
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

proc validate_RemediationsDeleteAtResourceGroup_594151(path: JsonNode;
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
  var valid_594153 = path.getOrDefault("resourceGroupName")
  valid_594153 = validateParameter(valid_594153, JString, required = true,
                                 default = nil)
  if valid_594153 != nil:
    section.add "resourceGroupName", valid_594153
  var valid_594154 = path.getOrDefault("subscriptionId")
  valid_594154 = validateParameter(valid_594154, JString, required = true,
                                 default = nil)
  if valid_594154 != nil:
    section.add "subscriptionId", valid_594154
  var valid_594155 = path.getOrDefault("remediationName")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "remediationName", valid_594155
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594156 = query.getOrDefault("api-version")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = nil)
  if valid_594156 != nil:
    section.add "api-version", valid_594156
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594157: Call_RemediationsDeleteAtResourceGroup_594150;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing remediation at resource group scope.
  ## 
  let valid = call_594157.validator(path, query, header, formData, body)
  let scheme = call_594157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594157.url(scheme.get, call_594157.host, call_594157.base,
                         call_594157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594157, url, valid)

proc call*(call_594158: Call_RemediationsDeleteAtResourceGroup_594150;
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
  var path_594159 = newJObject()
  var query_594160 = newJObject()
  add(path_594159, "resourceGroupName", newJString(resourceGroupName))
  add(query_594160, "api-version", newJString(apiVersion))
  add(path_594159, "subscriptionId", newJString(subscriptionId))
  add(path_594159, "remediationName", newJString(remediationName))
  result = call_594158.call(path_594159, query_594160, nil, nil, nil)

var remediationsDeleteAtResourceGroup* = Call_RemediationsDeleteAtResourceGroup_594150(
    name: "remediationsDeleteAtResourceGroup", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PolicyInsights/remediations/{remediationName}",
    validator: validate_RemediationsDeleteAtResourceGroup_594151, base: "",
    url: url_RemediationsDeleteAtResourceGroup_594152, schemes: {Scheme.Https})
type
  Call_RemediationsCancelAtResourceGroup_594161 = ref object of OpenApiRestCall_593424
proc url_RemediationsCancelAtResourceGroup_594163(protocol: Scheme; host: string;
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

proc validate_RemediationsCancelAtResourceGroup_594162(path: JsonNode;
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
  var valid_594164 = path.getOrDefault("resourceGroupName")
  valid_594164 = validateParameter(valid_594164, JString, required = true,
                                 default = nil)
  if valid_594164 != nil:
    section.add "resourceGroupName", valid_594164
  var valid_594165 = path.getOrDefault("subscriptionId")
  valid_594165 = validateParameter(valid_594165, JString, required = true,
                                 default = nil)
  if valid_594165 != nil:
    section.add "subscriptionId", valid_594165
  var valid_594166 = path.getOrDefault("remediationName")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "remediationName", valid_594166
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594167 = query.getOrDefault("api-version")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "api-version", valid_594167
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594168: Call_RemediationsCancelAtResourceGroup_594161;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels a remediation at resource group scope.
  ## 
  let valid = call_594168.validator(path, query, header, formData, body)
  let scheme = call_594168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594168.url(scheme.get, call_594168.host, call_594168.base,
                         call_594168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594168, url, valid)

proc call*(call_594169: Call_RemediationsCancelAtResourceGroup_594161;
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
  var path_594170 = newJObject()
  var query_594171 = newJObject()
  add(path_594170, "resourceGroupName", newJString(resourceGroupName))
  add(query_594171, "api-version", newJString(apiVersion))
  add(path_594170, "subscriptionId", newJString(subscriptionId))
  add(path_594170, "remediationName", newJString(remediationName))
  result = call_594169.call(path_594170, query_594171, nil, nil, nil)

var remediationsCancelAtResourceGroup* = Call_RemediationsCancelAtResourceGroup_594161(
    name: "remediationsCancelAtResourceGroup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PolicyInsights/remediations/{remediationName}/cancel",
    validator: validate_RemediationsCancelAtResourceGroup_594162, base: "",
    url: url_RemediationsCancelAtResourceGroup_594163, schemes: {Scheme.Https})
type
  Call_RemediationsListDeploymentsAtResourceGroup_594172 = ref object of OpenApiRestCall_593424
proc url_RemediationsListDeploymentsAtResourceGroup_594174(protocol: Scheme;
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

proc validate_RemediationsListDeploymentsAtResourceGroup_594173(path: JsonNode;
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
  var valid_594175 = path.getOrDefault("resourceGroupName")
  valid_594175 = validateParameter(valid_594175, JString, required = true,
                                 default = nil)
  if valid_594175 != nil:
    section.add "resourceGroupName", valid_594175
  var valid_594176 = path.getOrDefault("subscriptionId")
  valid_594176 = validateParameter(valid_594176, JString, required = true,
                                 default = nil)
  if valid_594176 != nil:
    section.add "subscriptionId", valid_594176
  var valid_594177 = path.getOrDefault("remediationName")
  valid_594177 = validateParameter(valid_594177, JString, required = true,
                                 default = nil)
  if valid_594177 != nil:
    section.add "remediationName", valid_594177
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : Maximum number of records to return.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594178 = query.getOrDefault("api-version")
  valid_594178 = validateParameter(valid_594178, JString, required = true,
                                 default = nil)
  if valid_594178 != nil:
    section.add "api-version", valid_594178
  var valid_594179 = query.getOrDefault("$top")
  valid_594179 = validateParameter(valid_594179, JInt, required = false, default = nil)
  if valid_594179 != nil:
    section.add "$top", valid_594179
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594180: Call_RemediationsListDeploymentsAtResourceGroup_594172;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all deployments for a remediation at resource group scope.
  ## 
  let valid = call_594180.validator(path, query, header, formData, body)
  let scheme = call_594180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594180.url(scheme.get, call_594180.host, call_594180.base,
                         call_594180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594180, url, valid)

proc call*(call_594181: Call_RemediationsListDeploymentsAtResourceGroup_594172;
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
  var path_594182 = newJObject()
  var query_594183 = newJObject()
  add(path_594182, "resourceGroupName", newJString(resourceGroupName))
  add(query_594183, "api-version", newJString(apiVersion))
  add(path_594182, "subscriptionId", newJString(subscriptionId))
  add(query_594183, "$top", newJInt(Top))
  add(path_594182, "remediationName", newJString(remediationName))
  result = call_594181.call(path_594182, query_594183, nil, nil, nil)

var remediationsListDeploymentsAtResourceGroup* = Call_RemediationsListDeploymentsAtResourceGroup_594172(
    name: "remediationsListDeploymentsAtResourceGroup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PolicyInsights/remediations/{remediationName}/listDeployments",
    validator: validate_RemediationsListDeploymentsAtResourceGroup_594173,
    base: "", url: url_RemediationsListDeploymentsAtResourceGroup_594174,
    schemes: {Scheme.Https})
type
  Call_RemediationsListForResource_594184 = ref object of OpenApiRestCall_593424
proc url_RemediationsListForResource_594186(protocol: Scheme; host: string;
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

proc validate_RemediationsListForResource_594185(path: JsonNode; query: JsonNode;
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
  var valid_594187 = path.getOrDefault("resourceId")
  valid_594187 = validateParameter(valid_594187, JString, required = true,
                                 default = nil)
  if valid_594187 != nil:
    section.add "resourceId", valid_594187
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
  var valid_594188 = query.getOrDefault("api-version")
  valid_594188 = validateParameter(valid_594188, JString, required = true,
                                 default = nil)
  if valid_594188 != nil:
    section.add "api-version", valid_594188
  var valid_594189 = query.getOrDefault("$top")
  valid_594189 = validateParameter(valid_594189, JInt, required = false, default = nil)
  if valid_594189 != nil:
    section.add "$top", valid_594189
  var valid_594190 = query.getOrDefault("$filter")
  valid_594190 = validateParameter(valid_594190, JString, required = false,
                                 default = nil)
  if valid_594190 != nil:
    section.add "$filter", valid_594190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594191: Call_RemediationsListForResource_594184; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all remediations for a resource.
  ## 
  let valid = call_594191.validator(path, query, header, formData, body)
  let scheme = call_594191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594191.url(scheme.get, call_594191.host, call_594191.base,
                         call_594191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594191, url, valid)

proc call*(call_594192: Call_RemediationsListForResource_594184;
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
  var path_594193 = newJObject()
  var query_594194 = newJObject()
  add(query_594194, "api-version", newJString(apiVersion))
  add(query_594194, "$top", newJInt(Top))
  add(path_594193, "resourceId", newJString(resourceId))
  add(query_594194, "$filter", newJString(Filter))
  result = call_594192.call(path_594193, query_594194, nil, nil, nil)

var remediationsListForResource* = Call_RemediationsListForResource_594184(
    name: "remediationsListForResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{resourceId}/providers/Microsoft.PolicyInsights/remediations",
    validator: validate_RemediationsListForResource_594185, base: "",
    url: url_RemediationsListForResource_594186, schemes: {Scheme.Https})
type
  Call_RemediationsCreateOrUpdateAtResource_594205 = ref object of OpenApiRestCall_593424
proc url_RemediationsCreateOrUpdateAtResource_594207(protocol: Scheme;
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

proc validate_RemediationsCreateOrUpdateAtResource_594206(path: JsonNode;
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
  var valid_594208 = path.getOrDefault("resourceId")
  valid_594208 = validateParameter(valid_594208, JString, required = true,
                                 default = nil)
  if valid_594208 != nil:
    section.add "resourceId", valid_594208
  var valid_594209 = path.getOrDefault("remediationName")
  valid_594209 = validateParameter(valid_594209, JString, required = true,
                                 default = nil)
  if valid_594209 != nil:
    section.add "remediationName", valid_594209
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594210 = query.getOrDefault("api-version")
  valid_594210 = validateParameter(valid_594210, JString, required = true,
                                 default = nil)
  if valid_594210 != nil:
    section.add "api-version", valid_594210
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

proc call*(call_594212: Call_RemediationsCreateOrUpdateAtResource_594205;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a remediation at resource scope.
  ## 
  let valid = call_594212.validator(path, query, header, formData, body)
  let scheme = call_594212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594212.url(scheme.get, call_594212.host, call_594212.base,
                         call_594212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594212, url, valid)

proc call*(call_594213: Call_RemediationsCreateOrUpdateAtResource_594205;
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
  var path_594214 = newJObject()
  var query_594215 = newJObject()
  var body_594216 = newJObject()
  add(query_594215, "api-version", newJString(apiVersion))
  add(path_594214, "resourceId", newJString(resourceId))
  if parameters != nil:
    body_594216 = parameters
  add(path_594214, "remediationName", newJString(remediationName))
  result = call_594213.call(path_594214, query_594215, nil, nil, body_594216)

var remediationsCreateOrUpdateAtResource* = Call_RemediationsCreateOrUpdateAtResource_594205(
    name: "remediationsCreateOrUpdateAtResource", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}",
    validator: validate_RemediationsCreateOrUpdateAtResource_594206, base: "",
    url: url_RemediationsCreateOrUpdateAtResource_594207, schemes: {Scheme.Https})
type
  Call_RemediationsGetAtResource_594195 = ref object of OpenApiRestCall_593424
proc url_RemediationsGetAtResource_594197(protocol: Scheme; host: string;
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

proc validate_RemediationsGetAtResource_594196(path: JsonNode; query: JsonNode;
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
  var valid_594198 = path.getOrDefault("resourceId")
  valid_594198 = validateParameter(valid_594198, JString, required = true,
                                 default = nil)
  if valid_594198 != nil:
    section.add "resourceId", valid_594198
  var valid_594199 = path.getOrDefault("remediationName")
  valid_594199 = validateParameter(valid_594199, JString, required = true,
                                 default = nil)
  if valid_594199 != nil:
    section.add "remediationName", valid_594199
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594200 = query.getOrDefault("api-version")
  valid_594200 = validateParameter(valid_594200, JString, required = true,
                                 default = nil)
  if valid_594200 != nil:
    section.add "api-version", valid_594200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594201: Call_RemediationsGetAtResource_594195; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an existing remediation at resource scope.
  ## 
  let valid = call_594201.validator(path, query, header, formData, body)
  let scheme = call_594201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594201.url(scheme.get, call_594201.host, call_594201.base,
                         call_594201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594201, url, valid)

proc call*(call_594202: Call_RemediationsGetAtResource_594195; apiVersion: string;
          resourceId: string; remediationName: string): Recallable =
  ## remediationsGetAtResource
  ## Gets an existing remediation at resource scope.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   resourceId: string (required)
  ##             : Resource ID.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_594203 = newJObject()
  var query_594204 = newJObject()
  add(query_594204, "api-version", newJString(apiVersion))
  add(path_594203, "resourceId", newJString(resourceId))
  add(path_594203, "remediationName", newJString(remediationName))
  result = call_594202.call(path_594203, query_594204, nil, nil, nil)

var remediationsGetAtResource* = Call_RemediationsGetAtResource_594195(
    name: "remediationsGetAtResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}",
    validator: validate_RemediationsGetAtResource_594196, base: "",
    url: url_RemediationsGetAtResource_594197, schemes: {Scheme.Https})
type
  Call_RemediationsDeleteAtResource_594217 = ref object of OpenApiRestCall_593424
proc url_RemediationsDeleteAtResource_594219(protocol: Scheme; host: string;
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

proc validate_RemediationsDeleteAtResource_594218(path: JsonNode; query: JsonNode;
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
  var valid_594220 = path.getOrDefault("resourceId")
  valid_594220 = validateParameter(valid_594220, JString, required = true,
                                 default = nil)
  if valid_594220 != nil:
    section.add "resourceId", valid_594220
  var valid_594221 = path.getOrDefault("remediationName")
  valid_594221 = validateParameter(valid_594221, JString, required = true,
                                 default = nil)
  if valid_594221 != nil:
    section.add "remediationName", valid_594221
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594222 = query.getOrDefault("api-version")
  valid_594222 = validateParameter(valid_594222, JString, required = true,
                                 default = nil)
  if valid_594222 != nil:
    section.add "api-version", valid_594222
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594223: Call_RemediationsDeleteAtResource_594217; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing remediation at individual resource scope.
  ## 
  let valid = call_594223.validator(path, query, header, formData, body)
  let scheme = call_594223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594223.url(scheme.get, call_594223.host, call_594223.base,
                         call_594223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594223, url, valid)

proc call*(call_594224: Call_RemediationsDeleteAtResource_594217;
          apiVersion: string; resourceId: string; remediationName: string): Recallable =
  ## remediationsDeleteAtResource
  ## Deletes an existing remediation at individual resource scope.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   resourceId: string (required)
  ##             : Resource ID.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_594225 = newJObject()
  var query_594226 = newJObject()
  add(query_594226, "api-version", newJString(apiVersion))
  add(path_594225, "resourceId", newJString(resourceId))
  add(path_594225, "remediationName", newJString(remediationName))
  result = call_594224.call(path_594225, query_594226, nil, nil, nil)

var remediationsDeleteAtResource* = Call_RemediationsDeleteAtResource_594217(
    name: "remediationsDeleteAtResource", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}",
    validator: validate_RemediationsDeleteAtResource_594218, base: "",
    url: url_RemediationsDeleteAtResource_594219, schemes: {Scheme.Https})
type
  Call_RemediationsCancelAtResource_594227 = ref object of OpenApiRestCall_593424
proc url_RemediationsCancelAtResource_594229(protocol: Scheme; host: string;
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

proc validate_RemediationsCancelAtResource_594228(path: JsonNode; query: JsonNode;
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
  var valid_594230 = path.getOrDefault("resourceId")
  valid_594230 = validateParameter(valid_594230, JString, required = true,
                                 default = nil)
  if valid_594230 != nil:
    section.add "resourceId", valid_594230
  var valid_594231 = path.getOrDefault("remediationName")
  valid_594231 = validateParameter(valid_594231, JString, required = true,
                                 default = nil)
  if valid_594231 != nil:
    section.add "remediationName", valid_594231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594232 = query.getOrDefault("api-version")
  valid_594232 = validateParameter(valid_594232, JString, required = true,
                                 default = nil)
  if valid_594232 != nil:
    section.add "api-version", valid_594232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594233: Call_RemediationsCancelAtResource_594227; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancel a remediation at resource scope.
  ## 
  let valid = call_594233.validator(path, query, header, formData, body)
  let scheme = call_594233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594233.url(scheme.get, call_594233.host, call_594233.base,
                         call_594233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594233, url, valid)

proc call*(call_594234: Call_RemediationsCancelAtResource_594227;
          apiVersion: string; resourceId: string; remediationName: string): Recallable =
  ## remediationsCancelAtResource
  ## Cancel a remediation at resource scope.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   resourceId: string (required)
  ##             : Resource ID.
  ##   remediationName: string (required)
  ##                  : The name of the remediation.
  var path_594235 = newJObject()
  var query_594236 = newJObject()
  add(query_594236, "api-version", newJString(apiVersion))
  add(path_594235, "resourceId", newJString(resourceId))
  add(path_594235, "remediationName", newJString(remediationName))
  result = call_594234.call(path_594235, query_594236, nil, nil, nil)

var remediationsCancelAtResource* = Call_RemediationsCancelAtResource_594227(
    name: "remediationsCancelAtResource", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}/cancel",
    validator: validate_RemediationsCancelAtResource_594228, base: "",
    url: url_RemediationsCancelAtResource_594229, schemes: {Scheme.Https})
type
  Call_RemediationsListDeploymentsAtResource_594237 = ref object of OpenApiRestCall_593424
proc url_RemediationsListDeploymentsAtResource_594239(protocol: Scheme;
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

proc validate_RemediationsListDeploymentsAtResource_594238(path: JsonNode;
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
  var valid_594240 = path.getOrDefault("resourceId")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = nil)
  if valid_594240 != nil:
    section.add "resourceId", valid_594240
  var valid_594241 = path.getOrDefault("remediationName")
  valid_594241 = validateParameter(valid_594241, JString, required = true,
                                 default = nil)
  if valid_594241 != nil:
    section.add "remediationName", valid_594241
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : Maximum number of records to return.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594242 = query.getOrDefault("api-version")
  valid_594242 = validateParameter(valid_594242, JString, required = true,
                                 default = nil)
  if valid_594242 != nil:
    section.add "api-version", valid_594242
  var valid_594243 = query.getOrDefault("$top")
  valid_594243 = validateParameter(valid_594243, JInt, required = false, default = nil)
  if valid_594243 != nil:
    section.add "$top", valid_594243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594244: Call_RemediationsListDeploymentsAtResource_594237;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all deployments for a remediation at resource scope.
  ## 
  let valid = call_594244.validator(path, query, header, formData, body)
  let scheme = call_594244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594244.url(scheme.get, call_594244.host, call_594244.base,
                         call_594244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594244, url, valid)

proc call*(call_594245: Call_RemediationsListDeploymentsAtResource_594237;
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
  var path_594246 = newJObject()
  var query_594247 = newJObject()
  add(query_594247, "api-version", newJString(apiVersion))
  add(query_594247, "$top", newJInt(Top))
  add(path_594246, "resourceId", newJString(resourceId))
  add(path_594246, "remediationName", newJString(remediationName))
  result = call_594245.call(path_594246, query_594247, nil, nil, nil)

var remediationsListDeploymentsAtResource* = Call_RemediationsListDeploymentsAtResource_594237(
    name: "remediationsListDeploymentsAtResource", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.PolicyInsights/remediations/{remediationName}/listDeployments",
    validator: validate_RemediationsListDeploymentsAtResource_594238, base: "",
    url: url_RemediationsListDeploymentsAtResource_594239, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
