
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: DevTestLabsClient
## version: 2015-05-21-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure DevTest Labs REST API version 2015-05-21-preview.
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

  OpenApiRestCall_593421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593421): Option[Scheme] {.used.} =
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
  macServiceName = "devtestlabs-DTL"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_LabListBySubscription_593643 = ref object of OpenApiRestCall_593421
proc url_LabListBySubscription_593645(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabListBySubscription_593644(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List labs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593819 = path.getOrDefault("subscriptionId")
  valid_593819 = validateParameter(valid_593819, JString, required = true,
                                 default = nil)
  if valid_593819 != nil:
    section.add "subscriptionId", valid_593819
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##   $orderBy: JString
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593833 = query.getOrDefault("api-version")
  valid_593833 = validateParameter(valid_593833, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_593833 != nil:
    section.add "api-version", valid_593833
  var valid_593834 = query.getOrDefault("$top")
  valid_593834 = validateParameter(valid_593834, JInt, required = false, default = nil)
  if valid_593834 != nil:
    section.add "$top", valid_593834
  var valid_593835 = query.getOrDefault("$orderBy")
  valid_593835 = validateParameter(valid_593835, JString, required = false,
                                 default = nil)
  if valid_593835 != nil:
    section.add "$orderBy", valid_593835
  var valid_593836 = query.getOrDefault("$filter")
  valid_593836 = validateParameter(valid_593836, JString, required = false,
                                 default = nil)
  if valid_593836 != nil:
    section.add "$filter", valid_593836
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593859: Call_LabListBySubscription_593643; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List labs.
  ## 
  let valid = call_593859.validator(path, query, header, formData, body)
  let scheme = call_593859.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593859.url(scheme.get, call_593859.host, call_593859.base,
                         call_593859.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593859, url, valid)

proc call*(call_593930: Call_LabListBySubscription_593643; subscriptionId: string;
          apiVersion: string = "2015-05-21-preview"; Top: int = 0; OrderBy: string = "";
          Filter: string = ""): Recallable =
  ## labListBySubscription
  ## List labs.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##   OrderBy: string
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_593931 = newJObject()
  var query_593933 = newJObject()
  add(query_593933, "api-version", newJString(apiVersion))
  add(path_593931, "subscriptionId", newJString(subscriptionId))
  add(query_593933, "$top", newJInt(Top))
  add(query_593933, "$orderBy", newJString(OrderBy))
  add(query_593933, "$filter", newJString(Filter))
  result = call_593930.call(path_593931, query_593933, nil, nil, nil)

var labListBySubscription* = Call_LabListBySubscription_593643(
    name: "labListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DevTestLab/labs",
    validator: validate_LabListBySubscription_593644, base: "",
    url: url_LabListBySubscription_593645, schemes: {Scheme.Https})
type
  Call_LabListByResourceGroup_593972 = ref object of OpenApiRestCall_593421
proc url_LabListByResourceGroup_593974(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabListByResourceGroup_593973(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List labs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593975 = path.getOrDefault("resourceGroupName")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "resourceGroupName", valid_593975
  var valid_593976 = path.getOrDefault("subscriptionId")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "subscriptionId", valid_593976
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##   $orderBy: JString
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593977 = query.getOrDefault("api-version")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_593977 != nil:
    section.add "api-version", valid_593977
  var valid_593978 = query.getOrDefault("$top")
  valid_593978 = validateParameter(valid_593978, JInt, required = false, default = nil)
  if valid_593978 != nil:
    section.add "$top", valid_593978
  var valid_593979 = query.getOrDefault("$orderBy")
  valid_593979 = validateParameter(valid_593979, JString, required = false,
                                 default = nil)
  if valid_593979 != nil:
    section.add "$orderBy", valid_593979
  var valid_593980 = query.getOrDefault("$filter")
  valid_593980 = validateParameter(valid_593980, JString, required = false,
                                 default = nil)
  if valid_593980 != nil:
    section.add "$filter", valid_593980
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593981: Call_LabListByResourceGroup_593972; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List labs.
  ## 
  let valid = call_593981.validator(path, query, header, formData, body)
  let scheme = call_593981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593981.url(scheme.get, call_593981.host, call_593981.base,
                         call_593981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593981, url, valid)

proc call*(call_593982: Call_LabListByResourceGroup_593972;
          resourceGroupName: string; subscriptionId: string;
          apiVersion: string = "2015-05-21-preview"; Top: int = 0; OrderBy: string = "";
          Filter: string = ""): Recallable =
  ## labListByResourceGroup
  ## List labs.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##   OrderBy: string
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_593983 = newJObject()
  var query_593984 = newJObject()
  add(path_593983, "resourceGroupName", newJString(resourceGroupName))
  add(query_593984, "api-version", newJString(apiVersion))
  add(path_593983, "subscriptionId", newJString(subscriptionId))
  add(query_593984, "$top", newJInt(Top))
  add(query_593984, "$orderBy", newJString(OrderBy))
  add(query_593984, "$filter", newJString(Filter))
  result = call_593982.call(path_593983, query_593984, nil, nil, nil)

var labListByResourceGroup* = Call_LabListByResourceGroup_593972(
    name: "labListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs",
    validator: validate_LabListByResourceGroup_593973, base: "",
    url: url_LabListByResourceGroup_593974, schemes: {Scheme.Https})
type
  Call_ArtifactSourceList_593985 = ref object of OpenApiRestCall_593421
proc url_ArtifactSourceList_593987(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/artifactsources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactSourceList_593986(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## List artifact sources.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593988 = path.getOrDefault("resourceGroupName")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "resourceGroupName", valid_593988
  var valid_593989 = path.getOrDefault("subscriptionId")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = nil)
  if valid_593989 != nil:
    section.add "subscriptionId", valid_593989
  var valid_593990 = path.getOrDefault("labName")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "labName", valid_593990
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##   $orderBy: JString
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593991 = query.getOrDefault("api-version")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_593991 != nil:
    section.add "api-version", valid_593991
  var valid_593992 = query.getOrDefault("$top")
  valid_593992 = validateParameter(valid_593992, JInt, required = false, default = nil)
  if valid_593992 != nil:
    section.add "$top", valid_593992
  var valid_593993 = query.getOrDefault("$orderBy")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = nil)
  if valid_593993 != nil:
    section.add "$orderBy", valid_593993
  var valid_593994 = query.getOrDefault("$filter")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "$filter", valid_593994
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593995: Call_ArtifactSourceList_593985; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List artifact sources.
  ## 
  let valid = call_593995.validator(path, query, header, formData, body)
  let scheme = call_593995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593995.url(scheme.get, call_593995.host, call_593995.base,
                         call_593995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593995, url, valid)

proc call*(call_593996: Call_ArtifactSourceList_593985; resourceGroupName: string;
          subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"; Top: int = 0; OrderBy: string = "";
          Filter: string = ""): Recallable =
  ## artifactSourceList
  ## List artifact sources.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##   OrderBy: string
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_593997 = newJObject()
  var query_593998 = newJObject()
  add(path_593997, "resourceGroupName", newJString(resourceGroupName))
  add(query_593998, "api-version", newJString(apiVersion))
  add(path_593997, "subscriptionId", newJString(subscriptionId))
  add(query_593998, "$top", newJInt(Top))
  add(query_593998, "$orderBy", newJString(OrderBy))
  add(path_593997, "labName", newJString(labName))
  add(query_593998, "$filter", newJString(Filter))
  result = call_593996.call(path_593997, query_593998, nil, nil, nil)

var artifactSourceList* = Call_ArtifactSourceList_593985(
    name: "artifactSourceList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources",
    validator: validate_ArtifactSourceList_593986, base: "",
    url: url_ArtifactSourceList_593987, schemes: {Scheme.Https})
type
  Call_ArtifactList_593999 = ref object of OpenApiRestCall_593421
proc url_ArtifactList_594001(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "artifactSourceName" in path,
        "`artifactSourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/artifactsources/"),
               (kind: VariableSegment, value: "artifactSourceName"),
               (kind: ConstantSegment, value: "/artifacts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactList_594000(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## List artifacts.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   artifactSourceName: JString (required)
  ##                     : The name of the artifact source.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594002 = path.getOrDefault("resourceGroupName")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "resourceGroupName", valid_594002
  var valid_594003 = path.getOrDefault("subscriptionId")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "subscriptionId", valid_594003
  var valid_594004 = path.getOrDefault("artifactSourceName")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "artifactSourceName", valid_594004
  var valid_594005 = path.getOrDefault("labName")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "labName", valid_594005
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##   $orderBy: JString
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594006 = query.getOrDefault("api-version")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594006 != nil:
    section.add "api-version", valid_594006
  var valid_594007 = query.getOrDefault("$top")
  valid_594007 = validateParameter(valid_594007, JInt, required = false, default = nil)
  if valid_594007 != nil:
    section.add "$top", valid_594007
  var valid_594008 = query.getOrDefault("$orderBy")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "$orderBy", valid_594008
  var valid_594009 = query.getOrDefault("$filter")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "$filter", valid_594009
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594010: Call_ArtifactList_593999; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List artifacts.
  ## 
  let valid = call_594010.validator(path, query, header, formData, body)
  let scheme = call_594010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594010.url(scheme.get, call_594010.host, call_594010.base,
                         call_594010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594010, url, valid)

proc call*(call_594011: Call_ArtifactList_593999; resourceGroupName: string;
          subscriptionId: string; artifactSourceName: string; labName: string;
          apiVersion: string = "2015-05-21-preview"; Top: int = 0; OrderBy: string = "";
          Filter: string = ""): Recallable =
  ## artifactList
  ## List artifacts.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##   OrderBy: string
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_594012 = newJObject()
  var query_594013 = newJObject()
  add(path_594012, "resourceGroupName", newJString(resourceGroupName))
  add(query_594013, "api-version", newJString(apiVersion))
  add(path_594012, "subscriptionId", newJString(subscriptionId))
  add(query_594013, "$top", newJInt(Top))
  add(query_594013, "$orderBy", newJString(OrderBy))
  add(path_594012, "artifactSourceName", newJString(artifactSourceName))
  add(path_594012, "labName", newJString(labName))
  add(query_594013, "$filter", newJString(Filter))
  result = call_594011.call(path_594012, query_594013, nil, nil, nil)

var artifactList* = Call_ArtifactList_593999(name: "artifactList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/artifacts",
    validator: validate_ArtifactList_594000, base: "", url: url_ArtifactList_594001,
    schemes: {Scheme.Https})
type
  Call_ArtifactGetResource_594014 = ref object of OpenApiRestCall_593421
proc url_ArtifactGetResource_594016(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "artifactSourceName" in path,
        "`artifactSourceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/artifactsources/"),
               (kind: VariableSegment, value: "artifactSourceName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactGetResource_594015(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get artifact.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the artifact.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   artifactSourceName: JString (required)
  ##                     : The name of the artifact source.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594017 = path.getOrDefault("resourceGroupName")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "resourceGroupName", valid_594017
  var valid_594018 = path.getOrDefault("name")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "name", valid_594018
  var valid_594019 = path.getOrDefault("subscriptionId")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "subscriptionId", valid_594019
  var valid_594020 = path.getOrDefault("artifactSourceName")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "artifactSourceName", valid_594020
  var valid_594021 = path.getOrDefault("labName")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "labName", valid_594021
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594022 = query.getOrDefault("api-version")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594022 != nil:
    section.add "api-version", valid_594022
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594023: Call_ArtifactGetResource_594014; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get artifact.
  ## 
  let valid = call_594023.validator(path, query, header, formData, body)
  let scheme = call_594023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594023.url(scheme.get, call_594023.host, call_594023.base,
                         call_594023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594023, url, valid)

proc call*(call_594024: Call_ArtifactGetResource_594014; resourceGroupName: string;
          name: string; subscriptionId: string; artifactSourceName: string;
          labName: string; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## artifactGetResource
  ## Get artifact.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the artifact.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594025 = newJObject()
  var query_594026 = newJObject()
  add(path_594025, "resourceGroupName", newJString(resourceGroupName))
  add(query_594026, "api-version", newJString(apiVersion))
  add(path_594025, "name", newJString(name))
  add(path_594025, "subscriptionId", newJString(subscriptionId))
  add(path_594025, "artifactSourceName", newJString(artifactSourceName))
  add(path_594025, "labName", newJString(labName))
  result = call_594024.call(path_594025, query_594026, nil, nil, nil)

var artifactGetResource* = Call_ArtifactGetResource_594014(
    name: "artifactGetResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/artifacts/{name}",
    validator: validate_ArtifactGetResource_594015, base: "",
    url: url_ArtifactGetResource_594016, schemes: {Scheme.Https})
type
  Call_ArtifactGenerateArmTemplate_594027 = ref object of OpenApiRestCall_593421
proc url_ArtifactGenerateArmTemplate_594029(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "artifactSourceName" in path,
        "`artifactSourceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/artifactsources/"),
               (kind: VariableSegment, value: "artifactSourceName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/generateArmTemplate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactGenerateArmTemplate_594028(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generates an ARM template for the given artifact, uploads the required files to a storage account, and validates the generated artifact.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the artifact.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   artifactSourceName: JString (required)
  ##                     : The name of the artifact source.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594030 = path.getOrDefault("resourceGroupName")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "resourceGroupName", valid_594030
  var valid_594031 = path.getOrDefault("name")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "name", valid_594031
  var valid_594032 = path.getOrDefault("subscriptionId")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "subscriptionId", valid_594032
  var valid_594033 = path.getOrDefault("artifactSourceName")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "artifactSourceName", valid_594033
  var valid_594034 = path.getOrDefault("labName")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "labName", valid_594034
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594035 = query.getOrDefault("api-version")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594035 != nil:
    section.add "api-version", valid_594035
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   generateArmTemplateRequest: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594037: Call_ArtifactGenerateArmTemplate_594027; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generates an ARM template for the given artifact, uploads the required files to a storage account, and validates the generated artifact.
  ## 
  let valid = call_594037.validator(path, query, header, formData, body)
  let scheme = call_594037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594037.url(scheme.get, call_594037.host, call_594037.base,
                         call_594037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594037, url, valid)

proc call*(call_594038: Call_ArtifactGenerateArmTemplate_594027;
          resourceGroupName: string; name: string; subscriptionId: string;
          artifactSourceName: string; labName: string;
          generateArmTemplateRequest: JsonNode;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## artifactGenerateArmTemplate
  ## Generates an ARM template for the given artifact, uploads the required files to a storage account, and validates the generated artifact.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the artifact.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   generateArmTemplateRequest: JObject (required)
  var path_594039 = newJObject()
  var query_594040 = newJObject()
  var body_594041 = newJObject()
  add(path_594039, "resourceGroupName", newJString(resourceGroupName))
  add(query_594040, "api-version", newJString(apiVersion))
  add(path_594039, "name", newJString(name))
  add(path_594039, "subscriptionId", newJString(subscriptionId))
  add(path_594039, "artifactSourceName", newJString(artifactSourceName))
  add(path_594039, "labName", newJString(labName))
  if generateArmTemplateRequest != nil:
    body_594041 = generateArmTemplateRequest
  result = call_594038.call(path_594039, query_594040, nil, nil, body_594041)

var artifactGenerateArmTemplate* = Call_ArtifactGenerateArmTemplate_594027(
    name: "artifactGenerateArmTemplate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/artifacts/{name}/generateArmTemplate",
    validator: validate_ArtifactGenerateArmTemplate_594028, base: "",
    url: url_ArtifactGenerateArmTemplate_594029, schemes: {Scheme.Https})
type
  Call_ArtifactSourceCreateOrUpdateResource_594054 = ref object of OpenApiRestCall_593421
proc url_ArtifactSourceCreateOrUpdateResource_594056(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/artifactsources/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactSourceCreateOrUpdateResource_594055(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing artifact source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594057 = path.getOrDefault("resourceGroupName")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "resourceGroupName", valid_594057
  var valid_594058 = path.getOrDefault("name")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "name", valid_594058
  var valid_594059 = path.getOrDefault("subscriptionId")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "subscriptionId", valid_594059
  var valid_594060 = path.getOrDefault("labName")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "labName", valid_594060
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594061 = query.getOrDefault("api-version")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594061 != nil:
    section.add "api-version", valid_594061
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   artifactSource: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594063: Call_ArtifactSourceCreateOrUpdateResource_594054;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or replace an existing artifact source.
  ## 
  let valid = call_594063.validator(path, query, header, formData, body)
  let scheme = call_594063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594063.url(scheme.get, call_594063.host, call_594063.base,
                         call_594063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594063, url, valid)

proc call*(call_594064: Call_ArtifactSourceCreateOrUpdateResource_594054;
          resourceGroupName: string; name: string; artifactSource: JsonNode;
          subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## artifactSourceCreateOrUpdateResource
  ## Create or replace an existing artifact source.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the artifact source.
  ##   artifactSource: JObject (required)
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594065 = newJObject()
  var query_594066 = newJObject()
  var body_594067 = newJObject()
  add(path_594065, "resourceGroupName", newJString(resourceGroupName))
  add(query_594066, "api-version", newJString(apiVersion))
  add(path_594065, "name", newJString(name))
  if artifactSource != nil:
    body_594067 = artifactSource
  add(path_594065, "subscriptionId", newJString(subscriptionId))
  add(path_594065, "labName", newJString(labName))
  result = call_594064.call(path_594065, query_594066, nil, nil, body_594067)

var artifactSourceCreateOrUpdateResource* = Call_ArtifactSourceCreateOrUpdateResource_594054(
    name: "artifactSourceCreateOrUpdateResource", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{name}",
    validator: validate_ArtifactSourceCreateOrUpdateResource_594055, base: "",
    url: url_ArtifactSourceCreateOrUpdateResource_594056, schemes: {Scheme.Https})
type
  Call_ArtifactSourceGetResource_594042 = ref object of OpenApiRestCall_593421
proc url_ArtifactSourceGetResource_594044(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/artifactsources/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactSourceGetResource_594043(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get artifact source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594045 = path.getOrDefault("resourceGroupName")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "resourceGroupName", valid_594045
  var valid_594046 = path.getOrDefault("name")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "name", valid_594046
  var valid_594047 = path.getOrDefault("subscriptionId")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "subscriptionId", valid_594047
  var valid_594048 = path.getOrDefault("labName")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "labName", valid_594048
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594049 = query.getOrDefault("api-version")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594049 != nil:
    section.add "api-version", valid_594049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594050: Call_ArtifactSourceGetResource_594042; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get artifact source.
  ## 
  let valid = call_594050.validator(path, query, header, formData, body)
  let scheme = call_594050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594050.url(scheme.get, call_594050.host, call_594050.base,
                         call_594050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594050, url, valid)

proc call*(call_594051: Call_ArtifactSourceGetResource_594042;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## artifactSourceGetResource
  ## Get artifact source.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594052 = newJObject()
  var query_594053 = newJObject()
  add(path_594052, "resourceGroupName", newJString(resourceGroupName))
  add(query_594053, "api-version", newJString(apiVersion))
  add(path_594052, "name", newJString(name))
  add(path_594052, "subscriptionId", newJString(subscriptionId))
  add(path_594052, "labName", newJString(labName))
  result = call_594051.call(path_594052, query_594053, nil, nil, nil)

var artifactSourceGetResource* = Call_ArtifactSourceGetResource_594042(
    name: "artifactSourceGetResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{name}",
    validator: validate_ArtifactSourceGetResource_594043, base: "",
    url: url_ArtifactSourceGetResource_594044, schemes: {Scheme.Https})
type
  Call_ArtifactSourcePatchResource_594080 = ref object of OpenApiRestCall_593421
proc url_ArtifactSourcePatchResource_594082(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/artifactsources/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactSourcePatchResource_594081(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of artifact sources.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594083 = path.getOrDefault("resourceGroupName")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "resourceGroupName", valid_594083
  var valid_594084 = path.getOrDefault("name")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "name", valid_594084
  var valid_594085 = path.getOrDefault("subscriptionId")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "subscriptionId", valid_594085
  var valid_594086 = path.getOrDefault("labName")
  valid_594086 = validateParameter(valid_594086, JString, required = true,
                                 default = nil)
  if valid_594086 != nil:
    section.add "labName", valid_594086
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594087 = query.getOrDefault("api-version")
  valid_594087 = validateParameter(valid_594087, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594087 != nil:
    section.add "api-version", valid_594087
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   artifactSource: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594089: Call_ArtifactSourcePatchResource_594080; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of artifact sources.
  ## 
  let valid = call_594089.validator(path, query, header, formData, body)
  let scheme = call_594089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594089.url(scheme.get, call_594089.host, call_594089.base,
                         call_594089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594089, url, valid)

proc call*(call_594090: Call_ArtifactSourcePatchResource_594080;
          resourceGroupName: string; name: string; artifactSource: JsonNode;
          subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## artifactSourcePatchResource
  ## Modify properties of artifact sources.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the artifact source.
  ##   artifactSource: JObject (required)
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594091 = newJObject()
  var query_594092 = newJObject()
  var body_594093 = newJObject()
  add(path_594091, "resourceGroupName", newJString(resourceGroupName))
  add(query_594092, "api-version", newJString(apiVersion))
  add(path_594091, "name", newJString(name))
  if artifactSource != nil:
    body_594093 = artifactSource
  add(path_594091, "subscriptionId", newJString(subscriptionId))
  add(path_594091, "labName", newJString(labName))
  result = call_594090.call(path_594091, query_594092, nil, nil, body_594093)

var artifactSourcePatchResource* = Call_ArtifactSourcePatchResource_594080(
    name: "artifactSourcePatchResource", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{name}",
    validator: validate_ArtifactSourcePatchResource_594081, base: "",
    url: url_ArtifactSourcePatchResource_594082, schemes: {Scheme.Https})
type
  Call_ArtifactSourceDeleteResource_594068 = ref object of OpenApiRestCall_593421
proc url_ArtifactSourceDeleteResource_594070(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/artifactsources/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactSourceDeleteResource_594069(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete artifact source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594071 = path.getOrDefault("resourceGroupName")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "resourceGroupName", valid_594071
  var valid_594072 = path.getOrDefault("name")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "name", valid_594072
  var valid_594073 = path.getOrDefault("subscriptionId")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "subscriptionId", valid_594073
  var valid_594074 = path.getOrDefault("labName")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "labName", valid_594074
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594075 = query.getOrDefault("api-version")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594075 != nil:
    section.add "api-version", valid_594075
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594076: Call_ArtifactSourceDeleteResource_594068; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete artifact source.
  ## 
  let valid = call_594076.validator(path, query, header, formData, body)
  let scheme = call_594076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594076.url(scheme.get, call_594076.host, call_594076.base,
                         call_594076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594076, url, valid)

proc call*(call_594077: Call_ArtifactSourceDeleteResource_594068;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## artifactSourceDeleteResource
  ## Delete artifact source.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594078 = newJObject()
  var query_594079 = newJObject()
  add(path_594078, "resourceGroupName", newJString(resourceGroupName))
  add(query_594079, "api-version", newJString(apiVersion))
  add(path_594078, "name", newJString(name))
  add(path_594078, "subscriptionId", newJString(subscriptionId))
  add(path_594078, "labName", newJString(labName))
  result = call_594077.call(path_594078, query_594079, nil, nil, nil)

var artifactSourceDeleteResource* = Call_ArtifactSourceDeleteResource_594068(
    name: "artifactSourceDeleteResource", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{name}",
    validator: validate_ArtifactSourceDeleteResource_594069, base: "",
    url: url_ArtifactSourceDeleteResource_594070, schemes: {Scheme.Https})
type
  Call_CostInsightList_594094 = ref object of OpenApiRestCall_593421
proc url_CostInsightList_594096(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/costinsights")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CostInsightList_594095(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## List cost insights.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594097 = path.getOrDefault("resourceGroupName")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "resourceGroupName", valid_594097
  var valid_594098 = path.getOrDefault("subscriptionId")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "subscriptionId", valid_594098
  var valid_594099 = path.getOrDefault("labName")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "labName", valid_594099
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##   $orderBy: JString
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594100 = query.getOrDefault("api-version")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594100 != nil:
    section.add "api-version", valid_594100
  var valid_594101 = query.getOrDefault("$top")
  valid_594101 = validateParameter(valid_594101, JInt, required = false, default = nil)
  if valid_594101 != nil:
    section.add "$top", valid_594101
  var valid_594102 = query.getOrDefault("$orderBy")
  valid_594102 = validateParameter(valid_594102, JString, required = false,
                                 default = nil)
  if valid_594102 != nil:
    section.add "$orderBy", valid_594102
  var valid_594103 = query.getOrDefault("$filter")
  valid_594103 = validateParameter(valid_594103, JString, required = false,
                                 default = nil)
  if valid_594103 != nil:
    section.add "$filter", valid_594103
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594104: Call_CostInsightList_594094; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List cost insights.
  ## 
  let valid = call_594104.validator(path, query, header, formData, body)
  let scheme = call_594104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594104.url(scheme.get, call_594104.host, call_594104.base,
                         call_594104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594104, url, valid)

proc call*(call_594105: Call_CostInsightList_594094; resourceGroupName: string;
          subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"; Top: int = 0; OrderBy: string = "";
          Filter: string = ""): Recallable =
  ## costInsightList
  ## List cost insights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##   OrderBy: string
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_594106 = newJObject()
  var query_594107 = newJObject()
  add(path_594106, "resourceGroupName", newJString(resourceGroupName))
  add(query_594107, "api-version", newJString(apiVersion))
  add(path_594106, "subscriptionId", newJString(subscriptionId))
  add(query_594107, "$top", newJInt(Top))
  add(query_594107, "$orderBy", newJString(OrderBy))
  add(path_594106, "labName", newJString(labName))
  add(query_594107, "$filter", newJString(Filter))
  result = call_594105.call(path_594106, query_594107, nil, nil, nil)

var costInsightList* = Call_CostInsightList_594094(name: "costInsightList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/costinsights",
    validator: validate_CostInsightList_594095, base: "", url: url_CostInsightList_594096,
    schemes: {Scheme.Https})
type
  Call_CostInsightGetResource_594108 = ref object of OpenApiRestCall_593421
proc url_CostInsightGetResource_594110(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/costinsights/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CostInsightGetResource_594109(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get cost insight.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the cost insight.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594111 = path.getOrDefault("resourceGroupName")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "resourceGroupName", valid_594111
  var valid_594112 = path.getOrDefault("name")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "name", valid_594112
  var valid_594113 = path.getOrDefault("subscriptionId")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "subscriptionId", valid_594113
  var valid_594114 = path.getOrDefault("labName")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "labName", valid_594114
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594115 = query.getOrDefault("api-version")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594115 != nil:
    section.add "api-version", valid_594115
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594116: Call_CostInsightGetResource_594108; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get cost insight.
  ## 
  let valid = call_594116.validator(path, query, header, formData, body)
  let scheme = call_594116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594116.url(scheme.get, call_594116.host, call_594116.base,
                         call_594116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594116, url, valid)

proc call*(call_594117: Call_CostInsightGetResource_594108;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## costInsightGetResource
  ## Get cost insight.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the cost insight.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594118 = newJObject()
  var query_594119 = newJObject()
  add(path_594118, "resourceGroupName", newJString(resourceGroupName))
  add(query_594119, "api-version", newJString(apiVersion))
  add(path_594118, "name", newJString(name))
  add(path_594118, "subscriptionId", newJString(subscriptionId))
  add(path_594118, "labName", newJString(labName))
  result = call_594117.call(path_594118, query_594119, nil, nil, nil)

var costInsightGetResource* = Call_CostInsightGetResource_594108(
    name: "costInsightGetResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/costinsights/{name}",
    validator: validate_CostInsightGetResource_594109, base: "",
    url: url_CostInsightGetResource_594110, schemes: {Scheme.Https})
type
  Call_CostInsightRefreshData_594120 = ref object of OpenApiRestCall_593421
proc url_CostInsightRefreshData_594122(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/costinsights/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/refreshData")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CostInsightRefreshData_594121(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Refresh Lab's Cost Insight Data. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the cost insight.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594123 = path.getOrDefault("resourceGroupName")
  valid_594123 = validateParameter(valid_594123, JString, required = true,
                                 default = nil)
  if valid_594123 != nil:
    section.add "resourceGroupName", valid_594123
  var valid_594124 = path.getOrDefault("name")
  valid_594124 = validateParameter(valid_594124, JString, required = true,
                                 default = nil)
  if valid_594124 != nil:
    section.add "name", valid_594124
  var valid_594125 = path.getOrDefault("subscriptionId")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "subscriptionId", valid_594125
  var valid_594126 = path.getOrDefault("labName")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "labName", valid_594126
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594127 = query.getOrDefault("api-version")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594127 != nil:
    section.add "api-version", valid_594127
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594128: Call_CostInsightRefreshData_594120; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Refresh Lab's Cost Insight Data. This operation can take a while to complete.
  ## 
  let valid = call_594128.validator(path, query, header, formData, body)
  let scheme = call_594128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594128.url(scheme.get, call_594128.host, call_594128.base,
                         call_594128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594128, url, valid)

proc call*(call_594129: Call_CostInsightRefreshData_594120;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## costInsightRefreshData
  ## Refresh Lab's Cost Insight Data. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the cost insight.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594130 = newJObject()
  var query_594131 = newJObject()
  add(path_594130, "resourceGroupName", newJString(resourceGroupName))
  add(query_594131, "api-version", newJString(apiVersion))
  add(path_594130, "name", newJString(name))
  add(path_594130, "subscriptionId", newJString(subscriptionId))
  add(path_594130, "labName", newJString(labName))
  result = call_594129.call(path_594130, query_594131, nil, nil, nil)

var costInsightRefreshData* = Call_CostInsightRefreshData_594120(
    name: "costInsightRefreshData", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/costinsights/{name}/refreshData",
    validator: validate_CostInsightRefreshData_594121, base: "",
    url: url_CostInsightRefreshData_594122, schemes: {Scheme.Https})
type
  Call_CostList_594132 = ref object of OpenApiRestCall_593421
proc url_CostList_594134(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/costs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CostList_594133(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## List costs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594135 = path.getOrDefault("resourceGroupName")
  valid_594135 = validateParameter(valid_594135, JString, required = true,
                                 default = nil)
  if valid_594135 != nil:
    section.add "resourceGroupName", valid_594135
  var valid_594136 = path.getOrDefault("subscriptionId")
  valid_594136 = validateParameter(valid_594136, JString, required = true,
                                 default = nil)
  if valid_594136 != nil:
    section.add "subscriptionId", valid_594136
  var valid_594137 = path.getOrDefault("labName")
  valid_594137 = validateParameter(valid_594137, JString, required = true,
                                 default = nil)
  if valid_594137 != nil:
    section.add "labName", valid_594137
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##   $orderBy: JString
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594138 = query.getOrDefault("api-version")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594138 != nil:
    section.add "api-version", valid_594138
  var valid_594139 = query.getOrDefault("$top")
  valid_594139 = validateParameter(valid_594139, JInt, required = false, default = nil)
  if valid_594139 != nil:
    section.add "$top", valid_594139
  var valid_594140 = query.getOrDefault("$orderBy")
  valid_594140 = validateParameter(valid_594140, JString, required = false,
                                 default = nil)
  if valid_594140 != nil:
    section.add "$orderBy", valid_594140
  var valid_594141 = query.getOrDefault("$filter")
  valid_594141 = validateParameter(valid_594141, JString, required = false,
                                 default = nil)
  if valid_594141 != nil:
    section.add "$filter", valid_594141
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594142: Call_CostList_594132; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List costs.
  ## 
  let valid = call_594142.validator(path, query, header, formData, body)
  let scheme = call_594142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594142.url(scheme.get, call_594142.host, call_594142.base,
                         call_594142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594142, url, valid)

proc call*(call_594143: Call_CostList_594132; resourceGroupName: string;
          subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"; Top: int = 0; OrderBy: string = "";
          Filter: string = ""): Recallable =
  ## costList
  ## List costs.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##   OrderBy: string
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_594144 = newJObject()
  var query_594145 = newJObject()
  add(path_594144, "resourceGroupName", newJString(resourceGroupName))
  add(query_594145, "api-version", newJString(apiVersion))
  add(path_594144, "subscriptionId", newJString(subscriptionId))
  add(query_594145, "$top", newJInt(Top))
  add(query_594145, "$orderBy", newJString(OrderBy))
  add(path_594144, "labName", newJString(labName))
  add(query_594145, "$filter", newJString(Filter))
  result = call_594143.call(path_594144, query_594145, nil, nil, nil)

var costList* = Call_CostList_594132(name: "costList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/costs",
                                  validator: validate_CostList_594133, base: "",
                                  url: url_CostList_594134,
                                  schemes: {Scheme.Https})
type
  Call_CostGetResource_594146 = ref object of OpenApiRestCall_593421
proc url_CostGetResource_594148(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/costs/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CostGetResource_594147(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get cost.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the cost.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594149 = path.getOrDefault("resourceGroupName")
  valid_594149 = validateParameter(valid_594149, JString, required = true,
                                 default = nil)
  if valid_594149 != nil:
    section.add "resourceGroupName", valid_594149
  var valid_594150 = path.getOrDefault("name")
  valid_594150 = validateParameter(valid_594150, JString, required = true,
                                 default = nil)
  if valid_594150 != nil:
    section.add "name", valid_594150
  var valid_594151 = path.getOrDefault("subscriptionId")
  valid_594151 = validateParameter(valid_594151, JString, required = true,
                                 default = nil)
  if valid_594151 != nil:
    section.add "subscriptionId", valid_594151
  var valid_594152 = path.getOrDefault("labName")
  valid_594152 = validateParameter(valid_594152, JString, required = true,
                                 default = nil)
  if valid_594152 != nil:
    section.add "labName", valid_594152
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594153 = query.getOrDefault("api-version")
  valid_594153 = validateParameter(valid_594153, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594153 != nil:
    section.add "api-version", valid_594153
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594154: Call_CostGetResource_594146; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get cost.
  ## 
  let valid = call_594154.validator(path, query, header, formData, body)
  let scheme = call_594154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594154.url(scheme.get, call_594154.host, call_594154.base,
                         call_594154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594154, url, valid)

proc call*(call_594155: Call_CostGetResource_594146; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## costGetResource
  ## Get cost.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the cost.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594156 = newJObject()
  var query_594157 = newJObject()
  add(path_594156, "resourceGroupName", newJString(resourceGroupName))
  add(query_594157, "api-version", newJString(apiVersion))
  add(path_594156, "name", newJString(name))
  add(path_594156, "subscriptionId", newJString(subscriptionId))
  add(path_594156, "labName", newJString(labName))
  result = call_594155.call(path_594156, query_594157, nil, nil, nil)

var costGetResource* = Call_CostGetResource_594146(name: "costGetResource",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/costs/{name}",
    validator: validate_CostGetResource_594147, base: "", url: url_CostGetResource_594148,
    schemes: {Scheme.Https})
type
  Call_CostRefreshData_594158 = ref object of OpenApiRestCall_593421
proc url_CostRefreshData_594160(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/costs/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/refreshData")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CostRefreshData_594159(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Refresh Lab's Cost Data. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the cost.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594161 = path.getOrDefault("resourceGroupName")
  valid_594161 = validateParameter(valid_594161, JString, required = true,
                                 default = nil)
  if valid_594161 != nil:
    section.add "resourceGroupName", valid_594161
  var valid_594162 = path.getOrDefault("name")
  valid_594162 = validateParameter(valid_594162, JString, required = true,
                                 default = nil)
  if valid_594162 != nil:
    section.add "name", valid_594162
  var valid_594163 = path.getOrDefault("subscriptionId")
  valid_594163 = validateParameter(valid_594163, JString, required = true,
                                 default = nil)
  if valid_594163 != nil:
    section.add "subscriptionId", valid_594163
  var valid_594164 = path.getOrDefault("labName")
  valid_594164 = validateParameter(valid_594164, JString, required = true,
                                 default = nil)
  if valid_594164 != nil:
    section.add "labName", valid_594164
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594165 = query.getOrDefault("api-version")
  valid_594165 = validateParameter(valid_594165, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594165 != nil:
    section.add "api-version", valid_594165
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594166: Call_CostRefreshData_594158; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Refresh Lab's Cost Data. This operation can take a while to complete.
  ## 
  let valid = call_594166.validator(path, query, header, formData, body)
  let scheme = call_594166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594166.url(scheme.get, call_594166.host, call_594166.base,
                         call_594166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594166, url, valid)

proc call*(call_594167: Call_CostRefreshData_594158; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## costRefreshData
  ## Refresh Lab's Cost Data. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the cost.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594168 = newJObject()
  var query_594169 = newJObject()
  add(path_594168, "resourceGroupName", newJString(resourceGroupName))
  add(query_594169, "api-version", newJString(apiVersion))
  add(path_594168, "name", newJString(name))
  add(path_594168, "subscriptionId", newJString(subscriptionId))
  add(path_594168, "labName", newJString(labName))
  result = call_594167.call(path_594168, query_594169, nil, nil, nil)

var costRefreshData* = Call_CostRefreshData_594158(name: "costRefreshData",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/costs/{name}/refreshData",
    validator: validate_CostRefreshData_594159, base: "", url: url_CostRefreshData_594160,
    schemes: {Scheme.Https})
type
  Call_CustomImageList_594170 = ref object of OpenApiRestCall_593421
proc url_CustomImageList_594172(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/customimages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomImageList_594171(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## List custom images.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594173 = path.getOrDefault("resourceGroupName")
  valid_594173 = validateParameter(valid_594173, JString, required = true,
                                 default = nil)
  if valid_594173 != nil:
    section.add "resourceGroupName", valid_594173
  var valid_594174 = path.getOrDefault("subscriptionId")
  valid_594174 = validateParameter(valid_594174, JString, required = true,
                                 default = nil)
  if valid_594174 != nil:
    section.add "subscriptionId", valid_594174
  var valid_594175 = path.getOrDefault("labName")
  valid_594175 = validateParameter(valid_594175, JString, required = true,
                                 default = nil)
  if valid_594175 != nil:
    section.add "labName", valid_594175
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##   $orderBy: JString
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594176 = query.getOrDefault("api-version")
  valid_594176 = validateParameter(valid_594176, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594176 != nil:
    section.add "api-version", valid_594176
  var valid_594177 = query.getOrDefault("$top")
  valid_594177 = validateParameter(valid_594177, JInt, required = false, default = nil)
  if valid_594177 != nil:
    section.add "$top", valid_594177
  var valid_594178 = query.getOrDefault("$orderBy")
  valid_594178 = validateParameter(valid_594178, JString, required = false,
                                 default = nil)
  if valid_594178 != nil:
    section.add "$orderBy", valid_594178
  var valid_594179 = query.getOrDefault("$filter")
  valid_594179 = validateParameter(valid_594179, JString, required = false,
                                 default = nil)
  if valid_594179 != nil:
    section.add "$filter", valid_594179
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594180: Call_CustomImageList_594170; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List custom images.
  ## 
  let valid = call_594180.validator(path, query, header, formData, body)
  let scheme = call_594180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594180.url(scheme.get, call_594180.host, call_594180.base,
                         call_594180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594180, url, valid)

proc call*(call_594181: Call_CustomImageList_594170; resourceGroupName: string;
          subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"; Top: int = 0; OrderBy: string = "";
          Filter: string = ""): Recallable =
  ## customImageList
  ## List custom images.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##   OrderBy: string
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_594182 = newJObject()
  var query_594183 = newJObject()
  add(path_594182, "resourceGroupName", newJString(resourceGroupName))
  add(query_594183, "api-version", newJString(apiVersion))
  add(path_594182, "subscriptionId", newJString(subscriptionId))
  add(query_594183, "$top", newJInt(Top))
  add(query_594183, "$orderBy", newJString(OrderBy))
  add(path_594182, "labName", newJString(labName))
  add(query_594183, "$filter", newJString(Filter))
  result = call_594181.call(path_594182, query_594183, nil, nil, nil)

var customImageList* = Call_CustomImageList_594170(name: "customImageList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages",
    validator: validate_CustomImageList_594171, base: "", url: url_CustomImageList_594172,
    schemes: {Scheme.Https})
type
  Call_CustomImageCreateOrUpdateResource_594196 = ref object of OpenApiRestCall_593421
proc url_CustomImageCreateOrUpdateResource_594198(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/customimages/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomImageCreateOrUpdateResource_594197(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing custom image. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the custom image.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594199 = path.getOrDefault("resourceGroupName")
  valid_594199 = validateParameter(valid_594199, JString, required = true,
                                 default = nil)
  if valid_594199 != nil:
    section.add "resourceGroupName", valid_594199
  var valid_594200 = path.getOrDefault("name")
  valid_594200 = validateParameter(valid_594200, JString, required = true,
                                 default = nil)
  if valid_594200 != nil:
    section.add "name", valid_594200
  var valid_594201 = path.getOrDefault("subscriptionId")
  valid_594201 = validateParameter(valid_594201, JString, required = true,
                                 default = nil)
  if valid_594201 != nil:
    section.add "subscriptionId", valid_594201
  var valid_594202 = path.getOrDefault("labName")
  valid_594202 = validateParameter(valid_594202, JString, required = true,
                                 default = nil)
  if valid_594202 != nil:
    section.add "labName", valid_594202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594203 = query.getOrDefault("api-version")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594203 != nil:
    section.add "api-version", valid_594203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   customImage: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594205: Call_CustomImageCreateOrUpdateResource_594196;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or replace an existing custom image. This operation can take a while to complete.
  ## 
  let valid = call_594205.validator(path, query, header, formData, body)
  let scheme = call_594205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594205.url(scheme.get, call_594205.host, call_594205.base,
                         call_594205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594205, url, valid)

proc call*(call_594206: Call_CustomImageCreateOrUpdateResource_594196;
          resourceGroupName: string; name: string; subscriptionId: string;
          customImage: JsonNode; labName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## customImageCreateOrUpdateResource
  ## Create or replace an existing custom image. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the custom image.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   customImage: JObject (required)
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594207 = newJObject()
  var query_594208 = newJObject()
  var body_594209 = newJObject()
  add(path_594207, "resourceGroupName", newJString(resourceGroupName))
  add(query_594208, "api-version", newJString(apiVersion))
  add(path_594207, "name", newJString(name))
  add(path_594207, "subscriptionId", newJString(subscriptionId))
  if customImage != nil:
    body_594209 = customImage
  add(path_594207, "labName", newJString(labName))
  result = call_594206.call(path_594207, query_594208, nil, nil, body_594209)

var customImageCreateOrUpdateResource* = Call_CustomImageCreateOrUpdateResource_594196(
    name: "customImageCreateOrUpdateResource", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages/{name}",
    validator: validate_CustomImageCreateOrUpdateResource_594197, base: "",
    url: url_CustomImageCreateOrUpdateResource_594198, schemes: {Scheme.Https})
type
  Call_CustomImageGetResource_594184 = ref object of OpenApiRestCall_593421
proc url_CustomImageGetResource_594186(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/customimages/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomImageGetResource_594185(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get custom image.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the custom image.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594187 = path.getOrDefault("resourceGroupName")
  valid_594187 = validateParameter(valid_594187, JString, required = true,
                                 default = nil)
  if valid_594187 != nil:
    section.add "resourceGroupName", valid_594187
  var valid_594188 = path.getOrDefault("name")
  valid_594188 = validateParameter(valid_594188, JString, required = true,
                                 default = nil)
  if valid_594188 != nil:
    section.add "name", valid_594188
  var valid_594189 = path.getOrDefault("subscriptionId")
  valid_594189 = validateParameter(valid_594189, JString, required = true,
                                 default = nil)
  if valid_594189 != nil:
    section.add "subscriptionId", valid_594189
  var valid_594190 = path.getOrDefault("labName")
  valid_594190 = validateParameter(valid_594190, JString, required = true,
                                 default = nil)
  if valid_594190 != nil:
    section.add "labName", valid_594190
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594191 = query.getOrDefault("api-version")
  valid_594191 = validateParameter(valid_594191, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594191 != nil:
    section.add "api-version", valid_594191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594192: Call_CustomImageGetResource_594184; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get custom image.
  ## 
  let valid = call_594192.validator(path, query, header, formData, body)
  let scheme = call_594192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594192.url(scheme.get, call_594192.host, call_594192.base,
                         call_594192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594192, url, valid)

proc call*(call_594193: Call_CustomImageGetResource_594184;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## customImageGetResource
  ## Get custom image.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the custom image.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594194 = newJObject()
  var query_594195 = newJObject()
  add(path_594194, "resourceGroupName", newJString(resourceGroupName))
  add(query_594195, "api-version", newJString(apiVersion))
  add(path_594194, "name", newJString(name))
  add(path_594194, "subscriptionId", newJString(subscriptionId))
  add(path_594194, "labName", newJString(labName))
  result = call_594193.call(path_594194, query_594195, nil, nil, nil)

var customImageGetResource* = Call_CustomImageGetResource_594184(
    name: "customImageGetResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages/{name}",
    validator: validate_CustomImageGetResource_594185, base: "",
    url: url_CustomImageGetResource_594186, schemes: {Scheme.Https})
type
  Call_CustomImageDeleteResource_594210 = ref object of OpenApiRestCall_593421
proc url_CustomImageDeleteResource_594212(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/customimages/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomImageDeleteResource_594211(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete custom image. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the custom image.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594213 = path.getOrDefault("resourceGroupName")
  valid_594213 = validateParameter(valid_594213, JString, required = true,
                                 default = nil)
  if valid_594213 != nil:
    section.add "resourceGroupName", valid_594213
  var valid_594214 = path.getOrDefault("name")
  valid_594214 = validateParameter(valid_594214, JString, required = true,
                                 default = nil)
  if valid_594214 != nil:
    section.add "name", valid_594214
  var valid_594215 = path.getOrDefault("subscriptionId")
  valid_594215 = validateParameter(valid_594215, JString, required = true,
                                 default = nil)
  if valid_594215 != nil:
    section.add "subscriptionId", valid_594215
  var valid_594216 = path.getOrDefault("labName")
  valid_594216 = validateParameter(valid_594216, JString, required = true,
                                 default = nil)
  if valid_594216 != nil:
    section.add "labName", valid_594216
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594217 = query.getOrDefault("api-version")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594217 != nil:
    section.add "api-version", valid_594217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594218: Call_CustomImageDeleteResource_594210; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete custom image. This operation can take a while to complete.
  ## 
  let valid = call_594218.validator(path, query, header, formData, body)
  let scheme = call_594218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594218.url(scheme.get, call_594218.host, call_594218.base,
                         call_594218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594218, url, valid)

proc call*(call_594219: Call_CustomImageDeleteResource_594210;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## customImageDeleteResource
  ## Delete custom image. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the custom image.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594220 = newJObject()
  var query_594221 = newJObject()
  add(path_594220, "resourceGroupName", newJString(resourceGroupName))
  add(query_594221, "api-version", newJString(apiVersion))
  add(path_594220, "name", newJString(name))
  add(path_594220, "subscriptionId", newJString(subscriptionId))
  add(path_594220, "labName", newJString(labName))
  result = call_594219.call(path_594220, query_594221, nil, nil, nil)

var customImageDeleteResource* = Call_CustomImageDeleteResource_594210(
    name: "customImageDeleteResource", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages/{name}",
    validator: validate_CustomImageDeleteResource_594211, base: "",
    url: url_CustomImageDeleteResource_594212, schemes: {Scheme.Https})
type
  Call_FormulaList_594222 = ref object of OpenApiRestCall_593421
proc url_FormulaList_594224(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/formulas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FormulaList_594223(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## List formulas.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594225 = path.getOrDefault("resourceGroupName")
  valid_594225 = validateParameter(valid_594225, JString, required = true,
                                 default = nil)
  if valid_594225 != nil:
    section.add "resourceGroupName", valid_594225
  var valid_594226 = path.getOrDefault("subscriptionId")
  valid_594226 = validateParameter(valid_594226, JString, required = true,
                                 default = nil)
  if valid_594226 != nil:
    section.add "subscriptionId", valid_594226
  var valid_594227 = path.getOrDefault("labName")
  valid_594227 = validateParameter(valid_594227, JString, required = true,
                                 default = nil)
  if valid_594227 != nil:
    section.add "labName", valid_594227
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##   $orderBy: JString
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594228 = query.getOrDefault("api-version")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594228 != nil:
    section.add "api-version", valid_594228
  var valid_594229 = query.getOrDefault("$top")
  valid_594229 = validateParameter(valid_594229, JInt, required = false, default = nil)
  if valid_594229 != nil:
    section.add "$top", valid_594229
  var valid_594230 = query.getOrDefault("$orderBy")
  valid_594230 = validateParameter(valid_594230, JString, required = false,
                                 default = nil)
  if valid_594230 != nil:
    section.add "$orderBy", valid_594230
  var valid_594231 = query.getOrDefault("$filter")
  valid_594231 = validateParameter(valid_594231, JString, required = false,
                                 default = nil)
  if valid_594231 != nil:
    section.add "$filter", valid_594231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594232: Call_FormulaList_594222; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List formulas.
  ## 
  let valid = call_594232.validator(path, query, header, formData, body)
  let scheme = call_594232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594232.url(scheme.get, call_594232.host, call_594232.base,
                         call_594232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594232, url, valid)

proc call*(call_594233: Call_FormulaList_594222; resourceGroupName: string;
          subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"; Top: int = 0; OrderBy: string = "";
          Filter: string = ""): Recallable =
  ## formulaList
  ## List formulas.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##   OrderBy: string
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_594234 = newJObject()
  var query_594235 = newJObject()
  add(path_594234, "resourceGroupName", newJString(resourceGroupName))
  add(query_594235, "api-version", newJString(apiVersion))
  add(path_594234, "subscriptionId", newJString(subscriptionId))
  add(query_594235, "$top", newJInt(Top))
  add(query_594235, "$orderBy", newJString(OrderBy))
  add(path_594234, "labName", newJString(labName))
  add(query_594235, "$filter", newJString(Filter))
  result = call_594233.call(path_594234, query_594235, nil, nil, nil)

var formulaList* = Call_FormulaList_594222(name: "formulaList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas",
                                        validator: validate_FormulaList_594223,
                                        base: "", url: url_FormulaList_594224,
                                        schemes: {Scheme.Https})
type
  Call_FormulaCreateOrUpdateResource_594248 = ref object of OpenApiRestCall_593421
proc url_FormulaCreateOrUpdateResource_594250(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/formulas/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FormulaCreateOrUpdateResource_594249(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing Formula. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the formula.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594251 = path.getOrDefault("resourceGroupName")
  valid_594251 = validateParameter(valid_594251, JString, required = true,
                                 default = nil)
  if valid_594251 != nil:
    section.add "resourceGroupName", valid_594251
  var valid_594252 = path.getOrDefault("name")
  valid_594252 = validateParameter(valid_594252, JString, required = true,
                                 default = nil)
  if valid_594252 != nil:
    section.add "name", valid_594252
  var valid_594253 = path.getOrDefault("subscriptionId")
  valid_594253 = validateParameter(valid_594253, JString, required = true,
                                 default = nil)
  if valid_594253 != nil:
    section.add "subscriptionId", valid_594253
  var valid_594254 = path.getOrDefault("labName")
  valid_594254 = validateParameter(valid_594254, JString, required = true,
                                 default = nil)
  if valid_594254 != nil:
    section.add "labName", valid_594254
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594255 = query.getOrDefault("api-version")
  valid_594255 = validateParameter(valid_594255, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594255 != nil:
    section.add "api-version", valid_594255
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   formula: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594257: Call_FormulaCreateOrUpdateResource_594248; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing Formula. This operation can take a while to complete.
  ## 
  let valid = call_594257.validator(path, query, header, formData, body)
  let scheme = call_594257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594257.url(scheme.get, call_594257.host, call_594257.base,
                         call_594257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594257, url, valid)

proc call*(call_594258: Call_FormulaCreateOrUpdateResource_594248;
          resourceGroupName: string; formula: JsonNode; name: string;
          subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## formulaCreateOrUpdateResource
  ## Create or replace an existing Formula. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   formula: JObject (required)
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the formula.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594259 = newJObject()
  var query_594260 = newJObject()
  var body_594261 = newJObject()
  add(path_594259, "resourceGroupName", newJString(resourceGroupName))
  if formula != nil:
    body_594261 = formula
  add(query_594260, "api-version", newJString(apiVersion))
  add(path_594259, "name", newJString(name))
  add(path_594259, "subscriptionId", newJString(subscriptionId))
  add(path_594259, "labName", newJString(labName))
  result = call_594258.call(path_594259, query_594260, nil, nil, body_594261)

var formulaCreateOrUpdateResource* = Call_FormulaCreateOrUpdateResource_594248(
    name: "formulaCreateOrUpdateResource", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas/{name}",
    validator: validate_FormulaCreateOrUpdateResource_594249, base: "",
    url: url_FormulaCreateOrUpdateResource_594250, schemes: {Scheme.Https})
type
  Call_FormulaGetResource_594236 = ref object of OpenApiRestCall_593421
proc url_FormulaGetResource_594238(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/formulas/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FormulaGetResource_594237(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get formula.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the formula.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594239 = path.getOrDefault("resourceGroupName")
  valid_594239 = validateParameter(valid_594239, JString, required = true,
                                 default = nil)
  if valid_594239 != nil:
    section.add "resourceGroupName", valid_594239
  var valid_594240 = path.getOrDefault("name")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = nil)
  if valid_594240 != nil:
    section.add "name", valid_594240
  var valid_594241 = path.getOrDefault("subscriptionId")
  valid_594241 = validateParameter(valid_594241, JString, required = true,
                                 default = nil)
  if valid_594241 != nil:
    section.add "subscriptionId", valid_594241
  var valid_594242 = path.getOrDefault("labName")
  valid_594242 = validateParameter(valid_594242, JString, required = true,
                                 default = nil)
  if valid_594242 != nil:
    section.add "labName", valid_594242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594243 = query.getOrDefault("api-version")
  valid_594243 = validateParameter(valid_594243, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594243 != nil:
    section.add "api-version", valid_594243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594244: Call_FormulaGetResource_594236; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get formula.
  ## 
  let valid = call_594244.validator(path, query, header, formData, body)
  let scheme = call_594244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594244.url(scheme.get, call_594244.host, call_594244.base,
                         call_594244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594244, url, valid)

proc call*(call_594245: Call_FormulaGetResource_594236; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## formulaGetResource
  ## Get formula.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the formula.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594246 = newJObject()
  var query_594247 = newJObject()
  add(path_594246, "resourceGroupName", newJString(resourceGroupName))
  add(query_594247, "api-version", newJString(apiVersion))
  add(path_594246, "name", newJString(name))
  add(path_594246, "subscriptionId", newJString(subscriptionId))
  add(path_594246, "labName", newJString(labName))
  result = call_594245.call(path_594246, query_594247, nil, nil, nil)

var formulaGetResource* = Call_FormulaGetResource_594236(
    name: "formulaGetResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas/{name}",
    validator: validate_FormulaGetResource_594237, base: "",
    url: url_FormulaGetResource_594238, schemes: {Scheme.Https})
type
  Call_FormulaDeleteResource_594262 = ref object of OpenApiRestCall_593421
proc url_FormulaDeleteResource_594264(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/formulas/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FormulaDeleteResource_594263(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete formula.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the formula.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594265 = path.getOrDefault("resourceGroupName")
  valid_594265 = validateParameter(valid_594265, JString, required = true,
                                 default = nil)
  if valid_594265 != nil:
    section.add "resourceGroupName", valid_594265
  var valid_594266 = path.getOrDefault("name")
  valid_594266 = validateParameter(valid_594266, JString, required = true,
                                 default = nil)
  if valid_594266 != nil:
    section.add "name", valid_594266
  var valid_594267 = path.getOrDefault("subscriptionId")
  valid_594267 = validateParameter(valid_594267, JString, required = true,
                                 default = nil)
  if valid_594267 != nil:
    section.add "subscriptionId", valid_594267
  var valid_594268 = path.getOrDefault("labName")
  valid_594268 = validateParameter(valid_594268, JString, required = true,
                                 default = nil)
  if valid_594268 != nil:
    section.add "labName", valid_594268
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594269 = query.getOrDefault("api-version")
  valid_594269 = validateParameter(valid_594269, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594269 != nil:
    section.add "api-version", valid_594269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594270: Call_FormulaDeleteResource_594262; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete formula.
  ## 
  let valid = call_594270.validator(path, query, header, formData, body)
  let scheme = call_594270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594270.url(scheme.get, call_594270.host, call_594270.base,
                         call_594270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594270, url, valid)

proc call*(call_594271: Call_FormulaDeleteResource_594262;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## formulaDeleteResource
  ## Delete formula.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the formula.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594272 = newJObject()
  var query_594273 = newJObject()
  add(path_594272, "resourceGroupName", newJString(resourceGroupName))
  add(query_594273, "api-version", newJString(apiVersion))
  add(path_594272, "name", newJString(name))
  add(path_594272, "subscriptionId", newJString(subscriptionId))
  add(path_594272, "labName", newJString(labName))
  result = call_594271.call(path_594272, query_594273, nil, nil, nil)

var formulaDeleteResource* = Call_FormulaDeleteResource_594262(
    name: "formulaDeleteResource", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas/{name}",
    validator: validate_FormulaDeleteResource_594263, base: "",
    url: url_FormulaDeleteResource_594264, schemes: {Scheme.Https})
type
  Call_GalleryImageList_594274 = ref object of OpenApiRestCall_593421
proc url_GalleryImageList_594276(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/galleryimages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GalleryImageList_594275(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## List gallery images.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594277 = path.getOrDefault("resourceGroupName")
  valid_594277 = validateParameter(valid_594277, JString, required = true,
                                 default = nil)
  if valid_594277 != nil:
    section.add "resourceGroupName", valid_594277
  var valid_594278 = path.getOrDefault("subscriptionId")
  valid_594278 = validateParameter(valid_594278, JString, required = true,
                                 default = nil)
  if valid_594278 != nil:
    section.add "subscriptionId", valid_594278
  var valid_594279 = path.getOrDefault("labName")
  valid_594279 = validateParameter(valid_594279, JString, required = true,
                                 default = nil)
  if valid_594279 != nil:
    section.add "labName", valid_594279
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##   $orderBy: JString
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594280 = query.getOrDefault("api-version")
  valid_594280 = validateParameter(valid_594280, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594280 != nil:
    section.add "api-version", valid_594280
  var valid_594281 = query.getOrDefault("$top")
  valid_594281 = validateParameter(valid_594281, JInt, required = false, default = nil)
  if valid_594281 != nil:
    section.add "$top", valid_594281
  var valid_594282 = query.getOrDefault("$orderBy")
  valid_594282 = validateParameter(valid_594282, JString, required = false,
                                 default = nil)
  if valid_594282 != nil:
    section.add "$orderBy", valid_594282
  var valid_594283 = query.getOrDefault("$filter")
  valid_594283 = validateParameter(valid_594283, JString, required = false,
                                 default = nil)
  if valid_594283 != nil:
    section.add "$filter", valid_594283
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594284: Call_GalleryImageList_594274; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List gallery images.
  ## 
  let valid = call_594284.validator(path, query, header, formData, body)
  let scheme = call_594284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594284.url(scheme.get, call_594284.host, call_594284.base,
                         call_594284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594284, url, valid)

proc call*(call_594285: Call_GalleryImageList_594274; resourceGroupName: string;
          subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"; Top: int = 0; OrderBy: string = "";
          Filter: string = ""): Recallable =
  ## galleryImageList
  ## List gallery images.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##   OrderBy: string
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_594286 = newJObject()
  var query_594287 = newJObject()
  add(path_594286, "resourceGroupName", newJString(resourceGroupName))
  add(query_594287, "api-version", newJString(apiVersion))
  add(path_594286, "subscriptionId", newJString(subscriptionId))
  add(query_594287, "$top", newJInt(Top))
  add(query_594287, "$orderBy", newJString(OrderBy))
  add(path_594286, "labName", newJString(labName))
  add(query_594287, "$filter", newJString(Filter))
  result = call_594285.call(path_594286, query_594287, nil, nil, nil)

var galleryImageList* = Call_GalleryImageList_594274(name: "galleryImageList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/galleryimages",
    validator: validate_GalleryImageList_594275, base: "",
    url: url_GalleryImageList_594276, schemes: {Scheme.Https})
type
  Call_PolicySetEvaluatePolicies_594288 = ref object of OpenApiRestCall_593421
proc url_PolicySetEvaluatePolicies_594290(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/policysets/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/evaluatePolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicySetEvaluatePolicies_594289(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Evaluates Lab Policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the policy set.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594291 = path.getOrDefault("resourceGroupName")
  valid_594291 = validateParameter(valid_594291, JString, required = true,
                                 default = nil)
  if valid_594291 != nil:
    section.add "resourceGroupName", valid_594291
  var valid_594292 = path.getOrDefault("name")
  valid_594292 = validateParameter(valid_594292, JString, required = true,
                                 default = nil)
  if valid_594292 != nil:
    section.add "name", valid_594292
  var valid_594293 = path.getOrDefault("subscriptionId")
  valid_594293 = validateParameter(valid_594293, JString, required = true,
                                 default = nil)
  if valid_594293 != nil:
    section.add "subscriptionId", valid_594293
  var valid_594294 = path.getOrDefault("labName")
  valid_594294 = validateParameter(valid_594294, JString, required = true,
                                 default = nil)
  if valid_594294 != nil:
    section.add "labName", valid_594294
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594295 = query.getOrDefault("api-version")
  valid_594295 = validateParameter(valid_594295, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594295 != nil:
    section.add "api-version", valid_594295
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   evaluatePoliciesRequest: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594297: Call_PolicySetEvaluatePolicies_594288; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Evaluates Lab Policy.
  ## 
  let valid = call_594297.validator(path, query, header, formData, body)
  let scheme = call_594297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594297.url(scheme.get, call_594297.host, call_594297.base,
                         call_594297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594297, url, valid)

proc call*(call_594298: Call_PolicySetEvaluatePolicies_594288;
          resourceGroupName: string; name: string; subscriptionId: string;
          evaluatePoliciesRequest: JsonNode; labName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## policySetEvaluatePolicies
  ## Evaluates Lab Policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the policy set.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   evaluatePoliciesRequest: JObject (required)
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594299 = newJObject()
  var query_594300 = newJObject()
  var body_594301 = newJObject()
  add(path_594299, "resourceGroupName", newJString(resourceGroupName))
  add(query_594300, "api-version", newJString(apiVersion))
  add(path_594299, "name", newJString(name))
  add(path_594299, "subscriptionId", newJString(subscriptionId))
  if evaluatePoliciesRequest != nil:
    body_594301 = evaluatePoliciesRequest
  add(path_594299, "labName", newJString(labName))
  result = call_594298.call(path_594299, query_594300, nil, nil, body_594301)

var policySetEvaluatePolicies* = Call_PolicySetEvaluatePolicies_594288(
    name: "policySetEvaluatePolicies", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{name}/evaluatePolicies",
    validator: validate_PolicySetEvaluatePolicies_594289, base: "",
    url: url_PolicySetEvaluatePolicies_594290, schemes: {Scheme.Https})
type
  Call_PolicyList_594302 = ref object of OpenApiRestCall_593421
proc url_PolicyList_594304(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "policySetName" in path, "`policySetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/policysets/"),
               (kind: VariableSegment, value: "policySetName"),
               (kind: ConstantSegment, value: "/policies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyList_594303(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## List policies.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   policySetName: JString (required)
  ##                : The name of the policy set.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594305 = path.getOrDefault("resourceGroupName")
  valid_594305 = validateParameter(valid_594305, JString, required = true,
                                 default = nil)
  if valid_594305 != nil:
    section.add "resourceGroupName", valid_594305
  var valid_594306 = path.getOrDefault("subscriptionId")
  valid_594306 = validateParameter(valid_594306, JString, required = true,
                                 default = nil)
  if valid_594306 != nil:
    section.add "subscriptionId", valid_594306
  var valid_594307 = path.getOrDefault("policySetName")
  valid_594307 = validateParameter(valid_594307, JString, required = true,
                                 default = nil)
  if valid_594307 != nil:
    section.add "policySetName", valid_594307
  var valid_594308 = path.getOrDefault("labName")
  valid_594308 = validateParameter(valid_594308, JString, required = true,
                                 default = nil)
  if valid_594308 != nil:
    section.add "labName", valid_594308
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##   $orderBy: JString
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594309 = query.getOrDefault("api-version")
  valid_594309 = validateParameter(valid_594309, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594309 != nil:
    section.add "api-version", valid_594309
  var valid_594310 = query.getOrDefault("$top")
  valid_594310 = validateParameter(valid_594310, JInt, required = false, default = nil)
  if valid_594310 != nil:
    section.add "$top", valid_594310
  var valid_594311 = query.getOrDefault("$orderBy")
  valid_594311 = validateParameter(valid_594311, JString, required = false,
                                 default = nil)
  if valid_594311 != nil:
    section.add "$orderBy", valid_594311
  var valid_594312 = query.getOrDefault("$filter")
  valid_594312 = validateParameter(valid_594312, JString, required = false,
                                 default = nil)
  if valid_594312 != nil:
    section.add "$filter", valid_594312
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594313: Call_PolicyList_594302; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List policies.
  ## 
  let valid = call_594313.validator(path, query, header, formData, body)
  let scheme = call_594313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594313.url(scheme.get, call_594313.host, call_594313.base,
                         call_594313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594313, url, valid)

proc call*(call_594314: Call_PolicyList_594302; resourceGroupName: string;
          subscriptionId: string; policySetName: string; labName: string;
          apiVersion: string = "2015-05-21-preview"; Top: int = 0; OrderBy: string = "";
          Filter: string = ""): Recallable =
  ## policyList
  ## List policies.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##   OrderBy: string
  ##   policySetName: string (required)
  ##                : The name of the policy set.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_594315 = newJObject()
  var query_594316 = newJObject()
  add(path_594315, "resourceGroupName", newJString(resourceGroupName))
  add(query_594316, "api-version", newJString(apiVersion))
  add(path_594315, "subscriptionId", newJString(subscriptionId))
  add(query_594316, "$top", newJInt(Top))
  add(query_594316, "$orderBy", newJString(OrderBy))
  add(path_594315, "policySetName", newJString(policySetName))
  add(path_594315, "labName", newJString(labName))
  add(query_594316, "$filter", newJString(Filter))
  result = call_594314.call(path_594315, query_594316, nil, nil, nil)

var policyList* = Call_PolicyList_594302(name: "policyList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies",
                                      validator: validate_PolicyList_594303,
                                      base: "", url: url_PolicyList_594304,
                                      schemes: {Scheme.Https})
type
  Call_PolicyCreateOrUpdateResource_594330 = ref object of OpenApiRestCall_593421
proc url_PolicyCreateOrUpdateResource_594332(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "policySetName" in path, "`policySetName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/policysets/"),
               (kind: VariableSegment, value: "policySetName"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyCreateOrUpdateResource_594331(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the policy.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   policySetName: JString (required)
  ##                : The name of the policy set.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594333 = path.getOrDefault("resourceGroupName")
  valid_594333 = validateParameter(valid_594333, JString, required = true,
                                 default = nil)
  if valid_594333 != nil:
    section.add "resourceGroupName", valid_594333
  var valid_594334 = path.getOrDefault("name")
  valid_594334 = validateParameter(valid_594334, JString, required = true,
                                 default = nil)
  if valid_594334 != nil:
    section.add "name", valid_594334
  var valid_594335 = path.getOrDefault("subscriptionId")
  valid_594335 = validateParameter(valid_594335, JString, required = true,
                                 default = nil)
  if valid_594335 != nil:
    section.add "subscriptionId", valid_594335
  var valid_594336 = path.getOrDefault("policySetName")
  valid_594336 = validateParameter(valid_594336, JString, required = true,
                                 default = nil)
  if valid_594336 != nil:
    section.add "policySetName", valid_594336
  var valid_594337 = path.getOrDefault("labName")
  valid_594337 = validateParameter(valid_594337, JString, required = true,
                                 default = nil)
  if valid_594337 != nil:
    section.add "labName", valid_594337
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594338 = query.getOrDefault("api-version")
  valid_594338 = validateParameter(valid_594338, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594338 != nil:
    section.add "api-version", valid_594338
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   policy: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594340: Call_PolicyCreateOrUpdateResource_594330; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing policy.
  ## 
  let valid = call_594340.validator(path, query, header, formData, body)
  let scheme = call_594340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594340.url(scheme.get, call_594340.host, call_594340.base,
                         call_594340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594340, url, valid)

proc call*(call_594341: Call_PolicyCreateOrUpdateResource_594330;
          resourceGroupName: string; name: string; subscriptionId: string;
          policySetName: string; labName: string; policy: JsonNode;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## policyCreateOrUpdateResource
  ## Create or replace an existing policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the policy.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   policySetName: string (required)
  ##                : The name of the policy set.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   policy: JObject (required)
  var path_594342 = newJObject()
  var query_594343 = newJObject()
  var body_594344 = newJObject()
  add(path_594342, "resourceGroupName", newJString(resourceGroupName))
  add(query_594343, "api-version", newJString(apiVersion))
  add(path_594342, "name", newJString(name))
  add(path_594342, "subscriptionId", newJString(subscriptionId))
  add(path_594342, "policySetName", newJString(policySetName))
  add(path_594342, "labName", newJString(labName))
  if policy != nil:
    body_594344 = policy
  result = call_594341.call(path_594342, query_594343, nil, nil, body_594344)

var policyCreateOrUpdateResource* = Call_PolicyCreateOrUpdateResource_594330(
    name: "policyCreateOrUpdateResource", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies/{name}",
    validator: validate_PolicyCreateOrUpdateResource_594331, base: "",
    url: url_PolicyCreateOrUpdateResource_594332, schemes: {Scheme.Https})
type
  Call_PolicyGetResource_594317 = ref object of OpenApiRestCall_593421
proc url_PolicyGetResource_594319(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "policySetName" in path, "`policySetName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/policysets/"),
               (kind: VariableSegment, value: "policySetName"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyGetResource_594318(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the policy.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   policySetName: JString (required)
  ##                : The name of the policy set.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594320 = path.getOrDefault("resourceGroupName")
  valid_594320 = validateParameter(valid_594320, JString, required = true,
                                 default = nil)
  if valid_594320 != nil:
    section.add "resourceGroupName", valid_594320
  var valid_594321 = path.getOrDefault("name")
  valid_594321 = validateParameter(valid_594321, JString, required = true,
                                 default = nil)
  if valid_594321 != nil:
    section.add "name", valid_594321
  var valid_594322 = path.getOrDefault("subscriptionId")
  valid_594322 = validateParameter(valid_594322, JString, required = true,
                                 default = nil)
  if valid_594322 != nil:
    section.add "subscriptionId", valid_594322
  var valid_594323 = path.getOrDefault("policySetName")
  valid_594323 = validateParameter(valid_594323, JString, required = true,
                                 default = nil)
  if valid_594323 != nil:
    section.add "policySetName", valid_594323
  var valid_594324 = path.getOrDefault("labName")
  valid_594324 = validateParameter(valid_594324, JString, required = true,
                                 default = nil)
  if valid_594324 != nil:
    section.add "labName", valid_594324
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594325 = query.getOrDefault("api-version")
  valid_594325 = validateParameter(valid_594325, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594325 != nil:
    section.add "api-version", valid_594325
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594326: Call_PolicyGetResource_594317; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get policy.
  ## 
  let valid = call_594326.validator(path, query, header, formData, body)
  let scheme = call_594326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594326.url(scheme.get, call_594326.host, call_594326.base,
                         call_594326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594326, url, valid)

proc call*(call_594327: Call_PolicyGetResource_594317; resourceGroupName: string;
          name: string; subscriptionId: string; policySetName: string;
          labName: string; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## policyGetResource
  ## Get policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the policy.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   policySetName: string (required)
  ##                : The name of the policy set.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594328 = newJObject()
  var query_594329 = newJObject()
  add(path_594328, "resourceGroupName", newJString(resourceGroupName))
  add(query_594329, "api-version", newJString(apiVersion))
  add(path_594328, "name", newJString(name))
  add(path_594328, "subscriptionId", newJString(subscriptionId))
  add(path_594328, "policySetName", newJString(policySetName))
  add(path_594328, "labName", newJString(labName))
  result = call_594327.call(path_594328, query_594329, nil, nil, nil)

var policyGetResource* = Call_PolicyGetResource_594317(name: "policyGetResource",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies/{name}",
    validator: validate_PolicyGetResource_594318, base: "",
    url: url_PolicyGetResource_594319, schemes: {Scheme.Https})
type
  Call_PolicyPatchResource_594358 = ref object of OpenApiRestCall_593421
proc url_PolicyPatchResource_594360(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "policySetName" in path, "`policySetName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/policysets/"),
               (kind: VariableSegment, value: "policySetName"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyPatchResource_594359(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Modify properties of policies.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the policy.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   policySetName: JString (required)
  ##                : The name of the policy set.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594361 = path.getOrDefault("resourceGroupName")
  valid_594361 = validateParameter(valid_594361, JString, required = true,
                                 default = nil)
  if valid_594361 != nil:
    section.add "resourceGroupName", valid_594361
  var valid_594362 = path.getOrDefault("name")
  valid_594362 = validateParameter(valid_594362, JString, required = true,
                                 default = nil)
  if valid_594362 != nil:
    section.add "name", valid_594362
  var valid_594363 = path.getOrDefault("subscriptionId")
  valid_594363 = validateParameter(valid_594363, JString, required = true,
                                 default = nil)
  if valid_594363 != nil:
    section.add "subscriptionId", valid_594363
  var valid_594364 = path.getOrDefault("policySetName")
  valid_594364 = validateParameter(valid_594364, JString, required = true,
                                 default = nil)
  if valid_594364 != nil:
    section.add "policySetName", valid_594364
  var valid_594365 = path.getOrDefault("labName")
  valid_594365 = validateParameter(valid_594365, JString, required = true,
                                 default = nil)
  if valid_594365 != nil:
    section.add "labName", valid_594365
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594366 = query.getOrDefault("api-version")
  valid_594366 = validateParameter(valid_594366, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594366 != nil:
    section.add "api-version", valid_594366
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   policy: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594368: Call_PolicyPatchResource_594358; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of policies.
  ## 
  let valid = call_594368.validator(path, query, header, formData, body)
  let scheme = call_594368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594368.url(scheme.get, call_594368.host, call_594368.base,
                         call_594368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594368, url, valid)

proc call*(call_594369: Call_PolicyPatchResource_594358; resourceGroupName: string;
          name: string; subscriptionId: string; policySetName: string;
          labName: string; policy: JsonNode;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## policyPatchResource
  ## Modify properties of policies.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the policy.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   policySetName: string (required)
  ##                : The name of the policy set.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   policy: JObject (required)
  var path_594370 = newJObject()
  var query_594371 = newJObject()
  var body_594372 = newJObject()
  add(path_594370, "resourceGroupName", newJString(resourceGroupName))
  add(query_594371, "api-version", newJString(apiVersion))
  add(path_594370, "name", newJString(name))
  add(path_594370, "subscriptionId", newJString(subscriptionId))
  add(path_594370, "policySetName", newJString(policySetName))
  add(path_594370, "labName", newJString(labName))
  if policy != nil:
    body_594372 = policy
  result = call_594369.call(path_594370, query_594371, nil, nil, body_594372)

var policyPatchResource* = Call_PolicyPatchResource_594358(
    name: "policyPatchResource", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies/{name}",
    validator: validate_PolicyPatchResource_594359, base: "",
    url: url_PolicyPatchResource_594360, schemes: {Scheme.Https})
type
  Call_PolicyDeleteResource_594345 = ref object of OpenApiRestCall_593421
proc url_PolicyDeleteResource_594347(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "policySetName" in path, "`policySetName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/policysets/"),
               (kind: VariableSegment, value: "policySetName"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyDeleteResource_594346(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the policy.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   policySetName: JString (required)
  ##                : The name of the policy set.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594348 = path.getOrDefault("resourceGroupName")
  valid_594348 = validateParameter(valid_594348, JString, required = true,
                                 default = nil)
  if valid_594348 != nil:
    section.add "resourceGroupName", valid_594348
  var valid_594349 = path.getOrDefault("name")
  valid_594349 = validateParameter(valid_594349, JString, required = true,
                                 default = nil)
  if valid_594349 != nil:
    section.add "name", valid_594349
  var valid_594350 = path.getOrDefault("subscriptionId")
  valid_594350 = validateParameter(valid_594350, JString, required = true,
                                 default = nil)
  if valid_594350 != nil:
    section.add "subscriptionId", valid_594350
  var valid_594351 = path.getOrDefault("policySetName")
  valid_594351 = validateParameter(valid_594351, JString, required = true,
                                 default = nil)
  if valid_594351 != nil:
    section.add "policySetName", valid_594351
  var valid_594352 = path.getOrDefault("labName")
  valid_594352 = validateParameter(valid_594352, JString, required = true,
                                 default = nil)
  if valid_594352 != nil:
    section.add "labName", valid_594352
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594353 = query.getOrDefault("api-version")
  valid_594353 = validateParameter(valid_594353, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594353 != nil:
    section.add "api-version", valid_594353
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594354: Call_PolicyDeleteResource_594345; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete policy.
  ## 
  let valid = call_594354.validator(path, query, header, formData, body)
  let scheme = call_594354.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594354.url(scheme.get, call_594354.host, call_594354.base,
                         call_594354.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594354, url, valid)

proc call*(call_594355: Call_PolicyDeleteResource_594345;
          resourceGroupName: string; name: string; subscriptionId: string;
          policySetName: string; labName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## policyDeleteResource
  ## Delete policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the policy.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   policySetName: string (required)
  ##                : The name of the policy set.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594356 = newJObject()
  var query_594357 = newJObject()
  add(path_594356, "resourceGroupName", newJString(resourceGroupName))
  add(query_594357, "api-version", newJString(apiVersion))
  add(path_594356, "name", newJString(name))
  add(path_594356, "subscriptionId", newJString(subscriptionId))
  add(path_594356, "policySetName", newJString(policySetName))
  add(path_594356, "labName", newJString(labName))
  result = call_594355.call(path_594356, query_594357, nil, nil, nil)

var policyDeleteResource* = Call_PolicyDeleteResource_594345(
    name: "policyDeleteResource", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies/{name}",
    validator: validate_PolicyDeleteResource_594346, base: "",
    url: url_PolicyDeleteResource_594347, schemes: {Scheme.Https})
type
  Call_ScheduleList_594373 = ref object of OpenApiRestCall_593421
proc url_ScheduleList_594375(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/schedules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScheduleList_594374(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## List schedules.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594376 = path.getOrDefault("resourceGroupName")
  valid_594376 = validateParameter(valid_594376, JString, required = true,
                                 default = nil)
  if valid_594376 != nil:
    section.add "resourceGroupName", valid_594376
  var valid_594377 = path.getOrDefault("subscriptionId")
  valid_594377 = validateParameter(valid_594377, JString, required = true,
                                 default = nil)
  if valid_594377 != nil:
    section.add "subscriptionId", valid_594377
  var valid_594378 = path.getOrDefault("labName")
  valid_594378 = validateParameter(valid_594378, JString, required = true,
                                 default = nil)
  if valid_594378 != nil:
    section.add "labName", valid_594378
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##   $orderBy: JString
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594379 = query.getOrDefault("api-version")
  valid_594379 = validateParameter(valid_594379, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594379 != nil:
    section.add "api-version", valid_594379
  var valid_594380 = query.getOrDefault("$top")
  valid_594380 = validateParameter(valid_594380, JInt, required = false, default = nil)
  if valid_594380 != nil:
    section.add "$top", valid_594380
  var valid_594381 = query.getOrDefault("$orderBy")
  valid_594381 = validateParameter(valid_594381, JString, required = false,
                                 default = nil)
  if valid_594381 != nil:
    section.add "$orderBy", valid_594381
  var valid_594382 = query.getOrDefault("$filter")
  valid_594382 = validateParameter(valid_594382, JString, required = false,
                                 default = nil)
  if valid_594382 != nil:
    section.add "$filter", valid_594382
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594383: Call_ScheduleList_594373; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List schedules.
  ## 
  let valid = call_594383.validator(path, query, header, formData, body)
  let scheme = call_594383.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594383.url(scheme.get, call_594383.host, call_594383.base,
                         call_594383.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594383, url, valid)

proc call*(call_594384: Call_ScheduleList_594373; resourceGroupName: string;
          subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"; Top: int = 0; OrderBy: string = "";
          Filter: string = ""): Recallable =
  ## scheduleList
  ## List schedules.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##   OrderBy: string
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_594385 = newJObject()
  var query_594386 = newJObject()
  add(path_594385, "resourceGroupName", newJString(resourceGroupName))
  add(query_594386, "api-version", newJString(apiVersion))
  add(path_594385, "subscriptionId", newJString(subscriptionId))
  add(query_594386, "$top", newJInt(Top))
  add(query_594386, "$orderBy", newJString(OrderBy))
  add(path_594385, "labName", newJString(labName))
  add(query_594386, "$filter", newJString(Filter))
  result = call_594384.call(path_594385, query_594386, nil, nil, nil)

var scheduleList* = Call_ScheduleList_594373(name: "scheduleList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules",
    validator: validate_ScheduleList_594374, base: "", url: url_ScheduleList_594375,
    schemes: {Scheme.Https})
type
  Call_ScheduleCreateOrUpdateResource_594399 = ref object of OpenApiRestCall_593421
proc url_ScheduleCreateOrUpdateResource_594401(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScheduleCreateOrUpdateResource_594400(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing schedule. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594402 = path.getOrDefault("resourceGroupName")
  valid_594402 = validateParameter(valid_594402, JString, required = true,
                                 default = nil)
  if valid_594402 != nil:
    section.add "resourceGroupName", valid_594402
  var valid_594403 = path.getOrDefault("name")
  valid_594403 = validateParameter(valid_594403, JString, required = true,
                                 default = nil)
  if valid_594403 != nil:
    section.add "name", valid_594403
  var valid_594404 = path.getOrDefault("subscriptionId")
  valid_594404 = validateParameter(valid_594404, JString, required = true,
                                 default = nil)
  if valid_594404 != nil:
    section.add "subscriptionId", valid_594404
  var valid_594405 = path.getOrDefault("labName")
  valid_594405 = validateParameter(valid_594405, JString, required = true,
                                 default = nil)
  if valid_594405 != nil:
    section.add "labName", valid_594405
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594406 = query.getOrDefault("api-version")
  valid_594406 = validateParameter(valid_594406, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594406 != nil:
    section.add "api-version", valid_594406
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   schedule: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594408: Call_ScheduleCreateOrUpdateResource_594399; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing schedule. This operation can take a while to complete.
  ## 
  let valid = call_594408.validator(path, query, header, formData, body)
  let scheme = call_594408.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594408.url(scheme.get, call_594408.host, call_594408.base,
                         call_594408.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594408, url, valid)

proc call*(call_594409: Call_ScheduleCreateOrUpdateResource_594399;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; schedule: JsonNode;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## scheduleCreateOrUpdateResource
  ## Create or replace an existing schedule. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   schedule: JObject (required)
  var path_594410 = newJObject()
  var query_594411 = newJObject()
  var body_594412 = newJObject()
  add(path_594410, "resourceGroupName", newJString(resourceGroupName))
  add(query_594411, "api-version", newJString(apiVersion))
  add(path_594410, "name", newJString(name))
  add(path_594410, "subscriptionId", newJString(subscriptionId))
  add(path_594410, "labName", newJString(labName))
  if schedule != nil:
    body_594412 = schedule
  result = call_594409.call(path_594410, query_594411, nil, nil, body_594412)

var scheduleCreateOrUpdateResource* = Call_ScheduleCreateOrUpdateResource_594399(
    name: "scheduleCreateOrUpdateResource", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}",
    validator: validate_ScheduleCreateOrUpdateResource_594400, base: "",
    url: url_ScheduleCreateOrUpdateResource_594401, schemes: {Scheme.Https})
type
  Call_ScheduleGetResource_594387 = ref object of OpenApiRestCall_593421
proc url_ScheduleGetResource_594389(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScheduleGetResource_594388(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594390 = path.getOrDefault("resourceGroupName")
  valid_594390 = validateParameter(valid_594390, JString, required = true,
                                 default = nil)
  if valid_594390 != nil:
    section.add "resourceGroupName", valid_594390
  var valid_594391 = path.getOrDefault("name")
  valid_594391 = validateParameter(valid_594391, JString, required = true,
                                 default = nil)
  if valid_594391 != nil:
    section.add "name", valid_594391
  var valid_594392 = path.getOrDefault("subscriptionId")
  valid_594392 = validateParameter(valid_594392, JString, required = true,
                                 default = nil)
  if valid_594392 != nil:
    section.add "subscriptionId", valid_594392
  var valid_594393 = path.getOrDefault("labName")
  valid_594393 = validateParameter(valid_594393, JString, required = true,
                                 default = nil)
  if valid_594393 != nil:
    section.add "labName", valid_594393
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594394 = query.getOrDefault("api-version")
  valid_594394 = validateParameter(valid_594394, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594394 != nil:
    section.add "api-version", valid_594394
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594395: Call_ScheduleGetResource_594387; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get schedule.
  ## 
  let valid = call_594395.validator(path, query, header, formData, body)
  let scheme = call_594395.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594395.url(scheme.get, call_594395.host, call_594395.base,
                         call_594395.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594395, url, valid)

proc call*(call_594396: Call_ScheduleGetResource_594387; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## scheduleGetResource
  ## Get schedule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594397 = newJObject()
  var query_594398 = newJObject()
  add(path_594397, "resourceGroupName", newJString(resourceGroupName))
  add(query_594398, "api-version", newJString(apiVersion))
  add(path_594397, "name", newJString(name))
  add(path_594397, "subscriptionId", newJString(subscriptionId))
  add(path_594397, "labName", newJString(labName))
  result = call_594396.call(path_594397, query_594398, nil, nil, nil)

var scheduleGetResource* = Call_ScheduleGetResource_594387(
    name: "scheduleGetResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}",
    validator: validate_ScheduleGetResource_594388, base: "",
    url: url_ScheduleGetResource_594389, schemes: {Scheme.Https})
type
  Call_SchedulePatchResource_594425 = ref object of OpenApiRestCall_593421
proc url_SchedulePatchResource_594427(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SchedulePatchResource_594426(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of schedules.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594428 = path.getOrDefault("resourceGroupName")
  valid_594428 = validateParameter(valid_594428, JString, required = true,
                                 default = nil)
  if valid_594428 != nil:
    section.add "resourceGroupName", valid_594428
  var valid_594429 = path.getOrDefault("name")
  valid_594429 = validateParameter(valid_594429, JString, required = true,
                                 default = nil)
  if valid_594429 != nil:
    section.add "name", valid_594429
  var valid_594430 = path.getOrDefault("subscriptionId")
  valid_594430 = validateParameter(valid_594430, JString, required = true,
                                 default = nil)
  if valid_594430 != nil:
    section.add "subscriptionId", valid_594430
  var valid_594431 = path.getOrDefault("labName")
  valid_594431 = validateParameter(valid_594431, JString, required = true,
                                 default = nil)
  if valid_594431 != nil:
    section.add "labName", valid_594431
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594432 = query.getOrDefault("api-version")
  valid_594432 = validateParameter(valid_594432, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594432 != nil:
    section.add "api-version", valid_594432
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   schedule: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594434: Call_SchedulePatchResource_594425; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of schedules.
  ## 
  let valid = call_594434.validator(path, query, header, formData, body)
  let scheme = call_594434.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594434.url(scheme.get, call_594434.host, call_594434.base,
                         call_594434.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594434, url, valid)

proc call*(call_594435: Call_SchedulePatchResource_594425;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; schedule: JsonNode;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## schedulePatchResource
  ## Modify properties of schedules.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   schedule: JObject (required)
  var path_594436 = newJObject()
  var query_594437 = newJObject()
  var body_594438 = newJObject()
  add(path_594436, "resourceGroupName", newJString(resourceGroupName))
  add(query_594437, "api-version", newJString(apiVersion))
  add(path_594436, "name", newJString(name))
  add(path_594436, "subscriptionId", newJString(subscriptionId))
  add(path_594436, "labName", newJString(labName))
  if schedule != nil:
    body_594438 = schedule
  result = call_594435.call(path_594436, query_594437, nil, nil, body_594438)

var schedulePatchResource* = Call_SchedulePatchResource_594425(
    name: "schedulePatchResource", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}",
    validator: validate_SchedulePatchResource_594426, base: "",
    url: url_SchedulePatchResource_594427, schemes: {Scheme.Https})
type
  Call_ScheduleDeleteResource_594413 = ref object of OpenApiRestCall_593421
proc url_ScheduleDeleteResource_594415(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScheduleDeleteResource_594414(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete schedule. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594416 = path.getOrDefault("resourceGroupName")
  valid_594416 = validateParameter(valid_594416, JString, required = true,
                                 default = nil)
  if valid_594416 != nil:
    section.add "resourceGroupName", valid_594416
  var valid_594417 = path.getOrDefault("name")
  valid_594417 = validateParameter(valid_594417, JString, required = true,
                                 default = nil)
  if valid_594417 != nil:
    section.add "name", valid_594417
  var valid_594418 = path.getOrDefault("subscriptionId")
  valid_594418 = validateParameter(valid_594418, JString, required = true,
                                 default = nil)
  if valid_594418 != nil:
    section.add "subscriptionId", valid_594418
  var valid_594419 = path.getOrDefault("labName")
  valid_594419 = validateParameter(valid_594419, JString, required = true,
                                 default = nil)
  if valid_594419 != nil:
    section.add "labName", valid_594419
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594420 = query.getOrDefault("api-version")
  valid_594420 = validateParameter(valid_594420, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594420 != nil:
    section.add "api-version", valid_594420
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594421: Call_ScheduleDeleteResource_594413; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete schedule. This operation can take a while to complete.
  ## 
  let valid = call_594421.validator(path, query, header, formData, body)
  let scheme = call_594421.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594421.url(scheme.get, call_594421.host, call_594421.base,
                         call_594421.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594421, url, valid)

proc call*(call_594422: Call_ScheduleDeleteResource_594413;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## scheduleDeleteResource
  ## Delete schedule. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594423 = newJObject()
  var query_594424 = newJObject()
  add(path_594423, "resourceGroupName", newJString(resourceGroupName))
  add(query_594424, "api-version", newJString(apiVersion))
  add(path_594423, "name", newJString(name))
  add(path_594423, "subscriptionId", newJString(subscriptionId))
  add(path_594423, "labName", newJString(labName))
  result = call_594422.call(path_594423, query_594424, nil, nil, nil)

var scheduleDeleteResource* = Call_ScheduleDeleteResource_594413(
    name: "scheduleDeleteResource", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}",
    validator: validate_ScheduleDeleteResource_594414, base: "",
    url: url_ScheduleDeleteResource_594415, schemes: {Scheme.Https})
type
  Call_ScheduleExecute_594439 = ref object of OpenApiRestCall_593421
proc url_ScheduleExecute_594441(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/execute")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScheduleExecute_594440(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594442 = path.getOrDefault("resourceGroupName")
  valid_594442 = validateParameter(valid_594442, JString, required = true,
                                 default = nil)
  if valid_594442 != nil:
    section.add "resourceGroupName", valid_594442
  var valid_594443 = path.getOrDefault("name")
  valid_594443 = validateParameter(valid_594443, JString, required = true,
                                 default = nil)
  if valid_594443 != nil:
    section.add "name", valid_594443
  var valid_594444 = path.getOrDefault("subscriptionId")
  valid_594444 = validateParameter(valid_594444, JString, required = true,
                                 default = nil)
  if valid_594444 != nil:
    section.add "subscriptionId", valid_594444
  var valid_594445 = path.getOrDefault("labName")
  valid_594445 = validateParameter(valid_594445, JString, required = true,
                                 default = nil)
  if valid_594445 != nil:
    section.add "labName", valid_594445
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594446 = query.getOrDefault("api-version")
  valid_594446 = validateParameter(valid_594446, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594446 != nil:
    section.add "api-version", valid_594446
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594447: Call_ScheduleExecute_594439; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  let valid = call_594447.validator(path, query, header, formData, body)
  let scheme = call_594447.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594447.url(scheme.get, call_594447.host, call_594447.base,
                         call_594447.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594447, url, valid)

proc call*(call_594448: Call_ScheduleExecute_594439; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## scheduleExecute
  ## Execute a schedule. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594449 = newJObject()
  var query_594450 = newJObject()
  add(path_594449, "resourceGroupName", newJString(resourceGroupName))
  add(query_594450, "api-version", newJString(apiVersion))
  add(path_594449, "name", newJString(name))
  add(path_594449, "subscriptionId", newJString(subscriptionId))
  add(path_594449, "labName", newJString(labName))
  result = call_594448.call(path_594449, query_594450, nil, nil, nil)

var scheduleExecute* = Call_ScheduleExecute_594439(name: "scheduleExecute",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}/execute",
    validator: validate_ScheduleExecute_594440, base: "", url: url_ScheduleExecute_594441,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineList_594451 = ref object of OpenApiRestCall_593421
proc url_VirtualMachineList_594453(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineList_594452(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## List virtual machines.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594454 = path.getOrDefault("resourceGroupName")
  valid_594454 = validateParameter(valid_594454, JString, required = true,
                                 default = nil)
  if valid_594454 != nil:
    section.add "resourceGroupName", valid_594454
  var valid_594455 = path.getOrDefault("subscriptionId")
  valid_594455 = validateParameter(valid_594455, JString, required = true,
                                 default = nil)
  if valid_594455 != nil:
    section.add "subscriptionId", valid_594455
  var valid_594456 = path.getOrDefault("labName")
  valid_594456 = validateParameter(valid_594456, JString, required = true,
                                 default = nil)
  if valid_594456 != nil:
    section.add "labName", valid_594456
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##   $orderBy: JString
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594457 = query.getOrDefault("api-version")
  valid_594457 = validateParameter(valid_594457, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594457 != nil:
    section.add "api-version", valid_594457
  var valid_594458 = query.getOrDefault("$top")
  valid_594458 = validateParameter(valid_594458, JInt, required = false, default = nil)
  if valid_594458 != nil:
    section.add "$top", valid_594458
  var valid_594459 = query.getOrDefault("$orderBy")
  valid_594459 = validateParameter(valid_594459, JString, required = false,
                                 default = nil)
  if valid_594459 != nil:
    section.add "$orderBy", valid_594459
  var valid_594460 = query.getOrDefault("$filter")
  valid_594460 = validateParameter(valid_594460, JString, required = false,
                                 default = nil)
  if valid_594460 != nil:
    section.add "$filter", valid_594460
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594461: Call_VirtualMachineList_594451; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List virtual machines.
  ## 
  let valid = call_594461.validator(path, query, header, formData, body)
  let scheme = call_594461.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594461.url(scheme.get, call_594461.host, call_594461.base,
                         call_594461.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594461, url, valid)

proc call*(call_594462: Call_VirtualMachineList_594451; resourceGroupName: string;
          subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"; Top: int = 0; OrderBy: string = "";
          Filter: string = ""): Recallable =
  ## virtualMachineList
  ## List virtual machines.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##   OrderBy: string
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_594463 = newJObject()
  var query_594464 = newJObject()
  add(path_594463, "resourceGroupName", newJString(resourceGroupName))
  add(query_594464, "api-version", newJString(apiVersion))
  add(path_594463, "subscriptionId", newJString(subscriptionId))
  add(query_594464, "$top", newJInt(Top))
  add(query_594464, "$orderBy", newJString(OrderBy))
  add(path_594463, "labName", newJString(labName))
  add(query_594464, "$filter", newJString(Filter))
  result = call_594462.call(path_594463, query_594464, nil, nil, nil)

var virtualMachineList* = Call_VirtualMachineList_594451(
    name: "virtualMachineList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines",
    validator: validate_VirtualMachineList_594452, base: "",
    url: url_VirtualMachineList_594453, schemes: {Scheme.Https})
type
  Call_VirtualMachineCreateOrUpdateResource_594477 = ref object of OpenApiRestCall_593421
proc url_VirtualMachineCreateOrUpdateResource_594479(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineCreateOrUpdateResource_594478(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing Virtual Machine. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594480 = path.getOrDefault("resourceGroupName")
  valid_594480 = validateParameter(valid_594480, JString, required = true,
                                 default = nil)
  if valid_594480 != nil:
    section.add "resourceGroupName", valid_594480
  var valid_594481 = path.getOrDefault("name")
  valid_594481 = validateParameter(valid_594481, JString, required = true,
                                 default = nil)
  if valid_594481 != nil:
    section.add "name", valid_594481
  var valid_594482 = path.getOrDefault("subscriptionId")
  valid_594482 = validateParameter(valid_594482, JString, required = true,
                                 default = nil)
  if valid_594482 != nil:
    section.add "subscriptionId", valid_594482
  var valid_594483 = path.getOrDefault("labName")
  valid_594483 = validateParameter(valid_594483, JString, required = true,
                                 default = nil)
  if valid_594483 != nil:
    section.add "labName", valid_594483
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594484 = query.getOrDefault("api-version")
  valid_594484 = validateParameter(valid_594484, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594484 != nil:
    section.add "api-version", valid_594484
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   labVirtualMachine: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594486: Call_VirtualMachineCreateOrUpdateResource_594477;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or replace an existing Virtual Machine. This operation can take a while to complete.
  ## 
  let valid = call_594486.validator(path, query, header, formData, body)
  let scheme = call_594486.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594486.url(scheme.get, call_594486.host, call_594486.base,
                         call_594486.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594486, url, valid)

proc call*(call_594487: Call_VirtualMachineCreateOrUpdateResource_594477;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; labVirtualMachine: JsonNode;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## virtualMachineCreateOrUpdateResource
  ## Create or replace an existing Virtual Machine. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   labVirtualMachine: JObject (required)
  var path_594488 = newJObject()
  var query_594489 = newJObject()
  var body_594490 = newJObject()
  add(path_594488, "resourceGroupName", newJString(resourceGroupName))
  add(query_594489, "api-version", newJString(apiVersion))
  add(path_594488, "name", newJString(name))
  add(path_594488, "subscriptionId", newJString(subscriptionId))
  add(path_594488, "labName", newJString(labName))
  if labVirtualMachine != nil:
    body_594490 = labVirtualMachine
  result = call_594487.call(path_594488, query_594489, nil, nil, body_594490)

var virtualMachineCreateOrUpdateResource* = Call_VirtualMachineCreateOrUpdateResource_594477(
    name: "virtualMachineCreateOrUpdateResource", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}",
    validator: validate_VirtualMachineCreateOrUpdateResource_594478, base: "",
    url: url_VirtualMachineCreateOrUpdateResource_594479, schemes: {Scheme.Https})
type
  Call_VirtualMachineGetResource_594465 = ref object of OpenApiRestCall_593421
proc url_VirtualMachineGetResource_594467(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineGetResource_594466(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594468 = path.getOrDefault("resourceGroupName")
  valid_594468 = validateParameter(valid_594468, JString, required = true,
                                 default = nil)
  if valid_594468 != nil:
    section.add "resourceGroupName", valid_594468
  var valid_594469 = path.getOrDefault("name")
  valid_594469 = validateParameter(valid_594469, JString, required = true,
                                 default = nil)
  if valid_594469 != nil:
    section.add "name", valid_594469
  var valid_594470 = path.getOrDefault("subscriptionId")
  valid_594470 = validateParameter(valid_594470, JString, required = true,
                                 default = nil)
  if valid_594470 != nil:
    section.add "subscriptionId", valid_594470
  var valid_594471 = path.getOrDefault("labName")
  valid_594471 = validateParameter(valid_594471, JString, required = true,
                                 default = nil)
  if valid_594471 != nil:
    section.add "labName", valid_594471
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594472 = query.getOrDefault("api-version")
  valid_594472 = validateParameter(valid_594472, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594472 != nil:
    section.add "api-version", valid_594472
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594473: Call_VirtualMachineGetResource_594465; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get virtual machine.
  ## 
  let valid = call_594473.validator(path, query, header, formData, body)
  let scheme = call_594473.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594473.url(scheme.get, call_594473.host, call_594473.base,
                         call_594473.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594473, url, valid)

proc call*(call_594474: Call_VirtualMachineGetResource_594465;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## virtualMachineGetResource
  ## Get virtual machine.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594475 = newJObject()
  var query_594476 = newJObject()
  add(path_594475, "resourceGroupName", newJString(resourceGroupName))
  add(query_594476, "api-version", newJString(apiVersion))
  add(path_594475, "name", newJString(name))
  add(path_594475, "subscriptionId", newJString(subscriptionId))
  add(path_594475, "labName", newJString(labName))
  result = call_594474.call(path_594475, query_594476, nil, nil, nil)

var virtualMachineGetResource* = Call_VirtualMachineGetResource_594465(
    name: "virtualMachineGetResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}",
    validator: validate_VirtualMachineGetResource_594466, base: "",
    url: url_VirtualMachineGetResource_594467, schemes: {Scheme.Https})
type
  Call_VirtualMachinePatchResource_594503 = ref object of OpenApiRestCall_593421
proc url_VirtualMachinePatchResource_594505(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinePatchResource_594504(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of virtual machines.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594506 = path.getOrDefault("resourceGroupName")
  valid_594506 = validateParameter(valid_594506, JString, required = true,
                                 default = nil)
  if valid_594506 != nil:
    section.add "resourceGroupName", valid_594506
  var valid_594507 = path.getOrDefault("name")
  valid_594507 = validateParameter(valid_594507, JString, required = true,
                                 default = nil)
  if valid_594507 != nil:
    section.add "name", valid_594507
  var valid_594508 = path.getOrDefault("subscriptionId")
  valid_594508 = validateParameter(valid_594508, JString, required = true,
                                 default = nil)
  if valid_594508 != nil:
    section.add "subscriptionId", valid_594508
  var valid_594509 = path.getOrDefault("labName")
  valid_594509 = validateParameter(valid_594509, JString, required = true,
                                 default = nil)
  if valid_594509 != nil:
    section.add "labName", valid_594509
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594510 = query.getOrDefault("api-version")
  valid_594510 = validateParameter(valid_594510, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594510 != nil:
    section.add "api-version", valid_594510
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   labVirtualMachine: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594512: Call_VirtualMachinePatchResource_594503; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of virtual machines.
  ## 
  let valid = call_594512.validator(path, query, header, formData, body)
  let scheme = call_594512.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594512.url(scheme.get, call_594512.host, call_594512.base,
                         call_594512.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594512, url, valid)

proc call*(call_594513: Call_VirtualMachinePatchResource_594503;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; labVirtualMachine: JsonNode;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## virtualMachinePatchResource
  ## Modify properties of virtual machines.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   labVirtualMachine: JObject (required)
  var path_594514 = newJObject()
  var query_594515 = newJObject()
  var body_594516 = newJObject()
  add(path_594514, "resourceGroupName", newJString(resourceGroupName))
  add(query_594515, "api-version", newJString(apiVersion))
  add(path_594514, "name", newJString(name))
  add(path_594514, "subscriptionId", newJString(subscriptionId))
  add(path_594514, "labName", newJString(labName))
  if labVirtualMachine != nil:
    body_594516 = labVirtualMachine
  result = call_594513.call(path_594514, query_594515, nil, nil, body_594516)

var virtualMachinePatchResource* = Call_VirtualMachinePatchResource_594503(
    name: "virtualMachinePatchResource", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}",
    validator: validate_VirtualMachinePatchResource_594504, base: "",
    url: url_VirtualMachinePatchResource_594505, schemes: {Scheme.Https})
type
  Call_VirtualMachineDeleteResource_594491 = ref object of OpenApiRestCall_593421
proc url_VirtualMachineDeleteResource_594493(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineDeleteResource_594492(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete virtual machine. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594494 = path.getOrDefault("resourceGroupName")
  valid_594494 = validateParameter(valid_594494, JString, required = true,
                                 default = nil)
  if valid_594494 != nil:
    section.add "resourceGroupName", valid_594494
  var valid_594495 = path.getOrDefault("name")
  valid_594495 = validateParameter(valid_594495, JString, required = true,
                                 default = nil)
  if valid_594495 != nil:
    section.add "name", valid_594495
  var valid_594496 = path.getOrDefault("subscriptionId")
  valid_594496 = validateParameter(valid_594496, JString, required = true,
                                 default = nil)
  if valid_594496 != nil:
    section.add "subscriptionId", valid_594496
  var valid_594497 = path.getOrDefault("labName")
  valid_594497 = validateParameter(valid_594497, JString, required = true,
                                 default = nil)
  if valid_594497 != nil:
    section.add "labName", valid_594497
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594498 = query.getOrDefault("api-version")
  valid_594498 = validateParameter(valid_594498, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594498 != nil:
    section.add "api-version", valid_594498
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594499: Call_VirtualMachineDeleteResource_594491; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_594499.validator(path, query, header, formData, body)
  let scheme = call_594499.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594499.url(scheme.get, call_594499.host, call_594499.base,
                         call_594499.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594499, url, valid)

proc call*(call_594500: Call_VirtualMachineDeleteResource_594491;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## virtualMachineDeleteResource
  ## Delete virtual machine. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594501 = newJObject()
  var query_594502 = newJObject()
  add(path_594501, "resourceGroupName", newJString(resourceGroupName))
  add(query_594502, "api-version", newJString(apiVersion))
  add(path_594501, "name", newJString(name))
  add(path_594501, "subscriptionId", newJString(subscriptionId))
  add(path_594501, "labName", newJString(labName))
  result = call_594500.call(path_594501, query_594502, nil, nil, nil)

var virtualMachineDeleteResource* = Call_VirtualMachineDeleteResource_594491(
    name: "virtualMachineDeleteResource", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}",
    validator: validate_VirtualMachineDeleteResource_594492, base: "",
    url: url_VirtualMachineDeleteResource_594493, schemes: {Scheme.Https})
type
  Call_VirtualMachineApplyArtifacts_594517 = ref object of OpenApiRestCall_593421
proc url_VirtualMachineApplyArtifacts_594519(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/applyArtifacts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineApplyArtifacts_594518(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Apply artifacts to Lab VM. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594520 = path.getOrDefault("resourceGroupName")
  valid_594520 = validateParameter(valid_594520, JString, required = true,
                                 default = nil)
  if valid_594520 != nil:
    section.add "resourceGroupName", valid_594520
  var valid_594521 = path.getOrDefault("name")
  valid_594521 = validateParameter(valid_594521, JString, required = true,
                                 default = nil)
  if valid_594521 != nil:
    section.add "name", valid_594521
  var valid_594522 = path.getOrDefault("subscriptionId")
  valid_594522 = validateParameter(valid_594522, JString, required = true,
                                 default = nil)
  if valid_594522 != nil:
    section.add "subscriptionId", valid_594522
  var valid_594523 = path.getOrDefault("labName")
  valid_594523 = validateParameter(valid_594523, JString, required = true,
                                 default = nil)
  if valid_594523 != nil:
    section.add "labName", valid_594523
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594524 = query.getOrDefault("api-version")
  valid_594524 = validateParameter(valid_594524, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594524 != nil:
    section.add "api-version", valid_594524
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   applyArtifactsRequest: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594526: Call_VirtualMachineApplyArtifacts_594517; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Apply artifacts to Lab VM. This operation can take a while to complete.
  ## 
  let valid = call_594526.validator(path, query, header, formData, body)
  let scheme = call_594526.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594526.url(scheme.get, call_594526.host, call_594526.base,
                         call_594526.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594526, url, valid)

proc call*(call_594527: Call_VirtualMachineApplyArtifacts_594517;
          resourceGroupName: string; name: string; subscriptionId: string;
          applyArtifactsRequest: JsonNode; labName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## virtualMachineApplyArtifacts
  ## Apply artifacts to Lab VM. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   applyArtifactsRequest: JObject (required)
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594528 = newJObject()
  var query_594529 = newJObject()
  var body_594530 = newJObject()
  add(path_594528, "resourceGroupName", newJString(resourceGroupName))
  add(query_594529, "api-version", newJString(apiVersion))
  add(path_594528, "name", newJString(name))
  add(path_594528, "subscriptionId", newJString(subscriptionId))
  if applyArtifactsRequest != nil:
    body_594530 = applyArtifactsRequest
  add(path_594528, "labName", newJString(labName))
  result = call_594527.call(path_594528, query_594529, nil, nil, body_594530)

var virtualMachineApplyArtifacts* = Call_VirtualMachineApplyArtifacts_594517(
    name: "virtualMachineApplyArtifacts", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/applyArtifacts",
    validator: validate_VirtualMachineApplyArtifacts_594518, base: "",
    url: url_VirtualMachineApplyArtifacts_594519, schemes: {Scheme.Https})
type
  Call_VirtualMachineStart_594531 = ref object of OpenApiRestCall_593421
proc url_VirtualMachineStart_594533(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineStart_594532(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Start a Lab VM. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594534 = path.getOrDefault("resourceGroupName")
  valid_594534 = validateParameter(valid_594534, JString, required = true,
                                 default = nil)
  if valid_594534 != nil:
    section.add "resourceGroupName", valid_594534
  var valid_594535 = path.getOrDefault("name")
  valid_594535 = validateParameter(valid_594535, JString, required = true,
                                 default = nil)
  if valid_594535 != nil:
    section.add "name", valid_594535
  var valid_594536 = path.getOrDefault("subscriptionId")
  valid_594536 = validateParameter(valid_594536, JString, required = true,
                                 default = nil)
  if valid_594536 != nil:
    section.add "subscriptionId", valid_594536
  var valid_594537 = path.getOrDefault("labName")
  valid_594537 = validateParameter(valid_594537, JString, required = true,
                                 default = nil)
  if valid_594537 != nil:
    section.add "labName", valid_594537
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594538 = query.getOrDefault("api-version")
  valid_594538 = validateParameter(valid_594538, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594538 != nil:
    section.add "api-version", valid_594538
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594539: Call_VirtualMachineStart_594531; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Start a Lab VM. This operation can take a while to complete.
  ## 
  let valid = call_594539.validator(path, query, header, formData, body)
  let scheme = call_594539.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594539.url(scheme.get, call_594539.host, call_594539.base,
                         call_594539.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594539, url, valid)

proc call*(call_594540: Call_VirtualMachineStart_594531; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## virtualMachineStart
  ## Start a Lab VM. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594541 = newJObject()
  var query_594542 = newJObject()
  add(path_594541, "resourceGroupName", newJString(resourceGroupName))
  add(query_594542, "api-version", newJString(apiVersion))
  add(path_594541, "name", newJString(name))
  add(path_594541, "subscriptionId", newJString(subscriptionId))
  add(path_594541, "labName", newJString(labName))
  result = call_594540.call(path_594541, query_594542, nil, nil, nil)

var virtualMachineStart* = Call_VirtualMachineStart_594531(
    name: "virtualMachineStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/start",
    validator: validate_VirtualMachineStart_594532, base: "",
    url: url_VirtualMachineStart_594533, schemes: {Scheme.Https})
type
  Call_VirtualMachineStop_594543 = ref object of OpenApiRestCall_593421
proc url_VirtualMachineStop_594545(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineStop_594544(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Stop a Lab VM. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594546 = path.getOrDefault("resourceGroupName")
  valid_594546 = validateParameter(valid_594546, JString, required = true,
                                 default = nil)
  if valid_594546 != nil:
    section.add "resourceGroupName", valid_594546
  var valid_594547 = path.getOrDefault("name")
  valid_594547 = validateParameter(valid_594547, JString, required = true,
                                 default = nil)
  if valid_594547 != nil:
    section.add "name", valid_594547
  var valid_594548 = path.getOrDefault("subscriptionId")
  valid_594548 = validateParameter(valid_594548, JString, required = true,
                                 default = nil)
  if valid_594548 != nil:
    section.add "subscriptionId", valid_594548
  var valid_594549 = path.getOrDefault("labName")
  valid_594549 = validateParameter(valid_594549, JString, required = true,
                                 default = nil)
  if valid_594549 != nil:
    section.add "labName", valid_594549
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594550 = query.getOrDefault("api-version")
  valid_594550 = validateParameter(valid_594550, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594550 != nil:
    section.add "api-version", valid_594550
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594551: Call_VirtualMachineStop_594543; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop a Lab VM. This operation can take a while to complete.
  ## 
  let valid = call_594551.validator(path, query, header, formData, body)
  let scheme = call_594551.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594551.url(scheme.get, call_594551.host, call_594551.base,
                         call_594551.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594551, url, valid)

proc call*(call_594552: Call_VirtualMachineStop_594543; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## virtualMachineStop
  ## Stop a Lab VM. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual Machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594553 = newJObject()
  var query_594554 = newJObject()
  add(path_594553, "resourceGroupName", newJString(resourceGroupName))
  add(query_594554, "api-version", newJString(apiVersion))
  add(path_594553, "name", newJString(name))
  add(path_594553, "subscriptionId", newJString(subscriptionId))
  add(path_594553, "labName", newJString(labName))
  result = call_594552.call(path_594553, query_594554, nil, nil, nil)

var virtualMachineStop* = Call_VirtualMachineStop_594543(
    name: "virtualMachineStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/stop",
    validator: validate_VirtualMachineStop_594544, base: "",
    url: url_VirtualMachineStop_594545, schemes: {Scheme.Https})
type
  Call_VirtualNetworkList_594555 = ref object of OpenApiRestCall_593421
proc url_VirtualNetworkList_594557(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualnetworks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkList_594556(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## List virtual networks.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594558 = path.getOrDefault("resourceGroupName")
  valid_594558 = validateParameter(valid_594558, JString, required = true,
                                 default = nil)
  if valid_594558 != nil:
    section.add "resourceGroupName", valid_594558
  var valid_594559 = path.getOrDefault("subscriptionId")
  valid_594559 = validateParameter(valid_594559, JString, required = true,
                                 default = nil)
  if valid_594559 != nil:
    section.add "subscriptionId", valid_594559
  var valid_594560 = path.getOrDefault("labName")
  valid_594560 = validateParameter(valid_594560, JString, required = true,
                                 default = nil)
  if valid_594560 != nil:
    section.add "labName", valid_594560
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##   $orderBy: JString
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594561 = query.getOrDefault("api-version")
  valid_594561 = validateParameter(valid_594561, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594561 != nil:
    section.add "api-version", valid_594561
  var valid_594562 = query.getOrDefault("$top")
  valid_594562 = validateParameter(valid_594562, JInt, required = false, default = nil)
  if valid_594562 != nil:
    section.add "$top", valid_594562
  var valid_594563 = query.getOrDefault("$orderBy")
  valid_594563 = validateParameter(valid_594563, JString, required = false,
                                 default = nil)
  if valid_594563 != nil:
    section.add "$orderBy", valid_594563
  var valid_594564 = query.getOrDefault("$filter")
  valid_594564 = validateParameter(valid_594564, JString, required = false,
                                 default = nil)
  if valid_594564 != nil:
    section.add "$filter", valid_594564
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594565: Call_VirtualNetworkList_594555; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List virtual networks.
  ## 
  let valid = call_594565.validator(path, query, header, formData, body)
  let scheme = call_594565.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594565.url(scheme.get, call_594565.host, call_594565.base,
                         call_594565.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594565, url, valid)

proc call*(call_594566: Call_VirtualNetworkList_594555; resourceGroupName: string;
          subscriptionId: string; labName: string;
          apiVersion: string = "2015-05-21-preview"; Top: int = 0; OrderBy: string = "";
          Filter: string = ""): Recallable =
  ## virtualNetworkList
  ## List virtual networks.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##   OrderBy: string
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_594567 = newJObject()
  var query_594568 = newJObject()
  add(path_594567, "resourceGroupName", newJString(resourceGroupName))
  add(query_594568, "api-version", newJString(apiVersion))
  add(path_594567, "subscriptionId", newJString(subscriptionId))
  add(query_594568, "$top", newJInt(Top))
  add(query_594568, "$orderBy", newJString(OrderBy))
  add(path_594567, "labName", newJString(labName))
  add(query_594568, "$filter", newJString(Filter))
  result = call_594566.call(path_594567, query_594568, nil, nil, nil)

var virtualNetworkList* = Call_VirtualNetworkList_594555(
    name: "virtualNetworkList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks",
    validator: validate_VirtualNetworkList_594556, base: "",
    url: url_VirtualNetworkList_594557, schemes: {Scheme.Https})
type
  Call_VirtualNetworkCreateOrUpdateResource_594581 = ref object of OpenApiRestCall_593421
proc url_VirtualNetworkCreateOrUpdateResource_594583(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualnetworks/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkCreateOrUpdateResource_594582(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing virtual network. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594584 = path.getOrDefault("resourceGroupName")
  valid_594584 = validateParameter(valid_594584, JString, required = true,
                                 default = nil)
  if valid_594584 != nil:
    section.add "resourceGroupName", valid_594584
  var valid_594585 = path.getOrDefault("name")
  valid_594585 = validateParameter(valid_594585, JString, required = true,
                                 default = nil)
  if valid_594585 != nil:
    section.add "name", valid_594585
  var valid_594586 = path.getOrDefault("subscriptionId")
  valid_594586 = validateParameter(valid_594586, JString, required = true,
                                 default = nil)
  if valid_594586 != nil:
    section.add "subscriptionId", valid_594586
  var valid_594587 = path.getOrDefault("labName")
  valid_594587 = validateParameter(valid_594587, JString, required = true,
                                 default = nil)
  if valid_594587 != nil:
    section.add "labName", valid_594587
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594588 = query.getOrDefault("api-version")
  valid_594588 = validateParameter(valid_594588, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594588 != nil:
    section.add "api-version", valid_594588
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   virtualNetwork: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594590: Call_VirtualNetworkCreateOrUpdateResource_594581;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or replace an existing virtual network. This operation can take a while to complete.
  ## 
  let valid = call_594590.validator(path, query, header, formData, body)
  let scheme = call_594590.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594590.url(scheme.get, call_594590.host, call_594590.base,
                         call_594590.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594590, url, valid)

proc call*(call_594591: Call_VirtualNetworkCreateOrUpdateResource_594581;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; virtualNetwork: JsonNode;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## virtualNetworkCreateOrUpdateResource
  ## Create or replace an existing virtual network. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   virtualNetwork: JObject (required)
  var path_594592 = newJObject()
  var query_594593 = newJObject()
  var body_594594 = newJObject()
  add(path_594592, "resourceGroupName", newJString(resourceGroupName))
  add(query_594593, "api-version", newJString(apiVersion))
  add(path_594592, "name", newJString(name))
  add(path_594592, "subscriptionId", newJString(subscriptionId))
  add(path_594592, "labName", newJString(labName))
  if virtualNetwork != nil:
    body_594594 = virtualNetwork
  result = call_594591.call(path_594592, query_594593, nil, nil, body_594594)

var virtualNetworkCreateOrUpdateResource* = Call_VirtualNetworkCreateOrUpdateResource_594581(
    name: "virtualNetworkCreateOrUpdateResource", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks/{name}",
    validator: validate_VirtualNetworkCreateOrUpdateResource_594582, base: "",
    url: url_VirtualNetworkCreateOrUpdateResource_594583, schemes: {Scheme.Https})
type
  Call_VirtualNetworkGetResource_594569 = ref object of OpenApiRestCall_593421
proc url_VirtualNetworkGetResource_594571(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualnetworks/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkGetResource_594570(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get virtual network.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594572 = path.getOrDefault("resourceGroupName")
  valid_594572 = validateParameter(valid_594572, JString, required = true,
                                 default = nil)
  if valid_594572 != nil:
    section.add "resourceGroupName", valid_594572
  var valid_594573 = path.getOrDefault("name")
  valid_594573 = validateParameter(valid_594573, JString, required = true,
                                 default = nil)
  if valid_594573 != nil:
    section.add "name", valid_594573
  var valid_594574 = path.getOrDefault("subscriptionId")
  valid_594574 = validateParameter(valid_594574, JString, required = true,
                                 default = nil)
  if valid_594574 != nil:
    section.add "subscriptionId", valid_594574
  var valid_594575 = path.getOrDefault("labName")
  valid_594575 = validateParameter(valid_594575, JString, required = true,
                                 default = nil)
  if valid_594575 != nil:
    section.add "labName", valid_594575
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594576 = query.getOrDefault("api-version")
  valid_594576 = validateParameter(valid_594576, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594576 != nil:
    section.add "api-version", valid_594576
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594577: Call_VirtualNetworkGetResource_594569; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get virtual network.
  ## 
  let valid = call_594577.validator(path, query, header, formData, body)
  let scheme = call_594577.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594577.url(scheme.get, call_594577.host, call_594577.base,
                         call_594577.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594577, url, valid)

proc call*(call_594578: Call_VirtualNetworkGetResource_594569;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## virtualNetworkGetResource
  ## Get virtual network.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594579 = newJObject()
  var query_594580 = newJObject()
  add(path_594579, "resourceGroupName", newJString(resourceGroupName))
  add(query_594580, "api-version", newJString(apiVersion))
  add(path_594579, "name", newJString(name))
  add(path_594579, "subscriptionId", newJString(subscriptionId))
  add(path_594579, "labName", newJString(labName))
  result = call_594578.call(path_594579, query_594580, nil, nil, nil)

var virtualNetworkGetResource* = Call_VirtualNetworkGetResource_594569(
    name: "virtualNetworkGetResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks/{name}",
    validator: validate_VirtualNetworkGetResource_594570, base: "",
    url: url_VirtualNetworkGetResource_594571, schemes: {Scheme.Https})
type
  Call_VirtualNetworkPatchResource_594607 = ref object of OpenApiRestCall_593421
proc url_VirtualNetworkPatchResource_594609(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualnetworks/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkPatchResource_594608(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of virtual networks.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594610 = path.getOrDefault("resourceGroupName")
  valid_594610 = validateParameter(valid_594610, JString, required = true,
                                 default = nil)
  if valid_594610 != nil:
    section.add "resourceGroupName", valid_594610
  var valid_594611 = path.getOrDefault("name")
  valid_594611 = validateParameter(valid_594611, JString, required = true,
                                 default = nil)
  if valid_594611 != nil:
    section.add "name", valid_594611
  var valid_594612 = path.getOrDefault("subscriptionId")
  valid_594612 = validateParameter(valid_594612, JString, required = true,
                                 default = nil)
  if valid_594612 != nil:
    section.add "subscriptionId", valid_594612
  var valid_594613 = path.getOrDefault("labName")
  valid_594613 = validateParameter(valid_594613, JString, required = true,
                                 default = nil)
  if valid_594613 != nil:
    section.add "labName", valid_594613
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594614 = query.getOrDefault("api-version")
  valid_594614 = validateParameter(valid_594614, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594614 != nil:
    section.add "api-version", valid_594614
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   virtualNetwork: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594616: Call_VirtualNetworkPatchResource_594607; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of virtual networks.
  ## 
  let valid = call_594616.validator(path, query, header, formData, body)
  let scheme = call_594616.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594616.url(scheme.get, call_594616.host, call_594616.base,
                         call_594616.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594616, url, valid)

proc call*(call_594617: Call_VirtualNetworkPatchResource_594607;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; virtualNetwork: JsonNode;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## virtualNetworkPatchResource
  ## Modify properties of virtual networks.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   virtualNetwork: JObject (required)
  var path_594618 = newJObject()
  var query_594619 = newJObject()
  var body_594620 = newJObject()
  add(path_594618, "resourceGroupName", newJString(resourceGroupName))
  add(query_594619, "api-version", newJString(apiVersion))
  add(path_594618, "name", newJString(name))
  add(path_594618, "subscriptionId", newJString(subscriptionId))
  add(path_594618, "labName", newJString(labName))
  if virtualNetwork != nil:
    body_594620 = virtualNetwork
  result = call_594617.call(path_594618, query_594619, nil, nil, body_594620)

var virtualNetworkPatchResource* = Call_VirtualNetworkPatchResource_594607(
    name: "virtualNetworkPatchResource", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks/{name}",
    validator: validate_VirtualNetworkPatchResource_594608, base: "",
    url: url_VirtualNetworkPatchResource_594609, schemes: {Scheme.Https})
type
  Call_VirtualNetworkDeleteResource_594595 = ref object of OpenApiRestCall_593421
proc url_VirtualNetworkDeleteResource_594597(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualnetworks/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworkDeleteResource_594596(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete virtual network. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594598 = path.getOrDefault("resourceGroupName")
  valid_594598 = validateParameter(valid_594598, JString, required = true,
                                 default = nil)
  if valid_594598 != nil:
    section.add "resourceGroupName", valid_594598
  var valid_594599 = path.getOrDefault("name")
  valid_594599 = validateParameter(valid_594599, JString, required = true,
                                 default = nil)
  if valid_594599 != nil:
    section.add "name", valid_594599
  var valid_594600 = path.getOrDefault("subscriptionId")
  valid_594600 = validateParameter(valid_594600, JString, required = true,
                                 default = nil)
  if valid_594600 != nil:
    section.add "subscriptionId", valid_594600
  var valid_594601 = path.getOrDefault("labName")
  valid_594601 = validateParameter(valid_594601, JString, required = true,
                                 default = nil)
  if valid_594601 != nil:
    section.add "labName", valid_594601
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594602 = query.getOrDefault("api-version")
  valid_594602 = validateParameter(valid_594602, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594602 != nil:
    section.add "api-version", valid_594602
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594603: Call_VirtualNetworkDeleteResource_594595; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete virtual network. This operation can take a while to complete.
  ## 
  let valid = call_594603.validator(path, query, header, formData, body)
  let scheme = call_594603.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594603.url(scheme.get, call_594603.host, call_594603.base,
                         call_594603.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594603, url, valid)

proc call*(call_594604: Call_VirtualNetworkDeleteResource_594595;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## virtualNetworkDeleteResource
  ## Delete virtual network. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_594605 = newJObject()
  var query_594606 = newJObject()
  add(path_594605, "resourceGroupName", newJString(resourceGroupName))
  add(query_594606, "api-version", newJString(apiVersion))
  add(path_594605, "name", newJString(name))
  add(path_594605, "subscriptionId", newJString(subscriptionId))
  add(path_594605, "labName", newJString(labName))
  result = call_594604.call(path_594605, query_594606, nil, nil, nil)

var virtualNetworkDeleteResource* = Call_VirtualNetworkDeleteResource_594595(
    name: "virtualNetworkDeleteResource", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks/{name}",
    validator: validate_VirtualNetworkDeleteResource_594596, base: "",
    url: url_VirtualNetworkDeleteResource_594597, schemes: {Scheme.Https})
type
  Call_LabCreateOrUpdateResource_594632 = ref object of OpenApiRestCall_593421
proc url_LabCreateOrUpdateResource_594634(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabCreateOrUpdateResource_594633(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing Lab. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594635 = path.getOrDefault("resourceGroupName")
  valid_594635 = validateParameter(valid_594635, JString, required = true,
                                 default = nil)
  if valid_594635 != nil:
    section.add "resourceGroupName", valid_594635
  var valid_594636 = path.getOrDefault("name")
  valid_594636 = validateParameter(valid_594636, JString, required = true,
                                 default = nil)
  if valid_594636 != nil:
    section.add "name", valid_594636
  var valid_594637 = path.getOrDefault("subscriptionId")
  valid_594637 = validateParameter(valid_594637, JString, required = true,
                                 default = nil)
  if valid_594637 != nil:
    section.add "subscriptionId", valid_594637
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594638 = query.getOrDefault("api-version")
  valid_594638 = validateParameter(valid_594638, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594638 != nil:
    section.add "api-version", valid_594638
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   lab: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594640: Call_LabCreateOrUpdateResource_594632; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing Lab. This operation can take a while to complete.
  ## 
  let valid = call_594640.validator(path, query, header, formData, body)
  let scheme = call_594640.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594640.url(scheme.get, call_594640.host, call_594640.base,
                         call_594640.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594640, url, valid)

proc call*(call_594641: Call_LabCreateOrUpdateResource_594632;
          resourceGroupName: string; name: string; subscriptionId: string;
          lab: JsonNode; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## labCreateOrUpdateResource
  ## Create or replace an existing Lab. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   lab: JObject (required)
  var path_594642 = newJObject()
  var query_594643 = newJObject()
  var body_594644 = newJObject()
  add(path_594642, "resourceGroupName", newJString(resourceGroupName))
  add(query_594643, "api-version", newJString(apiVersion))
  add(path_594642, "name", newJString(name))
  add(path_594642, "subscriptionId", newJString(subscriptionId))
  if lab != nil:
    body_594644 = lab
  result = call_594641.call(path_594642, query_594643, nil, nil, body_594644)

var labCreateOrUpdateResource* = Call_LabCreateOrUpdateResource_594632(
    name: "labCreateOrUpdateResource", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}",
    validator: validate_LabCreateOrUpdateResource_594633, base: "",
    url: url_LabCreateOrUpdateResource_594634, schemes: {Scheme.Https})
type
  Call_LabGetResource_594621 = ref object of OpenApiRestCall_593421
proc url_LabGetResource_594623(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabGetResource_594622(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594624 = path.getOrDefault("resourceGroupName")
  valid_594624 = validateParameter(valid_594624, JString, required = true,
                                 default = nil)
  if valid_594624 != nil:
    section.add "resourceGroupName", valid_594624
  var valid_594625 = path.getOrDefault("name")
  valid_594625 = validateParameter(valid_594625, JString, required = true,
                                 default = nil)
  if valid_594625 != nil:
    section.add "name", valid_594625
  var valid_594626 = path.getOrDefault("subscriptionId")
  valid_594626 = validateParameter(valid_594626, JString, required = true,
                                 default = nil)
  if valid_594626 != nil:
    section.add "subscriptionId", valid_594626
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594627 = query.getOrDefault("api-version")
  valid_594627 = validateParameter(valid_594627, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594627 != nil:
    section.add "api-version", valid_594627
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594628: Call_LabGetResource_594621; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get lab.
  ## 
  let valid = call_594628.validator(path, query, header, formData, body)
  let scheme = call_594628.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594628.url(scheme.get, call_594628.host, call_594628.base,
                         call_594628.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594628, url, valid)

proc call*(call_594629: Call_LabGetResource_594621; resourceGroupName: string;
          name: string; subscriptionId: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## labGetResource
  ## Get lab.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_594630 = newJObject()
  var query_594631 = newJObject()
  add(path_594630, "resourceGroupName", newJString(resourceGroupName))
  add(query_594631, "api-version", newJString(apiVersion))
  add(path_594630, "name", newJString(name))
  add(path_594630, "subscriptionId", newJString(subscriptionId))
  result = call_594629.call(path_594630, query_594631, nil, nil, nil)

var labGetResource* = Call_LabGetResource_594621(name: "labGetResource",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}",
    validator: validate_LabGetResource_594622, base: "", url: url_LabGetResource_594623,
    schemes: {Scheme.Https})
type
  Call_LabPatchResource_594656 = ref object of OpenApiRestCall_593421
proc url_LabPatchResource_594658(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabPatchResource_594657(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Modify properties of labs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594659 = path.getOrDefault("resourceGroupName")
  valid_594659 = validateParameter(valid_594659, JString, required = true,
                                 default = nil)
  if valid_594659 != nil:
    section.add "resourceGroupName", valid_594659
  var valid_594660 = path.getOrDefault("name")
  valid_594660 = validateParameter(valid_594660, JString, required = true,
                                 default = nil)
  if valid_594660 != nil:
    section.add "name", valid_594660
  var valid_594661 = path.getOrDefault("subscriptionId")
  valid_594661 = validateParameter(valid_594661, JString, required = true,
                                 default = nil)
  if valid_594661 != nil:
    section.add "subscriptionId", valid_594661
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594662 = query.getOrDefault("api-version")
  valid_594662 = validateParameter(valid_594662, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594662 != nil:
    section.add "api-version", valid_594662
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   lab: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594664: Call_LabPatchResource_594656; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of labs.
  ## 
  let valid = call_594664.validator(path, query, header, formData, body)
  let scheme = call_594664.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594664.url(scheme.get, call_594664.host, call_594664.base,
                         call_594664.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594664, url, valid)

proc call*(call_594665: Call_LabPatchResource_594656; resourceGroupName: string;
          name: string; subscriptionId: string; lab: JsonNode;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## labPatchResource
  ## Modify properties of labs.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   lab: JObject (required)
  var path_594666 = newJObject()
  var query_594667 = newJObject()
  var body_594668 = newJObject()
  add(path_594666, "resourceGroupName", newJString(resourceGroupName))
  add(query_594667, "api-version", newJString(apiVersion))
  add(path_594666, "name", newJString(name))
  add(path_594666, "subscriptionId", newJString(subscriptionId))
  if lab != nil:
    body_594668 = lab
  result = call_594665.call(path_594666, query_594667, nil, nil, body_594668)

var labPatchResource* = Call_LabPatchResource_594656(name: "labPatchResource",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}",
    validator: validate_LabPatchResource_594657, base: "",
    url: url_LabPatchResource_594658, schemes: {Scheme.Https})
type
  Call_LabDeleteResource_594645 = ref object of OpenApiRestCall_593421
proc url_LabDeleteResource_594647(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabDeleteResource_594646(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Delete lab. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594648 = path.getOrDefault("resourceGroupName")
  valid_594648 = validateParameter(valid_594648, JString, required = true,
                                 default = nil)
  if valid_594648 != nil:
    section.add "resourceGroupName", valid_594648
  var valid_594649 = path.getOrDefault("name")
  valid_594649 = validateParameter(valid_594649, JString, required = true,
                                 default = nil)
  if valid_594649 != nil:
    section.add "name", valid_594649
  var valid_594650 = path.getOrDefault("subscriptionId")
  valid_594650 = validateParameter(valid_594650, JString, required = true,
                                 default = nil)
  if valid_594650 != nil:
    section.add "subscriptionId", valid_594650
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594651 = query.getOrDefault("api-version")
  valid_594651 = validateParameter(valid_594651, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594651 != nil:
    section.add "api-version", valid_594651
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594652: Call_LabDeleteResource_594645; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete lab. This operation can take a while to complete.
  ## 
  let valid = call_594652.validator(path, query, header, formData, body)
  let scheme = call_594652.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594652.url(scheme.get, call_594652.host, call_594652.base,
                         call_594652.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594652, url, valid)

proc call*(call_594653: Call_LabDeleteResource_594645; resourceGroupName: string;
          name: string; subscriptionId: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## labDeleteResource
  ## Delete lab. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_594654 = newJObject()
  var query_594655 = newJObject()
  add(path_594654, "resourceGroupName", newJString(resourceGroupName))
  add(query_594655, "api-version", newJString(apiVersion))
  add(path_594654, "name", newJString(name))
  add(path_594654, "subscriptionId", newJString(subscriptionId))
  result = call_594653.call(path_594654, query_594655, nil, nil, nil)

var labDeleteResource* = Call_LabDeleteResource_594645(name: "labDeleteResource",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}",
    validator: validate_LabDeleteResource_594646, base: "",
    url: url_LabDeleteResource_594647, schemes: {Scheme.Https})
type
  Call_LabCreateEnvironment_594669 = ref object of OpenApiRestCall_593421
proc url_LabCreateEnvironment_594671(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/createEnvironment")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabCreateEnvironment_594670(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create virtual machines in a Lab. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594672 = path.getOrDefault("resourceGroupName")
  valid_594672 = validateParameter(valid_594672, JString, required = true,
                                 default = nil)
  if valid_594672 != nil:
    section.add "resourceGroupName", valid_594672
  var valid_594673 = path.getOrDefault("name")
  valid_594673 = validateParameter(valid_594673, JString, required = true,
                                 default = nil)
  if valid_594673 != nil:
    section.add "name", valid_594673
  var valid_594674 = path.getOrDefault("subscriptionId")
  valid_594674 = validateParameter(valid_594674, JString, required = true,
                                 default = nil)
  if valid_594674 != nil:
    section.add "subscriptionId", valid_594674
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594675 = query.getOrDefault("api-version")
  valid_594675 = validateParameter(valid_594675, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594675 != nil:
    section.add "api-version", valid_594675
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   labVirtualMachine: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594677: Call_LabCreateEnvironment_594669; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create virtual machines in a Lab. This operation can take a while to complete.
  ## 
  let valid = call_594677.validator(path, query, header, formData, body)
  let scheme = call_594677.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594677.url(scheme.get, call_594677.host, call_594677.base,
                         call_594677.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594677, url, valid)

proc call*(call_594678: Call_LabCreateEnvironment_594669;
          resourceGroupName: string; name: string; subscriptionId: string;
          labVirtualMachine: JsonNode; apiVersion: string = "2015-05-21-preview"): Recallable =
  ## labCreateEnvironment
  ## Create virtual machines in a Lab. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labVirtualMachine: JObject (required)
  var path_594679 = newJObject()
  var query_594680 = newJObject()
  var body_594681 = newJObject()
  add(path_594679, "resourceGroupName", newJString(resourceGroupName))
  add(query_594680, "api-version", newJString(apiVersion))
  add(path_594679, "name", newJString(name))
  add(path_594679, "subscriptionId", newJString(subscriptionId))
  if labVirtualMachine != nil:
    body_594681 = labVirtualMachine
  result = call_594678.call(path_594679, query_594680, nil, nil, body_594681)

var labCreateEnvironment* = Call_LabCreateEnvironment_594669(
    name: "labCreateEnvironment", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/createEnvironment",
    validator: validate_LabCreateEnvironment_594670, base: "",
    url: url_LabCreateEnvironment_594671, schemes: {Scheme.Https})
type
  Call_LabGenerateUploadUri_594682 = ref object of OpenApiRestCall_593421
proc url_LabGenerateUploadUri_594684(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/generateUploadUri")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabGenerateUploadUri_594683(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generate a URI for uploading custom disk images to a Lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594685 = path.getOrDefault("resourceGroupName")
  valid_594685 = validateParameter(valid_594685, JString, required = true,
                                 default = nil)
  if valid_594685 != nil:
    section.add "resourceGroupName", valid_594685
  var valid_594686 = path.getOrDefault("name")
  valid_594686 = validateParameter(valid_594686, JString, required = true,
                                 default = nil)
  if valid_594686 != nil:
    section.add "name", valid_594686
  var valid_594687 = path.getOrDefault("subscriptionId")
  valid_594687 = validateParameter(valid_594687, JString, required = true,
                                 default = nil)
  if valid_594687 != nil:
    section.add "subscriptionId", valid_594687
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594688 = query.getOrDefault("api-version")
  valid_594688 = validateParameter(valid_594688, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594688 != nil:
    section.add "api-version", valid_594688
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   generateUploadUriParameter: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594690: Call_LabGenerateUploadUri_594682; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generate a URI for uploading custom disk images to a Lab.
  ## 
  let valid = call_594690.validator(path, query, header, formData, body)
  let scheme = call_594690.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594690.url(scheme.get, call_594690.host, call_594690.base,
                         call_594690.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594690, url, valid)

proc call*(call_594691: Call_LabGenerateUploadUri_594682;
          resourceGroupName: string; name: string; subscriptionId: string;
          generateUploadUriParameter: JsonNode;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## labGenerateUploadUri
  ## Generate a URI for uploading custom disk images to a Lab.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   generateUploadUriParameter: JObject (required)
  var path_594692 = newJObject()
  var query_594693 = newJObject()
  var body_594694 = newJObject()
  add(path_594692, "resourceGroupName", newJString(resourceGroupName))
  add(query_594693, "api-version", newJString(apiVersion))
  add(path_594692, "name", newJString(name))
  add(path_594692, "subscriptionId", newJString(subscriptionId))
  if generateUploadUriParameter != nil:
    body_594694 = generateUploadUriParameter
  result = call_594691.call(path_594692, query_594693, nil, nil, body_594694)

var labGenerateUploadUri* = Call_LabGenerateUploadUri_594682(
    name: "labGenerateUploadUri", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/generateUploadUri",
    validator: validate_LabGenerateUploadUri_594683, base: "",
    url: url_LabGenerateUploadUri_594684, schemes: {Scheme.Https})
type
  Call_LabListVhds_594695 = ref object of OpenApiRestCall_593421
proc url_LabListVhds_594697(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/listVhds")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabListVhds_594696(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## List disk images available for custom image creation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594698 = path.getOrDefault("resourceGroupName")
  valid_594698 = validateParameter(valid_594698, JString, required = true,
                                 default = nil)
  if valid_594698 != nil:
    section.add "resourceGroupName", valid_594698
  var valid_594699 = path.getOrDefault("name")
  valid_594699 = validateParameter(valid_594699, JString, required = true,
                                 default = nil)
  if valid_594699 != nil:
    section.add "name", valid_594699
  var valid_594700 = path.getOrDefault("subscriptionId")
  valid_594700 = validateParameter(valid_594700, JString, required = true,
                                 default = nil)
  if valid_594700 != nil:
    section.add "subscriptionId", valid_594700
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594701 = query.getOrDefault("api-version")
  valid_594701 = validateParameter(valid_594701, JString, required = true,
                                 default = newJString("2015-05-21-preview"))
  if valid_594701 != nil:
    section.add "api-version", valid_594701
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594702: Call_LabListVhds_594695; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List disk images available for custom image creation.
  ## 
  let valid = call_594702.validator(path, query, header, formData, body)
  let scheme = call_594702.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594702.url(scheme.get, call_594702.host, call_594702.base,
                         call_594702.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594702, url, valid)

proc call*(call_594703: Call_LabListVhds_594695; resourceGroupName: string;
          name: string; subscriptionId: string;
          apiVersion: string = "2015-05-21-preview"): Recallable =
  ## labListVhds
  ## List disk images available for custom image creation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_594704 = newJObject()
  var query_594705 = newJObject()
  add(path_594704, "resourceGroupName", newJString(resourceGroupName))
  add(query_594705, "api-version", newJString(apiVersion))
  add(path_594704, "name", newJString(name))
  add(path_594704, "subscriptionId", newJString(subscriptionId))
  result = call_594703.call(path_594704, query_594705, nil, nil, nil)

var labListVhds* = Call_LabListVhds_594695(name: "labListVhds",
                                        meth: HttpMethod.HttpPost,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/listVhds",
                                        validator: validate_LabListVhds_594696,
                                        base: "", url: url_LabListVhds_594697,
                                        schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
