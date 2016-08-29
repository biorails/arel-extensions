module ArelExtensions
  module Visitors
    Arel::Visitors::MSSQL.class_eval do

      # Math Functions
      def visit_ArelExtensions_Nodes_Ceil o, collector
        collector << "CEILING("
        collector = visit o.expr, collector
        collector << ")"
        collector
      end

      def visit_ArelExtensions_Nodes_Concat o, collector
        arg = o.left.relation.engine.columns.find{|c| c.name == o.left.name.to_s}.type
        if(o.right.is_a?(Arel::Attributes::Attribute))
          collector = visit o.left, collector
          collector << ' + '
          collector = visit o.right, collector
          collector
        elsif ( arg == :date || arg == :datetime)
          collector << "DATEADD(day,#{o.right},"
          collector = visit o.left, collector
          collector
        else
          collector = visit o.left, collector
          collector << " + '"
          collector << "#{o.right}'"
          collector
        end
      end

      def visit_ArelExtensions_Nodes_Coalesce o, collector
        collector << "COALESCE("
        if(o.left.is_a?(Arel::Attributes::Attribute))
          collector = visit o.left, collector
        else
          collector << "#{o.left}"
        end
           o.other.each { |a|
          collector << ","
          if(a.is_a?(Arel::Attributes::Attribute))
            collector = visit a, collector
          else
            collector << "#{a}"
          end
        }
        collector << ")"
        collector
      end

      def visit_ArelExtensions_Nodes_DateDiff o, collector

          collector << "DATEDIFF(day,"
          collector = visit o.left, collector
          collector<< ","
        if(o.right.is_a?(Arel::Attributes::Attribute))
          collector = visit o.right, collector
        else
          collector<< "'#{o.right}'"

        end
        collector << ")"
        collector
      end


      def visit_ArelExtensions_Nodes_Duration o, collector
        #visit left for period
        if(o.left == "d")
          collector << "DAY("
        elsif(o.left == "m")
          collector << "MONTH("
        elsif (o.left == "w")
          collector << "WEEK"
        elsif (o.left == "y")
          collector << "YEAR("
        end
        #visit right
        if(o.right.is_a?(Arel::Attributes::Attribute))
          collector = visit o.right, collector
        else
          collector << "'#{o.right}'"
        end
        collector << ")"
        collector
      end


     def visit_ArelExtensions_Nodes_Findis o,collector
     end


     def visit_ArelExtensions_Nodes_Length o, collector
       collector << "LEN("
       collector = visit o.expr, collector
       collector << ")"
       collector
     end


     def visit_ArelExtensions_Nodes_Locate o, collector
       collector << "CHARINDEX("
       if(o.val.is_a?(Arel::Attributes::Attribute))
         collector = visit o.val, collector
       else
         collector << "'#{o.val}'"
       end
       collector << ","
       collector = visit o.expr, collector
       collector << ")"
       collector
     end

      def visit_ArelExtensions_Nodes_Isnull o, collector
        collector << "ISNULL("
        collector = visit o.left, collector
        collector << ","
        if(o.right.is_a?(Arel::Attributes::Attribute))
        collector = visit o.right, collector
        else
        collector << "'#{o.right}'"
        end
        collector << ")"
        collector
      end

      def visit_ArelExtensions_Nodes_Replace o, collector
         collector << "REPLACE("
         collector = visit o.expr,collector
         collector << ","
         if(o.left.is_a?(Arel::Attributes::Attribute))
           collector = visit o.left, collector
         else
           collector << "'#{o.left}'"
         end
         collector << ","
         if(o.right.is_a?(Arel::Attributes::Attribute))
           collector = visit o.right, collector
         else
           collector << "'#{o.right}'"
         end
         collector << ")"
         collector
      end


      # SQL Server does not know about REGEXP
      def visit_Arel_Nodes_Regexp o, collector
        collector = visit o.left, collector
        collector << "LIKE '% #{o.right}%'"
        collector
      end

      def visit_Arel_Nodes_NotRegexp o, collector
        collector = visit o.left, collector
        collector << "NOT LIKE '% #{o.right}%'"
        collector
      end

      def visit_ArelExtensions_Nodes_Soundex o, collector
        collector << "SOUNDEX("
       if((o.expr).is_a?(Arel::Attributes::Attribute))
        collector = visit o.expr, collector
      else
          collector << "'#{o.expr}'"
       end
        collector << ")"
        collector
      end

      def visit_ArelExtensions_Nodes_Trim o , collector
          collector << "TRIM("
        collector = visit o.left, collector
        collector << ","
        if(o.right.is_a?(Arel::Attributes::Attribute))
          collector = visit o.right, collector
        else
          collector << "'#{o.right}'"
        end
        collector << ")"
        collector
      end

      def visit_ArelExtensions_Nodes_Ltrim o , collector
          collector << "LTRIM("
        collector = visit o.left, collector
        collector << ","
        if(o.right.is_a?(Arel::Attributes::Attribute))
          collector = visit o.right, collector
        else
          collector << "'#{o.right}'"
        end
        collector << ")"
        collector
      end


      def visit_ArelExtensions_Nodes_Rtrim o , collector
          collector << "RTRIM("
        collector = visit o.left, collector
        collector << ","
        if(o.right.is_a?(Arel::Attributes::Attribute))
          collector = visit o.right, collector
        else
          collector << "'#{o.right}'"
        end
        collector << ")"
        collector
      end

    end
  end
end