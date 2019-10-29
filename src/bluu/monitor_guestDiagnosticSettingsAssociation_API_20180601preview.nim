
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Guest Diagnostic Settings Association
## version: 2018-06-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## API to Add/Remove/List Guest Diagnostics Settings Association for Azure Resources
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

  OpenApiRestCall_563540 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563540](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563540): Option[Scheme] {.used.} =
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
  macServiceName = "monitor-guestDiagnosticSettingsAssociation_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GuestDiagnosticsSettingsAssociationList_563762 = ref object of OpenApiRestCall_563540
proc url_GuestDiagnosticsSettingsAssociationList_563764(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/guestDiagnosticSettingsAssociations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GuestDiagnosticsSettingsAssociationList_563763(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a list of all guest diagnostic settings association in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563939 = path.getOrDefault("subscriptionId")
  valid_563939 = validateParameter(valid_563939, JString, required = true,
                                 default = nil)
  if valid_563939 != nil:
    section.add "subscriptionId", valid_563939
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563940 = query.getOrDefault("api-version")
  valid_563940 = validateParameter(valid_563940, JString, required = true,
                                 default = nil)
  if valid_563940 != nil:
    section.add "api-version", valid_563940
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563963: Call_GuestDiagnosticsSettingsAssociationList_563762;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a list of all guest diagnostic settings association in a subscription.
  ## 
  let valid = call_563963.validator(path, query, header, formData, body)
  let scheme = call_563963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563963.url(scheme.get, call_563963.host, call_563963.base,
                         call_563963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563963, url, valid)

proc call*(call_564034: Call_GuestDiagnosticsSettingsAssociationList_563762;
          apiVersion: string; subscriptionId: string): Recallable =
  ## guestDiagnosticsSettingsAssociationList
  ## Get a list of all guest diagnostic settings association in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription Id.
  var path_564035 = newJObject()
  var query_564037 = newJObject()
  add(query_564037, "api-version", newJString(apiVersion))
  add(path_564035, "subscriptionId", newJString(subscriptionId))
  result = call_564034.call(path_564035, query_564037, nil, nil, nil)

var guestDiagnosticsSettingsAssociationList* = Call_GuestDiagnosticsSettingsAssociationList_563762(
    name: "guestDiagnosticsSettingsAssociationList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/microsoft.insights/guestDiagnosticSettingsAssociations",
    validator: validate_GuestDiagnosticsSettingsAssociationList_563763, base: "",
    url: url_GuestDiagnosticsSettingsAssociationList_563764,
    schemes: {Scheme.Https})
type
  Call_GuestDiagnosticsSettingsAssociationListByResourceGroup_564076 = ref object of OpenApiRestCall_563540
proc url_GuestDiagnosticsSettingsAssociationListByResourceGroup_564078(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/microsoft.insights/guestDiagnosticSettingsAssociations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GuestDiagnosticsSettingsAssociationListByResourceGroup_564077(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get a list of all guest diagnostic settings association in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564079 = path.getOrDefault("subscriptionId")
  valid_564079 = validateParameter(valid_564079, JString, required = true,
                                 default = nil)
  if valid_564079 != nil:
    section.add "subscriptionId", valid_564079
  var valid_564080 = path.getOrDefault("resourceGroupName")
  valid_564080 = validateParameter(valid_564080, JString, required = true,
                                 default = nil)
  if valid_564080 != nil:
    section.add "resourceGroupName", valid_564080
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564081 = query.getOrDefault("api-version")
  valid_564081 = validateParameter(valid_564081, JString, required = true,
                                 default = nil)
  if valid_564081 != nil:
    section.add "api-version", valid_564081
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564082: Call_GuestDiagnosticsSettingsAssociationListByResourceGroup_564076;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a list of all guest diagnostic settings association in a resource group.
  ## 
  let valid = call_564082.validator(path, query, header, formData, body)
  let scheme = call_564082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564082.url(scheme.get, call_564082.host, call_564082.base,
                         call_564082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564082, url, valid)

proc call*(call_564083: Call_GuestDiagnosticsSettingsAssociationListByResourceGroup_564076;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## guestDiagnosticsSettingsAssociationListByResourceGroup
  ## Get a list of all guest diagnostic settings association in a resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564084 = newJObject()
  var query_564085 = newJObject()
  add(query_564085, "api-version", newJString(apiVersion))
  add(path_564084, "subscriptionId", newJString(subscriptionId))
  add(path_564084, "resourceGroupName", newJString(resourceGroupName))
  result = call_564083.call(path_564084, query_564085, nil, nil, nil)

var guestDiagnosticsSettingsAssociationListByResourceGroup* = Call_GuestDiagnosticsSettingsAssociationListByResourceGroup_564076(
    name: "guestDiagnosticsSettingsAssociationListByResourceGroup",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.insights/guestDiagnosticSettingsAssociations",
    validator: validate_GuestDiagnosticsSettingsAssociationListByResourceGroup_564077,
    base: "", url: url_GuestDiagnosticsSettingsAssociationListByResourceGroup_564078,
    schemes: {Scheme.Https})
type
  Call_GuestDiagnosticsSettingsAssociationCreateOrUpdate_564096 = ref object of OpenApiRestCall_563540
proc url_GuestDiagnosticsSettingsAssociationCreateOrUpdate_564098(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  assert "associationName" in path, "`associationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/guestDiagnosticSettingsAssociation/"),
               (kind: VariableSegment, value: "associationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GuestDiagnosticsSettingsAssociationCreateOrUpdate_564097(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates or updates guest diagnostics settings association.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   associationName: JString (required)
  ##                  : The name of the diagnostic settings association.
  ##   resourceUri: JString (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `associationName` field"
  var valid_564099 = path.getOrDefault("associationName")
  valid_564099 = validateParameter(valid_564099, JString, required = true,
                                 default = nil)
  if valid_564099 != nil:
    section.add "associationName", valid_564099
  var valid_564100 = path.getOrDefault("resourceUri")
  valid_564100 = validateParameter(valid_564100, JString, required = true,
                                 default = nil)
  if valid_564100 != nil:
    section.add "resourceUri", valid_564100
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564101 = query.getOrDefault("api-version")
  valid_564101 = validateParameter(valid_564101, JString, required = true,
                                 default = nil)
  if valid_564101 != nil:
    section.add "api-version", valid_564101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   diagnosticSettingsAssociation: JObject (required)
  ##                                : The diagnostic settings association to create or update.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564103: Call_GuestDiagnosticsSettingsAssociationCreateOrUpdate_564096;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates guest diagnostics settings association.
  ## 
  let valid = call_564103.validator(path, query, header, formData, body)
  let scheme = call_564103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564103.url(scheme.get, call_564103.host, call_564103.base,
                         call_564103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564103, url, valid)

proc call*(call_564104: Call_GuestDiagnosticsSettingsAssociationCreateOrUpdate_564096;
          diagnosticSettingsAssociation: JsonNode; apiVersion: string;
          associationName: string; resourceUri: string): Recallable =
  ## guestDiagnosticsSettingsAssociationCreateOrUpdate
  ## Creates or updates guest diagnostics settings association.
  ##   diagnosticSettingsAssociation: JObject (required)
  ##                                : The diagnostic settings association to create or update.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   associationName: string (required)
  ##                  : The name of the diagnostic settings association.
  ##   resourceUri: string (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type.
  var path_564105 = newJObject()
  var query_564106 = newJObject()
  var body_564107 = newJObject()
  if diagnosticSettingsAssociation != nil:
    body_564107 = diagnosticSettingsAssociation
  add(query_564106, "api-version", newJString(apiVersion))
  add(path_564105, "associationName", newJString(associationName))
  add(path_564105, "resourceUri", newJString(resourceUri))
  result = call_564104.call(path_564105, query_564106, nil, nil, body_564107)

var guestDiagnosticsSettingsAssociationCreateOrUpdate* = Call_GuestDiagnosticsSettingsAssociationCreateOrUpdate_564096(
    name: "guestDiagnosticsSettingsAssociationCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/{resourceUri}/providers/microsoft.insights/guestDiagnosticSettingsAssociation/{associationName}",
    validator: validate_GuestDiagnosticsSettingsAssociationCreateOrUpdate_564097,
    base: "", url: url_GuestDiagnosticsSettingsAssociationCreateOrUpdate_564098,
    schemes: {Scheme.Https})
type
  Call_GuestDiagnosticsSettingsAssociationGet_564086 = ref object of OpenApiRestCall_563540
proc url_GuestDiagnosticsSettingsAssociationGet_564088(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  assert "associationName" in path, "`associationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/guestDiagnosticSettingsAssociation/"),
               (kind: VariableSegment, value: "associationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GuestDiagnosticsSettingsAssociationGet_564087(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets guest diagnostics association settings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   associationName: JString (required)
  ##                  : The name of the diagnostic settings association.
  ##   resourceUri: JString (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `associationName` field"
  var valid_564089 = path.getOrDefault("associationName")
  valid_564089 = validateParameter(valid_564089, JString, required = true,
                                 default = nil)
  if valid_564089 != nil:
    section.add "associationName", valid_564089
  var valid_564090 = path.getOrDefault("resourceUri")
  valid_564090 = validateParameter(valid_564090, JString, required = true,
                                 default = nil)
  if valid_564090 != nil:
    section.add "resourceUri", valid_564090
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564091 = query.getOrDefault("api-version")
  valid_564091 = validateParameter(valid_564091, JString, required = true,
                                 default = nil)
  if valid_564091 != nil:
    section.add "api-version", valid_564091
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564092: Call_GuestDiagnosticsSettingsAssociationGet_564086;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets guest diagnostics association settings.
  ## 
  let valid = call_564092.validator(path, query, header, formData, body)
  let scheme = call_564092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564092.url(scheme.get, call_564092.host, call_564092.base,
                         call_564092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564092, url, valid)

proc call*(call_564093: Call_GuestDiagnosticsSettingsAssociationGet_564086;
          apiVersion: string; associationName: string; resourceUri: string): Recallable =
  ## guestDiagnosticsSettingsAssociationGet
  ## Gets guest diagnostics association settings.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   associationName: string (required)
  ##                  : The name of the diagnostic settings association.
  ##   resourceUri: string (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type.
  var path_564094 = newJObject()
  var query_564095 = newJObject()
  add(query_564095, "api-version", newJString(apiVersion))
  add(path_564094, "associationName", newJString(associationName))
  add(path_564094, "resourceUri", newJString(resourceUri))
  result = call_564093.call(path_564094, query_564095, nil, nil, nil)

var guestDiagnosticsSettingsAssociationGet* = Call_GuestDiagnosticsSettingsAssociationGet_564086(
    name: "guestDiagnosticsSettingsAssociationGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{resourceUri}/providers/microsoft.insights/guestDiagnosticSettingsAssociation/{associationName}",
    validator: validate_GuestDiagnosticsSettingsAssociationGet_564087, base: "",
    url: url_GuestDiagnosticsSettingsAssociationGet_564088,
    schemes: {Scheme.Https})
type
  Call_GuestDiagnosticsSettingsAssociationUpdate_564118 = ref object of OpenApiRestCall_563540
proc url_GuestDiagnosticsSettingsAssociationUpdate_564120(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  assert "associationName" in path, "`associationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/guestDiagnosticSettingsAssociation/"),
               (kind: VariableSegment, value: "associationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GuestDiagnosticsSettingsAssociationUpdate_564119(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing guestDiagnosticsSettingsAssociation Resource. To update other fields use the CreateOrUpdate method
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   associationName: JString (required)
  ##                  : The name of the diagnostic settings association.
  ##   resourceUri: JString (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `associationName` field"
  var valid_564138 = path.getOrDefault("associationName")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "associationName", valid_564138
  var valid_564139 = path.getOrDefault("resourceUri")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "resourceUri", valid_564139
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564140 = query.getOrDefault("api-version")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "api-version", valid_564140
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564142: Call_GuestDiagnosticsSettingsAssociationUpdate_564118;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing guestDiagnosticsSettingsAssociation Resource. To update other fields use the CreateOrUpdate method
  ## 
  let valid = call_564142.validator(path, query, header, formData, body)
  let scheme = call_564142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564142.url(scheme.get, call_564142.host, call_564142.base,
                         call_564142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564142, url, valid)

proc call*(call_564143: Call_GuestDiagnosticsSettingsAssociationUpdate_564118;
          apiVersion: string; associationName: string; resourceUri: string;
          parameters: JsonNode): Recallable =
  ## guestDiagnosticsSettingsAssociationUpdate
  ## Updates an existing guestDiagnosticsSettingsAssociation Resource. To update other fields use the CreateOrUpdate method
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   associationName: string (required)
  ##                  : The name of the diagnostic settings association.
  ##   resourceUri: string (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the operation.
  var path_564144 = newJObject()
  var query_564145 = newJObject()
  var body_564146 = newJObject()
  add(query_564145, "api-version", newJString(apiVersion))
  add(path_564144, "associationName", newJString(associationName))
  add(path_564144, "resourceUri", newJString(resourceUri))
  if parameters != nil:
    body_564146 = parameters
  result = call_564143.call(path_564144, query_564145, nil, nil, body_564146)

var guestDiagnosticsSettingsAssociationUpdate* = Call_GuestDiagnosticsSettingsAssociationUpdate_564118(
    name: "guestDiagnosticsSettingsAssociationUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/{resourceUri}/providers/microsoft.insights/guestDiagnosticSettingsAssociation/{associationName}",
    validator: validate_GuestDiagnosticsSettingsAssociationUpdate_564119,
    base: "", url: url_GuestDiagnosticsSettingsAssociationUpdate_564120,
    schemes: {Scheme.Https})
type
  Call_GuestDiagnosticsSettingsAssociationDelete_564108 = ref object of OpenApiRestCall_563540
proc url_GuestDiagnosticsSettingsAssociationDelete_564110(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  assert "associationName" in path, "`associationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/guestDiagnosticSettingsAssociation/"),
               (kind: VariableSegment, value: "associationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GuestDiagnosticsSettingsAssociationDelete_564109(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete guest diagnostics association settings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   associationName: JString (required)
  ##                  : The name of the diagnostic settings association.
  ##   resourceUri: JString (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `associationName` field"
  var valid_564111 = path.getOrDefault("associationName")
  valid_564111 = validateParameter(valid_564111, JString, required = true,
                                 default = nil)
  if valid_564111 != nil:
    section.add "associationName", valid_564111
  var valid_564112 = path.getOrDefault("resourceUri")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = nil)
  if valid_564112 != nil:
    section.add "resourceUri", valid_564112
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564113 = query.getOrDefault("api-version")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "api-version", valid_564113
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564114: Call_GuestDiagnosticsSettingsAssociationDelete_564108;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete guest diagnostics association settings.
  ## 
  let valid = call_564114.validator(path, query, header, formData, body)
  let scheme = call_564114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564114.url(scheme.get, call_564114.host, call_564114.base,
                         call_564114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564114, url, valid)

proc call*(call_564115: Call_GuestDiagnosticsSettingsAssociationDelete_564108;
          apiVersion: string; associationName: string; resourceUri: string): Recallable =
  ## guestDiagnosticsSettingsAssociationDelete
  ## Delete guest diagnostics association settings.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   associationName: string (required)
  ##                  : The name of the diagnostic settings association.
  ##   resourceUri: string (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type.
  var path_564116 = newJObject()
  var query_564117 = newJObject()
  add(query_564117, "api-version", newJString(apiVersion))
  add(path_564116, "associationName", newJString(associationName))
  add(path_564116, "resourceUri", newJString(resourceUri))
  result = call_564115.call(path_564116, query_564117, nil, nil, nil)

var guestDiagnosticsSettingsAssociationDelete* = Call_GuestDiagnosticsSettingsAssociationDelete_564108(
    name: "guestDiagnosticsSettingsAssociationDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/{resourceUri}/providers/microsoft.insights/guestDiagnosticSettingsAssociation/{associationName}",
    validator: validate_GuestDiagnosticsSettingsAssociationDelete_564109,
    base: "", url: url_GuestDiagnosticsSettingsAssociationDelete_564110,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
